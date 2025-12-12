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

    return _buildResultsScreen(viewModel);
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
        color: const Color(0xFFCFBAE9),
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
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101010),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF820DFF),
                    ),
                    maxLines: 1,
                  ),
                ),
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
                  color: Colors.orange[50],
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
                            onPress: _tryAgain,
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 25.h),

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
                        color: Colors.black,
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
                          const Color(0xFF7DFAC4).withOpacity(0.3),
                          const Color(0xFF05E51F).withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${(result.confidence * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF05E51F),
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

// ------------------ TEMPERAMENT SECTION ------------------
              Text(
                "Temperament & Characteristics",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF820DFF),
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
                        height: 52.h,
                        borderRadius: 12.r,
                        textColors: const Color(0xFFFF0505),
                        backgroundColors: const Color(0xFFFFE5E5),
                        isSelected: true,
                        onPress: _goBack,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: RoundButton(
                        title: _isSaving ? "Saving..." : "Save Results",
                        height: 52.h,
                        borderRadius: 12.r,
                        textColors: Colors.white,
                        backgroundColors: const Color(0xFF2A2A2A),
                        isSelected: true,
                        onPress: () => _saveResults(viewModel),
                      ),
                    ),
                  ],
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
            color: Colors.black,
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
              color: const Color(0xFFF3F6F3),
              borderRadius: BorderRadius.circular(8.96),
            ),
            child: Icon(
              CupertinoIcons.chevron_left,
              size: 20.sp,
              color: Colors.black,
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
                color: Colors.black,
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

  void _tryAgain() {
    if (_imageBytes != null) {
      widget.viewModel.predictImage(_imageBytes!);
    }
  }

  // Future<void> _saveResults(DogValuesViewModel viewModel) async {
  //   if (viewModel.predictionResult == null) return;
  //
  //   setState(() {
  //     _isSaving = true;
  //   });
  //
  //   try {
  //     final result = viewModel.predictionResult!;
  //     final imageBytes = viewModel.imageBytes ?? _imageBytes;
  //
  //     if (imageBytes == null) {
  //       _showSnackbar('No image data', Colors.red);
  //       return;
  //     }
  //
  //     // Get additional breed information from your database
  //     final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
  //
  //     // Prepare characteristics from PredictionResult
  //     final Map<String, dynamic> characteristics = {
  //       'size': result.size,
  //       'weight': result.weight,
  //       'height': result.height,
  //       'coat': result.coat,
  //       'color': result.color,
  //       'headFace': result.headFace,
  //       'body': result.body,
  //       'purpose': result.purpose,
  //       'shape': result.shape,
  //       'age': result.age,
  //       'gender': result.gender,
  //     };
  //
  //     // Add temperament from PredictionResult
  //     if (result.temperament.isNotEmpty) {
  //       characteristics['temperament'] = result.temperament;
  //     }
  //
  //     // If we have breedInfo from the database, merge it (breedInfo takes priority)
  //     if (breedInfo != null) {
  //       // Merge breedInfo into characteristics
  //       characteristics.addAll({
  //         'size': breedInfo['size'] as String? ?? result.size,
  //         'weight': breedInfo['weight'] as String? ?? result.weight,
  //         'height': breedInfo['height'] as String? ?? result.height,
  //         'age': breedInfo['age'] as String? ?? result.age,
  //         'coat': breedInfo['coat'] as String? ?? result.coat,
  //         'color': breedInfo['color'] as String? ?? result.color,
  //         'headFace': breedInfo['headFace'] as String? ?? result.headFace,
  //         'body': breedInfo['body'] as String? ?? result.body,
  //         'purpose': breedInfo['purpose'] as String? ?? result.purpose,
  //       });
  //
  //       // Add temperament from breedInfo if available
  //       if (breedInfo['temperament'] is Map) {
  //         final temperament = Map<String, String>.from(breedInfo['temperament']);
  //         characteristics['temperament'] = {
  //           ...result.temperament,
  //           ...temperament, // BreedInfo temperament takes priority
  //         };
  //       }
  //     }
  //
  //     final resultData = {
  //       'id': DateTime.now().millisecondsSinceEpoch.toString(),
  //       'imageBytes': imageBytes,
  //       'breedName': result.breed,
  //       'formattedBreedName': _formatBreedName(result.breed),
  //       'confidence': result.confidence,
  //       'timestamp': DateTime.now().toIso8601String(),
  //       'isFavorite': false,
  //       'characteristics': characteristics,
  //
  //       // Also store individual fields for easy access
  //       'size': characteristics['size'],
  //       'weight': characteristics['weight'],
  //       'height': characteristics['height'],
  //       'age': characteristics['age'],
  //       'coat': characteristics['coat'],
  //       'color': characteristics['color'],
  //       'headFace': characteristics['headFace'],
  //       'body': characteristics['body'],
  //       'purpose': characteristics['purpose'],
  //       'temperament': characteristics['temperament'],
  //     };
  //
  //     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
  //
  //     // Save the scan with all data
  //     await scanProvider.addScan(resultData);
  //
  //     // Show success message
  //     String message;
  //     Color color;
  //
  //     if (breedInfo != null) {
  //       message = '${_formatBreedName(result.breed)} saved with complete breed information! ✅';
  //       color = Colors.green;
  //     } else {
  //       message = '${_formatBreedName(result.breed)} saved with basic information';
  //       color = Colors.orange;
  //     }
  //
  //     _showSnackbar(message, color);
  //
  //     await Future.delayed(const Duration(milliseconds: 800));
  //
  //     if (mounted) {
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         RoutesName.dashboard,
  //             (route) => false,
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print('Save error: $e');
  //       print('Stack trace: $stackTrace');
  //     }
  //     _showSnackbar('Failed to save results', Colors.red);
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isSaving = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _saveResults(DogValuesViewModel viewModel) async {
    // Get the current prediction result
    final viewModel = Provider.of<DogValuesViewModel>(context, listen: false);

    if (viewModel.predictionResult == null) {
      _showSnackbar('No prediction result available', Colors.red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final result = viewModel.predictionResult!;
      final imageBytes = viewModel.imageBytes ?? _imageBytes;

      if (imageBytes == null) {
        _showSnackbar('No image data to save', Colors.red);
        setState(() => _isSaving = false);
        return;
      }


      final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;


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
        // if (kDebugMode) {
        //   print('   Enriching with breed data from database');
        // }

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
              // Start with prediction temperament
              ...result.temperament,
              // Override with database temperament (more complete)
              ...temperament,
            };
          } catch (e) {

          }
        }
      } else {

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
        'characteristics': characteristics,

        // Also store key fields individually for easier access
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



      // Show success message
      String _;
      Color _;

      if (breedInfo != null) {

      } else {

      }

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.dashboard,
              (route) => false,
        );
      }

    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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

