import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/common_input_field.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Signupview extends StatefulWidget {
  const Signupview({super.key});

  @override
  State<Signupview> createState() => _LoginViewState();
}

class _LoginViewState extends State<Signupview> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  // Focus Nodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }
  bool _showFullText = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 28.w, vertical: 76.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  SizedBox(height: 36.h),
                  Text(
                    'Create New Account',
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
                  SizedBox(height: 23.h),
                  Text(
                    'UserName',
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
                    controller: _usernameController,
                    currentFocusNode: _usernameFocus,
                    nextFocusNode: _emailFocus,
                    hintText: 'username',
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
                  SizedBox(height: 9.h),
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
                  SizedBox(height:  9.h),
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
                  SizedBox(height:  9.h),
                  Text(
                    'confirm Password',
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
                    nextFocusNode: _confirmPasswordFocus,
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
                  SizedBox(height:  9.h),
                  Text(
                    'FullName',
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
                    controller: _fullNameController,
                    currentFocusNode: _fullNameFocus,
                    nextFocusNode: _fullNameFocus,
                    hintText: 'fullName',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Checkbox(
                        checkColor: const Color(0xFFF5F5F5),
                        activeColor: AppColors.vibrantPurple,
                        value: _showFullText,
                        onChanged: (bool? value) {
                          setState(() {
                            _showFullText = value ?? false;

                          });
                        },
                      ),
                       Text.rich(
                        TextSpan(
                          text: "I want to receive calls and emails from invoice Simple and\nits Affiliates about.... ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF878787),
                            height: 1.23,
                            letterSpacing: -0.16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Show More',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF6B97E8),
                              ),
                            ),
                          ],
                        ),

                      ),
                    ],
                  ),
                  SizedBox(height:28.h ),
                  RoundButton(
                    title: "Create Account",
                    height: 50,
                    width: 379,
                    backgroundColors: AppColors.vibrantPurple,
                    isSelected: true,
                    onPress: () {
                      // Navigator.pushNamed(context, RoutesName.dashboard);
                    },
                  ),
                  SizedBox(height: 26.h),
                  Center(
                    child: Text(
                      'Have Account',
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
                  SizedBox(height: 14.h),
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
                  SizedBox(height: 13.h),
                  RoundButton(
                    title: "LOGIN",
                    height: 50,
                    width: 379,
                    backgroundColors: AppColors.black,
                    isSelected: true,
                    onPress: () {
                      Navigator.pushNamed(context, RoutesName.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}