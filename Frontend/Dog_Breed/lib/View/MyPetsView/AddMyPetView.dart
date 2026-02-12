
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Valid/AppColors.dart';
import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../View_model/home/home_view_model.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';
import '../../l10n/app_localizations.dart';

class Addmypetview extends StatefulWidget {
  const Addmypetview({super.key});

  @override
  State<Addmypetview> createState() => _AddmypetviewState();
}

class _AddmypetviewState extends State<Addmypetview> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _breedSearchController = TextEditingController();
  final TextEditingController _breedManualController = TextEditingController();

  Uint8List? _imageBytes;
  String? _breedName;
  String? _selectedGender;
  DateTime? _selectedDate;

  // Track validation state
  bool _isNameValid = true;
  bool _isGenderValid = true;
  bool _isDateValid = true;
  bool _isBreedValid = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.vibrantPurple,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.secondaryContainer,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).cardColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _isDateValid = true; // Reset validation when date is selected
      });
    }
  }

  final List<String> _genders = ['Male', 'Female', 'Other'];

  String _getLocalizedGender(BuildContext context, String gender) {
    final l10n = AppLocalizations.of(context)!;
    switch (gender) {
      case 'Male':
        return l10n.genderMale;
      case 'Female':
        return l10n.genderFemale;
      case 'Other':
        return l10n.genderOther;
      default:
        return gender;
    }
  }

  @override
  void initState() {
    super.initState();



    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['scanData'] != null) {
        final scanData = args['scanData'] as Map<String, dynamic>;

        setState(() {
          _imageBytes = _parseImageData(scanData['imageBytes']);
          _breedName = _normalizeBreed(context, scanData['breedName']);
          _isBreedValid = _breedName != null && _breedName!.isNotEmpty && _breedName != AppLocalizations.of(context)!.unknownBreed;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedSearchController.dispose();
    _breedManualController.dispose();
    super.dispose();
  }

  /// Handle Uint8List / base64 image
  Uint8List? _parseImageData(dynamic data) {
    if (data == null) return null;
    if (data is Uint8List) return data;
    if (data is String) return base64Decode(data);
    return null;
  }

  /// Format breed name
  String _normalizeBreed(BuildContext context, String? raw) {
    if (raw == null || raw.isEmpty) return AppLocalizations.of(context)!.unknownBreed;
    return raw
        .replaceAll('-', ' ')
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  List<String> _getLocalizedBreeds(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.breedAffenpinscher,
      l10n.breedAfghanHound,
      l10n.breedAfricanHuntingDog,
      l10n.breedAiredale,
      l10n.breedAmericanStaffordshireTerrier,
      l10n.breedAppenzeller,
      l10n.breedAustralianTerrier,
      l10n.breedBasenji,
      l10n.breedBasset,
      l10n.breedBeagle,
      l10n.breedBedlingtonTerrier,
      l10n.breedBerneseMountainDog,
      l10n.breedBlackAndTanCoonhound,
      l10n.breedBlenheimSpaniel,
      l10n.breedBloodhound,
      l10n.breedBluetick,
      l10n.breedBorderCollie,
      l10n.breedBorderTerrier,
      l10n.breedBorzoi,
      l10n.breedBostonBull,
      l10n.breedBouvierDesFlandres,
      l10n.breedBoxer,
      l10n.breedBrabanconGriffon,
      l10n.breedBriard,
      l10n.breedBrittanySpaniel,
      l10n.breedBullMastiff,
      l10n.breedCairn,
      l10n.breedCardigan,
      l10n.breedChesapeakeBayRetriever,
      l10n.breedChihuahua,
      l10n.breedChow,
      l10n.breedClumber,
      l10n.breedCockerSpaniel,
      l10n.breedCollie,
      l10n.breedCurlyCoatedRetriever,
      l10n.breedDandieDinmont,
      l10n.breedDhole,
      l10n.breedDingo,
      l10n.breedDoberman,
      l10n.breedEnglishFoxhound,
      l10n.breedEnglishSetter,
      l10n.breedEnglishSpringer,
      l10n.breedEntleBucher,
      l10n.breedEskimoDog,
      l10n.breedFlatCoatedRetriever,
      l10n.breedFrenchBulldog,
      l10n.breedGermanShepherd,
      l10n.breedGermanShortHairedPointer,
      l10n.breedGiantSchnauzer,
      l10n.breedGoldenRetriever,
      l10n.breedGordonSetter,
      l10n.breedGreatDane,
      l10n.breedGreatPyrenees,
      l10n.breedGreaterSwissMountainDog,
      l10n.breedGroenendael,
      l10n.breedIbizanHound,
      l10n.breedIrishSetter,
      l10n.breedIrishTerrier,
      l10n.breedIrishWaterSpaniel,
      l10n.breedIrishWolfhound,
      l10n.breedItalianGreyhound,
      l10n.breedJapaneseSpaniel,
      l10n.breedKeeshond,
      l10n.breedKelpie,
      l10n.breedKerryBlueTerrier,
      l10n.breedKomondor,
      l10n.breedKuvasz,
      l10n.breedLabradorRetriever,
      l10n.breedLakelandTerrier,
      l10n.breedLeonberg,
      l10n.breedLhasa,
      l10n.breedMalamute,
      l10n.breedMalinois,
      l10n.breedMalteseDog,
      l10n.breedMexicanHairless,
      l10n.breedMiniaturePinscher,
      l10n.breedMiniaturePoodle,
      l10n.breedMiniatureSchnauzer,
      l10n.breedNewfoundland,
      l10n.breedNorfolkTerrier,
      l10n.breedNorwegianElkhound,
      l10n.breedNorwichTerrier,
      l10n.breedOldEnglishSheepdog,
      l10n.breedOtterhound,
      l10n.breedPapillon,
      l10n.breedPekinese,
      l10n.breedPembroke,
      l10n.breedPomeranian,
      l10n.breedPug,
      l10n.breedRedbone,
      l10n.breedRhodesianRidgeback,
      l10n.breedRottweiler,
      l10n.breedSaintBernard,
      l10n.breedSaluki,
      l10n.breedSamoyed,
      l10n.breedSchipperke,
      l10n.breedScotchTerrier,
      l10n.breedScottishDeerhound,
      l10n.breedSealyhamTerrier,
      l10n.breedShetlandSheepdog,
      l10n.breedShihTzu,
      l10n.breedSiberianHusky,
      l10n.breedSilkyTerrier,
      l10n.breedSoftCoatedWheatenTerrier,
      l10n.breedStaffordshireBullterrier,
      l10n.breedStandardPoodle,
      l10n.breedStandardSchnauzer,
      l10n.breedSussexSpaniel,
      l10n.breedTibetanMastiff,
      l10n.breedTibetanTerrier,
      l10n.breedToyPoodle,
      l10n.breedToyTerrier,
      l10n.breedVizsla,
      l10n.breedWalkerHound,
      l10n.breedWeimaraner,
      l10n.breedWelshSpringerSpaniel,
      l10n.breedWestHighlandWhiteTerrier,
      l10n.breedWhippet,
      l10n.breedWireHairedFoxTerrier,
      l10n.breedYorkshireTerrier,
    ];
  }

  void _showBreedBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    List<String> filteredBreeds = _getLocalizedBreeds(context);
    if (_breedSearchController.text.isNotEmpty) {
      filteredBreeds = _getLocalizedBreeds(context)
          .where((breed) => breed.toLowerCase().contains(_breedSearchController.text.toLowerCase()))
          .toList();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filterBreeds(String query) {
              if (query.isEmpty) {
                setState(() {
                  filteredBreeds = _getLocalizedBreeds(context);
                });
              } else {
                setState(() {
                  filteredBreeds = _getLocalizedBreeds(context)
                      .where((breed) =>
                          breed.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              }
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.hintSelectBreed,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close,
                                  color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _breedSearchController,
                            autofocus: true,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: l10n.hintSearchBreed,
                              hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor),
                              prefixIcon: Icon(Icons.search,
                                  color: Theme.of(context).hintColor),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              suffixIcon: _breedSearchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        _breedSearchController.clear();
                                        filterBreeds('');
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: filterBreeds,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filteredBreeds.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60.sp,
                                  color: Theme.of(context).hintColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noBreedsFound,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.tryDifferentSearch,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredBreeds.length,
                            itemBuilder: (context, index) {
                              final breed = filteredBreeds[index];
                              return ListTile(
                                title: Text(
                                  breed,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _breedName = breed;
                                    _isBreedValid = true;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBreedEditDialog() {
    _breedManualController.text = _breedName ?? '';
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            AppLocalizations.of(context)!.labelBreed,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: _breedManualController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.hintSearchBreed,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = _breedManualController.text.trim();
                setState(() {
                  if (value.isEmpty) {
                    _breedName = AppLocalizations.of(context)!.unknownBreed;
                    _isBreedValid = false;
                  } else {
                    _breedName = _normalizeBreed(context, value);
                    _isBreedValid = true;
                  }
                });
                Navigator.pop(ctx);
              },
              child: Text(AppLocalizations.of(context)!.actionSave),
            ),
          ],
        );
      },
    );
  }

  void _savePet() {
    // Validate all fields
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      setState(() => _isNameValid = false);
      isValid = false;
    } else {
      setState(() => _isNameValid = true);
    }

    if (_breedName == null || _breedName!.isEmpty || _breedName == AppLocalizations.of(context)!.unknownBreed) {
      setState(() => _isBreedValid = false);
      isValid = false;
    } else {
      setState(() => _isBreedValid = true);
    }

    if (_selectedGender == null) {
      setState(() => _isGenderValid = false);
      isValid = false;
    } else {
      setState(() => _isGenderValid = true);
    }

    if (_selectedDate == null) {
      setState(() => _isDateValid = false);
      isValid = false;
    } else {
      setState(() => _isDateValid = true);
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorFillRequired),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final newPet = Pet(
      name: _nameController.text.trim(),
      breed: _breedName!,
      gender: _selectedGender!,
      birthday: _selectedDate!,
      imageBytes: _imageBytes,
    );

    Provider.of<PetProvider>(context, listen: false).addPet(newPet);


    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.selectedIndex = 1;
    Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40.305.w,
                        height: 40.305.h,
                        padding: const EdgeInsets.all(8.96),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8.96),
                        ),
                        child: Icon(CupertinoIcons.chevron_left,
                            size: 20.sp, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.addPetTitle,
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 29.75.sp,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 23.h),
                Center(
                  child: Container(
                    width: 159.w,
                    height: 159.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(27.83),
                      border: Border.all(
                        color: _imageBytes == null ? Theme.of(context).colorScheme.outlineVariant : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: _imageBytes != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(27.83),
                      child: Image.memory(
                        _imageBytes!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Icon(
                      Icons.pets,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      size: 28.r,
                    ),
                  ),
                ),
                SizedBox(height: 23.h),

                // Pet Name Field with validation
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.labelPetName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_isNameValid)
                      Text(
                        AppLocalizations.of(context)!.labelRequired,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  height: 58.h,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _isNameValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      hintText: AppLocalizations.of(context)!.hintEnterPetName,
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      errorBorder: !_isNameValid
                          ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() => _isNameValid = true);
                      }
                    },
                  ),
                ),

                SizedBox(height: 16.h),

                // Breed Field with validation
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.labelBreed,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_isBreedValid)
                      Text(
                        AppLocalizations.of(context)!.errorRequired,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  height: 58.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: _isBreedValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12.r),
                    border: !_isBreedValid
                        ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showBreedEditDialog,
                        child: Text(
                          _breedName ?? AppLocalizations.of(context)!.hintSelectBreed,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: _breedName != null && _breedName != AppLocalizations.of(context)!.unknownBreed
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).hintColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _showBreedBottomSheet,
                          child: const Icon(Icons.search))
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: _showBreedBottomSheet,
                //   child: Container(
                //     width: double.infinity,
                //     height: 58.h,
                //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                //     alignment: Alignment.centerLeft,
                //     decoration: BoxDecoration(
                //       color: _isBreedValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
                //       borderRadius: BorderRadius.circular(12.r),
                //       border: !_isBreedValid
                //           ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
                //           : null,
                //     ),
                //     child: Text(
                //       _breedName ?? AppLocalizations.of(context)!.hintSelectBreed,
                //       style: TextStyle(
                //         fontSize: 16.sp,
                //         fontFamily: 'Inter',
                //         color: _breedName != null && _breedName != AppLocalizations.of(context)!.unknownBreed
                //             ? Theme.of(context).colorScheme.onSurface
                //             : Theme.of(context).hintColor,
                //       ),
                //       overflow: TextOverflow.ellipsis,
                //     ),
                //   ),
                // ),

                SizedBox(height: 17.h),

                // Gender Field with validation
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.labelGender,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_isGenderValid)
                      Text(
                        AppLocalizations.of(context)!.labelRequired,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Center(
                  child: SizedBox(
                    height: 58.h,
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _isGenderValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                        hintText: AppLocalizations.of(context)!.hintSelectGender,
                        errorBorder: !_isGenderValid
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
                        )
                            : null,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            AppLocalizations.of(context)!.hintSelectGender,
                            style:  TextStyle(color:Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                        ..._genders.map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(_getLocalizedGender(context, g)),
                        )).toList(),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _selectedGender = v;
                          if (v != null) _isGenderValid = true;
                        });
                      },
                      icon:  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface),
                      dropdownColor: Theme.of(context).cardColor,
                      isExpanded: true,
                      validator: (value) {
                        return value == null ? AppLocalizations.of(context)!.errorSelectGender : null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 17.h),

                // Date Field
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.labelDOB,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_isDateValid)
                      Text(
                        AppLocalizations.of(context)!.labelRequired,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 58.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: _isDateValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12.r),
                      border: !_isDateValid
                          ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}"
                              : "DD/MM/YYYY",
                          style: TextStyle(
                            color: _selectedDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface,
                            fontSize: 16.sp,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: _selectedDate != null ? const Color(0xFF820DFF) : Theme.of(context).hintColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Validation summary
                if (!_isNameValid || !_isBreedValid || !_isGenderValid || !_isDateValid)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.errorFillRequired,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 24.h),
                RoundButton(
                  title: AppLocalizations.of(context)!.actionSave,
                  height: 50,
                  width: 379,
                  backgroundColors: const Color(0xFF820DFF),
                  isSelected: true,
                  onPress: _savePet,
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





//
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../Valid/AppColors.dart';
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
// import '../../View_model/home/home_view_model.dart';
// import '../../config/components/roundButton.dart';
// import '../../utils/routes/routes_name.dart';
// import '../../l10n/app_localizations.dart';
//
// class Addmypetview extends StatefulWidget {
//   const Addmypetview({super.key});
//
//   @override
//   State<Addmypetview> createState() => _AddmypetviewState();
// }
//
// class _AddmypetviewState extends State<Addmypetview> {
//   final TextEditingController _nameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Uint8List? _imageBytes;
//   String? _breedName;
//   String? _selectedGender;
//   DateTime? _selectedDate;
//
//   // Track validation state
//   bool _isNameValid = true;
//   bool _isGenderValid = true;
//   bool _isDateValid = true;
//   bool _isBreedValid = true;
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.vibrantPurple,
//               onPrimary: Colors.white,
//               surface: Theme.of(context).colorScheme.secondaryContainer,
//               onSurface: Theme.of(context).colorScheme.onSurface,
//             ),
//             dialogBackgroundColor: Theme.of(context).cardColor,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _isDateValid = true; // Reset validation when date is selected
//       });
//     }
//   }
//
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//
//   String _getLocalizedGender(BuildContext context, String gender) {
//     final l10n = AppLocalizations.of(context)!;
//     switch (gender) {
//       case 'Male':
//         return l10n.genderMale;
//       case 'Female':
//         return l10n.genderFemale;
//       case 'Other':
//         return l10n.genderOther;
//       default:
//         return gender;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args =
//       ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//
//       if (args != null && args['scanData'] != null) {
//         final scanData = args['scanData'] as Map<String, dynamic>;
//
//         setState(() {
//           _imageBytes = _parseImageData(scanData['imageBytes']);
//           _breedName = _normalizeBreed(context, scanData['breedName']);
//           _isBreedValid = _breedName != null && _breedName!.isNotEmpty && _breedName != AppLocalizations.of(context)!.unknownBreed;
//         });
//       }
//     });
//   }
//
//   /// Handle Uint8List / base64 image
//   Uint8List? _parseImageData(dynamic data) {
//     if (data == null) return null;
//     if (data is Uint8List) return data;
//     if (data is String) return base64Decode(data);
//     return null;
//   }
//
//   /// Format breed name
//   String _normalizeBreed(BuildContext context, String? raw) {
//     if (raw == null || raw.isEmpty) return AppLocalizations.of(context)!.unknownBreed;
//     return raw
//         .replaceAll('-', ' ')
//         .split(' ')
//         .map((e) => e[0].toUpperCase() + e.substring(1))
//         .join(' ');
//   }
//
//   void _savePet() {
//     // Validate all fields
//     bool isValid = true;
//
//     if (_nameController.text.trim().isEmpty) {
//       setState(() => _isNameValid = false);
//       isValid = false;
//     } else {
//       setState(() => _isNameValid = true);
//     }
//
//     if (_breedName == null || _breedName!.isEmpty || _breedName == AppLocalizations.of(context)!.unknownBreed) {
//       setState(() => _isBreedValid = false);
//       isValid = false;
//     } else {
//       setState(() => _isBreedValid = true);
//     }
//
//     if (_selectedGender == null) {
//       setState(() => _isGenderValid = false);
//       isValid = false;
//     } else {
//       setState(() => _isGenderValid = true);
//     }
//
//     if (_selectedDate == null) {
//       setState(() => _isDateValid = false);
//       isValid = false;
//     } else {
//       setState(() => _isDateValid = true);
//     }
//
//     if (!isValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(AppLocalizations.of(context)!.errorFillRequired),
//           backgroundColor: Theme.of(context).colorScheme.error,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     final newPet = Pet(
//       name: _nameController.text.trim(),
//       breed: _breedName!,
//       gender: _selectedGender!,
//       birthday: _selectedDate!,
//       imageBytes: _imageBytes,
//     );
//
//     Provider.of<PetProvider>(context, listen: false).addPet(newPet);
//
//
//     final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
//     homeViewModel.selectedIndex = 1;
//     Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         width: 40.305.w,
//                         height: 40.305.h,
//                         padding: const EdgeInsets.all(8.96),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.surface,
//                           borderRadius: BorderRadius.circular(8.96),
//                         ),
//                         child: Icon(CupertinoIcons.chevron_left,
//                             size: 20.sp, color: Theme.of(context).colorScheme.onSurface),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           AppLocalizations.of(context)!.addPetTitle,
//                           style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.w300,
//                             fontSize: 29.75.sp,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 23.h),
//                 Center(
//                   child: Container(
//                     width: 159.w,
//                     height: 159.h,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(27.83),
//                       border: Border.all(
//                         color: _imageBytes == null ? Theme.of(context).colorScheme.outlineVariant : Colors.transparent,
//                         width: 1,
//                       ),
//                     ),
//                     child: _imageBytes != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(27.83),
//                       child: Image.memory(
//                         _imageBytes!,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : Icon(
//                       Icons.pets,
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//                       size: 28.r,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 23.h),
//
//                 // Pet Name Field with validation
//                 Row(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.labelPetName,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 12.sp,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     if (!_isNameValid)
//                       Text(
//                         AppLocalizations.of(context)!.labelRequired,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 12.sp,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 SizedBox(
//                   height: 58.h,
//                   child: TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: _isNameValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       hintText: AppLocalizations.of(context)!.hintEnterPetName,
//                       hintStyle: TextStyle(color: Theme.of(context).hintColor),
//                       errorBorder: !_isNameValid
//                           ? OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
//                       )
//                           : null,
//                     ),
//                     onChanged: (value) {
//                       if (value.trim().isNotEmpty) {
//                         setState(() => _isNameValid = true);
//                       }
//                     },
//                   ),
//                 ),
//
//                 SizedBox(height: 16.h),
//
//                 // Breed Field with validation
//                 Row(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.labelBreed,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 12.sp,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     if (!_isBreedValid)
//                       Text(
//                         AppLocalizations.of(context)!.errorRequired,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 12.sp,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 GestureDetector(
//                   onTap: () {
//                     // You can add a breed selection dialog here
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(AppLocalizations.of(context)!.msgBreedDetected),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 58.h,
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     alignment: Alignment.centerLeft,
//                     decoration: BoxDecoration(
//                       color: _isBreedValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: !_isBreedValid
//                           ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
//                           : null,
//                     ),
//                     child: Text(
//                       _breedName ?? AppLocalizations.of(context)!.hintTapToScan,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontFamily: 'Inter',
//                         color: _breedName != null && _breedName != AppLocalizations.of(context)!.unknownBreed
//                             ? Theme.of(context).colorScheme.onSurface
//                             : Theme.of(context).hintColor,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 17.h),
//
//                 // Gender Field with validation
//                 Row(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.labelGender,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 12.sp,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     if (!_isGenderValid)
//                       Text(
//                         AppLocalizations.of(context)!.labelRequired,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 12.sp,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 Center(
//                   child: SizedBox(
//                     height: 58.h,
//                     child: DropdownButtonFormField<String>(
//                       value: _selectedGender,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: _isGenderValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
//                         hintText: AppLocalizations.of(context)!.hintSelectGender,
//                         errorBorder: !_isGenderValid
//                             ? OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
//                         )
//                             : null,
//                       ),
//                       items: [
//                         DropdownMenuItem<String>(
//                           value: null,
//                           child: Text(
//                             AppLocalizations.of(context)!.hintSelectGender,
//                             style:  TextStyle(color:Theme.of(context).colorScheme.onSurface),
//                           ),
//                         ),
//                         ..._genders.map((g) => DropdownMenuItem(
//                           value: g,
//                           child: Text(_getLocalizedGender(context, g)),
//                         )).toList(),
//                       ],
//                       onChanged: (v) {
//                         setState(() {
//                           _selectedGender = v;
//                           if (v != null) _isGenderValid = true;
//                         });
//                       },
//                       icon:  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface),
//                       dropdownColor: Theme.of(context).cardColor,
//                       isExpanded: true,
//                       validator: (value) {
//                         return value == null ? AppLocalizations.of(context)!.errorSelectGender : null;
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//
//                 // Date Field
//                 Row(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.labelDOB,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 12.sp,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     if (!_isDateValid)
//                       Text(
//                         AppLocalizations.of(context)!.labelRequired,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 12.sp,
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: Container(
//                     height: 58.h,
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     decoration: BoxDecoration(
//                       color: _isDateValid ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.errorContainer,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: !_isDateValid
//                           ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
//                           : null,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _selectedDate != null
//                               ? "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}"
//                               : "DD/MM/YYYY",
//                           style: TextStyle(
//                             color: _selectedDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                         Icon(
//                           Icons.calendar_today,
//                           color: _selectedDate != null ? const Color(0xFF820DFF) : Theme.of(context).hintColor,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 24.h),
//
//                 // Validation summary
//                 if (!_isNameValid || !_isBreedValid || !_isGenderValid || !_isDateValid)
//                   Container(
//                     padding: EdgeInsets.all(12.w),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.errorContainer,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 16.sp),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             AppLocalizations.of(context)!.errorFillRequired,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.error,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 SizedBox(height: 24.h),
//                 RoundButton(
//                   title: AppLocalizations.of(context)!.actionSave,
//                   height: 50,
//                   width: 379,
//                   backgroundColors: const Color(0xFF820DFF),
//                   isSelected: true,
//                   onPress: _savePet,
//                 ),
//
//                 SizedBox(height: 16.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
