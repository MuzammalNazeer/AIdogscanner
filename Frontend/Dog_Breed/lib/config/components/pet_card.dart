// lib/config/components/pet_card.dart
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int photoCount;
  final int vaccineCount;
  final int clothesCount;
  final int calendarCount;
  final int medicalCount;
  final int profileCount;

  final double photoProgress;
  final double vaccineProgress;
  final double clothesProgress;
  final double calendarProgress;
  final double medicalProgress;
  final double profileProgress;

  const PetCard({
    super.key,
    required this.imageUrl,
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
        color: Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(16),
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
                    width: 68,
                    height: 68,
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
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.white,
                    ),
                    child: ClipOval(child: _buildImage()),
                  ),
                  const Positioned(right: 0, top: 0, child: _CameraButton()),
                ],
              ),
              const SizedBox(width: 12),

              Text(
                name,
                style: const TextStyle(
                  fontFamily: "Sora",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 94,
            decoration: const BoxDecoration(
              color: Color(0xFFE9EFED),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
                    _buildGridItem(
                      imageAsset: 'assets/images/7.png',
                      count: vaccineCount,
                      progress: vaccineProgress,
                      color: CupertinoColors.systemRed,
                    ),
                    VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
                    _buildGridItem(
                      imageAsset: 'assets/images/3.png',
                      count: medicalCount,
                      progress: medicalProgress,
                      color: CupertinoColors.white,
                    ),
                    VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
                    _buildGridItem(
                      imageAsset: 'assets/images/0.png',
                      count: calendarCount,
                      progress: calendarProgress,
                      color: CupertinoColors.systemGreen,
                    ),
                    VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
                    _buildGridItem(
                      imageAsset: 'assets/images/5.png',
                      count: clothesCount,
                      progress: clothesProgress,
                      color: CupertinoColors.systemOrange,
                    ),
                    VerticalDivider(color: Color(0xFFCBE4DC), thickness: 1),
                    _buildGridItem(
                      imageAsset: 'assets/images/4.png',
                      count: profileCount,
                      progress: profileProgress,
                      color: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _divider() {
    return Container(
      width: 2,
      height: 94,
      color: const Color(0xFFCBE4DC),
    );
  }
  Widget _buildImage() {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorImage(),
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorImage(),
      );
    }
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
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageAsset != null)
            Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            "$count",
            style: const TextStyle(
              fontFamily: "Sora",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF272727),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.5),
              child: SizedBox(
                width: 31,
                height: 3,
                child: Stack(
                  children: [
                    // background track
                    Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(1),
                        borderRadius: BorderRadius.circular(15.5),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: CupertinoColors.white,
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
//                   const Positioned(
//                     right: 0,
//                     top: 0,
//                     child: _CameraButton(),
//                   ),
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
//           const SizedBox(height: 16),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 3,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 117 / 61,
//             children: [
//               _buildGridItem(
//                 imageAsset: 'assets/images/2.png',
//                 count: photoCount,
//                 progress: photoProgress,
//                 color: CupertinoColors.systemGreen,
//               ),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.pushNamed(context, RoutesName.hygiene);
//                 },
//                 child: _buildGridItem(
//                   imageAsset: 'assets/images/7.png',
//                   count: vaccineCount,
//                   progress: vaccineProgress,
//                   color: CupertinoColors.systemRed,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.pushNamed(context, RoutesName.cleaning);
//                 },
//                 child: _buildGridItem(
//                   imageAsset: 'assets/images/3.png',
//                   count: clothesCount,
//                   progress: clothesProgress,
//                   color: CupertinoColors.systemOrange,
//                 ),
//               ),
//               _buildGridItem(
//                 imageAsset: 'assets/images/0.png',
//                 count: calendarCount,
//                 progress: calendarProgress,
//                 color: CupertinoColors.systemGreen,
//               ),
//               _buildGridItem(
//                 imageAsset: 'assets/images/5.png',
//                 count: medicalCount,
//                 progress: medicalProgress,
//                 color: CupertinoColors.white,
//               ),
//               _buildGridItem(
//                 imageAsset: 'assets/images/4.png',
//                 count: profileCount,
//                 progress: profileProgress,
//                 color: CupertinoColors.activeBlue,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
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
//       child: const Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey),
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
//     return Container(
//       width: 117,
//       height: 61,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: CupertinoColors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: CupertinoColors.systemGrey.withOpacity(0.18),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               if (imageAsset != null)
//                 Image.asset(
//                   imageAsset,
//                   width: 20,
//                   height: 20,
//                   fit: BoxFit.contain,
//                 ),
//               const SizedBox(width: 30),
//               Text(
//                 "$count",
//                 style: const TextStyle(
//                   fontFamily: "Sora",
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Color(0xFF272727),
//                 ),
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15.5),
//               child: Container(
//                 width: 31,
//                 height: 3,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(1),
//                   borderRadius: BorderRadius.circular(15.5),
//                 ),
//                 child: FractionallySizedBox(
//                   alignment: Alignment.centerLeft,
//                   widthFactor: progress.clamp(0.0, 1.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(15.5),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//
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
//
