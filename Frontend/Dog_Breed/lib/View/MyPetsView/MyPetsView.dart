// Mypetsview.dart - Updated version
import 'dart:typed_data';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/pet_card.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../View_model/PetProvider.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/home/Pet.dart';
import '../../utils/routes/routes_name.dart';

class Mypetsview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Mypetsview({super.key, this.onShowSnackBar});

  @override
  State<Mypetsview> createState() => _MypetsviewState();
}

class _MypetsviewState extends State<Mypetsview> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final pets = petProvider.pets;
    final allActivities = activityNotifier.activities;

    final filteredPets = _searchQuery.isEmpty
        ? pets
        : pets
        .where(
          (pet) =>
      pet.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      ) ||
          pet.breed.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
    )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_pet_button',
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.addPet);
        },
        backgroundColor: AppColors.vibrantPurple,
        elevation: 8,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'My Pets',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w400,
                  fontSize: 29.75.sp,
                  color: const Color(0xFF272727),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search for Dog',
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: pets.isEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/pet.png',
                      height: 85.h,
                      width: 85.w,
                    ),
                  ),
                  Center(
                    child: Text(
                      'No pets have been added yet',
                      style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  RoundButton(
                    height: 51.h,
                    width: 150.w,
                    isSelected: true,
                    title: '+  Add pet',
                    backgroundColors: AppColors.vibrantPurple,
                    textColors: Colors.white,
                    onPress: () {
                      Navigator.pushNamed(context, RoutesName.addPet);
                    },)
                ],
              )
                  : filteredPets.isEmpty
                  ? const Center(
                child: Text(
                  'No pets match your search',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = filteredPets[index];
                  // Filter activities for this pet
                  final petActivities = allActivities.where((a) => a.petId == pet.id).toList();

                  final Map<String, int> counts = {};
                  for (var activity in petActivities) {
                    counts[activity.name] = (counts[activity.name] ?? 0) + 1;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      child: PetCard(
                        key: Key('pet_${pet.id}_$index'),
                        imageUrl: _getPetImage(index),
                        imageBytes: pet.imageBytes,
                        name: pet.name,
                        activityCounts: counts,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPetImage(int index) {
    final images = [
      'assets/images/Ellipse 77 (2).png',
      'assets/images/Ellipse 77 (1).png',
      'assets/images/Ellipse 77.png',
    ];
    return images[index % images.length];
  }
}

// import 'package:dog_breed/config/components/pet_card.dart';
// import 'package:dog_breed/View_model/pet.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// class Mypetsview extends StatefulWidget {
//   const Mypetsview({super.key});
//
//   @override
//   State<Mypetsview> createState() => _MypetsviewState();
// }
//
// class _MypetsviewState extends State<Mypetsview> {
//   @override
//   Widget build(BuildContext context) {
//     final petProvider = Provider.of<PetProvid>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//              SizedBox(height: 20.h),
//              Center(
//               child: Text(
//                 'My Pets',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 29.75.sp,
//                   height: 1.0,
//                   letterSpacing: 0.0,
//                   color: const Color(0xFF272727),
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: CupertinoSearchTextField(
//                 placeholder: 'Search for Dog',
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 children: [
//                   if (petProvider.pets.isNotEmpty) ...[
//                     ...petProvider.pets.map((pet) => Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: PetCard(
//                         key: Key('saved_pet_${pet.name}_${petProvider.pets.indexOf(pet)}'),
//                         imageUrl: _getPetImage(petProvider.pets.indexOf(pet)),
//                         imageBytes: pet.imageBytes,
//                         name: pet.name,
//                         photoCount: 2,
//                         vaccineCount: 3,
//                         clothesCount: 4,
//                         calendarCount: 1,
//                         medicalCount: 0,
//                         profileCount: 0,
//                         photoProgress: 0.4,
//                         vaccineProgress: 0.6,
//                         clothesProgress: 0.8,
//                         calendarProgress: 0.2,
//                         medicalProgress: 0.0,
//                         profileProgress: 0.8,
//                       ),
//                     )),
//                   ] else ...[
//                     const Padding(
//                       padding: EdgeInsets.only(top: 20, bottom: 20),
//                       child: Center(
//                         child: Text(
//                           'No additional pets added yet',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getPetImage(int index) {
//     final images = [
//       'assets/images/Ellipse 77 (2).png',
//       'assets/images/Ellipse 77 (1).png',
//       'assets/images/Ellipse 77.png',
//     ];
//     return images[index % images.length];
//   }
// }


// // Mypetsview.dart - Updated version
// import 'dart:typed_data';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/pet_card.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Mypetsview extends StatefulWidget {
//   final void Function(String message)? onShowSnackBar;
//
//   const Mypetsview({super.key, this.onShowSnackBar});
//
//   @override
//   State<Mypetsview> createState() => _MypetsviewState();
// }
//
// class _MypetsviewState extends State<Mypetsview> {
//   String _searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final petProvider = Provider.of<PetProvider>(context);
//     final pets = petProvider.pets;
//     final filteredPets = _searchQuery.isEmpty
//         ? pets
//         : pets
//               .where(
//                 (pet) =>
//                     pet.name.toLowerCase().contains(
//                       _searchQuery.toLowerCase(),
//                     ) ||
//                     pet.breed.toLowerCase().contains(
//                       _searchQuery.toLowerCase(),
//                     ),
//               )
//               .toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, RoutesName.addPet);
//         },
//         backgroundColor: AppColors.vibrantPurple,
//         elevation: 8,
//         shape: const CircleBorder(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.add_rounded,
//               color: Colors.white,
//               size: 32.sp,
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             SizedBox(height: 20.h),
//             Center(
//               child: Text(
//                 'My Pets',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 29.75.sp,
//                   color: const Color(0xFF272727),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: CupertinoSearchTextField(
//                 placeholder: 'Search for Dog',
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 12,
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _searchQuery = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: pets.isEmpty
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Image.asset(
//                             'assets/images/pet.png',
//                             height: 85.h,
//                             width: 85.w,
//                           ),
//                         ),
//                          Center(
//                           child: Text(
//                             'No pets have been added yet',
//                             style: TextStyle(fontSize: 20.sp, color: Colors.grey),
//                           ),
//                         ),
//                         const SizedBox(height: 20,),
//                         RoundButton(
//                           height: 51.h,
//                           width: 150.w,
//                           isSelected: true,
//                           title: '+  Add pet',
//                           backgroundColors: AppColors.vibrantPurple,
//                           textColors: Colors.white,
//                           onPress: () {
//                             Navigator.pushNamed(context, RoutesName.addPet);
//                           },)
//                       ],
//                     )
//                   : filteredPets.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No pets match your search',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: filteredPets.length,
//                       itemBuilder: (context, index) {
//                         final pet = filteredPets[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: GestureDetector(
//                             child: PetCard(
//                               key: Key('pet_${pet.id}_$index'),
//                               imageUrl: _getPetImage(index),
//                               imageBytes: pet.imageBytes,
//                               name: pet.name,
//                               photoCount: 2,
//                               vaccineCount: 3,
//                               clothesCount: 4,
//                               calendarCount: 1,
//                               medicalCount: 0,
//                               profileCount: 0,
//                               photoProgress: 0.4,
//                               vaccineProgress: 0.6,
//                               clothesProgress: 0.8,
//                               calendarProgress: 0.2,
//                               medicalProgress: 0.0,
//                               profileProgress: 0.8,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getPetImage(int index) {
//     final images = [
//       'assets/images/Ellipse 77 (2).png',
//       'assets/images/Ellipse 77 (1).png',
//       'assets/images/Ellipse 77.png',
//     ];
//     return images[index % images.length];
//   }
// }
//
// // import 'package:dog_breed/config/components/pet_card.dart';
// // import 'package:dog_breed/View_model/pet.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// //
// // class Mypetsview extends StatefulWidget {
// //   const Mypetsview({super.key});
// //
// //   @override
// //   State<Mypetsview> createState() => _MypetsviewState();
// // }
// //
// // class _MypetsviewState extends State<Mypetsview> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final petProvider = Provider.of<PetProvid>(context);
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //              SizedBox(height: 20.h),
// //              Center(
// //               child: Text(
// //                 'My Pets',
// //                 style: TextStyle(
// //                   fontFamily: 'Sora',
// //                   fontWeight: FontWeight.w400,
// //                   fontStyle: FontStyle.normal,
// //                   fontSize: 29.75.sp,
// //                   height: 1.0,
// //                   letterSpacing: 0.0,
// //                   color: const Color(0xFF272727),
// //                 ),
// //               ),
// //             ),
// //             const Padding(
// //               padding: EdgeInsets.all(16.0),
// //               child: CupertinoSearchTextField(
// //                 placeholder: 'Search for Dog',
// //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// //               ),
// //             ),
// //             Expanded(
// //               child: ListView(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 children: [
// //                   if (petProvider.pets.isNotEmpty) ...[
// //                     ...petProvider.pets.map((pet) => Padding(
// //                       padding: const EdgeInsets.only(bottom: 16),
// //                       child: PetCard(
// //                         key: Key('saved_pet_${pet.name}_${petProvider.pets.indexOf(pet)}'),
// //                         imageUrl: _getPetImage(petProvider.pets.indexOf(pet)),
// //                         imageBytes: pet.imageBytes,
// //                         name: pet.name,
// //                         photoCount: 2,
// //                         vaccineCount: 3,
// //                         clothesCount: 4,
// //                         calendarCount: 1,
// //                         medicalCount: 0,
// //                         profileCount: 0,
// //                         photoProgress: 0.4,
// //                         vaccineProgress: 0.6,
// //                         clothesProgress: 0.8,
// //                         calendarProgress: 0.2,
// //                         medicalProgress: 0.0,
// //                         profileProgress: 0.8,
// //                       ),
// //                     )),
// //                   ] else ...[
// //                     const Padding(
// //                       padding: EdgeInsets.only(top: 20, bottom: 20),
// //                       child: Center(
// //                         child: Text(
// //                           'No additional pets added yet',
// //                           style: TextStyle(fontSize: 16, color: Colors.grey),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _getPetImage(int index) {
// //     final images = [
// //       'assets/images/Ellipse 77 (2).png',
// //       'assets/images/Ellipse 77 (1).png',
// //       'assets/images/Ellipse 77.png',
// //     ];
// //     return images[index % images.length];
// //   }
// // }


// // Mypetsview.dart - Updated version
// import 'dart:typed_data';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/pet_card.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../View_model/PetProvider.dart';
// import '../../View_model/home/Pet.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Mypetsview extends StatefulWidget {
//   final void Function(String message)? onShowSnackBar;
//
//   const Mypetsview({super.key, this.onShowSnackBar});
//
//   @override
//   State<Mypetsview> createState() => _MypetsviewState();
// }
//
// class _MypetsviewState extends State<Mypetsview> {
//   String _searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final petProvider = Provider.of<PetProvider>(context);
//     final pets = petProvider.pets;
//     final filteredPets = _searchQuery.isEmpty
//         ? pets
//         : pets
//               .where(
//                 (pet) =>
//                     pet.name.toLowerCase().contains(
//                       _searchQuery.toLowerCase(),
//                     ) ||
//                     pet.breed.toLowerCase().contains(
//                       _searchQuery.toLowerCase(),
//                     ),
//               )
//               .toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, RoutesName.addPet);
//         },
//         backgroundColor: AppColors.vibrantPurple,
//         elevation: 8,
//         shape: const CircleBorder(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.add_rounded,
//               color: Colors.white,
//               size: 32.sp,
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             SizedBox(height: 20.h),
//             Center(
//               child: Text(
//                 'My Pets',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 29.75.sp,
//                   color: const Color(0xFF272727),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: CupertinoSearchTextField(
//                 placeholder: 'Search for Dog',
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 12,
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _searchQuery = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: pets.isEmpty
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Image.asset(
//                             'assets/images/pet.png',
//                             height: 85.h,
//                             width: 85.w,
//                           ),
//                         ),
//                          Center(
//                           child: Text(
//                             'No pets have been added yet',
//                             style: TextStyle(fontSize: 20.sp, color: Colors.grey),
//                           ),
//                         ),
//                         const SizedBox(height: 20,),
//                         RoundButton(
//                           height: 51.h,
//                           width: 150.w,
//                           isSelected: true,
//                           title: '+  Add pet',
//                           backgroundColors: AppColors.vibrantPurple,
//                           textColors: Colors.white,
//                           onPress: () {
//                             Navigator.pushNamed(context, RoutesName.addPet);
//                           },)
//                       ],
//                     )
//                   : filteredPets.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No pets match your search',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: filteredPets.length,
//                       itemBuilder: (context, index) {
//                         final pet = filteredPets[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: GestureDetector(
//                             child: PetCard(
//                               key: Key('pet_${pet.id}_$index'),
//                               imageUrl: _getPetImage(index),
//                               imageBytes: pet.imageBytes,
//                               name: pet.name,
//                               photoCount: 2,
//                               vaccineCount: 3,
//                               clothesCount: 4,
//                               calendarCount: 1,
//                               medicalCount: 0,
//                               profileCount: 0,
//                               photoProgress: 0.4,
//                               vaccineProgress: 0.6,
//                               clothesProgress: 0.8,
//                               calendarProgress: 0.2,
//                               medicalProgress: 0.0,
//                               profileProgress: 0.8,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getPetImage(int index) {
//     final images = [
//       'assets/images/Ellipse 77 (2).png',
//       'assets/images/Ellipse 77 (1).png',
//       'assets/images/Ellipse 77.png',
//     ];
//     return images[index % images.length];
//   }
// }
//
// // import 'package:dog_breed/config/components/pet_card.dart';
// // import 'package:dog_breed/View_model/pet.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// //
// // class Mypetsview extends StatefulWidget {
// //   const Mypetsview({super.key});
// //
// //   @override
// //   State<Mypetsview> createState() => _MypetsviewState();
// // }
// //
// // class _MypetsviewState extends State<Mypetsview> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final petProvider = Provider.of<PetProvid>(context);
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //              SizedBox(height: 20.h),
// //              Center(
// //               child: Text(
// //                 'My Pets',
// //                 style: TextStyle(
// //                   fontFamily: 'Sora',
// //                   fontWeight: FontWeight.w400,
// //                   fontStyle: FontStyle.normal,
// //                   fontSize: 29.75.sp,
// //                   height: 1.0,
// //                   letterSpacing: 0.0,
// //                   color: const Color(0xFF272727),
// //                 ),
// //               ),
// //             ),
// //             const Padding(
// //               padding: EdgeInsets.all(16.0),
// //               child: CupertinoSearchTextField(
// //                 placeholder: 'Search for Dog',
// //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// //               ),
// //             ),
// //             Expanded(
// //               child: ListView(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 children: [
// //                   if (petProvider.pets.isNotEmpty) ...[
// //                     ...petProvider.pets.map((pet) => Padding(
// //                       padding: const EdgeInsets.only(bottom: 16),
// //                       child: PetCard(
// //                         key: Key('saved_pet_${pet.name}_${petProvider.pets.indexOf(pet)}'),
// //                         imageUrl: _getPetImage(petProvider.pets.indexOf(pet)),
// //                         imageBytes: pet.imageBytes,
// //                         name: pet.name,
// //                         photoCount: 2,
// //                         vaccineCount: 3,
// //                         clothesCount: 4,
// //                         calendarCount: 1,
// //                         medicalCount: 0,
// //                         profileCount: 0,
// //                         photoProgress: 0.4,
// //                         vaccineProgress: 0.6,
// //                         clothesProgress: 0.8,
// //                         calendarProgress: 0.2,
// //                         medicalProgress: 0.0,
// //                         profileProgress: 0.8,
// //                       ),
// //                     )),
// //                   ] else ...[
// //                     const Padding(
// //                       padding: EdgeInsets.only(top: 20, bottom: 20),
// //                       child: Center(
// //                         child: Text(
// //                           'No additional pets added yet',
// //                           style: TextStyle(fontSize: 16, color: Colors.grey),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _getPetImage(int index) {
// //     final images = [
// //       'assets/images/Ellipse 77 (2).png',
// //       'assets/images/Ellipse 77 (1).png',
// //       'assets/images/Ellipse 77.png',
// //     ];
// //     return images[index % images.length];
// //   }
// // }
