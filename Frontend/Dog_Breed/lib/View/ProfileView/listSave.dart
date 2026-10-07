import 'dart:convert';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../Valid/AppColors.dart';
import '../../l10n/app_localizations.dart';
import '../../View_model/dogvaluesviewmodel.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Column(
            children: [
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
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration:  BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.recentScansTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.sp,
                                height: 1.0,
                                letterSpacing: 0.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.supportedBreeds,
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.sp,
                                height: 1.0,
                                letterSpacing: 0.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (favoriteBreeds.isNotEmpty)
                            Text(
                              AppLocalizations.of(context)!.favoriteCount(favoriteBreeds.length),
                              style: TextStyle(
                                fontFamily: 'Sora',

                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _buildSupportedBreedsVerticalFormatted(scanProvider),
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
    );

  }

  List<Map<String, String>> _getLocalizedBreeds(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      {
        'name': localizations.breedNameBulldog,
        'description': localizations.breedDescBulldog,
        'image': 'assets/images/Ellipse 139.png',
      },
      {
        'name': localizations.breedNameBeagle,
        'description': localizations.breedDescBeagle,
        'image': 'assets/images/Ellipse 139 (1).png',
      },
      {
        'name': localizations.breedNameYorkshireTerrier,
        'description': localizations.breedDescYorkshireTerrier,
        'image': 'assets/images/Ellipse 139 (2).png',
      },
      {
        'name': localizations.breedNameCavalierKingCharlesSpaniel,
        'description': localizations.breedDescCavalierKingCharlesSpaniel,
        'image': 'assets/images/Ellipse 139 (3).png',
      },
      {
        'name': localizations.breedNameEnglishSpringerSpaniel,
        'description': localizations.breedDescEnglishSpringerSpaniel,
        'image': 'assets/images/Ellipse 139 (4).png',
      },
      {
        'name': localizations.breedNameBullmastiff,
        'description': localizations.breedDescBullmastiff,
        'image': 'assets/images/Ellipse 139 (5).png',
      },
      {
        'name': localizations.breedNameEnglishCockerSpaniel,
        'description': localizations.breedDescEnglishCockerSpaniel,
        'image': 'assets/images/Ellipse 139 (6).png',
      },
      {
        'name': localizations.breedNameAiredaleTerrier,
        'description': localizations.breedDescAiredaleTerrier,
        'image': 'assets/images/Ellipse 139 (7).png',
      },
      {
        'name': localizations.breedNameTerrier,
        'description': localizations.breedDescTerrier,
        'image': 'assets/images/Ellipse 139 (8).png',
      },
      {
        'name': localizations.breedNameWhippet,
        'description': localizations.breedDescWhippet,
        'image': 'assets/images/Ellipse 1399.png',
      },
      {
        'name': localizations.breedNameBullTerrier,
        'description': localizations.breedDescBullTerrier,
        'image': 'assets/images/Ellipse 139 (9).png',
      },
      {
        'name': localizations.breedNameGoldenRetriever,
        'description': localizations.breedDescGoldenRetriever,
        'image': 'assets/images/Ellipse 139 (10).png',
      },
      {
        'name': localizations.breedNameOldEnglishSheepdog,
        'description': localizations.breedDescOldEnglishSheepdog,
        'image': 'assets/images/Ellipse 1391.png',
      },
      {
        'name': localizations.breedNameBorderCollie,
        'description': localizations.breedDescBorderCollie,
        'image': 'assets/images/Ellipse 1392.png',
      },
      {
        'name': localizations.breedNameGreyhound,
        'description': localizations.breedDescGreyhound,
        'image': 'assets/images/Ellipse 139 (12).png',
      },
      {
        'name': localizations.breedNameJackRussellTerrier,
        'description': localizations.breedDescJackRussellTerrier,
        'image': 'assets/images/Ellipse 139 (13).png',
      },
      {
        'name': localizations.breedNameBloodhound,
        'description': localizations.breedDescBloodhound,
        'image': 'assets/images/Ellipse 139 (14).png',
      },
      {
        'name': localizations.breedNameEnglishPointer,
        'description': localizations.breedDescEnglishPointer,
        'image': 'assets/images/Ellipse 139 (15).png',
      },
      {
        'name': localizations.breedNameStaffordshireBullTerrier,
        'description': localizations.breedDescStaffordshireBullTerrier,
        'image': 'assets/images/Ellipse 139 (16).png',
      },
      {
        'name': localizations.breedNameEnglishFoxhound,
        'description': localizations.breedDescEnglishFoxhound,
        'image': 'assets/images/Ellipse 139 (17).png',
      },
      {
        'name': localizations.breedNameWireFoxTerrier,
        'description': localizations.breedDescWireFoxTerrier,
        'image': 'assets/images/Ellipse 139 (18).png',
      },
      {
        'name': localizations.breedNameManchesterTerrier,
        'description': localizations.breedDescManchesterTerrier,
        'image': 'assets/images/Ellipse 1393.png',
      },
      {
        'name': localizations.breedNameBedlingtonTerrier,
        'description': localizations.breedDescBedlingtonTerrier,
        'image': 'assets/images/Ellipse 139 (20).png',
      },
      {
        'name': localizations.breedNameBostonTerrier,
        'description': localizations.breedDescBostonTerrier,
        'image': 'assets/images/Ellipse 1394.png',
      },
      {
        'name': localizations.breedNameEnglishSetter,
        'description': localizations.breedDescEnglishSetter,
        'image': 'assets/images/Ellipse 139 (21).png',
      },
      {
        'name': localizations.breedNameBorderTerrier,
        'description': localizations.breedDescBorderTerrier,
        'image': 'assets/images/Ellipse 139 (22).png',
      },
    ];
  }

  Widget _buildSupportedBreedsVerticalFormatted(ScanProvider scanProvider) {
    final colors = Theme.of(context).colorScheme;
    final List<Map<String, String>> topBreeds = _getLocalizedBreeds(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Column(
          children: topBreeds.asMap().entries.map((entry) {
            final _ = entry.key;
            final breed = entry.value;
            final isFavorite = scanProvider.isBreedFavorite(breed['name']!);

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: 413.w,
              height: 140.h,
              decoration: BoxDecoration(
                color: colors.tertiaryContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: colors.background.withOpacity(0.2)),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the avatar
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Container(
                          width: 100.w,
                          height: 100.w, // Ensure width and height are equal for a circle
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: ClipOval(
                            child: breed['image'] != null
                                ? Image.asset(
                              breed['image']!,
                              fit: BoxFit.cover,
                            )
                                : Icon(
                              Icons.pets,
                              size: 40.sp,
                              color: AppColors.vibrantPurple,
                            ),
                          ),
                        ),
                      ),

                      /// --- Text Content Section ---
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 40.w, top: 12.h, bottom: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                breed['name']!,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18.sp, // Slightly larger for the title
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Expanded(
                                child: Text(
                                  breed['description']!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// --- Heart Favorite Icon (Positioned Top Right) ---
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {
                        scanProvider.toggleBreedFavorite(breed['name']!);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.grey,
                        size: 26.sp,
                      ),
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
            'breedName': dogResult['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed,
            'confidence': (dogResult['confidence'] ?? 0.0) is double
                ? dogResult['confidence'] as double
                : 0.0,
            'formattedBreedName':
            dogResult['formattedBreedName']?.toString() ??
                _formatBreedName(
                  dogResult['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed,
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
                    width: 80.w,
                    height: 80.h,
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
