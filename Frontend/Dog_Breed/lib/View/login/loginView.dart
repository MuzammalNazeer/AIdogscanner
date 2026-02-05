import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/common_input_field.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dog_breed/Valid/session_controller.dart';


import '../../database/DatabaseHelper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SessionController _sessionController = SessionController();


  Future<void> _performLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final users = await _dbHelper.getAllUsers();
      final user = users.firstWhere(
            (u) => u['email'] == email && u['password'] == password,
        orElse: () => <String, dynamic>{},
      );

      if (user.isNotEmpty) {
        // Save session
        await _sessionController.saveUserSession(
            "dummy_token",
            user['id'],
            user['email']
        );

        // Show centered success message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.5 - 30, // Center vertically
              left: 20,
              right: 20,
            ),
            content: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Login successful!',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Delay navigation to show success message
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesName.dashboard);
        }
      } else {
        // Show error message at bottom (default position)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Invalid email or password',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show network/connection error at bottom
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Login failed. Please try again.',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );

      // Log error for debugging
      print('Login error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _mockGoogleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate Google Sign In delay and result
    await Future.delayed(const Duration(seconds: 1));
    const googleEmail = "google_user@gmail.com"; // Mock email
    
    try {
      final users = await _dbHelper.getAllUsers();
      var user = users.firstWhere(
            (u) => u['email'] == googleEmail,
        orElse: () => <String, dynamic>{},
      );

      if (user.isEmpty) {
        // Register new user
        final newUser = {
          'username': 'GoogleUser',
          'email': googleEmail,
          'password': 'google_password_secure', // Dummy password
          'full_name': 'Google User',
        };
        await _dbHelper.insertUser(newUser);
        // Fetch again to get ID
        final updatedUsers = await _dbHelper.getAllUsers();
        user = updatedUsers.firstWhere((u) => u['email'] == googleEmail);
      }

      // Save session
      await _sessionController.saveUserSession(
          "dummy_google_token",
          user['id'],
          user['email']
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in with Google as $googleEmail'),
          backgroundColor: Colors.green,
        ),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboard);
      }

    } catch (e) {
      print("Google login error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Google Login failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
        height: 50.h,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.platinumGray,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const Spacer(),
            Center(
              child: Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w,),
            Icon(
              Icons.arrow_forward,
              size: 24.sp,
              color: Colors.black45,
            ),

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/Group2.svg",
                      width: 72.w,
                      height: 37.h,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Manager',
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: AppColors.jet,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 41.h),
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.vibrantPurple,
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _emailController,
                  currentFocusNode: _emailFocus,
                  nextFocusNode: _passwordFocus,
                  hintText: 'abc@gmail.com',
                  validator: (v) =>
                  v!.trim().isEmpty ||
                      !RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(v.trim())
                      ? 'Enter a valid email'
                      : null,
                ),
                SizedBox(height: 5.h),

                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 9.h),
                CommonInputField(
                  controller: _passwordController,
                  currentFocusNode: _passwordFocus,
                  hintText: '••••••••',
                  obscureText: true,
                  validator: (v) => v!.isEmpty || v.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                SizedBox(height: 8.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RoutesName.forgetEmail),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Forgot Password? ',
                            style: TextStyle(
                              color: Color(0xFF1F2029),
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'Click Here',
                            style: TextStyle(
                              color: Color(0xFF0084FF),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                RoundButton(
                  title: "LOGIN",
                  height: 55.h,
                  backgroundColors: AppColors.vibrantPurple,
                  isSelected: true,
                  onPress: _performLogin,
                ),
                SizedBox(height: 34.h),
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
                    width: 34.w,
                    height: 34.h,
                    fit: BoxFit.contain,
                  ),
                  label: 'Login with Gmail',
                  onTap: _mockGoogleLogin,
                ),
                SizedBox(height:10.h ),
                _buildSocialButton(
                  iconWidget: Image.asset(
                    'assets/images/image 44.png',
                    width: 34.w,
                    height: 34.h,
                    fit: BoxFit.contain,
                  ),
                  label: 'Login with Apple',
                  onTap: () {},
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
                  height: 55.h,
                  width: 379.w,
                  backgroundColors: AppColors.black,
                  isSelected: true,
                  onPress: () {
                    Navigator.pushNamed(context, RoutesName.signup);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),



            // Row(
            //   children: [
            //     Expanded(child: Divider(color: Colors.grey[300])),
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 16),
            //       child: Text('OR'),
            //     ),
            //     Expanded(child: Divider(color: Colors.grey[300])),
            //   ],
            // ),
            // SizedBox(height: 20.h),
            //
            // _buildSocialButton(
            //   iconWidget: Image.asset(
            //     'assets/images/image 43.png',
            //     width: 48,
            //     height: 48,
            //   ),
            //   label: 'Login with Gmail',
            //   onTap: () {},
            // ),
            // SizedBox(height: 10.h),
            // _buildSocialButton(
            //   iconWidget: Image.asset(
            //     'assets/images/image 44.png',
            //     width: 48,
            //     height: 48,
            //   ),
            //   label: 'Login with Apple',
            //   onTap: () {},
            // ),
            //
            // SizedBox(height: 20.h),
            // Center(
            //   child: GestureDetector(
            //     onTap: () =>
            //         Navigator.pushNamed(context, RoutesName.signup),
            //     child: Text(
            //       'Create New Account',
            //       style: TextStyle(
            //         fontSize: 18.sp,
            //         color: AppColors.vibrantPurple,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10.h),
            // Text(
            //   'By continuing you agree to our Terms & Privacy Policy',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 12.sp, color: Color(0xFF878787)),
            // ),
            // SizedBox(height: 20.h),
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
//
// import '../../database/DatabaseHelper.dart';
//
// class LoginView extends StatefulWidget {
//   const LoginView({super.key});
//
//   @override
//   State<LoginView> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<LoginView> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   final FocusNode _emailFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//
//   bool _isLoading = false;
//
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//
//
//   Future<void> _performLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final email = _emailController.text.trim();
//     final password = _passwordController.text;
//
//     try {
//       final users = await _dbHelper.getAllUsers();
//       final user = users.firstWhere(
//             (u) => u['email'] == email && u['password'] == password,
//         orElse: () => <String, dynamic>{},
//       );
//
//       if (user.isNotEmpty) {
//         // Show centered success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             margin: EdgeInsets.only(
//               bottom: MediaQuery.of(context).size.height * 0.5 - 30, // Center vertically
//               left: 20,
//               right: 20,
//             ),
//             content: Container(
//               alignment: Alignment.center,
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     'Login successful!',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//
//         // Delay navigation to show success message
//         await Future.delayed(const Duration(milliseconds: 1500));
//
//         if (mounted) {
//           Navigator.pushReplacementNamed(context, RoutesName.dashboard);
//         }
//       } else {
//         // Show error message at bottom (default position)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.white,
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             behavior: SnackBarBehavior.floating,
//             content: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Invalid email or password',
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     } catch (e) {
//       // Show network/connection error at bottom
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Row(
//             children: [
//               Icon(Icons.warning, color: Colors.white),
//               SizedBox(width: 8),
//               Text('Login failed. Please try again.',
//                   style: TextStyle(color: Colors.white)),
//             ],
//           ),
//           duration: Duration(seconds: 3),
//         ),
//       );
//
//       // Log error for debugging
//       print('Login error: $e');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _emailFocus.dispose();
//     _passwordFocus.dispose();
//     super.dispose();
//   }
//
//   Widget _buildSocialButton({
//     required Widget iconWidget,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         height: 50.h,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: AppColors.platinumGray,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             iconWidget,
//             const Spacer(),
//             Center(
//               child: Expanded(
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16.sp,
//                       color: AppColors.black,
//                       fontWeight: FontWeight.bold
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 20.w,),
//             Icon(
//               Icons.arrow_forward,
//               size: 24.sp,
//               color: Colors.black45,
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/images/Group2.svg",
//                       width: 72.w,
//                       height: 37.h,
//                     ),
//                     SizedBox(width: 3.w),
//                     Text(
//                       'Manager',
//                       style: TextStyle(
//                         fontSize: 30.sp,
//                         color: AppColors.jet,
//                         fontFamily: 'Sora',
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 41.h),
//                 Text(
//                   'Login',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 26.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.vibrantPurple,
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//
//                 Text(
//                   'Email',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 9.h),
//                 CommonInputField(
//                   controller: _emailController,
//                   currentFocusNode: _emailFocus,
//                   nextFocusNode: _passwordFocus,
//                   hintText: 'abc@gmail.com',
//                   validator: (v) =>
//                   v!.trim().isEmpty ||
//                       !RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(v.trim())
//                       ? 'Enter a valid email'
//                       : null,
//                 ),
//                 SizedBox(height: 5.h),
//
//                 Text(
//                   'Password',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 9.h),
//                 CommonInputField(
//                   controller: _passwordController,
//                   currentFocusNode: _passwordFocus,
//                   hintText: '••••••••',
//                   obscureText: true,
//                   validator: (v) => v!.isEmpty || v.length < 6
//                       ? 'Password must be at least 6 characters'
//                       : null,
//                 ),
//                 SizedBox(height: 8.h),
//
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () =>
//                         Navigator.pushNamed(context, RoutesName.forgetEmail),
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'Forgot Password? ',
//                             style: TextStyle(
//                               color: Color(0xFF1F2029),
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'Click Here',
//                             style: TextStyle(
//                               color: Color(0xFF0084FF),
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 25.h),
//
//                 RoundButton(
//                   title: "LOGIN",
//                   height: 55.h,
//                   backgroundColors: AppColors.vibrantPurple,
//                   isSelected: true,
//                   onPress: _performLogin,
//                 ),
//                 SizedBox(height: 34.h),
//                 SizedBox(height: 34.h),
//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: Colors.grey[300])),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         'OR',
//                         style: TextStyle(color: Colors.grey[600],fontSize: 14.sp, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Expanded(child: Divider(color: Colors.grey[300])),
//                   ],
//                 ),
//                 SizedBox(height: 20.h),
//                 _buildSocialButton(
//                   iconWidget: Image.asset(
//                     'assets/images/image 43.png',
//                     width: 34.w,
//                     height: 34.h,
//                     fit: BoxFit.contain,
//                   ),
//                   label: 'Login with Gmail',
//                   onTap:  () {},
//                 ),
//                 SizedBox(height:10.h ),
//                 _buildSocialButton(
//                   iconWidget: Image.asset(
//                     'assets/images/image 44.png',
//                     width: 34.w,
//                     height: 34.h,
//                     fit: BoxFit.contain,
//                   ),
//                   label: 'Login with Apple',
//                   onTap: () {},
//                 ),
//                 SizedBox(height: 20.h),
//                 Center(
//                   child: Text(
//                     'Create New Account',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 18.sp,
//                       height: 1.0,
//                       letterSpacing: 0.0,
//                       color: AppColors.vibrantPurple,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Text(
//                   'By continuing you agree to our Terms & Privacy Policy',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12.sp,
//                     height: 1.23,
//                     letterSpacing: -0.16,
//                     color: const Color(0xFF878787),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 RoundButton(
//                   title: "CREATE NEW ACCOUNT",
//                   height: 55.h,
//                   width: 379.w,
//                   backgroundColors: AppColors.black,
//                   isSelected: true,
//                   onPress: () {
//                     Navigator.pushNamed(context, RoutesName.signup);
//                   },
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//
//
//
//             // Row(
//             //   children: [
//             //     Expanded(child: Divider(color: Colors.grey[300])),
//             //     Padding(
//             //       padding: EdgeInsets.symmetric(horizontal: 16),
//             //       child: Text('OR'),
//             //     ),
//             //     Expanded(child: Divider(color: Colors.grey[300])),
//             //   ],
//             // ),
//             // SizedBox(height: 20.h),
//             //
//             // _buildSocialButton(
//             //   iconWidget: Image.asset(
//             //     'assets/images/image 43.png',
//             //     width: 48,
//             //     height: 48,
//             //   ),
//             //   label: 'Login with Gmail',
//             //   onTap: () {},
//             // ),
//             // SizedBox(height: 10.h),
//             // _buildSocialButton(
//             //   iconWidget: Image.asset(
//             //     'assets/images/image 44.png',
//             //     width: 48,
//             //     height: 48,
//             //   ),
//             //   label: 'Login with Apple',
//             //   onTap: () {},
//             // ),
//             //
//             // SizedBox(height: 20.h),
//             // Center(
//             //   child: GestureDetector(
//             //     onTap: () =>
//             //         Navigator.pushNamed(context, RoutesName.signup),
//             //     child: Text(
//             //       'Create New Account',
//             //       style: TextStyle(
//             //         fontSize: 18.sp,
//             //         color: AppColors.vibrantPurple,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // SizedBox(height: 10.h),
//             // Text(
//             //   'By continuing you agree to our Terms & Privacy Policy',
//             //   textAlign: TextAlign.center,
//             //   style: TextStyle(fontSize: 12.sp, color: Color(0xFF878787)),
//             // ),
//             // SizedBox(height: 20.h),
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
//
//
//
//
