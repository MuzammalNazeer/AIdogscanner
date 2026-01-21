
import 'package:dog_breed/Valid/AppColors.dart';
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

  // Activity time selection
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF820DFF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF820DFF),
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
    if (_currentActivity == null) {
      _showErrorSnackBar('Please select an activity first');
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
      _showErrorSnackBar('Reminder time must be in the future');
      return;
    }

    String? foodValue;
    final String activityName = _currentActivity!.name.toLowerCase();

    if (activityName == 'drink') {
      const double ozToMl = 29.5735;
      double amount = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;
      foodValue = '${amount.toStringAsFixed(1)} ${_isOzUnit ? 'oz' : 'ml'}';
      if (_foodController.text.trim().isNotEmpty) {
        foodValue = '$foodValue ${_foodController.text.trim()}';
      }
    } else if (activityName == 'weight') {
      if (_weightValue <= 0) {
        _showErrorSnackBar('Please enter a valid weight');
        return;
      }
      foodValue =
      '${_weightValue.toStringAsFixed(1)} ${_isLbsUnit ? 'lbs' : 'kg'}';
    } else if (activityName == 'height') {
      if (_heightValue <= 0) {
        _showErrorSnackBar('Please enter a valid height');
        return;
      }
      foodValue =
      '${_heightValue.toStringAsFixed(1)} ${_isInchesUnit ? 'Inches' : 'cm'}';
    } else if (activityName == 'temperature') {
      if (_temperatureValue <= 0) {
        _showErrorSnackBar('Please enter a valid temperature');
        return;
      }
      foodValue =
      '${_temperatureValue.toStringAsFixed(1)} ${_isFahrenheitUnit ? '°F' : '°C'}';
    } else if (['walk', 'play', 'crate'].contains(activityName)) {
      const double kmToMi = 0.621371;
      double amount = _isKmUnit ? _walkDistanceKm : _walkDistanceKm * kmToMi;
      foodValue = '${amount.toStringAsFixed(1)} ${_isKmUnit ? 'km' : 'mi'}';
    } else {
      if (activityName == 'eat') {
        if (_foodController.text.trim().isEmpty) {
          _showErrorSnackBar('Please enter food name or type');
          return;
        }
      }
      if (_foodController.text.trim().isNotEmpty) {
        foodValue = _foodController.text.trim();
      }


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
      if (_hasReminder && reminderDateTime != null) {
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
            'Activity ${_hasReminder ? 'with reminder ' : ''}saved successfully!',
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
      _showErrorSnackBar('Failed to save: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
              color: Colors.black.withOpacity(0.1),
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.systemGrey4,
      ),
      child: const Icon(
        CupertinoIcons.photo,
        size: 32,
        color: CupertinoColors.systemGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM-dd-yyyy');
    final timeFormat = DateFormat('HH:mm');
    final String activityName = _currentActivity?.name.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
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
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.chevron_left),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveActivity,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.check_mark),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildActivityImage(),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        _currentActivity?.name ?? 'No Activity Selected',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),


              Text(
                'Date',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
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
                    color: Colors.grey[50],
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
                        ),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Text(
                'Time',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
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
                    color: Colors.grey[50],
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
                        ),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 416.h),

              RoundButton(
                title: 'Save',
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


// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View/Calendar/walkView.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ReminderNotifier.dart';
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
// import '../../config/components/CustomDatePicker.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Reminderlist extends StatefulWidget {
//   final Activity? selectedActivity;
//   final DateTime? initialDate;
//   final String? selectedPetId;
//
//   const Reminderlist({
//     super.key,
//     this.selectedActivity,
//     this.initialDate,
//     this.selectedPetId,
//   });
//
//   @override
//   State<Reminderlist> createState() => _ReminderlistState();
// }
//
// class _ReminderlistState extends State<Reminderlist> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   DateTime? _reminderDate;
//   TimeOfDay? _reminderTime;
//   final TextEditingController _foodController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();
//
//   File? _selectedImage;
//   File? _selectedVideo;
//   final ImagePicker _picker = ImagePicker();
//
//   Activity? _currentActivity;
//   DateTime _walkStartDate = DateTime.now();
//   TimeOfDay _walkStartTime = TimeOfDay.now();
//   DateTime _walkEndDate = DateTime.now();
//   TimeOfDay _walkEndTime = TimeOfDay.now();
//
//   double _drinkQuantityOz = 0.0;
//   bool _isOzUnit = true;
//
//   double _walkDistanceKm = 0.0;
//   bool _isKmUnit = true;
//
//   double _weightValue = 1.0;
//   bool _isLbsUnit = true;
//
//   double _heightValue = 1.0;
//   bool _isInchesUnit = true;
//
//   double _temperatureValue = 100.0;
//   bool _isFahrenheitUnit = true;
//
//   bool _hasReminder = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentActivity = widget.selectedActivity;
//
//     if (widget.initialDate != null) {
//       _selectedDate = widget.initialDate!;
//     } else if (_currentActivity != null) {
//       _selectedDate = _currentActivity!.dateTime;
//       _selectedTime = TimeOfDay.fromDateTime(_currentActivity!.dateTime);
//     }
//
//     // If editing existing activity with reminder, populate values
//     if (_currentActivity?.hasReminder == true) {
//       _hasReminder = true;
//       _reminderDate = _currentActivity?.reminderDateTime;
//       _reminderTime = _currentActivity?.reminderDateTime != null
//           ? TimeOfDay.fromDateTime(_currentActivity!.reminderDateTime!)
//           : null;
//     }
//
//     final int totalMinutes =
//         _selectedTime.hour * 60 + _selectedTime.minute + 60;
//     final int endHour = totalMinutes ~/ 60 % 24;
//     final int endMinute = totalMinutes % 60;
//     _walkEndTime = TimeOfDay(hour: endHour, minute: endMinute);
//   }
//
//   // Reminder date selection
//
//
//
//   void _selectDate() async {
//     final DateTime? picked = await showDialog<DateTime>(
//       context: context,
//       builder: (context) => CustomDatePicker(initialDate: _selectedDate),
//     );
//
//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//     }
//   }
//
//   // Activity time selection
//   Future<void> _selectTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF820DFF),
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xFF820DFF),
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() => _selectedTime = picked);
//     }
//   }
//
//
//
//
//
//
//
//
//
//   void _saveActivity() async {
//     if (_currentActivity == null) {
//       _showErrorSnackBar('Please select an activity first');
//       return;
//     }
//
//     // Validate reminder time if set
//     DateTime? reminderDateTime;
//     if (_hasReminder && _reminderDate != null && _reminderTime != null) {
//       reminderDateTime = DateTime(
//         _reminderDate!.year,
//         _reminderDate!.month,
//         _reminderDate!.day,
//         _reminderTime!.hour,
//         _reminderTime!.minute,
//       );
//
//       if (reminderDateTime.isBefore(DateTime.now())) {
//         _showErrorSnackBar('Reminder time must be in the future');
//         return;
//       }
//     }
//
//     String? foodValue;
//     final String activityName = _currentActivity!.name.toLowerCase();
//
//     if (activityName == 'drink') {
//       const double ozToMl = 29.5735;
//       double amount = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;
//       foodValue = '${amount.toStringAsFixed(1)} ${_isOzUnit ? 'oz' : 'ml'}';
//       if (_foodController.text.trim().isNotEmpty) {
//         foodValue = '$foodValue ${_foodController.text.trim()}';
//       }
//     } else if (activityName == 'weight') {
//       if (_weightValue <= 0) {
//         _showErrorSnackBar('Please enter a valid weight');
//         return;
//       }
//       foodValue =
//       '${_weightValue.toStringAsFixed(1)} ${_isLbsUnit ? 'lbs' : 'kg'}';
//     } else if (activityName == 'height') {
//       if (_heightValue <= 0) {
//         _showErrorSnackBar('Please enter a valid height');
//         return;
//       }
//       foodValue =
//       '${_heightValue.toStringAsFixed(1)} ${_isInchesUnit ? 'Inches' : 'cm'}';
//     } else if (activityName == 'temperature') {
//       if (_temperatureValue <= 0) {
//         _showErrorSnackBar('Please enter a valid temperature');
//         return;
//       }
//       foodValue =
//       '${_temperatureValue.toStringAsFixed(1)} ${_isFahrenheitUnit ? '°F' : '°C'}';
//     } else if (['walk', 'play', 'crate'].contains(activityName)) {
//       const double kmToMi = 0.621371;
//       double amount = _isKmUnit ? _walkDistanceKm : _walkDistanceKm * kmToMi;
//       foodValue = '${amount.toStringAsFixed(1)} ${_isKmUnit ? 'km' : 'mi'}';
//     } else {
//       if (activityName == 'eat') {
//         if (_foodController.text.trim().isEmpty) {
//           _showErrorSnackBar('Please enter food name or type');
//           return;
//         }
//       }
//       if (_foodController.text.trim().isNotEmpty) {
//         foodValue = _foodController.text.trim();
//       }
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(color: AppColors.vibrantPurple),
//       ),
//     );
//
//     try {
//       DateTime activityDateTime;
//
//       if (['walk', 'play', 'crate'].contains(activityName)) {
//         activityDateTime = DateTime(
//           _walkStartDate.year,
//           _walkStartDate.month,
//           _walkStartDate.day,
//           _walkStartTime.hour,
//           _walkStartTime.minute,
//         );
//       } else {
//         activityDateTime = DateTime(
//           _selectedDate.year,
//           _selectedDate.month,
//           _selectedDate.day,
//           _selectedTime.hour,
//           _selectedTime.minute,
//         );
//       }
//
//       final newActivity = Activity(
//         name: _currentActivity!.name,
//         imagePath: _currentActivity!.imagePath,
//         color: _currentActivity!.color,
//         food: foodValue,
//         dateTime: activityDateTime,
//         note: _noteController.text.trim().isEmpty
//             ? null
//             : _noteController.text.trim(),
//         imagePathLocal: _selectedImage?.path,
//         videoPathLocal: _selectedVideo?.path,
//         hasReminder: _hasReminder,
//         reminderDateTime: reminderDateTime,
//         reminderId: _currentActivity?.reminderId,
//         petId: _currentActivity?.petId ?? widget.selectedPetId,
//       );
//
//       final activityNotifier = Provider.of<ActivityNotifier>(
//         context,
//         listen: false,
//       );
//
//       final reminderNotifier = Provider.of<ReminderNotifier>(
//         context,
//         listen: false,
//       );
//
//       // Save activity
//       activityNotifier.addActivity(newActivity);
//
//       // Schedule reminder if set
//       if (_hasReminder && reminderDateTime != null) {
//         final reminderId = await reminderNotifier.scheduleReminder(
//           activity: newActivity,
//           reminderDateTime: reminderDateTime,
//         );
//
//         // Update activity with reminder ID
//         final updatedActivity = newActivity.copyWith(reminderId: reminderId);
//         activityNotifier.updateActivity(updatedActivity);
//       } else if (!_hasReminder && _currentActivity?.reminderId != null) {
//         // Cancel existing reminder if removed
//         await reminderNotifier.cancelReminder(_currentActivity!.reminderId!);
//       }
//
//       Navigator.pop(context); // close loading
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Activity ${_hasReminder ? 'with reminder ' : ''}saved successfully!',
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//
//       Future.delayed(const Duration(milliseconds: 800), () {
//         if (context.mounted) {
//           Navigator.pop(context, true);
//         }
//       });
//     } catch (e) {
//       Navigator.pop(context);
//       _showErrorSnackBar('Failed to save: $e');
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   Widget _buildActivityImage() {
//     if (_currentActivity != null) {
//       return Container(
//         width: 90.w,
//         height: 90.h,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Center(
//           child: ClipOval(
//             child: Image.asset(
//               _currentActivity!.imagePath,
//               width: 70.w,
//               height: 70.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) =>
//                   Icon(Icons.pets, color: _currentActivity!.color),
//             ),
//           ),
//         ),
//       );
//     }
//     return Container(
//       width: 70.w,
//       height: 70.h,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: CupertinoColors.systemGrey4,
//       ),
//       child: const Icon(
//         CupertinoIcons.photo,
//         size: 32,
//         color: CupertinoColors.systemGrey,
//       ),
//     );
//   }
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
//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('MM-dd-yyyy');
//     final timeFormat = DateFormat('HH:mm');
//     final String activityName = _currentActivity?.name.toLowerCase() ?? '';
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.background,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(CupertinoIcons.chevron_left),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _saveActivity,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.background,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(CupertinoIcons.check_mark),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.h),
//
//               Container(
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF4F7F6),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Row(
//                   children: [
//                     _buildActivityImage(),
//                     SizedBox(width: 20.w),
//                     Expanded(
//                       child: Text(
//                         _currentActivity?.name ?? 'No Activity Selected',
//                         style: TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//
//               Text(
//                 'Date',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 6.h),
//               GestureDetector(
//                 onTap: _selectDate,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 14.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         dateFormat.format(_selectedDate),
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Icon(Icons.calendar_month),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//
//               Text(
//                 'Time',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               GestureDetector(
//                 onTap: _selectTime,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 14.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         timeFormat.format(
//                           DateTime(
//                             2000,
//                             1,
//                             1,
//                             _selectedTime.hour,
//                             _selectedTime.minute,
//                           ),
//                         ),
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Icon(Icons.access_time),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 416.h),
//
//               RoundButton(
//                 title: 'Save',
//                 isSelected: true,
//                 textColors: Colors.white,
//                 backgroundColors: AppColors.vibrantPurple,
//                 onPress: _saveActivity,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
