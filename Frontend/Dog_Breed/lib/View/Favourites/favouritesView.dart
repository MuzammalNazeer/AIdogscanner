import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Valid/AppColors.dart';
import '../../View_model/ScanProvider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/routes/routes_name.dart';
import '../MyPetsView/DogResultScreen.dart';

class Favouritesview extends StatefulWidget {
  const Favouritesview({super.key});

  @override
  State<Favouritesview> createState() => _FavouritesviewState();
}

class _FavouritesviewState extends State<Favouritesview> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: true);
    final favoriteScans = scanProvider.favoriteScans;
    final _ = scanProvider.favoriteBreeds;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 19.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              Transform.translate(
                offset: Offset(0, -30.h),
                child: _buildNavigationButtons(),
              ),
              _selectedSection == 0
                  ? _buildRecentScansList(favoriteScans, scanProvider, context)
                  : _buildSupportedBreedsVerticalFormatted(scanProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 80.h,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.305.w,
                  height: 40.305.h,
                  padding: const EdgeInsets.all(8.96),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.96),
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Center text
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.favoritesTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w300,
                    fontSize: 27.75.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Invisible placeholder to balance
              SizedBox(
                width: 40.305.w,
                height: 40.305.h,
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     GestureDetector(
          //       onTap: () => Navigator.pop(context),
          //       child: Container(
          //         width: 40.w,
          //         height: 40.h,
          //         decoration:  BoxDecoration(
          //           color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : const Color(0xFF686868).withOpacity(0.1),
          //           shape: BoxShape.circle,
          //         ),
          //         child: Center(
          //           child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
          //         ),
          //       ),
          //     ),
          //      const SizedBox(width: 60,),
          //     Text(
          //       AppLocalizations.of(context)!.favoritesTitle,
          //       style: TextStyle(
          //         fontFamily: 'Sora',
          //         fontWeight: FontWeight.w400,
          //         fontStyle: FontStyle.normal,
          //         fontSize: 30.sp,
          //         height: 1.0,
          //         letterSpacing: 0.0,
          //         color: Theme.of(context).colorScheme.onSurface,
          //       ),
          //     ),
          //     const Spacer(),
          //   ],
          // ),

          Positioned(
            bottom: 5,
            right: 10,
            child: SizedBox(
              height: 78.h,
              width: 80.w,
              child: Center(
                child: Transform.rotate(
                  angle: -81.51,
                  child: SvgPicture.asset(
                    "assets/images/Group099.svg",
                    width: 92.w,
                    height: 92.h,
                    color: colors.surfaceContainerLow,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                    AppLocalizations.of(context)!.scanTabTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _selectedSection == 0
                          ? Theme.of(context).colorScheme.onSurface
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
                    AppLocalizations.of(context)!.supportedBreeds,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _selectedSection == 1
                          ? Theme.of(context).colorScheme.onSurface
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
                      ? Theme.of(context)
                            .colorScheme
                            .surfaceContainer // Purple color
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
                      ? Theme.of(context)
                            .colorScheme
                            .surfaceContainer // Purple color
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
        return _buildRecentScanCard(scan, index, scanProvider, context);
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
    final breedName = scan['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed;
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
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.background.withOpacity(0.2)),
        // boxShadow: [
        //   BoxShadow(
        //     color: colors.onSurface.withOpacity(0.1),
        //     blurRadius: 42.w,
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
                Navigator.pushNamed(
                  context,
                  RoutesName.dogSave,
                  arguments: {"scanId": scanId},
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Container
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
                            fontWeight: FontWeight.bold,
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
                        onTap: () {
                          if (kDebugMode) {
                            print("📌 Navigating with scanId: $scanId");
                          }
                          Navigator.pushNamed(
                            context,
                            RoutesName.dogSave,
                            arguments: {"scanId": scanId},
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
    final favouriteBreeds = topBreeds
        .where((breed) => scanProvider.isBreedFavorite(breed['name']!))
        .toList();

    if (favouriteBreeds.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Text(
            AppLocalizations.of(context)!.noFavoriteBreedsMessage,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Column(
          children: favouriteBreeds.map((breed) {
            final _ = true; // always true here

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: 413.w,
              height: 140.h,
              decoration: BoxDecoration(
                color: colors.tertiaryContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: colors.background.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 103.w,
                      height: 103.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF8F5FF),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(51.5.w),
                        child: Image.asset(breed['image']!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Text(
                              breed['name']!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, right: 6.w),
                              child: GestureDetector(
                                onTap: () {
                                  scanProvider.toggleBreedFavorite(
                                    breed['name']!,
                                  );
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Expanded(
                          child: Text(
                            breed['description']!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
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

  String _formatBreedName(String name) {
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

String _formatBreedNameHelper(String name) {
  return name
      .replaceAll('-', ' ')
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

Future<void> _handleRescanTap(
  Map<String, dynamic> scan,
  BuildContext context,
) async {
  if (kDebugMode) {
    print('🔄 Re-scanning: ${scan['breedName']}');
  }

  try {
    final cameraResult = await Navigator.pushNamed(context, RoutesName.camera);

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

        final scanProvider = Provider.of<ScanProvider>(context, listen: false);
        final scanData = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'image': dogResult['image'] ?? cameraResult,
          'breedName': dogResult['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed,
          'confidence': (dogResult['confidence'] ?? 0.0) is double
              ? dogResult['confidence'] as double
              : 0.0,
          // 'formattedBreedName':
          // dogResult['formattedBreedName']?.toString() ??
          //     _formatBreedName(
          //       dogResult['breedName']?.toString() ?? AppLocalizations.of(context)!.unknownBreed,
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
