
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../View_model/PetProvider.dart';
import '../../View_model/home/Pet.dart';
import '../../config/components/roundButton.dart';

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
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF820DFF),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
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

  @override
  void initState() {
    super.initState();

    // REMOVE DEFAULT VALUES - Let user input them
    // _nameController.text = 'Super Dog';
    // _selectedGender = 'Male';
    // _selectedDate = DateTime(2020, 2, 2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['scanData'] != null) {
        final scanData = args['scanData'] as Map<String, dynamic>;

        setState(() {
          _imageBytes = _parseImageData(scanData['imageBytes']);
          _breedName = _normalizeBreed(scanData['breedName']);
          _isBreedValid = _breedName != null && _breedName!.isNotEmpty && _breedName != 'Unknown Breed';
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
  String _normalizeBreed(String? raw) {
    if (raw == null || raw.isEmpty) return 'Unknown Breed';
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

    if (_breedName == null || _breedName!.isEmpty || _breedName == 'Unknown Breed') {
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
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
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

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pet added successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          color: const Color(0xFFF3F6F3),
                          borderRadius: BorderRadius.circular(8.96),
                        ),
                        child: Icon(CupertinoIcons.chevron_left,
                            size: 20.sp, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add Pet',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 29.75.sp,
                            color: Colors.black,
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
                      color: const Color(0xFFF3F6F3),
                      borderRadius: BorderRadius.circular(27.83),
                      border: Border.all(
                        color: _imageBytes == null ? Colors.grey.shade300 : Colors.transparent,
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
                      color: Colors.grey.withOpacity(0.5),
                      size: 28.r,
                    ),
                  ),
                ),
                SizedBox(height: 23.h),

                // Pet Name Field with validation
                Row(
                  children: [
                    Text(
                      'Pet Name',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: const Color(0xFF6F7D86),
                      ),
                    ),
                    if (!_isNameValid)
                      Text(
                        ' (Required)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Colors.red,
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
                      fillColor: _isNameValid ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      hintText: 'Enter pet name',
                      hintStyle: const TextStyle(color: Colors.grey),
                      errorBorder: !_isNameValid
                          ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.red, width: 1),
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
                      'Breed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: const Color(0xFF6F7D86),
                      ),
                    ),
                    if (!_isBreedValid)
                      Text(
                        ' (Required)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    // You can add a breed selection dialog here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Breed is detected from scan. To change breed, please rescan.'),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: _isBreedValid ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(12.r),
                      border: !_isBreedValid
                          ? Border.all(color: Colors.red, width: 1)
                          : null,
                    ),
                    child: Text(
                      _breedName ?? 'Tap to scan for breed',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        color: _breedName != null && _breedName != 'Unknown Breed'
                            ? const Color(0xFF000000)
                            : Colors.grey,
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
                      'Gender',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: const Color(0xFF6F7D86),
                      ),
                    ),
                    if (!_isGenderValid)
                      Text(
                        ' (Required)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Colors.red,
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
                        fillColor: _isGenderValid ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                        hintText: 'Select gender',
                        errorBorder: !_isGenderValid
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        )
                            : null,
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Select gender',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ..._genders.map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        )).toList(),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _selectedGender = v;
                          if (v != null) _isGenderValid = true;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      validator: (value) {
                        return value == null ? 'Please select gender' : null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 17.h),

                // Birthday Field with validation
                Row(
                  children: [
                    Text(
                      'Birthday',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        color: const Color(0xFF6F7D86),
                      ),
                    ),
                    if (!_isDateValid)
                      Text(
                        ' (Required)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 58.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _isDateValid ? const Color(0xFFF5F5F5) : const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(12.r),
                      border: !_isDateValid
                          ? Border.all(color: Colors.red, width: 1)
                          : Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}'
                              : 'DD-MM-YYYY',
                          style: TextStyle(
                            color: _selectedDate != null ? Colors.black87 : Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: _selectedDate != null ? const Color(0xFF820DFF) : Colors.grey,
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
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.shade100, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Please fill all required fields before saving',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 24.h),

                RoundButton(
                  title: "Save ",
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
//
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
// import '../../config/components/roundButton.dart';
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
//
//   Uint8List? _imageBytes;
//   String? _breedName;
//   String? _selectedGender;
//   DateTime? _selectedDate;
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF820DFF), // Your app's primary color
//               onPrimary: Colors.white,
//             ),
//             dialogBackgroundColor: Colors.white, // White background for dialog
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) setState(() => _selectedDate = picked);
//   }
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _nameController.text = 'Super Dog';
//     _selectedGender = 'Male';
//     _selectedDate = DateTime(2020, 2, 2);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args =
//       ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//
//       if (args != null && args['scanData'] != null) {
//         final scanData = args['scanData'] as Map<String, dynamic>;
//
//         setState(() {
//           _imageBytes = _parseImageData(scanData['imageBytes']);
//           _breedName = _normalizeBreed(scanData['breedName']);
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
//   String _normalizeBreed(String? raw) {
//     if (raw == null || raw.isEmpty) return 'Unknown Breed';
//     return raw
//         .replaceAll('-', ' ')
//         .split(' ')
//         .map((e) => e[0].toUpperCase() + e.substring(1))
//         .join(' ');
//   }
//
//   void _savePet() {
//     if (_nameController.text.isEmpty ||
//         _breedName == null ||
//         _selectedGender == null ||
//         _selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }
//
//     final newPet = Pet(
//       name: _nameController.text,
//       breed: _breedName!,
//       gender: _selectedGender!,
//       birthday: _selectedDate!,
//       imageBytes: _imageBytes,
//     );
//
//     Provider.of<PetProvider>(context, listen: false).addPet(newPet);
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
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
//                           color: const Color(0xFFF3F6F3),
//                           borderRadius: BorderRadius.circular(8.96),
//                         ),
//                         child:  Icon(CupertinoIcons.chevron_left,
//                             size: 20.sp, color: Colors.black),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           'Add Pet',
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
//                   child: Container(
//                     width: 159.w,
//                     height: 159.h,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F6F3),
//                       borderRadius: BorderRadius.circular(27.83),
//                     ),
//                     child: _imageBytes != null
//                         ? ClipRRect(
//                       child: Image.memory(
//                         _imageBytes!,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : Icon(
//                       Icons.pets,
//                       color: Colors.white.withOpacity(0.8),
//                       size: 28.r,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 23.h),
//                 const Text('Pet Name', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF6F7D86))),
//                 SizedBox(height: 4.h),
//                 SizedBox(
//                   height: 58.h,
//                   child: Center(
//                     child: TextField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFFF5F5F5),
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Breed',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 12.sp,
//                     color: const Color(0xFF6F7D86),
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Container(
//                   width: double.infinity,
//                   height: 58.h,
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F5F5),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Text(
//                     _breedName ?? 'Unknown Breed',
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontFamily: 'Inter',
//                       color: const Color(0xFF000000),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 Text('Gender', style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, color: const Color(0xFF6F7D86))),
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
//                             borderRadius: BorderRadius.circular(12.r),
//                             borderSide: BorderSide.none
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
//                       ),
//                       items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
//                       onChanged: (v) => setState(() => _selectedGender = v),
//                       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       dropdownColor: Colors.white,
//                       isExpanded: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 17.h),
//                 const Text('Birthday', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF6F7D86))),
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
//                               color: _selectedDate != null ? Colors.black87 : Colors.grey,
//                               fontSize: 16),
//                         ),
//                         const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
//
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 124.h),
//                 RoundButton(
//                   title: "Save",
//                   height: 50,
//                   width: 379,
//                   backgroundColors: const Color(0xFF820DFF),
//                   isSelected: true,
//                   onPress:_savePet
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
