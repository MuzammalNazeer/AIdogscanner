import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.breedAnalysisTitle),
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
              tooltip: l10n.viewHistoryTooltip,
            ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: onNewPrediction,
            tooltip: l10n.newScanTooltip,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Confidence Section
            _buildImageAndConfidenceSection(context, l10n),

            SizedBox(height: 16.h),

            // Breed Identification Card
            _buildBreedIdentificationCard(context, l10n),

            SizedBox(height: 16.h),

            // Physical Characteristics Section
            _buildPhysicalCharacteristicsSection(context, l10n),

            SizedBox(height: 16.h),

            // Temperament Traits Section
            _buildTemperamentSection(context, l10n),

            SizedBox(height: 16.h),

            // Additional Information Section
            _buildAdditionalInfoSection(context, l10n),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onNewPrediction,
        backgroundColor: const Color(0xFF7B2CBF),
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        label: Text(
          l10n.scanAnotherButton,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageAndConfidenceSection(BuildContext context, AppLocalizations l10n) {
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
                      '${(predictionResult.confidence * 100).toStringAsFixed(1)}% ${l10n.confidentLabel}',
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
                l10n.aiAnalysisComplete,
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

  Widget _buildBreedIdentificationCard(BuildContext context, AppLocalizations l10n) {
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
                      l10n.breedIdentified,
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
                            l10n.primaryPurpose(predictionResult.purpose),
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
                    l10n.confidenceLevel,
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

  Widget _buildPhysicalCharacteristicsSection(BuildContext context, AppLocalizations l10n) {
    final characteristics = [
      {'title': l10n.size, 'value': _getLocalizedSize(context, predictionResult.size), 'icon': Icons.height},
      {'title': l10n.shape, 'value': predictionResult.shape, 'icon': Icons.shape_line},
      {'title': l10n.color, 'value': predictionResult.color, 'icon': Icons.palette},
      {'title': l10n.coatType, 'value': predictionResult.coat, 'icon': Icons.texture},
    ];

    final bodyCharacteristics = [
      {'title': l10n.headAndFace, 'value': predictionResult.headFace, 'icon': Icons.face},
      {'title': l10n.bodyStructure, 'value': predictionResult.body, 'icon': Icons.accessibility},
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
                  l10n.physicalCharacteristicsTitle,
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

  Widget _buildTemperamentSection(BuildContext context, AppLocalizations l10n) {
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
                  l10n.temperamentAndBehaviorTitle,
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
                    context,
                    l10n,
                    entry.key,
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

  Widget _buildTemperamentRow(BuildContext context, AppLocalizations l10n, String key, String value) {
    String title = key;
    if (key.toLowerCase().contains('energy')) title = l10n.energyLevel;
    else if (key.toLowerCase().contains('trainability')) title = l10n.trainability;
    else if (key.toLowerCase().contains('social')) title = l10n.socialBehavior;
    else if (key.toLowerCase().contains('family')) title = l10n.familyCompatibility;
    else if (key.toLowerCase().contains('child')) title = l10n.childFriendliness;
    else title = _formatTraitName(key);

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
                _getLocalizedTemperamentValue(context, value),
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

  Widget _buildAdditionalInfoSection(BuildContext context, AppLocalizations l10n) {
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
                  l10n.additionalInfoTitle,
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
                  l10n.labelGender,
                  predictionResult.gender,
                  Icons.female,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                // Age Group
                _buildInfoRow(
                  l10n.ageGroup,
                  predictionResult.age,
                  Icons.cake,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                // Weight Range
                _buildInfoRow(
                  l10n.weightRange,
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

  String _getLocalizedSize(BuildContext context, String size) {
    final loc = AppLocalizations.of(context)!;
    switch (size.toLowerCase()) {
      case 'small': return loc.sizeSmall;
      case 'medium': return loc.sizeMedium;
      case 'large': return loc.sizeLarge;
      case 'giant': return loc.sizeGiant;
      case 'toy': return loc.sizeToy;
      case 'miniature': return loc.sizeMiniature;
      case 'standard': return loc.sizeStandard;
      case 'small to medium': return loc.sizeSmallToMedium;
      case 'medium to large': return loc.sizeMediumToLarge;
      default: return size;
    }
  }

  String _getLocalizedTemperamentValue(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();

    if (lower.contains('low') && lower.contains('moderate')) return loc.levelLowToModerate;
    if (lower.contains('moderate') && lower.contains('high')) return loc.levelModerateToHigh;
    if (lower.contains('high') && lower.contains('very')) return loc.levelHighToVeryHigh;

    if (lower == 'low') return loc.levelLow;
    if (lower == 'high') return loc.levelHigh;
    if (lower == 'very high') return loc.levelVeryHigh;
    if (lower == 'moderate') return loc.moderate;

    if (lower == 'good') return loc.good;
    if (lower == 'excellent') return loc.ratingExcellent;
    if (lower == 'average') return loc.ratingAverage;
    if (lower == 'fair') return loc.ratingFair;
    if (lower == 'poor') return loc.ratingPoor;

    if (lower == 'friendly') return loc.friendly;

    // Traits
    if (lower.contains('intelligent')) return loc.traitIntelligent;
    if (lower.contains('alert')) return loc.traitAlert;
    if (lower.contains('loyal')) return loc.traitLoyal;
    if (lower.contains('protective')) return loc.traitProtective;
    if (lower.contains('calm')) return loc.traitCalm;
    if (lower.contains('gentle')) return loc.traitGentle;
    if (lower.contains('active') && !lower.contains('family')) return loc.traitActive;
    if (lower.contains('independent')) return loc.traitIndependent;
    if (lower.contains('confident')) return loc.traitConfident;
    if (lower.contains('brave')) return loc.traitBrave;
    if (lower.contains('playful')) return loc.traitPlayful;
    if (lower.contains('affectionate')) return loc.traitAffectionate;
    if (lower.contains('stubborn')) return loc.traitStubborn;
    if (lower.contains('eager to please')) return loc.traitEagerToPlease;

    // Compatibility
    if (lower.contains('excellent') && lower.contains('children')) return loc.excellentWithChildren;
    if (lower.contains('excellent') && lower.contains('family')) return loc.excellentWithFamily;
    if (lower.contains('good') && lower.contains('children')) return loc.goodWithChildren;
    if (lower.contains('good') && lower.contains('family')) return loc.goodWithFamily;

    return value;
  }
}
