
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../View_model/ScanProvider.dart';

class Dogtreslutsave extends StatefulWidget {
  const Dogtreslutsave({super.key});

  @override
  State<Dogtreslutsave> createState() => _DogtreslutsaveState();
}

class _DogtreslutsaveState extends State<Dogtreslutsave> {
Map<String,dynamic>? scan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final scanId = args != null ? args['scanId'] : null;
      if (kDebugMode) print("📌 Received scanId: $scanId");

      // List all scans for debugging
      if (kDebugMode) {
        print("📊 -------- All Scans Available --------");
        for (var s in scanProvider.recentScans) {
          print("➡ ID: ${s['id']} | Breed: ${s['breedName']}");
        }
        print("----------------------------------------");
      }

      // Find the scan that matches the ID
      if (scanId != null) {
        final matched = scanProvider.recentScans.firstWhere(
              (s) => s['id'].toString() == scanId.toString(),
          orElse: () => {},
        );
        if (matched.isNotEmpty) {
          setState(() {
            scan = Map<String, dynamic>.from(matched);
          });
          if (kDebugMode) print("✅ Matched scan: ${scan!['breedName']}");
        } else {
          if (kDebugMode) print("❌ No scan matched for ID: $scanId");
        }
      } else {
        if (kDebugMode) print("❌ scanId was null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: scan == null
                ? _buildEmptyState()
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h),
                  _buildHeader(),
                  SizedBox(height: 25.h),
                  _buildDetailedScanCard(scan!,scanProvider),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
  //     if (kDebugMode) {
  //       print('📊 Scan count on startup: ${scanProvider.recentScans.length}');
  //       for (var scan in scanProvider.recentScans) {
  //         print('   Scan ID: ${scan['id']}, Breed: ${scan['breedName']}');
  //       }
  //     }
  //   });
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<ScanProvider>(
  //     builder: (context, scanProvider, child) {
  //       final recentScans = scanProvider.recentScans;
  //
  //       return Scaffold(
  //         backgroundColor: Colors.white,
  //         body: SafeArea(
  //           child: recentScans.isEmpty
  //               ? _buildEmptyState()
  //               : SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 25.h),
  //                 _buildHeader(),
  //                 SizedBox(height: 25.h),
  //                 ...recentScans.map((scan) => _buildDetailedScanCard(scan, scanProvider)).toList(),
  //                 SizedBox(height: 40.h),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _goBack() {
    Navigator.pop(context);
  }
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _goBack,
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
                'Dog Results',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 29.75.w,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 300.h,
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: const Color(0xFF323332).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 60.sp, color: Colors.grey[600]),
            SizedBox(height: 20.h),
            Text(
              'No recent scans',
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            SizedBox(height: 12.h),
            Text(
              'Scan a dog to see results here',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedScanCard(Map<String, dynamic> scan, ScanProvider scanProvider) {
    final imageBytes = _parseImageData(scan['imageBytes']);
    final breedName = scan['breedName']?.toString() ?? 'Unknown Breed';
    final confidence = (scan['confidence'] as num?)?.toDouble() ?? 0.0;
    Map<String, dynamic> characteristics = scan['characteristics'] is Map
        ? Map.from(scan['characteristics'])
        : {};
    final size = characteristics['size']?.toString() ?? "N/A";
    final color = characteristics['color']?.toString() ?? "N/A";
    final coat = characteristics['coat']?.toString() ?? "N/A";
    final headFace = characteristics['headFace']?.toString() ?? "N/A";
    final purpose = characteristics['purpose']?.toString() ?? "N/A";
    final body = characteristics['body']?.toString() ?? "N/A";
    final weight = characteristics['weight']?.toString() ?? "N/A";
    final height = characteristics['height']?.toString() ?? "N/A";

    // Extract temperament
    Map<String, dynamic> temperament = {};
    if (characteristics['temperament'] is Map) {
      temperament = Map.from(characteristics['temperament']);
    } else if (scan['temperament'] is Map) {
      temperament = Map.from(scan['temperament']);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageBytes != null)
            Container(
              height: 245.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            )
          else
            Container(
              height: 245.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.grey[200],
              ),
              child: Center(child: Icon(Icons.photo, size: 60.sp, color: Colors.grey)),
            ),

          SizedBox(height: 20.h),

          // Breed Name + Confidence
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _formatBreedName(breedName),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          SizedBox(height: 30.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 2.6,
            children: [
              _buildCharacteristicCard(iconPath: "assets/images/size.svg", title: "Size", value: size),
              _buildCharacteristicCard(iconPath: "assets/images/shape.svg", title: "Height", value: height),
              _buildCharacteristicCard(iconPath: "assets/images/regular.svg", title: "Color", value: color),
              _buildCharacteristicCard(iconPath: "assets/images/coat.svg", title: "Coat", value: coat),
              _buildCharacteristicCard(iconPath: "assets/images/flex_dog.svg", title: "Head & Face", value: headFace),
              _buildCharacteristicCard(iconPath: "assets/images/akar.svg", title: "Purpose", value: purpose),
              _buildCharacteristicCard(iconPath: "assets/images/fluent.svg", title: "Body", value: body),
              _buildCharacteristicCard(iconPath: "assets/images/akar.svg", title: "Weight", value: weight),
            ],
          ),

          if (temperament.isNotEmpty) ...[
            SizedBox(height: 30.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Temperament & Characteristics",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 16.h),
                ...[
                  "Energy Level",
                  "Trainability",
                  "Social Behavior",
                  "Family Compatibility",
                  "Child Friendliness",
                ].where((key) => temperament.containsKey(key)).map(
                      (key) => _buildTemperamentRow(key, temperament[key]?.toString() ?? "N/A"),
                ),
                ...temperament.entries
                    .where((e) => ![
                  "Energy Level",
                  "Trainability",
                  "Social Behavior",
                  "Family Compatibility",
                  "Child Friendliness"
                ].contains(e.key))
                    .map((e) => _buildTemperamentRow(e.key, e.value.toString())),
              ],
            ),
          ],

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCharacteristicCard({
    String? iconPath,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath,
              width: 32.w,
              height: 32.h,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold,height: 1.5.h, color: Theme.of(context).colorScheme.tertiary),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperamentRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color(0xFF7E808F)),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Uint8List? _parseImageData(dynamic imageData) {
    if (imageData == null) return null;
    if (imageData is Uint8List) return imageData;
    if (imageData is List<int>) return Uint8List.fromList(imageData);
    if (imageData is String) {
      try {
        String base64String = imageData.contains('base64,') ? imageData.split('base64,')[1] : imageData;
        return base64.decode(base64String);
      } catch (e) {
        if (kDebugMode) print('Base64 decode error: $e');
        return null;
      }
    }
    return null;
  }

  String _formatBreedName(String name) {
    if (name.isEmpty) return 'Unknown Breed';
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ');
  }
}



