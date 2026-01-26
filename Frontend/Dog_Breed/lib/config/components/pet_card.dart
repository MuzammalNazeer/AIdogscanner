import 'dart:io';
import 'dart:typed_data';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/Valid/ActivityConstants.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String? petId;
  final Uint8List? imageBytes;
  final Map<String, int> activityCounts;
  final VoidCallback? onEditPressed;
  final bool showEditButton;

  const PetCard({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.name,
    this.petId,
    required this.activityCounts,
    this.onEditPressed,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer gradient circle
                    Container(
                      width: 68.w,
                      height: 68.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // White circle background for image
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.white,
                      ),
                      child: ClipOval(
                        child: _buildImage(),
                      ),
                    ),
                    // Edit button (replaces camera button)
                    if (showEditButton)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: onEditPressed ?? () {
                            // Default edit action - navigate to edit screen
                            Navigator.pushNamed(
                              context,
                              RoutesName.edit,
                              arguments: {
                                'isEditing': true,
                                'petName': name,
                                'petId': petId,
                                'imageBytes': imageBytes,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.pencil,
                              size: 16,
                              color: AppColors.vibrantPurple,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8.w),
                Image.asset(
                  'assets/images/1233.png',
                  width: 118.w,
                  height: 73.h,
                )
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFCBE4DC),
            thickness: 1,
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.start,
              children: ActivityConstants.allActivities
                  .where((type) => (activityCounts[type.name] ?? 0) > 0)
                  .map((type) => _buildGridItem(
                imageAsset: type.image,
                count: activityCounts[type.name]!,
                backgroundColor: type.color,
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Priority 1: Use imageBytes if available
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
        errorBuilder: (_, __, ___) => _errorImage(),
      );
    }

    // Priority 2: Use imageUrl if available
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        return Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _errorImage(),
        );
      } else if (File(imageUrl!).existsSync()) {
        return Image.file(
          File(imageUrl!),
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _errorImage(),
        );
      } else {
        return Image.asset(
          imageUrl!,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _errorImage(),
        );
      }
    }

    // Fallback
    return _errorImage();
  }

  Widget _errorImage() {
    return Container(
      color: CupertinoColors.systemGrey4,
      child: const Icon(
        CupertinoIcons.photo,
        color: CupertinoColors.systemGrey,
      ),
    );
  }

  Widget _buildGridItem({
    required int count,
    required Color backgroundColor,
    String? imageAsset,
    IconData? icon, // fallback if asset missing
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: imageAsset != null
                ? Image.asset(
              imageAsset,
              width: 28.w,
              height: 28.h,
              fit: BoxFit.contain,
              errorBuilder: (context, _, __) => Icon(
                icon ?? Icons.error,
                size: 24.sp,
                color: Colors.black54,
              ),
            )
                : Icon(
              icon ?? Icons.image,
              size: 24.sp,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: const Color(0xFF272727),
          ),
        ),
      ],
    );
  }
}


// import 'dart:io';
// import 'dart:typed_data';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/Valid/ActivityConstants.dart';
//
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class PetCard extends StatelessWidget {
//   final String? imageUrl;
//   final String name;
//   final String? petId;
//   final Uint8List? imageBytes;
//   final Map<String, int> activityCounts;
//   final VoidCallback? onEditPressed;
//   final bool showEditButton;
//
//   const PetCard({
//     super.key,
//     this.imageUrl,
//     this.imageBytes,
//     required this.name,
//     this.petId,
//     required this.activityCounts,
//     this.onEditPressed,
//     this.showEditButton = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: 20.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: CupertinoColors.systemGrey.withOpacity(0.10),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Row(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Outer gradient circle
//                     Container(
//                       width: 68.w,
//                       height: 68.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                     ),
//                     // White circle background for image
//                     Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: CupertinoColors.white,
//                       ),
//                       child: ClipOval(
//                         child: _buildImage(),
//                       ),
//                     ),
//                     // Edit button (replaces camera button)
//                     if (showEditButton)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: GestureDetector(
//                           onTap: onEditPressed ?? () {
//                             // Default edit action - navigate to edit screen
//                             Navigator.pushNamed(
//                               context,
//                               RoutesName.edit,
//                               arguments: {
//                                 'isEditing': true,
//                                 'petName': name,
//                                 'petId': petId,
//                                 'imageBytes': imageBytes,
//                               },
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   offset: Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               CupertinoIcons.pencil,
//                               size: 16,
//                               color: AppColors.vibrantPurple,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(width: 12.w),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontFamily: "Sora",
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                     color: CupertinoColors.black,
//                   ),
//                 ),
//                 const Spacer(),
//                 Image.asset(
//                   'assets/images/1233.png',
//                   width: 118.w,
//                   height: 73.h,
//                 )
//               ],
//             ),
//           ),
//           const Divider(
//             color: Color(0xFFCBE4DC),
//             thickness: 1,
//           ),
//           SizedBox(height: 5.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.w),
//             child: Wrap(
//               spacing: 12.w,
//               runSpacing: 16.h,
//               alignment: WrapAlignment.start,
//               children: ActivityConstants.allActivities
//                   .where((type) => (activityCounts[type.name] ?? 0) > 0)
//                   .map((type) => _buildGridItem(
//                 imageAsset: type.image,
//                 count: activityCounts[type.name]!,
//                 backgroundColor: type.color,
//               ))
//                   .toList(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     // Priority 1: Use imageBytes if available
//     if (imageBytes != null && imageBytes!.isNotEmpty) {
//       return Image.memory(
//         imageBytes!,
//         fit: BoxFit.cover,
//         width: 60,
//         height: 60,
//         errorBuilder: (_, __, ___) => _errorImage(),
//       );
//     }
//
//     // Priority 2: Use imageUrl if available
//     if (imageUrl != null && imageUrl!.isNotEmpty) {
//       if (imageUrl!.startsWith('http')) {
//         return Image.network(
//           imageUrl!,
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       } else if (File(imageUrl!).existsSync()) {
//         return Image.file(
//           File(imageUrl!),
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       } else {
//         return Image.asset(
//           imageUrl!,
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       }
//     }
//
//     // Fallback
//     return _errorImage();
//   }
//
//   Widget _errorImage() {
//     return Container(
//       color: CupertinoColors.systemGrey4,
//       child: const Icon(
//         CupertinoIcons.photo,
//         color: CupertinoColors.systemGrey,
//       ),
//     );
//   }
//
//   Widget _buildGridItem({
//     required int count,
//     required Color backgroundColor,
//     String? imageAsset,
//     IconData? icon, // fallback if asset missing
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 50.w,
//           height: 50.h,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: imageAsset != null
//                 ? Image.asset(
//               imageAsset,
//               width: 28.w,
//               height: 28.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, _, __) => Icon(
//                 icon ?? Icons.error,
//                 size: 24.sp,
//                 color: Colors.black54,
//               ),
//             )
//                 : Icon(
//               icon ?? Icons.image,
//               size: 24.sp,
//               color: Colors.black54,
//             ),
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           '$count',
//           style: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w600,
//             fontSize: 16.sp,
//             color: const Color(0xFF272727),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/Valid/ActivityConstants.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class PetCard extends StatelessWidget {
//   final String? imageUrl;
//   final String name;
//   final String? petId;
//   final Uint8List? imageBytes;
//   final Map<String, int> activityCounts;
//   final VoidCallback? onEditPressed;
//   final bool showEditButton;
//
//   const PetCard({
//     super.key,
//     this.imageUrl,
//     this.imageBytes,
//     required this.name,
//     this.petId,
//     required this.activityCounts,
//     this.onEditPressed,
//     this.showEditButton = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: 20.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: CupertinoColors.systemGrey.withOpacity(0.10),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(12.w),
//             child: Row(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Outer gradient circle
//                     Container(
//                       width: 68.w,
//                       height: 68.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                     ),
//                     // White circle background for image
//                     Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: CupertinoColors.white,
//                       ),
//                       child: ClipOval(
//                         child: _buildImage(),
//                       ),
//                     ),
//                     // Edit button (replaces camera button)
//                     if (showEditButton)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: GestureDetector(
//                           onTap: onEditPressed ?? () {
//                             // Default edit action - navigate to edit screen
//                             Navigator.pushNamed(
//                               context,
//                               RoutesName.edit,
//                               arguments: {
//                                 'isEditing': true,
//                                 'petName': name,
//                                 'petId': petId,
//                                 'imageBytes': imageBytes,
//                               },
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   offset: Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               CupertinoIcons.pencil,
//                               size: 16,
//                               color: AppColors.vibrantPurple,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     name,
//                     style: TextStyle(
//                       fontFamily: "Sora",
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: CupertinoColors.black,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     maxLines: 1,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Image.asset(
//                   'assets/images/1233.png',
//                   width: 118.w,
//                   height: 73.h,
//                 )
//               ],
//             ),
//           ),
//           const Divider(
//             color: Color(0xFFCBE4DC),
//             thickness: 1,
//           ),
//           SizedBox(height: 5.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.w),
//             child: Wrap(
//               spacing: 12.w,
//               runSpacing: 16.h,
//               alignment: WrapAlignment.start,
//               children: ActivityConstants.allActivities
//                   .where((type) => (activityCounts[type.name] ?? 0) > 0)
//                   .map((type) => _buildGridItem(
//                 imageAsset: type.image,
//                 count: activityCounts[type.name]!,
//                 backgroundColor: type.color,
//                 label: _getLocalizedActivityName(context, type.name),
//               ))
//                   .toList(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   String _getLocalizedActivityName(BuildContext context, String activityName) {
//     final l10n = AppLocalizations.of(context)!;
//     switch (activityName) {
//       case 'Veterinary': return l10n.activityVeterinary;
//       case 'Pee': return l10n.activityPee;
//       case 'Eat': return l10n.activityEat;
//       case 'Drink': return l10n.activityDrink;
//       case 'Play': return l10n.activityPlay;
//       case 'Poop': return l10n.activityPoop;
//       case 'Walk': return l10n.activityWalk;
//       case 'Crate': return l10n.activityCrate;
//       case 'Sleep': return l10n.activitySleep;
//       case 'Training': return l10n.activityTraining;
//       case 'Treat': return l10n.activityTreat;
//       case 'Grooming': return l10n.activityGrooming;
//       case 'Cleaning': return l10n.activityCleaning;
//       case 'Medication': return l10n.activityMedication;
//       case 'Vaccination': return l10n.activityVaccination;
//       case 'Weight': return l10n.activityWeight;
//       case 'Height': return l10n.activityHeight;
//       case 'Temperature': return l10n.activityTemperature;
//       case 'Health Condition': return l10n.activityHealthCondition;
//       case 'Accident': return l10n.activityAccident;
//       case 'Journal': return l10n.activityJournal;
//       default: return activityName;
//     }
//   }
//
//   Widget _buildImage() {
//     // Priority 1: Use imageBytes if available
//     if (imageBytes != null && imageBytes!.isNotEmpty) {
//       return Image.memory(
//         imageBytes!,
//         fit: BoxFit.cover,
//         width: 60,
//         height: 60,
//         errorBuilder: (_, __, ___) => _errorImage(),
//       );
//     }
//
//     // Priority 2: Use imageUrl if available
//     if (imageUrl != null && imageUrl!.isNotEmpty) {
//       if (imageUrl!.startsWith('http')) {
//         return Image.network(
//           imageUrl!,
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       } else if (File(imageUrl!).existsSync()) {
//         return Image.file(
//           File(imageUrl!),
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       } else {
//         return Image.asset(
//           imageUrl!,
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(),
//         );
//       }
//     }
//
//     // Fallback
//     return _errorImage();
//   }
//
//   Widget _errorImage() {
//     return Container(
//       color: CupertinoColors.systemGrey4,
//       child: const Icon(
//         CupertinoIcons.photo,
//         color: CupertinoColors.systemGrey,
//       ),
//     );
//   }
//
//   Widget _buildGridItem({
//     required int count,
//     required Color backgroundColor,
//     String? imageAsset,
//     IconData? icon, // fallback if asset missing
//     required String label,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 50.w,
//           height: 50.h,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: imageAsset != null
//                 ? Image.asset(
//               imageAsset,
//               width: 28.w,
//               height: 28.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, _, __) => Icon(
//                 icon ?? Icons.error,
//                 size: 24.sp,
//                 color: Colors.black54,
//               ),
//             )
//                 : Icon(
//               icon ?? Icons.image,
//               size: 24.sp,
//               color: Colors.black54,
//             ),
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w400,
//             fontSize: 12.sp,
//             color: const Color(0xFF272727),
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: 2.h),
//         Text(
//           '$count',
//           style: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w600,
//             fontSize: 16.sp,
//             color: const Color(0xFF272727),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/Valid/ActivityConstants.dart';
// //
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class PetCard extends StatelessWidget {
// //   final String? imageUrl;
// //   final String name;
// //   final String? petId;
// //   final Uint8List? imageBytes;
// //   final Map<String, int> activityCounts;
// //   final VoidCallback? onEditPressed;
// //   final bool showEditButton;
// //
// //   const PetCard({
// //     super.key,
// //     this.imageUrl,
// //     this.imageBytes,
// //     required this.name,
// //     this.petId,
// //     required this.activityCounts,
// //     this.onEditPressed,
// //     this.showEditButton = true,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: double.infinity,
// //       padding: EdgeInsets.only(bottom: 20.h),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF4F7F6),
// //         borderRadius: BorderRadius.circular(16.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: CupertinoColors.systemGrey.withOpacity(0.10),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.all(12.w),
// //             child: Row(
// //               children: [
// //                 Stack(
// //                   alignment: Alignment.center,
// //                   children: [
// //                     // Outer gradient circle
// //                     Container(
// //                       width: 68.w,
// //                       height: 68.h,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         gradient: LinearGradient(
// //                           colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                         ),
// //                       ),
// //                     ),
// //                     // White circle background for image
// //                     Container(
// //                       width: 60.w,
// //                       height: 60.h,
// //                       decoration: const BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: CupertinoColors.white,
// //                       ),
// //                       child: ClipOval(
// //                         child: _buildImage(),
// //                       ),
// //                     ),
// //                     // Edit button (replaces camera button)
// //                     if (showEditButton)
// //                       Positioned(
// //                         right: 0,
// //                         top: 0,
// //                         child: GestureDetector(
// //                           onTap: onEditPressed ?? () {
// //                             // Default edit action - navigate to edit screen
// //                             Navigator.pushNamed(
// //                               context,
// //                               RoutesName.edit,
// //                               arguments: {
// //                                 'isEditing': true,
// //                                 'petName': name,
// //                                 'petId': petId,
// //                                 'imageBytes': imageBytes,
// //                               },
// //                             );
// //                           },
// //                           child: Container(
// //                             padding: const EdgeInsets.all(4),
// //                             decoration: const BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black12,
// //                                   blurRadius: 4,
// //                                   offset: Offset(0, 2),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: const Icon(
// //                               CupertinoIcons.pencil,
// //                               size: 16,
// //                               color: AppColors.vibrantPurple,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //                 SizedBox(width: 12.w),
// //                 Text(
// //                   name,
// //                   style: TextStyle(
// //                     fontFamily: "Sora",
// //                     fontSize: 18.sp,
// //                     fontWeight: FontWeight.w600,
// //                     color: CupertinoColors.black,
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 Image.asset(
// //                   'assets/images/1233.png',
// //                   width: 118.w,
// //                   height: 73.h,
// //                 )
// //               ],
// //             ),
// //           ),
// //           const Divider(
// //             color: Color(0xFFCBE4DC),
// //             thickness: 1,
// //           ),
// //           SizedBox(height: 5.h),
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 2.w),
// //             child: Wrap(
// //               spacing: 12.w,
// //               runSpacing: 16.h,
// //               alignment: WrapAlignment.start,
// //               children: ActivityConstants.allActivities
// //                   .where((type) => (activityCounts[type.name] ?? 0) > 0)
// //                   .map((type) => _buildGridItem(
// //                 imageAsset: type.image,
// //                 count: activityCounts[type.name]!,
// //                 backgroundColor: type.color,
// //               ))
// //                   .toList(),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildImage() {
// //     // Priority 1: Use imageBytes if available
// //     if (imageBytes != null && imageBytes!.isNotEmpty) {
// //       return Image.memory(
// //         imageBytes!,
// //         fit: BoxFit.cover,
// //         width: 60,
// //         height: 60,
// //         errorBuilder: (_, __, ___) => _errorImage(),
// //       );
// //     }
// //
// //     // Priority 2: Use imageUrl if available
// //     if (imageUrl != null && imageUrl!.isNotEmpty) {
// //       if (imageUrl!.startsWith('http')) {
// //         return Image.network(
// //           imageUrl!,
// //           fit: BoxFit.cover,
// //           width: 60,
// //           height: 60,
// //           errorBuilder: (_, __, ___) => _errorImage(),
// //         );
// //       } else if (File(imageUrl!).existsSync()) {
// //         return Image.file(
// //           File(imageUrl!),
// //           fit: BoxFit.cover,
// //           width: 60,
// //           height: 60,
// //           errorBuilder: (_, __, ___) => _errorImage(),
// //         );
// //       } else {
// //         return Image.asset(
// //           imageUrl!,
// //           fit: BoxFit.cover,
// //           width: 60,
// //           height: 60,
// //           errorBuilder: (_, __, ___) => _errorImage(),
// //         );
// //       }
// //     }
// //
// //     // Fallback
// //     return _errorImage();
// //   }
// //
// //   Widget _errorImage() {
// //     return Container(
// //       color: CupertinoColors.systemGrey4,
// //       child: const Icon(
// //         CupertinoIcons.photo,
// //         color: CupertinoColors.systemGrey,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGridItem({
// //     required int count,
// //     required Color backgroundColor,
// //     String? imageAsset,
// //     IconData? icon, // fallback if asset missing
// //   }) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Container(
// //           width: 50.w,
// //           height: 50.h,
// //           decoration: BoxDecoration(
// //             color: backgroundColor,
// //             shape: BoxShape.circle,
// //           ),
// //           child: Center(
// //             child: imageAsset != null
// //                 ? Image.asset(
// //               imageAsset,
// //               width: 28.w,
// //               height: 28.h,
// //               fit: BoxFit.contain,
// //               errorBuilder: (context, _, __) => Icon(
// //                 icon ?? Icons.error,
// //                 size: 24.sp,
// //                 color: Colors.black54,
// //               ),
// //             )
// //                 : Icon(
// //               icon ?? Icons.image,
// //               size: 24.sp,
// //               color: Colors.black54,
// //             ),
// //           ),
// //         ),
// //         SizedBox(height: 6.h),
// //         Text(
// //           '$count',
// //           style: TextStyle(
// //             fontFamily: 'Sora',
// //             fontWeight: FontWeight.w600,
// //             fontSize: 16.sp,
// //             color: const Color(0xFF272727),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
