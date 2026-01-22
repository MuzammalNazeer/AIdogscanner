import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View/Calendar/walkView.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View_model/ReminderNotifier.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/home/home_view_model.dart';
import '../../activity_model.dart';
import '../../config/components/CustomDatePicker.dart';
import '../../utils/routes/routes_name.dart';

class Allactivityview extends StatefulWidget {
  final Activity? selectedActivity;
  final DateTime? initialDate;
  final String? selectedPetId;

  const Allactivityview({
    super.key,
    this.selectedActivity,
    this.initialDate,
    this.selectedPetId,
  });

  @override
  State<Allactivityview> createState() => _AllactivityviewState();
}

class _AllactivityviewState extends State<Allactivityview> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  File? _selectedImage;
  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  Activity? _currentActivity;
  DateTime _walkStartDate = DateTime.now();
  TimeOfDay _walkStartTime = TimeOfDay.now();
  DateTime _walkEndDate = DateTime.now();
  TimeOfDay _walkEndTime = TimeOfDay.now();

  double _drinkQuantityOz = 0.0;
  bool _isOzUnit = true;

  double _walkDistanceKm = 0.0;
  bool _isKmUnit = true;

  double _weightValue = 1.0;
  bool _isLbsUnit = true;

  double _heightValue = 1.0;
  bool _isInchesUnit = true;

  double _temperatureValue = 100.0;
  bool _isFahrenheitUnit = true;

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
      _reminderDate = _currentActivity?.reminderDateTime;
      _reminderTime = _currentActivity?.reminderDateTime != null
          ? TimeOfDay.fromDateTime(_currentActivity!.reminderDateTime!)
          : null;
    }

    final int totalMinutes =
        _selectedTime.hour * 60 + _selectedTime.minute + 60;
    final int endHour = totalMinutes ~/ 60 % 24;
    final int endMinute = totalMinutes % 60;
    _walkEndTime = TimeOfDay(hour: endHour, minute: endMinute);
  }

  // Reminder date selection
  Future<void> _selectReminderDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) =>
          CustomDatePicker(initialDate: _reminderDate ?? DateTime.now()),
    );

    if (picked != null) {
      setState(() {
        _reminderDate = picked;
        _hasReminder = true;
      });
    }
  }

  // Reminder time selection
  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
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
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
        _hasReminder = true;
      });
    }
  }

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
              primary: AppColors.vibrantPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: AppColors.vibrantPurple,
              onSecondary: Colors.white,
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

  // Walk specific date/time methods
  Future<void> _selectWalkStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _walkStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF820DFF)

          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _walkStartDate = picked);
  }

  Future<void> _selectWalkStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _walkStartTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(

            primary: AppColors.vibrantPurple,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            secondary: AppColors.vibrantPurple,
            onSecondary: Colors.white,

          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _walkStartTime = picked);
  }

  Future<void> _selectWalkEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _walkEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF820DFF)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _walkEndDate = picked);
  }

  Future<void> _selectWalkEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _walkEndTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.vibrantPurple,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            secondary: AppColors.vibrantPurple,
            onSecondary: Colors.white,

          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _walkEndTime = picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final XFile? video = await _picker.pickVideo(source: source);
      if (video != null) {
        setState(() => _selectedVideo = File(video.path));
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF820DFF),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.videocam, color: Color(0xFF820DFF)),
                title: const Text('Record Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_library,
                  color: Color(0xFF820DFF),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveActivity() async {
    if (_currentActivity == null) {
      _showErrorSnackBar('Please select an activity first');
      return;
    }

    // Validate reminder time if set
    DateTime? reminderDateTime;
    if (_hasReminder && _reminderDate != null && _reminderTime != null) {
      reminderDateTime = DateTime(
        _reminderDate!.year,
        _reminderDate!.month,
        _reminderDate!.day,
        _reminderTime!.hour,
        _reminderTime!.minute,
      );

      if (reminderDateTime.isBefore(DateTime.now())) {
        _showErrorSnackBar('Reminder time must be in the future');
        return;
      }
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

      if (['walk', 'play', 'crate'].contains(activityName)) {
        activityDateTime = DateTime(
          _walkStartDate.year,
          _walkStartDate.month,
          _walkStartDate.day,
          _walkStartTime.hour,
          _walkStartTime.minute,
        );
      } else {
        activityDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      }

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

      Navigator.pop(context);

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
      homeViewModel.calendarTabIndex = 0; // Index for Calendar
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);

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

  Widget _buildSelectedImage() {
    if (_selectedImage == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Image:',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 8.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  _selectedImage!,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedVideo() {
    if (_selectedVideo == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Video:',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 8.h),
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xFF820DFF).withOpacity(0.1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    size: 40,
                    color: Color(0xFF820DFF),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedVideo = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // Reminder Header
        // Row(
        //   children: [
        //     Expanded(
        //       child: Text(
        //         'Set Reminder',
        //         style: TextStyle(
        //           fontSize: 16.sp,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //     // Switch(
        //     //   value: _hasReminder,
        //     //   activeThumbColor: Colors.black,
        //     //   activeColor: const Color(0xFF820DFF),
        //     //   inactiveThumbColor: Colors.white,
        //     //   inactiveTrackColor: Colors.red,
        //     //
        //     //   onChanged: (value) {
        //     //     setState(() {
        //     //       _hasReminder = value;
        //     //       if (!value) {
        //     //         _reminderDate = null;
        //     //         _reminderTime = null;
        //     //       }
        //     //     });
        //     //   },
        //     // ),
        //
        //     Switch(
        //       value: _hasReminder,
        //       activeColor: const Color(0xFF820DFF), // Purple track when ON
        //       activeTrackColor: const Color(0xFF820DFF), // Purple track
        //       inactiveThumbColor: Colors.white,
        //       inactiveTrackColor: Colors.red, // Red track when OFF
        //       thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        //         if (states.contains(MaterialState.selected)) {
        //           return Colors.white; // White thumb when ON
        //         }
        //         return Colors.white; // White thumb when OFF
        //       }),
        //       trackOutlineColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        //         if (states.contains(MaterialState.selected)) {
        //           return const Color(0xFF820DFF);
        //         }
        //         return Colors.red;
        //       }),
        //       onChanged: (value) {
        //         setState(() {
        //           _hasReminder = value;
        //           if (!value) {
        //             _reminderDate = null;
        //             _reminderTime = null;
        //           }
        //         });
        //       },
        //     ),
        //   ],
        // ),
        SizedBox(height: 8.h),

        if (_hasReminder) ...[
          // Reminder Date
          GestureDetector(
            onTap: _selectReminderDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _reminderDate != null
                        ? DateFormat('MMM dd, yyyy').format(_reminderDate!)
                        : 'Select reminder date',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _reminderDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Reminder Time
          GestureDetector(
            onTap: _selectReminderTime,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _reminderTime != null
                        ? _reminderTime!.format(context)
                        : 'Select reminder time',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _reminderTime != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.access_time, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Reminder Preview
          if (_reminderDate != null && _reminderTime != null)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF820DFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF820DFF).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: const Color(0xFF820DFF),
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Reminder set for ${DateFormat('MMM d, yyyy').format(_reminderDate!)} at ${_reminderTime!.format(context)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF820DFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }

  void _showFoodName1BottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color:  Color(0xFFF4F7F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: RoundButton(
                      title: 'save',
                      height: 53.h,
                      isSelected: true,
                      textColors: Colors.white,
                      backgroundColors: const Color(0xFF820DFF),
                      onPress: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: RoundButton(
                      title: 'Delete',
                      height: 53.h,
                      isSelected: true,
                      isOutline: true,
                      borderColors: Colors.red,
                      textColors: Colors.red,
                      onPress: () {
                        setState(() {
                          _foodController.clear();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodNameBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color:  Color(0xFFF4F7F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              RoundButton(
                title: 'save',
                height: 53.h,
                isSelected: true,
                textColors: Colors.white,
                backgroundColors: const Color(0xFF820DFF),
                onPress: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
  void _showDrinkName1BottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color:  Color(0xFFF4F7F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: RoundButton(
                      title: 'save',
                      height: 53.h,
                      isSelected: true,
                      textColors: Colors.white,
                      backgroundColors: const Color(0xFF820DFF),
                      onPress: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: RoundButton(
                      title: 'Delete',
                      height: 53.h,
                      isSelected: true,
                      isOutline: true,
                      borderColors: Colors.red,
                      textColors: Colors.red,
                      onPress: () {
                        setState(() {
                          _foodController.clear();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDrinkNameBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Color(0xFFF4F7F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              RoundButton(
                title: 'save',
                height: 53.h,
                isSelected: true,
                textColors: Colors.white,
                backgroundColors: const Color(0xFF820DFF),
                onPress: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }







  Widget _buildDrinkQuantitySelector() {
    // ... (keep existing drink selector code)
    const double ozToMl = 29.5735;
    const double ozStep = 0.1;
    const double mlStep = 1;

    double snapOzToWholeMl(double oz) {
      double ml = oz * ozToMl;
      return ml.roundToDouble() / ozToMl;
    }

    double displayValue = _isOzUnit
        ? _drinkQuantityOz
        : _drinkQuantityOz * ozToMl;

    void increment() {
      setState(() {
        if (_isOzUnit) {
          if (_drinkQuantityOz <= 49.5) {
            _drinkQuantityOz += ozStep;
          }
        } else {
          _drinkQuantityOz += mlStep / ozToMl;
          _drinkQuantityOz = snapOzToWholeMl(_drinkQuantityOz);
        }
      });
    }

    void decrement() {
      setState(() {
        if (_isOzUnit) {
          if (_drinkQuantityOz >= ozStep) {
            _drinkQuantityOz -= ozStep;
          }
        } else {
          if (_drinkQuantityOz * ozToMl > mlStep) {
            _drinkQuantityOz -= mlStep / ozToMl;
            _drinkQuantityOz = snapOzToWholeMl(_drinkQuantityOz);
          }
        }
      });
    }

    return Column(
      children: [
        if (_foodController.text.isNotEmpty)
          RoundButton(
            title: _foodController.text,
            isSelected: true,
            backgroundColors: const Color(0xFFF4F7F6),
            textColors: Colors.black,
            hasIcons: true,
            isTrailingIcon: true,
            icon: const Icon(Icons.edit, size: 20, color: Colors.black),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            onPress: _showDrinkName1BottomSheet,
          )
        else
          RoundButton(
            title: "+ Add Drink name or type",
            isSelected: true,
            backgroundColors: const Color(0xFFF4F7F6),
            textColors: const Color(0xFF820DFF),
            onPress: _showDrinkNameBottomSheet,
          ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Color(0xFF820DFF)),
                onPressed: decrement,
              ),
              Text(
                _isOzUnit
                    ? displayValue.toStringAsFixed(1)
                    : displayValue.toStringAsFixed(0),
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
                onPressed: increment,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOzUnit = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _isOzUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'oz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isOzUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isOzUnit = false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: !_isOzUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'mL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isOzUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSelector() {
    const double lbsToKg = 0.45359237;
    const double step = 0.1;

    double displayValue = _weightValue;

    void increment() {
      setState(() {
        if (displayValue < 999) {
          _weightValue = (_weightValue + step);
        }
      });
    }

    void decrement() {
      setState(() {
        if (_weightValue > step) {
          _weightValue = (_weightValue - step);
        }
      });
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Color(0xFF820DFF)),
                onPressed: decrement,
              ),
              Text(
                displayValue.toStringAsFixed(1),
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
                onPressed: increment,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!_isLbsUnit) {
                        _weightValue = _weightValue / lbsToKg;
                        _isLbsUnit = true;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _isLbsUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'lbs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isLbsUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isLbsUnit) {
                        _weightValue = _weightValue * lbsToKg;
                        _isLbsUnit = false;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: !_isLbsUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'kg',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isLbsUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeightSelector() {
    const double inchToCm = 2.54;
    const double step = 0.5;

    double displayValue = _heightValue;

    void increment() {
      setState(() {
        if (displayValue < 300) {
          _heightValue = (_heightValue + step);
        }
      });
    }

    void decrement() {
      setState(() {
        if (_heightValue > step) {
          _heightValue = (_heightValue - step);
        }
      });
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Color(0xFF820DFF)),
                onPressed: decrement,
              ),
              Text(
                displayValue.toStringAsFixed(1),
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
                onPressed: increment,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!_isInchesUnit) {
                        _heightValue = _heightValue / inchToCm;
                        _isInchesUnit = true;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _isInchesUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Inches',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isInchesUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isInchesUnit) {
                        _heightValue = _heightValue * inchToCm;
                        _isInchesUnit = false;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: !_isInchesUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'cm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isInchesUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureSelector() {
    const double step = 0.5;

    double displayValue = _temperatureValue;

    void increment() {
      setState(() {
        if (displayValue < 200) {
          _temperatureValue = (_temperatureValue + step);
        }
      });
    }

    void decrement() {
      setState(() {
        if (_temperatureValue > step) {
          _temperatureValue = (_temperatureValue - step);
        }
      });
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Color(0xFF820DFF)),
                onPressed: decrement,
              ),
              Text(
                displayValue.toStringAsFixed(1),
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
                onPressed: increment,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!_isFahrenheitUnit) {
                        _temperatureValue = (_temperatureValue * 9 / 5) + 32;
                        _isFahrenheitUnit = true;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _isFahrenheitUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      '°F',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isFahrenheitUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isFahrenheitUnit) {
                        _temperatureValue =
                            (_temperatureValue - 32) * 5 / 9;
                        _isFahrenheitUnit = false;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: !_isFahrenheitUnit
                          ? const Color(0xFF820DFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      '°C',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isFahrenheitUnit ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildWalkDistanceSelector() {
    final String activityName = _currentActivity?.name.toLowerCase() ?? '';
    final bool isWalkActivity = activityName == 'walk';

    const double kmToMi = 0.621371;
    double baseKm = _walkDistanceKm;
    double rawDisplayValue = _isKmUnit ? baseKm : baseKm * kmToMi;
    double step = 1.0;
    String displayText = _isKmUnit
        ? rawDisplayValue.toStringAsFixed(1)
        : '${rawDisplayValue.round()} ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundButton(
          title: "Or start a timer",
          isSelected: true,
          textColors: AppColors.vibrantPurple,
          hasIcons: true,
          icon: const Icon(Icons.update, color: AppColors.vibrantPurple),
          backgroundColors: const Color(0xFFF4F7F6),
          onPress: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Walkview(selectedActivity: _currentActivity),
              ),
            );

            if (result != null && result is Map) {
              final duration = result['duration'] as Duration;
              final formattedDuration = result['formattedDuration'] as String;
              final note = result['note'] as String;

              final walkDateTime = DateTime(
                _walkStartDate.year,
                _walkStartDate.month,
                _walkStartDate.day,
                _walkStartTime.hour,
                _walkStartTime.minute,
              );

              final walkActivity = Activity(
                name: _currentActivity?.name ?? 'Walk',
                imagePath: _currentActivity!.imagePath,
                color: _currentActivity!.color,
                food:
                    '${_walkDistanceKm.toStringAsFixed(1)} ${_isKmUnit ? 'km' : 'mi'}',
                dateTime: walkDateTime,
                note: note.isNotEmpty ? note : null,
                duration: duration,
                formattedDuration: formattedDuration,
                walkDistance:
                    '${_walkDistanceKm.toStringAsFixed(1)} ${_isKmUnit ? 'km' : 'mi'}',
                petId: _currentActivity?.petId ?? widget.selectedPetId,
              );

              final activityNotifier = Provider.of<ActivityNotifier>(
                context,
                listen: false,
              );
              activityNotifier.addActivity(walkActivity);

              Navigator.pop(context);
            }
          },
        ),

        // Show distance selector only for walk activity
        if (isWalkActivity) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 85.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.black, size: 28),
                    onPressed: () {
                      setState(() {
                        if (_isKmUnit) {
                          if (_walkDistanceKm >= step) {
                            _walkDistanceKm -= step;
                          }
                        } else {
                          double currentMi = _walkDistanceKm * kmToMi;
                          if (currentMi >= step) {
                            _walkDistanceKm = (currentMi - step) / kmToMi;
                          }
                        }
                      });
                    },
                  ),
                ),
                Text(
                  displayText,
                  style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 85.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black, size: 28),
                    onPressed: () {
                      setState(() {
                        if (_isKmUnit) {
                          if (_walkDistanceKm <= 99) {
                            _walkDistanceKm += step;
                          }
                        } else {
                          double currentMi = _walkDistanceKm * kmToMi;
                          if (currentMi <= 62) {
                            _walkDistanceKm = (currentMi + step) / kmToMi;
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isKmUnit = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: _isKmUnit
                            ? const Color(0xFF820DFF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'km',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isKmUnit ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isKmUnit = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: !_isKmUnit
                            ? const Color(0xFF820DFF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'ml',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isKmUnit ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 24.h),
        Text(
          'Started At',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkStartDate,
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
                        DateFormat('MM-dd-yyyy').format(_walkStartDate),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkStartTime,
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
                        DateFormat('HH:mm').format(
                          DateTime(
                            0,
                            0,
                            0,
                            _walkStartTime.hour,
                            _walkStartTime.minute,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          'Ended At',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkEndDate,
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
                        DateFormat('MM-dd-yyyy').format(_walkEndDate),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkEndTime,
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
                        DateFormat('HH:mm').format(
                          DateTime(
                            0,
                            0,
                            0,
                            _walkEndTime.hour,
                            _walkEndTime.minute,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }





  String _getButtonTitle(String activityName) {
    switch (activityName) {
      case 'treat':
        return "+ Add Treat";
      case 'grooming':
        return "+ Add grooming type";
      case 'medication':
        return "+ Add medication";
      case 'vaccination':
        return "+ Add vaccination";
        case 'health condition':
        return "+ Add health condition";
        case 'accident':
        return "+ Add accident type";
        case 'cleaning':
        return "+ Add Cleaning type";
      default:
        return "+ Add Food name or type";
    }
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

              // Reminder Section (for all activities)
              _buildReminderSection(),
              SizedBox(height: 10.h),

              if (activityName == 'drink')
                _buildDrinkQuantitySelector()
              else if (activityName == 'weight')
                _buildWeightSelector()
              else if (activityName == 'height')
                _buildHeightSelector()
              else if (activityName == 'temperature')
                _buildTemperatureSelector()
              else if (['walk', 'play', 'crate','training','sleep'].contains(activityName))
                _buildWalkDistanceSelector()
              else if (activityName != 'pee' && activityName != 'poop' && activityName != 'journal')
                if (_foodController.text.isNotEmpty)
                  RoundButton(
                    title: _foodController.text,
                    isSelected: true,
                    backgroundColors: const Color(0xFFF4F7F6),
                    textColors: Colors.black,
                    borderColors: const Color(0xFF820DFF),
                    hasIcons: true,
                    isTrailingIcon: true,
                    icon: const Icon(Icons.edit, size: 20, color: Colors.black),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onPress: _showFoodName1BottomSheet,
                  )
              else
                  RoundButton(
                    title: _getButtonTitle(activityName),
                    isSelected: true,
                    backgroundColors: const Color(0xFFF4F7F6),
                    textColors: const Color(0xFF820DFF),
                    onPress: _showFoodNameBottomSheet,
                  ),
              SizedBox(height: 10.h),

              if (['weight', 'height', 'temperature'].contains(activityName))
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        'Started At',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectWalkStartDate,
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
                                      DateFormat('MM-dd-yyyy').format(_walkStartDate),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectWalkStartTime,
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
                                      DateFormat('HH:mm').format(
                                        DateTime(
                                          0,
                                          0,
                                          0,
                                          _walkStartTime.hour,
                                          _walkStartTime.minute,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.access_time, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Ended At',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectWalkEndDate,
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
                                      DateFormat('MM-dd-yyyy').format(_walkEndDate),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectWalkEndTime,
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
                                      DateFormat('HH:mm').format(
                                        DateTime(
                                          0,
                                          0,
                                          0,
                                          _walkEndTime.hour,
                                          _walkEndTime.minute,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.access_time, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              if (!['walk', 'play', 'crate','training','weight','height','temperature']
                  .contains(activityName)) ...[
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
                SizedBox(height: 16.h),
              ],

              // Note
              Text(
                'Note',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Add a note about this activity...',
                  filled: true,
                  fillColor: const Color(0xFFF3F6F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.w),
                ),
              ),
              SizedBox(height: 20.h),

              // Add Image
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
                      SizedBox(width: 12.w),
                      const Text(
                        '+ Add Image',
                        style: TextStyle(
                          color: Color(0xFF820DFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildSelectedImage(),
              SizedBox(height: 16.h),

              // Add Video
              GestureDetector(
                onTap: _showVideoSourceDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.videocam, color: Color(0xFF820DFF)),
                      SizedBox(width: 12.w),
                      const Text(
                        '+ Add Video',
                        style: TextStyle(
                          color: Color(0xFF820DFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildSelectedVideo(),
              SizedBox(height: 32.h),

              // Save Button
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
