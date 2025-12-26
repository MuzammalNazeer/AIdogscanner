import 'dart:typed_data'; // Correct import
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final int photoCount;
  final int vaccineCount;
  final int clothesCount;
  final int calendarCount;
  final int medicalCount;
  final int profileCount;
  final Uint8List? imageBytes;

  final double photoProgress;
  final double vaccineProgress;
  final double clothesProgress;
  final double calendarProgress;
  final double medicalProgress;
  final double profileProgress;

  const PetCard({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.name,
    required this.photoCount,
    required this.vaccineCount,
    required this.clothesCount,
    required this.calendarCount,
    required this.medicalCount,
    required this.profileCount,
    required this.photoProgress,
    required this.vaccineProgress,
    required this.clothesProgress,
    required this.calendarProgress,
    required this.medicalProgress,
    required this.profileProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
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
                  const Positioned(right: 0, top: 0, child: _CameraButton()),
                ],
              ),
               SizedBox(width: 12.w),
              Text(
                name,
                style:  TextStyle(
                  fontFamily: "Sora",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/1233.png',
                width: 118.w,
                height: 73.h,
              )
            ],
          ),
          const Divider(
            color: Color(0xFFCBE4DC),
            thickness: 1,
          ),
           SizedBox(height: 10.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGridItem(
                    imageAsset: 'assets/images/2.png',
                    count: photoCount,
                    progress: photoProgress,
                    color: CupertinoColors.systemGreen,
                  ),
                  _buildGridItem(
                    imageAsset: 'assets/images/7.png',
                    count: vaccineCount,
                    progress: vaccineProgress,
                    color: CupertinoColors.systemRed,
                  ),
                  _buildGridItem(
                    imageAsset: 'assets/images/3.png',
                    count: medicalCount,
                    progress: medicalProgress,
                    color: CupertinoColors.white,
                  ),
                  _buildGridItem(
                    imageAsset: 'assets/images/0.png',
                    count: calendarCount,
                    progress: calendarProgress,
                    color: CupertinoColors.systemGreen,
                  ),
                  _buildGridItem(
                    imageAsset: 'assets/images/5.png',
                    count: clothesCount,
                    progress: clothesProgress,
                    color: CupertinoColors.systemOrange,
                  ),
                  _buildGridItem(
                    imageAsset: 'assets/images/4.png',
                    count: profileCount,
                    progress: profileProgress,
                    color: CupertinoColors.activeBlue,
                  ),
                ],
              ),
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
          errorBuilder: (_, __, ___) => _errorImage(),
        );
      } else {
        return Image.asset(
          imageUrl!,
          fit: BoxFit.cover,
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
    required double progress,
    required Color color,
    String? imageAsset,
    IconData? icon, // fallback if asset missing
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: imageAsset != null
                ? Image.asset(
              imageAsset,
              width: 32.w,
              height: 32.h,
              fit: BoxFit.contain,
              errorBuilder: (context, _, __) => Icon(
                icon ?? Icons.error,
                size: 32.sp,
                color: Colors.white,
              ),
            )
                : Icon(
              icon ?? Icons.image,
              size: 32.sp,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: Color(0xFF272727),
          ),
        ),
      ],
    );
  }




}

class _CameraButton extends StatelessWidget {
  const _CameraButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        CupertinoIcons.camera,
        size: 16,
        color: Color(0xFF9C27B0),
      ),
    );
  }
}

// // lib/config/components/pet_card.dart
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PetCard extends StatelessWidget {
//   final String imageUrl;
//   final String name;
//   final int photoCount;
//   final int vaccineCount;
//   final int clothesCount;
//   final int calendarCount;
//   final int medicalCount;
//   final int profileCount;
//
//   final double photoProgress;
//   final double vaccineProgress;
//   final double clothesProgress;
//   final double calendarProgress;
//   final double medicalProgress;
//   final double profileProgress;
//
//   const PetCard({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//     required this.photoCount,
//     required this.vaccineCount,
//     required this.clothesCount,
//     required this.calendarCount,
//     required this.medicalCount,
//     required this.profileCount,
//     required this.photoProgress,
//     required this.vaccineProgress,
//     required this.clothesProgress,
//     required this.calendarProgress,
//     required this.medicalProgress,
//     required this.profileProgress,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: CupertinoColors.systemGrey.withOpacity(0.10),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: 68,
//                     height: 68,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: CupertinoColors.white,
//                     ),
//                     child: ClipOval(child: _buildImage()),
//                   ),
//                   const Positioned(right: 0, top: 0, child: _CameraButton()),
//                 ],
//               ),
//               const SizedBox(width: 12),
//
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontFamily: "Sora",
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: CupertinoColors.black,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Container(
//             width: double.infinity,
//             height: 94,
//             decoration: const BoxDecoration(
//               color: Color(0xFFE9EFED),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(21),
//                 bottomRight: Radius.circular(21),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: IntrinsicHeight(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildGridItem(
//                       imageAsset: 'assets/images/2.png',
//                       count: photoCount,
//                       progress: photoProgress,
//                       color: CupertinoColors.systemGreen,
//                     ),
//                     VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
//                     _buildGridItem(
//                       imageAsset: 'assets/images/7.png',
//                       count: vaccineCount,
//                       progress: vaccineProgress,
//                       color: CupertinoColors.systemRed,
//                     ),
//                     VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
//                     _buildGridItem(
//                       imageAsset: 'assets/images/3.png',
//                       count: medicalCount,
//                       progress: medicalProgress,
//                       color: CupertinoColors.white,
//                     ),
//                     VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
//                     _buildGridItem(
//                       imageAsset: 'assets/images/0.png',
//                       count: calendarCount,
//                       progress: calendarProgress,
//                       color: CupertinoColors.systemGreen,
//                     ),
//                     VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
//                     _buildGridItem(
//                       imageAsset: 'assets/images/5.png',
//                       count: clothesCount,
//                       progress: clothesProgress,
//                       color: CupertinoColors.systemOrange,
//                     ),
//                     VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
//                     _buildGridItem(
//                       imageAsset: 'assets/images/4.png',
//                       count: profileCount,
//                       progress: profileProgress,
//                       color: CupertinoColors.activeBlue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   Widget _divider() {
//     return Container(
//       width: 2,
//       height: 94,
//       color: const Color(0xFFCBE4DC),
//     );
//   }
//   Widget _buildImage() {
//     if (imageUrl.startsWith('http')) {
//       return Image.network(
//         imageUrl,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _errorImage(),
//       );
//     } else {
//       return Image.asset(
//         imageUrl,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => _errorImage(),
//       );
//     }
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
//     required double progress,
//     required Color color,
//     String? imageAsset,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (imageAsset != null)
//             Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.contain),
//           const SizedBox(height: 10),
//           Text(
//             "$count",
//             style: const TextStyle(
//               fontFamily: "Sora",
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Color(0xFF272727),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15.5),
//               child: SizedBox(
//                 width: 31,
//                 height: 3,
//                 child: Stack(
//                   children: [
//                     // background track
//                     Container(
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(1),
//                         borderRadius: BorderRadius.circular(15.5),
//                       ),
//                     ),
//                     FractionallySizedBox(
//                       alignment: Alignment.centerLeft,
//                       widthFactor: progress.clamp(0.0, 1.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: color,
//                           borderRadius: BorderRadius.circular(15.5),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CameraButton extends StatelessWidget {
//   const _CameraButton();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: const BoxDecoration(
//         color: CupertinoColors.white,
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(
//         CupertinoIcons.camera,
//         size: 16,
//         color: Color(0xFF9C27B0),
//       ),
//     );
//   }
// }
