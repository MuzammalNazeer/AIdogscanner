import 'dart:convert';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../../View_model/DogValuesViewModel.dart';
import '../../View_model/ScanProvider.dart';
import '../MyPetsView/DogResultScreen.dart';
class Listsave extends StatefulWidget {
  const Listsave({super.key});

  @override
  State<Listsave> createState() => _ListsaveState();
}

class _ListsaveState extends State<Listsave> {
  late final  DogValuesViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = DogValuesViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      if (kDebugMode) {
        print('📊 Scan count on startup: ${scanProvider.recentScans.length}');
      }
      for (var scan in scanProvider.recentScans) {
        if (kDebugMode) {
          print('   Scan ID: ${scan['id']}, Breed: ${scan['breedName']}');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final recentScans = scanProvider.recentScans;
    final favoriteBreeds = scanProvider.favoriteBreeds;

    if (kDebugMode) {
      print('🏠 HomeView build() called. Recent scans: ${recentScans.length}');
      print('   Favorite breeds: ${favoriteBreeds.length}');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 19.w),
              //   child: Column(
              //     children: [
              //       _buildHeader(),
              //     ],
              //   ),
              // ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 60.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration:  BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.recentScansTitle,

                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 19.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.recentScansTitle,
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.sp,
                              height: 1.0,
                              letterSpacing: 0.0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.scansCount(recentScans.length),
                            style: TextStyle(
                              fontFamily: 'Sora',

                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (recentScans.isNotEmpty)
                        _buildRecentScansList(recentScans, scanProvider,context)
                      else
                        _buildEmptyState(),
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
    );

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
            'formattedBreedName':
            dogResult['formattedBreedName']?.toString() ??
                _formatBreedName(
                  dogResult['breedName']?.toString() ?? 'Unknown Breed',
                ),
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
                AppLocalizations.of(context)!.rescannedSuccess(
                  scanData['formattedBreedName'],
                  confidencePercent,
                ),
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
          content: Text(AppLocalizations.of(context)!.errorRescanning(e)),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/Group5353.svg",
            width: 32.w,
            height: 37.h,
            fit: BoxFit.contain,
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
          ),
          SvgPicture.asset(
            "assets/images/Group5354.svg",
            width: 160.w,
            height: 82.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)!.zeroResults,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!.noScansMessage,
            style: TextStyle(fontSize: 12.sp, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
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
// Helper function to parse image data from various formats
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
    final breedName = scan['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed;
    final _ =
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
      // height: 179.h,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.background.withOpacity(0.2)),
        // boxShadow: [
        //   BoxShadow(
        //     color:  const Color(0xFFCBE4DC).withOpacity(0.5),
        //     blurRadius: 52.w,
        //     spreadRadius: 2.w,
        //     offset: Offset(0, 8.h),
        //   ),
        // ],
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
                            _formatDateTime(timestamp, context),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        SizedBox(height: 6.h),
                        Text(
                          AppLocalizations.of(context)!.scanLooksLike,
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

                  // Confidence Circle
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color:  const Color(0xFFFACE7D).withValues(alpha: 0.4),
                    ),
                    child: Center(
                      child: Text(
                        '${(confidence * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 15.sp,
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
                          AppLocalizations.of(context)!.returnAction,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 102.w),
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
                        child: Text(
                          AppLocalizations.of(context)!.showAction,
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
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final localizations = AppLocalizations.of(context)!;

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return localizations.daysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return localizations.hoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return localizations.minutesAgo(difference.inMinutes);
    } else {
      return localizations.justNow;
    }
  }



}
