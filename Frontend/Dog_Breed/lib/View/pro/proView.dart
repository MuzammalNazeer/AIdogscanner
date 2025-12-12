import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';

class Proview extends StatefulWidget {
  const Proview({super.key});

  @override
  State<Proview> createState() => _ProviewState();
}

class _ProviewState extends State<Proview> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: _CustomShapeClipper(),
                  child: Container(
                    height: 165.h,
                    width: double.infinity,
                    color: colors.onBackground,
                    child: Stack(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 20.w,top: 50.h),
                          child: GestureDetector(
                            onTap:(){
                              Navigator.pushNamed(context, RoutesName.splash);
                            },
                            child: Positioned(
                              left: 20.w,
                              top: 50.h,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 36.sp,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 85.h,
                          left: 184.w,
                          child: Center(
                            child: Image.asset(
                              'assets/images/Group888.png',
                              height: 80.h,
                              width: 80.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Start Like A Pro",
                  style: TextStyle(
                    fontSize: 28.sp,
                    height: 45.2 / 28,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color:  Theme.of(context).colorScheme.onSurface,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "unlock All Features",
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 45.2 / 16,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Premium",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        "Free",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                const _FeatureRow(
                  title: "Camera Detector (Flash Mode)",
                  premium: true,
                  free: true,
                ),
                const _FeatureRow(
                  title: "Device Scanner (WiFi)",
                  premium: true,
                  free: true,
                ),
                const _FeatureRow(
                  title: "Camera Detector (Magnetic)",
                  premium: true,
                  free: true,
                ),
                const _FeatureRow(
                  title: "Remove Ads",
                  premium: true,
                  free: false,
                ),
                const _FeatureRow(
                  title: "VIP Customer Support",
                  premium: true,
                  free: false,
                ),
                SizedBox(height: 130.h),
                Text(
                  "3-Days FREE Trial, Rs 2550/Week After",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 24 / 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF000000),
                    fontFamily: "Inter",
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                RoundButton(
                  title: "START FREE TRIAL",
                  height: 56.h,
                  width: 379.w,
                  backgroundColors: colors.onBackground,
                  isSelected: true,
                  onPress: () {
                    Navigator.pushNamed(context, RoutesName.wizard);
                  },
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  child: Text(
                    "By continuing you agree to our Terms and Privacy policy, subscription is billed after the trial ends and will auto-renew. Cancel subscription anytime before trial ends to avoid charges.",
                    style: TextStyle(
                      fontSize: 10.sp,
                      height: 18 / 10,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                      fontFamily: "Inter",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


class _FeatureRow extends StatelessWidget {
  final String title;
  final bool premium;
  final bool free;

  const _FeatureRow({
    required this.title,
    required this.premium,
    required this.free,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF0A0A0A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // First column (Premium)
          Icon(
            premium ? Icons.check : Icons.lock_outline,
            color: premium
                ? (isDarkTheme ? colors.surface : AppColors.vibrantPurple)
                : (isDarkTheme ? colors.surface.withOpacity(0.9) : AppColors.vibrantPurple.withOpacity(0.9)),
            size: 20,
          ),
          const SizedBox(width: 40),
          // Second column (Free)
          Icon(
            free ? Icons.check : Icons.lock_outline,
            color: free
                ? (isDarkTheme ? colors.surface : AppColors.vibrantPurple)
                : (isDarkTheme ? colors.surface.withOpacity(0.9) : AppColors.vibrantPurple.withOpacity(0.9)),
            size: 20,
          ),
        ],
      ),
    );
  }
}