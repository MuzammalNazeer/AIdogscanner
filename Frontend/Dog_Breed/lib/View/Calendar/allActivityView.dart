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

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.selectedActivity;
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
              primary: Color(0xFF820DFF), // Header color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor: Colors.white, // Dialog background
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF820DFF), // Button text color
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
              primary: Color(0xFF820DFF), // Header color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor: Colors.white, // Dialog background
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF820DFF), // Button text color
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
                leading: const Icon(Icons.photo_library, color: Color(0xFF820DFF)),
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
                leading: const Icon(Icons.video_library, color: Color(0xFF820DFF)),
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

    if (_foodController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter food name or type');
      return;
    }

    // Show loading dialog
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
        food: _foodController.text.trim(),
        dateTime: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        imagePathLocal: _selectedImage?.path,
        videoPathLocal: _selectedVideo?.path,
      );

      // Save using provider (ChangeNotifier)
      final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
      activityNotifier.addActivity(newActivity);

      // Success flow
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
          Navigator.pop(context, true); // close screen
        }
      });
    } catch (e) {
      Navigator.pop(context); // close loading
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
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Center(
          child: ClipOval(
            child: Image.asset(
              _currentActivity!.imagePath,
              width: 70.w,
              height: 70.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.pets,
                color: _currentActivity!.color,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: CupertinoColors.systemGrey4),
      child: const Icon(CupertinoIcons.photo, size: 32, color: CupertinoColors.systemGrey),
    );
  }

  Widget _buildSelectedImage() {
    if (_selectedImage == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Image:', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
          SizedBox(height: 8.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(_selectedImage!, width: 100.w, height: 100.h, fit: BoxFit.cover),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
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
          Text('Selected Video:', style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
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
                child: const Center(child: Icon(Icons.videocam, size: 40, color: Color(0xFF820DFF))),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedVideo = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM-dd-yyyy');
    final timeFormat = DateFormat('HH:mm');

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
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Food field
            TextField(
              controller: _foodController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '+ Add food name or type',
                hintStyle: TextStyle(color: const Color(0xFF820DFF), fontSize: 16.sp),
                filled: true,
                fillColor: const Color(0xFFF4F7F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 16.h),

            // Date
            Text('Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateFormat.format(_selectedDate), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Time
            Text('Time', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeFormat.format(DateTime(2000, 1, 1, _selectedTime.hour, _selectedTime.minute)),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Note
            Text('Note', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add a note about this activity...',
                filled: true,
                fillColor: const Color(0xFFF3F6F3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
            SizedBox(height: 24.h),

            // Add Image
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(color: const Color(0xFFF3F6F3), borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
                    SizedBox(width: 12.w),
                    const Text('+ Add Image', style: TextStyle(color: Color(0xFF820DFF), fontWeight: FontWeight.w500)),
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
                decoration: BoxDecoration(color: const Color(0xFFF3F6F3), borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    const Icon(Icons.videocam, color: Color(0xFF820DFF)),
                    SizedBox(width: 12.w),
                    const Text('+ Add Video', style: TextStyle(color: Color(0xFF820DFF), fontWeight: FontWeight.w500)),
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
//   @override
//   void initState() {
//     super.initState();
//     _currentActivity = widget.selectedActivity;
//   }
//
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
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
//     if (_foodController.text.trim().isEmpty) {
//       _showErrorSnackBar('Please enter food name or type');
//       return;
//     }
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(color: AppColors.vibrantPurple),
//       ),
//     );
//
//     try {
//       final newActivity = Activity(
//         name: _currentActivity!.name,
//         imagePath: _currentActivity!.imagePath,
//         color: _currentActivity!.color,
//         food: _foodController.text.trim(),
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
//       // Save using provider (ChangeNotifier)
//       final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
//       activityNotifier.addActivity(newActivity);
//
//       // Success flow
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
//           Navigator.pop(context, true); // close screen
//         }
//       });
//     } catch (e) {
//       Navigator.pop(context); // close loading
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
//             // Header with back and save buttons
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
//             SizedBox(height: 16.h),
//
//             // Food field
//             TextField(
//               controller: _foodController,
//               textAlign: TextAlign.center,
//               decoration: InputDecoration(
//                 hintText: '+ Add food name or type',
//                 hintStyle: TextStyle(color: const Color(0xFF820DFF), fontSize: 16.sp),
//                 filled: true,
//                 fillColor: const Color(0xFFF4F7F6),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
//               ),
//             ),
//             SizedBox(height: 16.h),
//
//             // Date
//             Text('Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 8.h),
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
//             SizedBox(height: 16.h),
//
//             // Time
//             Text('Time', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 8.h),
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
//             SizedBox(height: 16.h),
//
//             // Note
//             Text('Note', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
//             SizedBox(height: 8.h),
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
//             SizedBox(height: 24.h),
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
//             SizedBox(height: 16.h),
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
//             SizedBox(height: 32.h),
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
//
//
//
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/config/components/roundButton.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';
// //
// // import '../../View_model/activity_provider.dart';
// // import '../../activity_model.dart';
// //
// //
// // class Allactivityview extends StatefulWidget {
// //   final Activity? selectedActivity;
// //
// //   const Allactivityview({super.key, this.selectedActivity});
// //
// //   @override
// //   State<Allactivityview> createState() => _AllactivityviewState();
// // }
// //
// // class _AllactivityviewState extends State<Allactivityview> {
// //   DateTime _selectedDate = DateTime.now();
// //   TimeOfDay _selectedTime = TimeOfDay.now();
// //   final TextEditingController _foodController = TextEditingController();
// //   final TextEditingController _noteController = TextEditingController();
// //
// //   File? _selectedImage;
// //   File? _selectedVideo;
// //   final ImagePicker _picker = ImagePicker();
// //
// //   Activity? _currentActivity;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _currentActivity = widget.selectedActivity;
// //   }
// //
// //   Future<void> _selectDate() async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() => _selectedDate = picked);
// //     }
// //   }
// //
// //   Future<void> _selectTime() async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: _selectedTime,
// //     );
// //     if (picked != null && picked != _selectedTime) {
// //       setState(() => _selectedTime = picked);
// //     }
// //   }
// //
// //   Future<void> _pickImage(ImageSource source) async {
// //     try {
// //       final XFile? image = await _picker.pickImage(source: source);
// //       if (image != null) {
// //         setState(() {
// //           _selectedImage = File(image.path);
// //         });
// //       }
// //     } catch (e) {
// //       print('Error picking image: $e');
// //     }
// //   }
// //
// //   Future<void> _pickVideo(ImageSource source) async {
// //     try {
// //       final XFile? video = await _picker.pickVideo(source: source);
// //       if (video != null) {
// //         setState(() {
// //           _selectedVideo = File(video.path);
// //         });
// //       }
// //     } catch (e) {
// //       print('Error picking video: $e');
// //     }
// //   }
// //
// //   void _showImageSourceDialog() {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) {
// //         return SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.camera_alt, color: Color(0xFF820DFF)),
// //                 title: const Text('Take Photo'),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _pickImage(ImageSource.camera);
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(
// //                   Icons.photo_library,
// //                   color: Color(0xFF820DFF),
// //                 ),
// //                 title: const Text('Choose from Gallery'),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _pickImage(ImageSource.gallery);
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   void _showVideoSourceDialog() {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) {
// //         return SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.videocam, color: Color(0xFF820DFF)),
// //                 title: const Text('Record Video'),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _pickVideo(ImageSource.camera);
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(
// //                   Icons.video_library,
// //                   color: Color(0xFF820DFF),
// //                 ),
// //                 title: const Text('Choose from Gallery'),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _pickVideo(ImageSource.gallery);
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildActivityImage() {
// //     if (_currentActivity != null) {
// //       return Container(
// //         width: 70.w,
// //         height: 70.h,
// //         decoration: BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 8,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Center(
// //           child: Container(
// //             width: 60.w, // Slightly smaller than parent
// //             height: 60.h,
// //             decoration: const BoxDecoration(
// //               shape: BoxShape.circle,
// //             ),
// //             child: ClipOval(
// //               child: Image.asset(
// //                 _currentActivity!.imagePath,
// //                 fit: BoxFit.contain, // This will keep aspect ratio
// //                 errorBuilder: (context, error, stackTrace) {
// //                   return Container(
// //                     width: double.infinity,
// //                     height: double.infinity,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: _currentActivity!.color.withOpacity(0.3),
// //                     ),
// //                     child: Center(
// //                       child: Icon(
// //                         Icons.pets,
// //                         size: 28.w,
// //                         color: _currentActivity!.color,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       width: 70.w,
// //       height: 70.h,
// //       decoration: const BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: CupertinoColors.systemGrey4,
// //       ),
// //       child: const Center(
// //         child: Icon(
// //           CupertinoIcons.photo,
// //           size: 32,
// //           color: CupertinoColors.systemGrey,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSelectedImage() {
// //     if (_selectedImage != null) {
// //       return Container(
// //         margin: EdgeInsets.only(top: 8.h),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Selected Image:',
// //               style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// //             ),
// //             SizedBox(height: 8.h),
// //             Stack(
// //               children: [
// //                 Container(
// //                   width: 100.w,
// //                   height: 100.h,
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     border: Border.all(color: Colors.grey[300]!),
// //                   ),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     child: Image.file(
// //                       _selectedImage!,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (_, __, ___) => Container(
// //                         color: Colors.grey[200],
// //                         child: const Icon(Icons.error, color: Colors.grey),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 4,
// //                   right: 4,
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         _selectedImage = null;
// //                       });
// //                     },
// //                     child: Container(
// //                       width: 24,
// //                       height: 24,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colors.black54,
// //                       ),
// //                       child: const Icon(
// //                         Icons.close,
// //                         size: 16,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //     return const SizedBox.shrink();
// //   }
// //
// //   Widget _buildSelectedVideo() {
// //     if (_selectedVideo != null) {
// //       return Container(
// //         margin: EdgeInsets.only(top: 8.h),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Selected Video:',
// //               style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
// //             ),
// //             SizedBox(height: 8.h),
// //             Stack(
// //               children: [
// //                 Container(
// //                   width: 100.w,
// //                   height: 100.h,
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     border: Border.all(color: Colors.grey[300]!),
// //                     color: const Color(0xFF820DFF).withOpacity(0.1),
// //                   ),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const Icon(
// //                         Icons.videocam,
// //                         size: 40,
// //                         color: Color(0xFF820DFF),
// //                       ),
// //                       SizedBox(height: 4.h),
// //                       Text(
// //                         'Video Selected',
// //                         style: TextStyle(
// //                           fontSize: 12.sp,
// //                           color: const Color(0xFF820DFF),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 4,
// //                   right: 4,
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         _selectedVideo = null;
// //                       });
// //                     },
// //                     child: Container(
// //                       width: 24,
// //                       height: 24,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colors.black54,
// //                       ),
// //                       child: const Icon(
// //                         Icons.close,
// //                         size: 16,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //     return const SizedBox.shrink();
// //   }
// //   // void _saveActivity() async {
// //   //   // Validate required fields
// //   //   if (_currentActivity == null) {
// //   //     _showErrorSnackBar('Please select an activity first');
// //   //     return;
// //   //   }
// //   //
// //   //   if (_foodController.text.trim().isEmpty) {
// //   //     _showErrorSnackBar('Please enter food name or type');
// //   //     return;
// //   //   }
// //   //
// //   //   // Show loading
// //   //   _showLoadingDialog();
// //   //
// //   //   try {
// //   //     final viewModel = ref.read(activityViewModelProvider.notifier);
// //   //
// //   //     // Save the activity
// //   //     await viewModel.saveActivity(
// //   //       activityName: _currentActivity!.name,
// //   //       activityImagePath: _currentActivity!.imagePath,
// //   //       activityColor: _currentActivity!.color,
// //   //       food: _foodController.text.trim(),
// //   //       date: _selectedDate,
// //   //       time: _selectedTime,
// //   //       note: _noteController.text.trim(),
// //   //       imagePath: _selectedImage?.path,
// //   //       videoPath: _selectedVideo?.path,
// //   //     );
// //   //
// //   //     // Hide loading
// //   //     if (context.mounted) {
// //   //       Navigator.of(context).pop(); // Close loading dialog
// //   //
// //   //       // Show success message
// //   //       _showSuccessSnackBar('Activity saved successfully!');
// //   //
// //   //       // Wait a moment then close the screen
// //   //       await Future.delayed(const Duration(milliseconds: 500));
// //   //
// //   //       // Close the screen and pass success result
// //   //       if (context.mounted) {
// //   //         Navigator.pop(context, true);
// //   //       }
// //   //     }
// //   //
// //   //   } catch (e) {
// //   //     // Hide loading
// //   //     if (context.mounted) {
// //   //       Navigator.of(context).pop(); // Close loading dialog
// //   //
// //   //       // Show error message
// //   //       _showErrorSnackBar('Failed to save activity: ${e.toString()}');
// //   //     }
// //   //   }
// //   // }
// //
// // // Helper methods
// //   void _showLoadingDialog() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) {
// //         return AlertDialog(
// //           backgroundColor: Colors.transparent,
// //           elevation: 0,
// //           content: Center(
// //             child: CircularProgressIndicator(
// //               color: AppColors.vibrantPurple,
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   void _showSuccessSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Row(
// //           children: [
// //             Icon(Icons.check_circle, color: Colors.white, size: 20.w),
// //             SizedBox(width: 8.w),
// //             Expanded(
// //               child: Text(
// //                 message,
// //                 style: TextStyle(
// //                   fontSize: 14.sp,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         backgroundColor: Colors.green,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8.r),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Row(
// //           children: [
// //             Icon(Icons.error_outline, color: Colors.white, size: 20.w),
// //             SizedBox(width: 8.w),
// //             Expanded(
// //               child: Text(
// //                 message,
// //                 style: TextStyle(
// //                   fontSize: 14.sp,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         backgroundColor: Colors.red,
// //         duration: const Duration(seconds: 3),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8.r),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dateFormat = DateFormat('MM-dd-yyyy');
// //     final timeFormat = DateFormat('HH:mm');
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 GestureDetector(
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                   },
// //                   child: Container(
// //                     width: 40.305.w,
// //                     height: 40.305.h,
// //                     padding: const EdgeInsets.all(8.96),
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).colorScheme.background,
// //                       borderRadius: BorderRadius.circular(8.96),
// //                     ),
// //                     child: Icon(
// //                       CupertinoIcons.chevron_left,
// //                       size: 26.sp,
// //                       color: Theme.of(context).colorScheme.onSurface,
// //                     ),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 GestureDetector(
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                   },
// //                   child: Container(
// //                     width: 40.305.w,
// //                     height: 40.305.h,
// //                     padding: const EdgeInsets.all(8.96),
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).colorScheme.background,
// //                       borderRadius: BorderRadius.circular(8.96),
// //                     ),
// //                     child: Icon(
// //                       CupertinoIcons.check_mark,
// //                       size: 26.sp,
// //                       color: Theme.of(context).colorScheme.onSurface,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 11.h,),
// //             Container(
// //               width: double.infinity,
// //               height: 110.h,
// //               padding: EdgeInsets.all(16.w),
// //               decoration: BoxDecoration(
// //                 color:  const Color(0xFFF4F7F6),
// //                 borderRadius: BorderRadius.circular(12.r),
// //               ),
// //               child: Row(
// //                 children: [
// //                   // Activity Icon
// //                   Container(
// //                     width: 70.w,
// //                     height: 70.h,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.white,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.1),
// //                           blurRadius: 8,
// //                           offset: const Offset(0, 2),
// //                         ),
// //                       ],
// //                     ),
// //                     child: _buildActivityImage(),
// //                   ),
// //                   SizedBox(width: 20.w),
// //                   Expanded(
// //                     child: Text(
// //                       _currentActivity?.name ?? 'No Activity Selected',
// //                       style: TextStyle(
// //                         fontFamily: "Sora",
// //                         fontSize: 30.sp,
// //                         fontWeight: FontWeight.w700,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 8.h),
// //             Center(
// //               child: TextField(
// //                 controller: _foodController,
// //                 textAlign: TextAlign.center,
// //                 decoration: InputDecoration(
// //                   hintText: '+ Add food name or type',
// //                   hintStyle: TextStyle(color: const Color(0xFF820DFF), fontSize: 16.sp),
// //                   filled: true,
// //                   fillColor:const Color(0xFFF4F7F6),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   contentPadding: EdgeInsets.symmetric(
// //                     horizontal: 16.w,
// //                     vertical: 14.h,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 10.h),
// //             Text(
// //               'Date',
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 color: Colors.grey[700],
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             SizedBox(height: 4.h),
// //             GestureDetector(
// //               onTap: _selectDate,
// //               child: Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[50],
// //                   borderRadius: BorderRadius.circular(12.r),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       dateFormat.format(_selectedDate),
// //                       style: TextStyle(
// //                         fontSize: 16.sp,
// //                         color: Color(0xFF000000),
// //                           fontWeight: FontWeight.bold
// //                       ),
// //                     ),
// //                     const Icon(
// //                       Icons.calendar_month,
// //                       color: Color(0xFF000000),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 14.h),
// //             Text(
// //               'Time',
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 color: Colors.grey[700],
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             SizedBox(height: 4.h),
// //             GestureDetector(
// //               onTap: _selectTime,
// //               child: Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[50],
// //                   borderRadius: BorderRadius.circular(12.r),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       timeFormat.format(
// //                         DateTime(
// //                           2025,
// //                           1,
// //                           1,
// //                           _selectedTime.hour,
// //                           _selectedTime.minute,
// //                         ),
// //                       ),
// //                       style: TextStyle(
// //                         fontSize: 16.sp,
// //                         color: Color(0xFF000000),
// //                           fontWeight: FontWeight.bold
// //                       ),
// //                     ),
// //                     const Icon(Icons.access_time, color: Color(0xFF000000)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 14.h),
// //             Text(
// //               'Note',
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 color: Colors.grey[700],
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             SizedBox(height: 4.h),
// //             TextField(
// //               controller: _noteController,
// //               maxLines: 5,
// //               decoration: InputDecoration(
// //                 hintText: 'Add a note about this activity...',
// //                 hintStyle: TextStyle(color: const Color(0xFF000000), fontSize: 14.sp,fontWeight: FontWeight.bold),
// //                 filled: true,
// //                 fillColor: const Color(0xFFF3F6F3),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12.r),
// //                   borderSide: BorderSide.none,
// //                 ),
// //                 contentPadding: EdgeInsets.all(16.w),
// //               ),
// //             ),
// //             SizedBox(height: 44.h),
// //             GestureDetector(
// //               onTap: _showImageSourceDialog,
// //               child: Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
// //                 decoration: BoxDecoration(
// //                   color:  const Color(0xFFF3F6F3),
// //                   borderRadius: BorderRadius.circular(12.r),
// //
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(
// //                       Icons.camera_alt,
// //                       color: const Color(0xFF820DFF),
// //                       size: 24.w,
// //                     ),
// //                     SizedBox(width: 12.w),
// //                     Text(
// //                       '+ Add Image',
// //                       style: TextStyle(
// //                         fontSize: 16.sp,
// //                         color: const Color(0xFF820DFF),
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             _buildSelectedImage(),
// //             SizedBox(height: 16.h),
// //             GestureDetector(
// //               onTap: _showVideoSourceDialog,
// //               child: Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
// //                 decoration: BoxDecoration(
// //                   color:  const Color(0xFFF3F6F3),
// //                   borderRadius: BorderRadius.circular(12.r),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(
// //                       Icons.videocam,
// //                       color: const Color(0xFF820DFF),
// //                       size: 24.w,
// //                     ),
// //                     SizedBox(width: 12.w),
// //                     Text(
// //                       '+ Add Video',
// //                       style: TextStyle(
// //                         fontSize: 16.sp,
// //                         color: const Color(0xFF820DFF),
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             _buildSelectedVideo(),
// //             SizedBox(height: 32.h),
// //             RoundButton(
// //               title: 'Save',
// //               isSelected: true,
// //               textColors: Colors.white,
// //               backgroundColors: AppColors.vibrantPurple,
// //               onPress: () {
// //                 // _saveActivity();
// //                 },
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
