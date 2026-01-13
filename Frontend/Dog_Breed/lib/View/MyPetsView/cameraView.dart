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
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRearCamera = true;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize the future immediately
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No camera found!');
      }

      _controller = CameraController(
        _isRearCamera ? cameras.first : cameras.last,
        ResolutionPreset.high,
        enableAudio: false,
      );

      return _controller!.initialize();
    } catch (e) {
      debugPrint("Camera init error: $e");
      rethrow;
    }
  }
  Future<void> _toggleFlash() async {
    _isFlashOn = !_isFlashOn;
    await _controller?.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile? photo = await _controller
          ?.takePicture(); // Fixed: takePicture()
      final File imageFile = File(photo!.path);

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
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _initializeControllerFuture = _initializeCamera();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Scan', style: TextStyle(color:Theme.of(context).colorScheme.onSurface, fontSize: 30.sp,  fontWeight: FontWeight.w400, fontFamily: 'Sora', )),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              size: 34,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(child: CameraPreview(_controller!));
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
          // UI Overlay
          Column(
            children: [
              // Dog Face Focus Frame (Centered in remaining space)
              Expanded(
                child: Center(
                  child: Container(
                    width: 300.w,
                    height: 300.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 6),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),
              ),

              // Bottom Controls
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.background, // Dark background for controls
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Gallery button
                        GestureDetector(
                          onTap: _pickFromGallery,
                          child: Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 35.sp,
                          ),
                        ),

                        // Capture button
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF820DFF),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Info button
                        GestureDetector(
                          onTap: () => _showInfoDialog(context),
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 35.sp,
                          ),
                        ),
                      ],
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

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: const Color(0xFF9B59B6), size: 28.sp),
            SizedBox(width: 10.w),
            Text(
              "How to use",
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(Icons.wb_sunny_outlined, "Ensure good lighting for better results."),
            _buildInfoItem(Icons.center_focus_strong, "Fit the dog's face inside the white frame."),
            _buildInfoItem(Icons.touch_app_outlined, "Tap the purple button to identify the breed."),
            _buildInfoItem(Icons.photo_library_outlined, "You can also pick a photo from your gallery."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Got it!",
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF9B59B6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF9B59B6), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// // lib/View/Cameraview.dart
//
// import 'dart:io';
// import 'package:camera/camera.dart'; // Fixed import
// import 'package:dog_breed/View/MyPetsView/DogIdentificationScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
//
// List<CameraDescription> cameras = [];
//
// class Cameraview extends StatefulWidget {
//   const Cameraview({super.key});
//
//   @override
//   State<Cameraview> createState() => _CameraviewState();
// }
//
// class _CameraviewState extends State<Cameraview> with WidgetsBindingObserver {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   bool _isRearCamera = true;
//   bool _isFlashOn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     // Initialize the future immediately
//     _initializeControllerFuture = _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         throw Exception('No camera found!');
//       }
//
//       _controller = CameraController(
//         _isRearCamera ? cameras.first : cameras.last,
//         ResolutionPreset.high,
//         enableAudio: false,
//       );
//
//       return _controller!.initialize();
//     } catch (e) {
//       debugPrint("Camera init error: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> _toggleCamera() async {
//     _isRearCamera = !_isRearCamera;
//     await _controller?.dispose();
//     await _initializeCamera();
//   }
//
//   Future<void> _toggleFlash() async {
//     _isFlashOn = !_isFlashOn;
//     await _controller?.setFlashMode(
//       _isFlashOn ? FlashMode.torch : FlashMode.off,
//     );
//     if (mounted) setState(() {});
//   }
//
//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//       final XFile? photo = await _controller
//           ?.takePicture(); // Fixed: takePicture()
//       final File imageFile = File(photo!.path);
//
//       if (!mounted) return;
//
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => DogIdentificationScreen(imageFile: imageFile),
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error taking photo: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to take photo: $e')));
//     }
//   }
//
//   // Gallery picker
//   Future<void> _pickFromGallery() async {
//     final picker = ImagePicker(); // Fixed: ImagePicker()
//     final XFile? pickedFile = await picker.pickImage(
//       source: ImageSource.gallery, // Fixed: ImageSource
//       imageQuality: 95,
//     );
//
//     if (pickedFile != null && mounted) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) =>
//               DogIdentificationScreen(imageFile: File(pickedFile.path)),
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final CameraController? cameraController = _controller;
//
//     if (!cameraController!.value.isInitialized) return;
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _initializeCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Camera Preview
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return Positioned.fill(child: CameraPreview(_controller!));
//               } else if (snapshot.hasError) {
//                 return const Center(
//                   child: Text(
//                     'Camera Error',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF9B59B6)),
//                 );
//               }
//             },
//           ),
//
//           // Top Bar
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(
//                       Icons.close,
//                       size: 34,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _toggleFlash,
//                     icon: Icon(
//                       _isFlashOn ? Icons.flash_on : Icons.flash_off,
//                       size: 34,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Dog Face Focus Frame
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
//           // Bottom Controls
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 50.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Gallery
//                   GestureDetector(
//                     onTap: _pickFromGallery,
//                     child: Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(12.r),
//                         border: Border.all(color: Colors.white, width: 3),
//                       ),
//                       child: Icon(
//                         Icons.photo_library,
//                         color: Colors.white,
//                         size: 30.sp,
//                       ),
//                     ),
//                   ),
//
//                   // Capture Button
//                   GestureDetector(
//                     onTap: _takePicture,
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
//                   // Flip Camera
//                   GestureDetector(
//                     onTap: _toggleCamera,
//                     child: Container(
//                       padding: EdgeInsets.all(12.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Icon(
//                         Icons.flip_camera_ios,
//                         color: Colors.white,
//                         size: 32.sp,
//                       ),
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
