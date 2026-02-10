
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
              surface: Theme.of(context).cardColor,
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
                GestureDetector(
                  onTap: () {
                    // You can add a breed selection dialog here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.msgBreedDetected),
                      ),
                    );
                  },
                  child: Container(
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
                    child: Text(
                      _breedName ?? AppLocalizations.of(context)!.hintTapToScan,
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
                ),

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
