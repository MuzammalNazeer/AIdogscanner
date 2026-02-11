import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Valid/AppColors.dart';
import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../View_model/home/home_view_model.dart';
import '../../config/components/CommonApp.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';
import '../../l10n/app_localizations.dart';

class Editview extends StatefulWidget {
  final String? petName;
  final String? petId;
  final Uint8List? imageBytes;
  final bool isEditing;

  const Editview({
    super.key,
    this.petName,
    this.petId,
    this.imageBytes,
    this.isEditing = false,
  });

  @override
  State<Editview> createState() => _EditviewState();
}

class _EditviewState extends State<Editview> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;

  late String? _selectedBreed;
  late String? _selectedGender;
  late DateTime? _selectedDate;
  late Uint8List? _selectedImage;

  // Track original breed to detect changes
  String? _originalBreed;
  bool _isDataLoaded = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _breeds = [
    'Affenpinscher',
    'Afghan Hound',
    'African Hunting Dog',
    'Airedale',
    'American Staffordshire Terrier',
    'Appenzeller',
    'Australian Terrier',
    'Basenji',
    'Basset',
    'Beagle',
    'Bedlington Terrier',
    'Bernese Mountain Dog',
    'Black-and-tan Coonhound',
    'Blenheim Spaniel',
    'Bloodhound',
    'Bluetick',
    'Border Collie',
    'Border Terrier',
    'Borzoi',
    'Boston Bull',
    'Bouvier Des Flandres',
    'Boxer',
    'Brabancon Griffon',
    'Briard',
    'Brittany Spaniel',
    'Bull Mastiff',
    'Cairn',
    'Cardigan',
    'Chesapeake Bay Retriever',
    'Chihuahua',
    'Chow',
    'Clumber',
    'Cocker Spaniel',
    'Collie',
    'Curly-coated Retriever',
    'Dandie Dinmont',
    'Dhole',
    'Dingo',
    'Doberman',
    'English Foxhound',
    'English Setter',
    'English Springer',
    'EntleBucher',
    'Eskimo Dog',
    'Flat-coated Retriever',
    'French Bulldog',
    'German Shepherd',
    'German Short-haired Pointer',
    'Giant Schnauzer',
    'Golden Retriever',
    'Gordon Setter',
    'Great Dane',
    'Great Pyrenees',
    'Greater Swiss Mountain Dog',
    'Groenendael',
    'Ibizan Hound',
    'Irish Setter',
    'Irish Terrier',
    'Irish Water Spaniel',
    'Irish Wolfhound',
    'Italian Greyhound',
    'Japanese Spaniel',
    'Keeshond',
    'Kelpie',
    'Kerry Blue Terrier',
    'Komondor',
    'Kuvasz',
    'Labrador Retriever',
    'Lakeland Terrier',
    'Leonberg',
    'Lhasa',
    'Malamute',
    'Malinois',
    'Maltese Dog',
    'Mexican Hairless',
    'Miniature Pinscher',
    'Miniature Poodle',
    'Miniature Schnauzer',
    'Newfoundland',
    'Norfolk Terrier',
    'Norwegian Elkhound',
    'Norwich Terrier',
    'Old English Sheepdog',
    'Otterhound',
    'Papillon',
    'Pekinese',
    'Pembroke',
    'Pomeranian',
    'Pug',
    'Redbone',
    'Rhodesian Ridgeback',
    'Rottweiler',
    'Saint Bernard',
    'Saluki',
    'Samoyed',
    'Schipperke',
    'Scotch Terrier',
    'Scottish Deerhound',
    'Sealyham Terrier',
    'Shetland Sheepdog',
    'Shih-Tzu',
    'Siberian Husky',
    'Silky Terrier',
    'Soft-coated Wheaten Terrier',
    'Staffordshire Bullterrier',
    'Standard Poodle',
    'Standard Schnauzer',
    'Sussex Spaniel',
    'Tibetan Mastiff',
    'Tibetan Terrier',
    'Toy Poodle',
    'Toy Terrier',
    'Vizsla',
    'Walker Hound',
    'Weimaraner',
    'Welsh Springer Spaniel',
    'West Highland White Terrier',
    'Whippet',
    'Wire-haired Fox Terrier',
    'Yorkshire Terrier',
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _nameController = TextEditingController(text: widget.petName ?? '');
    _breedController = TextEditingController();

    // Initialize with widget data
    _selectedImage = widget.imageBytes;

    // Set defaults
    _selectedBreed = 'Affenpinscher';
    _selectedGender = 'Male';
    _selectedDate = DateTime(2020, 2, 2);

    // Set initial breed text
    _breedController.text = _selectedBreed!;
  }

  void _showBreedBottomSheet() {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredBreeds = List.from(_breeds);

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
                  filteredBreeds = List.from(_breeds);
                });
              } else {
                setState(() {
                  filteredBreeds = _breeds
                      .where((breed) =>
                      breed.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              }
            }

            // Initial filter
            filterBreeds(searchController.text);

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.hintSelectBreed,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close, color: Theme.of(context).hintColor),
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
                            controller: searchController,
                            autofocus: true,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.hintSearchBreed,
                              hintStyle: TextStyle(color: Theme.of(context).hintColor),
                              prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  searchController.clear();
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
                            AppLocalizations.of(context)!.noBreedsFound,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.tryDifferentSearch,
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
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: _selectedBreed == breed
                              ? Icon(
                            Icons.check_circle,
                            color: AppColors.vibrantPurple,
                            size: 24.sp,
                          )
                              : null,
                          tileColor: _selectedBreed == breed
                              ? AppColors.vibrantPurple.withOpacity(0.1)
                              : Colors.transparent,
                          onTap: () {
                            // Save breed to TextField and update state
                            setState(() {
                              _selectedBreed = breed;
                              _breedController.text = breed;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),

                  // Cancel Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancelButton,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.isEditing && widget.petId != null && !_isDataLoaded) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      try {
        final pet = petProvider.pets.firstWhere((p) => p.id == widget.petId);

        _nameController.text = pet.name;

        // Handle breed selection
        if (_breeds.contains(pet.breed)) {
          _selectedBreed = pet.breed;
          _breedController.text = pet.breed;
        } else {
          // Clean up breed name
          String normalized = pet.breed;
          if (normalized.contains(' ')) {
            final parts = normalized.split(' ');
            if (parts.length > 1 &&
                parts[0].length > 3 &&
                parts[0].contains(RegExp(r'[0-9]'))) {
              normalized = parts.sublist(1).join(' ');
            }
          }
          normalized = normalized.replaceAll('_', ' ');

          final match = _breeds.firstWhere(
                (b) => b.toLowerCase() == normalized.toLowerCase(),
            orElse: () => '',
          );

          if (match.isNotEmpty) {
            _selectedBreed = match;
            _breedController.text = match;
          } else {
            _breeds.add(pet.breed);
            _breeds.sort();
            _selectedBreed = pet.breed;
            _breedController.text = pet.breed;
          }
        }

        // Handle gender
        if (_genders.contains(pet.gender)) {
          _selectedGender = pet.gender;
        } else {
          _selectedGender = _genders.first;
        }

        _selectedDate = pet.birthday;

        if (_selectedImage == null && pet.imageBytes != null) {
          _selectedImage = pet.imageBytes;
        }

        _originalBreed = _selectedBreed;
        _isDataLoaded = true;

        debugPrint("Loaded pet for editing: ${pet.name}");
      } catch (e) {
        debugPrint("Pet not found for editing: $e");
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? image = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 500,
  //       maxHeight: 500,
  //       imageQuality: 80,
  //     );
  //
  //     if (image != null) {
  //       final bytes = await image.readAsBytes();
  //       setState(() {
  //         _selectedImage = bytes;
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(AppLocalizations.of(context)!.msgImagePickFailed(e))),
  //     );
  //   }
  // }

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
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }


  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add pet",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 24.h),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: Text(
                        "Upload from Gallery",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF007AFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: Text(
                        "Open Camera",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF007AFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: Theme.of(context).colorScheme.secondaryContainer,
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
                        widget.isEditing ? AppLocalizations.of(context)!.editPetTitle : AppLocalizations.of(context)!.addPetTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                          fontSize: 29.75.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Invisible placeholder to balance
                    SizedBox(
                      width: 40.305.w,
                      height: 40.305.h,
                    ),
                  ],
                ),
                SizedBox(height: 23.h),
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 159.w,
                      height: 159.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(27.83),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          _selectedImage!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      )
                          : widget.imageBytes != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          widget.imageBytes!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).hintColor,
                            size: 32,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            AppLocalizations.of(context)!.labelPhoto,
                            style:  TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 23.h),
                Text(
                  AppLocalizations.of(context)!.labelPetName,
                  style:  TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  height: 58.h,
                  child: Center(
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondaryContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Text(
                  AppLocalizations.of(context)!.labelBreed,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(height: 4.h),

                // Breed TextField with Click-to-Select
                GestureDetector(
                  onTap: () async {
                    if (widget.isEditing) {
                      final bool? shouldChange = await showDialog<bool>(
                        context: context,

                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            title: const Text('Change Breed?'),
                            content: const Text(
                                'Are you sure you want to change the breed?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context)!.cancelButton),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Change'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldChange == true) {
                        _showBreedBottomSheet();
                      }
                    } else {
                      _showBreedBottomSheet();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _breedController,
                            enabled: false, // Disable manual typing
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'Select Breed',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).hintColor,
                            size: 32.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 17.h),
                Text(
                  AppLocalizations.of(context)!.labelGender,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Center(
                  child: SizedBox(
                    height: 58.h,
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondaryContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 0,
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16.sp,
                      ),
                      items: _genders
                          .map(
                            (g) => DropdownMenuItem(
                          value: g,
                          child: Text(_getLocalizedGender(context, g)),
                        ),
                      )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      icon:  Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).hintColor,
                        size: 32.sp,
                      ),
                      dropdownColor: Theme.of(context).cardColor,
                      isExpanded: true,
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Text(
                  AppLocalizations.of(context)!.labelDOB,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 58.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}'
                              : 'DD-MM-YYYY',
                          style: TextStyle(
                            color: _selectedDate != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).hintColor,
                            fontSize: 16,
                          ),
                        ),
                         Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 190.h),
                RoundButton(
                  title: widget.isEditing ? AppLocalizations.of(context)!.actionUpdate : AppLocalizations.of(context)!.actionSave,
                  height: 50,
                  width: 379,
                  backgroundColors: AppColors.vibrantPurple,
                  isSelected: true,
                  onPress: () async {
                    if (_nameController.text.isEmpty ||
                        _breedController.text.isEmpty ||
                        _selectedGender == null ||
                        _selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                           backgroundColor: Colors.red,
                          content: Text('Please Fill Pet Name ',style: TextStyle(color: Colors.white),),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }

                    final pet = Pet(
                      name: _nameController.text.trim(),
                      breed: _breedController.text.trim(),
                      gender: _selectedGender!,
                      birthday: _selectedDate!,
                      imageBytes: _selectedImage,
                    );

                    final petProvider = Provider.of<PetProvider>(
                      context,
                      listen: false,
                    );

                    if (widget.isEditing && widget.petId != null) {
                      pet.id = widget.petId!;
                      final success = await petProvider.updatePet(
                        widget.petId!,
                        pet,
                      );
                      if (success) {
                        final homeViewModel = Provider.of<HomeViewModel>(
                          context,
                          listen: false,
                        );
                        homeViewModel.selectedIndex = 1; // Index for Calendar
                        homeViewModel.calendarTabIndex =
                            0; // Index for AddReminderView
                        homeViewModel.setSelectedPetId(pet.id);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.dashboard,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.msgUpdateFailed),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      final success = await petProvider.addPet(pet);
                      if (success) {
                        final homeViewModel = Provider.of<HomeViewModel>(
                          context,
                          listen: false,
                        );
                        homeViewModel.selectedIndex = 1; // Index for Calendar
                        homeViewModel.calendarTabIndex =
                            0; // Index for AddReminderView
                        homeViewModel.setSelectedPetId(pet.id);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.dashboard,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.msgAddFailed),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:typed_data';
//
// import 'package:dog_breed/View_model/home/Pet.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/PetProvider.dart';
//
// class Editview extends StatefulWidget {
//   final String? petName;
//   final String? petId;
//   final Uint8List? imageBytes;
//   final bool isEditing;
//
//   const Editview({
//     super.key,
//     this.petName,
//     this.petId,
//     this.imageBytes,
//     this.isEditing = false,
//   });
//
//   @override
//   State<Editview> createState() => _EditviewState();
// }
//
// class _EditviewState extends State<Editview> {
//   late TextEditingController _nameController;
//   late String? _selectedBreed;
//   late String? _selectedGender;
//   late DateTime? _selectedDate;
//   late Uint8List? _selectedImage;
//
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//   final List<String> _breeds = [
//     'Affenpinscher',
//     'Afghan Hound',
//     'African Hunting Dog',
//     'Airedale',
//     'American Staffordshire Terrier',
//     'Appenzeller',
//     'Australian Terrier',
//     'Basenji',
//     'Basset',
//     'Beagle',
//     'Bedlington Terrier',
//     'Bernese Mountain Dog',
//     'Black-and-tan Coonhound',
//     'Blenheim Spaniel',
//     'Bloodhound',
//     'Bluetick',
//     'Border Collie',
//     'Border Terrier',
//     'Borzoi',
//     'Boston Bull',
//     'Bouvier Des Flandres',
//     'Boxer',
//     'Brabancon Griffon',
//     'Briard',
//     'Brittany Spaniel',
//     'Bull Mastiff',
//     'Cairn',
//     'Cardigan',
//     'Chesapeake Bay Retriever',
//     'Chihuahua',
//     'Chow',
//     'Clumber',
//     'Cocker Spaniel',
//     'Collie',
//     'Curly-coated Retriever',
//     'Dandie Dinmont',
//     'Dhole',
//     'Dingo',
//     'Doberman',
//     'English Foxhound',
//     'English Setter',
//     'English Springer',
//     'EntleBucher',
//     'Eskimo Dog',
//     'Flat-coated Retriever',
//     'French Bulldog',
//     'German Shepherd',
//     'German Short-haired Pointer',
//     'Giant Schnauzer',
//     'Golden Retriever',
//     'Gordon Setter',
//     'Great Dane',
//     'Great Pyrenees',
//     'Greater Swiss Mountain Dog',
//     'Groenendael',
//     'Ibizan Hound',
//     'Irish Setter',
//     'Irish Terrier',
//     'Irish Water Spaniel',
//     'Irish Wolfhound',
//     'Italian Greyhound',
//     'Japanese Spaniel',
//     'Keeshond',
//     'Kelpie',
//     'Kerry Blue Terrier',
//     'Komondor',
//     'Kuvasz',
//     'Labrador Retriever',
//     'Lakeland Terrier',
//     'Leonberg',
//     'Lhasa',
//     'Malamute',
//     'Malinois',
//     'Maltese Dog',
//     'Mexican Hairless',
//     'Miniature Pinscher',
//     'Miniature Poodle',
//     'Miniature Schnauzer',
//     'Newfoundland',
//     'Norfolk Terrier',
//     'Norwegian Elkhound',
//     'Norwich Terrier',
//     'Old English Sheepdog',
//     'Otterhound',
//     'Papillon',
//     'Pekinese',
//     'Pembroke',
//     'Pomeranian',
//     'Pug',
//     'Redbone',
//     'Rhodesian Ridgeback',
//     'Rottweiler',
//     'Saint Bernard',
//     'Saluki',
//     'Samoyed',
//     'Schipperke',
//     'Scotch Terrier',
//     'Scottish Deerhound',
//     'Sealyham Terrier',
//     'Shetland Sheepdog',
//     'Shih-Tzu',
//     'Siberian Husky',
//     'Silky Terrier',
//     'Soft-coated Wheaten Terrier',
//     'Staffordshire Bullterrier',
//     'Standard Poodle',
//     'Standard Schnauzer',
//     'Sussex Spaniel',
//     'Tibetan Mastiff',
//     'Tibetan Terrier',
//     'Toy Poodle',
//     'Toy Terrier',
//     'Vizsla',
//     'Walker Hound',
//     'Weimaraner',
//     'Welsh Springer Spaniel',
//     'West Highland White Terrier',
//     'Whippet',
//     'Wire-haired Fox Terrier',
//     'Yorkshire Terrier',
//   ];
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize with widget data
//     _nameController = TextEditingController(text: widget.petName ?? '');
//     _selectedImage = widget.imageBytes;
//
//     // Set defaults
//     _selectedBreed = 'Affenpinscher';
//     _selectedGender = 'Male';
//     _selectedDate = DateTime(2020, 2, 2);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     // If editing and we have a petId, load complete pet data
//     if (widget.isEditing && widget.petId != null) {
//       final petProvider = Provider.of<PetProvider>(context, listen: false);
//       try {
//         final pet = petProvider.pets.firstWhere((p) => p.id == widget.petId);
//
//         // Update all fields with pet data
//         if (_nameController.text.isEmpty) {
//           _nameController.text = pet.name;
//         }
//
//         // Handle potentially missing breed in the dropdown list
//         if (!_breeds.contains(pet.breed)) {
//           // Check if it's a formatting issue (e.g. "N02085782 Japanese_spaniel")
//           String normalized = pet.breed;
//
//           // Try to clean up the breed name if it looks like "ID Name" or has underscores
//           if (normalized.contains(' ')) {
//             final parts = normalized.split(' ');
//             // If first part is alphanumeric ID (e.g. N02085782), remove it
//             if (parts.length > 1 &&
//                 parts[0].length > 3 &&
//                 parts[0].contains(RegExp(r'[0-9]'))) {
//               normalized = parts.sublist(1).join(' ');
//             }
//           }
//           normalized = normalized.replaceAll('_', ' ');
//
//           // Check if normalized version exists (case-insensitive)
//           final match = _breeds.firstWhere(
//             (b) => b.toLowerCase() == normalized.toLowerCase(),
//             orElse: () => '',
//           );
//
//           if (match.isNotEmpty) {
//             _selectedBreed = match;
//           } else {
//             // If still not found, add the original breed to the list to prevent crash
//             _breeds.add(pet.breed);
//             _breeds.sort();
//             _selectedBreed = pet.breed;
//           }
//         } else {
//           _selectedBreed = pet.breed;
//         }
//
//         // Validate gender
//         if (_genders.contains(pet.gender)) {
//           _selectedGender = pet.gender;
//         } else {
//           _selectedGender = _genders.first;
//         }
//
//         _selectedDate = pet.birthday;
//
//         // Only use widget imageBytes if pet doesn't have one
//         if (_selectedImage == null && pet.imageBytes != null) {
//           _selectedImage = pet.imageBytes;
//         }
//
//         print("Loaded pet for editing: ${pet.name}");
//       } catch (e) {
//         debugPrint("Pet not found for editing: $e");
//       }
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF820DFF),
//               onPrimary: Colors.white,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) setState(() => _selectedDate = picked);
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 500,
//         maxHeight: 500,
//         imageQuality: 80,
//       );
//
//       if (image != null) {
//         final bytes = await image.readAsBytes();
//         setState(() {
//           _selectedImage = bytes;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
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
//                           color: const Color(0xFFF3F6F3),
//                           borderRadius: BorderRadius.circular(8.96),
//                         ),
//                         child: Icon(
//                           CupertinoIcons.chevron_left,
//                           size: 20.sp,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           widget.isEditing ? 'Edit Pet' : 'Add Pet',
//                           style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.w300,
//                             fontSize: 29.75.sp,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 23.h),
//                 Center(
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: Container(
//                       width: 159.w,
//                       height: 159.h,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF3F6F3),
//                         borderRadius: BorderRadius.circular(27.83),
//                       ),
//                       child: _selectedImage != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Image.memory(
//                                 _selectedImage!,
//                                 width: 130,
//                                 height: 130,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : widget.imageBytes != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: Image.memory(
//                                 widget.imageBytes!,
//                                 width: 130,
//                                 height: 130,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : const Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.grey,
//                                   size: 32,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text(
//                                   'Photo',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 23.h),
//                 const Text(
//                   'Pet Name',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12,
//                     color: Color(0xFF6F7D86),
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 SizedBox(
//                   height: 58.h,
//                   child: Center(
//                     child: TextField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFFF5F5F5),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 Text(
//                   'Breed',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12.sp,
//                     color: const Color(0xFF6F7D86),
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Center(
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 58.h,
//                     child: DropdownButtonFormField<String>(
//                       value: _selectedBreed,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFFF5F5F5),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                         ),
//                       ),
//                       items: _breeds
//                           .map(
//                             (b) => DropdownMenuItem(
//                               value: b,
//                               child: Text(
//                                 b,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => _selectedBreed = v),
//                       icon: const Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.grey,
//                       ),
//                       dropdownColor: Colors.white,
//                       isExpanded: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 Text(
//                   'Gender',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12.sp,
//                     color: const Color(0xFF6F7D86),
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Center(
//                   child: SizedBox(
//                     height: 58.h,
//                     child: DropdownButtonFormField<String>(
//                       value: _selectedGender,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFFF5F5F5),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16.w,
//                           vertical: 0,
//                         ),
//                       ),
//                       items: _genders
//                           .map(
//                             (g) => DropdownMenuItem(value: g, child: Text(g)),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => _selectedGender = v),
//                       icon: const Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.grey,
//                       ),
//                       dropdownColor: Colors.white,
//                       isExpanded: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 const Text(
//                   'Birthday',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12,
//                     color: Color(0xFF6F7D86),
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: Container(
//                     height: 58.h,
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _selectedDate != null
//                               ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}'
//                               : 'DD-MM-YYYY',
//                           style: TextStyle(
//                             color: _selectedDate != null
//                                 ? Colors.black87
//                                 : Colors.grey,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const Icon(
//                           Icons.calendar_today,
//                           color: Colors.grey,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 190.h),
//                 RoundButton(
//                   title: widget.isEditing ? "Update" : "Save",
//                   height: 50,
//                   width: 379,
//                   backgroundColors: const Color(0xFF820DFF),
//                   isSelected: true,
//                   onPress: () async {
//                     if (_nameController.text.isEmpty ||
//                         _selectedBreed == null ||
//                         _selectedGender == null ||
//                         _selectedDate == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Please fill all fields')),
//                       );
//                       return;
//                     }
//
//                     final pet = Pet(
//                       name: _nameController.text.trim(),
//                       breed: _selectedBreed!,
//                       gender: _selectedGender!,
//                       birthday: _selectedDate!,
//                       imageBytes: _selectedImage,
//                     );
//
//                     final petProvider = Provider.of<PetProvider>(
//                       context,
//                       listen: false,
//                     );
//
//                     if (widget.isEditing && widget.petId != null) {
//                       // Update existing pet
//                       pet.id = widget.petId!;
//                       final success = await petProvider.updatePet(
//                         widget.petId!,
//                         pet,
//                       );
//                       if (success) {
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   const SnackBar(content: Text('Pet updated successfully!')),
//                         // );
//                         Navigator.pop(context, true);
//                       } else {}
//                     } else {
//                       // Add new pet
//                       final success = await petProvider.addPet(pet);
//                       if (success) {
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   const SnackBar(content: Text('Pet added successfully!')),
//                         // );
//                         Navigator.pop(context, true);
//                       } else {
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   const SnackBar(content: Text('Failed to add pet')),
//                         // );
//                       }
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
