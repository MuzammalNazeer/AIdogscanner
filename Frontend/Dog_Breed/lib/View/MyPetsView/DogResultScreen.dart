

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
import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../utils/routes/routes_name.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

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
      return _buildErrorScreen(AppLocalizations.of(context)!.noPredictionResult);
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
                AppLocalizations.of(context)!.analyzingImage,
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
                      AppLocalizations.of(context)!.errorOccurred,
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
                      title: AppLocalizations.of(context)!.goBack,
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
                      AppLocalizations.of(context)!.noDogDetected,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppLocalizations.of(context)!.clearerPhotoPrompt,
                      style: TextStyle(fontSize: 16.sp, color: Colors.orange[700]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            title: AppLocalizations.of(context)!.cancel,
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
                            title: AppLocalizations.of(context)!.tryAgain,
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
                          AppLocalizations.of(context)!.lowConfidenceWarning(confidence.toStringAsFixed(1)),
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
                        AppLocalizations.of(context)!.savingToRecentScans,
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
                        color: Theme.of(context).colorScheme.onPrimaryContainer
                    ),
                    child: Center(
                      child: Text(
                        "${confidence.toStringAsFixed(0)}%",
                        style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color:const Color(0xFF05E51F)
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
                    title: AppLocalizations.of(context)!.size,
                    value: _getLocalizedSize(result.size),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/shape.svg",
                    title: AppLocalizations.of(context)!.shape,
                    value: _getLocalizedShape(result.shape),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/regular.svg",
                    title: AppLocalizations.of(context)!.color,
                    value: _getLocalizedColor(result.color),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/coat.svg",
                    title: AppLocalizations.of(context)!.coat,
                    value: _getLocalizedCoat(result.coat),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/flex_dog.svg",
                    title: AppLocalizations.of(context)!.headAndFace,
                    value: _getLocalizedHeadFace(result.headFace),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/akar.svg",
                    title: AppLocalizations.of(context)!.purpose,
                    value: _getLocalizedPurpose(result.purpose),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/fluent.svg",
                    title: AppLocalizations.of(context)!.body,
                    value: _getLocalizedBody(result.body),
                  ),
                  _buildCharacteristicCard(
                    iconPath: "assets/images/akar.svg",
                    title: AppLocalizations.of(context)!.weight,
                    value: _getLocalizedWeight(result.weight),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              Text(
                AppLocalizations.of(context)!.temperamentAndCharacteristics,
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
                    AppLocalizations.of(context)!.energyLevel,
                    _getLocalizedTemperamentValue(result.temperament["Energy Level"] ?? "Moderate"),
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    AppLocalizations.of(context)!.trainability,
                    _getLocalizedTemperamentValue(result.temperament["Trainability"] ?? "Moderate"),
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    AppLocalizations.of(context)!.socialBehavior,
                    _getLocalizedTemperamentValue(result.temperament["Social Behavior"] ?? "Friendly"),
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    AppLocalizations.of(context)!.familyCompatibility,
                    _getLocalizedTemperamentValue(result.temperament["Family Compatibility"] ?? "Good"),
                  ),
                  SizedBox(height: 12.h),

                  _buildTemperamentCard(
                    AppLocalizations.of(context)!.childFriendliness,
                    _getLocalizedTemperamentValue(result.temperament["Child Friendliness"] ?? "Good"),
                  ),
                ],
              ),

              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RoundButton(
                        title: AppLocalizations.of(context)!.cancel,
                        height: 58.h,
                        borderRadius: 10.r,
                        textColors: const Color(0xFFFF0505),
                        backgroundColors: const Color(0xFFFFE5E5),
                        isSelected: true,
                        onPress: _goBack,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: RoundButton(
                        title: AppLocalizations.of(context)!.addPet,
                        height: 58.h,
                        borderRadius: 10.r,
                        textColors: Colors.white,
                        backgroundColors: const Color(0xFF820DFF),
                        isSelected: true,
                        onPress: (){
                          Navigator.pushNamed(context, RoutesName.myAdd, arguments: {
                            'scanData': {
                              'imageBytes': imageBytes,
                              'breedName': result.breed,
                            }
                          },);
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
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
                            title: !canSave ? AppLocalizations.of(context)!.cannotSave :
                            _isSaving ? AppLocalizations.of(context)!.saving :
                            (_isAutoSaved ? AppLocalizations.of(context)!.saved : AppLocalizations.of(context)!.save),
                            height: 58.h,
                            borderRadius: 10.r,
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
              AppLocalizations.of(context)!.dogResults,
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

  String _getLocalizedBreedName(String breed) {
    final normalized = breed.replaceAll(' ', '').replaceAll('-', '').toLowerCase();
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

      default: return _formatBreedName(breed);
    }
  }

  String _getLocalizedSize(String size) {
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

  String _getLocalizedTemperamentValue(String value) {
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

  String _getLocalizedShape(String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'well proportioned') return loc.wellProportioned;
    return value;
  }

  String _getLocalizedColor(String value) {
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

  String _getLocalizedCoat(String value) {
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

  String _getLocalizedHeadFace(String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'breed-specific') return loc.breedSpecific;
    return value;
  }

  String _getLocalizedBody(String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'balanced') return loc.balanced;
    return value;
  }

  String _getLocalizedPurpose(String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'companion') return loc.companion;
    return value;
  }

  String _getLocalizedWeight(String value) {
    final loc = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower == 'varies by breed') return loc.variesByBreed;
    return value;
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
        AppLocalizations.of(context)!.cannotSaveConfidence(confidence.toStringAsFixed(1)),
        Colors.orange,
      );
      return;
    }

    if (viewModel.predictionResult == null) {
      _showSnackbar(AppLocalizations.of(context)!.noPredictionResult, Colors.red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final _ = viewModel.predictionResult!;
      final imageBytes = viewModel.imageBytes ?? _imageBytes;

      if (imageBytes == null) {
        _showSnackbar(AppLocalizations.of(context)!.noImageDataToSave, Colors.red);
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
      _showSnackbar(AppLocalizations.of(context)!.failedToSaveResults, Colors.red);
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
      'formattedBreedName': _getLocalizedBreedName(result.breed),
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
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
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
//   bool _canAutoSave = true; // Track if auto-save is allowed
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
//     // Check if we should auto-save (confidence >= 40%)
//     final confidence = viewModel.predictionResult!.confidence * 100;
//     if (confidence >= 40.0 && _canAutoSave) {
//       // Auto-save when results are ready
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!_isAutoSaved && !_isSaving && viewModel.predictionResult != null) {
//           _autoSaveResults();
//         }
//       });
//     }
//
//     return _buildResultsScreen(viewModel);
//   }
//
//   // Check if results meet the criteria for saving
//   bool _shouldSaveResults(DogValuesViewModel viewModel) {
//     if (!viewModel.isDogDetected) {
//       if (kDebugMode) print('❌ Cannot save: Not a dog');
//       return false;
//     }
//
//     if (viewModel.predictionResult == null) {
//       if (kDebugMode) print('❌ Cannot save: No prediction result');
//       return false;
//     }
//
//     final confidence = viewModel.predictionResult!.confidence * 100;
//     if (confidence < 40.0) {
//       if (kDebugMode) print('❌ Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%');
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<void> _autoSaveResults() async {
//     if (_isAutoSaved || _isSaving) return;
//
//     final viewModel = widget.viewModel;
//
//     // Check if we should save
//     if (!_shouldSaveResults(viewModel)) {
//       _canAutoSave = false; // Prevent future auto-save attempts
//       return;
//     }
//
//     final result = viewModel.predictionResult!;
//     final confidence = result.confidence * 100;
//
//     if (kDebugMode) {
//       print('✅ Auto-save conditions met: Dog detected, Confidence: ${confidence.toStringAsFixed(1)}%');
//     }
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
//       // Save logic
//       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: true);
//
//       if (mounted) {
//         setState(() {
//           _isAutoSaved = true;
//           _isSaving = false;
//           _canAutoSave = false; // Prevent further auto-saves
//         });
//       }
//
//       if (kDebugMode) {
//         print('✅ Auto-saved to recent scans: ${result.breed} (${confidence.toStringAsFixed(1)}%)');
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
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 Flexible(
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Theme.of(context).colorScheme.tertiary,
//                       height: 1.5.h
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 // FittedBox(
//                 //   fit: BoxFit.scaleDown,
//                 //   child: Text(
//                 //     value,
//                 //     style: TextStyle(
//                 //       fontSize: 18.sp,
//                 //       color: Theme.of(context).colorScheme.tertiary,
//                 //     ),
//                 //     maxLines: 2,
//                 //
//                 //   ),
//                 // ),
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
//     final confidence = result.confidence * 100;
//     final canSave = _shouldSaveResults(viewModel);
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
//               // Warning for low confidence
//               if (confidence < 40.0)
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
//                   margin: EdgeInsets.only(bottom: 10.h),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(color: Colors.orange[200]!),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.warning, size: 20.sp, color: Colors.orange[800]),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: Text(
//                           'Low confidence (${confidence.toStringAsFixed(1)}%). Results may not be accurate.',
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.orange[800],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
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
//                       color: Theme.of(context).colorScheme.onPrimaryContainer
//                     ),
//                     child: Center(
//                       child: Text(
//                         "${confidence.toStringAsFixed(0)}%",
//                         style: TextStyle(
//                           fontSize: 32.sp,
//                           fontWeight: FontWeight.bold,
//                           color:const Color(0xFF05E51F)
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
//                         height: 58.h,
//                         borderRadius: 47.r,
//                         textColors: const Color(0xFFFF0505),
//                         backgroundColors: const Color(0xFFFFE5E5),
//                         isSelected: true,
//                         onPress: _goBack,
//                       ),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: (!canSave || _isAutoSaved || _isSaving)
//                             ? null
//                             : () {
//                           _manualSaveResults();
//                         },
//                         child: Opacity(
//                           opacity: (!canSave || _isAutoSaved || _isSaving) ? 0.9 : 1.0,
//                           child: RoundButton(
//                             title: !canSave ? "Cannot Save" :
//                             _isSaving ? "Saving..." :
//                             (_isAutoSaved ? "Saved  Recents" : "Save Results"),
//                             height: 58.h,
//                             borderRadius: 47.r,
//                             textColors: Colors.white,
//                             backgroundColors: !canSave ? Colors.black :
//                             _isAutoSaved ? Colors.black : Colors.black,
//                             isSelected: true,
//                             onPress: () {
//                               if (canSave && !_isAutoSaved && !_isSaving) {
//                                 _manualSaveResults();
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//
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
//
//   Future<void> _manualSaveResults() async {
//     // Get viewModel
//     final viewModel = widget.viewModel;
//
//     // Check if we should save
//     if (!_shouldSaveResults(viewModel)) {
//       final confidence = viewModel.predictionResult!.confidence * 100;
//       _showSnackbar(
//         'Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%',
//         Colors.orange,
//       );
//       return;
//     }
//
//     if (viewModel.predictionResult == null) {
//       _showSnackbar('No prediction result available', Colors.red);
//       return;
//     }
//
//     setState(() {
//       _isSaving = true;
//     });
//
//     try {
//       final _ = viewModel.predictionResult!;
//       final imageBytes = viewModel.imageBytes ?? _imageBytes;
//
//       if (imageBytes == null) {
//         _showSnackbar('No image data to save', Colors.red);
//         setState(() => _isSaving = false);
//         return;
//       }
//
//       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: false);
//
//       setState(() {
//         _isAutoSaved = true;
//         _isSaving = false;
//       });
//
//       // // Show success message
//       // final confidence = result.confidence * 100;
//       // _showSnackbar(
//       //   '${_formatBreedName(result.breed)} saved successfully! (${confidence.toStringAsFixed(1)}%) ✅',
//       //   Colors.green,
//       // );
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
//
//     } catch (e) {
//       // if (kDebugMode) {
//       //   print('❌ Manual save error: $e');
//       //   print('Stack trace: $stackTrace');
//       // }
//       _showSnackbar('Failed to save results', Colors.red);
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   // Common save method for both auto and manual save
//   Future<void> _saveDataToProvider(
//       DogValuesViewModel viewModel,
//       Uint8List imageBytes,
//       {bool isAutoSave = false}
//       ) async {
//     final result = viewModel.predictionResult!;
//
//     // Get breed info from database
//     final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
//
//     // Prepare characteristics
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
//     // Add temperament if available
//     if (result.temperament.isNotEmpty) {
//       characteristics['temperament'] = result.temperament;
//     }
//
//     // If breedInfo exists in database, enrich the characteristics
//     if (breedInfo != null) {
//       // Override with database values (they're more complete)
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
//         try {
//           final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
//           characteristics['temperament'] = {
//             ...result.temperament,
//             ...temperament,
//           };
//         } catch (e) {
//           if (kDebugMode) print('Error parsing temperament: $e');
//         }
//       }
//     }
//
//     // Create the complete scan data
//     final resultData = {
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'imageBytes': imageBytes,
//       'breedName': result.breed,
//       'formattedBreedName': _formatBreedName(result.breed),
//       'confidence': result.confidence,
//       'timestamp': DateTime.now().toIso8601String(),
//       'isFavorite': false,
//       'isAutoSaved': isAutoSave,
//       'characteristics': characteristics,
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
//     // Save to ScanProvider
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.addScan(resultData);
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
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
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
//   bool _canAutoSave = true; // Track if auto-save is allowed
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
//     // Check if we should auto-save (confidence >= 40%)
//     final confidence = viewModel.predictionResult!.confidence * 100;
//     if (confidence >= 40.0 && _canAutoSave) {
//       // Auto-save when results are ready
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!_isAutoSaved && !_isSaving && viewModel.predictionResult != null) {
//           _autoSaveResults();
//         }
//       });
//     }
//
//     return _buildResultsScreen(viewModel);
//   }
//
//   // Check if results meet the criteria for saving
//   bool _shouldSaveResults(DogValuesViewModel viewModel) {
//     if (!viewModel.isDogDetected) {
//       if (kDebugMode) print('❌ Cannot save: Not a dog');
//       return false;
//     }
//
//     if (viewModel.predictionResult == null) {
//       if (kDebugMode) print('❌ Cannot save: No prediction result');
//       return false;
//     }
//
//     final confidence = viewModel.predictionResult!.confidence * 100;
//     if (confidence < 40.0) {
//       if (kDebugMode) print('❌ Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%');
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<void> _autoSaveResults() async {
//     if (_isAutoSaved || _isSaving) return;
//
//     final viewModel = widget.viewModel;
//
//     // Check if we should save
//     if (!_shouldSaveResults(viewModel)) {
//       _canAutoSave = false; // Prevent future auto-save attempts
//       return;
//     }
//
//     final result = viewModel.predictionResult!;
//     final confidence = result.confidence * 100;
//
//     if (kDebugMode) {
//       print('✅ Auto-save conditions met: Dog detected, Confidence: ${confidence.toStringAsFixed(1)}%');
//     }
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
//       // Save logic
//       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: true);
//
//       if (mounted) {
//         setState(() {
//           _isAutoSaved = true;
//           _isSaving = false;
//           _canAutoSave = false; // Prevent further auto-saves
//         });
//       }
//
//       if (kDebugMode) {
//         print('✅ Auto-saved to recent scans: ${result.breed} (${confidence.toStringAsFixed(1)}%)');
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
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 Flexible(
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Theme.of(context).colorScheme.tertiary,
//                         height: 1.5.h
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 // FittedBox(
//                 //   fit: BoxFit.scaleDown,
//                 //   child: Text(
//                 //     value,
//                 //     style: TextStyle(
//                 //       fontSize: 18.sp,
//                 //       color: Theme.of(context).colorScheme.tertiary,
//                 //     ),
//                 //     maxLines: 2,
//                 //
//                 //   ),
//                 // ),
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
//     final confidence = result.confidence * 100;
//     final canSave = _shouldSaveResults(viewModel);
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
//               // Warning for low confidence
//               if (confidence < 40.0)
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
//                   margin: EdgeInsets.only(bottom: 10.h),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(color: Colors.orange[200]!),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.warning, size: 20.sp, color: Colors.orange[800]),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: Text(
//                           'Low confidence (${confidence.toStringAsFixed(1)}%). Results may not be accurate.',
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             color: Colors.orange[800],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
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
//                         shape: BoxShape.circle,
//                         color: Theme.of(context).colorScheme.onPrimaryContainer
//                     ),
//                     child: Center(
//                       child: Text(
//                         "${confidence.toStringAsFixed(0)}%",
//                         style: TextStyle(
//                             fontSize: 32.sp,
//                             fontWeight: FontWeight.bold,
//                             color:const Color(0xFF05E51F)
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
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: RoundButton(
//                         title: "Cancel",
//                         height: 58.h,
//                         borderRadius: 10.r,
//                         textColors: const Color(0xFFFF0505),
//                         backgroundColors: const Color(0xFFFFE5E5),
//                         isSelected: true,
//                         onPress: _goBack,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: RoundButton(
//                         title: "+add Pet",
//                         height: 58.h,
//                         borderRadius: 10.r,
//                         textColors: Colors.white,
//                         backgroundColors: const Color(0xFF820DFF),
//                         isSelected: true,
//                         onPress: (){
//                           Navigator.pushNamed(context, RoutesName.addPet);
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: (!canSave || _isAutoSaved || _isSaving)
//                             ? null
//                             : () {
//                           _manualSaveResults();
//                         },
//                         child: Opacity(
//                           opacity: (!canSave || _isAutoSaved || _isSaving) ? 0.9 : 1.0,
//                           child: RoundButton(
//                             title: !canSave ? "Cannot Save" :
//                             _isSaving ? "Saving..." :
//                             (_isAutoSaved ? "Saved " : "Save"),
//                             height: 58.h,
//                             borderRadius: 10.r,
//                             textColors: Colors.white,
//                             backgroundColors: !canSave ? Colors.black :
//                             _isAutoSaved ? Colors.black : Colors.black,
//                             isSelected: true,
//                             onPress: () {
//                               if (canSave && !_isAutoSaved && !_isSaving) {
//                                 _manualSaveResults();
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//
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
//
//   Future<void> _manualSaveResults() async {
//     // Get viewModel
//     final viewModel = widget.viewModel;
//
//     // Check if we should save
//     if (!_shouldSaveResults(viewModel)) {
//       final confidence = viewModel.predictionResult!.confidence * 100;
//       _showSnackbar(
//         'Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%',
//         Colors.orange,
//       );
//       return;
//     }
//
//     if (viewModel.predictionResult == null) {
//       _showSnackbar('No prediction result available', Colors.red);
//       return;
//     }
//
//     setState(() {
//       _isSaving = true;
//     });
//
//     try {
//       final _ = viewModel.predictionResult!;
//       final imageBytes = viewModel.imageBytes ?? _imageBytes;
//
//       if (imageBytes == null) {
//         _showSnackbar('No image data to save', Colors.red);
//         setState(() => _isSaving = false);
//         return;
//       }
//
//       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: false);
//
//       setState(() {
//         _isAutoSaved = true;
//         _isSaving = false;
//       });
//
//       // // Show success message
//       // final confidence = result.confidence * 100;
//       // _showSnackbar(
//       //   '${_formatBreedName(result.breed)} saved successfully! (${confidence.toStringAsFixed(1)}%) ✅',
//       //   Colors.green,
//       // );
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
//
//     } catch (e) {
//       // if (kDebugMode) {
//       //   print('❌ Manual save error: $e');
//       //   print('Stack trace: $stackTrace');
//       // }
//       _showSnackbar('Failed to save results', Colors.red);
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   // Common save method for both auto and manual save
//   Future<void> _saveDataToProvider(
//       DogValuesViewModel viewModel,
//       Uint8List imageBytes,
//       {bool isAutoSave = false}
//       ) async {
//     final result = viewModel.predictionResult!;
//
//     // Get breed info from database
//     final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
//
//     // Prepare characteristics
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
//     // Add temperament if available
//     if (result.temperament.isNotEmpty) {
//       characteristics['temperament'] = result.temperament;
//     }
//
//     // If breedInfo exists in database, enrich the characteristics
//     if (breedInfo != null) {
//       // Override with database values (they're more complete)
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
//         try {
//           final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
//           characteristics['temperament'] = {
//             ...result.temperament,
//             ...temperament,
//           };
//         } catch (e) {
//           if (kDebugMode) print('Error parsing temperament: $e');
//         }
//       }
//     }
//
//     // Create the complete scan data
//     final resultData = {
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'imageBytes': imageBytes,
//       'breedName': result.breed,
//       'formattedBreedName': _formatBreedName(result.breed),
//       'confidence': result.confidence,
//       'timestamp': DateTime.now().toIso8601String(),
//       'isFavorite': false,
//       'isAutoSaved': isAutoSave,
//       'characteristics': characteristics,
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
//     // Save to ScanProvider
//     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//     await scanProvider.addScan(resultData);
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
// // import '../../View_model/PetProvider.dart';
// // import '../../View_model/home/Pet.dart';
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
// //   bool _isAutoSaved = false;
// //   bool _canAutoSave = true; // Track if auto-save is allowed
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
// //     // Check if we should auto-save (confidence >= 40%)
// //     final confidence = viewModel.predictionResult!.confidence * 100;
// //     if (confidence >= 40.0 && _canAutoSave) {
// //       // Auto-save when results are ready
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (!_isAutoSaved && !_isSaving && viewModel.predictionResult != null) {
// //           _autoSaveResults();
// //         }
// //       });
// //     }
// //
// //     return _buildResultsScreen(viewModel);
// //   }
// //
// //   // Check if results meet the criteria for saving
// //   bool _shouldSaveResults(DogValuesViewModel viewModel) {
// //     if (!viewModel.isDogDetected) {
// //       if (kDebugMode) print('❌ Cannot save: Not a dog');
// //       return false;
// //     }
// //
// //     if (viewModel.predictionResult == null) {
// //       if (kDebugMode) print('❌ Cannot save: No prediction result');
// //       return false;
// //     }
// //
// //     final confidence = viewModel.predictionResult!.confidence * 100;
// //     if (confidence < 40.0) {
// //       if (kDebugMode) print('❌ Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%');
// //       return false;
// //     }
// //
// //     return true;
// //   }
// //
// //   Future<void> _autoSaveResults() async {
// //     if (_isAutoSaved || _isSaving) return;
// //
// //     final viewModel = widget.viewModel;
// //
// //     // Check if we should save
// //     if (!_shouldSaveResults(viewModel)) {
// //       _canAutoSave = false; // Prevent future auto-save attempts
// //       return;
// //     }
// //
// //     final result = viewModel.predictionResult!;
// //     final confidence = result.confidence * 100;
// //
// //     if (kDebugMode) {
// //       print('✅ Auto-save conditions met: Dog detected, Confidence: ${confidence.toStringAsFixed(1)}%');
// //     }
// //
// //     try {
// //       setState(() {
// //         _isSaving = true;
// //       });
// //
// //       final imageBytes = viewModel.imageBytes ?? _imageBytes;
// //       if (imageBytes == null) {
// //         return;
// //       }
// //
// //       // Save logic
// //       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: true);
// //
// //       if (mounted) {
// //         setState(() {
// //           _isAutoSaved = true;
// //           _isSaving = false;
// //           _canAutoSave = false; // Prevent further auto-saves
// //         });
// //       }
// //
// //       if (kDebugMode) {
// //         print('✅ Auto-saved to recent scans: ${result.breed} (${confidence.toStringAsFixed(1)}%)');
// //       }
// //
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print('❌ Auto-save error: $e');
// //       }
// //       if (mounted) {
// //         setState(() {
// //           _isSaving = false;
// //         });
// //       }
// //     }
// //   }
// //
// //   Widget _buildCharacteristicCard({
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
// //                 Text(
// //                   title,
// //                   style: TextStyle(
// //                     fontSize: 17.sp,
// //                     fontWeight: FontWeight.w500,
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                   ),
// //                 ),
// //                 Flexible(
// //                   child: Text(
// //                     value,
// //                     style: TextStyle(
// //                       fontSize: 14.sp,
// //                       color: Theme.of(context).colorScheme.tertiary,
// //                       height: 1.5.h
// //                     ),
// //                     maxLines: 3,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //                 // FittedBox(
// //                 //   fit: BoxFit.scaleDown,
// //                 //   child: Text(
// //                 //     value,
// //                 //     style: TextStyle(
// //                 //       fontSize: 18.sp,
// //                 //       color: Theme.of(context).colorScheme.tertiary,
// //                 //     ),
// //                 //     maxLines: 2,
// //                 //
// //                 //   ),
// //                 // ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
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
// //     final confidence = result.confidence * 100;
// //     final canSave = _shouldSaveResults(viewModel);
// //
// //     return Scaffold(
// //       backgroundColor: Theme.of(context).colorScheme.background,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 25.h),
// //
// //               // Warning for low confidence
// //               if (confidence < 40.0)
// //                 Container(
// //                   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
// //                   margin: EdgeInsets.only(bottom: 10.h),
// //                   decoration: BoxDecoration(
// //                     color: Colors.orange[50],
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     border: Border.all(color: Colors.orange[200]!),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.warning, size: 20.sp, color: Colors.orange[800]),
// //                       SizedBox(width: 8.w),
// //                       Expanded(
// //                         child: Text(
// //                           'Low confidence (${confidence.toStringAsFixed(1)}%). Results may not be accurate.',
// //                           style: TextStyle(
// //                             fontSize: 13.sp,
// //                             color: Colors.orange[800],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //               if (_isSaving)
// //                 Container(
// //                   padding: EdgeInsets.symmetric(vertical: 8.h),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       SizedBox(
// //                         width: 20.w,
// //                         height: 20.h,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           valueColor: AlwaysStoppedAnimation<Color>(
// //                             Theme.of(context).primaryColor,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Text(
// //                         'Saving to recent scans...',
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           color: Colors.green,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
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
// //                         color: Theme.of(context).colorScheme.onSurface,
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
// //                       color: Theme.of(context).colorScheme.onPrimaryContainer
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         "${confidence.toStringAsFixed(0)}%",
// //                         style: TextStyle(
// //                           fontSize: 32.sp,
// //                           fontWeight: FontWeight.bold,
// //                           color:const Color(0xFF05E51F)
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
// //                         height: 58.h,
// //                         borderRadius: 47.r,
// //                         textColors: const Color(0xFFFF0505),
// //                         backgroundColors: const Color(0xFFFFE5E5),
// //                         isSelected: true,
// //                         onPress: _goBack,
// //                       ),
// //                     ),
// //                     SizedBox(width: 16.w),
// //                     Expanded(
// //                       child: GestureDetector(
// //                         onTap: (!canSave || _isAutoSaved || _isSaving)
// //                             ? null
// //                             : () {
// //                           _manualSaveResults();
// //                         },
// //                         child: Opacity(
// //                           opacity: (!canSave || _isAutoSaved || _isSaving) ? 0.9 : 1.0,
// //                           child: RoundButton(
// //                             title: !canSave ? "Cannot Save" :
// //                             _isSaving ? "Saving..." :
// //                             (_isAutoSaved ? "Saved  Recents" : "Save Results"),
// //                             height: 58.h,
// //                             borderRadius: 47.r,
// //                             textColors: Colors.white,
// //                             backgroundColors: !canSave ? Colors.black :
// //                             _isAutoSaved ? Colors.black : Colors.black,
// //                             isSelected: true,
// //                             onPress: () {
// //                               if (canSave && !_isAutoSaved && !_isSaving) {
// //                                 _manualSaveResults();
// //                               }
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //
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
// //
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
// //
// //   Future<void> _manualSaveResults() async {
// //     // Get viewModel
// //     final viewModel = widget.viewModel;
// //
// //     // Check if we should save
// //     if (!_shouldSaveResults(viewModel)) {
// //       final confidence = viewModel.predictionResult!.confidence * 100;
// //       _showSnackbar(
// //         'Cannot save: Confidence ${confidence.toStringAsFixed(1)}% < 40%',
// //         Colors.orange,
// //       );
// //       return;
// //     }
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
// //       final _ = viewModel.predictionResult!;
// //       final imageBytes = viewModel.imageBytes ?? _imageBytes;
// //
// //       if (imageBytes == null) {
// //         _showSnackbar('No image data to save', Colors.red);
// //         setState(() => _isSaving = false);
// //         return;
// //       }
// //
// //       await _saveDataToProvider(viewModel, imageBytes, isAutoSave: false);
// //
// //       setState(() {
// //         _isAutoSaved = true;
// //         _isSaving = false;
// //       });
// //
// //       // // Show success message
// //       // final confidence = result.confidence * 100;
// //       // _showSnackbar(
// //       //   '${_formatBreedName(result.breed)} saved successfully! (${confidence.toStringAsFixed(1)}%) ✅',
// //       //   Colors.green,
// //       // );
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
// //     } catch (e) {
// //       // if (kDebugMode) {
// //       //   print('❌ Manual save error: $e');
// //       //   print('Stack trace: $stackTrace');
// //       // }
// //       _showSnackbar('Failed to save results', Colors.red);
// //       if (mounted) {
// //         setState(() {
// //           _isSaving = false;
// //         });
// //       }
// //     }
// //   }
// //
// //   // Common save method for both auto and manual save
// //   Future<void> _saveDataToProvider(
// //       DogValuesViewModel viewModel,
// //       Uint8List imageBytes,
// //       {bool isAutoSave = false}
// //       ) async {
// //     final result = viewModel.predictionResult!;
// //
// //     // Get breed info from database
// //     final breedInfo = viewModel.dogBreeds[result.breed] as Map<String, dynamic>?;
// //
// //     // Prepare characteristics
// //     final Map<String, dynamic> characteristics = {
// //       'size': result.size,
// //       'weight': result.weight,
// //       'height': result.height,
// //       'coat': result.coat,
// //       'color': result.color,
// //       'headFace': result.headFace,
// //       'body': result.body,
// //       'purpose': result.purpose,
// //       'shape': result.shape,
// //       'age': result.age,
// //       'gender': result.gender,
// //     };
// //
// //     // Add temperament if available
// //     if (result.temperament.isNotEmpty) {
// //       characteristics['temperament'] = result.temperament;
// //     }
// //
// //     // If breedInfo exists in database, enrich the characteristics
// //     if (breedInfo != null) {
// //       // Override with database values (they're more complete)
// //       characteristics.addAll({
// //         'size': breedInfo['size'] as String? ?? result.size,
// //         'weight': breedInfo['weight'] as String? ?? result.weight,
// //         'height': breedInfo['height'] as String? ?? result.height,
// //         'age': breedInfo['age'] as String? ?? result.age,
// //         'coat': breedInfo['coat'] as String? ?? result.coat,
// //         'color': breedInfo['color'] as String? ?? result.color,
// //         'headFace': breedInfo['headFace'] as String? ?? result.headFace,
// //         'body': breedInfo['body'] as String? ?? result.body,
// //         'purpose': breedInfo['purpose'] as String? ?? result.purpose,
// //       });
// //
// //       // Add temperament from breedInfo if available
// //       if (breedInfo['temperament'] is Map) {
// //         try {
// //           final temperament = Map<String, String>.from(breedInfo['temperament'] as Map);
// //           characteristics['temperament'] = {
// //             ...result.temperament,
// //             ...temperament,
// //           };
// //         } catch (e) {
// //           if (kDebugMode) print('Error parsing temperament: $e');
// //         }
// //       }
// //     }
// //
// //     // Create the complete scan data
// //     final resultData = {
// //       'id': DateTime.now().millisecondsSinceEpoch.toString(),
// //       'imageBytes': imageBytes,
// //       'breedName': result.breed,
// //       'formattedBreedName': _formatBreedName(result.breed),
// //       'confidence': result.confidence,
// //       'timestamp': DateTime.now().toIso8601String(),
// //       'isFavorite': false,
// //       'isAutoSaved': isAutoSave,
// //       'characteristics': characteristics,
// //       'size': characteristics['size'],
// //       'weight': characteristics['weight'],
// //       'height': characteristics['height'],
// //       'age': characteristics['age'],
// //       'coat': characteristics['coat'],
// //       'color': characteristics['color'],
// //       'headFace': characteristics['headFace'],
// //       'body': characteristics['body'],
// //       'purpose': characteristics['purpose'],
// //       'temperament': characteristics['temperament'],
// //     };
// //
// //     // Save to ScanProvider
// //     final scanProvider = Provider.of<ScanProvider>(context, listen: false);
// //     await scanProvider.addScan(resultData);
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
