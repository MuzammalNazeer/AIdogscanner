import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/common_input_field.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';
class Newpasswordview extends StatefulWidget {
  const Newpasswordview({super.key});

  @override
  State<Newpasswordview> createState() => _NewpasswordviewState();
}

class _NewpasswordviewState extends State<Newpasswordview> {

  final  TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final  TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Set a New Password',
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
                'Create a new password. Ensure it differs from \nprevious ones for security',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 14.sp,
                  color: const Color(0xff6d6d6d),
                  letterSpacing: -0.16,
                ),
                maxLines: 2,
              ),
              SizedBox(height:  21.h),
              Text(
                'Password',
                style:  TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height:  9.h),
              CommonInputField(
                controller: _passwordController,
                currentFocusNode: _passwordFocus,
                nextFocusNode: null,
                hintText: '••••••••',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },

              ),
              SizedBox(height:  17.h),
              Text(
                'confirmPassword',
                style:  TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height:  9.h),
              CommonInputField(
                controller: _confirmPasswordController,
                currentFocusNode: _confirmPasswordFocus,
                nextFocusNode: null,
                hintText: '••••••••',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },

              ),
              SizedBox(height: 22.h),
              RoundButton(
                title: "Update Password",
                height: 50.h,
                width: double.infinity,
                backgroundColors: AppColors.vibrantPurple,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, RoutesName.login);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
