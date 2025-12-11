import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View/DogIdentifierApp.dart';

class DogPredictionResultsScreen extends StatelessWidget {
  final PredictionResult predictionResult;
  final Uint8List? imageBytes;
  final VoidCallback onNewPrediction;
  final VoidCallback? onSaveResult;
  final VoidCallback? onViewHistory;

  const DogPredictionResultsScreen({
    Key? key,
    required this.predictionResult,
    this.imageBytes,
    required this.onNewPrediction,
    this.onSaveResult,
    this.onViewHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Breed Analysis'),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (onViewHistory != null)
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: onViewHistory,
              tooltip: 'View History',
            ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: onNewPrediction,
            tooltip: 'New Scan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Confidence Section
            _buildImageAndConfidenceSection(),

            SizedBox(height: 16.h),

            // Breed Identification Card
            _buildBreedIdentificationCard(),

            SizedBox(height: 16.h),

            // Physical Characteristics Section
            _buildPhysicalCharacteristicsSection(),

            SizedBox(height: 16.h),

            // Temperament Traits Section
            _buildTemperamentSection(),

            SizedBox(height: 16.h),

            // Additional Information Section
            _buildAdditionalInfoSection(),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onNewPrediction,
        backgroundColor: const Color(0xFF7B2CBF),
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        label: const Text(
          'Scan Another',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageAndConfidenceSection() {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF7B2CBF),
            const Color(0xFF7B2CBF).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -50.w,
            top: -50.h,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.pets,
                size: 300.w,
                color: Colors.white,
              ),
            ),
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image Container
              Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: imageBytes != null
                      ? Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.pets,
                          color: const Color(0xFF7B2CBF),
                          size: 60.w,
                        ),
                      );
                    },
                  )
                      : Container(
                    color: Colors.white,
                    child: Icon(
                      Icons.pets,
                      color: const Color(0xFF7B2CBF),
                      size: 60.w,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Confidence Indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(predictionResult.confidence),
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getConfidenceIcon(predictionResult.confidence),
                      size: 18.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${(predictionResult.confidence * 100).toStringAsFixed(1)}% Confident',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'AI Analysis Complete',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green.shade600;
    if (confidence >= 0.6) return Colors.blue.shade600;
    if (confidence >= 0.4) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  IconData _getConfidenceIcon(double confidence) {
    if (confidence >= 0.8) return Icons.verified;
    if (confidence >= 0.6) return Icons.check_circle;
    if (confidence >= 0.4) return Icons.warning;
    return Icons.error_outline;
  }

  Widget _buildBreedIdentificationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: const Color(0xFF7B2CBF).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B2CBF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  Icons.pets,
                  color: const Color(0xFF7B2CBF),
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breed Identified',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      predictionResult.breed,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7B2CBF),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 16.sp,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'Primary Purpose: ${predictionResult.purpose}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Confidence Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confidence Level',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${(predictionResult.confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF7B2CBF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: predictionResult.confidence,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(predictionResult.confidence),
                  ),
                  minHeight: 8.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalCharacteristicsSection() {
    final characteristics = [
      {'title': 'Size', 'value': predictionResult.size, 'icon': Icons.height},
      {'title': 'Shape', 'value': predictionResult.shape, 'icon': Icons.shape_line},
      {'title': 'Color', 'value': predictionResult.color, 'icon': Icons.palette},
      {'title': 'Coat Type', 'value': predictionResult.coat, 'icon': Icons.texture},
    ];

    final bodyCharacteristics = [
      {'title': 'Head/Face', 'value': predictionResult.headFace, 'icon': Icons.face},
      {'title': 'Body Structure', 'value': predictionResult.body, 'icon': Icons.accessibility},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: const Color(0xFF7B2CBF),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Physical Characteristics',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Characteristics Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.5,
            ),
            itemCount: characteristics.length,
            itemBuilder: (context, index) {
              final item = characteristics[index];
              return _buildCharacteristicCard(
                item['title'] as String,
                item['value'] as String,
                item['icon'] as IconData,
              );
            },
          ),

          SizedBox(height: 16.h),

          // Body Characteristics
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.5,
            ),
            itemCount: bodyCharacteristics.length,
            itemBuilder: (context, index) {
              final item = bodyCharacteristics[index];
              return _buildCharacteristicCard(
                item['title'] as String,
                item['value'] as String,
                item['icon'] as IconData,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperamentSection() {
    final temperament = predictionResult.temperament;
    final entries = temperament.entries.toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: const Color(0xFF7B2CBF),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Temperament & Behavior',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Temperament Stats
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: Colors.grey[100]!,
                width: 1,
              ),
            ),
            child: Column(
              children: entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildTemperamentRow(
                    _formatTraitName(entry.key),
                    entry.value,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperamentRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _getTraitColor(value).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _getTraitColor(value).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: _getTraitColor(value),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTraitName(String name) {
    // Convert camelCase or snake_case to Title Case
    final formatted = name
        .replaceAll('_', ' ')
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();

    return formatted.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getTraitColor(String value) {
    final lowerValue = value.toLowerCase();

    if (lowerValue.contains('very high') || lowerValue.contains('excellent')) {
      return Colors.green.shade700;
    } else if (lowerValue.contains('high') || lowerValue.contains('very good')) {
      return Colors.green.shade600;
    } else if (lowerValue.contains('moderate') || lowerValue.contains('average')) {
      return Colors.orange.shade600;
    } else if (lowerValue.contains('low') || lowerValue.contains('minimal')) {
      return Colors.red.shade600;
    } else if (lowerValue.contains('good') || lowerValue.contains('friendly')) {
      return Colors.blue.shade600;
    } else if (lowerValue.contains('excellent') || lowerValue.contains('outstanding')) {
      return Colors.green.shade800;
    }

    return const Color(0xFF7B2CBF);
  }

  Widget _buildAdditionalInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: const Color(0xFF7B2CBF),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: Colors.grey[100]!,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Gender
                _buildInfoRow(
                  'Gender',
                  predictionResult.gender,
                  Icons.female,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                // Age Group
                _buildInfoRow(
                  'Age Group',
                  predictionResult.age,
                  Icons.cake,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                // Weight Range
                _buildInfoRow(
                  'Weight Range',
                  predictionResult.weight,
                  Icons.scale,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: const Color(0xFF7B2CBF),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}