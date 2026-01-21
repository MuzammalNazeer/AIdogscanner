
import 'dart:typed_data';

import 'package:dog_breed/View_model/home/Pet.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../View_model/PetProvider.dart';

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
  late String? _selectedBreed;
  late String? _selectedGender;
  late DateTime? _selectedDate;
  late Uint8List? _selectedImage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  List<String> _breeds = ['Affenpinscher', 'Afghan Hound', 'African Hunting Dog', 'Airedale', 'American Staffordshire Terrier', 'Appenzeller', 'Australian Terrier', 'Basenji', 'Basset', 'Beagle', 'Bedlington Terrier', 'Bernese Mountain Dog', 'Black-and-tan Coonhound', 'Blenheim Spaniel', 'Bloodhound', 'Bluetick', 'Border Collie', 'Border Terrier', 'Borzoi', 'Boston Bull', 'Bouvier Des Flandres', 'Boxer', 'Brabancon Griffon', 'Briard', 'Brittany Spaniel', 'Bull Mastiff', 'Cairn', 'Cardigan', 'Chesapeake Bay Retriever', 'Chihuahua', 'Chow', 'Clumber', 'Cocker Spaniel', 'Collie', 'Curly-coated Retriever', 'Dandie Dinmont', 'Dhole', 'Dingo', 'Doberman', 'English Foxhound', 'English Setter', 'English Springer', 'EntleBucher', 'Eskimo Dog', 'Flat-coated Retriever', 'French Bulldog', 'German Shepherd', 'German Short-haired Pointer', 'Giant Schnauzer', 'Golden Retriever', 'Gordon Setter', 'Great Dane', 'Great Pyrenees', 'Greater Swiss Mountain Dog', 'Groenendael', 'Ibizan Hound', 'Irish Setter', 'Irish Terrier', 'Irish Water Spaniel', 'Irish Wolfhound', 'Italian Greyhound', 'Japanese Spaniel', 'Keeshond', 'Kelpie', 'Kerry Blue Terrier', 'Komondor', 'Kuvasz', 'Labrador Retriever', 'Lakeland Terrier', 'Leonberg', 'Lhasa', 'Malamute', 'Malinois', 'Maltese Dog', 'Mexican Hairless', 'Miniature Pinscher', 'Miniature Poodle', 'Miniature Schnauzer', 'Newfoundland', 'Norfolk Terrier', 'Norwegian Elkhound', 'Norwich Terrier', 'Old English Sheepdog', 'Otterhound', 'Papillon', 'Pekinese', 'Pembroke', 'Pomeranian', 'Pug', 'Redbone', 'Rhodesian Ridgeback', 'Rottweiler', 'Saint Bernard', 'Saluki', 'Samoyed', 'Schipperke', 'Scotch Terrier', 'Scottish Deerhound', 'Sealyham Terrier', 'Shetland Sheepdog', 'Shih-Tzu', 'Siberian Husky', 'Silky Terrier', 'Soft-coated Wheaten Terrier', 'Staffordshire Bullterrier', 'Standard Poodle', 'Standard Schnauzer', 'Sussex Spaniel', 'Tibetan Mastiff', 'Tibetan Terrier', 'Toy Poodle', 'Toy Terrier', 'Vizsla', 'Walker Hound', 'Weimaraner', 'Welsh Springer Spaniel', 'West Highland White Terrier', 'Whippet', 'Wire-haired Fox Terrier', 'Yorkshire Terrier'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize with widget data
    _nameController = TextEditingController(text: widget.petName ?? '');
    _selectedImage = widget.imageBytes;

    // Set defaults
    _selectedBreed = 'Affenpinscher';
    _selectedGender = 'Male';
    _selectedDate = DateTime(2020, 2, 2);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // If editing and we have a petId, load complete pet data
    if (widget.isEditing && widget.petId != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      try {
        final pet = petProvider.pets.firstWhere((p) => p.id == widget.petId);

        // Update all fields with pet data
        if (_nameController.text.isEmpty) {
          _nameController.text = pet.name;
        }

        // Handle potentially missing breed in the dropdown list
        if (!_breeds.contains(pet.breed)) {
          // Check if it's a formatting issue (e.g. "N02085782 Japanese_spaniel")
          String normalized = pet.breed;
          
          // Try to clean up the breed name if it looks like "ID Name" or has underscores
          if (normalized.contains(' ')) {
             final parts = normalized.split(' ');
             // If first part is alphanumeric ID (e.g. N02085782), remove it
             if (parts.length > 1 && parts[0].length > 3 && parts[0].contains(RegExp(r'[0-9]'))) {
                normalized = parts.sublist(1).join(' ');
             }
          }
          normalized = normalized.replaceAll('_', ' ');
          
          // Check if normalized version exists (case-insensitive)
          final match = _breeds.firstWhere(
            (b) => b.toLowerCase() == normalized.toLowerCase(),
            orElse: () => '',
          );
          
          if (match.isNotEmpty) {
            _selectedBreed = match;
          } else {
            // If still not found, add the original breed to the list to prevent crash
            _breeds.add(pet.breed);
            _breeds.sort(); 
            _selectedBreed = pet.breed;
          }
        } else {
          _selectedBreed = pet.breed;
        }

        // Validate gender
        if (_genders.contains(pet.gender)) {
          _selectedGender = pet.gender;
        } else {
          _selectedGender = _genders.first;
        }
        
        _selectedDate = pet.birthday;

        // Only use widget imageBytes if pet doesn't have one
        if (_selectedImage == null && pet.imageBytes != null) {
          _selectedImage = pet.imageBytes;
        }

        print("Loaded pet for editing: ${pet.name}");
      } catch (e) {
        debugPrint("Pet not found for editing: $e");
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                          widget.isEditing ? 'Edit Pet' : 'Add Pet',
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
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 159.w,
                      height: 159.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6F3),
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
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.grey, size: 32),
                          SizedBox(height: 3),
                          Text('Photo', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 23.h),
                const Text(
                  'Pet Name',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF6F7D86)),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  height: 58.h,
                  child: Center(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Text(
                  'Breed',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, color: const Color(0xFF6F7D86)),
                ),
                SizedBox(height: 4.h),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 58.h,
                    child: DropdownButtonFormField<String>(
                      value: _selectedBreed,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: _breeds
                          .map((b) => DropdownMenuItem(
                        value: b,
                        child: Text(
                          b,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBreed = v),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Text(
                  'Gender',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, color: const Color(0xFF6F7D86)),
                ),
                SizedBox(height: 4.h),
                Center(
                  child: SizedBox(
                    height: 58.h,
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      ),
                      items: _genders
                          .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                const Text(
                  'Birthday',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF6F7D86)),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 58.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            color: _selectedDate != null ? Colors.black87 : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 190.h),
                RoundButton(
                  title: widget.isEditing ? "Update" : "Save",
                  height: 50,
                  width: 379,
                  backgroundColors: const Color(0xFF820DFF),
                  isSelected: true,
                  onPress: () async {
                    if (_nameController.text.isEmpty ||
                        _selectedBreed == null ||
                        _selectedGender == null ||
                        _selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    final pet = Pet(
                      name: _nameController.text.trim(),
                      breed: _selectedBreed!,
                      gender: _selectedGender!,
                      birthday: _selectedDate!,
                      imageBytes: _selectedImage,
                    );

                    final petProvider = Provider.of<PetProvider>(context, listen: false);

                    if (widget.isEditing && widget.petId != null) {
                      // Update existing pet
                      pet.id = widget.petId!;
                      final success = await petProvider.updatePet(widget.petId!, pet);
                      if (success) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Pet updated successfully!')),
                        // );
                        Navigator.pop(context, true);
                      } else {

                      }
                    } else {
                      // Add new pet
                      final success = await petProvider.addPet(pet);
                      if (success) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Pet added successfully!')),
                        // );
                        Navigator.pop(context, true);
                      } else {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Failed to add pet')),
                        // );
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
// import 'package:dog_breed/View_model/pet.dart' hide Pet;
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
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
//
//   const Editview({super.key, this.petName, this.petId, this.imageBytes});
//
//   @override
//   State<Editview> createState() => _EditviewState();
// }
//
// class _EditviewState extends State<Editview> {
//   final TextEditingController _nameController = TextEditingController();
//
//   String? _selectedBreed;
//   String? _selectedGender;
//   DateTime? _selectedDate;
//   Uint8List? _selectedImage;
//
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//   List<String> _breeds = ['Affenpinscher', 'Afghan Hound', 'African Hunting Dog', 'Airedale', 'American Staffordshire Terrier', 'Appenzeller', 'Australian Terrier', 'Basenji', 'Basset', 'Beagle', 'Bedlington Terrier', 'Bernese Mountain Dog', 'Black-and-tan Coonhound', 'Blenheim Spaniel', 'Bloodhound', 'Bluetick', 'Border Collie', 'Border Terrier', 'Borzoi', 'Boston Bull', 'Bouvier Des Flandres', 'Boxer', 'Brabancon Griffon', 'Briard', 'Brittany Spaniel', 'Bull Mastiff', 'Cairn', 'Cardigan', 'Chesapeake Bay Retriever', 'Chihuahua', 'Chow', 'Clumber', 'Cocker Spaniel', 'Collie', 'Curly-coated Retriever', 'Dandie Dinmont', 'Dhole', 'Dingo', 'Doberman', 'English Foxhound', 'English Setter', 'English Springer', 'EntleBucher', 'Eskimo Dog', 'Flat-coated Retriever', 'French Bulldog', 'German Shepherd', 'German Short-haired Pointer', 'Giant Schnauzer', 'Golden Retriever', 'Gordon Setter', 'Great Dane', 'Great Pyrenees', 'Greater Swiss Mountain Dog', 'Groenendael', 'Ibizan Hound', 'Irish Setter', 'Irish Terrier', 'Irish Water Spaniel', 'Irish Wolfhound', 'Italian Greyhound', 'Japanese Spaniel', 'Keeshond', 'Kelpie', 'Kerry Blue Terrier', 'Komondor', 'Kuvasz', 'Labrador Retriever', 'Lakeland Terrier', 'Leonberg', 'Lhasa', 'Malamute', 'Malinois', 'Maltese Dog', 'Mexican Hairless', 'Miniature Pinscher', 'Miniature Poodle', 'Miniature Schnauzer', 'Newfoundland', 'Norfolk Terrier', 'Norwegian Elkhound', 'Norwich Terrier', 'Old English Sheepdog', 'Otterhound', 'Papillon', 'Pekinese', 'Pembroke', 'Pomeranian', 'Pug', 'Redbone', 'Rhodesian Ridgeback', 'Rottweiler', 'Saint Bernard', 'Saluki', 'Samoyed', 'Schipperke', 'Scotch Terrier', 'Scottish Deerhound', 'Sealyham Terrier', 'Shetland Sheepdog', 'Shih-Tzu', 'Siberian Husky', 'Silky Terrier', 'Soft-coated Wheaten Terrier', 'Staffordshire Bullterrier', 'Standard Poodle', 'Standard Schnauzer', 'Sussex Spaniel', 'Tibetan Mastiff', 'Tibetan Terrier', 'Toy Poodle', 'Toy Terrier', 'Vizsla', 'Walker Hound', 'Weimaraner', 'Welsh Springer Spaniel', 'West Highland White Terrier', 'Whippet', 'Wire-haired Fox Terrier', 'Yorkshire Terrier'];
//   final ImagePicker _picker = ImagePicker();
//
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
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: $e')),
//       );
//     }
//   }
//
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with widget data first (if available)
//     if (widget.petName != null) {
//       _nameController.text = widget.petName!;
//     }
//     if (widget.imageBytes != null) {
//       _selectedImage = widget.imageBytes;
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       if (widget.petId != null) {
//         final petProvider = Provider.of<PetProvider>(context, listen: false);
//         try {
//           final pet = petProvider.pets.firstWhere((p) => p.id == widget.petId);
//           _selectedBreed = pet.breed;
//           _selectedGender = pet.gender;
//           _selectedDate = pet.birthday;
//           _nameController.text = pet.name;
//           _selectedImage = pet.imageBytes ?? widget.imageBytes;
//         } catch (e) {
//           debugPrint("Pet not found: $e");
//           // If pet not found in provider, use widget data
//           if (_nameController.text.isEmpty && widget.petName != null) {
//             _nameController.text = widget.petName!;
//           }
//           if (_selectedImage == null && widget.imageBytes != null) {
//             _selectedImage = widget.imageBytes;
//           }
//         }
//       } else {
//         // Default values for new pet
//         if (_nameController.text.isEmpty) {
//           _nameController.text = 'Super Dog';
//         }
//         if (_selectedBreed == null) {
//           _selectedBreed = 'Affenpinscher';
//         }
//         if (_selectedGender == null) {
//           _selectedGender = 'Male';
//         }
//         if (_selectedDate == null) {
//           _selectedDate = DateTime(2020, 2, 2);
//         }
//       }
//       _isInitialized = true;
//     }
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
//                         child:  Icon(CupertinoIcons.chevron_left,
//                             size: 20.sp, color: Colors.black),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           widget.petId != null ? 'Edit Pet' : 'Add Pet',
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
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     width: 159.w,
//                     height: 159.h,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F6F3),
//                       borderRadius: BorderRadius.circular(27.83),
//                     ),
//                     child: _selectedImage != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.memory(
//                         _selectedImage!,
//                         width: 130,
//                         height: 130,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : (widget.imageBytes != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.memory(
//                         widget.imageBytes!,
//                         width: 130,
//                         height: 130,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.camera_alt, color: Colors.grey, size: 32),
//                         SizedBox(height: 3),
//                         Text('Photo', style: TextStyle(color: Colors.grey, fontSize: 14)),
//                       ],
//                     )),
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
//                 SizedBox(height: 17.h),
//                 Text('Breed', style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, color: const Color(0xFF6F7D86))),
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
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                       ),
//                       items: _breeds.map((b) => DropdownMenuItem(
//                         value: b,
//                         child: Text(
//                           b,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       )).toList(),
//                       onChanged: (v) => setState(() => _selectedBreed = v),
//                       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                       dropdownColor: Colors.white,
//                       isExpanded: true,
//                     ),
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
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 190.h),
//
//                 RoundButton(
//                   title: widget.petId != null ? "Update" : "Save",
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
//                     final petProvider = Provider.of<PetProvider>(context, listen: false);
//
//                     if (widget.petId != null) {
//                       // Update existing pet
//                       final success = await petProvider.updatePet(widget.petId!, pet as Pet);
//                       if (success) {
//                         Navigator.pop(context);
//                       }
//                     } else {
//                       // Add new pet
//                       final success = await petProvider.addPet(pet as Pet);
//                       if (success) {
//                         Navigator.pop(context);
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
//
