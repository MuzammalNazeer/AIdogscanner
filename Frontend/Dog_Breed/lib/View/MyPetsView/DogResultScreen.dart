import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../View_model/DogValuesViewModel.dart';
import '../../View_model/ScanProvider.dart';
import '../../utils/routes/routes_name.dart';

class DogResultScreen extends StatefulWidget {
  final File imageFile;

  const DogResultScreen({super.key, required this.imageFile});

  @override
  State<DogResultScreen> createState() => _DogResultScreenState();
}

class _DogResultScreenState extends State<DogResultScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DogValuesViewModel(),
      child: Consumer<DogValuesViewModel>(
        builder: (context, viewModel, child) {
          return _DogResultScreenContent(
            viewModel: viewModel,
            imageFile: widget.imageFile,
          );
        },
      ),
    );
  }
}

class _DogResultScreenContent extends StatefulWidget {
  final DogValuesViewModel viewModel;
  final File imageFile;

  const _DogResultScreenContent({
    required this.viewModel,
    required this.imageFile,
  });

  @override
  State<_DogResultScreenContent> createState() => _DogResultScreenContentState();
}

class _DogResultScreenContentState extends State<_DogResultScreenContent> {
  Uint8List? _imageBytes;
  bool _initialized = false;
  bool _isSaving = false;
  bool _isAutoSaved = false;
  bool _canAutoSave = true; // Track if auto-save is allowed

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _imageBytes = await widget.imageFile.readAsBytes();

      if (_imageBytes != null) {
        widget.viewModel.predictImage(_imageBytes!);
      }

      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Initialization error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    if (!_initialized || viewModel.isLoading) {
      return _buildLoadingScreen();
    }

    if (viewModel.error.isNotEmpty) {
      return _buildErrorScreen(viewModel.error);
    }

    if (!viewModel.isDogDetected) {
      return _buildNotDogScreen(viewModel);
    }

    if (viewModel.predictionResult == null) {
      return _buildErrorScreen('No prediction results available');
    }

    // Check if we should auto-save (confidence >= 40%)
    final confidence = viewModel.predictionResult!.confidence * 100;
    if (confidence >= 40.0 && _canAutoSave) {
      // Auto-save when results are ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isAutoSaved && !_isSaving && viewModel.predictionResult != null) {
          _autoSaveResults();
        }
      });
    }

    return _buildResultsScreen(viewModel);
  }

  // Check if results meet the criteria for saving
  bool _shouldSaveResults(DogValuesViewModel viewModel) {
    if (!viewModel.isDogDetected) {
      if (kDebugMode) print('❌ Cannot save: Not a dog');
      return false;
    }

    if (viewModel.predictionResult == null) {
      if (kDebugMode) print('❌ Cannot save: No prediction result');
      return false;
    }

    final confidence = viewModel.predictionResult!.confidence * 100;
    if (confidence < 40.0) {
      if (kDebugMode) print('❌ Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%');
      return false;
    }

    return true;
  }

  Future<void> _autoSaveResults() async {
    if (_isAutoSaved || _isSaving) return;

    final viewModel = widget.viewModel;

    // Check if we should save
    if (!_shouldSaveResults(viewModel)) {
      _canAutoSave = false; // Prevent future auto-save attempts
      return;
    }

    final result = viewModel.predictionResult!;
    final confidence = result.confidence * 100;

    if (kDebugMode) {
      print('✅ Auto-save conditions met: Dog detected, Confidence: ${confidence.toStringAsFixed(1)}%');
    }

    try {
      setState(() {
        _isSaving = true;
      });

      final imageBytes = viewModel.imageBytes ?? _imageBytes;
      if (imageBytes == null) {
        return;
      }

      // Save logic
      await _saveDataToProvider(viewModel, imageBytes, isAutoSave: true);

      if (mounted) {
        setState(() {
          _isAutoSaved = true;
          _isSaving = false;
          _canAutoSave = false; // Prevent further auto-saves
        });
      }

      if (kDebugMode) {
        print('✅ Auto-saved to recent scans: ${result.breed} (${confidence.toStringAsFixed(1)}%)');
      }

    } catch (e) {
      if (kDebugMode) {
        print('❌ Auto-save error: $e');
      }
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildCharacteristicCard({
    String? iconPath,
    required String title,
    required String value,
  }) {
    return Container(
      height: 55.h,
      width: 193.w,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                iconPath,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.tertiary,
                      height: 1.5.h
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // FittedBox(
                //   fit: BoxFit.scaleDown,
                //   child: Text(
                //     value,
                //     style: TextStyle(
                //       fontSize: 18.sp,
                //       color: Theme.of(context).colorScheme.tertiary,
                //     ),
                //     maxLines: 2,
                //
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text(
                'Analyzing image...',
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 40.h),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                    SizedBox(height: 20.h),
                    Text(
                      'Error Occurred',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      error,
                      style: TextStyle(fontSize: 16.sp, color: Colors.red[800]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    RoundButton(
                      title: "Go Back",
                      height: 50.h,
                      borderRadius: 12.r,
                      textColors: Colors.white,
                      backgroundColors: Colors.red,
                      isSelected: true,
                      onPress: _goBack,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotDogScreen(DogValuesViewModel viewModel) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 40.h),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.pets, size: 64.sp, color: Colors.orange),
                    SizedBox(height: 20.h),
                    Text(
                      'No Dog Detected',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Please try with a clearer photo of a dog.',
                      style: TextStyle(fontSize: 16.sp, color: Colors.orange[700]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            title: "Cancel",
                            height: 50.h,
                            borderRadius: 12.r,
                            textColors: Colors.red,
                            backgroundColors: Colors.red[50]!,
                            isSelected: true,
                            onPress: _goBack,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: RoundButton(
                            title: "Try Again",
                            height: 50.h,
                            borderRadius: 12.r,
                            textColors: Colors.white,
                            backgroundColors: Colors.orange,
                            isSelected: true,
                            onPress: _goBack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen(DogValuesViewModel viewModel) {
    final result = viewModel.predictionResult!;
    final imageBytes = viewModel.imageBytes ?? _imageBytes;
    final confidence = result.confidence * 100;
    final canSave = _shouldSaveResults(viewModel);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 25.h),

              // Warning for low confidence
              if (confidence < 40.0)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, size: 20.sp, color: Colors.orange[800]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Low confidence (${confidence.toStringAsFixed(1)}%). Results may not be accurate.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_isSaving)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Saving to recent scans...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

              if (imageBytes != null)
                Container(
                  height: 245.h,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _formatBreedName(result.breed),
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          confidence >= 70.0
                              ? const Color(0xFF7DFAC4).withOpacity(0.3)
                              : confidence >= 40.0
                              ? const Color(0xFFFFD700).withOpacity(0.3)
                              : const Color(0xFFFF6B6B).withOpacity(0.3),
                          confidence >= 70.0
                              ? const Color(0xFF05E51F).withOpacity(0.1)
                              : confidence >= 40.0
                              ? const Color(0xFFFFA500).withOpacity(0.1)
                              : const Color(0xFFFF5252).withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: confidence >= 70.0
                              ? Colors.green.withOpacity(0.2)
                              : confidence >= 40.0
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${confidence.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: confidence >= 70.0
                              ? const Color(0xFF05E51F)
                              : confidence >= 40.0
                              ? const Color(0xFFFFA500)
                              : const Color(0xFFFF5252),
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
                  _buildCharacteristicCard(
                    iconPath: "assets/images/size.svg",
                    title: "Size",
                    value: result.size,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/shape.svg",
                    title: "Shape",
                    value: result.shape,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/regular.svg",
                    title: "Color",
                    value: result.color,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/coat.svg",
                    title: "Coat",
                    value: result.coat,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/flex_dog.svg",
                    title: "Head & Face",
                    value: result.headFace,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/akar.svg",
                    title: "Purpose",
                    value: result.purpose,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/fluent.svg",
                    title: "Body",
                    value: result.body,
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/akar.svg",
                    title: "Weight",
                    value: result.weight,
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              Text(
                "Temperament & Characteristics",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 16.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemperamentCard(
                    "Energy Level",
                    result.temperament["Energy Level"] ?? "Moderate",
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    "Trainability",
                    result.temperament["Trainability"] ?? "Moderate",
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    "Social Behavior",
                    result.temperament["Social Behavior"] ?? "Friendly",
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    "Family Compatibility",
                    result.temperament["Family Compatibility"] ?? "Good",
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    "Child Friendliness",
                    result.temperament["Child Friendliness"] ?? "Good",
                  ),
                ],
              ),

              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: RoundButton(
                        title: "Cancel",
                        height: 58.h,
                        borderRadius: 47.r,
                        textColors: const Color(0xFFFF0505),
                        backgroundColors: const Color(0xFFFFE5E5),
                        isSelected: true,
                        onPress: _goBack,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: (!canSave || _isAutoSaved || _isSaving)
                            ? null
                            : () {
                          _manualSaveResults();
                        },
                        child: Opacity(
                          opacity: (!canSave || _isAutoSaved || _isSaving) ? 0.9 : 1.0,
                          child: RoundButton(
                            title: !canSave ? "Cannot Save" :
                            _isSaving ? "Saving..." :
                            (_isAutoSaved ? "Saved  Recents" : "Save Results"),
                            height: 58.h,
                            borderRadius: 47.r,
                            textColors: Colors.white,
                            backgroundColors: !canSave ? Colors.black :
                            _isAutoSaved ? Colors.black : Colors.black,
                            isSelected: true,
                            onPress: () {
                              if (canSave && !_isAutoSaved && !_isSaving) {
                                _manualSaveResults();
                              }
                            },
                          ),
                        ),
                      ),
                    ),                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperamentCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF7E808F),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  String _formatBreedName(String name) {
    return name
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _goBack() {
    Navigator.pop(context);
  }


  Future<void> _manualSaveResults() async {
    // Get viewModel
    final viewModel = widget.viewModel;

    // Check if we should save
    if (!_shouldSaveResults(viewModel)) {
      final confidence = viewModel.predictionResult!.confidence * 100;
      _showSnackbar(
        'Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%',
        Colors.orange,
      );
      return;
    }

    if (viewModel.predictionResult == null) {
      _showSnackbar('No prediction result available', Colors.red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final _ = viewModel.predictionResult!;
      final imageBytes = viewModel.imageBytes ?? _imageBytes;

      if (imageBytes == null) {
        _showSnackbar('No image data to save', Colors.red);
        setState(() => _isSaving = false);
        return;
      }

      await _saveDataToProvider(viewModel, imageBytes, isAutoSave: false);

      setState(() {
        _isAutoSaved = true;
        _isSaving = false;
      });

      // // Show success message
      // final confidence = result.confidence * 100;
      // _showSnackbar(
      //   '${_formatBreedName(result.breed)} saved successfully! (${confidence.toStringAsFixed(1)}%) ✅',
      //   Colors.green,
      // );

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.dashboard,
              (route) => false,
        );
      }

    } catch (e) {
      // if (kDebugMode) {
      //   print('❌ Manual save error: $e');
      //   print('Stack trace: $stackTrace');
      // }
      _showSnackbar('Failed to save results', Colors.red);
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Common save method for both auto and manual save
  Future<void> _saveDataToProvider(
      DogValuesViewModel viewModel,
      Uint8List imageBytes,
      {bool isAutoSave = false}
      ) async {
    final result = viewModel.predictionResult!;

    // Get breed info from database
    final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;

    // Prepare characteristics
    final Map<String, dynamic> characteristics = {
      'size': result.size,
      'weight': result.weight,
      'height': result.height,
      'coat': result.coat,
      'color': result.color,
      'headFace': result.headFace,
      'body': result.body,
      'purpose': result.purpose,
      'shape': result.shape,
      'age': result.age,
      'gender': result.gender,
    };

    // Add temperament if available
    if (result.temperament.isNotEmpty) {
      characteristics['temperament'] = result.temperament;
    }

    // If breedInfo exists in database, enrich the characteristics
    if (breedInfo != null) {
      // Override with database values (they're more complete)
      characteristics.addAll({
        'size': breedInfo['size'] as String? ?? result.size,
        'weight': breedInfo['weight'] as String? ?? result.weight,
        'height': breedInfo['height'] as String? ?? result.height,
        'age': breedInfo['age'] as String? ?? result.age,
        'coat': breedInfo['coat'] as String? ?? result.coat,
        'color': breedInfo['color'] as String? ?? result.color,
        'headFace': breedInfo['headFace'] as String? ?? result.headFace,
        'body': breedInfo['body'] as String? ?? result.body,
        'purpose': breedInfo['purpose'] as String? ?? result.purpose,
      });

      // Add temperament from breedInfo if available
      if (breedInfo['temperament'] is Map) {
        try {
          final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
          characteristics['temperament'] = {
            ...result.temperament,
            ...temperament,
          };
        } catch (e) {
          if (kDebugMode) print('Error parsing temperament: $e');
        }
      }
    }

    // Create the complete scan data
    final resultData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'imageBytes': imageBytes,
      'breedName': result.breed,
      'formattedBreedName': _formatBreedName(result.breed),
      'confidence': result.confidence,
      'timestamp': DateTime.now().toIso8601String(),
      'isFavorite': false,
      'isAutoSaved': isAutoSave,
      'characteristics': characteristics,
      'size': characteristics['size'],
      'weight': characteristics['weight'],
      'height': characteristics['height'],
      'age': characteristics['age'],
      'coat': characteristics['coat'],
      'color': characteristics['color'],
      'headFace': characteristics['headFace'],
      'body': characteristics['body'],
      'purpose': characteristics['purpose'],
      'temperament': characteristics['temperament'],
    };

    // Save to ScanProvider
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    await scanProvider.addScan(resultData);
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:typed_data' show Uint8List;
//
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart' show CupertinoIcons;
// import 'package:flutter/foundation.dart' show kDebugMode;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/DogValuesViewModel.dart';
// import '../../View_model/ScanProvider.dart';
// import '../../utils/routes/routes_name.dart';
//
// class DogResultScreen extends StatefulWidget {
//   final File imageFile;
//
//   const DogResultScreen({super.key, required this.imageFile});
//
//   @override
//   State<DogResultScreen> createState() => _DogResultScreenState();
// }
//
// class _DogResultScreenState extends State<DogResultScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DogValuesViewModel(),
//       child: Consumer<DogValuesViewModel>(
//         builder: (context, viewModel, child) {
//           return _DogResultScreenContent(
//             viewModel: viewModel,
//             imageFile: widget.imageFile,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _DogResultScreenContent extends StatefulWidget {
//   final DogValuesViewModel viewModel;
//   final File imageFile;
//
//   const _DogResultScreenContent({
//     required this.viewModel,
//     required this.imageFile,
//   });
//
//   @override
//   State<_DogResultScreenContent> createState() => _DogResultScreenContentState();
// }
//
// class _DogResultScreenContentState extends State<_DogResultScreenContent> {
//   Uint8List? _imageBytes;
//   bool _initialized = false;
//   bool _isSaving = false;
//   bool _isAutoSaved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }
//
//   Future<void> _initialize() async {
//     try {
//       _imageBytes = await widget.imageFile.readAsBytes();
//
//       if (_imageBytes != null) {
//         widget.viewModel.predictImage(_imageBytes!);
//       }
//
//       if (mounted) {
//         setState(() {
//           _initialized = true;
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Initialization error: $e');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = widget.viewModel;
//
//     if (!_initialized || viewModel.isLoading) {
//       return _buildLoadingScreen();
//     }
//
//     if (viewModel.error.isNotEmpty) {
//       return _buildErrorScreen(viewModel.error);
//     }
//
//     if (!viewModel.isDogDetected) {
//       return _buildNotDogScreen(viewModel);
//     }
//
//     if (viewModel.predictionResult == null) {
//       return _buildErrorScreen('No prediction results available');
//     }
//
//     // Auto-save results when they become available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_isAutoSaved &&
//           !viewModel.isLoading &&
//           viewModel.predictionResult != null) {
//         _autoSaveResults(viewModel);
//       }
//     });
//
//     return _buildResultsScreen(viewModel);
//   }
//
//   // Auto-save method that runs automatically
//   Future<void> _autoSaveResults(DogValuesViewModel viewModel) async {
//     if (_isAutoSaved || _isSaving) return;
//
//     final result = viewModel.predictionResult;
//     if (result == null) return;
//
//     // Wait a moment to ensure UI is ready
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     if (!mounted || _isAutoSaved) return;
//
//     try {
//       setState(() {
//         _isSaving = true;
//       });
//
//       final imageBytes = viewModel.imageBytes ?? _imageBytes;
//       if (imageBytes == null) {
//         return;
//       }
//
//       // Get breed info from database
//       final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
//
//       // Prepare characteristics
//       final Map<String, dynamic> characteristics = {
//         'size': result.size,
//         'weight': result.weight,
//         'height': result.height,
//         'coat': result.coat,
//         'color': result.color,
//         'headFace': result.headFace,
//         'body': result.body,
//         'purpose': result.purpose,
//         'shape': result.shape,
//         'age': result.age,
//         'gender': result.gender,
//       };
//
//       // Add temperament
//       if (result.temperament.isNotEmpty) {
//         characteristics['temperament'] = result.temperament;
//       }
//
//       // Enrich with database info if available
//       if (breedInfo != null) {
//         characteristics.addAll({
//           'size': breedInfo['size'] as String? ?? result.size,
//           'weight': breedInfo['weight'] as String? ?? result.weight,
//           'height': breedInfo['height'] as String? ?? result.height,
//           'age': breedInfo['age'] as String? ?? result.age,
//           'coat': breedInfo['coat'] as String? ?? result.coat,
//           'color': breedInfo['color'] as String? ?? result.color,
//           'headFace': breedInfo['headFace'] as String? ?? result.headFace,
//           'body': breedInfo['body'] as String? ?? result.body,
//           'purpose': breedInfo['purpose'] as String? ?? result.purpose,
//         });
//
//         if (breedInfo['temperament'] is Map) {
//           try {
//             final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
//             characteristics['temperament'] = {
//               ...result.temperament,
//               ...temperament,
//             };
//           } catch (e) {
//             if (kDebugMode) print('Error parsing temperament: $e');
//           }
//         }
//       }
//
//       // Prepare scan data
//       final resultData = {
//         'id': DateTime.now().millisecondsSinceEpoch.toString(),
//         'imageBytes': imageBytes,
//         'breedName': result.breed,
//         'formattedBreedName': _formatBreedName(result.breed),
//         'confidence': result.confidence,
//         'timestamp': DateTime.now().toIso8601String(),
//         'isFavorite': false,
//         'isAutoSaved': true, // Mark as auto-saved
//         'characteristics': characteristics,
//         'size': characteristics['size'],
//         'weight': characteristics['weight'],
//         'height': characteristics['height'],
//         'age': characteristics['age'],
//         'coat': characteristics['coat'],
//         'color': characteristics['color'],
//         'headFace': characteristics['headFace'],
//         'body': characteristics['body'],
//         'purpose': characteristics['purpose'],
//         'temperament': characteristics['temperament'],
//       };
//
//       // Save to ScanProvider
//       final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//       await scanProvider.addScan(resultData);
//
//       // Update state
//       if (mounted) {
//         setState(() {
//           _isAutoSaved = true;
//           _isSaving = false;
//         });
//       }
//
//       if (kDebugMode) {
//         print('✅ Auto-saved to recent scans: ${result.breed}');
//       }
//
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Auto-save error: $e');
//       }
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   Widget _buildCharacteristicCard({
//     String? iconPath,
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       height: 55.h,
//       width: 193.w,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (iconPath != null)
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: SvgPicture.asset(
//                 iconPath,
//                 width: 32.w,
//                 height: 32.h,
//                 fit: BoxFit.contain,
//                 color: Theme.of(context).colorScheme.tertiary,
//               ),
//             ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Theme.of(context).colorScheme.tertiary,
//                     ),
//                     maxLines: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(),
//               SizedBox(height: 20.h),
//               Text(
//                 'Analyzing image...',
//                 style: TextStyle(fontSize: 16.sp),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorScreen(String error) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
//           child: Column(
//             children: [
//               _buildHeader(),
//               SizedBox(height: 40.h),
//               Container(
//                 padding: EdgeInsets.all(24.w),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.red[200]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
//                     SizedBox(height: 20.h),
//                     Text(
//                       'Error Occurred',
//                       style: TextStyle(
//                         fontSize: 22.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     Text(
//                       error,
//                       style: TextStyle(fontSize: 16.sp, color: Colors.red[800]),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 24.h),
//                     RoundButton(
//                       title: "Go Back",
//                       height: 50.h,
//                       borderRadius: 12.r,
//                       textColors: Colors.white,
//                       backgroundColors: Colors.red,
//                       isSelected: true,
//                       onPress: _goBack,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotDogScreen(DogValuesViewModel viewModel) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
//           child: Column(
//             children: [
//               _buildHeader(),
//               SizedBox(height: 40.h),
//               Container(
//                 padding: EdgeInsets.all(24.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.background,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.orange[200]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(Icons.pets, size: 64.sp, color: Colors.orange),
//                     SizedBox(height: 20.h),
//                     Text(
//                       'No Dog Detected',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange[800],
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     Text(
//                       'Please try with a clearer photo of a dog.',
//                       style: TextStyle(fontSize: 16.sp, color: Colors.orange[700]),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 30.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: RoundButton(
//                             title: "Cancel",
//                             height: 50.h,
//                             borderRadius: 12.r,
//                             textColors: Colors.red,
//                             backgroundColors: Colors.red[50]!,
//                             isSelected: true,
//                             onPress: _goBack,
//                           ),
//                         ),
//                         SizedBox(width: 16.w),
//                         Expanded(
//                           child: RoundButton(
//                             title: "Try Again",
//                             height: 50.h,
//                             borderRadius: 12.r,
//                             textColors: Colors.white,
//                             backgroundColors: Colors.orange,
//                             isSelected: true,
//                             onPress: _goBack,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResultsScreen(DogValuesViewModel viewModel) {
//     final result = viewModel.predictionResult!;
//     final imageBytes = viewModel.imageBytes ?? _imageBytes;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               SizedBox(height: 25.h),
//
//               // Show saving indicator if auto-saving is in progress
//               if (_isSaving)
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 8.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 20.w,
//                         height: 20.h,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Text(
//                         'Saving to recent scans...',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               if (imageBytes != null)
//                 Container(
//                   height: 245.h,
//                   width: double.infinity,
//                   margin: EdgeInsets.only(bottom: 20.h),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     image: DecorationImage(
//                       image: MemoryImage(imageBytes),
//                       fit: BoxFit.cover,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 15,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                 ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _formatBreedName(result.breed),
//                       style: TextStyle(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onSurface,
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   Container(
//                     width: 100.w,
//                     height: 100.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           const Color(0xFF7DFAC4).withOpacity(0.3),
//                           const Color(0xFF05E51F).withOpacity(0.1),
//                         ],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.green.withOpacity(0.2),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         "${(result.confidence * 100).toStringAsFixed(0)}%",
//                         style: TextStyle(
//                           fontSize: 32.sp,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF05E51F),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30.h),
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12.w,
//                 mainAxisSpacing: 12.h,
//                 childAspectRatio: 2.6,
//                 children: [
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/size.svg",
//                     title: "Size",
//                     value: result.size,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/shape.svg",
//                     title: "Shape",
//                     value: result.shape,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/regular.svg",
//                     title: "Color",
//                     value: result.color,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/coat.svg",
//                     title: "Coat",
//                     value: result.coat,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/flex_dog.svg",
//                     title: "Head & Face",
//                     value: result.headFace,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/akar.svg",
//                     title: "Purpose",
//                     value: result.purpose,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/fluent.svg",
//                     title: "Body",
//                     value: result.body,
//                   ),
//                   _buildCharacteristicCard(
//                     iconPath: "assets/images/akar.svg",
//                     title: "Weight",
//                     value: result.weight,
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 30.h),
//
//               // Temperament section
//               Text(
//                 "Temperament & Characteristics",
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.tertiary,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTemperamentCard(
//                     "Energy Level",
//                     result.temperament["Energy Level"] ?? "Moderate",
//                   ),
//                   SizedBox(height: 12.h),
//
//                   _buildTemperamentCard(
//                     "Trainability",
//                     result.temperament["Trainability"] ?? "Moderate",
//                   ),
//                   SizedBox(height: 12.h),
//
//                   _buildTemperamentCard(
//                     "Social Behavior",
//                     result.temperament["Social Behavior"] ?? "Friendly",
//                   ),
//                   SizedBox(height: 12.h),
//
//                   _buildTemperamentCard(
//                     "Family Compatibility",
//                     result.temperament["Family Compatibility"] ?? "Good",
//                   ),
//                   SizedBox(height: 12.h),
//
//                   _buildTemperamentCard(
//                     "Child Friendliness",
//                     result.temperament["Child Friendliness"] ?? "Good",
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 30.h),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: RoundButton(
//                         title: "Cancel",
//                         height: 52.h,
//                         borderRadius: 12.r,
//                         textColors: const Color(0xFFFF0505),
//                         backgroundColors: const Color(0xFFFFE5E5),
//                         isSelected: true,
//                         onPress: _goBack,
//                       ),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: RoundButton(
//                         title: _isAutoSaved ? "Saved to Recents" : "Save Results",
//                         height: 52.h,
//                         borderRadius: 12.r,
//                         textColors: _isAutoSaved ? Colors.green : Colors.white,
//                         backgroundColors: _isAutoSaved ? Colors.green[50]! : const Color(0xFF2A2A2A),
//                         isSelected: !_isAutoSaved,
//                         onPress: _isAutoSaved ? () {} : () => _manualSaveResults(viewModel),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTemperamentCard(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF7E808F),
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 15.sp,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: _goBack,
//           child: Container(
//             width: 40.305.w,
//             height: 40.305.h,
//             padding: const EdgeInsets.all(8.96),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.background,
//               borderRadius: BorderRadius.circular(8.96),
//             ),
//             child: Icon(
//               CupertinoIcons.chevron_left,
//               size: 20.sp,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Center(
//             child: Text(
//               'Dog Results',
//               style: TextStyle(
//                 fontFamily: 'Sora',
//                 fontWeight: FontWeight.w300,
//                 fontSize: 29.75.w,
//                 height: 1.0,
//                 letterSpacing: 0.0,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatBreedName(String name) {
//     return name
//         .replaceAll('-', ' ')
//         .split(' ')
//         .map((word) => word[0].toUpperCase() + word.substring(1))
//         .join(' ');
//   }
//
//   void _goBack() {
//     Navigator.pop(context);
//   }
//
//   void _tryAgain() {
//     if (_imageBytes != null) {
//       widget.viewModel.predictImage(_imageBytes!);
//     }
//   }
//
//   // Manual save method (for button press)
//   Future<void> _manualSaveResults(DogValuesViewModel viewModel) async {
//     if (viewModel.predictionResult == null) return;
//
//     setState(() {
//       _isSaving = true;
//     });
//
//     try {
//       final result = viewModel.predictionResult!;
//       final imageBytes = viewModel.imageBytes ?? _imageBytes;
//
//       if (imageBytes == null) {
//         _showSnackbar('No image data', Colors.red);
//         return;
//       }
//
//       // Get breed info
//       final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
//
//       // Prepare characteristics
//       final Map<String, dynamic> characteristics = {
//         'size': result.size,
//         'weight': result.weight,
//         'height': result.height,
//         'coat': result.coat,
//         'color': result.color,
//         'headFace': result.headFace,
//         'body': result.body,
//         'purpose': result.purpose,
//         'shape': result.shape,
//         'age': result.age,
//         'gender': result.gender,
//       };
//
//       // Add temperament
//       if (result.temperament.isNotEmpty) {
//         characteristics['temperament'] = result.temperament;
//       }
//
//       // Enrich with database info
//       if (breedInfo != null) {
//         characteristics.addAll({
//           'size': breedInfo['size'] as String? ?? result.size,
//           'weight': breedInfo['weight'] as String? ?? result.weight,
//           'height': breedInfo['height'] as String? ?? result.height,
//           'age': breedInfo['age'] as String? ?? result.age,
//           'coat': breedInfo['coat'] as String? ?? result.coat,
//           'color': breedInfo['color'] as String? ?? result.color,
//           'headFace': breedInfo['headFace'] as String? ?? result.headFace,
//           'body': breedInfo['body'] as String? ?? result.body,
//           'purpose': breedInfo['purpose'] as String? ?? result.purpose,
//         });
//
//         if (breedInfo['temperament'] is Map) {
//           try {
//             final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
//             characteristics['temperament'] = {
//               ...result.temperament,
//               ...temperament,
//             };
//           } catch (e) {
//             if (kDebugMode) print('Error parsing temperament: $e');
//           }
//         }
//       }
//
//       // Prepare scan data
//       final resultData = {
//         'id': DateTime.now().millisecondsSinceEpoch.toString(),
//         'imageBytes': imageBytes,
//         'breedName': result.breed,
//         'formattedBreedName': _formatBreedName(result.breed),
//         'confidence': result.confidence,
//         'timestamp': DateTime.now().toIso8601String(),
//         'isFavorite': false,
//         'isAutoSaved': false, // Manual save
//         'characteristics': characteristics,
//         'size': characteristics['size'],
//         'weight': characteristics['weight'],
//         'height': characteristics['height'],
//         'age': characteristics['age'],
//         'coat': characteristics['coat'],
//         'color': characteristics['color'],
//         'headFace': characteristics['headFace'],
//         'body': characteristics['body'],
//         'purpose': characteristics['purpose'],
//         'temperament': characteristics['temperament'],
//       };
//
//       // Save to ScanProvider
//       final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//       await scanProvider.addScan(resultData);
//
//       // Mark as saved
//       setState(() {
//         _isAutoSaved = true;
//       });
//
//       // Show success message
//       String message;
//       Color color;
//
//       if (breedInfo != null) {
//         message = '${_formatBreedName(result.breed)} saved with complete breed information! ✅';
//         color = Colors.green;
//       } else {
//         message = '${_formatBreedName(result.breed)} saved with basic information';
//         color = Colors.orange;
//       }
//
//       _showSnackbar(message, color);
//
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       if (mounted) {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           RoutesName.dashboard,
//               (route) => false,
//         );
//       }
//     } catch (e, stackTrace) {
//       if (kDebugMode) {
//         print('Save error: $e');
//         print('Stack trace: $stackTrace');
//       }
//       _showSnackbar('Failed to save results', Colors.red);
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   void _showSnackbar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'dart:io';
// // import 'dart:typed_data' show Uint8List;
// //
// // import 'package:dog_breed/config/components/roundButton.dart';
// // import 'package:flutter/cupertino.dart' show CupertinoIcons;
// // import 'package:flutter/foundation.dart' show kDebugMode;
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../View_model/DogValuesViewModel.dart';
// // import '../../View_model/ScanProvider.dart';
// // import '../../utils/routes/routes_name.dart';
// //
// // class DogResultScreen extends StatefulWidget {
// //   final File imageFile;
// //
// //   const DogResultScreen({super.key, required this.imageFile});
// //
// //   @override
// //   State<DogResultScreen> createState() => _DogResultScreenState();
// // }
// //
// // class _DogResultScreenState extends State<DogResultScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider(
// //       create: (_) => DogValuesViewModel(),
// //       child: Consumer<DogValuesViewModel>(
// //         builder: (context, viewModel, child) {
// //           return _DogResultScreenContent(
// //             viewModel: viewModel,
// //             imageFile: widget.imageFile,
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // class _DogResultScreenContent extends StatefulWidget {
// //   final DogValuesViewModel viewModel;
// //   final File imageFile;
// //
// //   const _DogResultScreenContent({
// //     required this.viewModel,
// //     required this.imageFile,
// //   });
// //
// //   @override
// //   State<_DogResultScreenContent> createState() => _DogResultScreenContentState();
// // }
// //
// // class _DogResultScreenContentState extends State<_DogResultScreenContent> {
// //   Uint8List? _imageBytes;
// //   bool _initialized = false;
// //   bool _isSaving = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initialize();
// //   }
// //
// //   Future<void> _initialize() async {
// //     try {
// //       _imageBytes = await widget.imageFile.readAsBytes();
// //
// //       if (_imageBytes != null) {
// //         widget.viewModel.predictImage(_imageBytes!);
// //       }
// //
// //       if (mounted) {
// //         setState(() {
// //           _initialized = true;
// //         });
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print('Initialization error: $e');
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final viewModel = widget.viewModel;
// //
// //     if (!_initialized || viewModel.isLoading) {
// //       return _buildLoadingScreen();
// //     }
// //
// //     if (viewModel.error.isNotEmpty) {
// //       return _buildErrorScreen(viewModel.error);
// //     }
// //
// //     if (!viewModel.isDogDetected) {
// //       return _buildNotDogScreen(viewModel);
// //     }
// //
// //     if (viewModel.predictionResult == null) {
// //       return _buildErrorScreen('No prediction results available');
// //     }
// //
// //     return _buildResultsScreen(viewModel);
// //   }
// //   Widget _buildCharacteristicCard({
// //
// //     String? iconPath,
// //     required String title,
// //     required String value,
// //   }) {
// //     return Container(
// //       height: 55.h,
// //       width: 193.w,
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey[300]!),
// //       ),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           if (iconPath != null)
// //             Padding(
// //               padding: const EdgeInsets.only(right: 10),
// //               child: SvgPicture.asset(
// //                 iconPath,
// //                 width: 32.w,
// //                 height: 32.h,
// //                 fit: BoxFit.contain,
// //                 color: Theme.of(context).colorScheme.tertiary,
// //               ),
// //             ),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 FittedBox(
// //                   fit: BoxFit.scaleDown,
// //                   child: Text(
// //                     title,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       fontWeight: FontWeight.w500,
// //                       color: Theme.of(context).colorScheme.onSurface,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 2.h),
// //                 FittedBox(
// //                   fit: BoxFit.scaleDown,
// //                   child: Text(
// //                     value,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       color: Theme.of(context).colorScheme.tertiary,
// //                     ),
// //                     maxLines: 1,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //   Widget _buildLoadingScreen() {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const CircularProgressIndicator(),
// //               SizedBox(height: 20.h),
// //               Text(
// //                 'Analyzing image...',
// //                 style: TextStyle(fontSize: 16.sp),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildErrorScreen(String error) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 40.h),
// //               Container(
// //                 padding: EdgeInsets.all(24.w),
// //                 decoration: BoxDecoration(
// //                   color: Colors.red[50],
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: Colors.red[200]!),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
// //                     SizedBox(height: 20.h),
// //                     Text(
// //                       'Error Occurred',
// //                       style: TextStyle(
// //                         fontSize: 22.sp,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.red,
// //                       ),
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     Text(
// //                       error,
// //                       style: TextStyle(fontSize: 16.sp, color: Colors.red[800]),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                     SizedBox(height: 24.h),
// //                     RoundButton(
// //                       title: "Go Back",
// //                       height: 50.h,
// //                       borderRadius: 12.r,
// //                       textColors: Colors.white,
// //                       backgroundColors: Colors.red,
// //                       isSelected: true,
// //                       onPress: _goBack,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildNotDogScreen(DogValuesViewModel viewModel) {
// //     return Scaffold(
// //       backgroundColor: Theme.of(context).colorScheme.background,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 40.h),
// //               Container(
// //                 padding: EdgeInsets.all(24.w),
// //                 decoration: BoxDecoration(
// //                   color: Theme.of(context).colorScheme.background,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: Colors.orange[200]!),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Icon(Icons.pets, size: 64.sp, color: Colors.orange),
// //                     SizedBox(height: 20.h),
// //                     Text(
// //                       'No Dog Detected',
// //                       style: TextStyle(
// //                         fontSize: 24.sp,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.orange[800],
// //                       ),
// //                     ),
// //                     SizedBox(height: 12.h),
// //                     Text(
// //                       'Please try with a clearer photo of a dog.',
// //                       style: TextStyle(fontSize: 16.sp, color: Colors.orange[700]),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                     SizedBox(height: 30.h),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: RoundButton(
// //                             title: "Cancel",
// //                             height: 50.h,
// //                             borderRadius: 12.r,
// //                             textColors: Colors.red,
// //                             backgroundColors: Colors.red[50]!,
// //                             isSelected: true,
// //                             onPress: _goBack,
// //                           ),
// //                         ),
// //                         SizedBox(width: 16.w),
// //                         Expanded(
// //                           child: RoundButton(
// //                             title: "Try Again",
// //                             height: 50.h,
// //                             borderRadius: 12.r,
// //                             textColors: Colors.white,
// //                             backgroundColors: Colors.orange,
// //                             isSelected: true,
// //                             onPress: _goBack,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildResultsScreen(DogValuesViewModel viewModel) {
// //     final result = viewModel.predictionResult!;
// //     final imageBytes = viewModel.imageBytes ?? _imageBytes;
// //
// //     return Scaffold(
// //       backgroundColor:Theme.of(context).colorScheme.background,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 25.h),
// //
// //               if (imageBytes != null)
// //                 Container(
// //                   height: 245.h,
// //                   width: double.infinity,
// //                   margin: EdgeInsets.only(bottom: 20.h),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(16),
// //                     image: DecorationImage(
// //                       image: MemoryImage(imageBytes),
// //                       fit: BoxFit.cover,
// //                     ),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.15),
// //                         blurRadius: 15,
// //                         offset: const Offset(0, 6),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       _formatBreedName(result.breed),
// //                       style: TextStyle(
// //                         fontSize: 28.sp,
// //                         fontWeight: FontWeight.bold,
// //                         color:Theme.of(context).colorScheme.onSurface,
// //                         height: 1.2,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ),
// //                   SizedBox(width: 16.w),
// //                   Container(
// //                     width: 100.w,
// //                     height: 100.h,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       gradient: LinearGradient(
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight,
// //                         colors: [
// //                           const Color(0xFF7DFAC4).withOpacity(0.3),
// //                           const Color(0xFF05E51F).withOpacity(0.1),
// //                         ],
// //                       ),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.green.withOpacity(0.2),
// //                           blurRadius: 10,
// //                           spreadRadius: 2,
// //                         ),
// //                       ],
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         "${(result.confidence * 100).toStringAsFixed(0)}%",
// //                         style: TextStyle(
// //                           fontSize: 32.sp,
// //                           fontWeight: FontWeight.bold,
// //                           color: const Color(0xFF05E51F),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 30.h),
// //               GridView.count(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 crossAxisCount: 2,
// //                 crossAxisSpacing: 12.w,
// //                 mainAxisSpacing: 12.h,
// //                 childAspectRatio: 2.6,
// //                 children: [
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/size.svg",
// //                     title: "Size",
// //                     value: result.size,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/shape.svg",
// //                     title: "Shape",
// //                     value: result.shape,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/regular.svg",
// //                     title: "Color",
// //                     value: result.color,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/coat.svg",
// //                     title: "Coat",
// //                     value: result.coat,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/flex_dog.svg",
// //                     title: "Head & Face",
// //                     value: result.headFace,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/akar.svg",
// //                     title: "Purpose",
// //                     value: result.purpose,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/fluent.svg",
// //                     title: "Body",
// //                     value: result.body,
// //                   ),
// //                   _buildCharacteristicCard(
// //                     iconPath: "assets/images/akar.svg",
// //                     title: "Weight",
// //                     value: result.weight,
// //                   ),
// //                 ],
// //               ),
// //
// //               SizedBox(height: 30.h),
// //
// // // ------------------ TEMPERAMENT SECTION ------------------
// //               Text(
// //                 "Temperament & Characteristics",
// //                 style: TextStyle(
// //                   fontSize: 20.sp,
// //                   fontWeight: FontWeight.bold,
// //                   color: Theme.of(context).colorScheme.tertiary,
// //                 ),
// //               ),
// //               SizedBox(height: 16.h),
// //
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildTemperamentCard(
// //                     "Energy Level",
// //                     result.temperament["Energy Level"] ?? "Moderate",
// //                   ),
// //                   SizedBox(height: 12.h),
// //
// //                   _buildTemperamentCard(
// //                     "Trainability",
// //                     result.temperament["Trainability"] ?? "Moderate",
// //                   ),
// //                   SizedBox(height: 12.h),
// //
// //                   _buildTemperamentCard(
// //                     "Social Behavior",
// //                     result.temperament["Social Behavior"] ?? "Friendly",
// //                   ),
// //                   SizedBox(height: 12.h),
// //
// //                   _buildTemperamentCard(
// //                     "Family Compatibility",
// //                     result.temperament["Family Compatibility"] ?? "Good",
// //                   ),
// //                   SizedBox(height: 12.h),
// //
// //                   _buildTemperamentCard(
// //                     "Child Friendliness",
// //                     result.temperament["Child Friendliness"] ?? "Good",
// //                   ),
// //                 ],
// //               ),
// //
// //               SizedBox(height: 30.h),
// //               Container(
// //                 padding: EdgeInsets.symmetric(vertical: 10.h),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: RoundButton(
// //                         title: "Cancel",
// //                         height: 52.h,
// //                         borderRadius: 12.r,
// //                         textColors: const Color(0xFFFF0505),
// //                         backgroundColors: const Color(0xFFFFE5E5),
// //                         isSelected: true,
// //                         onPress: _goBack,
// //                       ),
// //                     ),
// //                     SizedBox(width: 16.w),
// //                     Expanded(
// //                       child: RoundButton(
// //                         title: _isSaving ? "Saving..." : "Save Results",
// //                         height: 52.h,
// //                         borderRadius: 12.r,
// //                         textColors: Colors.white,
// //                         backgroundColors: const Color(0xFF2A2A2A),
// //                         isSelected: true,
// //                         onPress: () => _saveResults(viewModel),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 20.h),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildTemperamentCard(String title, String value) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           title,
// //           style: TextStyle(
// //             fontSize: 13.sp,
// //             fontWeight: FontWeight.w500,
// //             color: const Color(0xFF7E808F),
// //           ),
// //         ),
// //         SizedBox(height: 4.h),
// //         Text(
// //           value,
// //           style: TextStyle(
// //             fontSize: 15.sp,
// //             fontWeight: FontWeight.bold,
// //             color: Theme.of(context).colorScheme.onSurface,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.start,
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         GestureDetector(
// //           onTap: _goBack,
// //           child: Container(
// //             width: 40.305.w,
// //             height: 40.305.h,
// //             padding: const EdgeInsets.all(8.96),
// //             decoration: BoxDecoration(
// //               color: Theme.of(context).colorScheme.background,
// //               borderRadius: BorderRadius.circular(8.96),
// //             ),
// //             child: Icon(
// //               CupertinoIcons.chevron_left,
// //               size: 20.sp,
// //               color: Theme.of(context).colorScheme.onSurface,
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           child: Center(
// //             child: Text(
// //               'Dog Results',
// //               style: TextStyle(
// //                 fontFamily: 'Sora',
// //                 fontWeight: FontWeight.w300,
// //                 fontSize: 29.75.w,
// //                 height: 1.0,
// //                 letterSpacing: 0.0,
// //                 color: Theme.of(context).colorScheme.onSurface,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   String _formatBreedName(String name) {
// //     return name
// //         .replaceAll('-', ' ')
// //         .split(' ')
// //         .map((word) => word[0].toUpperCase() + word.substring(1))
// //         .join(' ');
// //   }
// //
// //   void _goBack() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _tryAgain() {
// //     if (_imageBytes != null) {
// //       widget.viewModel.predictImage(_imageBytes!);
// //     }
// //   }
// //
// //   // Future<void> _saveResults(DogValuesViewModel viewModel) async {
// //   //   if (viewModel.predictionResult == null) return;
// //   //
// //   //   setState(() {
// //   //     _isSaving = true;
// //   //   });
// //   //
// //   //   try {
// //   //     final result = viewModel.predictionResult!;
// //   //     final imageBytes = viewModel.imageBytes ?? _imageBytes;
// //   //
// //   //     if (imageBytes == null) {
// //   //       _showSnackbar('No image data', Colors.red);
// //   //       return;
// //   //     }
// //   //
// //   //     // Get additional breed information from your database
// //   //     final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
// //   //
// //   //     // Prepare characteristics from PredictionResult
// //   //     final Map<String, dynamic> characteristics = {
// //   //       'size': result.size,
// //   //       'weight': result.weight,
// //   //       'height': result.height,
// //   //       'coat': result.coat,
// //   //       'color': result.color,
// //   //       'headFace': result.headFace,
// //   //       'body': result.body,
// //   //       'purpose': result.purpose,
// //   //       'shape': result.shape,
// //   //       'age': result.age,
// //   //       'gender': result.gender,
// //   //     };
// //   //
// //   //     // Add temperament from PredictionResult
// //   //     if (result.temperament.isNotEmpty) {
// //   //       characteristics['temperament'] = result.temperament;
// //   //     }
// //   //
// //   //     // If we have breedInfo from the database, merge it (breedInfo takes priority)
// //   //     if (breedInfo != null) {
// //   //       // Merge breedInfo into characteristics
// //   //       characteristics.addAll({
// //   //         'size': breedInfo['size'] as String? ?? result.size,
// //   //         'weight': breedInfo['weight'] as String? ?? result.weight,
// //   //         'height': breedInfo['height'] as String? ?? result.height,
// //   //         'age': breedInfo['age'] as String? ?? result.age,
// //   //         'coat': breedInfo['coat'] as String? ?? result.coat,
// //   //         'color': breedInfo['color'] as String? ?? result.color,
// //   //         'headFace': breedInfo['headFace'] as String? ?? result.headFace,
// //   //         'body': breedInfo['body'] as String? ?? result.body,
// //   //         'purpose': breedInfo['purpose'] as String? ?? result.purpose,
// //   //       });
// //   //
// //   //       // Add temperament from breedInfo if available
// //   //       if (breedInfo['temperament'] is Map) {
// //   //         final temperament = Map<String, String>.from(breedInfo['temperament']);
// //   //         characteristics['temperament'] = {
// //   //           ...result.temperament,
// //   //           ...temperament, // BreedInfo temperament takes priority
// //   //         };
// //   //       }
// //   //     }
// //   //
// //   //     final resultData = {
// //   //       'id': DateTime.now().millisecondsSinceEpoch.toString(),
// //   //       'imageBytes': imageBytes,
// //   //       'breedName': result.breed,
// //   //       'formattedBreedName': _formatBreedName(result.breed),
// //   //       'confidence': result.confidence,
// //   //       'timestamp': DateTime.now().toIso8601String(),
// //   //       'isFavorite': false,
// //   //       'characteristics': characteristics,
// //   //
// //   //       // Also store individual fields for easy access
// //   //       'size': characteristics['size'],
// //   //       'weight': characteristics['weight'],
// //   //       'height': characteristics['height'],
// //   //       'age': characteristics['age'],
// //   //       'coat': characteristics['coat'],
// //   //       'color': characteristics['color'],
// //   //       'headFace': characteristics['headFace'],
// //   //       'body': characteristics['body'],
// //   //       'purpose': characteristics['purpose'],
// //   //       'temperament': characteristics['temperament'],
// //   //     };
// //   //
// //   //     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
// //   //
// //   //     // Save the scan with all data
// //   //     await scanProvider.addScan(resultData);
// //   //
// //   //     // Show success message
// //   //     String message;
// //   //     Color color;
// //   //
// //   //     if (breedInfo != null) {
// //   //       message = '${_formatBreedName(result.breed)} saved with complete breed information! ✅';
// //   //       color = Colors.green;
// //   //     } else {
// //   //       message = '${_formatBreedName(result.breed)} saved with basic information';
// //   //       color = Colors.orange;
// //   //     }
// //   //
// //   //     _showSnackbar(message, color);
// //   //
// //   //     await Future.delayed(const Duration(milliseconds: 800));
// //   //
// //   //     if (mounted) {
// //   //       Navigator.pushNamedAndRemoveUntil(
// //   //         context,
// //   //         RoutesName.dashboard,
// //   //             (route) => false,
// //   //       );
// //   //     }
// //   //   } catch (e, stackTrace) {
// //   //     if (kDebugMode) {
// //   //       print('Save error: $e');
// //   //       print('Stack trace: $stackTrace');
// //   //     }
// //   //     _showSnackbar('Failed to save results', Colors.red);
// //   //   } finally {
// //   //     if (mounted) {
// //   //       setState(() {
// //   //         _isSaving = false;
// //   //       });
// //   //     }
// //   //   }
// //   // }
// //
// //   Future<void> _saveResults(DogValuesViewModel viewModel) async {
// //     // Get the current prediction result
// //     final viewModel = Provider.of<DogValuesViewModel>(context, listen: false);
// //
// //     if (viewModel.predictionResult == null) {
// //       _showSnackbar('No prediction result available', Colors.red);
// //       return;
// //     }
// //
// //     setState(() {
// //       _isSaving = true;
// //     });
// //
// //     try {
// //       final result = viewModel.predictionResult!;
// //       final imageBytes = viewModel.imageBytes ?? _imageBytes;
// //
// //       if (imageBytes == null) {
// //         _showSnackbar('No image data to save', Colors.red);
// //         setState(() => _isSaving = false);
// //         return;
// //       }
// //
// //
// //       final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
// //
// //
// //       final Map<String, dynamic> characteristics = {
// //         'size': result.size,
// //         'weight': result.weight,
// //         'height': result.height,
// //         'coat': result.coat,
// //         'color': result.color,
// //         'headFace': result.headFace,
// //         'body': result.body,
// //         'purpose': result.purpose,
// //         'shape': result.shape,
// //         'age': result.age,
// //         'gender': result.gender,
// //       };
// //
// //       // Add temperament if available
// //       if (result.temperament.isNotEmpty) {
// //         characteristics['temperament'] = result.temperament;
// //       }
// //
// //       // If breedInfo exists in database, enrich the characteristics
// //       if (breedInfo != null) {
// //         // if (kDebugMode) {
// //         //   print('   Enriching with breed data from database');
// //         // }
// //
// //         // Override with database values (they're more complete)
// //         characteristics.addAll({
// //           'size': breedInfo['size'] as String? ?? result.size,
// //           'weight': breedInfo['weight'] as String? ?? result.weight,
// //           'height': breedInfo['height'] as String? ?? result.height,
// //           'age': breedInfo['age'] as String? ?? result.age,
// //           'coat': breedInfo['coat'] as String? ?? result.coat,
// //           'color': breedInfo['color'] as String? ?? result.color,
// //           'headFace': breedInfo['headFace'] as String? ?? result.headFace,
// //           'body': breedInfo['body'] as String? ?? result.body,
// //           'purpose': breedInfo['purpose'] as String? ?? result.purpose,
// //         });
// //
// //         // Add temperament from breedInfo if available
// //         if (breedInfo['temperament'] is Map) {
// //           try {
// //             final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
// //             characteristics['temperament'] = {
// //               // Start with prediction temperament
// //               ...result.temperament,
// //               // Override with database temperament (more complete)
// //               ...temperament,
// //             };
// //           } catch (e) {
// //
// //           }
// //         }
// //       } else {
// //
// //       }
// //
// //       // Create the complete scan data
// //       final resultData = {
// //         'id': DateTime.now().millisecondsSinceEpoch.toString(),
// //         'imageBytes': imageBytes,
// //         'breedName': result.breed,
// //         'formattedBreedName': _formatBreedName(result.breed),
// //         'confidence': result.confidence,
// //         'timestamp': DateTime.now().toIso8601String(),
// //         'isFavorite': false,
// //         'characteristics': characteristics,
// //
// //         // Also store key fields individually for easier access
// //         'size': characteristics['size'],
// //         'weight': characteristics['weight'],
// //         'height': characteristics['height'],
// //         'age': characteristics['age'],
// //         'coat': characteristics['coat'],
// //         'color': characteristics['color'],
// //         'headFace': characteristics['headFace'],
// //         'body': characteristics['body'],
// //         'purpose': characteristics['purpose'],
// //         'temperament': characteristics['temperament'],
// //       };
// //
// //
// //
// //       // Save to ScanProvider
// //       final scanProvider = Provider.of<ScanProvider>(context, listen: false);
// //       await scanProvider.addScan(resultData);
// //
// //
// //
// //       // Show success message
// //       String _;
// //       Color _;
// //
// //       if (breedInfo != null) {
// //
// //       } else {
// //
// //       }
// //
// //       await Future.delayed(const Duration(milliseconds: 800));
// //
// //       if (mounted) {
// //         Navigator.pushNamedAndRemoveUntil(
// //           context,
// //           RoutesName.dashboard,
// //               (route) => false,
// //         );
// //       }
// //
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isSaving = false;
// //         });
// //       }
// //     }
// //   }
// //
// //   void _showSnackbar(String message, Color color) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: color,
// //         duration: const Duration(seconds: 2),
// //       ),
// //     );
// //   }
// // }
// //
