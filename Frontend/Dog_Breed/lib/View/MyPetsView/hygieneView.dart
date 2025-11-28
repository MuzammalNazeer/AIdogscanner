import 'package:dog_breed/config/components/HygieneCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HygieneView extends StatefulWidget {
  const HygieneView({super.key});

  @override
  State<HygieneView> createState() => _HygieneViewState();
}

class _HygieneViewState extends State<HygieneView> {
  final Map<String, bool> _hasReminder = {};
  final Map<String, String> _notes = {};
  final List<Color> iconTintColors = [
    const Color(0xFF0048FF),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFFFFC107),
    const Color(0xFF9C27B0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                  ),
                  Center(
                    child: Text(
                      'Hygiene',
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
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  HygieneCard(
                    key: const ValueKey('bath'),
                    title: 'Bath',
                    iconColor: iconTintColors[0],
                    hasReminder: _hasReminder['bath'] ?? false,
                    note: _notes['bath'] ?? '',
                    imagePath: 'assets/images/Vector (3).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['bath'] = !(_hasReminder['bath'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['bath'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('grooming'),
                    title: 'Hair Grooming',
                    iconColor: iconTintColors[1],
                    hasReminder: _hasReminder['grooming'] ?? false,
                    note: _notes['grooming'] ?? '',
                    imagePath: 'assets/images/Vector (8).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['grooming'] = !(_hasReminder['grooming'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['grooming'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('ears'),
                    title: 'Ears Cleaning',
                    iconColor: iconTintColors[2],
                    hasReminder: _hasReminder['ears'] ?? false,
                    note: _notes['ears'] ?? '',
                    imagePath: 'assets/images/Vector (2).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['ears'] = !(_hasReminder['ears'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['ears'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('teeth'),
                    title: 'Teeth Brushing',
                    iconColor: iconTintColors[3],
                    hasReminder: _hasReminder['teeth'] ?? false,
                    note: _notes['teeth'] ?? '',
                    imagePath: 'assets/images/Vector (6).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['teeth'] = !(_hasReminder['teeth'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['teeth'] = note;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  HygieneCard(
                    key: const ValueKey('nail'),
                    title: 'Nail Clipping',
                    iconColor: iconTintColors[4],
                    hasReminder: _hasReminder['nail'] ?? false,
                    note: _notes['nail'] ?? '',
                    imagePath: 'assets/images/Vector (1).png',
                    onReminderTap: () {
                      setState(() {
                        _hasReminder['nail'] = !(_hasReminder['nail'] ?? false);
                      });
                    },
                    onAddNote: (note) {
                      setState(() {
                        _notes['nail'] = note;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:dog_breed/config/components/HygieneCard.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class HygieneView extends StatefulWidget {
//   const HygieneView({super.key});
//
//   @override
//   State<HygieneView> createState() => _HygieneViewState();
// }
//
// class _HygieneViewState extends State<HygieneView> {
//   final Map<String, bool> _hasReminder = {};
//   final Map<String, String> _notes = {};
//   final List<Color> iconTintColors = [
//     const Color(0xFF2196F3),
//     const Color(0xFF4CAF50),
//     const Color(0xFFFF9800),
//     const Color(0xFFFFC107),
//     const Color(0xFF9C27B0),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       width: 40.305.w,
//                       height: 40.305.h,
//                       padding: const EdgeInsets.all(8.96),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF3F6F3), // #F3F6F3
//                         borderRadius: BorderRadius.circular(8.96),
//                       ),
//                       child:  Icon(
//                         CupertinoIcons.chevron_left,
//                         size: 20.sp,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         'Hygiene',
//                         style: TextStyle(
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w300,
//                           fontSize: 29.75.w,
//                           height: 1.0,
//                           letterSpacing: 0.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30.h,),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 children: [
//                   HygieneCard(
//                     key: const ValueKey('bath'),
//                     title: 'Bath',
//                     iconColor: iconTintColors[0],
//                     hasReminder: _hasReminder['bath'] ?? false,
//                     note: _notes['bath'] ?? '',
//                     imagePath: 'assets/images/Vector (3).png',
//                     onReminderTap: () {
//                       setState(() {
//                         _hasReminder['bath'] = !(_hasReminder['bath'] ?? false);
//                       });
//                     },
//                     onAddNote: (note) {
//                       setState(() {
//                         _notes['bath'] = note;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   HygieneCard(
//                     key: const ValueKey('grooming'),
//                     title: 'Hair Grooming',
//                     iconColor: iconTintColors[1],
//                     hasReminder: _hasReminder['grooming'] ?? false,
//                     note: _notes['grooming'] ?? '',
//                     imagePath: 'assets/images/Vector (8).png',
//                     onReminderTap: () {
//                       setState(() {
//                         _hasReminder['grooming'] = !(_hasReminder['grooming'] ?? false);
//                       });
//                     },
//                     onAddNote: (note) {
//                       setState(() {
//                         _notes['grooming'] = note;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   HygieneCard(
//                     key: const ValueKey('ears'),
//                     title: 'Ears Cleaning',
//                     iconColor: iconTintColors[2],
//                     hasReminder: _hasReminder['ears'] ?? false,
//                     note: _notes['ears'] ?? '',
//                     imagePath: 'assets/images/Vector (2).png',
//                     onReminderTap: () {
//                       setState(() {
//                         _hasReminder['ears'] = !(_hasReminder['ears'] ?? false);
//                       });
//                     },
//                     onAddNote: (note) {
//                       setState(() {
//                         _notes['ears'] = note;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   HygieneCard(
//                     key: const ValueKey('teeth'),
//                     title: 'Teeth Brushing',
//                     iconColor: iconTintColors[3],
//                     hasReminder: _hasReminder['teeth'] ?? false,
//                     note: _notes['teeth'] ?? '',
//                     imagePath: 'assets/images/Vector (6).png',
//                     onReminderTap: () {
//                       setState(() {
//                         _hasReminder['teeth'] = !(_hasReminder['teeth'] ?? false);
//                       });
//                     },
//                     onAddNote: (note) {
//                       setState(() {
//                         _notes['teeth'] = note;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   HygieneCard(
//                     key: const ValueKey('teeth'),
//                     title: 'Nail Clipping',
//                     iconColor: iconTintColors[4],
//                     hasReminder: _hasReminder['Nail'] ?? false,
//                     note: _notes['Nail'] ?? '',
//                     imagePath: 'assets/images/Vector (1).png',
//                     onReminderTap: () {
//                       setState(() {
//                         _hasReminder['Nail'] = !(_hasReminder['Nail'] ?? false);
//                       });
//                     },
//                     onAddNote: (note) {
//                       setState(() {
//                         _notes['Nail'] = note;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
