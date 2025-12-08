import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../View_model/ScanProvider.dart';
import '../../utils/routes/routes_name.dart';

class Historyview extends StatefulWidget {
  const Historyview({super.key});

  @override
  State<Historyview> createState() => _HistoryviewState();
}

class _HistoryviewState extends State<Historyview> {
  final Set<String> _favoriteBreeds = {};

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: true);
    final recentScans = scanProvider.recentScans;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 5.h),
              _buildRecentScansList(recentScans),
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
            Text(
              'History',
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
            SizedBox(width: 188.w),
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

  Widget _buildRecentScansList(List<Map<String, dynamic>> recentScans) {
    if (recentScans.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100.h),
          child: Text(
            'No recent scans found',
            style: TextStyle(
              fontSize: 16.sp,
              color:Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentScans.length,
      itemBuilder: (context, index) {
        return _buildRecentScanCard(recentScans[index], index);
      },
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
        color: const Color(0xFF323332).withOpacity(0.1),
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
                    color: const Color(0xFFE58F05).withOpacity(0.24),
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
                            color: const Color(0xFFE58F05),
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
              color: const Color(0xFF323332).withOpacity(0.1),
              thickness: 1.0,
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
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
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.dogResult,
                          arguments: scan,
                        );
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
                      // Update the favorite breeds set
                      if (scan['isFavorite'] == true) {
                        _favoriteBreeds.add(breedName);
                      } else {
                        _favoriteBreeds.remove(breedName);
                      }
                    });

                  },
                  icon: Icon(
                    scan['isFavorite'] == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: scan['isFavorite'] == true
                        ? Colors.red
                        : Theme.of(context).colorScheme.onSurface,
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
    if (name.isEmpty) return 'Unknown Breed';
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

}