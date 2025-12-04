import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../View_model/ScanProvider.dart';
import '../MyPetsView/DogResultScreen.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final Set<String> _favoriteBreeds = {};

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final recentScans = scanProvider.recentScans;

    if (kDebugMode) {
      print('🏠 HomeView build() called. Recent scans: ${recentScans.length}');
    }
    if (recentScans.isNotEmpty) {
      if (kDebugMode) {
        print('   First scan: ${recentScans.first['breedName']}');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 4.h),
              _buildIdentifyDogCard(),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Scans',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.sp,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: const Color(0xFF371B34),
                    ),
                  ),
                  Text(
                    '${recentScans.length} scans',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Display recent scans
              if (recentScans.isNotEmpty)
                _buildRecentScansList(recentScans)
              else
                _buildEmptyState(),

              SizedBox(height: 22.h),
              Text(
                'Supported Breeds',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: const Color(0xFF371B34),
                ),
              ),
              _buildSupportedBreedsVerticalFormatted(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: 413.w,
      height: 169.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Text(
          'No recent scans',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
  Widget _buildRecentScansList(List<Map<String, dynamic>> recentScans) {
    final lastSixScans = recentScans.length > 6
        ? recentScans.sublist(recentScans.length - 6)
        : recentScans;

    return Column(
      children: lastSixScans.asMap().entries.map((entry) {
        final index = entry.key;
        final scan = entry.value;
        return _buildRecentScanCard(scan, index);
      }).toList(),
    );
  }

  Widget _buildRecentScanCard(Map<String, dynamic> scan, int index) {
    final image = scan['image'];
    final breedName = scan['breedName']?.toString() ?? 'Unknown Breed';
    final formattedBreedName =
        scan['formattedBreedName']?.toString() ?? _formatBreedName(breedName);
    final confidence = scan['confidence'] is double
        ? scan['confidence'] as double
        : 0.0;
    final _ = scan['timestamp'] is DateTime
        ? scan['timestamp'] as DateTime
        : DateTime.now();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      width: 413.w,
      height: 169.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7B2CBF), Color(0xFF5B0BAE)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7B2CBF),
                        ),
                        child: image is File && image.existsSync()
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            30.w,
                          ), // For circle
                          child: Image.file(
                            image,
                            width: 68.w,
                            height: 68.h,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Center(
                          child: Icon(
                            Icons.pets,
                            color: Colors.white.withOpacity(0.8),
                            size: 24.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 6.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedBreedName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      "Your dog you scanned looks like this.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 73.w,
                  height: 73.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7DFAC4).withOpacity(0.24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF05E51F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(
              color: Colors.grey[300],
              thickness: 1.0,
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: const Text(
                        'Rerun',
                        style: TextStyle(
                          color: Color(0xFF371B34),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 102.w),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesName.dogResult);
                      },
                      child: const Text(
                        'Show',
                        style: TextStyle(
                          color: Color(0xFF371B34),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      scan['isFavorite'] = !(scan['isFavorite'] == true);
                    });
                  },
                  icon: Icon(
                    scan['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
                    color: scan['isFavorite'] == true ? Colors.red : Colors.grey[600],
                    size: 26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  //
  // Widget _buildRecentScansList(List<Map<String, dynamic>> recentScans) {
  //   return Column(
  //     children: recentScans.asMap().entries.map((entry) {
  //       final index = entry.key;
  //       final scan = entry.value;
  //       return _buildRecentScanCard(scan, index);
  //     }).toList(),
  //   );
  // }



  // Widget _buildRecentScanCard(Map<String, dynamic> scan, int index) {
  //   final image = scan['image'];
  //   final breedName = scan['breedName']?.toString() ?? 'Unknown Breed';
  //   final formattedBreedName =
  //       scan['formattedBreedName']?.toString() ?? _formatBreedName(breedName);
  //   final confidence = scan['confidence'] is double
  //       ? scan['confidence'] as double
  //       : 0.0;
  //   final timestamp = scan['timestamp'] is DateTime
  //       ? scan['timestamp'] as DateTime
  //       : DateTime.now();
  //
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12.h),
  //     width: 413.w,
  //     height: 169.h,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF4F7F6),
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(6.r),
  //       child: Column(
  //         children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Stack(
  //                 children: [
  //                   Container(
  //                     width: 80.w,
  //                     height: 80.h,
  //                     decoration: const BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomRight,
  //                         colors: [Color(0xFF7B2CBF), Color(0xFF5B0BAE)],
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       width: 60.w,
  //                       height: 60.h,
  //                       decoration: const BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Color(0xFF7B2CBF),
  //                       ),
  //                       child: image is File && image.existsSync()
  //                           ? ClipRRect(
  //                               borderRadius: BorderRadius.circular(
  //                                 30.w,
  //                               ), // For circle
  //                               child: Image.file(
  //                                 image,
  //                                 width: 68.w,
  //                                 height: 68.h,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             )
  //                           : Center(
  //                               child: Icon(
  //                                 Icons.pets,
  //                                 color: Colors.white.withOpacity(0.8),
  //                                 size: 24.r,
  //                               ),
  //                             ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(width: 6.w),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     formattedBreedName,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16.sp,
  //                       color: Colors.black,
  //                     ),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   SizedBox(height: 14.h),
  //                   Text(
  //                     "Your dog you scanned looks like this.",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12.sp,
  //                       color: Colors.black,
  //                     ),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ),
  //               const Spacer(),
  //               Container(
  //                 width: 73.w,
  //                 height: 73.h,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: const Color(0xFF7DFAC4).withOpacity(0.24),
  //                 ),
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         '${(confidence * 100).toStringAsFixed(1)}%',
  //                         style: TextStyle(
  //                           fontSize: 20.sp,
  //                           fontWeight: FontWeight.bold,
  //                           color: const Color(0xFF05E51F),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 12.h),
  //           Divider(
  //             color: Colors.grey[300],
  //             thickness: 1.0,
  //             height: 1.h,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   const Text(
  //                     'Rerun',
  //                     style: TextStyle(
  //                       color: Color(0xFF371B34),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(width: 102.w),
  //                   const Text(
  //                     'Show',
  //                     style: TextStyle(
  //                       color: Color(0xFF371B34),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     if (scan['isFavorite'] == true) {
  //                       scan['isFavorite'] = false;
  //                     } else {
  //                       scan['isFavorite'] = true;
  //                     }
  //                   });
  //                 },
  //                 icon: Icon(
  //                   scan['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
  //                   color: scan['isFavorite'] == true ? Colors.red : Colors.grey[600],
  //                   size: 26,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String _formatBreedName(String name) {
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildIdentifyDogCard() {
    return Container(
      height: 177.h,
      width: 409.w,
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
                SizedBox(height: 20.h),
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
                SizedBox(height: 18.h),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
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
                SizedBox(height: 29.h),
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

                          // Get the provider
                          final scanProvider = Provider.of<ScanProvider>(
                            context,
                            listen: false,
                          );

                          // Create scan data
                          final scanData = {
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
                          };

                          if (kDebugMode) {
                            print(
                            '📋 Adding scan to provider: ${scanData['breedName']}',
                          );
                          }

                          // Add to provider (this will trigger UI update)
                          scanProvider.addScan(scanData);

                          // Show success message
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
          Image.asset(
            'assets/images/image 45.png',
            width: 123.w,
            height: 196.h,
            fit: BoxFit.contain,
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
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/Group2.svg",
                  width: 72.w,
                  height: 37.h,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 5),
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
            SizedBox(width: 78.w),
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

  Widget _buildSupportedBreedsVerticalFormatted() {
    final List<Map<String, String>> topBreeds = [
      {
        'name': 'Labrador Retriever',
        'description': 'Life expectancy can be up to 15 years.\nSaint Bernards can become obese if overled and under-exercised.',
        'accuracy': '98%',
        'image': 'assets/images/Ellipse 83.png',
      },
      {
        'name': 'German Shepherd',
        'description': 'Life expectancy can be up to 15 years.\nSaint Bernards can become obese if overled and under-exercised.',
        'accuracy': '96%',
        'image': 'assets/images/Ellipse 82.png',
      },
      {
        'name': 'Golden Retriever',
        'description': 'Life expectancy can be up to 15 years.\nSaint Bernards can become obese if overled and under-exercised.',
        'accuracy': '95%',
        'image': 'assets/images/Ellipse 81 (1).png',
      },
      {
        'name': 'French Bulldog',
        'description': 'Life expectancy can be up to 15 years.\nSaint Bernards can become obese if overled and under-exercised.',
        'accuracy': '94%',
        'image': 'assets/images/Ellipse 81 (2).png',
      },
      {
        'name': 'Poodle',
        'description': 'Life expectancy can be up to 15 years.\nSaint Bernards can become obese if overled and under-exercised.',
        'accuracy': '93%',
        'image': 'assets/images/Ellipse 77 (1).png',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Column(
          children: topBreeds.asMap().entries.map((entry) {
            final _ = entry.key;
            final breed = entry.value;
            final isFavorite = _favoriteBreeds.contains(breed['name']);

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: 413.w,
              height: 169.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 103.w,
                    height: 103.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF8F5FF),

                    ),
                    child: breed['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(51.5.w),
                      child: Image.asset(
                        breed['image']!,
                        fit: BoxFit.cover,
                        width: 103.w,
                        height: 103.h,
                      ),
                    )
                        : Center(
                      child: Icon(
                        Icons.pets,
                        size: 40.sp,
                        color: AppColors.vibrantPurple,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              breed['name']!,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF371B34),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, right: 16.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isFavorite) {
                                      _favoriteBreeds.remove(breed['name']);
                                    } else {
                                      _favoriteBreeds.add(breed['name']!);
                                    }
                                  });
                                },
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey[600],
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: Text(
                            breed['description']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF371B34),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }


}

