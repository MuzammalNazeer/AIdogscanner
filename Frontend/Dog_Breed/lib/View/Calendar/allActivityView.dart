import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../View_model/activity_provider.dart';
import '../../activity_model.dart';
import '../../utils/routes/routes_name.dart';

class Allactivityview extends StatefulWidget {
  final Activity? selectedActivity;

  const Allactivityview({super.key, this.selectedActivity});

  @override
  State<Allactivityview> createState() => _AllactivityviewState();
}

class _AllactivityviewState extends State<Allactivityview> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
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

  // // Drink state
  // double _drinkQuantityOz = 0.0;
  // bool _isOzUnit = true;
  double _drinkQuantityOz = 0.0;  // initial value in oz
  bool _isOzUnit = true;
  // Walk state
  double _walkDistanceKm = 0.0;
  bool _isKmUnit = true; // true = km, false = mi

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.selectedActivity;

    final int totalMinutes =
        _selectedTime.hour * 60 + _selectedTime.minute + 60;
    final int endHour = totalMinutes ~/ 60 % 24;
    final int endMinute = totalMinutes % 60;
    _walkEndTime = TimeOfDay(hour: endHour, minute: endMinute);
  }

  // Picker methods - MOVED TO CLASS LEVEL
  Future<void> _selectWalkStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _walkStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF820DFF)),
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
          colorScheme: const ColorScheme.light(primary: Color(0xFF820DFF)),
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
          colorScheme: const ColorScheme.light(primary: Color(0xFF820DFF)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _walkEndTime = picked);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

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

  void _saveActivity() {
    if (_currentActivity == null) {
      _showErrorSnackBar('Please select an activity first');
      return;
    }

    String? foodValue;
    final String activityName = _currentActivity!.name.toLowerCase();

    if (activityName == 'drink') {
      const double ozToMl = 29.5735;
      double amount = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;
      foodValue = '${amount.toStringAsFixed(1)} ${_isOzUnit ? 'oz' : 'ml'}';
    } else if (activityName == 'walk') {
      const double kmToMi = 0.500;
      double amount = _isKmUnit ? _walkDistanceKm : _walkDistanceKm * kmToMi;
      foodValue = '${amount.toStringAsFixed(1)} ${_isKmUnit ? 'km' : 'ml'}';
    } else {
      if (_foodController.text.trim().isEmpty) {
        _showErrorSnackBar('Please enter food name or type');
        return;
      }
      foodValue = _foodController.text.trim();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.vibrantPurple),
      ),
    );

    try {
      final newActivity = Activity(
        name: _currentActivity!.name,
        imagePath: _currentActivity!.imagePath,
        color: _currentActivity!.color,
        food: foodValue,
        dateTime: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        imagePathLocal: _selectedImage?.path,
        videoPathLocal: _selectedVideo?.path,
      );

      final activityNotifier = Provider.of<ActivityNotifier>(
        context,
        listen: false,
      );
      activityNotifier.addActivity(newActivity);

      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Activity saved successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      });
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



  Widget _buildDrinkQuantitySelector() {
    const double ozToMl = 29.5735;
    const double ozStep = 0.1;
    const double mlStep = 1;


    double snapOzToWholeMl(double oz) {
      double ml = oz * ozToMl;
      return ml.roundToDouble() / ozToMl;
    }

    double displayValue =
    _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;

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
        // ───────── Quantity Display ─────────
        Container(
          padding: EdgeInsets.all(16.w),
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
                    ? displayValue.toStringAsFixed(1) // oz
                    : displayValue.toStringAsFixed(0), // mL
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
                onPressed: increment,
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // ───────── Unit Toggle ─────────
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

  Widget _buildWalkDistanceSelector() {
    const double kmToMi = 0.621371;

    // Base value stored in km
    double baseKm = _walkDistanceKm;

    // Display value
    double rawDisplayValue = _isKmUnit ? baseKm : baseKm * kmToMi;

    // Step size: 1 in current unit
    double step = 1.0;

    // Format: 1 decimal for km, whole number for mi
    String displayText = _isKmUnit
        ? '${rawDisplayValue.toStringAsFixed(1)}'
        : '${rawDisplayValue.round()} ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Or start a timer" button
        RoundButton(
          title: "Or start a timer",
          isSelected: true,
          textColors: Colors.white,
          hasIcons: true,
          icon: const Icon(Icons.update, color: Colors.white),
          backgroundColors: AppColors.vibrantPurple,
          onPress: () {
            Navigator.pushNamed(context, RoutesName.walk);
          },
        ),
        SizedBox(height: 16.h),

        // Distance Selector
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7F6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minus Button
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

              // Display Value
              Text(
                displayText,
                style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
              ),

              // Plus Button
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
                        if (_walkDistanceKm <= 99) { // reasonable max
                          _walkDistanceKm += step;
                        }
                      } else {
                        double currentMi = _walkDistanceKm * kmToMi;
                        if (currentMi <= 62) { // ~100 km max
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

        // km / mi Toggle
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
                      color: _isKmUnit ? const Color(0xFF820DFF) : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
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
                      color: !_isKmUnit ? const Color(0xFF820DFF) : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(12.r)),
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

        SizedBox(height: 24.h),

        // Started At
        Text('Started At', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkStartDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MM-dd-yyyy').format(_walkStartDate), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('HH:mm').format(DateTime(0,0,0,_walkStartTime.hour,_walkStartTime.minute)), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Ended At
        Text('Ended At', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectWalkEndDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MM-dd-yyyy').format(_walkEndDate), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('HH:mm').format(DateTime(0,0,0,_walkEndTime.hour,_walkEndTime.minute)), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM-dd-yyyy');
    final timeFormat = DateFormat('HH:mm');
    final String activityName = _currentActivity?.name.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back and save buttons
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

            // Activity preview
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

            // Conditional Input Section
            if (activityName == 'drink')
              _buildDrinkQuantitySelector()
            else if (activityName == 'walk')
              _buildWalkDistanceSelector()
            else
              TextField(
                controller: _foodController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '+ Add food name or type',
                  hintStyle: TextStyle(
                    color: const Color(0xFF820DFF),
                    fontSize: 16.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F7F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

            SizedBox(height: 16.h),

            // === ONLY SHOW SINGLE DATE & TIME FOR NON-WALK ACTIVITIES ===
            if (activityName != 'walk') ...[
              // Date
              Text(
                'Date',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
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
              SizedBox(height: 16.h),

              // Time
              Text(
                'Time',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
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
            SizedBox(height: 24.h),

            // Add Image
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
    );
  }

}
















// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/activity_provider.dart';
// import '../../activity_model.dart';
//
// class Allactivityview extends StatefulWidget {
//   final Activity? selectedActivity;
//
//   const Allactivityview({super.key, this.selectedActivity});
//
//   @override
//   State<Allactivityview> createState() => _AllactivityviewState();
// }
//
// class _AllactivityviewState extends State<Allactivityview> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   final TextEditingController _foodController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();
//
//   File? _selectedImage;
//   File? _selectedVideo;
//   final ImagePicker _picker = ImagePicker();
//
//   Activity? _currentActivity;
//
//   // Drink quantity state (only used when activity is "Drink")
//   double _drinkQuantityOz = 1.0; // default 1.0 oz
//   bool _isOzUnit = true; // true = oz, false = mL
//
//   @override
//   void initState() {
//     super.initState();
//     _currentActivity = widget.selectedActivity;
//   }
//
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
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
//     if (picked != null && picked != _selectedDate) {
//       setState(() => _selectedDate = picked);
//     }
//   }
//
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
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() => _selectedImage = File(image.path));
//       }
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//     }
//   }
//
//   Future<void> _pickVideo(ImageSource source) async {
//     try {
//       final XFile? video = await _picker.pickVideo(source: source);
//       if (video != null) {
//         setState(() => _selectedVideo = File(video.path));
//       }
//     } catch (e) {
//       debugPrint('Error picking video: $e');
//     }
//   }
//
//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
//                 title: const Text('Take Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Color(0xFF820DFF)),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showVideoSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.videocam, color: Color(0xFF820DFF)),
//                 title: const Text('Record Video'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickVideo(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.video_library, color: Color(0xFF820DFF)),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickVideo(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _saveActivity() {
//     if (_currentActivity == null) {
//       _showErrorSnackBar('Please select an activity first');
//       return;
//     }
//
//     // For Drink activity, we don't require food name
//     if (_currentActivity!.name.toLowerCase() != 'drink' && _foodController.text.trim().isEmpty) {
//       _showErrorSnackBar('Please enter food name or type');
//       return;
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
//       // Determine food / drink value
//       String? foodValue;
//       if (_currentActivity!.name.toLowerCase() == 'drink') {
//         double amount = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * 29.5735;
//         foodValue = '${amount.toStringAsFixed(1)} ${_isOzUnit ? 'oz' : 'mL'}';
//       } else {
//         foodValue = _foodController.text.trim();
//       }
//
//       final newActivity = Activity(
//         name: _currentActivity!.name,
//         imagePath: _currentActivity!.imagePath,
//         color: _currentActivity!.color,
//         food: foodValue,
//         dateTime: DateTime(
//           _selectedDate.year,
//           _selectedDate.month,
//           _selectedDate.day,
//           _selectedTime.hour,
//           _selectedTime.minute,
//         ),
//         note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
//         imagePathLocal: _selectedImage?.path,
//         videoPathLocal: _selectedVideo?.path,
//       );
//
//       final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//       activityNotifier.addActivity(newActivity);
//
//       Navigator.pop(context); // close loading
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Activity saved successfully!'),
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
//             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Center(
//           child: ClipOval(
//             child: Image.asset(
//               _currentActivity!.imagePath,
//               width: 70.w,
//               height: 70.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) => Icon(
//                 Icons.pets,
//                 color: _currentActivity!.color,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return Container(
//       width: 70.w,
//       height: 70.h,
//       decoration: const BoxDecoration(shape: BoxShape.circle, color: CupertinoColors.systemGrey4),
//       child: const Icon(CupertinoIcons.photo, size: 32, color: CupertinoColors.systemGrey),
//     );
//   }
//
//   Widget _buildSelectedImage() {
//     if (_selectedImage == null) return const SizedBox.shrink();
//     return Padding(
//       padding: EdgeInsets.only(top: 8.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Selected Image:', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
//           SizedBox(height: 8.h),
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12.r),
//                 child: Image.file(_selectedImage!, width: 100.w, height: 100.h, fit: BoxFit.cover),
//               ),
//               Positioned(
//                 top: 4,
//                 right: 4,
//                 child: GestureDetector(
//                   onTap: () => setState(() => _selectedImage = null),
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
//                     child: const Icon(Icons.close, size: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSelectedVideo() {
//     if (_selectedVideo == null) return const SizedBox.shrink();
//     return Padding(
//       padding: EdgeInsets.only(top: 8.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Selected Video:', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
//           SizedBox(height: 8.h),
//           Stack(
//             children: [
//               Container(
//                 width: 100.w,
//                 height: 100.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                   color: const Color(0xFF820DFF).withOpacity(0.1),
//                 ),
//                 child: const Center(child: Icon(Icons.videocam, size: 40, color: Color(0xFF820DFF))),
//               ),
//               Positioned(
//                 top: 4,
//                 right: 4,
//                 child: GestureDetector(
//                   onTap: () => setState(() => _selectedVideo = null),
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
//                     child: const Icon(Icons.close, size: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrinkQuantitySelector() {
//     const double ozToMl = 1.0;
//     double displayValue = _isOzUnit ? _drinkQuantityOz : _drinkQuantityOz * ozToMl;
//
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7F6),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: 90.w,
//                 height: 45.h,
//                 decoration:const BoxDecoration(
//                     color: Color(0xFFFFFFFF)
//                 ) ,
//                 child: IconButton(
//                   icon: const Icon(Icons.remove, color: Color(0xFF820DFF)),
//                   onPressed: () {
//                     setState(() {
//                       if (_drinkQuantityOz >= 0.5) _drinkQuantityOz -= 0.5;
//                     });
//                   },
//                 ),
//               ),
//               Text(
//                 displayValue.toStringAsFixed(1),
//                 style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 width: 90.w,
//                 height: 45.h,
//                 decoration:const BoxDecoration(
//                   color: Color(0xFFFFFFFF)
//                 ) ,
//                 child:IconButton(
//                   icon: const Icon(Icons.add, color: Color(0xFF820DFF)),
//                   onPressed: () {
//                     setState(() {
//                       if (_drinkQuantityOz <= 49.5) _drinkQuantityOz += 0.5;
//                     });
//                   },
//                 ),
//               )
//
//             ],
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7F6),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Row(
//             children: [
//               // Left side - oz button
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _isOzUnit = true),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     decoration: BoxDecoration(
//                       color: _isOzUnit ? const Color(0xFF820DFF) : Colors.transparent,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10.r),
//                         bottomLeft: Radius.circular(10.r),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'oz',
//                         style: TextStyle(
//                           color: _isOzUnit ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Right side - mL button
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _isOzUnit = false),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     decoration: BoxDecoration(
//                       color: !_isOzUnit ? const Color(0xFF820DFF) : Colors.transparent,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(20.r),
//                         bottomRight: Radius.circular(20.r),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'mL',
//                         style: TextStyle(
//                           color: !_isOzUnit ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('MM-dd-yyyy');
//     final timeFormat = DateFormat('HH:mm');
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.background,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(CupertinoIcons.chevron_left),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: _saveActivity,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.background,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(CupertinoIcons.check_mark),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.h),
//
//             // Activity preview
//             Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF4F7F6),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Row(
//                 children: [
//                   _buildActivityImage(),
//                   SizedBox(width: 20.w),
//                   Expanded(
//                     child: Text(
//                       _currentActivity?.name ?? 'No Activity Selected',
//                       style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 12.h),
//
//             // Conditional: Food input OR Drink quantity selector
//             if (_currentActivity?.name.toLowerCase() == 'drink')
//               _buildDrinkQuantitySelector()
//             else
//               TextField(
//                 controller: _foodController,
//                 textAlign: TextAlign.center,
//                 decoration: InputDecoration(
//                   hintText: '+ Add food name or type',
//                   hintStyle: TextStyle(color: const Color(0xFF820DFF), fontSize: 16.sp),
//                   filled: true,
//                   fillColor: const Color(0xFFF4F7F6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             SizedBox(height: 10.h),
//             // Date
//             Text('Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 4.h),
//             GestureDetector(
//               onTap: _selectDate,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(dateFormat.format(_selectedDate), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                     const Icon(Icons.calendar_month),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.h),
//             // Time
//             Text('Time', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 4.h),
//             GestureDetector(
//               onTap: _selectTime,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       timeFormat.format(DateTime(2000, 1, 1, _selectedTime.hour, _selectedTime.minute)),
//                       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//                     ),
//                     const Icon(Icons.access_time),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.h),
//
//             // Note
//             Text('Note', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 4.h),
//             TextField(
//               controller: _noteController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'Add a note about this activity...',
//                 filled: true,
//                 fillColor: const Color(0xFFF3F6F3),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
//                 contentPadding: EdgeInsets.all(16.w),
//               ),
//             ),
//             SizedBox(height: 16.h),
//
//             // Add Image
//             GestureDetector(
//               onTap: _showImageSourceDialog,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 decoration: BoxDecoration(color: const Color(0xFFF3F6F3), borderRadius: BorderRadius.circular(12.r)),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
//                     SizedBox(width: 12.w),
//                     const Text('+ Add Image', style: TextStyle(color: Color(0xFF820DFF), fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//             _buildSelectedImage(),
//             SizedBox(height: 10.h),
//
//             // Add Video
//             GestureDetector(
//               onTap: _showVideoSourceDialog,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 decoration: BoxDecoration(color: const Color(0xFFF3F6F3), borderRadius: BorderRadius.circular(12.r)),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.videocam, color: Color(0xFF820DFF)),
//                     SizedBox(width: 12.w),
//                     const Text('+ Add Video', style: TextStyle(color: Color(0xFF820DFF), fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//             _buildSelectedVideo(),
//             SizedBox(height: 20.h),
//
//             // Save Button
//             RoundButton(
//               title: 'Save',
//               isSelected: true,
//               textColors: Colors.white,
//               backgroundColors: AppColors.vibrantPurple,
//               onPress: _saveActivity,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
