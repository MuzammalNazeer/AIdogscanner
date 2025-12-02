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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: SoftEllipseBottomClipper(),
                child: Container(
                  height: 183.h,
                  width: double.infinity,
                  color: const Color(0xFF7A1FFF),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      const Icon(
                        Icons.diamond,
                        color: Colors.white,
                        size: 55, // Exact size from your design
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
                  color: const Color(0xFF000000),
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
                  color: const Color(0xFF6F7D86),
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Premium",
                      style: TextStyle(
                        color: Color(0xFF6F7D86),
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      "Free",
                      style: TextStyle(
                        color: Color(0xFF6F7D86),
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
              SizedBox(height: 160.h),
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
                backgroundColors: AppColors.vibrantPurple,
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
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class SoftEllipseBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double inset = 55.0; // Left & right inset
    const double lift = 115.0; // How much the curve is pulled upward

    final path = Path();

    // Top-left corner
    path.moveTo(0, 0);
    path.lineTo(0, size.height - lift);

    // Perfect centered soft ellipse
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height + 75,
      size.width - inset,
      size.height - lift,
    );

    // Close the shape cleanly
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.check, color: Color(0xFF7A1FFF), size: 20),
          const SizedBox(width: 40),
          Icon(
            free ? Icons.check : Icons.lock_outline,
            color: Color(0xFF7A1FFF),
            size: 20,
          ),
        ],
      ),
    );
  }
}
