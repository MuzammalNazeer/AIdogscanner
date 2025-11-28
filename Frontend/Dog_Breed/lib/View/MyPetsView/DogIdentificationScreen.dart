// lib/View/MyPetsView/DogIdentificationScreen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'DogResultScreen.dart';

class DogIdentificationScreen extends StatefulWidget {
  final File imageFile;

  const DogIdentificationScreen({super.key, required this.imageFile});

  @override
  State<DogIdentificationScreen> createState() => _DogIdentificationScreenState();
}

class _DogIdentificationScreenState extends State<DogIdentificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation 100% → Go to full result screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DogResultScreen(imageFile: widget.imageFile),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Animated Circle + Dog + Percentage
            SizedBox(
              width: 240.w,
              height: 240.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Purple Circle
                  SizedBox(
                    width: 220.w,
                    height: 220.h,
                    child: CircularProgressIndicator(
                      value: _animation.value,
                      strokeWidth: 14,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9B59B6)),
                      strokeCap: StrokeCap.round,
                    ),
                  ),


                  // Percentage + "Analyzing..." Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_animation.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 52.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF9B59B6),
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 3),
                              blurRadius: 8,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Analyzing...',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 80.h),

            // Title
            Text(
              'AI identifying Your DOG',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),
            // Subtitle
            Text(
              'This usually takes up 1 minute...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



// // lib/View/MyPetsView/DogIdentificationScreen.dart
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DogIdentificationScreen extends StatefulWidget {
//   final File imageFile;
//
//   const DogIdentificationScreen({
//     super.key,
//     required this.imageFile,
//   });
//
//   @override
//   State<DogIdentificationScreen> createState() => _DogIdentificationScreenState();
// }
//
// class _DogIdentificationScreenState extends State<DogIdentificationScreen> {
//   bool isProcessing = true;
//   String breedName = "";
//   double confidence = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _runDogBreedDetection();
//   }
//
//   // Replace this with your real AI API later
//   Future<void> _runDogBreedDetection() async {
//     // Simulate AI processing time
//     await Future.delayed(const Duration(seconds: 4));
//
//     if (!mounted) return;
//
//     setState(() {
//       isProcessing = false;
//       breedName = "Shih Tzu";
//       confidence = 98.7;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               // Close button
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: Icon(Icons.close, size: 32.sp, color: Colors.black54),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//
//               SizedBox(height: 40.h),
//
//               // Dog photo preview
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(24.r),
//                 child: Image.file(
//                   widget.imageFile,
//                   height: 300.h,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Processing State (Yellow Dog + Text)
//               if (isProcessing) ...[
//
//                 Text(
//                   'AI identifying Your DOG',
//                   style: TextStyle(
//                     fontSize: 26.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'This usually takes up 1 minute...',
//                   style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//               ]
//
//               // Result State
//               else ...[
//                 Icon(Icons.pets, size: 90.sp, color: const Color(0xFF9B59B6)),
//                 SizedBox(height: 24.h),
//                 Text(
//                   breedName,
//                   style: TextStyle(
//                     fontSize: 38.sp,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF9B59B6),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   '${confidence.toStringAsFixed(1)}% confidence',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 50.h),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF9B59B6),
//                     padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Navigate to breed details page
//                   },
//                   child: Text(
//                     'See Detailed Info',
//                     style: TextStyle(fontSize: 18.sp, color: Colors.white),
//                   ),
//                 ),
//               ],
//
//               const Spacer(),
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class DogIdentificationScreen extends StatefulWidget {
// //   final File imageFile;
// //
// //   const DogIdentificationScreen({super.key, required this.imageFile});
// //
// //   @override
// //   State<DogIdentificationScreen> createState() => _DogIdentificationScreenState();
// // }
// //
// // class _DogIdentificationScreenState extends State<DogIdentificationScreen> {
// //   bool isProcessing = true;
// //   String breed = "";
// //   double confidence = 0.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _simulateAIProcessing();
// //   }
// //
// //   Future<void> _simulateAIProcessing() async {
// //     // Replace this with your real API call later
// //     await Future.delayed(const Duration(seconds: 4));
// //
// //     if (mounted) {
// //       setState(() {
// //         isProcessing = false;
// //         breed = "Shih Tzu";
// //         confidence = 98.7;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Close button
// //             Align(
// //               alignment: Alignment.topLeft,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20),
// //                 child: IconButton(
// //                   icon: const Icon(Icons.close, size: 32),
// //                   onPressed: () => Navigator.pop(context),
// //                 ),
// //               ),
// //             ),
// //
// //             // Dog photo
// //             Expanded(
// //               flex: 3,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 40.w),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(32.r),
// //                   child: Image.file(
// //                     widget.imageFile,
// //                     fit: BoxFit.cover,
// //                     width: double.infinity,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             SizedBox(height: 40.h),
// //
// //             // Loading OR Result
// //             Expanded(
// //               flex: 2,
// //               child: isProcessing
// //                   ? Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   // Cute yellow dog animation (replace with your asset)
// //                   Image.asset(
// //                     'assets/images/dog_loading.gif', // or .png
// //                     width: 120.w,
// //                     height: 120.h,
// //                   ),
// //                   SizedBox(height: 30.h),
// //                   Text(
// //                     'AI Identifying Your DOG',
// //                     style: TextStyle(
// //                       fontSize: 24.sp,
// //                       fontWeight: FontWeight.bold,
// //                       color: const Color(0xFF9B59B6),
// //                     ),
// //                   ),
// //                   SizedBox(height: 12.h),
// //                   Text(
// //                     'This usually takes up 1 minute...',
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       color: Colors.grey[600],
// //                     ),
// //                   ),
// //                 ],
// //               )
// //                   : Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.pets, size: 80.sp, color: const Color(0xFF9B59B6)),
// //                   SizedBox(height: 20.h),
// //                   Text(
// //                     breed,
// //                     style: TextStyle(
// //                       fontSize: 36.sp,
// //                       fontWeight: FontWeight.bold,
// //                       color: const Color(0xFF9B59B6),
// //                     ),
// //                   ),
// //                   SizedBox(height: 12.h),
// //                   Text(
// //                     '${confidence.toStringAsFixed(1)}% confidence',
// //                     style: TextStyle(
// //                       fontSize: 20.sp,
// //                       color: Colors.green[700],
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   SizedBox(height: 40.h),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF9B59B6),
// //                       padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 18.h),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(30.r),
// //                       ),
// //                     ),
// //                     onPressed: () {
// //                       // Go to breed details, share, etc.
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text('Detailed info coming soon!')),
// //                       );
// //                     },
// //                     child: Text(
// //                       'See Detailed Info',
// //                       style: TextStyle(fontSize: 18.sp, color: Colors.white),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }