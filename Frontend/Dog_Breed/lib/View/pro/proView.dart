
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Proview extends StatefulWidget {
  const Proview({super.key});

  @override
  State<Proview> createState() => _ProviewState();
}

class _ProviewState extends State<Proview> {
  final List<Map<String, dynamic>> features = [
    {'name': 'Video Screen Recorder', },
    {'name': 'Audio Capture', },
    {'name': 'FHD & UHD Support', },
    {'name': 'VIP Customer Support',},
    {'name': 'Remove Ads', },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15,top: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, RoutesName.splash),
                      child: const Icon(Icons.close, size: 24, color: Colors.black),
                    ),
                  ),
                ),
                 SizedBox(height:14.h),
                Padding(
                  padding: const EdgeInsets.only(left: 85,right: 85),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/Group2.svg",
                        width: 72.w,
                        height: 37.h,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
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
                 SizedBox(height: 38.h),
                Padding(
                  padding: const EdgeInsets.only(left: 70,right: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/Vector1.svg",
                        width: 97,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Dog Manager',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 12.56,
                              height: 1.0,
                              letterSpacing: -0.14,
                              color: AppColors.jet,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Text(
                            'Premium Version',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 17.94,
                              height: 1.0,
                              letterSpacing: -0.14,
                              color: AppColors.jet,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        "assets/images/Vector.svg",
                        width: 97,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 16.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'START LIKE A ',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 26.sp,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: AppColors.jet,
                        ),
                      ),
                      TextSpan(
                        text: 'PRO',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 26.sp,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: AppColors.vibrantPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 85.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        _buildFeatureRow('Video Screen Recorder'),
                        SizedBox(height: 7.h,),
                        _buildFeatureRow('Audio Capture'),
                        SizedBox(height: 7.h,),
                        _buildFeatureRow('FHD & UHD Support'),
                        SizedBox(height: 7.h,),
                        _buildFeatureRow('VIP Customer Support'),
                        SizedBox(height: 7.h,),
                        _buildFeatureRow('Remove Ads'),
                      ],
                    ),

                    Positioned(
                      top: -30,
                      left: 195,
                      child: Container(
                        width: 76.w,
                        height: 361.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBD8FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'BASIC',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.sp,
                                  height: 1.2,
                                  letterSpacing: -0.16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: features.asMap().entries.map((entry) {
                                  final item = entry.value;
                                  final bool basic = item['basic'] ?? false;

                                  return Container(
                                    height: 361.h / (features.length + 1),
                                    alignment: Alignment.center,
                                    child: basic
                                        ? Icon(Icons.check, color: Color(0xFF6A5AE0), size: 22.sp)
                                        : Text(
                                      '—',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w,),
                    Positioned(
                      top: -30,
                      left: 260,
                      child: Container(
                        width: 76.w,
                        height: 361.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E7CD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.h,
                                  height: 1.2,
                                  letterSpacing: -0.16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: features.map((item) {
                                  final bool premium = item['premium'] ?? true;
                                  return Container(
                                    height: 361.h / (features.length + 1),
                                    alignment: Alignment.center,
                                    child: premium
                                        ? Icon(Icons.check, color: Color(0xFF6A5AE0), size: 22.sp)
                                        : Text(
                                      '—',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 77.h),
                Text(
                  'Rs. 2,500/week after FREE 3-day trial',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.appColorBlack),
                ),
                 SizedBox(height: 10.h),
                Text(
                  'By continuing you agree to our Terms and Privacy policies.\n'
                      'Subscription is billed after the trial ends and will auto-renew. Cancel\n'
                      'subscription anytime before trial ends to avoid charges.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    height: 1.23,
                    letterSpacing: -0.16,
                    color: AppColors.battleshipGray,
                  ),
                ),
                 SizedBox(height: 25.h),
                RoundButton(
                  title: "START FREE TRIAL",
                  height: 56,
                  width: 379,
                  backgroundColors: AppColors.vibrantPurple,
                  isSelected: true,
                  onPress: () {
                    Navigator.pushNamed(context, RoutesName.wizard);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildFeatureRow(String name) {
    return Container(
      width: double.infinity,
      height: 49.h,
      padding: EdgeInsets.only(left: 10,right: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteSmoke,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(
            _getFeatureIcon(name),
            color: const Color(0xFF6A5AE0),
            size: 18.sp,
          ),
           SizedBox(width: 12.w),
          Text(
            name,
            style:  TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 16.sp,
              height: 1.2,
              letterSpacing: -0.16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  // Get Feature Icon
  IconData _getFeatureIcon(String feature) {
    switch (feature) {
      case 'Video Screen Recorder':
        return Icons.videocam;
      case 'Audio Capture':
        return Icons.mic;
      case 'FHD & UHD Support':
        return Icons.hd;
      case 'VIP Customer Support':
        return Icons.headset_mic;
      case 'Remove Ads':
        return Icons.block;
      default:
        return Icons.check;
    }
  }
}
