import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';

class Confirmpasswordview extends StatefulWidget {
  const Confirmpasswordview({super.key});

  @override
  State<Confirmpasswordview> createState() => _ConfirmpasswordviewState();
}

class _ConfirmpasswordviewState extends State<Confirmpasswordview> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: EdgeInsets.all(8.96.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(8.96.r),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_left,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 51.h),
              Text(
                'Password Reset',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101010),
                  height: 1.20,
                  letterSpacing: -0.16,
                ),
              ),
              SizedBox(height: 11.h),
              Text(
                'Your password has been successfully reset. click \nconfirm to set a new password',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 14.sp,
                  color: const Color(0xff6d6d6d),
                  height: 1.20,
                  letterSpacing: -0.16,
                ),
              ),
              SizedBox(height: 117.h),
              RoundButton(
                title: "Confirm",
                height: 50.h,
                width: double.infinity,
                backgroundColors: AppColors.vibrantPurple,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, RoutesName.newPassword);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
