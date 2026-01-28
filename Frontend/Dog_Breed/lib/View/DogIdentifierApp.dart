import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class PredictionResult {
  final String breed;
  final double confidence;
  final String size;
  final String shape;
  final String color;
  final String coat;
  final String headFace;
  final String body;
  final Map<String, String> temperament;
  final String purpose;
  final String gender;
  final String age;
  final String weight;
  final Map<String, dynamic>? metadata;

  PredictionResult({
    required this.breed,
    required this.confidence,
    required this.size,
    required this.shape,
    required this.color,
    required this.coat,
    required this.headFace,
    required this.body,
    required this.temperament,
    required this.purpose,
    required this.gender,
    required this.age,
    required this.weight,
    this.metadata,
  });
}

class DogIdentifierApp extends StatefulWidget {
  const DogIdentifierApp({super.key});

  @override
  State<DogIdentifierApp> createState() => _DogIdentifierAppState();
}

class _DogIdentifierAppState extends State<DogIdentifierApp> {
  File? _image;
  bool _loading = false;
  Map<String, dynamic>? _breedInfo;
  PredictionResult? _predictionResult;
  bool _isOfflineMode = true;
  Interpreter? _interpreter;
  List<String>? _labels;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  void _log(String message, {String type = 'INFO'}) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] [$type] $message';
    debugPrint(logMessage);
  }

  Future<void> _initializeModel() async {
    _log('🚀 Initializing model and labels...');
    await _loadModel();
    await _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      _log('📦 Loading TensorFlow Lite model...');
      _interpreter = await Interpreter.fromAsset('models/dog_identifier.tflite');
      _log('✅ Model loaded successfully');
    } catch (e) {
      _log('❌ Failed to load model: $e', type: 'ERROR');
      setState(() {
        _error = 'Failed to load AI model: $e';
      });
    }
  }

  Future<void> _loadLabels() async {
    try {
      _log('📝 Loading breed labels...');
      final data = await rootBundle.loadString('assets/labels.txt');
      final allLabels = LineSplitter.split(data)
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final uniqueLabels = <String>{};
      final filteredLabels = [
        for (final label in allLabels)
          if (uniqueLabels.add(label)) label
      ];

      setState(() => _labels = filteredLabels);
      _log('✅ Labels loaded successfully! Total: ${filteredLabels.length}');
    } catch (e) {
      _log('❌ Label load failed: $e', type: 'ERROR');
      setState(() {
        _labels = [
          'Affenpinscher', 'Afghan Hound', 'Airedale', 'Akita', 'American Bulldog',
          'Australian Shepherd', 'Beagle', 'Boxer', 'Bulldog', 'Chihuahua',
          'Endebucher Mountain Dog' // Added based on your design
        ];
      });
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
        _predictionResult = null;
        _breedInfo = null;
        _loading = true;
        _error = '';
      });

      if (_isOfflineMode) {
        await _predictOffline(File(picked.path));
      } else {
        await _predictOnline(File(picked.path));
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Image selection failed: $e';
      });
    }
  }

  Future<void> _predictOffline(File imageFile) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (_interpreter == null || _labels == null || _labels!.isEmpty) {
      setState(() {
        _loading = false;
        _error = l10n.errorOfflineModelNotAvailable;
      });
      return;
    }

    try {
      final imageBytes = await imageFile.readAsBytes();
      var decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception('Failed to decode image');

      // Center-crop to square
      final cropSize = decodedImage.width < decodedImage.height
          ? decodedImage.width
          : decodedImage.height;
      final xOffset = ((decodedImage.width - cropSize) / 2).floor();
      final yOffset = ((decodedImage.height - cropSize) / 2).floor();

      // Fixed: copyCrop now takes 5 positional args
      final cropped = img.copyCrop(
        decodedImage,
        xOffset,
        yOffset,
        cropSize,
        cropSize,
      );

      // Resize to 224x224
      const inputSize = 224;
      final resized = img.copyResize(
        cropped,
        width: inputSize,
        height: inputSize,
        interpolation: img.Interpolation.average,
      );

      // Prepare input tensor [1, 224, 224, 3] with normalized values [0.0, 1.0]
      final input = List.generate(1, (_) =>
          List.generate(inputSize, (y) =>
              List.generate(inputSize, (x) {
                final pixel = resized.getPixel(x, y); // Returns int (ABGR packed)

                // Extract channels from packed int (ABGR format in image package)
                final a = (pixel >> 24) & 0xFF;
                final b = (pixel >> 16) & 0xFF;
                final g = (pixel >> 8) & 0xFF;
                final r = pixel & 0xFF;

                // Normalize to [0.0, 1.0]
                return [r / 255.0, g / 255.0, b / 255.0];
              })
          )
      );

      // Prepare output
      final outputTensor = _interpreter!.getOutputTensor(0);
      final outShape = outputTensor.shape;
      final numClasses = outShape.length > 1 ? outShape[1] : outShape[0];
      final output = List.generate(1, (_) => List.filled(numClasses, 0.0));

      // Run inference
      _interpreter!.run(input, output);

      final predictions = output[0];

      // Find top prediction
      int maxIndex = 0;
      double maxConfidence = predictions[0];
      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }

      if (maxIndex >= _labels!.length) {
        throw Exception('Prediction index out of bounds');
      }

      final predictedBreed = _labels![maxIndex];
      await _fetchDogData(predictedBreed);

      setState(() {
        _predictionResult = PredictionResult(
          breed: predictedBreed,
          confidence: maxConfidence.clamp(0.0, 1.0),
          size: _breedInfo?['size'] ?? "Medium",
          shape: _breedInfo?['shape'] ?? "Well Proportioned",
          color: _breedInfo?['color'] ?? "Various",
          coat: _breedInfo?['coat'] ?? "Double Coat",
          headFace: _breedInfo?['headFace'] ?? "Breed-Specific",
          body: _breedInfo?['body'] ?? "Balanced",
          temperament: _breedInfo?['temperament'] != null
              ? Map<String, String>.from(_breedInfo!['temperament'])
              : {
            "Energy Level": "Moderate",
            "Trainability": "Moderate",
            "Social Behavior": "Friendly",
            "Family Compatibility": "Good",
            "Child Friendliness": "Good",
          },
          purpose: _breedInfo?['purpose'] ?? "Companion",
          gender: "Unknown",
          age: "Adult",
          weight: _breedInfo?['weight'] ?? "Varies by Breed",
        );
        _loading = false;
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Offline prediction error: $e\n$stackTrace');
      }
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _loading = false;
          _error = l10n.errorOfflinePredictionFailed(e.toString());
        });
      }
    }
  }


  Future<void> _predictOnline(File image) async {
    try {
      final hasInternet = await _checkInternetConnection();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      
      if (!hasInternet) {
        setState(() {
          _loading = false;
          _error = l10n.errorNoInternet;
          _image = null;
          _predictionResult = null;
        });
        return;
      }

      // For demo purposes, use the same as offline
      await _predictOffline(image);

    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _loading = false;
        _error = l10n.errorOnlinePredictionFailed(e.toString());
        _image = null;
        _predictionResult = null;
      });
    }
  }

  Future<void> _fetchDogData(String breedName) async {
    if (_isOfflineMode && _loading) return;
    setState(() {
      _breedInfo = {
        'size': 'Medium',
        'shape': 'Well Proportioned',
        'color': 'Various',
        'coat': 'Double Coat',
        'headFace': 'Breed-Specific',
        'body': 'Balanced',
        'purpose': 'Companion',
        'weight': 'Varies by Breed',
        'temperament': {
          'Energy Level': 'Moderate',
          'Trainability': 'Moderate',
          'Social Behavior': 'Friendly',
          'Family Compatibility': 'Good',
          'Child Friendliness': 'Good',
        }
      };
    });
  }

  Widget _buildCharacteristicCard(String title, String value) {
    return Container(
      height: 55.h,
      width: 193.w,
      padding: const EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFCFBAE9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style:  TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101010),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style:  TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color:const Color(0xFF820DFF) ,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperamentCard(String trait, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trait,
          style:  TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color:const Color(0xFF7E808F),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000        ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _image != null
          ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(_image!, fit: BoxFit.cover))
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pets,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.selectDogImage,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Loading Widget
  Widget _buildLoadingSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                _isOfflineMode ? Colors.orange : Colors.blue
            ),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            _isOfflineMode
                ? l10n.analyzingWithAI
                : l10n.connectingToServer,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(AppLocalizations l10n) {
    final result = _predictionResult!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Breed name on left
              Expanded(
                child: Text(
                  _getLocalizedBreedName(context, result.breed),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF101010),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Clean white circle with colored text
              Container(
                width: 103.w,
                height: 103.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7DFAC4),
                ),
                child: Center(
                  child: Text(
                    "${(result.confidence * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF05E51F),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildCharacteristicCard(l10n.size, _getLocalizedSize(context, result.size)),
              _buildCharacteristicCard(l10n.shape, _getLocalizedShape(context, result.shape)),
              _buildCharacteristicCard(l10n.color, _getLocalizedColor(context, result.color)),
              _buildCharacteristicCard(l10n.coat, _getLocalizedCoat(context, result.coat)),
              _buildCharacteristicCard(l10n.headAndFace, _getLocalizedHeadFace(context, result.headFace)),
              _buildCharacteristicCard(l10n.body, _getLocalizedBody(context, result.body)),
              _buildCharacteristicCard(l10n.purpose, _getLocalizedPurpose(context, result.purpose)),
              _buildCharacteristicCard(l10n.weight, _getLocalizedWeight(context, result.weight)),
            ],
          ),
          const SizedBox(height: 24),

          // Temperament Section Header
          Text(
            l10n.temperamentAndCharacteristics,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF820DFF),
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: [
              _buildTemperamentCard(l10n.energyLevel, _getLocalizedTemperamentValue(context, result.temperament["Energy Level"] ?? "Moderate")),
              const SizedBox(height: 8),
              _buildTemperamentCard(l10n.trainability, _getLocalizedTemperamentValue(context, result.temperament["Trainability"] ?? "Moderate")),
              const SizedBox(height: 8),
              _buildTemperamentCard(l10n.socialBehavior, _getLocalizedTemperamentValue(context, result.temperament["Social Behavior"] ?? "Friendly")),
              const SizedBox(height: 8),
              _buildTemperamentCard(l10n.familyCompatibility, _getLocalizedTemperamentValue(context, result.temperament["Family Compatibility"] ?? "Good")),
              const SizedBox(height: 8),
              _buildTemperamentCard(l10n.childFriendliness, _getLocalizedTemperamentValue(context, result.temperament["Child Friendliness"] ?? "Good")),
            ],
          ),
          const SizedBox(height: 32),

          // Action Buttons (Exactly as in design)
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                      _predictionResult = null;
                      _breedInfo = null;
                      _error = '';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Add as Pet Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement add as pet functionality
                    _log('Adding ${result.breed} as pet');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(
                    l10n.addAsPet,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Save Results Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save results functionality
                    _log('Saving results for ${result.breed}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.saveResults,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Error Section Widget
  Widget _buildErrorSection(AppLocalizations l10n) {
    if (_error.isEmpty) return Container();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red[800]),
              const SizedBox(width: 8),
              Text(
                l10n.errorOccurred,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _error,
            style: TextStyle(color: Colors.red[700]),
          ),
        ],
      ),
    );
  }

  // Action Buttons Widget
  Widget _buildActionButtons(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Mode indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isOfflineMode ? Colors.orange[100] : Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOfflineMode ? Colors.orange : Colors.blue,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isOfflineMode ? Icons.phone_android : Icons.cloud,
                  color: _isOfflineMode ? Colors.orange[800] : Colors.blue[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _isOfflineMode ? l10n.offlineMode : l10n.onlineMode,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isOfflineMode ? Colors.orange[800] : Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Camera/Gallery buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOfflineMode ? Colors.orange : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt, size: 20),
                    label: Text(l10n.camera),
                    onPressed: _loading ? null : () => _pickImage(ImageSource.camera),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOfflineMode ? Colors.orange : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library, size: 20),
                    label: Text(l10n.gallery),
                    onPressed: _loading ? null : () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.dogIdentifierTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isOfflineMode ? Icons.phone_android : Icons.cloud,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isOfflineMode = !_isOfflineMode;
                _image = null;
                _predictionResult = null;
                _breedInfo = null;
                _error = '';
              });
            },
            tooltip: _isOfflineMode ? l10n.switchToOnline : l10n.switchToOffline,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Image section
              _buildImageSection(l10n),
              const SizedBox(height: 20),

              // Error display
              _buildErrorSection(l10n),

              // Loading section
              if (_loading) _buildLoadingSection(l10n),

              // Results section
              if (_predictionResult != null && _predictionResult!.confidence >= 0.4)
                _buildResultsSection(l10n),

              // Action buttons (only show if not showing results)
              if (_predictionResult == null || _predictionResult!.confidence < 0.4)
                _buildActionButtons(l10n),

              // Labels info
              if (_labels != null && _predictionResult == null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    l10n.totalBreeds(_labels!.length),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  String _getLocalizedBreedName(BuildContext context, String breed) {
    // Normalize: remove spaces, hyphens, and underscores to match localization keys
    final normalized = breed.replaceAll(' ', '').replaceAll('-', '').replaceAll('_', '').toLowerCase();
    final loc = AppLocalizations.of(context)!;

    switch (normalized) {
      case 'affenpinscher': return loc.breedAffenpinscher;
      case 'afghanhound': return loc.breedAfghanHound;
      case 'africanhuntingdog': return loc.breedAfricanHuntingDog;
      case 'airedale': return loc.breedAiredale;
      case 'americanstaffordshireterrier': return loc.breedAmericanStaffordshireTerrier;
      case 'appenzeller': return loc.breedAppenzeller;
      case 'australianterrier': return loc.breedAustralianTerrier;
      case 'basenji': return loc.breedBasenji;
      case 'basset': return loc.breedBasset;
      case 'beagle': return loc.breedBeagle;
      case 'bedlingtonterrier': return loc.breedBedlingtonTerrier;
      case 'bernesemountaindog': return loc.breedBerneseMountainDog;
      case 'blackandtancoonhound': return loc.breedBlackAndTanCoonhound;
      case 'blenheimspaniel': return loc.breedBlenheimSpaniel;
      case 'bloodhound': return loc.breedBloodhound;
      case 'bluetick': return loc.breedBluetick;
      case 'bordercollie': return loc.breedBorderCollie;
      case 'borderterrier': return loc.breedBorderTerrier;
      case 'borzoi': return loc.breedBorzoi;
      case 'bostonbull': return loc.breedBostonBull;
      case 'bouvierdesflandres': return loc.breedBouvierDesFlandres;
      case 'boxer': return loc.breedBoxer;
      case 'brabancongriffon': return loc.breedBrabanconGriffon;
      case 'briard': return loc.breedBriard;
      case 'brittanyspaniel': return loc.breedBrittanySpaniel;
      case 'bullmastiff': return loc.breedBullMastiff;
      case 'cairn': return loc.breedCairn;
      case 'cardigan': return loc.breedCardigan;
      case 'chesapeakebayretriever': return loc.breedChesapeakeBayRetriever;
      case 'chihuahua': return loc.breedChihuahua;
      case 'chow': return loc.breedChow;
      case 'clumber': return loc.breedClumber;
      case 'cockerspaniel': return loc.breedCockerSpaniel;
      case 'collie': return loc.breedCollie;
      case 'curlycoatedretriever': return loc.breedCurlyCoatedRetriever;
      case 'dandiedinmont': return loc.breedDandieDinmont;
      case 'dhole': return loc.breedDhole;
      case 'dingo': return loc.breedDingo;
      case 'doberman': return loc.breedDoberman;
      case 'englishfoxhound': return loc.breedEnglishFoxhound;
      case 'englishsetter': return loc.breedEnglishSetter;
      case 'englishspringer': return loc.breedEnglishSpringer;
      case 'entlebucher': return loc.breedEntleBucher;
      case 'eskimodog': return loc.breedEskimoDog;
      case 'flatcoatedretriever': return loc.breedFlatCoatedRetriever;
      case 'frenchbulldog': return loc.breedFrenchBulldog;
      case 'germanshepherd': return loc.breedGermanShepherd;
      case 'germanshorthairedpointer': return loc.breedGermanShortHairedPointer;
      case 'giantschnauzer': return loc.breedGiantSchnauzer;
      case 'goldenretriever': return loc.breedGoldenRetriever;
      case 'gordonsetter': return loc.breedGordonSetter;
      case 'greatdane': return loc.breedGreatDane;
      case 'greatpyrenees': return loc.breedGreatPyrenees;
      case 'greaterswissmountaindog': return loc.breedGreaterSwissMountainDog;
      case 'groenendael': return loc.breedGroenendael;
      case 'ibizanhound': return loc.breedIbizanHound;
      case 'irishsetter': return loc.breedIrishSetter;
      case 'irishterrier': return loc.breedIrishTerrier;
      case 'irishwaterspaniel': return loc.breedIrishWaterSpaniel;
      case 'irishwolfhound': return loc.breedIrishWolfhound;
      case 'italiangreyhound': return loc.breedItalianGreyhound;
      case 'japanesespaniel': return loc.breedJapaneseSpaniel;
      case 'keeshond': return loc.breedKeeshond;
      case 'kelpie': return loc.breedKelpie;
      case 'kerryblueterrier': return loc.breedKerryBlueTerrier;
      case 'komondor': return loc.breedKomondor;
      case 'kuvasz': return loc.breedKuvasz;
      case 'labradorretriever': return loc.breedLabradorRetriever;
      case 'lakelandterrier': return loc.breedLakelandTerrier;
      case 'leonberg': return loc.breedLeonberg;
      case 'lhasa': return loc.breedLhasa;
      case 'malamute': return loc.breedMalamute;
      case 'malinois': return loc.breedMalinois;
      case 'maltesedog': return loc.breedMalteseDog;
      case 'mexicanhairless': return loc.breedMexicanHairless;
      case 'miniaturepinscher': return loc.breedMiniaturePinscher;
      case 'miniaturepoodle': return loc.breedMiniaturePoodle;
      case 'miniatureschnauzer': return loc.breedMiniatureSchnauzer;
      case 'newfoundland': return loc.breedNewfoundland;
      case 'norfolkterrier': return loc.breedNorfolkTerrier;
      case 'norwegianelkhound': return loc.breedNorwegianElkhound;
      case 'norwichterrier': return loc.breedNorwichTerrier;
      case 'oldenglishsheepdog': return loc.breedOldEnglishSheepdog;
      case 'otterhound': return loc.breedOtterhound;
      case 'papillon': return loc.breedPapillon;
      case 'pekinese': return loc.breedPekinese;
      case 'pembroke': return loc.breedPembroke;
      case 'pomeranian': return loc.breedPomeranian;
      case 'pug': return loc.breedPug;
      case 'redbone': return loc.breedRedbone;
      case 'rhodesianridgeback': return loc.breedRhodesianRidgeback;
      case 'rottweiler': return loc.breedRottweiler;
      case 'saintbernard': return loc.breedSaintBernard;
      case 'saluki': return loc.breedSaluki;
      case 'samoyed': return loc.breedSamoyed;
      case 'schipperke': return loc.breedSchipperke;
      case 'scotchterrier': return loc.breedScotchTerrier;
      case 'scottishdeerhound': return loc.breedScottishDeerhound;
      case 'sealyhamterrier': return loc.breedSealyhamTerrier;
      case 'shetlandsheepdog': return loc.breedShetlandSheepdog;
      case 'shihtzu': return loc.breedShihTzu;
      case 'siberianhusky': return loc.breedSiberianHusky;
      case 'silkyterrier': return loc.breedSilkyTerrier;
      case 'softcoatedwheatenterrier': return loc.breedSoftCoatedWheatenTerrier;
      case 'staffordshirebullterrier': return loc.breedStaffordshireBullterrier;
      case 'standardpoodle': return loc.breedStandardPoodle;
      case 'standardschnauzer': return loc.breedStandardSchnauzer;
      case 'sussexspaniel': return loc.breedSussexSpaniel;
      case 'tibetanmastiff': return loc.breedTibetanMastiff;
      case 'tibetanterrier': return loc.breedTibetanTerrier;
      case 'toypoodle': return loc.breedToyPoodle;
      case 'toyterrier': return loc.breedToyTerrier;
      case 'vizsla': return loc.breedVizsla;
      case 'walkerhound': return loc.breedWalkerHound;
      case 'weimaraner': return loc.breedWeimaraner;
      case 'welshspringerspaniel': return loc.breedWelshSpringerSpaniel;
      case 'westhighlandwhiteterrier': return loc.breedWestHighlandWhiteTerrier;
      case 'whippet': return loc.breedWhippet;
      case 'wirehairedfoxterrier': return loc.breedWireHairedFoxTerrier;
      case 'yorkshireterrier': return loc.breedYorkshireTerrier;
      default: return breed.replaceAll('_', ' ').replaceAll('-', ' ');
    }
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

  String _getLocalizedShape(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'well proportioned') return loc.wellProportioned;
    return value;
  }

  String _getLocalizedColor(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'black') return loc.colorBlack;
    if (lower == 'white') return loc.colorWhite;
    if (lower == 'brown') return loc.colorBrown;
    if (lower == 'red') return loc.colorRed;
    if (lower == 'tan') return loc.colorTan;
    if (lower == 'blue') return loc.colorBlue;
    if (lower == 'gray') return loc.colorGray;
    if (lower == 'fawn') return loc.colorFawn;
    if (lower == 'brindle') return loc.colorBrindle;
    if (lower == 'cream') return loc.colorCream;
    if (lower == 'gold') return loc.colorGold;
    if (lower == 'liver') return loc.colorLiver;
    if (lower == 'tri-color') return loc.colorTriColor;
    if (lower == 'merle') return loc.colorMerle;
    if (lower == 'sable') return loc.colorSable;
    if (lower == 'various') return loc.various;
    return value;
  }

  String _getLocalizedCoat(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'double coat') return loc.doubleCoat;
    if (lower == 'short') return loc.coatShort;
    if (lower == 'long') return loc.coatLong;
    if (lower == 'medium') return loc.coatMedium;
    if (lower == 'wire') return loc.coatWire;
    if (lower == 'silky') return loc.coatSilky;
    if (lower == 'smooth') return loc.coatSmooth;
    if (lower == 'dense') return loc.coatDense;
    if (lower == 'flat') return loc.coatFlat;
    if (lower == 'curly') return loc.coatCurly;
    if (lower == 'wavy') return loc.coatWavy;
    return value;
  }

  String _getLocalizedHeadFace(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'breed-specific') return loc.breedSpecific;
    return value;
  }

  String _getLocalizedBody(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'balanced') return loc.balanced;
    return value;
  }

  String _getLocalizedPurpose(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'companion') return loc.companion;
    return value;
  }

  String _getLocalizedWeight(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'varies by breed') return loc.variesByBreed;
    return value;
  }

  String _getLocalizedAge(BuildContext context, String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'adult') return loc.adult;
    return value;
  }
}
