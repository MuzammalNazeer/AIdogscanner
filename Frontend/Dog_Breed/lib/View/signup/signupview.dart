import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/common_input_field.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../database/DatabaseHelper.dart';

class Signupview extends StatefulWidget {
  const Signupview({super.key});

  @override
  State<Signupview> createState() => _SignupviewState();
}

class _SignupviewState extends State<Signupview> {
  final _formKey = GlobalKey<FormState>();

  bool _isChecked = false;
  bool _showFullText = false;
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  // Focus Nodes
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();

    // Dispose focus nodes
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _fullNameFocus.dispose();

    super.dispose();
  }

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _performSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the terms')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _dbHelper.insertUser({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'full_name': _fullNameController.text.trim(),
      });

      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Account created successfully!')),
        // );
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 30.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Group2.svg",
                      width: 72.w,
                      height: 39.h,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Manager',
                      style: TextStyle(fontSize: 39.sp, color: AppColors.jet),
                    ),
                  ],
                ),
                SizedBox(height: 36.h),
                Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.vibrantPurple,
                  ),
                ),
                SizedBox(height: 23.h),

                Text('Username', style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _usernameController,
                  currentFocusNode: _usernameFocus,
                  hintText: 'username',
                  validator: (v) => v!.trim().isEmpty ? 'Enter username' : null,
                ),

                SizedBox(height: 9.h),
                Text('Email', style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _emailController,
                  currentFocusNode: _emailFocus,
                  hintText: 'abc@gmail.com',
                  validator: (v) =>
                  v!.trim().isEmpty ||
                      !RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(v.trim())
                      ? 'Enter valid email'
                      : null,
                ),

                SizedBox(height: 9.h),
                Text('Password', style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _passwordController,
                  currentFocusNode: _passwordFocus,
                  obscureText: true,
                  hintText: '••••••••',
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                ),

                SizedBox(height: 9.h),
                Text('Confirm Password', style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _confirmPasswordController,
                  currentFocusNode: _confirmPasswordFocus,
                  obscureText: true,
                  hintText: '••••••••',
                  validator: (v) => v!.isEmpty ? 'Confirm password' : null,
                ),

                SizedBox(height: 9.h),
                Text('Full Name', style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _fullNameController,
                  currentFocusNode: _fullNameFocus,
                  hintText: 'John Doe',
                  validator: (v) =>
                  v!.trim().isEmpty ? 'Enter full name' : null,
                ),

                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 21.w,
                      height: 21.h,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        activeColor: AppColors.vibrantPurple,
                        checkColor: Colors.white,
                        value: _isChecked,
                        onChanged: (v) =>
                            setState(() => _isChecked = v ?? false),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: _showFullText
                              ? "I want to receive calls and emails from Invoice Simple and its Affiliates about products, services, news, surveys, and offers. I can unsubscribe at any time."
                              : "I want to receive calls and emails from Invoice Simple and\nits Affiliates about.... ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF878787),
                            height: 1.23,
                          ),
                          children: _showFullText
                              ? null
                              : [
                            TextSpan(
                              text: 'Show More',
                              style: const TextStyle(
                                color: Color(0xFF6B97E8),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    setState(() => _showFullText = true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28.h),
                RoundButton(
                  title: "Create Account",
                  height: 55.h,
                  backgroundColors: AppColors.vibrantPurple,
                  isSelected: true,
                  onPress: _performSignup,
                ),
                SizedBox(height: 26.h),
                Center(
                  child: Text(
                    'Have Account',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.vibrantPurple,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'By continuing you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF878787),
                  ),
                ),
                SizedBox(height: 13.h),
                RoundButton(
                  title: "LOGIN",
                  height: 55.h,
                  backgroundColors: AppColors.black,
                  isSelected: true,
                  onPress: () => Navigator.pushNamed(context, RoutesName.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/common_input_field.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
//
// class Signupview extends StatefulWidget {
//   const Signupview({super.key});
//
//   @override
//   State<Signupview> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<Signupview> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isChecked = false;
//
//   // Controllers
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//
//   // Focus Nodes
//   final FocusNode _emailFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//   final FocusNode _confirmPasswordFocus = FocusNode();
//   final FocusNode _usernameFocus = FocusNode();
//   final FocusNode _fullNameFocus = FocusNode();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose();
//     _fullNameController.dispose();
//     _confirmPasswordController.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     _confirmPasswordFocus.dispose();
//     super.dispose();
//   }
//
//   bool _showFullText = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 76.h),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 45),
//                     // padding: const EdgeInsets.only(left: 75,right: 65),
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(
//                           "assets/images/Group2.svg",
//                           width: 72.w,
//                           height: 39.h,
//                           fit: BoxFit.contain,
//                         ),
//                         SizedBox(width: 3.w),
//                         Text(
//                           'Manager',
//                           style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.w200,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 39.sp,
//                             height: 1.0,
//                             letterSpacing: 0.0,
//                             color: AppColors.jet,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 36.h),
//                   Text(
//                     'Create New Account',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w700,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 26.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: AppColors.vibrantPurple,
//                     ),
//                   ),
//                   SizedBox(height: 23.h),
//                   Text(
//                     'UserName',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _usernameController,
//                     currentFocusNode: _usernameFocus,
//                     nextFocusNode: _emailFocus,
//                     hintText: 'username',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 9.h),
//                   Text(
//                     'Email',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _emailController,
//                     currentFocusNode: _emailFocus,
//                     nextFocusNode: _passwordFocus,
//                     hintText: 'abc@gmail.com',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 9.h),
//                   Text(
//                     'Password',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _passwordController,
//                     currentFocusNode: _passwordFocus,
//                     nextFocusNode: null,
//                     hintText: '••••••••',
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 9.h),
//                   Text(
//                     'confirm Password',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _confirmPasswordController,
//                     currentFocusNode: _confirmPasswordFocus,
//                     nextFocusNode: _confirmPasswordFocus,
//                     hintText: '••••••••',
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 9.h),
//                   Text(
//                     'FullName',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _fullNameController,
//                     currentFocusNode: _fullNameFocus,
//                     nextFocusNode: _fullNameFocus,
//                     hintText: 'fullName',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 21.w,
//                         height: 21.h,
//                         child: Checkbox(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.r),
//                             // Radius 5
//                             side:  BorderSide(
//                               color: Colors.grey.shade200, // Border color
//                               width: 1,
//                             ),
//                           ),
//                           checkColor: Colors.white,
//                           // Checkmark color (better contrast on purple)
//                           activeColor: AppColors.vibrantPurple,
//                           // Fill color when checked
//                           side:  BorderSide(
//                             color: Colors.grey.shade200,
//                             width: 1,
//                           ),
//                           value: _isChecked,
//                           // Use a proper bool for checkbox state
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _isChecked = value ?? false;
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       // Checkbox(
//                       //   shape: RoundedRectangleBorder(
//                       //     borderRadius: BorderRadius.circular(8.r), // Radius 5
//                       //     side: const BorderSide(
//                       //       color: Color(0xFFF5F5F5), // Border color
//                       //       width: 2,
//                       //     ),
//                       //   ),
//                       //   checkColor: const Color(0xFFF5F5F5),
//                       //   activeColor: AppColors.vibrantPurple,
//                       //   side: const BorderSide(
//                       //     color: Color(0xFFF5F5F5),
//                       //     width: 2,
//                       //   ),
//                       //   value: _showFullText,
//                       //   onChanged: (bool? value) {
//                       //     setState(() {
//                       //       _showFullText = value ?? false;
//                       //
//                       //     });
//                       //   },
//                       // ),
//                       Text.rich(
//                         TextSpan(
//                           text:
//                               "I want to receive calls and emails from invoice Simple and\nits Affiliates about.... ",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: const Color(0xFF878787),
//                             height: 1.23,
//                             letterSpacing: -0.16,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: ' Show More',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: const Color(0xFF6B97E8),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 28.h),
//                   RoundButton(
//                     title: "Create Account",
//                     height: 50,
//                     width: 379,
//                     backgroundColors: AppColors.vibrantPurple,
//                     isSelected: true,
//                     onPress: () {
//                       // Navigator.pushNamed(context, RoutesName.dashboard);
//                     },
//                   ),
//                   SizedBox(height: 26.h),
//                   Center(
//                     child: Text(
//                       'Have Account',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 18.sp,
//                         height: 1.0,
//                         letterSpacing: 0.0,
//                         color: AppColors.vibrantPurple,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   Text(
//                     'By continuing you agree to our Terms & Privacy Policy',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12.sp,
//                       height: 1.23,
//                       letterSpacing: -0.16,
//                       color: const Color(0xFF878787),
//                     ),
//                   ),
//                   SizedBox(height: 13.h),
//                   RoundButton(
//                     title: "LOGIN",
//                     height: 50,
//                     width: 379,
//                     backgroundColors: AppColors.black,
//                     isSelected: true,
//                     onPress: () {
//                       Navigator.pushNamed(context, RoutesName.login);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/config/components/common_input_field.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
//
// class Signupview extends StatefulWidget {
//   const Signupview({super.key});
//
//   @override
//   State<Signupview> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<Signupview> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//
//   // Focus Nodes
//   final FocusNode _emailFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//   final FocusNode _confirmPasswordFocus = FocusNode();
//   final FocusNode _usernameFocus = FocusNode();
//   final FocusNode _fullNameFocus = FocusNode();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose();
//     _fullNameController.dispose();
//     _confirmPasswordController.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     _confirmPasswordFocus.dispose();
//     super.dispose();
//   }
//   bool _showFullText = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:  EdgeInsets.symmetric(horizontal: 28.w, vertical: 76.h),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 85,right: 65),
//                     child: Row(
//                       children: [
//                         SvgPicture.asset(
//                           "assets/images/Group2.svg",
//                           width: 72.w,
//                           height: 37.h,
//                           fit: BoxFit.contain,
//                         ),
//                         SizedBox(width: 3.w),
//                         Text(
//                           'Manager',
//                           style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.w200,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 30.sp,
//                             height: 1.0,
//                             letterSpacing: 0.0,
//                             color: AppColors.jet,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 36.h),
//                   Text(
//                     'Create New Account',
//                     textAlign: TextAlign.center,
//                     style:  TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w700,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 26.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: AppColors.vibrantPurple,
//                     ),
//                   ),
//                   SizedBox(height: 23.h),
//                   Text(
//                     'UserName',
//                     style:  TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _usernameController,
//                     currentFocusNode: _usernameFocus,
//                     nextFocusNode: _emailFocus,
//                     hintText: 'username',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 9.h),
//                   Text(
//                     'Email',
//                     style:  TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _emailController,
//                     currentFocusNode: _emailFocus,
//                     nextFocusNode: _passwordFocus,
//                     hintText: 'abc@gmail.com',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height:  9.h),
//                   Text(
//                     'Password',
//                     style:  TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height:  9.h),
//                   CommonInputField(
//                     controller: _passwordController,
//                     currentFocusNode: _passwordFocus,
//                     nextFocusNode: null,
//                     hintText: '••••••••',
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//
//                   ),
//                   SizedBox(height:  9.h),
//                   Text(
//                     'confirm Password',
//                     style:  TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height:  9.h),
//                   CommonInputField(
//                     controller: _confirmPasswordController,
//                     currentFocusNode: _confirmPasswordFocus,
//                     nextFocusNode: _confirmPasswordFocus,
//                     hintText: '••••••••',
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//
//                   ),
//                   SizedBox(height:  9.h),
//                   Text(
//                     'FullName',
//                     style:  TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 9.h),
//                   CommonInputField(
//                     controller: _fullNameController,
//                     currentFocusNode: _fullNameFocus,
//                     nextFocusNode: _fullNameFocus,
//                     hintText: 'fullName',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//
//                       Checkbox(
//                         checkColor: const Color(0xFFF5F5F5),
//                         activeColor: AppColors.vibrantPurple,
//                         value: _showFullText,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _showFullText = value ?? false;
//
//                           });
//                         },
//                       ),
//                        Text.rich(
//                         TextSpan(
//                           text: "I want to receive calls and emails from invoice Simple and\nits Affiliates about.... ",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: const Color(0xFF878787),
//                             height: 1.23,
//                             letterSpacing: -0.16,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: ' Show More',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: const Color(0xFF6B97E8),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                       ),
//                     ],
//                   ),
//                   SizedBox(height:28.h ),
//                   RoundButton(
//                     title: "Create Account",
//                     height: 50,
//                     width: 379,
//                     backgroundColors: AppColors.vibrantPurple,
//                     isSelected: true,
//                     onPress: () {
//                       // Navigator.pushNamed(context, RoutesName.dashboard);
//                     },
//                   ),
//                   SizedBox(height: 26.h),
//                   Center(
//                     child: Text(
//                       'Have Account',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 18.sp,
//                         height: 1.0,
//                         letterSpacing: 0.0,
//                         color: AppColors.vibrantPurple,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   Text(
//                     'By continuing you agree to our Terms & Privacy Policy',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12.sp,
//                       height: 1.23,
//                       letterSpacing: -0.16,
//                       color: const Color(0xFF878787),
//                     ),
//                   ),
//                   SizedBox(height: 13.h),
//                   RoundButton(
//                     title: "LOGIN",
//                     height: 50,
//                     width: 379,
//                     backgroundColors: AppColors.black,
//                     isSelected: true,
//                     onPress: () {
//                       Navigator.pushNamed(context, RoutesName.login);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }