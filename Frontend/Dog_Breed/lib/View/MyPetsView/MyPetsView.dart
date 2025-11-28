import 'package:dog_breed/config/components/pet_card.dart';
import 'package:dog_breed/View_model/pet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Mypetsview extends StatefulWidget {
  const Mypetsview({super.key});

  @override
  State<Mypetsview> createState() => _MypetsviewState();
}

class _MypetsviewState extends State<Mypetsview> {
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvid>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
             SizedBox(height: 20.h),
             Center(
              child: Text(
                'My Pets',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  fontSize: 29.75.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Color(0xFF272727),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search for Dog',
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDemoPetCard(
                    'assets/images/Ellipse 77 (2).png',
                    'My Lovely Tommy',
                  ),
                   SizedBox(height: 16.h),
                  _buildDemoPetCard(
                    'assets/images/Ellipse 77 (1).png',
                    'Danny',
                  ),
                   SizedBox(height: 16.h),
                  _buildDemoPetCard(
                    'assets/images/Ellipse 77.png',
                    'Sillcion',
                  ),
                   SizedBox(height: 16.h),
                  if (petProvider.pets.isNotEmpty) ...[
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Your Added Pets',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF272727),
                        ),
                      ),
                    ),
                    ...petProvider.pets.map((pet) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PetCard(
                        key: Key('saved_pet_${pet.name}_${petProvider.pets.indexOf(pet)}'),
                        imageUrl: _getPetImage(petProvider.pets.indexOf(pet)),
                        name: pet.name,
                        photoCount: 2,
                        vaccineCount: 3,
                        clothesCount: 4,
                        calendarCount: 1,
                        medicalCount: 0,
                        profileCount: 4,
                        photoProgress: 0.4,
                        vaccineProgress: 0.6,
                        clothesProgress: 0.8,
                        calendarProgress: 0.2,
                        medicalProgress: 0.0,
                        profileProgress: 0.8,
                      ),
                    )),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: Text(
                          'No additional pets added yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoPetCard(String imageUrl, String name) {
    return PetCard(
      key: Key('demo_$name'),
      imageUrl: imageUrl,
      name: name,
      photoCount: 2,
      vaccineCount: 3,
      clothesCount: 4,
      calendarCount: 1,
      medicalCount: 0,
      profileCount: 4,
      photoProgress: 0.4,
      vaccineProgress: 0.6,
      clothesProgress: 0.8,
      calendarProgress: 0.2,
      medicalProgress: 0.0,
      profileProgress: 0.8,
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

//
//
// import 'package:dog_breed/config/components/pet_card.dart';
// import 'package:dog_breed/View_model/pet.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
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
//     // FIX: Use PetProvider instead of Pet
//     final petProvider = Provider.of<PetProvid>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Center(
//               child: Text(
//                 'My Pets',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w300,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 29.75,
//                   height: 1.0,
//                   letterSpacing: 0.0,
//                   color: Color(0xFF272727),
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
//                   // Always show these 3 demo pets
//                   _buildDemoPetCard(
//                     'assets/images/Ellipse 77 (2).png',
//                     'My Lovely Tommy',
//                   ),
//                   const SizedBox(height: 16),
//                   _buildDemoPetCard(
//                     'assets/images/Ellipse 77 (1).png',
//                     'Danny',
//                   ),
//                   const SizedBox(height: 16),
//                   _buildDemoPetCard(
//                     'assets/images/Ellipse 77.png',
//                     'Sillcion',
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Show saved pets from provider below the demo pets
//                   if (petProvider.pets.isNotEmpty) ...[
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         'Your Added Pets',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF272727),
//                         ),
//                       ),
//                     ),
//                     ...petProvider.pets.map((pet) => Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: PetCard(
//                         key: Key('saved_pet_${pet.name}_${petProvider.pets.indexOf(pet)}'),
//                         imageUrl: _getPetImage(petProvider.pets.indexOf(pet)),
//                         name: pet.name,
//                         photoCount: 2,
//                         vaccineCount: 3,
//                         clothesCount: 4,
//                         calendarCount: 1,
//                         medicalCount: 0,
//                         profileCount: 4,
//                         photoProgress: 0.4,
//                         vaccineProgress: 0.6,
//                         clothesProgress: 0.8,
//                         calendarProgress: 0.2,
//                         medicalProgress: 0.0,
//                         profileProgress: 0.8,
//                       ),
//                     )).toList(),
//                   ] else ...[
//                     // Show message only if no saved pets (demo pets are always shown)
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
//   // Helper method to build demo pet cards
//   Widget _buildDemoPetCard(String imageUrl, String name) {
//     return PetCard(
//       key: Key('demo_$name'),
//       imageUrl: imageUrl,
//       name: name,
//       photoCount: 2,
//       vaccineCount: 3,
//       clothesCount: 4,
//       calendarCount: 1,
//       medicalCount: 0,
//       profileCount: 4,
//       photoProgress: 0.4,
//       vaccineProgress: 0.6,
//       clothesProgress: 0.8,
//       calendarProgress: 0.2,
//       medicalProgress: 0.0,
//       profileProgress: 0.8,
//     );
//   }
//
//   // Helper method to get different images for saved pets
//   String _getPetImage(int index) {
//     final images = [
//       'assets/images/Ellipse 77 (2).png',
//       'assets/images/Ellipse 77 (1).png',
//       'assets/images/Ellipse 77.png',
//     ];
//     return images[index % images.length];
//   }
// }
// // import 'package:dog_breed/config/components/pet_card.dart';
// // import 'package:dog_breed/View_model/pet.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
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
// //     final petProvider = Provider.of<Pet>(context);
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 20),
// //             const Center(
// //               child: Text(
// //                 'My Pets',
// //                 style: TextStyle(
// //                   fontFamily: 'Sora',
// //                   fontWeight: FontWeight.w300,
// //                   fontStyle: FontStyle.normal,
// //                   fontSize: 29.75,
// //                   height: 1.0,
// //                   letterSpacing: 0.0,
// //                   color: Color(0xFF272727),
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
// //               child: petProvider.pets.isEmpty
// //                   ? const Center(
// //                       child: Text(
// //                         'No pets added yet',
// //                         style: TextStyle(fontSize: 16, color: Colors.grey),
// //                       ),
// //                     )
// //                   : ListView.builder(
// //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// //                       itemCount: petProvider.pets.length,
// //                       itemBuilder: (context, index) {
// //                         final pet = petProvider.pets[index];
// //                         return Padding(
// //                           padding: EdgeInsets.only(bottom: 16),
// //                           child: Column(
// //                             children: [
// //                               PetCard(
// //                                 imageUrl: 'assets/images/Ellipse 77 (2).png',
// //                                 name: 'My Lovely Tommy',
// //                                 photoCount: 2,
// //                                 vaccineCount: 3,
// //                                 clothesCount: 4,
// //                                 calendarCount: 1,
// //                                 medicalCount: 0,
// //                                 profileCount: 4,
// //                                 photoProgress: 0.4,
// //                                 vaccineProgress: 0.6,
// //                                 clothesProgress: 0.8,
// //                                 calendarProgress: 0.2,
// //                                 medicalProgress: 0.0,
// //                                 profileProgress: 0.8,
// //                               ),
// //                               const SizedBox(height: 16),
// //                               PetCard(
// //                                 imageUrl: 'assets/images/Ellipse 77 (1).png',
// //                                 name: 'Danny',
// //                                 photoCount: 2,
// //                                 vaccineCount: 3,
// //                                 clothesCount: 4,
// //                                 calendarCount: 1,
// //                                 medicalCount: 0,
// //                                 profileCount: 4,
// //                                 photoProgress: 0.4,
// //                                 vaccineProgress: 0.6,
// //                                 clothesProgress: 0.8,
// //                                 calendarProgress: 0.2,
// //                                 medicalProgress: 0.0,
// //                                 profileProgress: 0.8,
// //                               ),
// //                               const SizedBox(height: 16),
// //                               PetCard(
// //                                 imageUrl: 'assets/images/Ellipse 77.png',
// //                                 name: 'Sillcion',
// //                                 photoCount: 2,
// //                                 vaccineCount: 3,
// //                                 clothesCount: 4,
// //                                 calendarCount: 1,
// //                                 medicalCount: 0,
// //                                 profileCount: 4,
// //                                 photoProgress: 0.4,
// //                                 vaccineProgress: 0.6,
// //                                 clothesProgress: 0.8,
// //                                 calendarProgress: 0.2,
// //                                 medicalProgress: 0.0,
// //                                 profileProgress: 0.8,
// //                               ),
// //                               const SizedBox(height: 16),
// //                               PetCard(
// //                                 key: Key('pet_${pet.name}_$index'),
// //                                 // Fix: Use Key() constructor
// //                                 imageUrl: 'assets/images/Ellipse 77.png',
// //                                 name: pet.name,
// //                                 photoCount: 2,
// //                                 vaccineCount: 3,
// //                                 clothesCount: 4,
// //                                 calendarCount: 1,
// //                                 medicalCount: 0,
// //                                 profileCount: 4,
// //                                 photoProgress: 0.4,
// //                                 vaccineProgress: 0.6,
// //                                 clothesProgress: 0.8,
// //                                 calendarProgress: 0.2,
// //                                 medicalProgress: 0.0,
// //                                 profileProgress: 0.8,
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // // lib/config/screens/my_pets_view.dart
// // // import 'package:dog_breed/config/components/pet_card.dart';
// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // //
// // // class Mypetsview extends StatefulWidget {
// // //   const Mypetsview({super.key});
// // //
// // //   @override
// // //   State<Mypetsview> createState() => _MypetsviewState();
// // // }
// // //
// // // class _MypetsviewState extends State<Mypetsview> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: SafeArea(
// // //         child: Column(
// // //           children: [
// // //             SizedBox(height: 20,),
// // //             Center(
// // //               child: Text(
// // //                 'My Pets',
// // //                 style: TextStyle(
// // //                   fontFamily: 'Sora',
// // //                   fontWeight: FontWeight.w300,
// // //                   fontStyle: FontStyle.normal,
// // //                   fontSize: 29.75,
// // //                   height: 1.0,
// // //                   letterSpacing: 0.0,
// // //                   color: const Color(0xFF272727),
// // //                 ),
// // //               ),
// // //             ),
// // //             const Padding(
// // //               padding: EdgeInsets.all(16.0),
// // //               child: CupertinoSearchTextField(
// // //                 placeholder: 'Search for Dog',
// // //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// // //               ),
// // //             ),
// // //             Expanded(
// // //               child: ListView(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                 children: [
// // //                   PetCard(
// // //                     imageUrl: 'assets/images/Ellipse 77 (2).png',
// // //                     name: 'My Lovely Tommy',
// // //                     photoCount: 2,
// // //                     vaccineCount: 3,
// // //                     clothesCount: 4,
// // //                     calendarCount: 1,
// // //                     medicalCount: 0,
// // //                     profileCount: 4,
// // //                     photoProgress: 0.4,
// // //                     vaccineProgress: 0.6,
// // //                     clothesProgress: 0.8,
// // //                     calendarProgress: 0.2,
// // //                     medicalProgress: 0.0,
// // //                     profileProgress: 0.8,
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   PetCard(
// // //                     imageUrl: 'assets/images/Ellipse 77 (1).png',
// // //                     name: 'Danny',
// // //                     photoCount: 2,
// // //                     vaccineCount: 3,
// // //                     clothesCount: 4,
// // //                     calendarCount: 1,
// // //                     medicalCount: 0,
// // //                     profileCount: 4,
// // //                     photoProgress: 0.4,
// // //                     vaccineProgress: 0.6,
// // //                     clothesProgress: 0.8,
// // //                     calendarProgress: 0.2,
// // //                     medicalProgress: 0.0,
// // //                     profileProgress: 0.8,
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   PetCard(
// // //                     imageUrl: 'assets/images/Ellipse 77.png',
// // //                     name: 'Sillcion',
// // //                     photoCount: 2,
// // //                     vaccineCount: 3,
// // //                     clothesCount: 4,
// // //                     calendarCount: 1,
// // //                     medicalCount: 0,
// // //                     profileCount: 4,
// // //                     photoProgress: 0.4,
// // //                     vaccineProgress: 0.6,
// // //                     clothesProgress: 0.8,
// // //                     calendarProgress: 0.2,
// // //                     medicalProgress: 0.0,
// // //                     profileProgress: 0.8,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
