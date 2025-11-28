// lib/config/components/HygieneCard.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HygieneCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final Color iconColor; // For circle tint only
  final Color backgroundColors; // For card background
  final bool hasReminder;
  final String note;
  final VoidCallback onReminderTap;
  final ValueChanged<String> onAddNote;


  const HygieneCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.iconColor,
    this.backgroundColors = Colors.white,
    required this.hasReminder,
    required this.note,
    required this.onReminderTap,
    required this.onAddNote,
  });

  @override
  State<HygieneCard> createState() => _HygieneCardState();
}

class _HygieneCardState extends State<HygieneCard> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note);
  }

  @override
  void didUpdateWidget(covariant HygieneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note != widget.note) {
      _noteController.text = widget.note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 411.w,
      height: 161.h,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: CupertinoColors.systemGrey.withOpacity(0.1),
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      widget.imagePath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        size: 10,
                        color: CupertinoColors.systemRed,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Title
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
              ),

              Container(
                width: 144.w,
                height: 35.225.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.transparent,
                  onPressed: widget.onReminderTap,
                  child: Row( // REMOVED Expanded from here
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 18.sp,
                        color: const Color(0xFF05E584),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Add Reminder',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF05E584),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // === ROW 2: Notes + Add (inside) ===
          Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CupertinoTextField(
                      controller: _noteController,
                      placeholder: 'Make Notes',
                      padding: const EdgeInsets.only(
                        left: 14,
                        top: 12,
                        bottom: 12,
                        right: 80,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E8E5),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.transparent),
                      ),
                      style: TextStyle(fontSize: 15.sp),
                      onSubmitted: widget.onAddNote,
                    ),
                    Positioned(
                      right: 8,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minSize: 0,
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: CupertinoColors.systemGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => widget.onAddNote(_noteController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// // lib/config/components/HygieneCard.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class HygieneCard extends StatefulWidget {
//   final String imagePath;
//   final String title;
//   final Color iconColor; // For circle tint only
//   final Color backgroundColors; // For card background
//   final bool hasReminder;
//   final String note;
//   final VoidCallback onReminderTap;
//   final ValueChanged<String> onAddNote;
//
//   const HygieneCard({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.iconColor,
//     this.backgroundColors = Colors.white,
//     required this.hasReminder,
//     required this.note,
//     required this.onReminderTap,
//     required this.onAddNote,
//   });
//
//   @override
//   State<HygieneCard> createState() => _HygieneCardState();
// }
//
// class _HygieneCardState extends State<HygieneCard> {
//   late TextEditingController _noteController;
//
//   @override
//   void initState() {
//     super.initState();
//     _noteController = TextEditingController(text: widget.note);
//   }
//
//   @override
//   void didUpdateWidget(covariant HygieneCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.note != widget.note) {
//       _noteController.text = widget.note;
//     }
//   }
//
//   @override
//   void dispose() {
//     _noteController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 411.w,
//       height: 161.h,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4F7F6),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: CupertinoColors.systemGrey.withOpacity(0.1),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 64.w,
//                 height: 64.h,
//                 decoration: BoxDecoration(
//                   color: widget.iconColor.withOpacity(0.6),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: ClipOval(
//                     child: Image.asset(
//                       widget.imagePath,
//                       width: 24,
//                       height: 24,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) => const Icon(
//                         CupertinoIcons.exclamationmark_triangle,
//                         size: 10,
//                         color: CupertinoColors.systemRed,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//                SizedBox(width: 12.w),
//               // Title
//               Expanded(
//                 child: Text(
//                   widget.title,
//                   style:  TextStyle(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w600,
//                     color: CupertinoColors.black,
//                   ),
//                 ),
//               ),
//
//               Container(
//                 width: 144.w,
//                 height: 35.225.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.r),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x0D000000),
//                       offset: Offset(2, 2),
//                       blurRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: CupertinoButton(
//                   padding: const EdgeInsets.all(8),
//                   borderRadius: BorderRadius.circular(8.r),
//                   color: Colors.transparent,
//                   onPressed: widget.onReminderTap,
//                   child: Expanded(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           CupertinoIcons.clock,
//                           size: 18.sp,
//                           color: const Color(0xFF05E584),
//                         ),
//                         SizedBox(width: 6.w),
//                         Text(
//                           'Add Reminder',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: const Color(0xFF05E584),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),          ],
//           ),
//            SizedBox(height: 16.h),
//           // === ROW 2: Notes + Add (inside) ===
//           Row(
//             children: [
//               Expanded(
//                 child: Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     CupertinoTextField(
//                       controller: _noteController,
//                       placeholder: 'Make Notes',
//                       padding: const EdgeInsets.only(
//                         left: 14,
//                         top: 12,
//                         bottom: 12,
//                         right: 80,
//                       ),
//                       decoration: BoxDecoration(
//                         color: CupertinoColors.systemGrey5,
//                         borderRadius: BorderRadius.circular(10.r),
//                         border: Border.all(color: Colors.transparent),
//                       ),
//                       style:  TextStyle(fontSize: 15.sp),
//                       onSubmitted: widget.onAddNote,
//                     ),
//                     Positioned(
//                       right: 8,
//                       child: CupertinoButton(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         minSize: 0,
//                         color: CupertinoColors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         child:  Text(
//                           'Add',
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             color: CupertinoColors.systemGreen,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         onPressed: () => widget.onAddNote(_noteController.text),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
