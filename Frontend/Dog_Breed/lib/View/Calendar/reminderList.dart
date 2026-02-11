
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/Valid/AppTheme.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/home/home_view_model.dart';
import '../../activity_model.dart';
import '../../config/components/CustomDatePicker.dart';
import '../../utils/routes/routes_name.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class Reminderlist extends StatefulWidget {
  final Activity? selectedActivity;
  final DateTime? initialDate;
  final String? selectedPetId;

  const Reminderlist({
    super.key,
    this.selectedActivity,
    this.initialDate,
    this.selectedPetId,
  });

  @override
  State<Reminderlist> createState() => _ReminderlistState();
}

class _ReminderlistState extends State<Reminderlist> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  File? _selectedImage;
  File? _selectedVideo;

  Activity? _currentActivity;

  final double _drinkQuantityOz = 0.0;
  final bool _isOzUnit = true;

  final double _walkDistanceKm = 0.0;
  final bool _isKmUnit = true;

  final double _weightValue = 1.0;
  final bool _isLbsUnit = true;

  final double _heightValue = 1.0;
  final bool _isInchesUnit = true;

  final double _temperatureValue = 100.0;
  final bool _isFahrenheitUnit = true;

  bool _hasReminder = false;

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.selectedActivity;

    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    } else if (_currentActivity != null) {
      _selectedDate = _currentActivity!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(_currentActivity!.dateTime);
    }

    // If editing existing activity with reminder, populate values
    if (_currentActivity?.hasReminder == true) {
      _hasReminder = true;
    }

    final int totalMinutes =
        _selectedTime.hour * 60 + _selectedTime.minute + 60;
    final int _ = totalMinutes ~/ 60 % 24;
    final int _ = totalMinutes % 60;
  }

  // Reminder date selection



  void _selectDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(initialDate: _selectedDate),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }


  Future<void> _selectTime() async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor:
              isDark ? const Color(0xFF1E1E1E) : Colors.white,

              // Dial
              dialBackgroundColor:
              isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF2F2F2),
              dialHandColor: AppColors.vibrantPurple,
              dialTextColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),

              // Hour / Minute
              hourMinuteTextColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? AppColors.vibrantPurple
                    : (isDark ? Colors.white : Colors.black),
              ),
              hourMinuteColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? AppColors.vibrantPurple.withOpacity(0.15)
                    : Colors.transparent,
              ),

              // AM / PM
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

              entryModeIconColor:
              isDark ? Colors.white70 : Colors.black87,
            ),

            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.vibrantPurple,
              onPrimary: Colors.white,
              surface:
              isDark ? const Color(0xFF1E1E1E) : Colors.white,
              onSurface:
              isDark ? Colors.white : Colors.black,
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.vibrantPurple,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }


  void _saveActivity() async {
    final localizations = AppLocalizations.of(context)!;
    if (_currentActivity == null) {
      _showErrorSnackBar(localizations.errorSelectActivity);
      return;
    }

    // Always enable reminder for this view and use selected date/time
    _hasReminder = true;
    DateTime? reminderDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (reminderDateTime.isBefore(DateTime.now())) {
      _showErrorSnackBar(localizations.errorReminderFuture);
      return;
    }

    String? foodValue;
    final String activityName = _currentActivity!.name.toLowerCase();

    if (activityName == 'drink') {
      const double ozToMl = 29.5735;
      double amount = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;
      foodValue = '${amount.toStringAsFixed(1)} ${_isOzUnit ? localizations.unitOz : localizations.unitMl}';
      if (_foodController.text.trim().isNotEmpty) {
        foodValue = '$foodValue ${_foodController.text.trim()}';
      }
    } else if (activityName == 'weight') {
      if (_weightValue <= 0) {
        _showErrorSnackBar(localizations.errorValidWeight);
        return;
      }
      foodValue =
      '${_weightValue.toStringAsFixed(1)} ${_isLbsUnit ? localizations.unitLbs : localizations.unitKg}';
    } else if (activityName == 'height') {
      if (_heightValue <= 0) {
        _showErrorSnackBar(localizations.errorValidHeight);
        return;
      }
      foodValue =
      '${_heightValue.toStringAsFixed(1)} ${_isInchesUnit ? localizations.unitInches : localizations.unitCm}';
    } else if (activityName == 'temperature') {
      if (_temperatureValue <= 0) {
        _showErrorSnackBar(localizations.errorValidTemp);
        return;
      }
      foodValue =
      '${_temperatureValue.toStringAsFixed(1)} ${_isFahrenheitUnit ? localizations.unitF : localizations.unitC}';
    } else if (['walk', 'play', 'crate'].contains(activityName)) {
      const double kmToMi = 0.621371;
      double amount = _isKmUnit ? _walkDistanceKm : _walkDistanceKm * kmToMi;
      foodValue = '${amount.toStringAsFixed(1)} ${_isKmUnit ? localizations.unitKm : localizations.unitMi}';
    } else {
      // if (activityName == 'eat') {
      //   if (_foodController.text.trim().isEmpty) {
      //     _showErrorSnackBar(localizations.errorEnterFood);
      //     return;
      //   }
      // }
      // if (_foodController.text.trim().isNotEmpty) {
      //   foodValue = _foodController.text.trim();
      // }


    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.vibrantPurple),
      ),
    );

    try {
      DateTime activityDateTime;

      // Always use selected date/time for the activity when setting a reminder
      // This ensures consistency between the reminder time and activity time
      activityDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newActivity = Activity(
        name: _currentActivity!.name,
        imagePath: _currentActivity!.imagePath,
        color: _currentActivity!.color,
        food: foodValue,
        dateTime: activityDateTime,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        imagePathLocal: _selectedImage?.path,
        videoPathLocal: _selectedVideo?.path,
        hasReminder: _hasReminder,
        reminderDateTime: reminderDateTime,
        reminderId: _currentActivity?.reminderId,
        petId: _currentActivity?.petId ?? widget.selectedPetId,
      );

      final activityNotifier = Provider.of<ActivityNotifier>(
        context,
        listen: false,
      );

      final reminderNotifier = Provider.of<ReminderNotifier>(
        context,
        listen: false,
      );

      // Save activity
      activityNotifier.addActivity(newActivity);

      // Schedule reminder if set
      if (_hasReminder) {
        final reminderId = await reminderNotifier.scheduleReminder(
          activity: newActivity,
          reminderDateTime: reminderDateTime,
        );

        // Update activity with reminder ID
        final updatedActivity = newActivity.copyWith(reminderId: reminderId);
        activityNotifier.updateActivity(updatedActivity);
      } else if (!_hasReminder && _currentActivity?.reminderId != null) {
        // Cancel existing reminder if removed
        await reminderNotifier.cancelReminder(_currentActivity!.reminderId!);
      }

      Navigator.pop(context); // close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _hasReminder
                ? localizations.successActivitySavedReminder
                : localizations.successActivitySaved,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.selectedIndex = 1; // Index for Calendar
      homeViewModel.calendarTabIndex = 1; // Index for AddReminderView
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);

      // Future.delayed(const Duration(milliseconds: 800), () {
      //   if (context.mounted) {
      //     final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      //     homeViewModel.selectedIndex = 1; // Index for Calendar
      //     Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);
      //   }
      // });
    } catch (e) {
      Navigator.pop(context);
      _showErrorSnackBar(localizations.errorSaveFailed(e.toString()));
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildActivityImage() {
    if (_currentActivity != null) {
      return Container(
        width: 90.w,
        height: 90.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: ClipOval(
            child: Image.asset(
              _currentActivity!.imagePath,
              width: 70.w,
              height: 70.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.pets, color: _currentActivity!.color),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Icon(
        CupertinoIcons.photo,
        size: 32,
        color: Theme.of(context).hintColor,
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
    final dateFormat = DateFormat.yMd(Localizations.localeOf(context).toString());
    final timeFormat = DateFormat.jm(Localizations.localeOf(context).toString());
    final String _ = _currentActivity?.name.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(CupertinoIcons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveActivity,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(CupertinoIcons.check_mark, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildActivityImage(),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        _currentActivity != null
                            ? _getLocalizedActivityName(
                                context, _currentActivity!.name)
                            : AppLocalizations.of(context)!.noActivitySelected,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),


              Text(
                AppLocalizations.of(context)!.labelDate,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateFormat.format(_selectedDate),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.onSurface),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Text(
                AppLocalizations.of(context)!.labelTime,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeFormat.format(
                          DateTime(
                            2000,
                            1,
                            1,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(Icons.access_time, color: Theme.of(context).colorScheme.onSurface),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 416.h),

              RoundButton(
                title: AppLocalizations.of(context)!.actionSave,
                isSelected: true,
                textColors: Colors.white,
                backgroundColors: AppColors.vibrantPurple,
                onPress: _saveActivity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
