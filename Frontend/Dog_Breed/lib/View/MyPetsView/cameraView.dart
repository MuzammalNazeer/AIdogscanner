// lib/View/Cameraview.dart

import 'dart:io';
import 'package:camera/camera.dart'; // Fixed import
import 'package:dog_breed/View/MyPetsView/DogIdentificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

List<CameraDescription> cameras = [];

class Cameraview extends StatefulWidget {
  const Cameraview({super.key});

  @override
  State<Cameraview> createState() => _CameraviewState();
}

class _CameraviewState extends State<Cameraview> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRearCamera = true;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No camera found!')));
      return;
    }

    _controller = CameraController(
      _isRearCamera ? cameras.first : cameras.last,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller
        .initialize()
        .then((_) {
          if (mounted) setState(() {});
        })
        .catchError((e) {
          debugPrint("Camera init error: $e");
        });
  }

  Future<void> _toggleCamera() async {
    _isRearCamera = !_isRearCamera;
    await _controller.dispose();
    await _initializeCamera();
  }

  Future<void> _toggleFlash() async {
    _isFlashOn = !_isFlashOn;
    await _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile photo = await _controller
          .takePicture(); // Fixed: takePicture()
      final File imageFile = File(photo.path);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DogIdentificationScreen(imageFile: imageFile),
        ),
      );
    } catch (e) {
      debugPrint("Error taking photo: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to take photo: $e')));
    }
  }

  // Gallery picker
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker(); // Fixed: ImagePicker()
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // Fixed: ImageSource
      imageQuality: 95,
    );

    if (pickedFile != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              DogIdentificationScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _controller;

    if (!cameraController!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(child: CameraPreview(_controller));
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Camera Error',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9B59B6)),
                );
              }
            },
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dog Face Focus Frame
          Center(
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 6),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
          ),

          // Bottom Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery
                  GestureDetector(
                    onTap: _pickFromGallery,
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ),

                  // Capture Button
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9B59B6),
                      ),
                      child: Center(
                        child: Container(
                          width: 75.w,
                          height: 75.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Flip Camera
                  GestureDetector(
                    onTap: _toggleCamera,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:dog_breed/View/MyPetsView/DogIdentificationScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
//
// class Cameraview extends StatefulWidget {
//   const Cameraview({super.key});
//
//   @override
//   State<Cameraview> createState() => _CameraviewState();
// }
//
// class _CameraviewState extends State<Cameraview> {
//   File? selectedImage;
//   final ImagePicker picker = ImagePicker();
//
//   // Unified function for both camera and gallery
//   Future<void> _pickAndProcessImage(ImageSource source) async {
//     final XFile? pickedFile = await picker.pickImage(
//       source: source,
//       imageQuality: 95,
//     );
//
//     if (pickedFile != null && mounted) {
//       final File imageFile = File(pickedFile.path);
//
//       // Optional: Show thumbnail preview (nice UX)
//       setState(() {
//         selectedImage = imageFile;
//       });
//
//       // Immediately go to AI identification screen
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => DogIdentificationScreen(imageFile: imageFile),
//         ),
//       ).then((_) {
//         // When user comes back from result screen → clean preview
//         if (mounted) {
//           setState(() => selectedImage = null);
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Full background: placeholder or captured preview
//           Positioned.fill(
//             child: selectedImage == null
//                 ? Image.asset(
//               'assets/images/Rectangle 56.png',
//               fit: BoxFit.cover,
//             )
//                 : Image.file(selectedImage!, fit: BoxFit.cover),
//           ),
//
//           // Top bar
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close, size: 32, color: Colors.white),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       // You can add real flash support later
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Flash toggled (coming soon)')),
//                       );
//                     },
//                     icon: const Icon(Icons.flash_on, size: 32, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Center focus frame (for dog face)
//           Center(
//             child: Container(
//               width: 300.w,
//               height: 300.h,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white, width: 6),
//                 borderRadius: BorderRadius.circular(50.r),
//               ),
//             ),
//           ),
//
//           // Bottom controls
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 50.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Gallery
//                   GestureDetector(
//                     onTap: () => _pickAndProcessImage(ImageSource.gallery),
//                     child: Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(12.r),
//                         border: Border.all(color: Colors.white, width: 3),
//                       ),
//                       child: Icon(Icons.photo_library, color: Colors.white, size: 30.sp),
//                     ),
//                   ),
//
//                   // Big capture button
//                   GestureDetector(
//                     onTap: () => _pickAndProcessImage(ImageSource.camera),
//                     child: Container(
//                       width: 90.w,
//                       height: 90.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF9B59B6),
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 75.w,
//                           height: 75.h,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Flip camera (placeholder)
//                   GestureDetector(
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Switch camera (coming soon)')),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(12.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Icon(Icons.flip_camera_ios, color: Colors.white, size: 32.sp),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:dog_breed/View/MyPetsView/DogIdentificationScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
//
// class Cameraview extends StatefulWidget {
//   const Cameraview({super.key});
//
//   @override
//   State<Cameraview> createState() => _CameraviewState();
// }
//
// class _CameraviewState extends State<Cameraview> {
//   bool isFlashOn = false;
//   File? selectedImage;
//   final ImagePicker picker = ImagePicker();
//
//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? image = await picker.pickImage(
//       source: source,
//       imageQuality: 90,
//     );
//
//     if (image != null && mounted) {
//       final File file = File(image.path);
//
//       setState(() {
//         selectedImage = file;
//       });
//
//       // Immediately go to AI identification screen
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => DogIdentificationScreen(imageFile: file),
//         ),
//       );
//
//       // Reset selectedImage so camera UI returns clean when user comes back
//       setState(() => selectedImage = null);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background image or selected photo preview
//           Positioned.fill(
//             child: selectedImage == null
//                 ? Image.asset(
//               'assets/images/Rectangle 56.png', // your placeholder
//               fit: BoxFit.cover,
//             )
//                 : Image.file(selectedImage!, fit: BoxFit.cover),
//           ),
//
//           // Top bar: Close + Flash
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close, size: 32, color: Colors.white),
//                   ),
//                   IconButton(
//                     onPressed: () => setState(() => isFlashOn = !isFlashOn),
//                     icon: Icon(
//                       isFlashOn ? Icons.flash_on : Icons.flash_off,
//                       size: 32,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Rounded focus frame in center
//           Center(
//             child: SizedBox(
//               width: 280.w,
//               height: 280.h,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40.r),
//                   border: Border.all(color: Colors.white, width: 6),
//                 ),
//               ),
//             ),
//           ),
//
//           // Bottom controls
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 40),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Gallery thumbnail
//                   GestureDetector(
//                     onTap: () => _pickImage(ImageSource.gallery),
//                     child: Container(
//                       width: 50.w,
//                       height: 50.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.r),
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: selectedImage == null
//                           ? const Icon(Icons.photo, color: Colors.white, size: 28)
//                           : ClipRRect(
//                         borderRadius: BorderRadius.circular(8.r),
//                         child: Image.file(selectedImage!, fit: BoxFit.cover),
//                       ),
//                     ),
//                   ),
//
//                   // Big capture button
//                   GestureDetector(
//                     onTap: () => _pickImage(ImageSource.camera),
//                     child: Container(
//                       width: 85.w,
//                       height: 85.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF9B59B6),
//                       ),
//                       child: Center(
//                         child: CircleAvatar(
//                           radius: 30.r,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Flip camera (optional)
//                   IconButton(
//                     onPressed: () {
//                       debugPrint("Flip camera tapped");
//                     },
//                     icon: const Icon(Icons.flip_camera_ios,
//                         size: 36, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // class Cameraview extends StatefulWidget {
// //   const Cameraview({super.key});
// //
// //   @override
// //   State<Cameraview> createState() => _CameraScreenState();
// // }
// //
// // class _CameraScreenState extends State<Cameraview> {
// //   bool isFlashOn = false;
// //
// //   File? selectedImage;
// //   final ImagePicker picker = ImagePicker();
// //
// //   Future<void> pickFromGallery() async {
// //     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// //     if (image != null) {
// //       setState(() {
// //         selectedImage = File(image.path);
// //       });
// //     }
// //   }
// //
// //   Future<void> captureFromCamera() async {
// //     final XFile? image = await picker.pickImage(source: ImageSource.camera);
// //     if (image != null) {
// //       setState(() {
// //         selectedImage = File(image.path);
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Stack(
// //         children: [
// //           Positioned.fill(
// //             child: selectedImage == null
// //                 ? Image.asset(
// //           'assets/images/Rectangle 56.png',
// //           width: 123.w,
// //           height: 166.h,
// //           fit: BoxFit.scaleDown
// //       )
// //                 : Image.file(
// //               selectedImage!,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           SafeArea(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   IconButton(
// //                     onPressed: () => Navigator.pop(context),
// //                     icon: const Icon(Icons.close, size: 32, color: Colors.white),
// //                   ),
// //                   IconButton(
// //                     onPressed: () {
// //                       setState(() => isFlashOn = !isFlashOn);
// //                     },
// //                     icon: Icon(
// //                       isFlashOn ? Icons.flash_on : Icons.flash_off,
// //                       size: 32,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: 280,
// //               height: 280,
// //               child: DecoratedBox(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(40),
// //                   border: Border.all(color: Colors.white, width: 6),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Align(
// //             alignment: Alignment.bottomCenter,
// //             child: Padding(
// //               padding: const EdgeInsets.only(bottom: 40),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   GestureDetector(
// //                     onTap: pickFromGallery,
// //                     child: Container(
// //                       width: 50,
// //                       height: 50,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(color: Colors.white, width: 2),
// //                       ),
// //                       child: selectedImage == null
// //                           ? const Icon(Icons.photo, color: Colors.white)
// //                           : ClipRRect(
// //                         borderRadius: BorderRadius.circular(8),
// //                         child: Image.file(selectedImage!, fit: BoxFit.cover),
// //                       ),
// //                     ),
// //                   ),
// //                   GestureDetector(
// //                     onTap: captureFromCamera,
// //                     child: Container(
// //                       width: 85,
// //                       height: 85,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Color(0xFF9B59B6),
// //                       ),
// //                       child: const Center(
// //                         child: CircleAvatar(
// //                           radius: 30,
// //                           backgroundColor: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   IconButton(
// //                     onPressed: () {
// //                       debugPrint("Camera flipped");
// //                     },
// //                     icon: const Icon(Icons.flip_camera_ios,
// //                         size: 36, color: Colors.white),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
