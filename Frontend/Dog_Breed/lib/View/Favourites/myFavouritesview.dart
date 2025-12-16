import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../View_model/ScanProvider.dart';
import '../../utils/routes/routes_name.dart';
import '../MyPetsView/DogResultScreen.dart';

class Myfavouritesview extends StatefulWidget {
  const Myfavouritesview({super.key});

  @override
  State<Myfavouritesview> createState() => _MyfavouritesviewState();
}

class _MyfavouritesviewState extends State<Myfavouritesview> {

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: true);
    final recentScans = scanProvider.recentScans;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 19.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 25.h),
              _buildRecentScansList(recentScans,scanProvider,context),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 40.305.w,
                height: 40.305.h,
                padding: const EdgeInsets.all(8.96),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8.96),
                ),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Favourites',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 35.sp,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentScansList(
      List<Map<String, dynamic>> recentScans,
      ScanProvider scanProvider,
      BuildContext context,
      ) {
    final lastSixScans = recentScans.length > 6
        ? recentScans.sublist(recentScans.length - 6)
        : recentScans;

    return Column(
      children: lastSixScans.asMap().entries.map((entry) {
        final index = entry.key;
        final scan = entry.value;
        return _buildRecentScanCard(scan, index, scanProvider,context);
      }).toList(),
    );
  }
  Uint8List? _parseImageData(dynamic imageData) {
    if (imageData == null) return null;

    if (imageData is Uint8List) {
      return imageData;
    } else if (imageData is String) {
      try {
        String base64String = imageData;

        // Handle data:image/...;base64,... format
        if (imageData.contains('base64,')) {
          final parts = imageData.split('base64,');
          if (parts.length > 1) {
            base64String = parts[1];
          }
        }

        // Decode base64 string
        return base64.decode(base64String);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to decode base64 image: $e');
        }
        return null;
      }
    } else if (imageData is List<int>) {
      return Uint8List.fromList(imageData);
    }

    if (kDebugMode) {
      print('Unsupported image data type: ${imageData.runtimeType}');
    }
    return null;
  }

  Widget _buildRecentScanCard(
      Map<String, dynamic> scan,
      int index,
      ScanProvider scanProvider,
      BuildContext context,
      ) {
    final colors = Theme.of(context).colorScheme;
    final imageBytes = _parseImageData(scan['imageBytes']);

    final scanId = scan['id']?.toString() ?? index.toString();
    final breedName = scan['breedName']?.toString() ?? 'Unknown Breed';
    final formattedBreedName =
        scan['formattedBreedName']?.toString() ?? _formatBreedName(breedName);
    final confidence = scan['confidence'] is double
        ? scan['confidence'] as double
        : 0.0;
    final isFavorite = scan['isFavorite'] == true;
    final timestamp = scan['timestamp'] != null
        ? DateTime.tryParse(scan['timestamp'].toString())
        : null;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      width: 413.w,
      height: 179.h,
      decoration: BoxDecoration(
        color:  colors.surfaceBright.withOpacity(0.2),
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
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (kDebugMode) {
                  print("📌 Navigating with scanId: $scanId");
                }
                Navigator.pushNamed(context,
                    RoutesName.dogSave,
                    arguments: {"scanId": scanId}
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
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
                          width: 64.w,
                          height: 64.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7B2CBF),
                          ),
                          child: imageBytes != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(30.w),
                            child: Image.memory(
                              imageBytes,
                              key: ValueKey('image_$scanId'),
                              width: 68.w,
                              height: 68.h,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
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

                  // Breed Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          breedName,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        if (timestamp != null)
                          Text(
                            _formatDateTime(timestamp),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        SizedBox(height: 6.h),
                        Text(
                          "Your dog you scanned looks like this.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 73.w,
                    height: 73.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE58F05).withOpacity(0.24),
                    ),
                    child: Center(
                      child: Text(
                        '${(confidence * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE58F05),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Divider(
              color: colors.outlineVariant,
              thickness: 1.0,
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _handleRescanTap(scan, context);
                        },
                        child: Text(
                          'Return',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 102.w),
                      GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print("📌 Navigating with scanId: $scanId");
                          }
                          Navigator.pushNamed(context,
                              RoutesName.dogSave,
                              arguments: {"scanId": scanId}
                          );
                        },
                        child: Text(
                          'Show',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      scanProvider.toggleScanFavorite(scanId);
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 26,
                    ),
                  ),
                ],
              ),
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
String _formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 7) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
Future<void> _handleRescanTap(
    Map<String, dynamic> scan,
    BuildContext context,
    ) async {
  if (kDebugMode) {
    print('🔄 Re-scanning: ${scan['breedName']}');
  }

  try {
    final cameraResult = await Navigator.pushNamed(
      context,
      RoutesName.camera,
    );

    if (cameraResult != null && cameraResult is File) {
      if (kDebugMode) {
        print('📷 New image captured: ${cameraResult.path}');
      }
      final dogResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DogResultScreen(imageFile: cameraResult),
        ),
      );

      if (dogResult != null && dogResult is Map<String, dynamic>) {
        if (kDebugMode) {
          print('✅ Received new scan data!');
        }

        final scanProvider = Provider.of<ScanProvider>(
          context,
          listen: false,
        );
        final scanData = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'image': dogResult['image'] ?? cameraResult,
          'breedName': dogResult['breedName']?.toString() ?? 'Unknown Breed',
          'confidence': (dogResult['confidence'] ?? 0.0) is double
              ? dogResult['confidence'] as double
              : 0.0,
          // 'formattedBreedName':
          // dogResult['formattedBreedName']?.toString() ??
          //     _formatBreedName(
          //       dogResult['breedName']?.toString() ?? 'Unknown Breed',
          //     ),
          'timestamp': DateTime.now(),
          'isFavorite': false,
        };

        if (kDebugMode) {
          print('📋 Adding new scan to provider: ${scanData['breedName']}');
        }

        // Add to provider (this will trigger UI update)
        scanProvider.addScan(scanData);

        final confidencePercent = (scanData['confidence']! * 100)
            .toStringAsFixed(1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Re-scanned: ${scanData['formattedBreedName']} ($confidencePercent% confidence)',
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        if (kDebugMode) {
          print('💾 New scan saved via provider!');
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error in re-scan flow: $e');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error re-scanning: $e'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}