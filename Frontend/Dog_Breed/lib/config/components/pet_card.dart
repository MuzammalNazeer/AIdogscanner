import 'dart:io';
import 'dart:typed_data';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/Valid/ActivityConstants.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../View_model/activity_provider.dart';

class PetCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String? petId;
  final Uint8List? imageBytes;
  final Map<String, int> activityCounts;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final bool showEditButton;
  final DateTime? selectedDate;

  const PetCard({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.name,
    this.petId,
    required this.activityCounts,
    this.onEditPressed,
    this.onDeletePressed,
    this.showEditButton = true,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final DateTime effectiveDate = selectedDate ?? DateTime.now();
    final String dateLabel = DateFormat(
      'd MMM, yyyy',
      Localizations.localeOf(context).toString(),
    ).format(effectiveDate);

    // If a specific date is provided, compute activity counts for that date and pet
    final Map<String, int> effectiveCounts = selectedDate == null
        ? activityCounts
        : _computeCountsForDate(
            context: context,
            date: effectiveDate,
            petId: petId,
          );
    return Dismissible(
      key: ValueKey('petcard_${petId ?? name}_${imageBytes?.hashCode ?? 0}'),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.vibrantPurple,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.white, size: 24.sp),
            const SizedBox(width: 3,),
            Text(
              l10n?.actionEdit ?? 'Edit',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 16.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.white, size: 24.sp),
            const SizedBox(width: 3,),
            Text(
              l10n?.actionDelete ?? 'Delete',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 16.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (onEditPressed != null) {
            onEditPressed!();
          } else {
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
          }
          return false;
        } else {
          if (onDeletePressed != null) {
            onDeletePressed!();
            return false;
          }
          return false;
        }
      },
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).shadowColor.withOpacity(0.10),
        //     blurRadius: 10,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
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
                        // gradient: LinearGradient(
                        //   colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                      ),
                    ),
                    // White circle background for image
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                      ),
                      child: ClipOval(child: _buildImage(context)),
                    ),
                    // // Edit button (replaces camera button)
                    // if (showEditButton)
                    //   Positioned(
                    //     right: 0,
                    //     top: 0,
                    //     child: PopupMenuButton<String>(
                    //       padding: EdgeInsets.zero,
                    //       color: Theme.of(context).cardColor,
                    //       elevation: 4,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.r),
                    //       ),
                    //       onSelected: (value) {
                    //         if (value == 'edit') {
                    //           if (onEditPressed != null) {
                    //             onEditPressed!();
                    //           } else {
                    //             // Default edit action - navigate to edit screen
                    //             Navigator.pushNamed(
                    //               context,
                    //               RoutesName.edit,
                    //               arguments: {
                    //                 'isEditing': true,
                    //                 'petName': name,
                    //                 'petId': petId,
                    //                 'imageBytes': imageBytes,
                    //               },
                    //             );
                    //           }
                    //         } else if (value == 'delete') {
                    //           onDeletePressed?.call();
                    //         }
                    //       },
                    //       itemBuilder: (BuildContext context) =>
                    //       <PopupMenuEntry<String>>[
                    //         PopupMenuItem<String>(
                    //           value: 'edit',
                    //           child: Text(
                    //             l10n?.actionEdit ?? 'Edit',
                    //             style: TextStyle(
                    //               fontFamily: 'Sora',
                    //               fontSize: 16.sp,
                    //               color: Theme.of(
                    //                 context,
                    //               ).colorScheme.onSurface,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ),
                    //         PopupMenuDivider(
                    //           color: Theme.of(
                    //             context,
                    //           ).colorScheme.onPrimaryContainer,
                    //           thickness: 1,
                    //         ),
                    //         PopupMenuItem<String>(
                    //           value: 'delete',
                    //           child: Text(
                    //             l10n?.actionDelete ?? 'Delete',
                    //             style: TextStyle(
                    //               fontFamily: 'Sora',
                    //               fontSize: 16.sp,
                    //               color: Theme.of(
                    //                 context,
                    //               ).colorScheme.onSurface,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //       child: Container(
                    //         padding: const EdgeInsets.all(4),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           shape: BoxShape.circle,
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Theme.of(
                    //                 context,
                    //               ).shadowColor.withOpacity(0.12),
                    //               blurRadius: 4,
                    //               offset: const Offset(0, 2),
                    //             ),
                    //           ],
                    //         ),
                    //         child: const Icon(
                    //           Icons.more_vert,
                    //           size: 16,
                    //           color: AppColors.vibrantPurple,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
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
                      color: Theme.of(context).colorScheme.onSurface,
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
                ),
              ],
            ),
          ),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 18.w),
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              thickness: 1,
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF21241F)
                    : const Color(0xFFE8EEEC),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding:  const EdgeInsets.symmetric(vertical: 5,horizontal: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                '${AppLocalizations.of(context)!.today} ${AppLocalizations.of(context)!.calendarTabActivities}',
                      // selectedDate == null
                      //     // ? '${AppLocalizations.of(context)!.today} ${AppLocalizations.of(context)!.calendarTabActivities}'
                      //     // : AppLocalizations.of(context)!.calendarTabActivities,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.start,
              children: ActivityConstants.allActivities
                  .where((type) => (effectiveCounts[type.name] ?? 0) > 0)
                  .map(
                    (type) => _buildGridItem(
                  context,
                  imageAsset: type.image,
                  count: effectiveCounts[type.name]!,
                  backgroundColor: type.color,
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    ));
  }

  Map<String, int> _computeCountsForDate({
    required BuildContext context,
    required DateTime date,
    required String? petId,
  }) {
    final activities = Provider.of<ActivityNotifier>(context).activities;
    final Map<String, int> counts = {};

    for (final activity in activities) {
      final bool samePet = petId == null || activity.petId == petId;
      final bool sameDay = activity.dateTime.year == date.year &&
          activity.dateTime.month == date.month &&
          activity.dateTime.day == date.day;
      if (samePet && sameDay) {
        final key = activity.name;
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    return counts;
  }

  Widget _buildImage(BuildContext context) {
    // Priority 1: Use imageBytes if available
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
        errorBuilder: (_, __, ___) => _errorImage(context),
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
          errorBuilder: (_, __, ___) => _errorImage(context),
        );
      } else if (File(imageUrl!).existsSync()) {
        return Image.file(
          File(imageUrl!),
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _errorImage(context),
        );
      } else {
        return Image.asset(
          imageUrl!,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          errorBuilder: (_, __, ___) => _errorImage(context),
        );
      }
    }

    // Fallback
    return _errorImage(context);
  }

  Widget _errorImage(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(CupertinoIcons.photo, color: Theme.of(context).hintColor),
    );
  }

  Widget _buildGridItem(
      BuildContext context, {
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
                color: Theme.of(context).hintColor,
              ),
            )
                : Icon(
              icon ?? Icons.image,
              size: 24.sp,
              color: Theme.of(context).hintColor,
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
            color: Theme.of(context).colorScheme.onSurface,
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
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
//
// import '../../l10n/app_localizations.dart';
//
// class PetCard extends StatelessWidget {
//   final String? imageUrl;
//   final String name;
//   final String? petId;
//   final Uint8List? imageBytes;
//   final Map<String, int> activityCounts;
//   final VoidCallback? onEditPressed;
//   final VoidCallback? onDeletePressed;
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
//     this.onDeletePressed,
//     this.showEditButton = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: 20.h),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondaryContainer,
//         borderRadius: BorderRadius.circular(16.r),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Theme.of(context).shadowColor.withOpacity(0.10),
//         //     blurRadius: 10,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
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
//                         // gradient: LinearGradient(
//                         //   colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
//                         //   begin: Alignment.topLeft,
//                         //   end: Alignment.bottomRight,
//                         // ),
//                       ),
//                     ),
//                     // White circle background for image
//                     Container(
//                       width: 60.w,
//                       height: 60.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Theme.of(context).cardColor,
//                       ),
//                       child: ClipOval(child: _buildImage(context)),
//                     ),
//                     // Edit button (replaces camera button)
//                     if (showEditButton)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: PopupMenuButton<String>(
//                           padding: EdgeInsets.zero,
//                           color: Theme.of(context).cardColor,
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           onSelected: (value) {
//                             if (value == 'edit') {
//                               if (onEditPressed != null) {
//                                 onEditPressed!();
//                               } else {
//                                 // Default edit action - navigate to edit screen
//                                 Navigator.pushNamed(
//                                   context,
//                                   RoutesName.edit,
//                                   arguments: {
//                                     'isEditing': true,
//                                     'petName': name,
//                                     'petId': petId,
//                                     'imageBytes': imageBytes,
//                                   },
//                                 );
//                               }
//                             } else if (value == 'delete') {
//                               onDeletePressed?.call();
//                             }
//                           },
//                           itemBuilder: (BuildContext context) =>
//                               <PopupMenuEntry<String>>[
//                                 PopupMenuItem<String>(
//                                   value: 'edit',
//                                   child: Text(
//                                     l10n?.actionEdit ?? 'Edit',
//                                     style: TextStyle(
//                                       fontFamily: 'Sora',
//                                       fontSize: 16.sp,
//                                       color: Theme.of(
//                                         context,
//                                       ).colorScheme.onSurface,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 PopupMenuDivider(
//                                   color: Theme.of(
//                                     context,
//                                   ).colorScheme.onPrimaryContainer,
//                                   thickness: 1,
//                                 ),
//                                 PopupMenuItem<String>(
//                                   value: 'delete',
//                                   child: Text(
//                                     l10n?.actionDelete ?? 'Delete',
//                                     style: TextStyle(
//                                       fontFamily: 'Sora',
//                                       fontSize: 16.sp,
//                                       color: Theme.of(
//                                         context,
//                                       ).colorScheme.onSurface,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Theme.of(
//                                     context,
//                                   ).shadowColor.withOpacity(0.12),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.more_vert,
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
//                       color: Theme.of(context).colorScheme.onSurface,
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
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding:EdgeInsets.symmetric(horizontal: 18.w),
//             child: Divider(
//               color: Theme.of(context).colorScheme.onPrimaryContainer,
//               thickness: 1,
//             ),
//           ),
//           SizedBox(height: 5.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Container(
//               height: 30.h,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? const Color(0xFF21241F)
//                     : const Color(0xFFE8EEEC),
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Padding(
//                 padding:  const EdgeInsets.symmetric(vertical: 5,horizontal: 11),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${AppLocalizations.of(context)!.today} ${AppLocalizations.of(context)!.calendarTabActivities}',
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Theme.of(context).hintColor,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Inter',
//                       ),
//                     ),
//                     Text(
//                       DateFormat(
//                         'd MMM, yyyy',
//                         Localizations.localeOf(context).toString(),
//                       ).format(DateTime.now()),
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Theme.of(context).hintColor,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Inter',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Wrap(
//               spacing: 12.w,
//               runSpacing: 16.h,
//               alignment: WrapAlignment.start,
//               children: ActivityConstants.allActivities
//                   .where((type) => (activityCounts[type.name] ?? 0) > 0)
//                   .map(
//                     (type) => _buildGridItem(
//                       context,
//                       imageAsset: type.image,
//                       count: activityCounts[type.name]!,
//                       backgroundColor: type.color,
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImage(BuildContext context) {
//     // Priority 1: Use imageBytes if available
//     if (imageBytes != null && imageBytes!.isNotEmpty) {
//       return Image.memory(
//         imageBytes!,
//         fit: BoxFit.cover,
//         width: 60,
//         height: 60,
//         errorBuilder: (_, __, ___) => _errorImage(context),
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
//           errorBuilder: (_, __, ___) => _errorImage(context),
//         );
//       } else if (File(imageUrl!).existsSync()) {
//         return Image.file(
//           File(imageUrl!),
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(context),
//         );
//       } else {
//         return Image.asset(
//           imageUrl!,
//           fit: BoxFit.cover,
//           width: 60,
//           height: 60,
//           errorBuilder: (_, __, ___) => _errorImage(context),
//         );
//       }
//     }
//
//     // Fallback
//     return _errorImage(context);
//   }
//
//   Widget _errorImage(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.surfaceContainerHighest,
//       child: Icon(CupertinoIcons.photo, color: Theme.of(context).hintColor),
//     );
//   }
//
//   Widget _buildGridItem(
//     BuildContext context, {
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
//                     imageAsset,
//                     width: 28.w,
//                     height: 28.h,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, _, __) => Icon(
//                       icon ?? Icons.error,
//                       size: 24.sp,
//                       color: Theme.of(context).hintColor,
//                     ),
//                   )
//                 : Icon(
//                     icon ?? Icons.image,
//                     size: 24.sp,
//                     color: Theme.of(context).hintColor,
//                   ),
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           '$count',
//           style: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w600,
//             fontSize: 16.sp,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/Valid/ActivityConstants.dart';
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // import '../../l10n/app_localizations.dart';
// //
// // class PetCard extends StatelessWidget {
// //   final String? imageUrl;
// //   final String name;
// //   final String? petId;
// //   final Uint8List? imageBytes;
// //   final Map<String, int> activityCounts;
// //   final VoidCallback? onEditPressed;
// //   final VoidCallback? onDeletePressed;
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
// //     this.onDeletePressed,
// //     this.showEditButton = true,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final l10n = AppLocalizations.of(context);
// //     return Container(
// //       width: double.infinity,
// //       padding: EdgeInsets.only(bottom: 20.h),
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).colorScheme.secondaryContainer,
// //         borderRadius: BorderRadius.circular(16.r),
// //         // boxShadow: [
// //         //   BoxShadow(
// //         //     color: Theme.of(context).shadowColor.withOpacity(0.10),
// //         //     blurRadius: 10,
// //         //     offset: const Offset(0, 2),
// //         //   ),
// //         // ],
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
// //                         // gradient: LinearGradient(
// //                         //   colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
// //                         //   begin: Alignment.topLeft,
// //                         //   end: Alignment.bottomRight,
// //                         // ),
// //                       ),
// //                     ),
// //                     // White circle background for image
// //                     Container(
// //                       width: 60.w,
// //                       height: 60.h,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Theme.of(context).cardColor,
// //                       ),
// //                       child: ClipOval(
// //                         child: _buildImage(context),
// //                       ),
// //                     ),
// //                     // Edit button (replaces camera button)
// //                     if (showEditButton)
// //                       Positioned(
// //                         right: 0,
// //                         top: 0,
// //                         child: PopupMenuButton<String>(
// //                           padding: EdgeInsets.zero,
// //                           color: Theme.of(context).cardColor,
// //                           elevation: 4,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12.r),
// //                           ),
// //                           onSelected: (value) {
// //                             if (value == 'edit') {
// //                               if (onEditPressed != null) {
// //                                 onEditPressed!();
// //                               } else {
// //                                 // Default edit action - navigate to edit screen
// //                                 Navigator.pushNamed(
// //                                   context,
// //                                   RoutesName.edit,
// //                                   arguments: {
// //                                     'isEditing': true,
// //                                     'petName': name,
// //                                     'petId': petId,
// //                                     'imageBytes': imageBytes,
// //                                   },
// //                                 );
// //                               }
// //                             } else if (value == 'delete') {
// //                               onDeletePressed?.call();
// //                             }
// //                           },
// //                           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
// //                             PopupMenuItem<String>(
// //                               value: 'edit',
// //                               child: Text(
// //                                 l10n?.actionEdit ?? 'Edit',
// //                                 style: TextStyle(
// //                                   fontFamily: 'Sora',
// //                                   fontSize: 16.sp,
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                              PopupMenuDivider(
// //                               color: Theme.of(context).colorScheme.onPrimaryContainer,
// //                                thickness: 1,
// //                             ),
// //                             PopupMenuItem<String>(
// //                               value: 'delete',
// //                               child: Text(
// //                                 l10n?.actionDelete ?? 'Delete',
// //                                 style: TextStyle(
// //                                   fontFamily: 'Sora',
// //                                   fontSize: 16.sp,
// //                                   color: Theme.of(context).colorScheme.onSurface,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                           child: Container(
// //                             padding: const EdgeInsets.all(4),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Theme.of(context).shadowColor.withOpacity(0.12),
// //                                   blurRadius: 4,
// //                                   offset: const Offset(0, 2),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: const Icon(
// //                               Icons.more_vert,
// //                               size: 16,
// //                               color: AppColors.vibrantPurple,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //                 SizedBox(width: 12.w),
// //                 Expanded(
// //                   child: Text(
// //                     name,
// //                     style: TextStyle(
// //                       fontFamily: "Sora",
// //                       fontSize: 18.sp,
// //                       fontWeight: FontWeight.w600,
// //                       color: Theme.of(context).colorScheme.onSurface,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     maxLines: 1,
// //                   ),
// //                 ),
// //                 SizedBox(width: 8.w),
// //                 Image.asset(
// //                   'assets/images/1233.png',
// //                   width: 118.w,
// //                   height: 73.h,
// //                 )
// //               ],
// //             ),
// //           ),
// //            Divider(
// //             color: Theme.of(context).colorScheme.onPrimaryContainer,
// //             thickness: 1,
// //           ),
// //           SizedBox(height: 5.h),
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 18.w),
// //             child: Wrap(
// //               spacing: 12.w,
// //               runSpacing: 16.h,
// //               alignment: WrapAlignment.start,
// //               children: ActivityConstants.allActivities
// //                   .where((type) => (activityCounts[type.name] ?? 0) > 0)
// //                   .map((type) => _buildGridItem(
// //                 context,
// //                 imageAsset: type.image,
// //                 count: activityCounts[type.name]!,
// //                 backgroundColor: type.color,
// //               )).toList(),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildImage(BuildContext context) {
// //     // Priority 1: Use imageBytes if available
// //     if (imageBytes != null && imageBytes!.isNotEmpty) {
// //       return Image.memory(
// //         imageBytes!,
// //         fit: BoxFit.cover,
// //         width: 60,
// //         height: 60,
// //         errorBuilder: (_, __, ___) => _errorImage(context),
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
// //           errorBuilder: (_, __, ___) => _errorImage(context),
// //         );
// //       } else if (File(imageUrl!).existsSync()) {
// //         return Image.file(
// //           File(imageUrl!),
// //           fit: BoxFit.cover,
// //           width: 60,
// //           height: 60,
// //           errorBuilder: (_, __, ___) => _errorImage(context),
// //         );
// //       } else {
// //         return Image.asset(
// //           imageUrl!,
// //           fit: BoxFit.cover,
// //           width: 60,
// //           height: 60,
// //           errorBuilder: (_, __, ___) => _errorImage(context),
// //         );
// //       }
// //     }
// //
// //     // Fallback
// //     return _errorImage(context);
// //   }
// //
// //   Widget _errorImage(BuildContext context) {
// //     return Container(
// //       color: Theme.of(context).colorScheme.surfaceContainerHighest,
// //       child: Icon(
// //         CupertinoIcons.photo,
// //         color: Theme.of(context).hintColor,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGridItem(BuildContext context, {
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
// //                 color: Theme.of(context).hintColor,
// //               ),
// //             )
// //                 : Icon(
// //               icon ?? Icons.image,
// //               size: 24.sp,
// //               color: Theme.of(context).hintColor,
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
// //             color: Theme.of(context).colorScheme.onSurface,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// //
