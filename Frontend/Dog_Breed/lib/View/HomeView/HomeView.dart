import 'dart:io';
import 'dart:math';

import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../View_model/ScanProvider.dart';
import '../MyPetsView/DogResultScreen.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final String userName = "Sarina";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24.w, right: 23.w, top: 18.h), // Fixed: Added .h and .w
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 17.h),
              _buildSearchBar(),
              SizedBox(height: 15.h),
              _buildPremiumBanner(),
              SizedBox(height: 17.h),
              _buildQuickActions(),
              SizedBox(height: 6.h),
              _buildIdentifyDogCard(),
              SizedBox(height: 6.h),
              _buildFoodManagementCard(),
              SizedBox(height: 6.h),
              _buildVisitsDogCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          SizedBox(
            width: 22.w, // Fixed: Added .w
            height: 22.h, // Fixed: Added .h
            child: const Icon(Icons.search, color: Color(0x99000000)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Search for Dog',
              style: TextStyle(
                color: const Color(0x99000000),
                fontFamily: 'Sora',
                fontWeight: FontWeight.w200,
                fontSize: 14.sp,
                height: 1.0,
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quickActionButton({
    required Widget image,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 86.w,
            height: 90.h,
            padding: EdgeInsets.all(6.w), // Fixed: Added .w
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Container(
              width: 57.w,
              height: 57.h,
              padding: EdgeInsets.all(6.w), // Fixed: Added .w
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: image,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/Group2.svg",
                      width: 72.w,
                      height: 37.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 5.w), // Fixed: Added .w
                    Text(
                      'Manager',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.normal,
                        fontSize: 30.sp,
                        height: 1.0,
                        letterSpacing: 0.0,
                        color: AppColors.jet,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 22.sp,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Welcome back, ',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: '$userName!',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 38.w),
            SizedBox(
              height: 92.h,
              width: 92.w,
              child: Center(
                child: Transform.rotate(
                  angle: -80.11,
                  child: Image.asset(
                    'assets/images/Group88.png',
                    width: 92.w,
                    height: 92.h,
                    color: const Color(0xFFF3F6F3),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      width: 393.w,
      height: 103.h,
      padding: EdgeInsets.all(4.w), // Fixed: Added .w
      decoration: BoxDecoration(
        color: const Color(0xFF6D09E8),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5.h,
                        left: 5.w,
                        right: 15.w,
                      ), // Fixed: Added .h and .w
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Try Premium Features 🌵',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.h), // Added spacing
                          Text(
                            'Claim your offer now and get unlimited recognition, health check and more',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  Transform.translate(
                    offset: Offset(-10.w, -18.h), // Fixed: Added .w and .h
                    child: Transform.rotate(
                      angle: -83.51 * (pi / 180),
                      child: SvgPicture.asset(
                        "assets/images/Group099.svg",
                        width: 40.w,
                        height: 42.h,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w), // Fixed: Added .w
                    child: SizedBox(
                      width: 84.w,
                      height: 36.h,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: FittedBox(
                              child: Text(
                                'GET IT',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        quickActionButton(
          image: SvgPicture.asset(
            'assets/images/Group77.svg',
            width: 52.w,
            height: 66.h,
            fit: BoxFit.contain,
          ),
          label: 'Hygiene',
          color: const Color(0xFFEF5DA8),
          onTap: () {
            Navigator.pushNamed(context, RoutesName.hygiene);
          },
        ),
        SizedBox(width: 9.w), // Fixed: Added .w
        quickActionButton(
          image: SvgPicture.asset(
            'assets/images/Group88.svg',
            width: 52.w,
            height: 66.h,
            fit: BoxFit.contain,
          ),
          label: 'Cleaning',
          color: const Color(0xFFAEAFF7),
          onTap: () {
            Navigator.pushNamed(context, RoutesName.cleaning);
          },
        ),
        SizedBox(width: 9.w), // Fixed: Added .w
        quickActionButton(
          image: SvgPicture.asset(
            'assets/images/Group99.svg',
            width: 52.w,
            height: 66.h,
            fit: BoxFit.contain,
          ),
          label: 'Medical',
          color: const Color(0xFFECEF8B),
          onTap: () {},
        ),
        SizedBox(width: 9.w), // Fixed: Added .w
        quickActionButton(
          image: SvgPicture.asset(
            'assets/images/Group991.svg',
            width: 52.w,
            height: 66.h,
            fit: BoxFit.contain,
          ),
          label: 'Booking',
          color: const Color(0xFFA0E3E2),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildIdentifyDogCard() {
    return Container(
      height: 157.h,
      width: 384.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFD4ACFF),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Identify Dog',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontSize: 22.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Instantly scan and identify your dog using AI',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 19.h),
                GestureDetector(
                  onTap: () async {
                    if (kDebugMode) {
                      print('📸 Starting scan process...');
                    }

                    try {
                      final cameraResult = await Navigator.pushNamed(
                        context,
                        RoutesName.camera,
                      );
                      if (cameraResult != null && cameraResult is File) {
                        if (kDebugMode) {
                          print('📷 Image captured: ${cameraResult.path}');
                        }
                        final dogResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DogResultScreen(imageFile: cameraResult),
                          ),
                        );
                        if (dogResult != null &&
                            dogResult is Map<String, dynamic>) {
                          if (kDebugMode) {
                            print('✅ Received valid scan data!');
                          }

                          final scanProvider = Provider.of<ScanProvider>(
                            context,
                            listen: false,
                          );

                          final scanData = {
                            'id': DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            'image': dogResult['image'] ?? cameraResult,
                            'breedName':
                            dogResult['breedName']?.toString() ??
                                'Unknown Breed',
                            'confidence':
                            (dogResult['confidence'] ?? 0.0) is double
                                ? dogResult['confidence'] as double
                                : 0.0,
                            'formattedBreedName':
                            dogResult['formattedBreedName']?.toString() ??
                                _formatBreedName(
                                  dogResult['breedName']?.toString() ??
                                      'Unknown Breed',
                                ),
                            'timestamp': DateTime.now(),
                            'isFavorite': false,
                          };

                          if (kDebugMode) {
                            print(
                              ' Adding scan to provider: ${scanData['breedName']}',
                            );
                          }

                          scanProvider.addScan(scanData);

                          final confidencePercent =
                          (scanData['confidence']! * 100).toStringAsFixed(
                            1,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Saved: ${scanData['formattedBreedName']} ($confidencePercent% confidence)',
                              ),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.green,
                            ),
                          );

                          if (kDebugMode) {
                            print('💾 Scan saved via provider!');
                          }
                        } else if (dogResult == null) {
                          if (kDebugMode) {
                            print(
                              '⚠️ User cancelled or went back without saving',
                            );
                          }
                        }
                      } else {
                        if (kDebugMode) {
                          print('❌ No image returned from camera');
                        }
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print('❌ Error in scan flow: $e');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Scan Now',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 0.9,
                      letterSpacing: 0,
                      color: AppColors.vibrantPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -10.h,
                left: -30.w,
                child: Transform.rotate(
                  angle: -83.51 * (pi / 180),
                  child: SvgPicture.asset(
                    "assets/images/Group099.svg",
                    width: 92.w,
                    height: 92.h,
                    fit: BoxFit.contain,
                    color: const Color(0xFF820DFF),
                  ),
                ),
              ),
              SizedBox(
                width: 123.w,
                height: 164.h,
                child: Image.asset(
                  'assets/images/image 45.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatBreedName(String name) {
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

  Widget _buildVisitsDogCard() {
    return Container(
      height: 157.h,
      width: 384.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFA4C4FF),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Vet Visits',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontSize: 22.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Schedule checkups and  keep \n track of vet visits',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 19.h),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Create Visit',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 0.9,
                      letterSpacing: 0,
                      color: const Color(0xFF0059FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -10.h,
                left: -30.w,
                bottom: 10.h,
                child: Transform.rotate(
                  angle: -83.51 * (pi / 180),
                  child: SvgPicture.asset(
                    "assets/images/Group099.svg",
                    width: 92.w,
                    height: 92.h,
                    fit: BoxFit.contain,
                    color: const Color(0xFF759BE3),
                  ),
                ),
              ),
              SizedBox(
                width: 123.w,
                height: 164.h,
                child: Image.asset(
                  'assets/images/image 46.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodManagementCard() {
    return Container(
      height: 157.h,
      width: 384.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E0),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Food Management',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontSize: 22.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Track meals and manage your \n pet’s daily nutrition',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFF371B34),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 19.h),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Check Schedule',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 0.9,
                      letterSpacing: 0,
                      color: const Color(0xFF6E4B25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -10.h,
                left: -30.w,
                child: Transform.rotate(
                  angle: -83.51 * (pi / 180),
                  child: SvgPicture.asset(
                    "assets/images/Group099.svg",
                    width: 92.w,
                    height: 92.h,
                    fit: BoxFit.contain,
                    color: const Color(0xFFEFCBA6),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 25.h),
                child: SizedBox(
                  width: 123.w,
                  height: 164.h,
                  child: Image.asset(
                    'assets/images/image 47.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:math';
//
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/ScanProvider.dart';
// import '../MyPetsView/DogResultScreen.dart';
//
// class Homeview extends StatefulWidget {
//   const Homeview({super.key});
//
//   @override
//   State<Homeview> createState() => _HomeviewState();
// }
//
// class _HomeviewState extends State<Homeview> {
//   final String userName = "Sarina";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(left: 24, right: 23, top: 18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               SizedBox(height: 17.h),
//               _buildSearchBar(),
//               SizedBox(height: 15.h),
//               _buildPremiumBanner(),
//               SizedBox(height: 17.h),
//               _buildQuickActions(),
//               SizedBox(height: 6.h),
//               _buildIdentifyDogCard(),
//               SizedBox(height: 6.h),
//               _buildFoodManagementCard(),
//               SizedBox(height: 6.h),
//               _buildVisitsDogCard(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Container(
//       height: 52.h,
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           SizedBox(width: 16.w),
//           const SizedBox(
//             width: 22,
//             height: 22,
//             child: Icon(Icons.search, color: Color(0x99000000)),
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(
//               'Search for Dog',
//               style: TextStyle(
//                 color: const Color(0x99000000),
//                 fontFamily: 'Sora',
//                 fontWeight: FontWeight.w200,
//                 fontSize: 14.sp,
//                 height: 1.0,
//                 letterSpacing: 0.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget quickActionButton({
//     required Widget image, // Now accepts Widget instead of String
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 86.w,
//             height: 90.h,
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(25.r),
//             ),
//             child: Container(
//               width: 57.w,
//               height: 57.h,
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: image,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             label,
//             style:  TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Stack(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       "assets/images/Group2.svg",
//                       width: 72.w,
//                       height: 37.h,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       'Manager',
//                       style: TextStyle(
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w200,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 30.sp,
//                         height: 1.0,
//                         letterSpacing: 0.0,
//                         color: AppColors.jet,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 22.h),
//                 RichText(
//                   text: TextSpan(
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontSize: 22.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black,
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: 'Welcome back, ',
//                         style: TextStyle(fontWeight: FontWeight.w400),
//                       ),
//                       TextSpan(
//                         text: '$userName!',
//                         style: const TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: 38.w),
//             SizedBox(
//               height: 92.h,
//               width: 92.w,
//               child: Center(
//                 child: Transform.rotate(
//                   angle: -80.11,
//                   child: Image.asset(
//                     'assets/images/Group88.png',
//                     width: 92.w,
//                     height: 92.h,
//                     color: const Color(0xFFF3F6F3),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPremiumBanner() {
//     return Container(
//       width: 393.w,
//       height: 103.h,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF6D09E8),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Stack(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 5,
//                         left: 5,
//                         right: 15,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Try Premium Features 🌵',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1,
//                           ),
//                           Text(
//                             'Claim your offer now and get unlimited recognition, health check and more',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14.sp,
//                               height: 1.4,
//                               letterSpacing: 0.2,
//                             ),
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Row(
//                 children: [
//                   Transform.translate(
//                     offset: Offset(-10, -18.h),
//                     child: Positioned(
//                       top: -10.h,
//                       left: -30.w,
//                       bottom: 10,
//                       child: Transform.rotate(
//                         angle: -83.51 * (pi / 180),
//                         child: SvgPicture.asset(
//                           "assets/images/Group099.svg",
//                           width: 40.w,
//                           height: 42.h,
//                           fit: BoxFit.contain,
//                           color:  Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 5),
//                     child: SizedBox(
//                       width: 84.w,
//                       height: 36.h,
//                       child: Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber,
//                               padding: EdgeInsets.symmetric(vertical: 8.h),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.r),
//                               ),
//                             ),
//                             child: FittedBox(
//                               child: Text(
//                                 'GET IT',
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   final List<Map<String, dynamic>> actions = [
//     {
//       'image': 'assets/images/H.png',
//       'label': 'Hygiene',
//       'color': const Color(0xFFF8BBD0),
//     },
//     {
//       'image': 'assets/images/C.png',
//       'label': 'Cleaning',
//       'color': const Color(0xFFBBDEFB),
//     },
//     {
//       'image': 'assets/images/M.png',
//       'label': 'Medical',
//       'color': const Color(0xFFECEF8B),
//     },
//     {
//       'image': 'assets/images/B.png',
//       'label': 'Booking',
//       'color': const Color(0xFFC8E6C9),
//     },
//   ];
//
//   Widget _buildQuickActions() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         quickActionButton(
//           image: SvgPicture.asset(
//             'assets/images/Group77.svg',
//             width: 52.w,
//             height: 66.h,
//             fit: BoxFit.contain,
//           ),
//           label: 'Hygiene',
//           color: const Color(0xFFEF5DA8),
//           onTap: () {
//             Navigator.pushNamed(context, RoutesName.hygiene);
//           },
//         ),
//         const SizedBox(width: 9),
//         quickActionButton(
//           image:  SvgPicture.asset(
//             'assets/images/Group88.svg',
//             width: 52.w,
//             height: 66.h,
//             fit: BoxFit.contain,
//           ),
//           label: 'Cleaning',
//           color: const Color(0xFFAEAFF7),
//           onTap: () {
//             Navigator.pushNamed(context, RoutesName.cleaning);
//           },
//         ),
//         const SizedBox(width: 9),
//         quickActionButton(
//           image:  SvgPicture.asset(
//             'assets/images/Group99.svg',
//             width: 52.w,
//             height: 66.h,
//             fit: BoxFit.contain,
//           ),
//           label: 'Medical',
//           color: const Color(0xFFECEF8B),
//           onTap: () {},
//         ),
//         const SizedBox(width: 9),
//         quickActionButton(
//           image:  SvgPicture.asset(
//             'assets/images/Group991.svg',
//             width: 52.w,
//             height: 66.h,
//             fit: BoxFit.contain,
//           ),
//           label: 'Booking',
//           color: const Color(0xFFA0E3E2),
//           onTap: () {},
//         ),
//       ],
//     );
//   }
//
//   Widget _buildIdentifyDogCard() {
//     return Container(
//       height: 157.h,
//       width: 384.w,
//       padding: EdgeInsets.all(10.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFD4ACFF),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 Text(
//                   'Identify Dog',
//                   style: TextStyle(
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 22.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w300,
//                     fontSize: 14.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                   maxLines: 2,
//                 ),
//                 SizedBox(height: 19.h),
//                 GestureDetector(
//                   onTap: () async {
//                     if (kDebugMode) {
//                       print('📸 Starting scan process...');
//                     }
//
//                     try {
//                       final cameraResult = await Navigator.pushNamed(
//                         context,
//                         RoutesName.camera,
//                       );
//                       if (cameraResult != null && cameraResult is File) {
//                         if (kDebugMode) {
//                           print('📷 Image captured: ${cameraResult.path}');
//                         }
//                         final dogResult = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 DogResultScreen(imageFile: cameraResult),
//                           ),
//                         );
//                         if (dogResult != null &&
//                             dogResult is Map<String, dynamic>) {
//                           if (kDebugMode) {
//                             print('✅ Received valid scan data!');
//                           }
//
//                           final scanProvider = Provider.of<ScanProvider>(
//                             context,
//                             listen: false,
//                           );
//
//                           final scanData = {
//                             'id': DateTime.now().millisecondsSinceEpoch
//                                 .toString(),
//                             'image': dogResult['image'] ?? cameraResult,
//                             'breedName':
//                                 dogResult['breedName']?.toString() ??
//                                 'Unknown Breed',
//                             'confidence':
//                                 (dogResult['confidence'] ?? 0.0) is double
//                                 ? dogResult['confidence'] as double
//                                 : 0.0,
//                             'formattedBreedName':
//                                 dogResult['formattedBreedName']?.toString() ??
//                                 _formatBreedName(
//                                   dogResult['breedName']?.toString() ??
//                                       'Unknown Breed',
//                                 ),
//                             'timestamp': DateTime.now(),
//                             'isFavorite': false,
//                           };
//
//                           if (kDebugMode) {
//                             print(
//                               ' Adding scan to provider: ${scanData['breedName']}',
//                             );
//                           }
//
//                           scanProvider.addScan(scanData);
//
//                           final confidencePercent =
//                               (scanData['confidence']! * 100).toStringAsFixed(
//                                 1,
//                               );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 '✅ Saved: ${scanData['formattedBreedName']} ($confidencePercent% confidence)',
//                               ),
//                               duration: const Duration(seconds: 3),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//
//                           if (kDebugMode) {
//                             print('💾 Scan saved via provider!');
//                           }
//                         } else if (dogResult == null) {
//                           if (kDebugMode) {
//                             print(
//                               '⚠️ User cancelled or went back without saving',
//                             );
//                           }
//                         }
//                       } else {
//                         if (kDebugMode) {
//                           print('❌ No image returned from camera');
//                         }
//                       }
//                     } catch (e) {
//                       if (kDebugMode) {
//                         print('❌ Error in scan flow: $e');
//                       }
//                     }
//                   },
//                   child: Text(
//                     'Scan Now',
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20.sp,
//                       height: 0.9,
//                       letterSpacing: 0,
//                       color: AppColors.vibrantPurple,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.center,
//             children: [
//               Positioned(
//                 top: -10.h,
//                 left: -30.w,
//                 child: Transform.rotate(
//                   angle: -83.51 * (pi / 180),
//                   child: SvgPicture.asset(
//                     "assets/images/Group099.svg",
//                     width: 92.w,
//                     height: 92.h,
//                     fit: BoxFit.contain,
//                     color: const Color(0xFF820DFF),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 123.w,
//                 height: 164.h,
//                 child: Image.asset(
//                   'assets/images/image 45.png',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   String _formatBreedName(String name) {
//     return name
//         .replaceAll('-', ' ')
//         .split(' ')
//         .map((word) => word[0].toUpperCase() + word.substring(1))
//         .join(' ');
//   }
//   Widget _buildVisitsDogCard() {
//     return Container(
//       height: 157.h,
//       width: 384.w,
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFA4C4FF),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 Text(
//                   'Vet Visits',
//                   style: TextStyle(
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 22.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w300,
//                     fontSize: 14.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                   maxLines: 2,
//                 ),
//                 SizedBox(height: 19.h),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     'Create Visit',
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20.sp,
//                       height: 0.9,
//                       letterSpacing: 0,
//                       color: const Color(0xFF0059FF),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.center,
//             children: [
//               Positioned(
//                 top: -10.h,
//                 left: -30.w,
//                 bottom: 10,
//                 child: Transform.rotate(
//                   angle: -83.51 * (pi / 180),
//                   child: SvgPicture.asset(
//                     "assets/images/Group099.svg",
//                     width: 92.w,
//                     height: 92.h,
//                     fit: BoxFit.contain,
//                     color: const Color(0xFF759BE3),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 123.w,
//                 height: 164.h,
//                 child: Image.asset(
//                   'assets/images/image 46.png',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFoodManagementCard() {
//     return Container(
//       height: 157.h,
//       width: 384.w,
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF0E0),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 Text(
//                   'Food Management',
//                   style: TextStyle(
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 22.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w300,
//                     fontSize: 14.sp,
//                     height: 1.0,
//                     letterSpacing: 0,
//                     color: const Color(0xFF371B34),
//                   ),
//                   maxLines: 2,
//                 ),
//                 SizedBox(height: 19.h),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     'Check Schedule',
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20.sp,
//                       height: 0.9,
//                       letterSpacing: 0,
//                       color: const Color(0xFF6E4B25),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.center,
//             children: [
//               Positioned(
//                 top: -10.h,
//                 left: -30.w,
//                 child: Transform.rotate(
//                   angle: -83.51 * (pi / 180),
//                   child: SvgPicture.asset(
//                     "assets/images/Group099.svg",
//                     width: 92.w,
//                     height: 92.h,
//                     fit: BoxFit.contain,
//                     color: const Color(0xFFEFCBA6),
//                   ),
//                 ),
//               ),
//               Transform.translate(
//                 offset: Offset(0, 25.h),
//                 child: SizedBox(
//                   width: 123.w,
//                   height: 164.h,
//                   child: Image.asset(
//                     'assets/images/image 47.png',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'dart:convert';
// // import 'dart:math';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:provider/provider.dart';
// // import 'dart:io';
// // import '../../View_model/DogValuesViewModel.dart';
// // import '../../View_model/ScanProvider.dart';
// // import '../MyPetsView/DogResultScreen.dart';
// //
// // class Homeview extends StatefulWidget {
// //   const Homeview({super.key});
// //
// //   @override
// //   State<Homeview> createState() => _HomeviewState();
// // }
// //
// // class _HomeviewState extends State<Homeview> {
// //   late final  DogValuesViewModel viewModel;
// //   @override
// //   void initState() {
// //     super.initState();
// //     viewModel = DogValuesViewModel();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final scanProvider = Provider.of<ScanProvider>(context, listen: false);
// //       if (kDebugMode) {
// //         print('📊 Scan count on startup: ${scanProvider.recentScans.length}');
// //       }
// //       for (var scan in scanProvider.recentScans) {
// //         if (kDebugMode) {
// //           print('   Scan ID: ${scan['id']}, Breed: ${scan['breedName']}');
// //         }
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final scanProvider = Provider.of<ScanProvider>(context);
// //     final recentScans = scanProvider.recentScans;
// //     final favoriteBreeds = scanProvider.favoriteBreeds;
// //
// //     if (kDebugMode) {
// //       print('🏠 HomeView build() called. Recent scans: ${recentScans.length}');
// //       print('   Favorite breeds: ${favoriteBreeds.length}');
// //     }
// //
// //     return Scaffold(
// //       backgroundColor: Theme.of(context).colorScheme.background,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 19.w),
// //           child: Stack(
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildHeader(),
// //                   SizedBox(height: 5.h),
// //                   Transform.translate(
// //                     offset: Offset(0, -30.h),
// //                     child: _buildIdentifyDogCard(),
// //                   ),
// //                   // _buildIdentifyDogCard(),
// //                   SizedBox(height: 16.h),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         'Recent Scans',
// //                         style: TextStyle(
// //                           fontFamily: 'Sora',
// //                           fontWeight: FontWeight.bold,
// //                           fontStyle: FontStyle.normal,
// //                           fontSize: 16.sp,
// //                           height: 1.0,
// //                           letterSpacing: 0.0,
// //                           color: Theme.of(context).colorScheme.onSurface,
// //                         ),
// //                       ),
// //                       Text(
// //                         '${recentScans.length} scans',
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           color: Theme.of(context).colorScheme.onSurface,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 16.h),
// //                   if (recentScans.isNotEmpty)
// //                     _buildRecentScansList(recentScans, scanProvider,context)
// //                   else
// //                     _buildEmptyState(),
// //
// //                   SizedBox(height: 22.h),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         'Supported Breeds',
// //                         style: TextStyle(
// //                           fontFamily: 'Sora',
// //                           fontWeight: FontWeight.bold,
// //                           fontStyle: FontStyle.normal,
// //                           fontSize: 16.sp,
// //                           height: 1.0,
// //                           letterSpacing: 0.0,
// //                           color: Theme.of(context).colorScheme.onSurface,
// //                         ),
// //                       ),
// //                       if (favoriteBreeds.isNotEmpty)
// //                         Text(
// //                           '${favoriteBreeds.length} favorites',
// //                           style: TextStyle(
// //                             fontSize: 14.sp,
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 12.h),
// //                   _buildSupportedBreedsVerticalFormatted(scanProvider),
// //                 ],
// //               ),
// //             ],
// //           )
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _handleRescanTap(
// //     Map<String, dynamic> scan,
// //     BuildContext context,
// //   ) async {
// //     if (kDebugMode) {
// //       print('🔄 Re-scanning: ${scan['breedName']}');
// //     }
// //
// //     try {
// //       final cameraResult = await Navigator.pushNamed(
// //         context,
// //         RoutesName.camera,
// //       );
// //
// //       if (cameraResult != null && cameraResult is File) {
// //         if (kDebugMode) {
// //           print('📷 New image captured: ${cameraResult.path}');
// //         }
// //         final dogResult = await Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => DogResultScreen(imageFile: cameraResult),
// //           ),
// //         );
// //
// //         if (dogResult != null && dogResult is Map<String, dynamic>) {
// //           if (kDebugMode) {
// //             print('✅ Received new scan data!');
// //           }
// //
// //           final scanProvider = Provider.of<ScanProvider>(
// //             context,
// //             listen: false,
// //           );
// //           final scanData = {
// //             'id': DateTime.now().millisecondsSinceEpoch.toString(),
// //             'image': dogResult['image'] ?? cameraResult,
// //             'breedName': dogResult['breedName']?.toString() ?? 'Unknown Breed',
// //             'confidence': (dogResult['confidence'] ?? 0.0) is double
// //                 ? dogResult['confidence'] as double
// //                 : 0.0,
// //             'formattedBreedName':
// //                 dogResult['formattedBreedName']?.toString() ??
// //                 _formatBreedName(
// //                   dogResult['breedName']?.toString() ?? 'Unknown Breed',
// //                 ),
// //             'timestamp': DateTime.now(),
// //             'isFavorite': false,
// //           };
// //
// //           if (kDebugMode) {
// //             print('📋 Adding new scan to provider: ${scanData['breedName']}');
// //           }
// //
// //           // Add to provider (this will trigger UI update)
// //           scanProvider.addScan(scanData);
// //
// //           final confidencePercent = (scanData['confidence']! * 100)
// //               .toStringAsFixed(1);
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                 '✅ Re-scanned: ${scanData['formattedBreedName']} ($confidencePercent% confidence)',
// //               ),
// //               duration: const Duration(seconds: 3),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //
// //           if (kDebugMode) {
// //             print('💾 New scan saved via provider!');
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print('❌ Error in re-scan flow: $e');
// //       }
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Error re-scanning: $e'),
// //           duration: const Duration(seconds: 3),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           SvgPicture.asset(
// //             "assets/images/Group5353.svg",
// //             width: 32.w,
// //             height: 37.h,
// //             fit: BoxFit.contain,
// //             color: Theme.of(context).colorScheme.surfaceContainerLowest,
// //           ),
// //           SvgPicture.asset(
// //             "assets/images/Group5354.svg",
// //             width: 160.w,
// //             height: 82.h,
// //             fit: BoxFit.contain,
// //           ),
// //           SizedBox(height: 12.h),
// //           Text(
// //             '0 Results',
// //             style: TextStyle(
// //               fontSize: 14.sp,
// //               fontWeight: FontWeight.w600,
// //               color: Theme.of(context).colorScheme.onSurface,
// //             ),
// //           ),
// //           SizedBox(height: 8.h),
// //           Text(
// //             'As soon as you’ve made your first scan,\nyour results will be logged here.',
// //             style: TextStyle(fontSize: 12.sp, color: Theme.of(context).colorScheme.onSurface),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecentScansList(
// //     List<Map<String, dynamic>> recentScans,
// //     ScanProvider scanProvider,
// //       BuildContext context,
// //   ) {
// //     final lastSixScans = recentScans.length > 6
// //         ? recentScans.sublist(recentScans.length - 6)
// //         : recentScans;
// //     return Column(
// //       children: lastSixScans.asMap().entries.map((entry) {
// //         final index = entry.key;
// //         final scan = entry.value;
// //         return _buildRecentScanCard(scan, index, scanProvider,context);
// //       }).toList(),
// //     );
// //   }
// // // Helper function to parse image data from various formats
// //   Uint8List? _parseImageData(dynamic imageData) {
// //     if (imageData == null) return null;
// //
// //     if (imageData is Uint8List) {
// //       return imageData;
// //     } else if (imageData is String) {
// //       try {
// //         String base64String = imageData;
// //
// //         // Handle data:image/...;base64,... format
// //         if (imageData.contains('base64,')) {
// //           final parts = imageData.split('base64,');
// //           if (parts.length > 1) {
// //             base64String = parts[1];
// //           }
// //         }
// //
// //         // Decode base64 string
// //         return base64.decode(base64String);
// //       } catch (e) {
// //         if (kDebugMode) {
// //           print('Failed to decode base64 image: $e');
// //         }
// //         return null;
// //       }
// //     } else if (imageData is List<int>) {
// //       return Uint8List.fromList(imageData);
// //     }
// //
// //     if (kDebugMode) {
// //       print('Unsupported image data type: ${imageData.runtimeType}');
// //     }
// //     return null;
// //   }
// //   Widget _buildRecentScanCard(
// //     Map<String, dynamic> scan,
// //     int index,
// //     ScanProvider scanProvider,
// //       BuildContext context,
// //   ) {
// //     final colors = Theme.of(context).colorScheme;
// //     final imageBytes = _parseImageData(scan['imageBytes']);
// //
// //     final scanId = scan['id']?.toString() ?? index.toString();
// //     final breedName = scan['breedName']?.toString() ?? 'Unknown Breed';
// //     final _ =
// //         scan['formattedBreedName']?.toString() ?? _formatBreedName(breedName);
// //     final confidence = scan['confidence'] is double
// //         ? scan['confidence'] as double
// //         : 0.0;
// //     final isFavorite = scan['isFavorite'] == true;
// //     final timestamp = scan['timestamp'] != null
// //         ? DateTime.tryParse(scan['timestamp'].toString())
// //         : null;
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 12.h),
// //       width: 413.w,
// //       height: 179.h,
// //       decoration: BoxDecoration(
// //         color: colors.secondaryContainer,
// //         borderRadius: BorderRadius.circular(20.r),
// //         border: Border.all(color: colors.background.withOpacity(0.2)),
// //         // boxShadow: [
// //         //   BoxShadow(
// //         //     color:  const Color(0xFFCBE4DC).withOpacity(0.5),
// //         //     blurRadius: 52.w,
// //         //     spreadRadius: 2.w,
// //         //     offset: Offset(0, 8.h),
// //         //   ),
// //         // ],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.all(8.r),
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               behavior: HitTestBehavior.opaque,
// //               onTap: () {
// //                 if (kDebugMode) {
// //                   print("📌 Navigating with scanId: $scanId");
// //                 }
// //                 Navigator.pushNamed(context,
// //                     RoutesName.dogSave,
// //                     arguments: {"scanId": scanId}
// //                 );
// //               },
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Stack(
// //                     alignment: Alignment.center,
// //                     children: [
// //                       Container(
// //                         width: 80.w,
// //                         height: 80.h,
// //                         decoration: const BoxDecoration(
// //                           shape: BoxShape.circle,
// //                           gradient: LinearGradient(
// //                             begin: Alignment.topLeft,
// //                             end: Alignment.bottomRight,
// //                             colors: [Color(0xFF7B2CBF), Color(0xFF5B0BAE)],
// //                           ),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Container(
// //                           width: 64.w,
// //                           height: 64.h,
// //                           decoration: const BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             color: Color(0xFF7B2CBF),
// //                           ),
// //                           child: imageBytes != null
// //                               ? ClipRRect(
// //                                   borderRadius: BorderRadius.circular(30.w),
// //                                   child: Image.memory(
// //                                     imageBytes,
// //                                     key: ValueKey('image_$scanId'),
// //                                     width: 68.w,
// //                                     height: 68.h,
// //                                     fit: BoxFit.cover,
// //                                     gaplessPlayback: true,
// //                                   ),
// //                                 )
// //                               : Center(
// //                                   child: Icon(
// //                                     Icons.pets,
// //                                     color: Colors.white.withOpacity(0.8),
// //                                     size: 24.r,
// //                                   ),
// //                                 ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(width: 6.w),
// //                   Expanded(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           breedName,
// //                           style: TextStyle(
// //                             fontSize: 16.sp,
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                             fontWeight: FontWeight.bold
// //                           ),
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                         SizedBox(height: 4.h),
// //                         if (timestamp != null)
// //                           Text(
// //                             _formatDateTime(timestamp),
// //                             style: TextStyle(
// //                               fontSize: 10.sp,
// //                               color: Colors.grey[500],
// //                             ),
// //                           ),
// //                         SizedBox(height: 6.h),
// //                         Text(
// //                           "Your dog you scanned looks like this.",
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.w500,
// //                             fontSize: 12.sp,
// //                             color: Theme.of(
// //                               context,
// //                             ).colorScheme.onSurface.withOpacity(0.8),
// //                           ),
// //                           maxLines: 2,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   SizedBox(width: 12.w),
// //
// //                   // Confidence Circle
// //                   Container(
// //                     width: 73.w,
// //                     height: 73.h,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: const Color(0xFFE58F05).withOpacity(0.24),
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         '${(confidence * 100).toStringAsFixed(1)}%',
// //                         style: TextStyle(
// //                           fontSize: 20.sp,
// //                           fontWeight: FontWeight.bold,
// //                           color: const Color(0xFFE58F05),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 12.h),
// //             Divider(
// //               color: colors.outlineVariant,
// //               thickness: 1.0,
// //               height: 1.h,
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       GestureDetector(
// //                         onTap: () async {
// //                           await _handleRescanTap(scan, context);
// //                         },
// //                         child: Text(
// //                           'Return',
// //                           style: TextStyle(
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16.sp,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 102.w),
// //                       GestureDetector(
// //                         behavior: HitTestBehavior.opaque,
// //                         onTap: () {
// //                           if (kDebugMode) {
// //                             print("📌 Navigating with scanId: $scanId");
// //                           }
// //                           Navigator.pushNamed(context,
// //                             RoutesName.dogSave,
// //                               arguments: {"scanId": scanId}
// //                           );
// //                         },
// //                         child: Text(
// //                           'Show',
// //                           style: TextStyle(
// //                             color: Theme.of(context).colorScheme.onSurface,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16.sp,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   GestureDetector(
// //                     onTap: () {
// //                       scanProvider.toggleScanFavorite(scanId);
// //                     },
// //                     child: Icon(
// //                       isFavorite ? Icons.favorite : Icons.favorite_border,
// //                       color: isFavorite ? Colors.red : Colors.grey[600],
// //                    size: 26,
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
// //
// //
// //   String _formatBreedName(String name) {
// //     return name
// //         .replaceAll('-', ' ')
// //         .split(' ')
// //         .map((word) => word[0].toUpperCase() + word.substring(1))
// //         .join(' ');
// //   }
// //
// //   String _formatDateTime(DateTime dateTime) {
// //     final now = DateTime.now();
// //     final difference = now.difference(dateTime);
// //
// //     if (difference.inDays > 7) {
// //       return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
// //     } else if (difference.inDays > 0) {
// //       return '${difference.inDays} days ago';
// //     } else if (difference.inHours > 0) {
// //       return '${difference.inHours} hours ago';
// //     } else if (difference.inMinutes > 0) {
// //       return '${difference.inMinutes} minutes ago';
// //     } else {
// //       return 'Just now';
// //     }
// //   }
// //
// //
// //   Widget _buildIdentifyDogCard() {
// //     final colors = Theme.of(context).colorScheme;
// //     return Container(
// //       height: 177.h,
// //       width: 409.w,
// //       padding: EdgeInsets.all(10.w),
// //       decoration: BoxDecoration(
// //         color: colors.surfaceContainerHigh,
// //         borderRadius: BorderRadius.circular(20.r),
// //         // boxShadow: [
// //         //   BoxShadow(
// //         //     color: colors.onSurface.withOpacity(0.1),
// //         //     blurRadius: 52.w,
// //         //     spreadRadius: 0.w,
// //         //     offset: Offset(0, 4.h),
// //         //   ),
// //         // ],
// //
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(height: 10.h),
// //                 Text(
// //                   'Identify Dog',
// //                   style: TextStyle(
// //                     fontFamily: 'Sora',
// //                     fontWeight: FontWeight.w400,
// //                     fontSize: 22.sp,
// //                     height: 1.0,
// //                     letterSpacing: 0,
// //                     color: colors.onSurface,
// //                   ),
// //                 ),
// //                 SizedBox(height: 18.h),
// //                 Text(
// //                   'Take a picture of your dog\nand identify its breed instantly.',
// //                   style: TextStyle(
// //                     fontFamily: 'Inter',
// //                     fontWeight: FontWeight.w300,
// //                     fontSize: 16.sp,
// //                     height: 1.0,
// //                     letterSpacing: 0,
// //                     color: colors.onSurface,
// //                   ),
// //                   maxLines: 2,
// //                 ),
// //                 SizedBox(height: 22.h),
// //                 GestureDetector(
// //                   onTap: () async {
// //                     if (kDebugMode) {
// //                       print('📸 Starting scan process...');
// //                     }
// //
// //                     try {
// //                       final cameraResult = await Navigator.pushNamed(
// //                         context,
// //                         RoutesName.camera,
// //                       );
// //                       if (cameraResult != null && cameraResult is File) {
// //                         if (kDebugMode) {
// //                           print('📷 Image captured: ${cameraResult.path}');
// //                         }
// //                         final dogResult = await Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) =>
// //                                 DogResultScreen(imageFile: cameraResult),
// //                           ),
// //                         );
// //                         if (dogResult != null &&
// //                             dogResult is Map<String, dynamic>) {
// //                           if (kDebugMode) {
// //                             print('✅ Received valid scan data!');
// //                           }
// //
// //                           final scanProvider = Provider.of<ScanProvider>(
// //                             context,
// //                             listen: false,
// //                           );
// //
// //                           final scanData = {
// //                             'id': DateTime.now().millisecondsSinceEpoch
// //                                 .toString(),
// //                             'image': dogResult['image'] ?? cameraResult,
// //                             'breedName':
// //                                 dogResult['breedName']?.toString() ??
// //                                 'Unknown Breed',
// //                             'confidence':
// //                                 (dogResult['confidence'] ?? 0.0) is double
// //                                 ? dogResult['confidence'] as double
// //                                 : 0.0,
// //                             'formattedBreedName':
// //                                 dogResult['formattedBreedName']?.toString() ??
// //                                 _formatBreedName(
// //                                   dogResult['breedName']?.toString() ??
// //                                       'Unknown Breed',
// //                                 ),
// //                             'timestamp': DateTime.now(),
// //                             'isFavorite': false,
// //                           };
// //
// //                           if (kDebugMode) {
// //                             print(
// //                               ' Adding scan to provider: ${scanData['breedName']}',
// //                             );
// //                           }
// //
// //                           scanProvider.addScan(scanData);
// //
// //                           final confidencePercent =
// //                               (scanData['confidence']! * 100).toStringAsFixed(
// //                                 1,
// //                               );
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(
// //                               content: Text(
// //                                 '✅ Saved: ${scanData['formattedBreedName']} ($confidencePercent% confidence)',
// //                               ),
// //                               duration: const Duration(seconds: 3),
// //                               backgroundColor: Colors.green,
// //                             ),
// //                           );
// //
// //                           if (kDebugMode) {
// //                             print('💾 Scan saved via provider!');
// //                           }
// //                         } else if (dogResult == null) {
// //                           if (kDebugMode) {
// //                             print(
// //                               '⚠️ User cancelled or went back without saving',
// //                             );
// //                           }
// //                         }
// //                       } else {
// //                         if (kDebugMode) {
// //                           print('❌ No image returned from camera');
// //                         }
// //                       }
// //                     } catch (e) {
// //                       if (kDebugMode) {
// //                         print('❌ Error in scan flow: $e');
// //                       }
// //                     }
// //                   },
// //                   child: Text(
// //                     'Scan Now',
// //                     style: TextStyle(
// //                       fontFamily: 'Sora',
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 22.sp,
// //                       height: 0.9,
// //                       letterSpacing: 0,
// //                       color: colors.tertiary,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(width: 12.w),
// //           Stack(
// //             clipBehavior: Clip.none,
// //             alignment: Alignment.center,
// //             children: [
// //               Positioned(
// //                 top: -10.h,
// //                 left: -30.w,
// //                 child: Transform.rotate(
// //                   angle: -83.51 * (pi / 180),
// //                   child: SvgPicture.asset(
// //                     "assets/images/Group099.svg",
// //                     width: 92.w,
// //                     height: 92.h,
// //                     color: colors.surfaceContainerHighest,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 width: 123.w,
// //                 height: 164.h,
// //                 child: Image.asset(
// //                   'assets/images/image 45.png',
// //
// //                 ),
// //               ),
// //             ],
// //           ),
// //           // Stack(
// //           //   children: [
// //           //     Positioned(
// //           //       child: SizedBox(
// //           //         height: 78.h,
// //           //         width: 80.w,
// //           //         child: Center(
// //           //           child: Transform.rotate(
// //           //             angle: -83.51,
// //           //             child: SvgPicture.asset(
// //           //               "assets/images/Group099.svg",
// //           //               width: 92.w,
// //           //               height: 92.h,
// //           //               color: colors.surfaceContainerLow,
// //           //               fit: BoxFit.contain,
// //           //             ),
// //           //           ),
// //           //         ),
// //           //       ),
// //           //     ),
// //           //     Image.asset(
// //           //       'assets/images/image 45.png',
// //           //       width: 123.w,
// //           //       height: 196.h,
// //           //       fit: BoxFit.contain,
// //           //     ),
// //           //   ],
// //           // )
// //
// //         ],
// //       ),
// //     );
// //   }
// //   Widget _buildHeader() {
// //     final colors = Theme.of(context).colorScheme;
// //     return SizedBox(
// //       height: 80.h,
// //       child: Stack(
// //         children: [
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               SvgPicture.asset(
// //                 "assets/images/Group2.svg",
// //                 width: 72.w,
// //                 height: 37.h,
// //                 fit: BoxFit.contain,
// //               ),
// //               const SizedBox(width: 5),
// //               Text(
// //                 'Manager',
// //                 style: TextStyle(
// //                   fontFamily: 'Sora',
// //                   fontWeight: FontWeight.w400,
// //                   fontStyle: FontStyle.normal,
// //                   fontSize: 30.sp,
// //                   height: 1.0,
// //                   letterSpacing: 0.0,
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //               ),
// //               const Spacer(),
// //             ],
// //           ),
// //
// //           Positioned(
// //             bottom: 5,
// //             right: 10,
// //             child: SizedBox(
// //               height: 78.h,
// //               width: 80.w,
// //               child: Center(
// //                 child: Transform.rotate(
// //                   angle: -81.51,
// //                   child: SvgPicture.asset(
// //                     "assets/images/Group099.svg",
// //                     width: 92.w,
// //                     height: 92.h,
// //                     // color: const Color(0xFFE9ECE9),
// //                     color: colors.surfaceContainerLow,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSupportedBreedsVerticalFormatted(ScanProvider scanProvider) {
// //     final colors = Theme.of(context).colorScheme;
// //     final List<Map<String, String>> topBreeds = [
// //       {
// //         'name': 'Bulldog',
// //         'description':
// //             'Life expectancy: 8-10 years.\nBrachycephalic breed requiring\nspecial care in hot weather.',
// //         'image': 'assets/images/Ellipse 139.png',
// //       },
// //       {
// //         'name': 'Beagle',
// //         'description':
// //             'Life expectancy: 12-15 years.\nFriendly, curious dogs with\nstrong hunting instincts.',
// //         'image': 'assets/images/Ellipse 139 (1).png',
// //       },
// //       {
// //         'name': 'Yorkshire Terrier',
// //         'description':
// //             'Life expectancy: 13-16 years.\nSmall but energetic companion\ndogs requiring regular grooming.',
// //         'image': 'assets/images/Ellipse 139 (2).png',
// //       },
// //       {
// //         'name': 'Cavalier King Charles Spaniel',
// //         'description':
// //             'Life expectancy: 9-14 years.\nAffectionate, gentle companion\ndogs prone to heart conditions.',
// //         'image': 'assets/images/Ellipse 139 (3).png',
// //       },
// //       {
// //         'name': 'English Springer Spaniel',
// //         'description':
// //             'Life expectancy: 12-14 years.\nEnergetic hunting dogs needing\nplenty of exercise.',
// //         'image': 'assets/images/Ellipse 139 (4).png',
// //       },
// //       {
// //         'name': 'Bullmastiff',
// //         'description':
// //             'Life expectancy: 8-10 years.\nLarge, powerful guardian breed\nrequiring early socialization.',
// //         'image': 'assets/images/Ellipse 139 (5).png',
// //       },
// //       {
// //         'name': 'English Cocker Spaniel',
// //         'description':
// //             'Life expectancy: 12-14 years.\nMerry, active sporting dogs\nneeding regular ear cleaning.',
// //         'image': 'assets/images/Ellipse 139 (6).png',
// //       },
// //       {
// //         'name': 'Airedale Terrier',
// //         'description':
// //             'Life expectancy: 10-13 years.\nLargest terrier breed -\nintelligent, energetic, versatile.',
// //         'image': 'assets/images/Ellipse 139 (7).png',
// //       },
// //       {
// //         'name': 'Terrier',
// //         'description':
// //             'Life expectancy: Varies.\nEnergetic, feisty dogs bred\nfor hunting vermin.',
// //         'image': 'assets/images/Ellipse 139 (8).png',
// //       },
// //       {
// //         'name': 'Whippet',
// //         'description':
// //             'Life expectancy: 12-15 years.\nGentle, affectionate sighthound\nneeding regular running.',
// //         'image': 'assets/images/Ellipse 1399.png',
// //       },
// //       {
// //         'name': 'Bull Terrier',
// //         'description':
// //             'Life expectancy: 10-14 years.\nMuscular dogs with distinctive\negg-shaped head.',
// //         'image': 'assets/images/Ellipse 139 (9).png',
// //       },
// //       {
// //         'name': 'Golden Retriever',
// //         'description':
// //             'Life expectancy: 10-12 years.\nFriendly, intelligent family\ndogs prone to hip dysplasia.',
// //         'image': 'assets/images/Ellipse 139 (10).png',
// //       },
// //       {
// //         'name': 'Old English Sheepdog',
// //         'description':
// //             'Life expectancy: 10-12 years.\nLarge, shaggy herding dogs\nrequiring extensive grooming.',
// //         'image': 'assets/images/Ellipse 1391.png',
// //       },
// //       {
// //         'name': 'Border Collie',
// //         'description':
// //             'Life expectancy: 12-15 years.\nHighly intelligent dogs needing\nextensive mental exercise.',
// //         'image': 'assets/images/Ellipse 1392.png',
// //       },
// //       {
// //         'name': 'Greyhound',
// //         'description':
// //             'Life expectancy: 10-14 years.\nFastest dog breed - low-energy\nindoors, gentle and calm.',
// //         'image': 'assets/images/Ellipse 139 (12).png',
// //       },
// //       {
// //         'name': 'Jack Russell Terrier',
// //         'description':
// //             'Life expectancy: 13-16 years.\nSmall but fearless terriers\nwith high energy levels.',
// //         'image': 'assets/images/Ellipse 139 (13).png',
// //       },
// //       {
// //         'name': 'Bloodhound',
// //         'description':
// //             'Life expectancy: 10-12 years.\nExceptional scent-tracking dogs\nrequiring patience in training.',
// //         'image': 'assets/images/Ellipse 139 (14).png',
// //       },
// //       {
// //         'name': 'English Pointer',
// //         'description':
// //             'Life expectancy: 12-15 years.\nElegant bird dogs with high energy\nand strong pointing instinct.',
// //         'image': 'assets/images/Ellipse 139 (15).png',
// //       },
// //       {
// //         'name': 'Staffordshire Bull Terrier',
// //         'description':
// //             'Life expectancy: 12-14 years.\nMuscular, affectionate dogs\nneeding proper socialization.',
// //         'image': 'assets/images/Ellipse 139 (16).png',
// //       },
// //       {
// //         'name': 'English Foxhound',
// //         'description':
// //             'Life expectancy: 10-13 years.\nPack hunting dogs bred for\nendurance, need ample exercise.',
// //         'image': 'assets/images/Ellipse 139 (17).png',
// //       },
// //       {
// //         'name': 'Wire Fox Terrier',
// //         'description':
// //             'Life expectancy: 12-15 years.\nAlert, quick dogs with\ndistinctive wiry coats.',
// //         'image': 'assets/images/Ellipse 139 (18).png',
// //       },
// //       {
// //         'name': 'Manchester Terrier',
// //         'description':
// //             'Life expectancy: 14-16 years.\nSleek, elegant terriers\nknown for ratting abilities.',
// //         'image': 'assets/images/Ellipse 1393.png',
// //       },
// //       {
// //         'name': 'Bedlington Terrier',
// //         'description':
// //             'Life expectancy: 12-14 years.\nDistinctive lamb-like appearance,\nenergetic yet gentle.',
// //         'image': 'assets/images/Ellipse 139 (20).png',
// //       },
// //       {
// //         'name': 'Boston Terrier',
// //         'description':
// //             'Life expectancy: 11-13 years.\nFriendly "American Gentleman"\nwith tuxedo-like markings.',
// //         'image': 'assets/images/Ellipse 1394.png',
// //       },
// //       {
// //         'name': 'English Setter',
// //         'description':
// //             'Life expectancy: 10-12 years.\nElegant bird dogs with\nspeckled coats, gentle companions.',
// //         'image': 'assets/images/Ellipse 139 (21).png',
// //       },
// //       {
// //         'name': 'Border Terrier',
// //         'description':
// //             'Life expectancy: 12-15 years.\nHardy small terriers bred\nfor fox hunting.',
// //         'image': 'assets/images/Ellipse 139 (22).png',
// //       },
// //     ];
// //
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         SizedBox(height: 6.h),
// //         Column(
// //           children: topBreeds.asMap().entries.map((entry) {
// //             final _ = entry.key;
// //             final breed = entry.value;
// //             final isFavorite = scanProvider.isBreedFavorite(breed['name']!);
// //
// //             return Container(
// //               margin: EdgeInsets.only(bottom: 16.h),
// //               width: 413.w,
// //               height: 140.h,
// //               decoration: BoxDecoration(
// //                 color:  colors.tertiaryContainer,
// //                 borderRadius: BorderRadius.circular(20.r),
// //                 border: Border.all(color: colors.background.withOpacity(0.2)),
// //                 // boxShadow: [
// //                 //   BoxShadow(
// //                 //     color: colors.surface.withOpacity(0.1),
// //                 //     blurRadius: 42.w,
// //                 //     spreadRadius: 2.w,
// //                 //     offset: Offset(0, 4.h),
// //                 //   ),
// //                 // ],
// //               ),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Container(
// //                       width: 103.w,
// //                       height: 103.h,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Color(0xFFF8F5FF),
// //                       ),
// //                       child: breed['image'] != null
// //                           ? ClipRRect(
// //                               borderRadius: BorderRadius.circular(51.5.w),
// //                               child: Image.asset(
// //                                 breed['image']!,
// //                                 fit: BoxFit.cover,
// //                                 width: 103.w,
// //                                 height: 103.h,
// //                               ),
// //                             )
// //                           : Center(
// //                               child: Icon(
// //                                 Icons.pets,
// //                                 size: 40.sp,
// //                                 color: AppColors.vibrantPurple,
// //                               ),
// //                             ),
// //                     ),
// //                   ),
// //                   SizedBox(width: 4.w),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         SizedBox(height: 6.h),
// //                         Row(
// //                           children: [
// //
// //                             Text(
// //                               breed['name']!,
// //                               style: TextStyle(
// //                                 fontSize: 16.sp,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Theme.of(context).colorScheme.onSurface,
// //                               ),
// //                             ),
// //                             const Spacer(),
// //                             Padding(
// //                               padding: EdgeInsets.only(top: 16.h, right: 6.w),
// //                               child: GestureDetector(
// //                                 onTap: () {
// //                                   scanProvider.toggleBreedFavorite(
// //                                     breed['name']!,
// //                                   );
// //                                 },
// //                                 child: Icon(
// //                                   isFavorite
// //                                       ? Icons.favorite
// //                                       : Icons.favorite_border,
// //                                   color: isFavorite
// //                                       ? Colors.red
// //                                       : Theme.of(context).colorScheme.onSurface,
// //                                   size: 28.sp,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(height: 6.h),
// //                         Expanded(
// //                           child: Text(
// //                             breed['description']!,
// //                             style: TextStyle(
// //                               fontSize: 14.sp,
// //                               color: Theme.of(context).colorScheme.onSurface,
// //                               height: 1.5,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }
// // }
