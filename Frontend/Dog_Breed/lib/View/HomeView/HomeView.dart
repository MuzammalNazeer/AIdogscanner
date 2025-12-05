

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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${recentScans.length} scans',
                    style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
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
                  color: Theme.of(context).colorScheme.onSurface,
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
        color:  Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 50,
            offset: const Offset(0, 4),
          ),
        ],
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
                        color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).colorScheme.onSurface,
              thickness: 1.0,
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child:  Text(
                        'Rerun',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 102.w),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesName.dogResult);
                      },
                      child:  Text(
                        'Show',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
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
                    color: scan['isFavorite'] == true ? Colors.red : Theme.of(context).colorScheme.onSurface,
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
                    color: Theme.of(context).colorScheme.onSurface,
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
        'name': 'Bulldog',
        'description': 'Life expectancy: 8-10 years.\nBrachycephalic breed requiring\nspecial care in hot weather.',
        'image': 'assets/images/Ellipse 139.png',
      },
      {
        'name': 'Beagle',
        'description': 'Life expectancy: 12-15 years.\nFriendly, curious dogs with\nstrong hunting instincts.',
        'image': 'assets/images/Ellipse 139 (1).png',
      },
      {
        'name': 'Yorkshire Terrier',
        'description': 'Life expectancy: 13-16 years.\nSmall but energetic companion\ndogs requiring regular grooming.',
        'image': 'assets/images/Ellipse 139 (2).png',
      },
      {
        'name': 'Cavalier King Charles Spaniel',
        'description': 'Life expectancy: 9-14 years.\nAffectionate, gentle companion\ndogs prone to heart conditions.',
        'image': 'assets/images/Ellipse 139 (3).png',
      },
      {
        'name': 'English Springer Spaniel',
        'description': 'Life expectancy: 12-14 years.\nEnergetic hunting dogs needing\nplenty of exercise.',
        'image': 'assets/images/Ellipse 139 (4).png',
      },
      {
        'name': 'Bullmastiff',
        'description': 'Life expectancy: 8-10 years.\nLarge, powerful guardian breed\nrequiring early socialization.',
        'image': 'assets/images/Ellipse 139 (5).png',
      },
      {
        'name': 'English Cocker Spaniel',
        'description': 'Life expectancy: 12-14 years.\nMerry, active sporting dogs\nneeding regular ear cleaning.',
        'image': 'assets/images/Ellipse 139 (6).png',
      },
      {
        'name': 'Airedale Terrier',
        'description': 'Life expectancy: 10-13 years.\nLargest terrier breed -\nintelligent, energetic, versatile.',
        'image': 'assets/images/Ellipse 139 (7).png',
      },
      {
        'name': 'Terrier',
        'description': 'Life expectancy: Varies.\nEnergetic, feisty dogs bred\nfor hunting vermin.',
        'image': 'assets/images/Ellipse 139 (8).png',
      },
      {
        'name': 'Whippet',
        'description': 'Life expectancy: 12-15 years.\nGentle, affectionate sighthound\nneeding regular running.',
        'image': 'assets/images/Ellipse 1399.png',
      },
      {
        'name': 'Bull Terrier',
        'description': 'Life expectancy: 10-14 years.\nMuscular dogs with distinctive\negg-shaped head.',
        'image': 'assets/images/Ellipse 139 (9).png',
      },
      {
        'name': 'Golden Retriever',
        'description': 'Life expectancy: 10-12 years.\nFriendly, intelligent family\ndogs prone to hip dysplasia.',
        'image': 'assets/images/Ellipse 139 (10).png',
      },
      {
        'name': 'Old English Sheepdog',
        'description': 'Life expectancy: 10-12 years.\nLarge, shaggy herding dogs\nrequiring extensive grooming.',
        'image': 'assets/images/Ellipse 1391.png',
      },
      {
        'name': 'Border Collie',
        'description': 'Life expectancy: 12-15 years.\nHighly intelligent dogs needing\nextensive mental exercise.',
        'image': 'assets/images/Ellipse 1392.png',
      },
      {
        'name': 'Greyhound',
        'description': 'Life expectancy: 10-14 years.\nFastest dog breed - low-energy\nindoors, gentle and calm.',
        'image': 'assets/images/Ellipse 139 (12).png',
      },
      {
        'name': 'Jack Russell Terrier',
        'description': 'Life expectancy: 13-16 years.\nSmall but fearless terriers\nwith high energy levels.',
        'image': 'assets/images/Ellipse 139 (13).png',
      },
      {
        'name': 'Bloodhound',
        'description': 'Life expectancy: 10-12 years.\nExceptional scent-tracking dogs\nrequiring patience in training.',
        'image': 'assets/images/Ellipse 139 (14).png',
      },
      {
        'name': 'English Pointer',
        'description': 'Life expectancy: 12-15 years.\nElegant bird dogs with high energy\nand strong pointing instinct.',
        'image': 'assets/images/Ellipse 139 (15).png',
      },
      {
        'name': 'Staffordshire Bull Terrier',
        'description': 'Life expectancy: 12-14 years.\nMuscular, affectionate dogs\nneeding proper socialization.',
        'image': 'assets/images/Ellipse 139 (16).png',
      },
      {
        'name': 'English Foxhound',
        'description': 'Life expectancy: 10-13 years.\nPack hunting dogs bred for\nendurance, need ample exercise.',
        'image': 'assets/images/Ellipse 139 (17).png',
      },
      {
        'name': 'Wire Fox Terrier',
        'description': 'Life expectancy: 12-15 years.\nAlert, quick dogs with\ndistinctive wiry coats.',
        'image': 'assets/images/Ellipse 139 (18).png',
      },
      {
        'name': 'Manchester Terrier',
        'description': 'Life expectancy: 14-16 years.\nSleek, elegant terriers\nknown for ratting abilities.',
        'image': 'assets/images/Ellipse 1393.png',
      },
      {
        'name': 'Bedlington Terrier',
        'description': 'Life expectancy: 12-14 years.\nDistinctive lamb-like appearance,\nenergetic yet gentle.',
        'image': 'assets/images/Ellipse 139 (20).png',
      },
      {
        'name': 'Boston Terrier',
        'description': 'Life expectancy: 11-13 years.\nFriendly "American Gentleman"\nwith tuxedo-like markings.',
        'image': 'assets/images/Ellipse 1394.png',
      },
      {
        'name': 'English Setter',
        'description': 'Life expectancy: 10-12 years.\nElegant bird dogs with\nspeckled coats, gentle companions.',
        'image': 'assets/images/Ellipse 139 (21).png',
      },
      {
        'name': 'Border Terrier',
        'description': 'Life expectancy: 12-15 years.\nHardy small terriers bred\nfor fox hunting.',
        'image': 'assets/images/Ellipse 139 (22).png',
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
                color: Theme.of(context).colorScheme.surface,
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
                  SizedBox(width: 12.w),
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, right: 6.w),
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
                                  color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface,
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
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
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

