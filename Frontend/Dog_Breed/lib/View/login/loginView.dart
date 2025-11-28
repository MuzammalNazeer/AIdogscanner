import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/common_input_field.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Focus Nodes
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 22,right: 21,top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 85,right: 65),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/Group2.svg",
                          width: 72.w,
                          height: 37.h,
                          fit: BoxFit.contain,
                        ),
                         SizedBox(width: 3.w),
                        Text(
                          'Manager',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.normal,
                            fontSize: 30.sp,
                            height: 1.0,
                            letterSpacing: 0.0,
                            color: AppColors.jet,
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 41.h),
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 26.sp,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: AppColors.vibrantPurple,
                    ),
                  ),
                   SizedBox(height: 24.h),
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
                   SizedBox(height: 9.h),
                  CommonInputField(
                    controller: _emailController,
                    currentFocusNode: _emailFocus,
                    nextFocusNode: _passwordFocus,
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
                   SizedBox(height:  5.h),
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
                   SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: RichText(
                        textAlign: TextAlign.right,
                        text:  TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot Password? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                height: 1.0,
                                letterSpacing: 0.0,
                                color: const Color(0xFF1F2029),
                              ),
                            ),
                            TextSpan(
                              text: 'Click Here',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                height: 1.0,
                                letterSpacing: 0.0,
                                color: const Color(0xFF0084FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height:25.h ),
                  RoundButton(
                    title: "LOGIN",
                    height: 50,
                    width: 379,
                    backgroundColors: AppColors.vibrantPurple,
                    isSelected: true,
                    onPress: () {
                      Navigator.pushNamed(context, RoutesName.dashboard);
                    },
                  ),
                   SizedBox(height: 34.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey[600],fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                   SizedBox(height: 20.h),
                  _buildSocialButton(
                    iconWidget: Image.asset(
                      'assets/images/image 43.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    label: 'Login with Gmail',
                    onTap: () {
                    },
                  ),
                   SizedBox(height:10.h ),
                  _buildSocialButton(
                    iconWidget: Image.asset(
                      'assets/images/image 44.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    label: 'Login with Apple',
                    onTap: () {
                    },
                  ),
                   SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      'Create New Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                        height: 1.0,
                        letterSpacing: 0.0,
                        color: AppColors.vibrantPurple,
                      ),
                    ),
                  ),
                   SizedBox(height: 10.h),
                   Text(
                    'By continuing you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 1.23,
                      letterSpacing: -0.16,
                      color: const Color(0xFF878787),
                    ),
                  ),
                   SizedBox(height: 20.h),
                  RoundButton(
                    title: "CREATE NEW ACCOUNT",
                    height: 50,
                    width: 379,
                    backgroundColors: AppColors.black,
                    isSelected: true,
                    onPress: () {
                      // Navigator.pushNamed(context, RoutesName.dashboard);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSocialButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.platinumGray,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 75,right: 45),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                alignment: Alignment.center,
                child: iconWidget,
              ),
               SizedBox(width: 7.w),
              Text(
                label,
                textAlign: TextAlign.right,
                style:  TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.h,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: AppColors.black,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



}