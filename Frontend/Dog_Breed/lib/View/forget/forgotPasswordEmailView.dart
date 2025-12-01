import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/common_input_field.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';

class Forgotpasswordemail extends StatefulWidget {
  const Forgotpasswordemail({super.key});

  @override
  State<Forgotpasswordemail> createState() => _ForgotpasswordemailState();
}

class _ForgotpasswordemailState extends State<Forgotpasswordemail> {
  final TextEditingController _emailController = TextEditingController();
  final _emailFocus=FocusNode();
  @override
  void initState() {

    _emailController.dispose();
    _emailFocus.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40.305.w,
                  height: 40.305.h,
                  padding: const EdgeInsets.all(8.96),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F3),
                    borderRadius: BorderRadius.circular(8.96),
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
             SizedBox(height: 16.h),
             Text(
              'Please enter your email to reset the password',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Email',
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
            const SizedBox(height: 8),
            CommonInputField(
              controller: _emailController,
              currentFocusNode: _emailFocus,
              nextFocusNode:_emailFocus ,
              hintText: 'abc@gmail.com',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            RoundButton(
              title: "Reset Password",
              height: 50,
              width: 379,
              backgroundColors: AppColors.vibrantPurple,
              isSelected: true,
              onPress: () {
                // Navigator.pushNamed(context, RoutesName.dashboard);
              },
            ),

          ],
        ),
      ),
    );
  }

  // Email validation method
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}