import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../activity_model.dart';
import 'add_activities_View.dart';

class AddReminderView extends StatefulWidget {
  final String? selectedPetId;
  const AddReminderView({super.key, this.selectedPetId});

  @override
  State<AddReminderView> createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {
  int _selectedTab = 0;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  final List<String> tabs = [
    'Activities',
    'Reminders',
    'Progress',
    'Documents',
    'Settings',
  ];
  ScrollController? _scrollController;
  int _selectedIndex = 0;
  Timer? _cleanupTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reminderNotifier = context.read<ReminderNotifier>();
      reminderNotifier.startReminderChecker(context);
      _startAutoRemoveCheck();
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _scrollController?.dispose();
    super.dispose();
  }

  void _startAutoRemoveCheck() {
    // Check immediately
    _checkAndRemoveExpiredReminders();
    // Then check every 30 seconds
    _cleanupTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkAndRemoveExpiredReminders();
    });
  }

  void _checkAndRemoveExpiredReminders() async {
    if (!mounted) return;

    final activityNotifier = context.read<ActivityNotifier>();
    final reminderNotifier = context.read<ReminderNotifier>();
    final now = DateTime.now();

    // 1. Identify expired activities first (read-only pass)
    final expiredActivities = activityNotifier.activities.where((activity) {
      return activity.hasReminder &&
          activity.reminderDateTime != null &&
          activity.reminderDateTime!.isBefore(now);
    }).toList();

    // 2. Process removal sequentially
    for (final activity in expiredActivities) {
      if (!mounted) return;
      // Pass silent: true to avoid spamming SnackBars
      await _removeReminder(
        activity,
        reminderNotifier,
        activityNotifier,
        silent: true,
      );
    }
  }

  void _scrollToSelectedDate() {
    if (_scrollController == null || !_scrollController!.hasClients) return;

    final days = _getDaysInMonth(_currentMonth);
    final selectedIndex = days.indexWhere(
      (date) =>
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day,
    );

    if (selectedIndex != -1) {
      _selectedIndex = selectedIndex;

      final itemWidth = 70.w + 12.w;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset =
          (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController!.animateTo(
        offset.clamp(0.0, _scrollController!.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final activities = activityNotifier.activities;
    final reminderNotifier = Provider.of<ReminderNotifier>(context);
    final allReminders = reminderNotifier.reminders;

    final filteredActivities = activities
        .where((activity) {
      final isSamePet = widget.selectedPetId == null ||
          activity.petId == null ||
          activity.petId == widget.selectedPetId;

      if (activity.hasReminder &&
          activity.reminderDateTime != null &&
          !activity.reminderDateTime!.isBefore(now)) {
        return false;  // ← don't show in activities list
      }
      return isSamePet;
    })
        .toList()
      ..sort((a, b) {
        final aTime = (a.hasReminder && a.reminderDateTime != null)
            ? a.reminderDateTime!
            : a.dateTime;
        final bTime = (b.hasReminder && b.reminderDateTime != null)
            ? b.reminderDateTime!
            : b.dateTime;
        return bTime.compareTo(aTime);
      });

    final filteredReminders = allReminders
        .where((reminder) {
      final petId = reminder['petId'];
      final isSamePet = widget.selectedPetId == null ||
          petId == null ||
          petId == widget.selectedPetId;
      final scheduled = DateTime.parse(reminder['scheduledTime']);
      return isSamePet && scheduled.isAfter(now);
      return isSamePet;
    })
        .toList()
      ..sort(
            (a, b) => DateTime.parse(b['scheduledTime'])
            .compareTo(DateTime.parse(a['scheduledTime'])),
      );






    // final activityNotifier = Provider.of<ActivityNotifier>(context);
    // final activities = activityNotifier.activities;
    // final reminderNotifier = Provider.of<ReminderNotifier>(context);
    // final allReminders = reminderNotifier.reminders;
    //
    // final filteredActivities = activities
    //     .where((activity) {
    //       final isSamePet = widget.selectedPetId == null ||
    //           activity.petId == null ||
    //           activity.petId == widget.selectedPetId;
    //       return isSamePet;
    //     })
    //     .toList()
    //   ..sort((a, b) {
    //     final aTime = (a.hasReminder && a.reminderDateTime != null)
    //         ? a.reminderDateTime!
    //         : a.dateTime;
    //     final bTime = (b.hasReminder && b.reminderDateTime != null)
    //         ? b.reminderDateTime!
    //         : b.dateTime;
    //     return bTime.compareTo(aTime);
    //   });
    //
    // final filteredReminders = allReminders
    //     .where((reminder) {
    //       final petId = reminder['petId'];
    //       final isSamePet = widget.selectedPetId == null ||
    //           petId == null ||
    //           petId == widget.selectedPetId;
    //       return isSamePet;
    //     })
    //     .toList()
    //   ..sort(
    //     (a, b) => DateTime.parse(b['scheduledTime'])
    //         .compareTo(DateTime.parse(a['scheduledTime'])),
    //   );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: _buildTabContent(filteredActivities, filteredReminders)),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    List<Activity> filteredActivities,
    List<Map<String, dynamic>> filteredReminders,
  ) {
    switch (_selectedTab) {
      case 0:
        return _buildActivitiesList(filteredActivities, filteredReminders);
      default:
        return const Center(child: Text('Coming soon...'));
    }
  }

  Widget _buildActivitiesList(
    List<Activity> activities,
    List<Map<String, dynamic>> reminders,
  ) {
    final hasActivities = activities.isNotEmpty;
    final hasReminders = reminders.isNotEmpty;
    final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildHeaderIcon('assets/images/61.png'),
                    SizedBox(width: 8.w),
                    _buildHeaderIcon('assets/images/62.png'),
                    SizedBox(width: 8.w),
                    _buildHeaderIcon('assets/images/63.png'),
                    SizedBox(width: 6.w),
                    SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: Image.asset('assets/images/a2.png')
                    ),
                  ],
                ),
                SizedBox(width: 6.w),

                GestureDetector(
                  onTap: () => _showAddActivitySheet(context),
                  child: const Text(
                    'Add Activity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/add.svg',
                      width: 28.w,
                      height: 28.h,
                    ),
                    onPressed: () => _showAddActivitySheet(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView(
            children: [
              if (hasActivities)
                ...activities.map(_buildActivityCard).toList()
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Image.asset(
                      'assets/images/images136.png',
                      width: 100.w,
                      height: 110.h,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'No Activity Logged',
                      style: TextStyle(fontSize: 20.sp, color: const Color(0xFF000000)),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      formattedDate,
                      style:  TextStyle(fontSize: 12.sp, color: const Color(0xFF878787)),
                    ),
                  ],
                ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Reminders',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              if (hasReminders)
                ...reminders.map(_buildReminderCard).toList()
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'No reminders set for this day',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final scheduledTime = DateTime.parse(reminder['scheduledTime']);
    final title = reminder['activityName']?.toString() ?? 'Reminder';
    final note = reminder['activityNote']?.toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        color: const Color(0xFFF4F7F6),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${DateFormat('MMM dd, yyyy').format(scheduledTime)} • ${DateFormat('hh:mm a').format(scheduledTime)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (note != null && note.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActivityCard(Activity activity) {
    final String activityName = activity.name.toLowerCase();
    final bool isDrink = activityName == 'drink';
    final bool isEat = activityName == 'eat';
    final bool isTreat = activityName == 'treat';
    final bool isGrooming = activityName == 'grooming';
    final bool isMedication = activityName == 'medication';
    final bool isVaccination = activityName == 'vaccination';
    final bool isWeight = activityName == 'weight';
    final bool isHeight = activityName == 'height';
    final bool isTemperature = activityName == 'temperature';
    final bool isHealth = activityName == 'health condition';
    final bool isAccident = activityName == 'accident';
    final bool isJournal = activityName == 'journal';
    final bool isCleaning = activityName == 'cleaning';
    final bool isWalk = activityName == 'walk';
    final bool isPlay = activityName == 'play';
    final bool isCrate = activityName == 'crate';
    final bool isTraining = activityName == 'training';
    final bool isSleep = activityName == 'sleep';
    final bool isTimerActivity = isWalk || isPlay || isCrate|| isTraining ||isSleep;
    final bool hasNote = activity.note != null && activity.note!.isNotEmpty;

    String distanceText = '';
    String durationText = '';
    String displayName = activity.name;

    if (isTimerActivity) {
      if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
        distanceText = activity.food!;
      }

      durationText = activity.displayDuration;
    } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
      String food = activity.food!;
      final RegExp quantityRegex =
          RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
      final match = quantityRegex.firstMatch(food);

      if (match != null) {
        distanceText = match.group(1)?.trim() ?? '';
        String namePart = match.group(2)?.trim() ?? '';
        if (namePart.isNotEmpty) {
          displayName = namePart;
        }
      } else {
        displayName = food;
      }
    }

    final DateTime effectiveDateTime = (activity.hasReminder &&
            activity.reminderDateTime != null)
        ? activity.reminderDateTime!
        : activity.dateTime;
    final String dateLabel = DateFormat('EEE MMM d').format(effectiveDateTime);
    final String timeLabel = DateFormat('h:mm a').format(effectiveDateTime);

    return Dismissible(
      key: Key(
        'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
      ),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(activity);
        }
        // _editActivity(activity);
        return false;
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r), // Slightly smaller border radius
        ),
        color: const Color(0xFFF4F7F6),
        child: InkWell(
          onTap: () => _showReminderOptions(activity),
          child: Container(
            padding: EdgeInsets.all(12.w), // Reduced padding
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Image with reminder badge
                    Stack(
                      children: [
                        Container(
                          width: 56.w, // Smaller image container
                          height: 56.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05), // Lighter shadow
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                activity.imagePath,
                                fit: BoxFit.cover,
                                width: 44.w, // Smaller image
                                height: 44.h,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.pets,
                                  color: activity.color,
                                  size: 24.w, // Smaller icon
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Reminder indicator badge
                        if (activity.hasReminder && activity.reminderDateTime != null)
                          Positioned(
                            top: 4,
                            right: 0,
                            child: Container(
                              width: 16.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.notifications,
                                  size: 8.w, // Smaller icon
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Text(
                                //   '$dateLabel $timeLabel',
                                //   style: TextStyle(
                                //     fontSize: 11.sp,
                                //     color: Colors.grey[700],
                                //   ),
                                // ),
                                Text(
                                  DateFormat('EEE MMM d').format(activity.dateTime).toLowerCase(),
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    color: const Color(0xFF555555),
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      activity.hasReminder
                                          ? Icons.notifications_active
                                          : Icons.notifications_active,
                                      size: 18.w,
                                      color: activity.hasReminder
                                          ? Colors.orange
                                          : const Color(0xFF868686),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      timeLabel,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: activity.hasReminder
                                            ? Colors.orange
                                            : const Color(0xFF868686),
                                        fontWeight: FontWeight.bold,
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
                  ],
                ),


                // SizedBox(height: 8.h),
                // const Divider(
                //   thickness: 0.5, // Thinner divider
                //   height: 1,
                //   color: Color(0xFFCBE4DC),
                // ),
                // SizedBox(height: 2.h),
                //
                // if (hasNote)
                //   Padding(
                //     padding: EdgeInsets.only(top: 8.h),
                //
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //
                //       children: [
                //         SizedBox(width: 8.w),
                //
                //         Expanded(
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //
                //             children: [
                //               Text(
                //                 'Note:',
                //                 style: TextStyle(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w600,
                //                   color: Colors.grey[800],
                //                 ),
                //               ),
                //
                //               SizedBox(width: 5.w),
                //
                //               Expanded(
                //                 child: Text(
                //                   activity.note!,
                //                   style: TextStyle(
                //                     fontSize: 16.sp,
                //                     color: Colors.black87,
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }






  // Widget _buildActivityCard(Activity activity) {
  //   final String activityName = activity.name.toLowerCase();
  //   final bool isDrink = activityName == 'drink';
  //   final bool isEat = activityName == 'eat';
  //   final bool isTreat = activityName == 'treat';
  //   final bool isGrooming = activityName == 'grooming';
  //   final bool isMedication = activityName == 'medication';
  //   final bool isVaccination = activityName == 'vaccination';
  //   final bool isWeight = activityName == 'weight';
  //   final bool isHeight = activityName == 'height';
  //   final bool isTemperature = activityName == 'temperature';
  //   final bool isHealth = activityName == 'health condition';
  //   final bool isAccident = activityName == 'accident';
  //   final bool isJournal = activityName == 'journal';
  //   final bool isCleaning = activityName == 'cleaning';
  //   final bool isWalk = activityName == 'walk';
  //   final bool isPlay = activityName == 'play';
  //   final bool isCrate = activityName == 'crate';
  //   final bool isTraining = activityName == 'training';
  //   final bool isSleep = activityName == 'sleep';
  //   final bool isTimerActivity = isWalk || isPlay || isCrate|| isTraining ||isSleep;
  //   final bool hasNote = activity.note != null && activity.note!.isNotEmpty;
  //
  //   String distanceText = '';
  //   String durationText = '';
  //   String displayName = activity.name;
  //
  //   if (isTimerActivity) {
  //     if (isWalk && activity.food != null && activity.food!.isNotEmpty) {
  //       distanceText = activity.food!;
  //     }
  //
  //     durationText = activity.displayDuration;
  //   } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
  //     String food = activity.food!;
  //     final RegExp quantityRegex = RegExp(r'^(\d+(?:\.\d+)?\s*[a-zA-Z]+)(.*)$');
  //     final match = quantityRegex.firstMatch(food);
  //
  //     if (match != null) {
  //       distanceText = match.group(1)?.trim() ?? '';
  //       String namePart = match.group(2)?.trim() ?? '';
  //       if (namePart.isNotEmpty) {
  //         displayName = namePart;
  //       }
  //     } else {
  //       displayName = food;
  //     }
  //   }
  //
  //   return Dismissible(
  //     key: Key(
  //       'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
  //     ),
  //     background: _buildSwipeBackground(isLeft: true),
  //     secondaryBackground: _buildSwipeBackground(isLeft: false),
  //     confirmDismiss: (direction) async {
  //       if (direction == DismissDirection.endToStart) {
  //         return await _showDeleteConfirmation(activity);
  //       }
  //       // _editActivity(activity);
  //       return false;
  //     },
  //     child: Card(
  //       margin: EdgeInsets.symmetric(vertical: 4.h),
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.r), // Slightly smaller border radius
  //       ),
  //       color: const Color(0xFFF4F7F6),
  //       child: InkWell(
  //         onTap: () => _showReminderOptions(activity),
  //         child: Container(
  //           padding: EdgeInsets.all(12.w), // Reduced padding
  //           child: Column(
  //             children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Activity Image with reminder badge
  //                   Stack(
  //                     children: [
  //                       Container(
  //                         width: 56.w, // Smaller image container
  //                         height: 56.h,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Colors.white,
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.black.withOpacity(0.05), // Lighter shadow
  //                               blurRadius: 3,
  //                               offset: const Offset(0, 1),
  //                             ),
  //                           ],
  //                         ),
  //                         child: Center(
  //                           child: ClipOval(
  //                             child: Image.asset(
  //                               activity.imagePath,
  //                               fit: BoxFit.cover,
  //                               width: 44.w, // Smaller image
  //                               height: 44.h,
  //                               errorBuilder: (_, __, ___) => Icon(
  //                                 Icons.pets,
  //                                 color: activity.color,
  //                                 size: 24.w, // Smaller icon
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       // Reminder indicator badge
  //                       if (activity.hasReminder && activity.reminderDateTime != null)
  //                         Positioned(
  //                           top: 4,
  //                           right: 0,
  //                           child: Container(
  //                             width: 16.w,
  //                             height: 16.h,
  //                             decoration: BoxDecoration(
  //                               color: Colors.orange,
  //                               shape: BoxShape.circle,
  //                               border: Border.all(
  //                                 color: Colors.white,
  //                                 width: 1.5,
  //                               ),
  //                             ),
  //                             child: Center(
  //                               child: Icon(
  //                                 Icons.notifications,
  //                                 size: 8.w, // Smaller icon
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   SizedBox(width: 10.w), // Reduced spacing
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(vertical: 8), // Reduced vertical padding
  //                                 child: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     if (isDrink && distanceText.isNotEmpty)
  //                                       Column(
  //                                         crossAxisAlignment: CrossAxisAlignment.start,
  //                                         children: [
  //                                           Row(
  //                                             children: [
  //                                               Text(
  //                                                 activity.name,
  //                                                 style: TextStyle(
  //                                                   fontSize: 16.sp, // Smaller font
  //                                                   fontWeight: FontWeight.bold,
  //                                                 ),
  //                                               ),
  //                                               SizedBox(width: 6.w),
  //                                               // Reminder time if set
  //                                               if (activity.hasReminder && activity.reminderDateTime != null)
  //                                                 Container(
  //                                                   padding: EdgeInsets.symmetric(
  //                                                     horizontal: 5.w,
  //                                                     vertical: 1.h,
  //                                                   ),
  //                                                   decoration: BoxDecoration(
  //                                                     color: Colors.orange.withOpacity(0.1),
  //                                                     borderRadius: BorderRadius.circular(3.r),
  //                                                     border: Border.all(
  //                                                       color: Colors.orange.withOpacity(0.3),
  //                                                       width: 0.5,
  //                                                     ),
  //                                                   ),
  //                                                   child: Row(
  //                                                     mainAxisSize: MainAxisSize.min,
  //                                                     children: [
  //                                                       Icon(
  //                                                         Icons.notifications,
  //                                                         size: 10.w,
  //                                                         color: Colors.orange,
  //                                                       ),
  //                                                       SizedBox(width: 3.w),
  //                                                       Text(
  //                                                         DateFormat('h:mm a').format(activity.reminderDateTime!),
  //                                                         style: TextStyle(
  //                                                           fontSize: 9.sp,
  //                                                           color: Colors.orange,
  //                                                           fontWeight: FontWeight.bold,
  //                                                         ),
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                             ],
  //                                           ),
  //                                           SizedBox(height: 3.h),
  //                                           Text(
  //                                             distanceText,
  //                                             style: TextStyle(
  //                                               fontSize: 13.sp, // Smaller font
  //                                               fontWeight: FontWeight.bold,
  //                                               color: const Color(0xFF7D7D7D),
  //                                             ),
  //                                           ),
  //                                           SizedBox(height: 3.h),
  //                                           Text(
  //                                             displayName,
  //                                             style: TextStyle(
  //                                               fontSize: 13.sp, // Smaller font
  //                                               fontWeight: FontWeight.bold,
  //                                               color: const Color(0xFF7D7D7D),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       )
  //                                     else ...[
  //                                       Text(
  //                                         displayName,
  //                                         style: TextStyle(
  //                                           fontSize: 16.sp, // Smaller font
  //                                           fontWeight: FontWeight.bold,
  //                                         ),
  //                                       ),
  //                                       if ((isEat ||
  //                                           isTreat ||
  //                                           isGrooming ||
  //                                           isMedication ||
  //                                           isVaccination ||
  //                                           isWeight ||
  //                                           isHeight ||
  //                                           isTemperature
  //                                           || isHealth ||
  //                                           isAccident ||
  //                                           isJournal || isCleaning) &&
  //                                           activity.food != null &&
  //                                           activity.food!.isNotEmpty)
  //                                         Text(
  //                                           activity.food!,
  //                                           style: TextStyle(
  //                                             fontSize: 13.sp,
  //                                             fontWeight: FontWeight.bold,
  //                                             color: const Color(0xFF7D7D7D),
  //                                           ),
  //                                         ),
  //                                     ],
  //                                     SizedBox(height: 4.h), // Reduced spacing
  //                                     if (isTimerActivity)
  //                                       Row(
  //                                         children: [
  //                                           if (distanceText.isNotEmpty)
  //                                             Row(
  //                                               children: [
  //                                                 Icon(
  //                                                   Icons.directions_walk,
  //                                                   size: 14.sp, // Smaller icon
  //                                                   color: const Color(0xFF7D7D7D),
  //                                                 ),
  //                                                 SizedBox(width: 3.w),
  //                                                 Text(
  //                                                   distanceText,
  //                                                   style: TextStyle(
  //                                                     fontSize: 13.sp, // Smaller font
  //                                                     fontWeight: FontWeight.bold,
  //                                                     color: const Color(0xFF7D7D7D),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           if (distanceText.isNotEmpty && durationText.isNotEmpty)
  //                                             SizedBox(width: 4.w),
  //                                           if (durationText.isNotEmpty)
  //                                             Text(
  //                                               durationText,
  //                                               style: TextStyle(
  //                                                 fontSize: 13.sp, // Smaller font
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: const Color(0xFF7D7D7D),
  //                                               ),
  //                                             ),
  //                                         ],
  //                                       )
  //                                     else if (isEat && activity.food != null && activity.food!.isNotEmpty)
  //                                       Text(
  //                                         activity.food!,
  //                                         style: TextStyle(
  //                                           fontSize: 13.sp, // Smaller font
  //                                           fontWeight: FontWeight.bold,
  //                                           color: const Color(0xFF7D7D7D),
  //                                         ),
  //                                       ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 4),
  //                               child: IconButton(
  //                                 onPressed: () => _showReminderOptions(activity),
  //                                 icon: Icon(
  //                                   activity.hasReminder
  //                                       ? Icons.notifications_active
  //                                       : Icons.notifications_none,
  //                                   color: activity.hasReminder
  //                                       ? Colors.orange
  //                                       : Colors.grey[600],
  //                                   size: 20.w, // Smaller icon
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 8.h), // Reduced spacing
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       DateFormat('MMM dd, yyyy').format(activity.dateTime).toLowerCase(),
  //                       style: TextStyle(
  //                         fontSize: 11.sp, // Smaller font
  //                         color: Colors.grey[700],
  //                       ),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Icon(
  //                           Icons.access_time,
  //                           size: 14.w, // Smaller icon
  //                           color: Colors.grey[600],
  //                         ),
  //                         SizedBox(width: 3.w),
  //                         Text(
  //                           DateFormat('hh:mm a').format(activity.dateTime),
  //                           style: TextStyle(
  //                             fontSize: 11.sp, // Smaller font
  //                             color: Colors.grey[600],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 thickness: 0.5, // Thinner divider
  //                 height: 1,
  //                 color: Color(0xFFCBE4DC),
  //               ),
  //               SizedBox(height: 2.h),
  //
  //               if (hasNote)
  //                 Padding(
  //                   padding: EdgeInsets.only(top: 8.h),
  //
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                     children: [
  //                       SizedBox(width: 8.w),
  //
  //                       Expanded(
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                           children: [
  //                             Text(
  //                               'Note:',
  //                               style: TextStyle(
  //                                 fontSize: 16.sp,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Colors.grey[800],
  //                               ),
  //                             ),
  //
  //                             SizedBox(width: 5.w),
  //
  //                             Expanded(
  //                               child: Text(
  //                                 activity.note!,
  //                                 style: TextStyle(
  //                                   fontSize: 16.sp,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }




  void _showReminderOptions(Activity activity) {
    final reminderNotifier = Provider.of<ReminderNotifier>(
      context,
      listen: false,
    );
    final activityNotifier = Provider.of<ActivityNotifier>(
      context,
      listen: false,
    );

    DateTime selectedDate = activity.dateTime;
    TimeOfDay selectedTime = activity.reminderDateTime != null
        ? TimeOfDay.fromDateTime(activity.reminderDateTime!)
        : TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Center(
                    child: Text(
                      'Set Reminder for ${activity.name}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Activity summary
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
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
                            child: Image.asset(
                              activity.imagePath,
                              width: 30.w,
                              height: 30.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy • hh:mm a',
                                ).format(activity.dateTime),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Date and Time selection with icon buttons
                  Row(
                    children: [
                      // Date selector with icon button
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2027, 12, 31),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        DateFormat(
                                          'EEE, MMM d, yyyy',
                                        ).format(selectedDate),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[500],
                                  size: 24.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Time selector with icon button
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    timePickerTheme: TimePickerThemeData(
                                      backgroundColor: Colors.white,
                                      dayPeriodBorderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.access_time,
                                      color: Colors.blue,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        selectedTime.format(context),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[500],
                                  size: 24.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Selected date time preview
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.blue,
                          size: 18.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Reminder set for: ${DateFormat('MMM d, yyyy').format(selectedDate)} at ${selectedTime.format(context)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Action buttons
                  Row(
                    children: [
                      // Remove reminder button (only if already has reminder)
                      if (activity.hasReminder)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await _removeReminder(
                                activity,
                                reminderNotifier,
                                activityNotifier,
                              );
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 20.w,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8.w),
                                const Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (activity.hasReminder) SizedBox(width: 12.w),

                      // Save/Cancel buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final reminderDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            if (reminderDateTime.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Reminder time must be in the future'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            await _setReminder(
                              activity,
                              reminderDateTime,
                              reminderNotifier,
                              activityNotifier,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                activity.hasReminder
                                    ? Icons.notifications_active
                                    : Icons.notifications,
                                size: 20.w,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                activity.hasReminder
                                    ? 'Update Reminder'
                                    : 'Set Reminder',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Cancel button
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _setReminder(
    Activity activity,
    DateTime reminderDateTime,
    ReminderNotifier reminderNotifier,
    ActivityNotifier activityNotifier,
  ) async {
    try {
      // Create or update reminder
      final reminderId = await reminderNotifier.scheduleReminder(
        activity: activity,
        reminderDateTime: reminderDateTime,
      );

      // Update activity with reminder info
      final updatedActivity = activity.copyWith(
        hasReminder: true,
        reminderDateTime: reminderDateTime,
        reminderId: reminderId,
      );

      // Update in activity provider
      activityNotifier.updateActivity(updatedActivity);

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Failed to set reminder: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to set reminder'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeReminder(
    Activity activity,
    ReminderNotifier reminderNotifier,
    ActivityNotifier activityNotifier, {
    bool silent = false,
  }) async {
    try {
      // Cancel the notification
      if (activity.reminderId != null) {
        await reminderNotifier.cancelReminder(activity.reminderId!);
      }

      // Update activity to remove reminder
      final updatedActivity = activity.copyWith(
        hasReminder: false,
        reminderDateTime: null,
        reminderId: null,
      );

      // Update in activity provider
      activityNotifier.updateActivity(updatedActivity);

      // Show success message
      if (!silent) {

      }

      // Refresh UI
      if (mounted) setState(() {});
    } catch (e) {

    }
  }

  // Build swipe background (edit on left, delete on right)
  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
        color: isLeft ? const Color(0xFF820DFF) : Colors.red,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: isLeft
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Icon(
                isLeft ? Icons.edit : Icons.delete,
                color: Colors.white,
                size: 24.w,
              ),
              SizedBox(width: 8.w),
              Text(
                isLeft ? 'Edit' : 'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  Future<bool> _showDeleteConfirmation(Activity activity) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Activity'),
        content: Text('Are you sure you want to delete "${activity.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Edit activity function
  // void _editActivity(Activity activity) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Allactivityview(
  //         selectedActivity: activity,
  //         selectedPetId: widget.selectedPetId,
  //       ),
  //     ),
  //   ).then((edited) {
  //     if (edited == true) {
  //       if (context.mounted) {
  //         setState(() {});
  //       }
  //     }
  //   });
  // }

  Widget _buildHeaderIcon(String path) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Image.asset(path, width: 24.w, height: 24.h),
      ),
    );
  }

  void _showAddActivitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: AddActivitiesView(
          initialDate: _selectedDate,
          selectedPetId: widget.selectedPetId,
        ),
      ),
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];

    for (int i = firstDay.weekday - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    while (days.length < 42) {
      days.add(days.last.add(const Duration(days: 1)));
    }

    return days;
  }
}




//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'add_activities_View.dart';
// import 'allactivityview.dart';
//
// class AddReminderView extends StatefulWidget {
//   const AddReminderView({super.key});
//
//   @override
//   State<AddReminderView> createState() => _AddReminderViewState();
// }
//
// class _AddReminderViewState extends State<AddReminderView> {
//   int _selectedTab = 0;
//   DateTime _selectedDate = DateTime.now();
//   DateTime _currentMonth = DateTime.now();
//
//   final List<String> tabs = [
//     'Activities',
//     'Reminders',
//     'Progress',
//     'Documents',
//     'Settings',
//   ];
//   ScrollController? _scrollController;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToSelectedDate();
//     });
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final reminderNotifier = context.read<ReminderNotifier>();
//       reminderNotifier.startReminderChecker(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     super.dispose();
//   }
//
//   void _scrollToSelectedDate() {
//     if (_scrollController == null) return;
//
//     final days = _getDaysInMonth(_currentMonth);
//     final selectedIndex = days.indexWhere(
//           (date) =>
//       date.year == _selectedDate.year &&
//           date.month == _selectedDate.month &&
//           date.day == _selectedDate.day,
//     );
//
//     if (selectedIndex != -1) {
//       _selectedIndex = selectedIndex;
//
//       final itemWidth = 70.w + 12.w;
//       final screenWidth = MediaQuery.of(context).size.width;
//       final offset =
//           (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
//
//       _scrollController!.animateTo(
//         offset.clamp(0.0, _scrollController!.position.maxScrollExtent),
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activityNotifier = Provider.of<ActivityNotifier>(context);
//     final activities = activityNotifier.activities;
//
//     final filteredActivities = activities.where((activity) {
//       return activity.dateTime.year == _selectedDate.year &&
//           activity.dateTime.month == _selectedDate.month &&
//           activity.dateTime.day == _selectedDate.day;
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.w),
//         child: Column(
//           children: [
//
//             Expanded(child: _buildTabContent(filteredActivities)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(List<Activity> filteredActivities) {
//     switch (_selectedTab) {
//       case 0:
//         return _buildActivitiesList(filteredActivities);
//       default:
//         return const Center(child: Text('Coming soon...'));
//     }
//   }
//
//   Widget _buildActivitiesList(List<Activity> activities) {
//     final hasActivities = activities.isNotEmpty;
//     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Add Activity Header
//         Container(
//           height: 70.h,
//           margin: EdgeInsets.symmetric(horizontal: 8.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7F6),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                     SizedBox(width: 8.w),
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                     SizedBox(width: 8.w),
//                     _buildHeaderIcon('assets/images/dog788.svg'),
//                   ],
//                 ),
//                 const Text(
//                   'Add Activity',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   width: 50.w,
//                   height: 50.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/images/add.svg',
//                       width: 28.w,
//                       height: 28.h,
//                     ),
//                     onPressed: () => _showAddActivitySheet(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(height: 24.h),
//
//         if (hasActivities)
//           Expanded(
//             child: ListView.builder(
//               itemCount: activities.length,
//               itemBuilder: (context, index) {
//                 final activity = activities[index];
//                 return _buildActivityCard(activity);
//               },
//             ),
//           )
//         else
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/images136.png',
//                     width: 100.w,
//                     height: 110.h,
//                   ),
//                   SizedBox(height: 20.h),
//                   const Text(
//                     'No Activity Logged',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     formattedDate,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildActivityCard(Activity activity) {
//     final String activityName = activity.name.toLowerCase();
//     final bool isDrink = activityName == 'drink';
//     final bool isWalk = activityName == 'walk';
//     final bool hasNote = activity.note != null && activity.note!.isNotEmpty;
//
//     String distanceText = '';
//     String durationText = '';
//
//     if (isWalk) {
//       if (activity.food != null && activity.food!.isNotEmpty) {
//         distanceText = activity.food!;
//       }
//
//       if (activity.formattedDuration != null &&
//           activity.formattedDuration!.isNotEmpty) {
//         durationText = activity.formattedDuration!;
//       } else if (activity.duration != null) {
//         final hours = activity.duration!.inHours;
//         final minutes = activity.duration!.inMinutes.remainder(60);
//         if (hours > 0) {
//           durationText = '$hours hr ${minutes > 0 ? '$minutes min' : ''}'.trim();
//         } else {
//           durationText = '$minutes min';
//         }
//       }
//     } else if (isDrink && activity.food != null && activity.food!.isNotEmpty) {
//       distanceText = activity.food!;
//     }
//
//     return Dismissible(
//       key: Key(
//         'activity_${activity.name}_${activity.dateTime.millisecondsSinceEpoch}',
//       ),
//       background: _buildSwipeBackground(isLeft: true),
//       secondaryBackground: _buildSwipeBackground(isLeft: false),
//       confirmDismiss: (direction) async {
//         if (direction == DismissDirection.endToStart) {
//           return await _showDeleteConfirmation(activity);
//         } else {
//           _editActivity(activity);
//           return false;
//         }
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 4.h),
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         color: const Color(0xFFF4F7F6),
//         child: InkWell(
//           onTap: () => _showReminderOptions(activity),
//           child: Container(
//             padding: EdgeInsets.all(10.w),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Activity Image with reminder badge
//                     Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: Container(
//                             width: 70.w,
//                             height: 70.h,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   activity.imagePath,
//                                   fit: BoxFit.cover,
//                                   width: 54.w,
//                                   height: 54.h,
//                                   errorBuilder: (_, __, ___) => Icon(
//                                     Icons.pets,
//                                     color: activity.color,
//                                     size: 28.w,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // Reminder indicator badge
//                         if (activity.hasReminder && activity.reminderDateTime != null)
//                           Positioned(
//                             top: 8,
//                             right: 0,
//                             child: Container(
//                               width: 20.w,
//                               height: 20.h,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.white, width: 2),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.notifications,
//                                   size: 10.w,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(width: 12.w),
//
//                     // Activity Details
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Left: Name + Distance/Duration
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 20,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             activity.name,
//                                             style: TextStyle(
//                                               fontSize: 18.sp,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(width: 8.w),
//                                           // Reminder time if set
//                                           if (activity.hasReminder && activity.reminderDateTime != null)
//                                             Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 6.w,
//                                                 vertical: 2.h,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.orange.withOpacity(0.1),
//                                                 borderRadius: BorderRadius.circular(4.r),
//                                                 border: Border.all(
//                                                   color: Colors.orange.withOpacity(0.3),
//                                                   width: 1,
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.notifications,
//                                                     size: 12.w,
//                                                     color: Colors.orange,
//                                                   ),
//                                                   SizedBox(width: 4.w),
//                                                   Text(
//                                                     DateFormat('hh:mm a').format(activity.reminderDateTime!),
//                                                     style: TextStyle(
//                                                       fontSize: 10.sp,
//                                                       color: Colors.orange,
//                                                       fontWeight: FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 6.h),
//
//                                       // Display distance and duration for walk
//                                       if (isWalk)
//                                         Row(
//                                           children: [
//                                             if (distanceText.isNotEmpty)
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_walk,
//                                                     size: 16.sp,
//                                                     color: const Color(0xFF7D7D7D),
//                                                   ),
//                                                   SizedBox(width: 4.w),
//                                                   Text(
//                                                     distanceText,
//                                                     style: TextStyle(
//                                                       fontSize: 14.sp,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: const Color(0xFF7D7D7D),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             SizedBox(width: 5.w),
//                                             if (durationText.isNotEmpty)
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.timer,
//                                                     size: 16.sp,
//                                                     color: const Color(0xFF7D7D7D),
//                                                   ),
//                                                   SizedBox(width: 4.w),
//                                                   Text(
//                                                     durationText,
//                                                     style: TextStyle(
//                                                       fontSize: 14.sp,
//                                                       fontWeight: FontWeight.bold,
//                                                       color: const Color(0xFF7D7D7D),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                           ],
//                                         ),
//
//                                       // Display just quantity for drink
//                                       if (isDrink && distanceText.isNotEmpty)
//                                         Text(
//                                           distanceText,
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: const Color(0xFF7D7D7D),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//
//                               // Right: Reminder Icon
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 20),
//                                 child: IconButton(
//                                   onPressed: () => _showReminderOptions(activity),
//                                   icon: Icon(
//                                     activity.hasReminder
//                                         ? Icons.notifications_active
//                                         : Icons.notifications_none,
//                                     color: activity.hasReminder
//                                         ? Colors.orange
//                                         : Colors.grey[600],
//                                     size: 24.w,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 // Date & Time Row
//                 Padding(
//                   padding: EdgeInsets.only(left: 82.w, bottom: 8.h),
//                   child: Row(
//                     children: [
//                       Text(
//                         DateFormat('MMM dd, yyyy').format(activity.dateTime).toLowerCase(),
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.access_time,
//                             size: 16.w,
//                             color: Colors.grey[600],
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             DateFormat('hh:mm a').format(activity.dateTime),
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Divider
//                 const Divider(thickness: 1, height: 1, color: Color(0xFFCBE4DC)),
//                 SizedBox(height: 12.h),
//
//                 // Note Section
//                 if (hasNote)
//                   Padding(
//                     padding: EdgeInsets.only(top: 8.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 82.w),
//                         Text(
//                           'Note:',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             activity.note!,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showReminderOptions(Activity activity) {
//     final reminderNotifier = Provider.of<ReminderNotifier>(context, listen: false);
//     final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//
//     DateTime selectedDate = activity.dateTime;
//     TimeOfDay selectedTime = activity.reminderDateTime != null
//         ? TimeOfDay.fromDateTime(activity.reminderDateTime!)
//         : TimeOfDay.now();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40.w,
//                       height: 4.h,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(2.r),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//
//                   Text(
//                     'Set Reminder for ${activity.name}',
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//
//                   // Activity summary
//                   Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 50.w,
//                           height: 50.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: Center(
//                             child: Image.asset(
//                               activity.imagePath,
//                               width: 30.w,
//                               height: 30.h,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 activity.name,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 DateFormat('MMM dd, yyyy • hh:mm a').format(activity.dateTime),
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//
//                   // Date selector
//                   ListTile(
//                     leading: Icon(Icons.calendar_today, color: Colors.blue),
//                     title: Text(
//                       'Date',
//                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//                     ),
//                     subtitle: Text(
//                       DateFormat('EEE, MMM d, yyyy').format(selectedDate),
//                       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//                     ),
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate,
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2027, 12, 31),
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           selectedDate = picked;
//                         });
//                       }
//                     },
//                   ),
//
//                   // Time selector
//                   ListTile(
//                     leading: Icon(Icons.access_time, color: Colors.blue),
//                     title: Text(
//                       'Time',
//                       style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//                     ),
//                     subtitle: Text(
//                       selectedTime.format(context),
//                       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//                     ),
//                     onTap: () async {
//                       final picked = await showTimePicker(
//                         context: context,
//                         initialTime: selectedTime,
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           selectedTime = picked;
//                         });
//                       }
//                     },
//                   ),
//                   SizedBox(height: 32.h),
//
//                   // Action buttons
//                   Row(
//                     children: [
//                       // Remove reminder button (only if already has reminder)
//                       if (activity.hasReminder)
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () async {
//                               await _removeReminder(activity, reminderNotifier, activityNotifier);
//                               Navigator.pop(context);
//                             },
//                             style: OutlinedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 16.h),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12.r),
//                               ),
//                             ),
//                             child: Text(
//                               'Remove Reminder',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ),
//
//                       if (activity.hasReminder) SizedBox(width: 12.w),
//
//                       // Save/Cancel buttons
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             final reminderDateTime = DateTime(
//                               selectedDate.year,
//                               selectedDate.month,
//                               selectedDate.day,
//                               selectedTime.hour,
//                               selectedTime.minute,
//                             );
//
//                             // Validation: Check if time is in the past
//                             if (reminderDateTime.isBefore(DateTime.now())) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Reminder time must be in the future'),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                               return;
//                             }
//
//                             await _setReminder(
//                               activity,
//                               reminderDateTime,
//                               reminderNotifier,
//                               activityNotifier,
//                             );
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             padding: EdgeInsets.symmetric(vertical: 16.h),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                           ),
//                           child: Text(
//                             activity.hasReminder ? 'Update Reminder' : 'Set Reminder',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('Cancel'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _setReminder(
//       Activity activity,
//       DateTime reminderDateTime,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) async {
//     try {
//       // Create or update reminder
//       final reminderId = await reminderNotifier.scheduleReminder(
//         activity: activity,
//         reminderDateTime: reminderDateTime,
//       );
//
//       // Update activity with reminder info
//       final updatedActivity = activity.copyWith(
//         hasReminder: true,
//         reminderDateTime: reminderDateTime,
//         reminderId: reminderId,
//       );
//
//       // Update in activity provider
//       activityNotifier.updateActivity(updatedActivity);
//
//
//
//       // Refresh UI
//       if (mounted) setState(() {});
//
//     } catch (e) {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: Text('Failed to set reminder: $e'),
//       //     backgroundColor: Colors.red,
//       //   ),
//       // );
//     }
//   }
//
//   Future<void> _removeReminder(
//       Activity activity,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) async {
//     try {
//       // Cancel the notification
//       if (activity.reminderId != null) {
//         await reminderNotifier.cancelReminder(activity.reminderId!);
//       }
//
//       // Update activity to remove reminder
//       final updatedActivity = activity.copyWith(
//         hasReminder: false,
//         reminderDateTime: null,
//         reminderId: null,
//       );
//
//       // Update in activity provider
//       activityNotifier.updateActivity(updatedActivity);
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Reminder removed'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//
//       // Refresh UI
//       if (mounted) setState(() {});
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to remove reminder: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   // Build swipe background (edit on left, delete on right)
//   Widget _buildSwipeBackground({required bool isLeft}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isLeft ? const Color(0xFF820DFF) : Colors.red,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Align(
//         alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Row(
//             mainAxisAlignment: isLeft
//                 ? MainAxisAlignment.start
//                 : MainAxisAlignment.end,
//             children: [
//               Icon(
//                 isLeft ? Icons.edit : Icons.delete,
//                 color: Colors.white,
//                 size: 24.w,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 isLeft ? 'Edit' : 'Delete',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Show delete confirmation dialog
//   Future<bool> _showDeleteConfirmation(Activity activity) async {
//     bool? result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         title: const Text('Delete Activity'),
//         content: Text('Are you sure you want to delete "${activity.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     return result ?? false;
//   }
//
//   // Edit activity function
//   void _editActivity(Activity activity) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Allactivityview(selectedActivity: activity),
//       ),
//     ).then((edited) {
//       if (edited == true) {
//         if (context.mounted) {
//           setState(() {});
//         }
//       }
//     });
//   }
//
//   Widget _buildHeaderIcon(String path) {
//     return Container(
//       width: 40.w,
//       height: 40.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(8.w),
//         child: SvgPicture.asset(path, width: 24.w, height: 24.h),
//       ),
//     );
//   }
//
//   void _showAddActivitySheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.92,
//         child: const AddActivitiesView(),
//       ),
//     );
//   }
//
//   List<DateTime> _getDaysInMonth(DateTime month) {
//     final firstDay = DateTime(month.year, month.month, 1);
//     final lastDay = DateTime(month.year, month.month + 1, 0);
//     final days = <DateTime>[];
//
//     for (int i = firstDay.weekday - 1; i > 0; i--) {
//       days.add(firstDay.subtract(Duration(days: i)));
//     }
//
//     for (int i = 1; i <= lastDay.day; i++) {
//       days.add(DateTime(month.year, month.month, i));
//     }
//
//     while (days.length < 42) {
//       days.add(days.last.add(const Duration(days: 1)));
//     }
//
//     return days;
//   }
// }
//
//
//
 // }
// //
// //
// //
