import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final Color textColors;
  final Color? borderColors;
  final bool loading;
  final VoidCallback onPress;
  final bool isOutline;
  final bool isSelected;
  final Icon? icon;
  final bool hasIcons;
  final bool isTrailingIcon; // New parameter
  final double? width;
  final double? height;
  final double borderRadius;
  final Color backgroundColors;
  final MainAxisAlignment mainAxisAlignment; // New parameter
  final VoidCallback? onIconPress; // New parameter for specific icon action

  const RoundButton({
    super.key,
    required this.title,
    this.loading = false,
    required this.onPress,
    this.isOutline = false,
    this.isSelected = false,
    this.icon,
    this.backgroundColors = Colors.amber,
    this.hasIcons = false,
    this.isTrailingIcon = false, // Default false
    this.textColors = Colors.white,
    this.borderColors,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.mainAxisAlignment = MainAxisAlignment.center, // Default center
    this.onIconPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Added padding for better spacing
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : (isSelected ? backgroundColors : Colors.white),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColors ?? (isOutline // Updated border logic
                ? Colors.grey
                : (isSelected ? backgroundColors : Colors.white)),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (hasIcons && !isTrailingIcon) ...[
                if (onIconPress != null)
                  GestureDetector(
                    onTap: onIconPress,
                    child: icon!,
                  )
                else
                  icon!,
                const SizedBox(width: 10),
              ],
              loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Flexible( // Added Flexible
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                        style: TextStyle(
                          color: isOutline ? textColors : (isSelected ? textColors : Colors.blue),
                          fontSize: 20.h,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',// Slightly bolder
                        ),
                      ),
                    ),
              if (hasIcons && isTrailingIcon) ...[
                const SizedBox(width: 10),
                if (onIconPress != null)
                  GestureDetector(
                    onTap: onIconPress,
                    child: icon!,
                  )
                else
                  icon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}



//
// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// class RoundButton extends StatelessWidget {
//   final String title;
//   final Color textColors;
//   final Color? borderColors;
//   final bool loading;
//   final VoidCallback onPress;
//   final bool isOutline;
//   final bool isSelected;
//   final Icon? icon;
//   final bool hasIcons;
//   final double? width;
//   final Color backgroundColors;
//
//   const RoundButton({
//     super.key,
//     required this.title,
//     this.loading = false,
//     required this.onPress,
//     this.isOutline = false,
//     this.isSelected = false,
//     this.icon,
//     this.backgroundColors = Colors.amber,
//     this.hasIcons = false,
//     this.textColors = Colors.white,
//     this.borderColors,
//     this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: loading ? null : onPress,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: isOutline ? Colors.white : (isSelected ? backgroundColors : Colors.white),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isOutline
//                 ? borderColors ?? Colors.grey
//                 : (isSelected ? backgroundColors : Colors.white),
//           ),
//         ),
//         child: Center(
//           child: FittedBox(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (hasIcons) ...[
//                   icon!,
//                   const SizedBox(width: 10),
//                 ],
//                 loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       color: isOutline ? textColors : (isSelected ? textColors : Colors.blue),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//       ),
//     );
//   }
// }
