import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrialButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool isSelected;

  const TrialButton({
    Key? key,
    required this.title,
    required this.onPress,
    this.isSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 62.h,
        width: 379.w,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.onBackground : Colors.grey,
          borderRadius: BorderRadius.circular(41.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
