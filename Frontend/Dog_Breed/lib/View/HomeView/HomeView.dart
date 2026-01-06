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

