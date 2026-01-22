import 'dart:async';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../activity_model.dart';
import 'addreminder.dart';

class AddReminderView extends StatefulWidget {
  final String? selectedPetId;
  const AddReminderView({super.key, this.selectedPetId});

  @override
  State<AddReminderView> createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {
  final DateTime _selectedDate = DateTime.now();
  Timer? _cleanupTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderNotifier>().startReminderChecker(context);
      _startAutoRemoveCheck();
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }

  void _startAutoRemoveCheck() {
    _checkAndRemoveExpiredReminders();
    _cleanupTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRemoveExpiredReminders());
  }

  void _checkAndRemoveExpiredReminders() async {
    if (!mounted) return;

    final activityNotifier = context.read<ActivityNotifier>();
    final reminderNotifier = context.read<ReminderNotifier>();
    final now = DateTime.now();

    final expiredActivities = activityNotifier.activities.where(
          (a) =>
      a.hasReminder &&
          a.reminderDateTime != null &&
          a.reminderDateTime!.isBefore(now),
    );

    for (final activity in expiredActivities) {
      await _removeReminder(
        reminderNotifier: reminderNotifier,
        activityNotifier: activityNotifier,
        activity: activity,
        silent: true,
      );
    }
  }

  Future<void> _updateReminderTime(
      Activity activity,
      DateTime newTime,
      ReminderNotifier reminderNotifier,
      ActivityNotifier activityNotifier,
      ) async {
    // 1. Cancel old reminder
    if (activity.reminderId != null) {
      await reminderNotifier.cancelReminder(activity.reminderId!);
    }

    // 2. Schedule new reminder
    final newId = await reminderNotifier.scheduleReminder(
      activity: activity,
      reminderDateTime: newTime,
    );

    // 3. Update activity
    activityNotifier.updateActivity(
      activity.copyWith(
        hasReminder: true,
        reminderDateTime: newTime,
        reminderId: newId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderNotifier = context.watch<ReminderNotifier>();
    final activityNotifier = context.read<ActivityNotifier>();
    final now = DateTime.now();

    final reminders = reminderNotifier.reminders.where((r) {
      final scheduled = DateTime.parse(r['scheduledTime']);
      final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;

      return petMatch &&
          scheduled.year == _selectedDate.year &&
          scheduled.month == _selectedDate.month &&
          scheduled.day == _selectedDate.day &&
          scheduled.isAfter(now);
    }).toList()
      ..sort((a, b) => DateTime.parse(b['scheduledTime'])
          .compareTo(DateTime.parse(a['scheduledTime'])));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildReminderList(
              reminders,
              reminderNotifier,
              activityNotifier,
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _headerIcon('assets/images/61.png'),
              SizedBox(width: 8.w),
              _headerIcon('assets/images/62.png'),
              SizedBox(width: 8.w),
              _headerIcon('assets/images/63.png'),
            ],
          ),
          GestureDetector(
            onTap: _showAddReminderSheet,
            child: Text(
              'Add Reminder',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: _showAddReminderSheet,
            icon: SvgPicture.asset('assets/images/add.svg', width: 28.w),
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(String path) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(8.w),
      child: Image.asset(path),
    );
  }

  // ================= REMINDER LIST =================

  Widget _buildReminderList(
      List<Map<String, dynamic>> reminders,
      ReminderNotifier reminderNotifier,
      ActivityNotifier activityNotifier,
      ) {
    final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);

    if (reminders.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/images136.png', width: 120.w),
          SizedBox(height: 20.h),
          Text('No Reminders', style: TextStyle(fontSize: 20.sp)),
          SizedBox(height: 6.h),
          Text(formattedDate, style: const TextStyle(color: Colors.grey)),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.only(top: 12.h),
      children: reminders.map(
            (r) => _buildReminderCard(
          r,
          reminderNotifier,
          activityNotifier,
        ),
      ).toList(),
    );
  }

  Widget _buildReminderCard(
      Map<String, dynamic> reminder,
      ReminderNotifier reminderNotifier,
      ActivityNotifier activityNotifier,
      ) {
    final scheduledTime = DateTime.parse(reminder['scheduledTime']);
    final title = reminder['activityName'] ?? 'Reminder';
    final imagePath = reminder['imagePath'];
    final colorValue = reminder['color'];
    final color = colorValue != null ? Color(colorValue) : Colors.orange;
    final reminderId = reminder['id'];

    Activity? activity;
    try {
      activity = activityNotifier.activities.firstWhere(
            (a) => a.reminderId == reminderId,
      );
    } catch (_) {
      // Fallback: Try to find by name and time if ID mismatch
      try {
        activity = activityNotifier.activities.firstWhere(
              (a) => a.name == title &&
              a.reminderDateTime != null &&
              a.reminderDateTime!.isAtSameMomentAs(scheduledTime),
        );
      } catch (_) {}
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        color: const Color(0xFFF4F7F6),
        child: InkWell(
          // onTap: activity != null
          //     ? () async {
          //   final TimeOfDay? picked = await showTimePicker(
          //     context: context,
          //     initialTime: TimeOfDay.fromDateTime(scheduledTime),
          //   );
          //   if (picked != null) {
          //     final newDateTime = DateTime(
          //       _selectedDate.year,
          //       _selectedDate.month,
          //       _selectedDate.day,
          //       picked.hour,
          //       picked.minute,
          //     );
          //
          //     try {
          //       await _updateReminderTime(
          //         activity!,
          //         newDateTime,
          //         reminderNotifier,
          //         activityNotifier,
          //       );
          //     } catch (e) {
          //       if (context.mounted) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Failed to update: $e')),
          //         );
          //       }
          //     }
          //   }
          // }
          //     : null,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: imagePath != null
                          ? Image.asset(
                        imagePath,
                        width: 35.w,
                        height: 35.h,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.pets, color: color, size: 24.w),
                      )
                          : Icon(Icons.notifications_active,
                          color: color, size: 24.w),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('EEE MMM d').format(scheduledTime),
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showReminderDetailsSheet(
                              context,
                              reminder,
                              activity,
                              reminderNotifier,
                              activityNotifier,
                            );
                          },
                          child:  Icon(
                            Icons.notifications,
                            size: 22.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat('hh:mm a').format(scheduledTime),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReminderDetailsSheet(
      BuildContext context,
      Map<String, dynamic> reminder,
      Activity? activity,
      ReminderNotifier reminderNotifier,
      ActivityNotifier activityNotifier,
      ) {
    final initialScheduledTime = DateTime.parse(reminder['scheduledTime']);
    DateTime tempScheduledTime = initialScheduledTime;

    final title = reminder['activityName'] ?? 'Reminder';
    final imagePath = reminder['imagePath'];
    final colorValue = reminder['color'];
    final color = colorValue != null ? Color(colorValue) : Colors.orange;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (builderContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image and Name
                  Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(12.w),
                        child: imagePath != null
                            ? Image.asset(imagePath)
                            : Icon(Icons.notifications, color: color),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        title,
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Date Row (Clickable)
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: builderContext,
                        initialDate: tempScheduledTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.vibrantPurple, // Header color
                                onPrimary: Colors.white, // Header text color
                                surface: Colors.white, // Background color
                                onSurface: Colors.black, // Text color
                              ),
                              dialogBackgroundColor: Colors.white, // Background color
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setSheetState(() {
                          tempScheduledTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            tempScheduledTime.hour,
                            tempScheduledTime.minute,
                          );
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('EEE, MMM d, yyyy').format(tempScheduledTime),
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: builderContext,
                        initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.vibrantPurple,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                                secondary: AppColors.vibrantPurple,
                                onSecondary: Colors.white,

                              ),
                              dialogBackgroundColor: Colors.white, // Background color
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        setSheetState(() {
                          tempScheduledTime = DateTime(
                            tempScheduledTime.year,
                            tempScheduledTime.month,
                            tempScheduledTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: AppColors.vibrantPurple),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('hh:mm a').format(tempScheduledTime),
                            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(builderContext);
                            if (activity != null) {
                              try {
                                await _updateReminderTime(
                                  activity,
                                  tempScheduledTime,
                                  reminderNotifier,
                                  activityNotifier,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cannot update: Activity not found')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: const Text('Update', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(builderContext);
                            await _removeReminder(
                              reminderNotifier: reminderNotifier,
                              activityNotifier: activityNotifier,
                              activity: activity,
                              reminderId: reminder['id'],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: const Text('Remove', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // void _showReminderDetailsSheet(
  //     BuildContext context,
  //     Map<String, dynamic> reminder,
  //     Activity? activity,
  //     ReminderNotifier reminderNotifier,
  //     ActivityNotifier activityNotifier,
  //     ) {
  //   final initialScheduledTime = DateTime.parse(reminder['scheduledTime']);
  //   // Mutable variable for the sheet
  //   DateTime tempScheduledTime = initialScheduledTime;
  //
  //   final title = reminder['activityName'] ?? 'Reminder';
  //   final imagePath = reminder['imagePath'];
  //   final colorValue = reminder['color'];
  //   final color = colorValue != null ? Color(colorValue) : Colors.orange;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     builder: (builderContext) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setSheetState) {
  //           return Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //             ),
  //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Image and Name
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: 60.w,
  //                       height: 60.h,
  //                       decoration: BoxDecoration(
  //                         color: color.withOpacity(0.2),
  //                         shape: BoxShape.circle,
  //                       ),
  //                       padding: EdgeInsets.all(12.w),
  //                       child: imagePath != null
  //                           ? Image.asset(imagePath)
  //                           : Icon(Icons.notifications, color: color),
  //                     ),
  //                     SizedBox(width: 16.w),
  //                     Text(
  //                       title,
  //                       style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20.h),
  //
  //                 // Date Row (Clickable)
  //                 InkWell(
  //                   onTap: () async {
  //                     final DateTime? pickedDate = await showDatePicker(
  //                       context: builderContext,
  //                       initialDate: tempScheduledTime,
  //                       firstDate: DateTime.now().subtract(const Duration(days: 365)),
  //                       lastDate: DateTime.now().add(const Duration(days: 365)),
  //                     );
  //                     if (pickedDate != null) {
  //                       setSheetState(() {
  //                         tempScheduledTime = DateTime(
  //                           pickedDate.year,
  //                           pickedDate.month,
  //                           pickedDate.day,
  //                           tempScheduledTime.hour,
  //                           tempScheduledTime.minute,
  //                         );
  //                       });
  //                     }
  //                   },
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 8.h),
  //                     child: Row(
  //                       children: [
  //                         const Icon(Icons.calendar_today, color: Colors.blue),
  //                         SizedBox(width: 8.w),
  //                         Text(
  //                           DateFormat('EEE, MMM d, yyyy').format(tempScheduledTime),
  //                           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
  //                         ),
  //                         const Spacer(),
  //                         const Icon(Icons.edit, size: 16, color: Colors.grey),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //                 SizedBox(height: 10.h),
  //                 InkWell(
  //                   onTap: () async {
  //                     final TimeOfDay? pickedTime = await showTimePicker(
  //                       context: builderContext,
  //                       initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
  //                     );
  //                     if (pickedTime != null) {
  //                       setSheetState(() {
  //                         tempScheduledTime = DateTime(
  //                           tempScheduledTime.year,
  //                           tempScheduledTime.month,
  //                           tempScheduledTime.day,
  //                           pickedTime.hour,
  //                           pickedTime.minute,
  //                         );
  //                       });
  //                     }
  //                   },
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 8.h),
  //                     child: Row(
  //                       children: [
  //                         const Icon(Icons.access_time, color: Colors.blue),
  //                         SizedBox(width: 8.w),
  //                         Text(
  //                           DateFormat('hh:mm a').format(tempScheduledTime),
  //                           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
  //                         ),
  //                         const Spacer(),
  //                         const Icon(Icons.edit, size: 16, color: Colors.grey),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //                 SizedBox(height: 30.h),
  //
  //                 // Buttons
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: () async {
  //                           Navigator.pop(builderContext);
  //                           if (activity != null) {
  //                             try {
  //                               await _updateReminderTime(
  //                                 activity,
  //                                 tempScheduledTime,
  //                                 reminderNotifier,
  //                                 activityNotifier,
  //                               );
  //                             } catch (e) {
  //                               // Show error if update fails
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 SnackBar(content: Text('Failed to update: $e')),
  //                               );
  //                             }
  //                           } else {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(content: Text('Cannot update: Activity not found')),
  //                             );
  //                           }
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.blue,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.r)),
  //                         ),
  //                         child: const Text('Update', style: TextStyle(color: Colors.white)),
  //                       ),
  //                     ),
  //                     SizedBox(width: 16.w),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: () async {
  //                           Navigator.pop(builderContext);
  //                           await _removeReminder(
  //                             reminderNotifier: reminderNotifier,
  //                             activityNotifier: activityNotifier,
  //                             activity: activity,
  //                             reminderId: reminder['id'], // Use 'id' from reminder map
  //                           );
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.red,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.r)),
  //                         ),
  //                         child: const Text('Remove', style: TextStyle(color: Colors.white)),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20.h),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // ================= ADD REMINDER =================

  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Addreminder(
          initialDate: _selectedDate,
          selectedPetId: widget.selectedPetId,
        ),
      ),
    );
  }

  // ================= REMOVE REMINDER =================

  Future<void> _removeReminder({
    required ReminderNotifier reminderNotifier,
    required ActivityNotifier activityNotifier,
    Activity? activity,
    String? reminderId,
    bool silent = false,
  }) async {
    final idToCancel = reminderId ?? activity?.reminderId;
    if (idToCancel != null) {
      await reminderNotifier.cancelReminder(idToCancel);
    }

    if (activity != null) {
      activityNotifier.updateActivity(
        activity.copyWith(
          hasReminder: false,
          reminderDateTime: null,
          reminderId: null,
        ),
      );
    }
  }


}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'addreminder.dart';
//
// class AddReminderView extends StatefulWidget {
//   final String? selectedPetId;
//   const AddReminderView({super.key, this.selectedPetId});
//
//   @override
//   State<AddReminderView> createState() => _AddReminderViewState();
// }
//
// class _AddReminderViewState extends State<AddReminderView> {
//   final DateTime _selectedDate = DateTime.now();
//   Timer? _cleanupTimer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReminderNotifier>().startReminderChecker(context);
//       _startAutoRemoveCheck();
//     });
//   }
//
//   @override
//   void dispose() {
//     _cleanupTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startAutoRemoveCheck() {
//     _checkAndRemoveExpiredReminders();
//     _cleanupTimer =
//         Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRemoveExpiredReminders());
//   }
//
//   void _checkAndRemoveExpiredReminders() async {
//     if (!mounted) return;
//
//     final activityNotifier = context.read<ActivityNotifier>();
//     final reminderNotifier = context.read<ReminderNotifier>();
//     final now = DateTime.now();
//
//     final expiredActivities = activityNotifier.activities.where(
//           (a) =>
//       a.hasReminder &&
//           a.reminderDateTime != null &&
//           a.reminderDateTime!.isBefore(now),
//     );
//
//     for (final activity in expiredActivities) {
//       await _removeReminder(
//         reminderNotifier: reminderNotifier,
//         activityNotifier: activityNotifier,
//         activity: activity,
//         silent: true,
//       );
//     }
//   }
//
//   Future<void> _updateReminderTime(
//       Activity activity,
//       DateTime newTime,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) async {
//     // 1. Cancel old reminder
//     if (activity.reminderId != null) {
//       await reminderNotifier.cancelReminder(activity.reminderId!);
//     }
//
//     // 2. Schedule new reminder
//     final newId = await reminderNotifier.scheduleReminder(
//       activity: activity,
//       reminderDateTime: newTime,
//     );
//
//     // 3. Update activity
//     activityNotifier.updateActivity(
//       activity.copyWith(
//         hasReminder: true,
//         reminderDateTime: newTime,
//         reminderId: newId,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reminderNotifier = context.watch<ReminderNotifier>();
//     final activityNotifier = context.read<ActivityNotifier>();
//     final now = DateTime.now();
//
//     final reminders = reminderNotifier.reminders.where((r) {
//       final scheduled = DateTime.parse(r['scheduledTime']);
//       final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;
//
//       return petMatch &&
//           scheduled.year == _selectedDate.year &&
//           scheduled.month == _selectedDate.month &&
//           scheduled.day == _selectedDate.day &&
//           scheduled.isAfter(now);
//     }).toList()
//       ..sort((a, b) => DateTime.parse(b['scheduledTime'])
//           .compareTo(DateTime.parse(a['scheduledTime'])));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: _buildReminderList(
//               reminders,
//               reminderNotifier,
//               activityNotifier,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= HEADER =================
//
//   Widget _buildHeader() {
//     return Container(
//       height: 70.h,
//       margin: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _headerIcon('assets/images/61.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/62.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/63.png'),
//             ],
//           ),
//           GestureDetector(
//             onTap: _showAddReminderSheet,
//             child: Text(
//               'Add Reminder',
//               style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
//             ),
//           ),
//           IconButton(
//             onPressed: _showAddReminderSheet,
//             icon: SvgPicture.asset('assets/images/add.svg', width: 28.w),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _headerIcon(String path) {
//     return Container(
//       width: 40.w,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       padding: EdgeInsets.all(8.w),
//       child: Image.asset(path),
//     );
//   }
//
//   // ================= REMINDER LIST =================
//
//   Widget _buildReminderList(
//       List<Map<String, dynamic>> reminders,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     if (reminders.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/images136.png', width: 120.w),
//           SizedBox(height: 20.h),
//           Text('No Reminders', style: TextStyle(fontSize: 20.sp)),
//           SizedBox(height: 6.h),
//           Text(formattedDate, style: const TextStyle(color: Colors.grey)),
//         ],
//       );
//     }
//
//     return ListView(
//       padding: EdgeInsets.only(top: 12.h),
//       children: reminders.map(
//             (r) => _buildReminderCard(
//           r,
//           reminderNotifier,
//           activityNotifier,
//         ),
//       ).toList(),
//     );
//   }
//
//   Widget _buildReminderCard(
//       Map<String, dynamic> reminder,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final scheduledTime = DateTime.parse(reminder['scheduledTime']);
//     final title = reminder['activityName'] ?? 'Reminder';
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//     final reminderId = reminder['reminderId'];
//
//     Activity? activity;
//     try {
//       activity = activityNotifier.activities.firstWhere(
//             (a) => a.reminderId == reminderId,
//       );
//     } catch (_) {}
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         color: const Color(0xFFF4F7F6),
//         child: InkWell(
//           onTap: activity != null
//               ? () async {
//             final TimeOfDay? picked = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.fromDateTime(scheduledTime),
//             );
//             if (picked != null) {
//               final newDateTime = DateTime(
//                 _selectedDate.year,
//                 _selectedDate.month,
//                 _selectedDate.day,
//                 picked.hour,
//                 picked.minute,
//               );
//
//               await _updateReminderTime(
//                 activity!,
//                 newDateTime,
//                 reminderNotifier,
//                 activityNotifier,
//               );
//             }
//           }
//               : null,
//           child: Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50.w,
//                   height: 50.h,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: ClipOval(
//                       child: imagePath != null
//                           ? Image.asset(
//                         imagePath,
//                         width: 35.w,
//                         height: 35.h,
//                         fit: BoxFit.contain,
//                         errorBuilder: (_, __, ___) =>
//                             Icon(Icons.pets, color: color, size: 24.w),
//                       )
//                           : Icon(Icons.notifications_active,
//                           color: color, size: 24.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       DateFormat('EEE MMM d').format(scheduledTime),
//                       style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             _showReminderDetailsSheet(
//                               context,
//                               reminder,
//                               activity,
//                               reminderNotifier,
//                               activityNotifier,
//                             );
//                           },
//                           child: const Icon(
//                             Icons.notifications,
//                             size: 16,
//                             color: Colors.red,
//                           ),
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           DateFormat('hh:mm a').format(scheduledTime),
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= REMINDER DETAILS SHEET =================
//
//   void _showReminderDetailsSheet(
//     BuildContext context,
//     Map<String, dynamic> reminder,
//     Activity? activity,
//     ReminderNotifier reminderNotifier,
//     ActivityNotifier activityNotifier,
//   ) {
//     final scheduledTime = DateTime.parse(reminder['scheduledTime']);
//     final title = reminder['activityName'] ?? 'Reminder';
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Image and Name
//             Row(
//               children: [
//                 Container(
//                   width: 60.w,
//                   height: 60.h,
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   padding: EdgeInsets.all(12.w),
//                   child: imagePath != null
//                       ? Image.asset(imagePath)
//                       : Icon(Icons.notifications, color: color),
//                 ),
//                 SizedBox(width: 16.w),
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//
//             // Date and Time
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, color: Colors.grey),
//                 SizedBox(width: 8.w),
//                 Text(DateFormat('EEE, MMM d, yyyy').format(scheduledTime)),
//               ],
//             ),
//             SizedBox(height: 10.h),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, color: Colors.grey),
//                 SizedBox(width: 8.w),
//                 Text(DateFormat('hh:mm a').format(scheduledTime)),
//               ],
//             ),
//
//             SizedBox(height: 30.h),
//
//             // Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       // Logic to update (show time picker)
//                       if (activity != null) {
//                         final TimeOfDay? picked = await showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.fromDateTime(scheduledTime),
//                         );
//                         if (picked != null) {
//                           final newDateTime = DateTime(
//                             _selectedDate.year,
//                             _selectedDate.month,
//                             _selectedDate.day,
//                             picked.hour,
//                             picked.minute,
//                           );
//
//                           await _updateReminderTime(
//                             activity,
//                             newDateTime,
//                             reminderNotifier,
//                             activityNotifier,
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.r)),
//                     ),
//                     child: const Text('Update', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       await _removeReminder(
//                         reminderNotifier: reminderNotifier,
//                         activityNotifier: activityNotifier,
//                         activity: activity,
//                         reminderId: reminder['reminderId'],
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.r)),
//                     ),
//                     child: const Text('Remove', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ================= ADD REMINDER =================
//
//   void _showAddReminderSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: Addreminder(
//           initialDate: _selectedDate,
//           selectedPetId: widget.selectedPetId,
//         ),
//       ),
//     );
//   }
//
//   // ================= REMOVE REMINDER =================
//
//   Future<void> _removeReminder({
//     required ReminderNotifier reminderNotifier,
//     required ActivityNotifier activityNotifier,
//     Activity? activity,
//     String? reminderId,
//     bool silent = false,
//   }) async {
//     final idToCancel = reminderId ?? activity?.reminderId;
//     if (idToCancel != null) {
//       await reminderNotifier.cancelReminder(idToCancel);
//     }
//
//     if (activity != null) {
//       activityNotifier.updateActivity(
//         activity.copyWith(
//           hasReminder: false,
//           reminderDateTime: null,
//           reminderId: null,
//         ),
//       );
//     }
//   }
//
//
// // Future<void> _removeReminder(
// //     Activity activity,
// //     ReminderNotifier reminderNotifier,
// //     ActivityNotifier activityNotifier, {
// //       bool silent = false,
// //     }) async {
// //   if (activity.reminderId != null) {
// //     await reminderNotifier.cancelReminder(activity.reminderId!);
// //   }
// //
// //   activityNotifier.updateActivity(
// //     activity.copyWith(
// //       hasReminder: false,
// //       reminderDateTime: null,
// //       reminderId: null,
// //     ),
// //   );
// // }
// }


//sssss




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'addreminder.dart';
//
// class AddReminderView extends StatefulWidget {
//   final String? selectedPetId;
//   const AddReminderView({super.key, this.selectedPetId});
//
//   @override
//   State<AddReminderView> createState() => _AddReminderViewState();
// }
//
// class _AddReminderViewState extends State<AddReminderView> {
//   DateTime _selectedDate = DateTime.now();
//   Timer? _cleanupTimer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReminderNotifier>().startReminderChecker(context);
//       _startAutoRemoveCheck();
//     });
//   }
//
//   @override
//   void dispose() {
//     _cleanupTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startAutoRemoveCheck() {
//     _checkAndRemoveExpiredReminders();
//     _cleanupTimer =
//         Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRemoveExpiredReminders());
//   }
//
//   void _checkAndRemoveExpiredReminders() async {
//     if (!mounted) return;
//
//     final activityNotifier = context.read<ActivityNotifier>();
//     final reminderNotifier = context.read<ReminderNotifier>();
//     final now = DateTime.now();
//
//     final expiredActivities = activityNotifier.activities.where(
//           (a) =>
//       a.hasReminder &&
//           a.reminderDateTime != null &&
//           a.reminderDateTime!.isBefore(now),
//     );
//
//     for (final activity in expiredActivities) {
//       await _removeReminder(
//         reminderNotifier: reminderNotifier,
//         activityNotifier: activityNotifier,
//         activity: activity,
//         silent: true,
//       );
//     }
//   }
//
//   Future<void> _updateReminderTime(
//       Activity activity,
//       DateTime newTime,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) async {
//     // 1. Cancel old reminder
//     if (activity.reminderId != null) {
//       await reminderNotifier.cancelReminder(activity.reminderId!);
//     }
//
//     // 2. Schedule new reminder
//     final newId = await reminderNotifier.scheduleReminder(
//       activity: activity,
//       reminderDateTime: newTime,
//     );
//
//     // 3. Update activity
//     activityNotifier.updateActivity(
//       activity.copyWith(
//         hasReminder: true,
//         reminderDateTime: newTime,
//         reminderId: newId,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reminderNotifier = context.watch<ReminderNotifier>();
//     final activityNotifier = context.read<ActivityNotifier>();
//     final now = DateTime.now();
//
//     final reminders = reminderNotifier.reminders.where((r) {
//       final scheduled = DateTime.parse(r['scheduledTime']);
//       final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;
//
//       return petMatch &&
//           scheduled.year == _selectedDate.year &&
//           scheduled.month == _selectedDate.month &&
//           scheduled.day == _selectedDate.day &&
//           scheduled.isAfter(now);
//     }).toList()
//       ..sort((a, b) => DateTime.parse(b['scheduledTime'])
//           .compareTo(DateTime.parse(a['scheduledTime'])));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: _buildReminderList(
//               reminders,
//               reminderNotifier,
//               activityNotifier,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= HEADER =================
//
//   Widget _buildHeader() {
//     return Container(
//       height: 70.h,
//       margin: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _headerIcon('assets/images/61.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/62.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/63.png'),
//             ],
//           ),
//           GestureDetector(
//             onTap: _showAddReminderSheet,
//             child: Text(
//               'Add Reminder',
//               style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
//             ),
//           ),
//           IconButton(
//             onPressed: _showAddReminderSheet,
//             icon: SvgPicture.asset('assets/images/add.svg', width: 28.w),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _headerIcon(String path) {
//     return Container(
//       width: 40.w,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       padding: EdgeInsets.all(8.w),
//       child: Image.asset(path),
//     );
//   }
//
//   // ================= REMINDER LIST =================
//
//   Widget _buildReminderList(
//       List<Map<String, dynamic>> reminders,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     if (reminders.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/images136.png', width: 120.w),
//           SizedBox(height: 20.h),
//           Text('No Reminders', style: TextStyle(fontSize: 20.sp)),
//           SizedBox(height: 6.h),
//           Text(formattedDate, style: const TextStyle(color: Colors.grey)),
//         ],
//       );
//     }
//
//     return ListView(
//       padding: EdgeInsets.only(top: 12.h),
//       children: reminders.map(
//             (r) => _buildReminderCard(
//           r,
//           reminderNotifier,
//           activityNotifier,
//         ),
//       ).toList(),
//     );
//   }
//
//   Widget _buildReminderCard(
//       Map<String, dynamic> reminder,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final scheduledTime = DateTime.parse(reminder['scheduledTime']);
//     final title = reminder['activityName'] ?? 'Reminder';
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//     final reminderId = reminder['reminderId'];
//
//     Activity? activity;
//     try {
//       activity = activityNotifier.activities.firstWhere(
//             (a) => a.reminderId == reminderId,
//       );
//     } catch (_) {}
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         color: const Color(0xFFF4F7F6),
//         child: InkWell(
//           onTap: activity != null
//               ? () async {
//             final TimeOfDay? picked = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.fromDateTime(scheduledTime),
//             );
//             if (picked != null) {
//               final newDateTime = DateTime(
//                 _selectedDate.year,
//                 _selectedDate.month,
//                 _selectedDate.day,
//                 picked.hour,
//                 picked.minute,
//               );
//
//               await _updateReminderTime(
//                 activity!,
//                 newDateTime,
//                 reminderNotifier,
//                 activityNotifier,
//               );
//             }
//           }
//               : null,
//           child: Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50.w,
//                   height: 50.h,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: ClipOval(
//                       child: imagePath != null
//                           ? Image.asset(
//                         imagePath,
//                         width: 35.w,
//                         height: 35.h,
//                         fit: BoxFit.contain,
//                         errorBuilder: (_, __, ___) =>
//                             Icon(Icons.pets, color: color, size: 24.w),
//                       )
//                           : Icon(Icons.notifications_active,
//                           color: color, size: 24.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       DateFormat('EEE MMM d').format(scheduledTime),
//                       style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             await _removeReminder(
//                               reminderNotifier: reminderNotifier,
//                               activityNotifier: activityNotifier,
//                               activity: activity,
//                               reminderId: reminderId,
//                             );
//                           },
//                           child: const Icon(
//                             Icons.notifications,
//                             size: 16,
//                             color: Colors.red,
//                           ),
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           DateFormat('hh:mm a').format(scheduledTime),
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= ADD REMINDER =================
//
//   void _showAddReminderSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: Addreminder(
//           initialDate: _selectedDate,
//           selectedPetId: widget.selectedPetId,
//         ),
//       ),
//     );
//   }
//
//   // ================= REMOVE REMINDER =================
//
//   Future<void> _removeReminder({
//     required ReminderNotifier reminderNotifier,
//     required ActivityNotifier activityNotifier,
//     Activity? activity,
//     String? reminderId,
//     bool silent = false,
//   }) async {
//     final idToCancel = reminderId ?? activity?.reminderId;
//     if (idToCancel != null) {
//       await reminderNotifier.cancelReminder(idToCancel);
//     }
//
//     if (activity != null) {
//       activityNotifier.updateActivity(
//         activity.copyWith(
//           hasReminder: false,
//           reminderDateTime: null,
//           reminderId: null,
//         ),
//       );
//     }
//   }
//
//
// // Future<void> _removeReminder(
// //     Activity activity,
// //     ReminderNotifier reminderNotifier,
// //     ActivityNotifier activityNotifier, {
// //       bool silent = false,
// //     }) async {
// //   if (activity.reminderId != null) {
// //     await reminderNotifier.cancelReminder(activity.reminderId!);
// //   }
// //
// //   activityNotifier.updateActivity(
// //     activity.copyWith(
// //       hasReminder: false,
// //       reminderDateTime: null,
// //       reminderId: null,
// //     ),
// //   );
// // }
// }



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'addreminder.dart';
//
// class AddReminderView extends StatefulWidget {
//   final String? selectedPetId;
//   const AddReminderView({super.key, this.selectedPetId});
//
//   @override
//   State<AddReminderView> createState() => _AddReminderViewState();
// }
//
// class _AddReminderViewState extends State<AddReminderView> {
//   DateTime _selectedDate = DateTime.now();
//   Timer? _cleanupTimer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReminderNotifier>().startReminderChecker(context);
//       _startAutoRemoveCheck();
//     });
//   }
//
//   @override
//   void dispose() {
//     _cleanupTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startAutoRemoveCheck() {
//     _checkAndRemoveExpiredReminders();
//     _cleanupTimer =
//         Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRemoveExpiredReminders());
//   }
//
//   void _checkAndRemoveExpiredReminders() async {
//     if (!mounted) return;
//
//     final activityNotifier = context.read<ActivityNotifier>();
//     final reminderNotifier = context.read<ReminderNotifier>();
//     final now = DateTime.now();
//
//     final expiredActivities = activityNotifier.activities.where(
//           (a) =>
//       a.hasReminder &&
//           a.reminderDateTime != null &&
//           a.reminderDateTime!.isBefore(now),
//     );
//
//     for (final activity in expiredActivities) {
//       await _removeReminder(
//         activity,
//         reminderNotifier,
//         activityNotifier,
//         silent: true,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reminderNotifier = context.watch<ReminderNotifier>();
//     final activityNotifier = context.read<ActivityNotifier>();
//     final now = DateTime.now();
//
//     final reminders = reminderNotifier.reminders.where((r) {
//       final scheduled = DateTime.parse(r['scheduledTime']);
//       final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;
//
//       return petMatch &&
//           scheduled.year == _selectedDate.year &&
//           scheduled.month == _selectedDate.month &&
//           scheduled.day == _selectedDate.day &&
//           scheduled.isAfter(now);
//     }).toList()
//       ..sort((a, b) => DateTime.parse(b['scheduledTime'])
//           .compareTo(DateTime.parse(a['scheduledTime'])));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: _buildReminderList(
//               reminders,
//               reminderNotifier,
//               activityNotifier,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= HEADER =================
//
//   Widget _buildHeader() {
//     return Container(
//       height: 70.h,
//       margin: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _headerIcon('assets/images/61.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/62.png'),
//               SizedBox(width: 8.w),
//               _headerIcon('assets/images/63.png'),
//             ],
//           ),
//           GestureDetector(
//             onTap: _showAddReminderSheet,
//             child: Text(
//               'Add Reminder',
//               style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
//             ),
//           ),
//           IconButton(
//             onPressed: _showAddReminderSheet,
//             icon: SvgPicture.asset('assets/images/add.svg', width: 28.w),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _headerIcon(String path) {
//     return Container(
//       width: 40.w,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       padding: EdgeInsets.all(8.w),
//       child: Image.asset(path),
//     );
//   }
//
//   // ================= REMINDER LIST =================
//
//   Widget _buildReminderList(
//       List<Map<String, dynamic>> reminders,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     if (reminders.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('assets/images/images136.png', width: 120.w),
//           SizedBox(height: 20.h),
//           Text('No Reminders', style: TextStyle(fontSize: 20.sp)),
//           SizedBox(height: 6.h),
//           Text(formattedDate, style: const TextStyle(color: Colors.grey)),
//         ],
//       );
//     }
//
//     return ListView(
//       padding: EdgeInsets.only(top: 12.h),
//       children: reminders.map(
//             (r) => _buildReminderCard(
//           r,
//           reminderNotifier,
//           activityNotifier,
//         ),
//       ).toList(),
//     );
//   }
//
//   Widget _buildReminderCard(
//       Map<String, dynamic> reminder,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final scheduledTime = DateTime.parse(reminder['scheduledTime']);
//     final title = reminder['activityName'] ?? 'Reminder';
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         color: const Color(0xFFF4F7F6),
//         child: Padding(
//           padding: EdgeInsets.all(12.w),
//           child: Row(
//             children: [
//               Container(
//                 width: 50.w,
//                 height: 50.h,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: Center(
//                   child: ClipOval(
//                     child: imagePath != null
//                         ? Image.asset(
//                       imagePath,
//                       width: 35.w,
//                       height: 35.h,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) =>
//                           Icon(Icons.pets, color: color, size: 24.w),
//                     )
//                         : Icon(Icons.notifications_active,
//                         color: color, size: 24.w),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     DateFormat('EEE MMM d').format(scheduledTime),
//                     style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                   ),
//                   SizedBox(height: 4.h),
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           final reminderId = reminder['reminderId'];
//
//                           final activity = activityNotifier.activities.firstWhere(
//                                 (a) => a.reminderId == reminderId,
//                           );
//
//                           await _removeReminder(
//                             activity,
//                             reminderNotifier,
//                             activityNotifier,
//                           );
//                         },
//                         child: const Icon(
//                           Icons.notifications,
//                           size: 16,
//                           color: Colors.red,
//                         ),
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         DateFormat('hh:mm a').format(scheduledTime),
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           color: Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= ADD REMINDER =================
//
//   void _showAddReminderSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: Addreminder(
//           initialDate: _selectedDate,
//           selectedPetId: widget.selectedPetId,
//         ),
//       ),
//     );
//   }
//
//   // ================= REMOVE REMINDER =================
//
//   Future<void> _removeReminder(
//       Activity activity,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier, {
//         bool silent = false,
//       }) async {
//     if (activity.reminderId != null) {
//       await reminderNotifier.cancelReminder(activity.reminderId!);
//     }
//
//     activityNotifier.updateActivity(
//       activity.copyWith(
//         hasReminder: false,
//         reminderDateTime: null,
//         reminderId: null,
//       ),
//     );
//   }
//
//
//   // Future<void> _removeReminder(
//   //     Activity activity,
//   //     ReminderNotifier reminderNotifier,
//   //     ActivityNotifier activityNotifier, {
//   //       bool silent = false,
//   //     }) async {
//   //   if (activity.reminderId != null) {
//   //     await reminderNotifier.cancelReminder(activity.reminderId!);
//   //   }
//   //
//   //   activityNotifier.updateActivity(
//   //     activity.copyWith(
//   //       hasReminder: false,
//   //       reminderDateTime: null,
//   //       reminderId: null,
//   //     ),
//   //   );
//   // }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
