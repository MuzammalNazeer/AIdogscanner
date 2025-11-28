import 'package:flutter/material.dart';

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
  final double? width;
  final double? height;
  final double borderRadius;
  final Color backgroundColors;

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
    this.textColors = Colors.white,
    this.borderColors,
    this.width,
    this.height,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : (isSelected ? backgroundColors : Colors.white),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isOutline
                ? borderColors ?? Colors.grey
                : (isSelected ? backgroundColors : Colors.white),
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasIcons) ...[
                  icon!,
                  const SizedBox(width: 10),
                ],
                loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isOutline ? textColors : (isSelected ? textColors : Colors.blue),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
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
