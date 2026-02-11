import 'dart:async';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/home/home_view_model.dart';
import '../../activity_model.dart';
import 'addreminder.dart';

class AddReminderView extends StatefulWidget {
  final String? selectedPetId;
  final DateTime? selectedDate;
  const AddReminderView({super.key, this.selectedPetId, this.selectedDate});

  @override
  State<AddReminderView> createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderNotifier>().startReminderChecker(context);
    });
  }

  @override
  void didUpdateWidget(covariant AddReminderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate!;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  String _getLocalizedActivityName(BuildContext context, String name) {
    final localizations = AppLocalizations.of(context)!;
    switch (name) {
      case 'Veterinary': return localizations.activityVeterinary;
      case 'Pee': return localizations.activityPee;
      case 'Eat': return localizations.activityEat;
      case 'Drink': return localizations.activityDrink;
      case 'Play': return localizations.activityPlay;
      case 'Poop': return localizations.activityPoop;
      case 'Walk': return localizations.activityWalk;
      case 'Crate': return localizations.activityCrate;
      case 'Sleep': return localizations.activitySleep;
      case 'Training': return localizations.activityTraining;
      case 'Treat': return localizations.activityTreat;
      case 'Grooming': return localizations.activityGrooming;
      case 'Cleaning': return localizations.activityCleaning;
      case 'Medication': return localizations.activityMedication;
      case 'Vaccination': return localizations.activityVaccination;
      case 'Weight': return localizations.activityWeight;
      case 'Height': return localizations.activityHeight;
      case 'Temperature': return localizations.activityTemperature;
      case 'Health Condition': return localizations.activityHealthCondition;
      case 'Accident': return localizations.activityAccident;
      case 'Journal': return localizations.activityJournal;
      default: return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderNotifier = context.watch<ReminderNotifier>();
    final activityNotifier = context.read<ActivityNotifier>();
    final _ = DateTime.now();

    final reminders = reminderNotifier.reminders.where((r) {
      final scheduled = DateTime.parse(r['scheduledTime']);
      final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;

      final String? activityName = r['activityName'];
      final bool isVisible = activityName != null
          ? activityNotifier.isActivityVisible(widget.selectedPetId, activityName)
          : true;

      return petMatch &&
          scheduled.year == _selectedDate.year &&
          scheduled.month == _selectedDate.month &&
          scheduled.day == _selectedDate.day &&
          isVisible;
    }).toList()
      ..sort((a, b) => DateTime.parse(b['scheduledTime'])
          .compareTo(DateTime.parse(a['scheduledTime'])));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.25),
        //     offset: const Offset(0, 4),
        //     blurRadius: 4,
        //     spreadRadius: 0,
        //   ),
        // ],
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _headerIcon('assets/images/61.png'),
              SizedBox(width: 5.w),
              _headerIcon('assets/images/62.png'),
              SizedBox(width: 5.w),
              _headerIcon('assets/images/63.png'),
              SizedBox(width: 4.w),
              SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: Image.asset('assets/images/a2.png')
              ),
            ],
          ),

          Flexible(
            child: GestureDetector(
              onTap: _showAddReminderSheet,
              child: Text(
                AppLocalizations.of(context)!.reminderAddTitle,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
              onPressed: _showAddReminderSheet,
              icon: SvgPicture.asset('assets/images/add.svg',
                width: 28.w,
                height: 28.h,
              ),
            ),
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
    final formattedDate = DateFormat('EEEE, MMMM d', Localizations.localeOf(context).toString()).format(_selectedDate);

    if (reminders.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/remd.png',
            width: 90.w,
          ),
          SizedBox(height: 20.h),
          Text(AppLocalizations.of(context)!.reminderNone, style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 6.h),
          Text(formattedDate, style:  TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w500,)),
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
    final rawTitle = reminder['activityName'] ?? AppLocalizations.of(context)!.reminderDefaultTitle;
    final title = _getLocalizedActivityName(context, rawTitle);
    final imagePath = reminder['imagePath'];
    final colorValue = reminder['color'];
    final color = colorValue != null ? Color(colorValue) : Colors.orange;
    final reminderId = reminder['id'];
    // 🔥 Detect expired reminder
    final bool isExpired = DateTime.now().isAfter(scheduledTime);
    final Color reminderColor =
    isExpired ? Colors.orange : Theme.of(context).colorScheme.error;
    Activity? activity;
    try {
      activity = activityNotifier.activities.firstWhere(
            (a) => a.reminderId == reminderId,
      );
    } catch (_) {
      // Fallback: Try to find by name and time if ID mismatch
      try {
        activity = activityNotifier.activities.firstWhere(
              (a) => a.name == rawTitle &&
              a.reminderDateTime != null &&
              a.reminderDateTime!.isAtSameMomentAs(scheduledTime),
        );
      } catch (_) {}
    }

    return Dismissible(
        key: Key(reminder['id'] ?? UniqueKey().toString()),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Right swipe - Update
            _showReminderDetailsSheet(
              context,
              reminder,
              activity,
              reminderNotifier,
              activityNotifier,
            );
            return false; // Don't dismiss the item
          } else if (direction == DismissDirection.endToStart) {
            // Left swipe - Remove
            final bool? confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: Text(AppLocalizations.of(context)!.deleteReminderTitle),
                content: Text(AppLocalizations.of(context)!.dialogDeleteActivityContent(_getLocalizedActivityName(context, activity!.name))),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(AppLocalizations.of(context)!.actionDelete),
                  ),
                ],
              ),
            );
            return confirm ?? false;
          }
          return false;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            // Remove reminder without showing dialog again
            _removeReminder(
              reminderNotifier: reminderNotifier,
              activityNotifier: activityNotifier,
              activity: activity,
              reminderId: reminder['id'],
            );
          }
        },
        background: _buildSwipeRightBackground(), // Update - Right swipe
        secondaryBackground: _buildSwipeLeftBackground(), // Remove - Left swipe
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 6),
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
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    DateFormat('EEE MMM d', Localizations.localeOf(context).toString()).format(scheduledTime),
                                    style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.normal, color: Theme.of(context).hintColor),
                                  ),
                                  SizedBox(width: 2.w),
                                   Text("/",style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.normal, color: Theme.of(context).hintColor),),
                                  SizedBox(width: 2.w),
                                  Text(
                                    DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(scheduledTime),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color:reminderColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.notifications,
                                    size: 22.sp,
                                    color: reminderColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              if (activity != null && activity.hasReminder == true) ...[
                                GestureDetector(
                                  onTap: () async {
                                    if (activity != null) {
                                      if (reminderId != null) {
                                        await reminderNotifier.cancelReminder(reminderId);
                                      }

                                      activityNotifier.updateActivity(
                                        activity.copyWith(
                                          hasReminder: false,
                                          reminderDateTime: null,
                                          reminderId: null,
                                          dateTime: scheduledTime,
                                        ),
                                      );

                                      if (context.mounted) {
                                        Provider.of<HomeViewModel>(context, listen: false).calendarTabIndex = 0;
                                      }
                                    }
                                  },
                                  child:  Text("+ Add As Activity",style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.normal, color: AppColors.vibrantPurple),),
                                ),
                              ],

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),),
        ));
                }


  // Swipe background for right swipe (Update)
  Widget _buildSwipeRightBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.vibrantPurple,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            AppLocalizations.of(context)!.actionUpdate,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Swipe background for left swipe (Remove)
  Widget _buildSwipeLeftBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.actionRemove,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.delete,
            color: Colors.white,
            size: 24.sp,
          ),
        ],
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

    final rawTitle = reminder['activityName'] ?? AppLocalizations.of(context)!.reminderDefaultTitle;
    final title = _getLocalizedActivityName(context, rawTitle);
    final imagePath = reminder['imagePath'];
    final colorValue = reminder['color'];
    final color = colorValue != null ? Color(colorValue) : Colors.orange;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (builderContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
// Date Row (Clickable)
                  InkWell(
                    onTap: () async {
                      final bool isDark = Theme.of(context).brightness == Brightness.dark;

                      final DateTime? pickedDate = await showDatePicker(
                        context: builderContext,
                        initialDate: tempScheduledTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.vibrantPurple,
                                onPrimary: Colors.white,
                                surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                onSurface: isDark ? Colors.white : Colors.black,
                                background: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                              ),
                              dialogBackgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 12.w),
                          Text(
                            DateFormat('EEE, MMM d, yyyy', Localizations.localeOf(context).toString()).format(tempScheduledTime),
                            style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16.sp, color: Theme.of(context).hintColor),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

// Time Row (Clickable)
                  InkWell(
                    onTap: () async {
                      final bool isDark = Theme.of(context).brightness == Brightness.dark;
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: builderContext,
                        initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              timePickerTheme: TimePickerThemeData(
                                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                dialBackgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                                dialHandColor: AppColors.vibrantPurple,
                                dialTextColor: MaterialStateColor.resolveWith(
                                      (states) => states.contains(MaterialState.selected)
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : Colors.black87),
                                ),
                                hourMinuteTextColor: MaterialStateColor.resolveWith(
                                      (states) => states.contains(MaterialState.selected)
                                      ? AppColors.vibrantPurple
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                                hourMinuteColor: MaterialStateColor.resolveWith(
                                      (states) => states.contains(MaterialState.selected)
                                      ? AppColors.vibrantPurple.withOpacity(0.2)
                                      : Colors.transparent,
                                ),
                                dayPeriodTextColor: MaterialStateColor.resolveWith(
                                      (states) => states.contains(MaterialState.selected)
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : Colors.black87),
                                ),
                                dayPeriodColor: MaterialStateColor.resolveWith(
                                      (states) => states.contains(MaterialState.selected)
                                      ? AppColors.vibrantPurple
                                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                                ),
                                entryModeIconColor: isDark ? Colors.white70 : Colors.black87,
                              ),
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: AppColors.vibrantPurple,
                                onPrimary: Colors.white,
                                surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                onSurface: isDark ? Colors.white : Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.vibrantPurple,
                                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(tempScheduledTime),
                            style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const Spacer(),
                          Icon(Icons.edit, size: 16.sp, color: Theme.of(context).hintColor),
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
                                  SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdateFailed(e.toString()))),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdateNotFound)),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.vibrantPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: Text(AppLocalizations.of(context)!.actionUpdate, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      // SizedBox(width: 16.w),
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       Navigator.pop(builderContext);
                      //       await _removeReminder(
                      //         reminderNotifier: reminderNotifier,
                      //         activityNotifier: activityNotifier,
                      //         activity: activity,
                      //         reminderId: reminder['id'],
                      //       );
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.red,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.r)),
                      //     ),
                      //     child: Text(AppLocalizations.of(context)!.actionRemove, style: const TextStyle(color: Colors.white)),
                      //   ),
                      // ),
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



  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import 'addreminder.dart';
//
// class AddReminderView extends StatefulWidget {
//   final String? selectedPetId;
//   final DateTime? selectedDate;
//   const AddReminderView({super.key, this.selectedPetId, this.selectedDate});
//
//   @override
//   State<AddReminderView> createState() => _AddReminderViewState();
// }
//
// class _AddReminderViewState extends State<AddReminderView> {
//   late DateTime _selectedDate;
//   Timer? _cleanupTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.selectedDate ?? DateTime.now();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReminderNotifier>().startReminderChecker(context);
//       _startAutoRemoveCheck();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant AddReminderView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.selectedDate != null && widget.selectedDate != oldWidget.selectedDate) {
//       setState(() {
//         _selectedDate = widget.selectedDate!;
//       });
//     }
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
//           a.reminderDateTime!.isBefore(now.subtract(const Duration(minutes: 5))),
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
//   String _getLocalizedActivityName(BuildContext context, String name) {
//     final localizations = AppLocalizations.of(context)!;
//     switch (name) {
//       case 'Veterinary': return localizations.activityVeterinary;
//       case 'Pee': return localizations.activityPee;
//       case 'Eat': return localizations.activityEat;
//       case 'Drink': return localizations.activityDrink;
//       case 'Play': return localizations.activityPlay;
//       case 'Poop': return localizations.activityPoop;
//       case 'Walk': return localizations.activityWalk;
//       case 'Crate': return localizations.activityCrate;
//       case 'Sleep': return localizations.activitySleep;
//       case 'Training': return localizations.activityTraining;
//       case 'Treat': return localizations.activityTreat;
//       case 'Grooming': return localizations.activityGrooming;
//       case 'Cleaning': return localizations.activityCleaning;
//       case 'Medication': return localizations.activityMedication;
//       case 'Vaccination': return localizations.activityVaccination;
//       case 'Weight': return localizations.activityWeight;
//       case 'Height': return localizations.activityHeight;
//       case 'Temperature': return localizations.activityTemperature;
//       case 'Health Condition': return localizations.activityHealthCondition;
//       case 'Accident': return localizations.activityAccident;
//       case 'Journal': return localizations.activityJournal;
//       default: return name;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reminderNotifier = context.watch<ReminderNotifier>();
//     final activityNotifier = context.read<ActivityNotifier>();
//     final _ = DateTime.now();
//
//     final reminders = reminderNotifier.reminders.where((r) {
//       final scheduled = DateTime.parse(r['scheduledTime']);
//       final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;
//
//       final String? activityName = r['activityName'];
//       final bool isVisible = activityName != null
//           ? activityNotifier.isActivityVisible(widget.selectedPetId, activityName)
//           : true;
//
//       return petMatch &&
//           scheduled.year == _selectedDate.year &&
//           scheduled.month == _selectedDate.month &&
//           scheduled.day == _selectedDate.day &&
//           isVisible;
//     }).toList()
//       ..sort((a, b) => DateTime.parse(b['scheduledTime'])
//           .compareTo(DateTime.parse(a['scheduledTime'])));
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
//       margin: EdgeInsets.symmetric(horizontal: 2.w),
//       decoration: BoxDecoration(
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.25),
//         //     offset: const Offset(0, 4),
//         //     blurRadius: 4,
//         //     spreadRadius: 0,
//         //   ),
//         // ],
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 6.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _headerIcon('assets/images/61.png'),
//               SizedBox(width: 5.w),
//               _headerIcon('assets/images/62.png'),
//               SizedBox(width: 5.w),
//               _headerIcon('assets/images/63.png'),
//               SizedBox(width: 4.w),
//               SizedBox(
//                   width: 40.w,
//                   height: 40.h,
//                   child: Image.asset('assets/images/a2.png')
//               ),
//             ],
//           ),
//
//           Flexible(
//             child: GestureDetector(
//               onTap: _showAddReminderSheet,
//               child: Text(
//                 AppLocalizations.of(context)!.reminderAddTitle,
//                 style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           Container(
//             width: 50.w,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//             child: IconButton(
//               onPressed: _showAddReminderSheet,
//               icon: SvgPicture.asset('assets/images/add.svg',
//                 width: 28.w,
//                 height: 28.h,
//               ),
//             ),
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
//         color: Theme.of(context).cardColor,
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
//     final formattedDate = DateFormat('EEEE, MMMM d', Localizations.localeOf(context).toString()).format(_selectedDate);
//
//     if (reminders.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//                  'assets/images/remd.png',
//             width: 90.w,
//           ),
//           SizedBox(height: 20.h),
//           Text(AppLocalizations.of(context)!.reminderNone, style: TextStyle(fontSize: 20.sp, color: Theme.of(context).colorScheme.onSurface)),
//           SizedBox(height: 6.h),
//           Text(formattedDate, style:  TextStyle(color: Theme.of(context).colorScheme.primary)),
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
//     final rawTitle = reminder['activityName'] ?? AppLocalizations.of(context)!.reminderDefaultTitle;
//     final title = _getLocalizedActivityName(context, rawTitle);
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//     final reminderId = reminder['id'];
//
//     Activity? activity;
//     try {
//       activity = activityNotifier.activities.firstWhere(
//             (a) => a.reminderId == reminderId,
//       );
//     } catch (_) {
//       // Fallback: Try to find by name and time if ID mismatch
//       try {
//         activity = activityNotifier.activities.firstWhere(
//               (a) => a.name == rawTitle &&
//               a.reminderDateTime != null &&
//               a.reminderDateTime!.isAtSameMomentAs(scheduledTime),
//         );
//       } catch (_) {}
//     }
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         color: Theme.of(context).cardColor,
//         child: InkWell(
//
//           child: Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50.w,
//                   height: 50.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Theme.of(context).scaffoldBackgroundColor,
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
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       DateFormat('EEE MMM d', Localizations.localeOf(context).toString()).format(scheduledTime),
//                       style: TextStyle(fontSize: 13.sp, color: Theme.of(context).hintColor),
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
//                           child:  Icon(
//                             Icons.notifications,
//                             size: 22.sp,
//                             color: Theme.of(context).colorScheme.error,
//                           ),
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(scheduledTime),
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             color: Theme.of(context).colorScheme.error,
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
//   void _showReminderDetailsSheet(
//       BuildContext context,
//       Map<String, dynamic> reminder,
//       Activity? activity,
//       ReminderNotifier reminderNotifier,
//       ActivityNotifier activityNotifier,
//       ) {
//     final initialScheduledTime = DateTime.parse(reminder['scheduledTime']);
//     DateTime tempScheduledTime = initialScheduledTime;
//
//     final rawTitle = reminder['activityName'] ?? AppLocalizations.of(context)!.reminderDefaultTitle;
//     final title = _getLocalizedActivityName(context, rawTitle);
//     final imagePath = reminder['imagePath'];
//     final colorValue = reminder['color'];
//     final color = colorValue != null ? Color(colorValue) : Colors.orange;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       builder: (builderContext) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setSheetState) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Image and Name
//                   Row(
//                     children: [
//                       Container(
//                         width: 60.w,
//                         height: 60.h,
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         padding: EdgeInsets.all(12.w),
//                         child: imagePath != null
//                             ? Image.asset(imagePath)
//                             : Icon(Icons.notifications, color: color),
//                       ),
//                       SizedBox(width: 16.w),
//                       Text(
//                         title,
//                         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
// // Date Row (Clickable)
//                   InkWell(
//                     onTap: () async {
//                       final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//                       final DateTime? pickedDate = await showDatePicker(
//                         context: builderContext,
//                         initialDate: tempScheduledTime,
//                         firstDate: DateTime.now().subtract(const Duration(days: 365)),
//                         lastDate: DateTime.now().add(const Duration(days: 365)),
//                         builder: (context, child) {
//                           return Theme(
//                             data: Theme.of(context).copyWith(
//                               colorScheme: ColorScheme.light(
//                                 primary: AppColors.vibrantPurple,
//                                 onPrimary: Colors.white,
//                                 surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                                 onSurface: isDark ? Colors.white : Colors.black,
//                                 background: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                               ),
//                               dialogBackgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (pickedDate != null) {
//                         setSheetState(() {
//                           tempScheduledTime = DateTime(
//                             pickedDate.year,
//                             pickedDate.month,
//                             pickedDate.day,
//                             tempScheduledTime.hour,
//                             tempScheduledTime.minute,
//                           );
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
//                           SizedBox(width: 12.w),
//                           Text(
//                             DateFormat('EEE, MMM d, yyyy', Localizations.localeOf(context).toString()).format(tempScheduledTime),
//                             style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
//                           ),
//                           const Spacer(),
//                           Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).hintColor),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 10.h),
//
// // Time Row (Clickable)
//                   InkWell(
//                     onTap: () async {
//                       final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//                       final TimeOfDay? pickedTime = await showTimePicker(
//                         context: builderContext,
//                         initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
//                         builder: (context, child) {
//                           return Theme(
//                             data: Theme.of(context).copyWith(
//                               timePickerTheme: TimePickerThemeData(
//                                 backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                                 dialBackgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
//                                 dialHandColor: AppColors.vibrantPurple,
//                                 dialTextColor: MaterialStateColor.resolveWith(
//                                       (states) => states.contains(MaterialState.selected)
//                                       ? Colors.white
//                                       : (isDark ? Colors.white70 : Colors.black87),
//                                 ),
//                                 hourMinuteTextColor: MaterialStateColor.resolveWith(
//                                       (states) => states.contains(MaterialState.selected)
//                                       ? AppColors.vibrantPurple
//                                       : (isDark ? Colors.white : Colors.black),
//                                 ),
//                                 hourMinuteColor: MaterialStateColor.resolveWith(
//                                       (states) => states.contains(MaterialState.selected)
//                                       ? AppColors.vibrantPurple.withOpacity(0.2)
//                                       : Colors.transparent,
//                                 ),
//                                 dayPeriodTextColor: MaterialStateColor.resolveWith(
//                                       (states) => states.contains(MaterialState.selected)
//                                       ? Colors.white
//                                       : (isDark ? Colors.white70 : Colors.black87),
//                                 ),
//                                 dayPeriodColor: MaterialStateColor.resolveWith(
//                                       (states) => states.contains(MaterialState.selected)
//                                       ? AppColors.vibrantPurple
//                                       : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
//                                 ),
//                                 entryModeIconColor: isDark ? Colors.white70 : Colors.black87,
//                               ),
//                               colorScheme: Theme.of(context).colorScheme.copyWith(
//                                 primary: AppColors.vibrantPurple,
//                                 onPrimary: Colors.white,
//                                 surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                                 onSurface: isDark ? Colors.white : Colors.black,
//                               ),
//                               textButtonTheme: TextButtonThemeData(
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: AppColors.vibrantPurple,
//                                   textStyle: const TextStyle(fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (pickedTime != null) {
//                         setSheetState(() {
//                           tempScheduledTime = DateTime(
//                             tempScheduledTime.year,
//                             tempScheduledTime.month,
//                             tempScheduledTime.day,
//                             pickedTime.hour,
//                             pickedTime.minute,
//                           );
//                         });
//                       }
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8.h),
//                       child: Row(
//                         children: [
//                           Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
//                           SizedBox(width: 8.w),
//                           Text(
//                             DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(tempScheduledTime),
//                             style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
//                           ),
//                           const Spacer(),
//                           Icon(Icons.edit, size: 16, color: Theme.of(context).hintColor),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // // Date Row (Clickable)
//                   // InkWell(
//                   //   onTap: () async {
//                   //     final DateTime? pickedDate = await showDatePicker(
//                   //       context: builderContext,
//                   //       initialDate: tempScheduledTime,
//                   //       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//                   //       lastDate: DateTime.now().add(const Duration(days: 365)),
//                   //       builder: (context, child) {
//                   //         return Theme(
//                   //           data: Theme.of(context).copyWith(
//                   //             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   //               primary: AppColors.vibrantPurple, // Header color
//                   //               onPrimary: Colors.white, // Header text color
//                   //               surface: Theme.of(context).scaffoldBackgroundColor, // Background color
//                   //               onSurface: Theme.of(context).colorScheme.onSurface, // Text color
//                   //             ),
//                   //             dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor, // Background color
//                   //           ),
//                   //           child: child!,
//                   //         );
//                   //       },
//                   //     );
//                   //     if (pickedDate != null) {
//                   //       setSheetState(() {
//                   //         tempScheduledTime = DateTime(
//                   //           pickedDate.year,
//                   //           pickedDate.month,
//                   //           pickedDate.day,
//                   //           tempScheduledTime.hour,
//                   //           tempScheduledTime.minute,
//                   //         );
//                   //       });
//                   //     }
//                   //   },
//                   //   child: Padding(
//                   //     padding: EdgeInsets.symmetric(vertical: 8.h),
//                   //     child: Row(
//                   //       children: [
//                   //         Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
//                   //         SizedBox(width: 8.w),
//                   //         Text(
//                   //           DateFormat('EEE, MMM d, yyyy', Localizations.localeOf(context).toString()).format(tempScheduledTime),
//                   //           style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
//                   //         ),
//                   //         const Spacer(),
//                   //         Icon(Icons.edit, size: 16, color: Theme.of(context).hintColor),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   //
//                   // SizedBox(height: 10.h),
//                   // InkWell(
//                   //   onTap: () async {
//                   //     final TimeOfDay? pickedTime = await showTimePicker(
//                   //       context: builderContext,
//                   //       initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
//                   //       builder: (context, child) {
//                   //         return Theme(
//                   //           data: Theme.of(context).copyWith(
//                   //             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   //               primary: AppColors.vibrantPurple,
//                   //               onPrimary: Colors.white,
//                   //               surface: Theme.of(context).scaffoldBackgroundColor,
//                   //               onSurface: Theme.of(context).colorScheme.onSurface,
//                   //               secondary: AppColors.vibrantPurple,
//                   //               onSecondary: Colors.white,
//                   //             ),
//                   //             dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor, // Background color
//                   //           ),
//                   //           child: child!,
//                   //         );
//                   //       },
//                   //     );
//                   //     if (pickedTime != null) {
//                   //       setSheetState(() {
//                   //         tempScheduledTime = DateTime(
//                   //           tempScheduledTime.year,
//                   //           tempScheduledTime.month,
//                   //           tempScheduledTime.day,
//                   //           pickedTime.hour,
//                   //           pickedTime.minute,
//                   //         );
//                   //       });
//                   //     }
//                   //   },
//                   //   child: Padding(
//                   //     padding: EdgeInsets.symmetric(vertical: 8.h),
//                   //     child: Row(
//                   //       children: [
//                   //         const Icon(Icons.access_time, color: AppColors.vibrantPurple),
//                   //         SizedBox(width: 8.w),
//                   //         Text(
//                   //           DateFormat('hh:mm a', Localizations.localeOf(context).toString()).format(tempScheduledTime),
//                   //           style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.onSurface),
//                   //         ),
//                   //         const Spacer(),
//                   //         Icon(Icons.edit, size: 16, color: Theme.of(context).hintColor),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//
//                   SizedBox(height: 30.h),
//
//                   // Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             Navigator.pop(builderContext);
//                             if (activity != null) {
//                               try {
//                                 await _updateReminderTime(
//                                   activity,
//                                   tempScheduledTime,
//                                   reminderNotifier,
//                                   activityNotifier,
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdateFailed(e.toString()))),
//                                 );
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdateNotFound)),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.r)),
//                           ),
//                           child: Text(AppLocalizations.of(context)!.actionUpdate, style: const TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             Navigator.pop(builderContext);
//                             await _removeReminder(
//                               reminderNotifier: reminderNotifier,
//                               activityNotifier: activityNotifier,
//                               activity: activity,
//                               reminderId: reminder['id'],
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.r)),
//                           ),
//                           child: Text(AppLocalizations.of(context)!.actionRemove, style: const TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//
//   void _showAddReminderSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
// }
//
//
//
//
//
//
// // import 'dart:async';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../View_model/ReminderNotifier.dart';
// // import '../../View_model/activity_provider.dart';
// // import '../../activity_model.dart';
// // import 'addreminder.dart';
// //
// // class AddReminderView extends StatefulWidget {
// //   final String? selectedPetId;
// //   const AddReminderView({super.key, this.selectedPetId});
// //
// //   @override
// //   State<AddReminderView> createState() => _AddReminderViewState();
// // }
// //
// // class _AddReminderViewState extends State<AddReminderView> {
// //   final DateTime _selectedDate = DateTime.now();
// //   Timer? _cleanupTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<ReminderNotifier>().startReminderChecker(context);
// //       _startAutoRemoveCheck();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _cleanupTimer?.cancel();
// //     super.dispose();
// //   }
// //
// //   void _startAutoRemoveCheck() {
// //     _checkAndRemoveExpiredReminders();
// //     _cleanupTimer =
// //         Timer.periodic(const Duration(seconds: 30), (_) => _checkAndRemoveExpiredReminders());
// //   }
// //
// //   void _checkAndRemoveExpiredReminders() async {
// //     if (!mounted) return;
// //
// //     final activityNotifier = context.read<ActivityNotifier>();
// //     final reminderNotifier = context.read<ReminderNotifier>();
// //     final now = DateTime.now();
// //
// //     final expiredActivities = activityNotifier.activities.where(
// //           (a) =>
// //       a.hasReminder &&
// //           a.reminderDateTime != null &&
// //           a.reminderDateTime!.isBefore(now),
// //     );
// //
// //     for (final activity in expiredActivities) {
// //       await _removeReminder(
// //         reminderNotifier: reminderNotifier,
// //         activityNotifier: activityNotifier,
// //         activity: activity,
// //         silent: true,
// //       );
// //     }
// //   }
// //
// //   Future<void> _updateReminderTime(
// //       Activity activity,
// //       DateTime newTime,
// //       ReminderNotifier reminderNotifier,
// //       ActivityNotifier activityNotifier,
// //       ) async {
// //     // 1. Cancel old reminder
// //     if (activity.reminderId != null) {
// //       await reminderNotifier.cancelReminder(activity.reminderId!);
// //     }
// //
// //     // 2. Schedule new reminder
// //     final newId = await reminderNotifier.scheduleReminder(
// //       activity: activity,
// //       reminderDateTime: newTime,
// //     );
// //
// //     // 3. Update activity
// //     activityNotifier.updateActivity(
// //       activity.copyWith(
// //         hasReminder: true,
// //         reminderDateTime: newTime,
// //         reminderId: newId,
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final reminderNotifier = context.watch<ReminderNotifier>();
// //     final activityNotifier = context.read<ActivityNotifier>();
// //     final now = DateTime.now();
// //
// //     final reminders = reminderNotifier.reminders.where((r) {
// //       final scheduled = DateTime.parse(r['scheduledTime']);
// //       final petMatch = widget.selectedPetId == null || r['petId'] == widget.selectedPetId;
// //
// //       return petMatch &&
// //           scheduled.year == _selectedDate.year &&
// //           scheduled.month == _selectedDate.month &&
// //           scheduled.day == _selectedDate.day &&
// //           scheduled.isAfter(now);
// //     }).toList()
// //       ..sort((a, b) => DateTime.parse(b['scheduledTime'])
// //           .compareTo(DateTime.parse(a['scheduledTime'])));
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Column(
// //         children: [
// //           _buildHeader(),
// //           Expanded(
// //             child: _buildReminderList(
// //               reminders,
// //               reminderNotifier,
// //               activityNotifier,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // ================= HEADER =================
// //
// //   Widget _buildHeader() {
// //     return Container(
// //       height: 70.h,
// //       margin: EdgeInsets.symmetric(horizontal: 8.w),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF4F7F6),
// //         borderRadius: BorderRadius.circular(16.r),
// //       ),
// //       padding: EdgeInsets.symmetric(horizontal: 16.w),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             children: [
// //               _headerIcon('assets/images/61.png'),
// //               SizedBox(width: 8.w),
// //               _headerIcon('assets/images/62.png'),
// //               SizedBox(width: 8.w),
// //               _headerIcon('assets/images/63.png'),
// //               SizedBox(width: 6.w),
// //               SizedBox(
// //                   width: 40.w,
// //                   height: 40.h,
// //                   child: Image.asset('assets/images/a2.png')
// //               ),
// //             ],
// //           ),
// //           GestureDetector(
// //             onTap: _showAddReminderSheet,
// //             child: Text(
// //               'Add Reminder',
// //               style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //           IconButton(
// //             onPressed: _showAddReminderSheet,
// //             icon: SvgPicture.asset('assets/images/add.svg', width: 28.w),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _headerIcon(String path) {
// //     return Container(
// //       width: 40.w,
// //       height: 40.h,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12.r),
// //       ),
// //       padding: EdgeInsets.all(8.w),
// //       child: Image.asset(path),
// //     );
// //   }
// //
// //   // ================= REMINDER LIST =================
// //
// //   Widget _buildReminderList(
// //       List<Map<String, dynamic>> reminders,
// //       ReminderNotifier reminderNotifier,
// //       ActivityNotifier activityNotifier,
// //       ) {
// //     final formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);
// //
// //     if (reminders.isEmpty) {
// //       return Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Image.asset('assets/images/images136.png', width: 120.w),
// //           SizedBox(height: 20.h),
// //           Text('No Reminders', style: TextStyle(fontSize: 20.sp)),
// //           SizedBox(height: 6.h),
// //           Text(formattedDate, style: const TextStyle(color: Colors.grey)),
// //         ],
// //       );
// //     }
// //
// //     return ListView(
// //       padding: EdgeInsets.only(top: 12.h),
// //       children: reminders.map(
// //             (r) => _buildReminderCard(
// //           r,
// //           reminderNotifier,
// //           activityNotifier,
// //         ),
// //       ).toList(),
// //     );
// //   }
// //
// //   Widget _buildReminderCard(
// //       Map<String, dynamic> reminder,
// //       ReminderNotifier reminderNotifier,
// //       ActivityNotifier activityNotifier,
// //       ) {
// //     final scheduledTime = DateTime.parse(reminder['scheduledTime']);
// //     final title = reminder['activityName'] ?? 'Reminder';
// //     final imagePath = reminder['imagePath'];
// //     final colorValue = reminder['color'];
// //     final color = colorValue != null ? Color(colorValue) : Colors.orange;
// //     final reminderId = reminder['id'];
// //
// //     Activity? activity;
// //     try {
// //       activity = activityNotifier.activities.firstWhere(
// //             (a) => a.reminderId == reminderId,
// //       );
// //     } catch (_) {
// //       // Fallback: Try to find by name and time if ID mismatch
// //       try {
// //         activity = activityNotifier.activities.firstWhere(
// //               (a) => a.name == title &&
// //               a.reminderDateTime != null &&
// //               a.reminderDateTime!.isAtSameMomentAs(scheduledTime),
// //         );
// //       } catch (_) {}
// //     }
// //
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
// //       child: Card(
// //         elevation: 0,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(10.r),
// //         ),
// //         color: const Color(0xFFF4F7F6),
// //         child: InkWell(
// //           // onTap: activity != null
// //           //     ? () async {
// //           //   final TimeOfDay? picked = await showTimePicker(
// //           //     context: context,
// //           //     initialTime: TimeOfDay.fromDateTime(scheduledTime),
// //           //   );
// //           //   if (picked != null) {
// //           //     final newDateTime = DateTime(
// //           //       _selectedDate.year,
// //           //       _selectedDate.month,
// //           //       _selectedDate.day,
// //           //       picked.hour,
// //           //       picked.minute,
// //           //     );
// //           //
// //           //     try {
// //           //       await _updateReminderTime(
// //           //         activity!,
// //           //         newDateTime,
// //           //         reminderNotifier,
// //           //         activityNotifier,
// //           //       );
// //           //     } catch (e) {
// //           //       if (context.mounted) {
// //           //         ScaffoldMessenger.of(context).showSnackBar(
// //           //           SnackBar(content: Text('Failed to update: $e')),
// //           //         );
// //           //       }
// //           //     }
// //           //   }
// //           // }
// //           //     : null,
// //           child: Padding(
// //             padding: EdgeInsets.all(12.w),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 50.w,
// //                   height: 50.h,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.white,
// //                   ),
// //                   child: Center(
// //                     child: ClipOval(
// //                       child: imagePath != null
// //                           ? Image.asset(
// //                         imagePath,
// //                         width: 35.w,
// //                         height: 35.h,
// //                         fit: BoxFit.contain,
// //                         errorBuilder: (_, __, ___) =>
// //                             Icon(Icons.pets, color: color, size: 24.w),
// //                       )
// //                           : Icon(Icons.notifications_active,
// //                           color: color, size: 24.w),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 12.w),
// //                 Expanded(
// //                   child: Text(
// //                     title,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     Text(
// //                       DateFormat('EEE MMM d').format(scheduledTime),
// //                       style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
// //                     ),
// //                     SizedBox(height: 4.h),
// //                     Row(
// //                       children: [
// //                         GestureDetector(
// //                           onTap: () {
// //                             _showReminderDetailsSheet(
// //                               context,
// //                               reminder,
// //                               activity,
// //                               reminderNotifier,
// //                               activityNotifier,
// //                             );
// //                           },
// //                           child:  Icon(
// //                             Icons.notifications,
// //                             size: 22.sp,
// //                             color: Colors.red,
// //                           ),
// //                         ),
// //                         SizedBox(width: 4.w),
// //                         Text(
// //                           DateFormat('hh:mm a').format(scheduledTime),
// //                           style: TextStyle(
// //                             fontSize: 16.sp,
// //                             color: Colors.red,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showReminderDetailsSheet(
// //       BuildContext context,
// //       Map<String, dynamic> reminder,
// //       Activity? activity,
// //       ReminderNotifier reminderNotifier,
// //       ActivityNotifier activityNotifier,
// //       ) {
// //     final initialScheduledTime = DateTime.parse(reminder['scheduledTime']);
// //     DateTime tempScheduledTime = initialScheduledTime;
// //
// //     final title = reminder['activityName'] ?? 'Reminder';
// //     final imagePath = reminder['imagePath'];
// //     final colorValue = reminder['color'];
// //     final color = colorValue != null ? Color(colorValue) : Colors.orange;
// //
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.white,
// //       builder: (builderContext) {
// //         return StatefulBuilder(
// //           builder: (BuildContext context, StateSetter setSheetState) {
// //             return Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
// //               ),
// //               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // Image and Name
// //                   Row(
// //                     children: [
// //                       Container(
// //                         width: 60.w,
// //                         height: 60.h,
// //                         decoration: BoxDecoration(
// //                           color: color.withOpacity(0.2),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         padding: EdgeInsets.all(12.w),
// //                         child: imagePath != null
// //                             ? Image.asset(imagePath)
// //                             : Icon(Icons.notifications, color: color),
// //                       ),
// //                       SizedBox(width: 16.w),
// //                       Text(
// //                         title,
// //                         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 20.h),
// //
// //                   // Date Row (Clickable)
// //                   InkWell(
// //                     onTap: () async {
// //                       final DateTime? pickedDate = await showDatePicker(
// //                         context: builderContext,
// //                         initialDate: tempScheduledTime,
// //                         firstDate: DateTime.now().subtract(const Duration(days: 365)),
// //                         lastDate: DateTime.now().add(const Duration(days: 365)),
// //                         builder: (context, child) {
// //                           return Theme(
// //                             data: Theme.of(context).copyWith(
// //                               colorScheme: const ColorScheme.light(
// //                                 primary: AppColors.vibrantPurple, // Header color
// //                                 onPrimary: Colors.white, // Header text color
// //                                 surface: Colors.white, // Background color
// //                                 onSurface: Colors.black, // Text color
// //                               ),
// //                               dialogBackgroundColor: Colors.white, // Background color
// //                             ),
// //                             child: child!,
// //                           );
// //                         },
// //                       );
// //                       if (pickedDate != null) {
// //                         setSheetState(() {
// //                           tempScheduledTime = DateTime(
// //                             pickedDate.year,
// //                             pickedDate.month,
// //                             pickedDate.day,
// //                             tempScheduledTime.hour,
// //                             tempScheduledTime.minute,
// //                           );
// //                         });
// //                       }
// //                     },
// //                     child: Padding(
// //                       padding: EdgeInsets.symmetric(vertical: 8.h),
// //                       child: Row(
// //                         children: [
// //                           const Icon(Icons.calendar_today, color: Colors.blue),
// //                           SizedBox(width: 8.w),
// //                           Text(
// //                             DateFormat('EEE, MMM d, yyyy').format(tempScheduledTime),
// //                             style: TextStyle(fontSize: 16.sp, color: Colors.black87),
// //                           ),
// //                           const Spacer(),
// //                           const Icon(Icons.edit, size: 16, color: Colors.grey),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //
// //                   SizedBox(height: 10.h),
// //                   InkWell(
// //                     onTap: () async {
// //                       final TimeOfDay? pickedTime = await showTimePicker(
// //                         context: builderContext,
// //                         initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
// //                         builder: (context, child) {
// //                           return Theme(
// //                             data: Theme.of(context).copyWith(
// //                               colorScheme: const ColorScheme.light(
// //                                 primary: AppColors.vibrantPurple,
// //                                 onPrimary: Colors.white,
// //                                 surface: Colors.white,
// //                                 onSurface: Colors.black,
// //                                 secondary: AppColors.vibrantPurple,
// //                                 onSecondary: Colors.white,
// //
// //                               ),
// //                               dialogBackgroundColor: Colors.white, // Background color
// //                             ),
// //                             child: child!,
// //                           );
// //                         },
// //                       );
// //                       if (pickedTime != null) {
// //                         setSheetState(() {
// //                           tempScheduledTime = DateTime(
// //                             tempScheduledTime.year,
// //                             tempScheduledTime.month,
// //                             tempScheduledTime.day,
// //                             pickedTime.hour,
// //                             pickedTime.minute,
// //                           );
// //                         });
// //                       }
// //                     },
// //                     child: Padding(
// //                       padding: EdgeInsets.symmetric(vertical: 8.h),
// //                       child: Row(
// //                         children: [
// //                           const Icon(Icons.access_time, color: AppColors.vibrantPurple),
// //                           SizedBox(width: 8.w),
// //                           Text(
// //                             DateFormat('hh:mm a').format(tempScheduledTime),
// //                             style: TextStyle(fontSize: 16.sp, color: Colors.black87),
// //                           ),
// //                           const Spacer(),
// //                           const Icon(Icons.edit, size: 16, color: Colors.grey),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //
// //                   SizedBox(height: 30.h),
// //
// //                   // Buttons
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           onPressed: () async {
// //                             Navigator.pop(builderContext);
// //                             if (activity != null) {
// //                               try {
// //                                 await _updateReminderTime(
// //                                   activity,
// //                                   tempScheduledTime,
// //                                   reminderNotifier,
// //                                   activityNotifier,
// //                                 );
// //                               } catch (e) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(content: Text('Failed to update: $e')),
// //                                 );
// //                               }
// //                             } else {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(content: Text('Cannot update: Activity not found')),
// //                               );
// //                             }
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.blue,
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10.r)),
// //                           ),
// //                           child: const Text('Update', style: TextStyle(color: Colors.white)),
// //                         ),
// //                       ),
// //                       SizedBox(width: 16.w),
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           onPressed: () async {
// //                             Navigator.pop(builderContext);
// //                             await _removeReminder(
// //                               reminderNotifier: reminderNotifier,
// //                               activityNotifier: activityNotifier,
// //                               activity: activity,
// //                               reminderId: reminder['id'],
// //                             );
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.red,
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10.r)),
// //                           ),
// //                           child: const Text('Remove', style: TextStyle(color: Colors.white)),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 20.h),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //
// //   // void _showReminderDetailsSheet(
// //   //     BuildContext context,
// //   //     Map<String, dynamic> reminder,
// //   //     Activity? activity,
// //   //     ReminderNotifier reminderNotifier,
// //   //     ActivityNotifier activityNotifier,
// //   //     ) {
// //   //   final initialScheduledTime = DateTime.parse(reminder['scheduledTime']);
// //   //   // Mutable variable for the sheet
// //   //   DateTime tempScheduledTime = initialScheduledTime;
// //   //
// //   //   final title = reminder['activityName'] ?? 'Reminder';
// //   //   final imagePath = reminder['imagePath'];
// //   //   final colorValue = reminder['color'];
// //   //   final color = colorValue != null ? Color(colorValue) : Colors.orange;
// //   //
// //   //   showModalBottomSheet(
// //   //     context: context,
// //   //     backgroundColor: Colors.white,
// //   //     builder: (builderContext) {
// //   //       return StatefulBuilder(
// //   //         builder: (BuildContext context, StateSetter setSheetState) {
// //   //           return Container(
// //   //             decoration: BoxDecoration(
// //   //               color: Colors.white,
// //   //               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
// //   //             ),
// //   //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
// //   //             child: Column(
// //   //               mainAxisSize: MainAxisSize.min,
// //   //               children: [
// //   //                 // Image and Name
// //   //                 Row(
// //   //                   children: [
// //   //                     Container(
// //   //                       width: 60.w,
// //   //                       height: 60.h,
// //   //                       decoration: BoxDecoration(
// //   //                         color: color.withOpacity(0.2),
// //   //                         shape: BoxShape.circle,
// //   //                       ),
// //   //                       padding: EdgeInsets.all(12.w),
// //   //                       child: imagePath != null
// //   //                           ? Image.asset(imagePath)
// //   //                           : Icon(Icons.notifications, color: color),
// //   //                     ),
// //   //                     SizedBox(width: 16.w),
// //   //                     Text(
// //   //                       title,
// //   //                       style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
// //   //                     ),
// //   //                   ],
// //   //                 ),
// //   //                 SizedBox(height: 20.h),
// //   //
// //   //                 // Date Row (Clickable)
// //   //                 InkWell(
// //   //                   onTap: () async {
// //   //                     final DateTime? pickedDate = await showDatePicker(
// //   //                       context: builderContext,
// //   //                       initialDate: tempScheduledTime,
// //   //                       firstDate: DateTime.now().subtract(const Duration(days: 365)),
// //   //                       lastDate: DateTime.now().add(const Duration(days: 365)),
// //   //                     );
// //   //                     if (pickedDate != null) {
// //   //                       setSheetState(() {
// //   //                         tempScheduledTime = DateTime(
// //   //                           pickedDate.year,
// //   //                           pickedDate.month,
// //   //                           pickedDate.day,
// //   //                           tempScheduledTime.hour,
// //   //                           tempScheduledTime.minute,
// //   //                         );
// //   //                       });
// //   //                     }
// //   //                   },
// //   //                   child: Padding(
// //   //                     padding: EdgeInsets.symmetric(vertical: 8.h),
// //   //                     child: Row(
// //   //                       children: [
// //   //                         const Icon(Icons.calendar_today, color: Colors.blue),
// //   //                         SizedBox(width: 8.w),
// //   //                         Text(
// //   //                           DateFormat('EEE, MMM d, yyyy').format(tempScheduledTime),
// //   //                           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
// //   //                         ),
// //   //                         const Spacer(),
// //   //                         const Icon(Icons.edit, size: 16, color: Colors.grey),
// //   //                       ],
// //   //                     ),
// //   //                   ),
// //   //                 ),
// //   //
// //   //                 SizedBox(height: 10.h),
// //   //                 InkWell(
// //   //                   onTap: () async {
// //   //                     final TimeOfDay? pickedTime = await showTimePicker(
// //   //                       context: builderContext,
// //   //                       initialTime: TimeOfDay.fromDateTime(tempScheduledTime),
// //   //                     );
// //   //                     if (pickedTime != null) {
// //   //                       setSheetState(() {
// //   //                         tempScheduledTime = DateTime(
// //   //                           tempScheduledTime.year,
// //   //                           tempScheduledTime.month,
// //   //                           tempScheduledTime.day,
// //   //                           pickedTime.hour,
// //   //                           pickedTime.minute,
// //   //                         );
// //   //                       });
// //   //                     }
// //   //                   },
// //   //                   child: Padding(
// //   //                     padding: EdgeInsets.symmetric(vertical: 8.h),
// //   //                     child: Row(
// //   //                       children: [
// //   //                         const Icon(Icons.access_time, color: Colors.blue),
// //   //                         SizedBox(width: 8.w),
// //   //                         Text(
// //   //                           DateFormat('hh:mm a').format(tempScheduledTime),
// //   //                           style: TextStyle(fontSize: 16.sp, color: Colors.black87),
// //   //                         ),
// //   //                         const Spacer(),
// //   //                         const Icon(Icons.edit, size: 16, color: Colors.grey),
// //   //                       ],
// //   //                     ),
// //   //                   ),
// //   //                 ),
// //   //
// //   //                 SizedBox(height: 30.h),
// //   //
// //   //                 // Buttons
// //   //                 Row(
// //   //                   children: [
// //   //                     Expanded(
// //   //                       child: ElevatedButton(
// //   //                         onPressed: () async {
// //   //                           Navigator.pop(builderContext);
// //   //                           if (activity != null) {
// //   //                             try {
// //   //                               await _updateReminderTime(
// //   //                                 activity,
// //   //                                 tempScheduledTime,
// //   //                                 reminderNotifier,
// //   //                                 activityNotifier,
// //   //                               );
// //   //                             } catch (e) {
// //   //                               // Show error if update fails
// //   //                               ScaffoldMessenger.of(context).showSnackBar(
// //   //                                 SnackBar(content: Text('Failed to update: $e')),
// //   //                               );
// //   //                             }
// //   //                           } else {
// //   //                             ScaffoldMessenger.of(context).showSnackBar(
// //   //                               const SnackBar(content: Text('Cannot update: Activity not found')),
// //   //                             );
// //   //                           }
// //   //                         },
// //   //                         style: ElevatedButton.styleFrom(
// //   //                           backgroundColor: Colors.blue,
// //   //                           shape: RoundedRectangleBorder(
// //   //                               borderRadius: BorderRadius.circular(10.r)),
// //   //                         ),
// //   //                         child: const Text('Update', style: TextStyle(color: Colors.white)),
// //   //                       ),
// //   //                     ),
// //   //                     SizedBox(width: 16.w),
// //   //                     Expanded(
// //   //                       child: ElevatedButton(
// //   //                         onPressed: () async {
// //   //                           Navigator.pop(builderContext);
// //   //                           await _removeReminder(
// //   //                             reminderNotifier: reminderNotifier,
// //   //                             activityNotifier: activityNotifier,
// //   //                             activity: activity,
// //   //                             reminderId: reminder['id'], // Use 'id' from reminder map
// //   //                           );
// //   //                         },
// //   //                         style: ElevatedButton.styleFrom(
// //   //                           backgroundColor: Colors.red,
// //   //                           shape: RoundedRectangleBorder(
// //   //                               borderRadius: BorderRadius.circular(10.r)),
// //   //                         ),
// //   //                         child: const Text('Remove', style: TextStyle(color: Colors.white)),
// //   //                       ),
// //   //                     ),
// //   //                   ],
// //   //                 ),
// //   //                 SizedBox(height: 20.h),
// //   //               ],
// //   //             ),
// //   //           );
// //   //         },
// //   //       );
// //   //     },
// //   //   );
// //   // }
// //
// //   // ================= ADD REMINDER =================
// //
// //   void _showAddReminderSheet() {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.white,
// //       builder: (_) => SizedBox(
// //         height: MediaQuery.of(context).size.height * 0.9,
// //         child: Addreminder(
// //           initialDate: _selectedDate,
// //           selectedPetId: widget.selectedPetId,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ================= REMOVE REMINDER =================
// //
// //   Future<void> _removeReminder({
// //     required ReminderNotifier reminderNotifier,
// //     required ActivityNotifier activityNotifier,
// //     Activity? activity,
// //     String? reminderId,
// //     bool silent = false,
// //   }) async {
// //     final idToCancel = reminderId ?? activity?.reminderId;
// //     if (idToCancel != null) {
// //       await reminderNotifier.cancelReminder(idToCancel);
// //     }
// //
// //     if (activity != null) {
// //       activityNotifier.updateActivity(
// //         activity.copyWith(
// //           hasReminder: false,
// //           reminderDateTime: null,
// //           reminderId: null,
// //         ),
// //       );
// //     }
// //   }
// //
// //
// // }
// //
// //
