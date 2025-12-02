import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/common_input_field.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';

class Forgotpasswordemailview extends StatefulWidget {
  const Forgotpasswordemailview({super.key});

  @override
  State<Forgotpasswordemailview> createState() => _ForgotpasswordemailviewState();
}

class _ForgotpasswordemailviewState extends State<Forgotpasswordemailview> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Pre-fill with example email
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _emailController.text = 'abc@gmail.com';
      }
    });
  }
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
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
              SizedBox(height: 50.h),
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101010),
                  height: 1.20,
                  letterSpacing: 0.16,
                ),
              ),
              SizedBox(height: 11.h),
              Text(
                'Please enter your email to reset the password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff6d6d6d),
                  height: 1.5,
                  letterSpacing: -0.16,
                ),
              ),
              SizedBox(height: 38.h),
              Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              CommonInputField(
                controller: _emailController,
                currentFocusNode: _emailFocus,
                nextFocusNode: _emailFocus,
                hintText: 'Enter your email',
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
              SizedBox(height: 25.h),
              RoundButton(
                title: "Reset Password",
                height: 50.h,
                width: double.infinity,
                backgroundColors: AppColors.vibrantPurple,
                isSelected: true,
                onPress: () {
                  final email = _emailController.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your email'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (!_isValidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid email address'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  print('Reset password for: $email');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reset link sent to $email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamed(context, RoutesName.forgetCode);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

}