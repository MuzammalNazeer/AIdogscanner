import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Valid/AppColors.dart';
import '../../View_model/ScanProvider.dart';
import '../../utils/routes/routes_name.dart';

class Favouritesview extends StatefulWidget {
  const Favouritesview({super.key});

  @override
  State<Favouritesview> createState() => _FavouritesviewState();
}

class _FavouritesviewState extends State<Favouritesview> {
  int _selectedSection = 0;
  final Set<String> _favoriteBreeds = {};

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: true);
    final recentScans = scanProvider.recentScans;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildNavigationButtons(),
              SizedBox(height: 24.h),
              _selectedSection == 0
                  ? _buildRecentScansSection(recentScans)
                  : _buildSupportedBreedsVerticalFormatted(),
            ],
          ),
        ),
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
                SizedBox(width: 5.w),
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.normal,
                    fontSize: 30.sp,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: const Color(0xFF371B34),
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

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSection = 0;
                  });
                },
                child: Center(
                  child: Text(
                    'Scan',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _selectedSection == 0
                          ? const Color(0xFF371B34)
                          : const Color(0xFF7E808F),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSection = 1;
                  });
                },
                child: Center(
                  child: Text(
                    'Supported Breeds',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _selectedSection == 1
                          ? const Color(0xFF371B34)
                          : const Color(0xFF7E808F),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Bottom indicator line
        Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3.h,
                decoration: BoxDecoration(
                  color: _selectedSection == 0
                      ? const Color(0xFF820DFF) // Purple color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3.h,
                decoration: BoxDecoration(
                  color: _selectedSection == 1
                      ? const Color(0xFF820DFF) // Purple color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildRecentScansSection(List<Map<String, dynamic>> recentScans) {
    if (recentScans.isEmpty) {
      return _buildEmptyState("No Recent Scans", "Scan a dog to see results here");
    }

    final lastSixScans = recentScans.length > 6
        ? recentScans.sublist(recentScans.length - 6)
        : recentScans;

    return Column(
      children: [
        Column(
          children: lastSixScans.asMap().entries.map((entry) {
            final index = entry.key;
            final scan = entry.value;
            return _buildRecentScanCard(scan, index);
          }).toList(),
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

  Widget _buildEmptyState(String title, String message) {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            _selectedSection == 0 ? Icons.camera_alt : Icons.pets,
            size: 60.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
}