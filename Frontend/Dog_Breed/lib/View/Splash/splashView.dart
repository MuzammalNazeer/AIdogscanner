import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.pro);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.onBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: 350.w,
                  height: 350.h,
                  decoration: BoxDecoration(
                    color: colors.onTertiary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D9FF).withOpacity(1),
                        blurRadius: 54,
                        spreadRadius: 0,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/Vector555.svg",
                      width: 230.w,
                      height: 230.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/text1.svg",
                      width: 97,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Manager',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w200, // ExtraLight
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              SizedBox(
                width: 254,
                height: 21,
                child: Text(
                  'Manage Your Dog daily Activity, Health',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.5,
                    letterSpacing: -0.16,
                    color: Colors.white.withOpacity(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:dog_breed/ads_util.dart';
// import 'package:dog_breed/remote_config_service.dart';
// import 'package:dog_breed/subscription_manager.dart';
// import 'package:dog_breed/app_preferences.dart';
//
// class Splashview extends StatefulWidget {
//   const Splashview({super.key});
//
//   @override
//   State<Splashview> createState() => _SplashviewState();
// }
//
// class _SplashviewState extends State<Splashview> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }
//
//   void _navigateToNextScreen() {
//     Future.delayed(const Duration(seconds: 4), () async {
//       // Show App Open Ad before moving to next screen
//       await AdService.showAppOpenAd();
//
//       if (mounted) {
//         final isSubscribed = await SubscriptionManager.isSubscribed();
//         final isOnboardingShown = await AppPreferences.isOnboardingShown();
//
//         if (isSubscribed || isOnboardingShown) {
//           Navigator.pushReplacementNamed(context, RoutesName.dashboard);
//         } else {
//           Navigator.pushReplacementNamed(context, RoutesName.wizard);
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor: colors.onBackground,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, right: 30),
//                     child: Container(
//                       width: 350.w,
//                       height: 350.h,
//                       decoration: BoxDecoration(
//                         color: colors.onTertiary,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF00D9FF).withOpacity(1),
//                             blurRadius: 54,
//                             spreadRadius: 0,
//                             offset: Offset.zero,
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset(
//                           "assets/images/Vector555.svg",
//                           width: 230.w,
//                           height: 230.h,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           "assets/images/text1.svg",
//                           width: 97,
//                           height: 50,
//                           color: Colors.white,
//                           fit: BoxFit.contain,
//                         ),
//                          SizedBox(width: 5.w),
//                         const Text(
//                           'Manager',
//                           style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.w200,
//                             fontSize: 40,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                    SizedBox(height: 10.h),
//
//                   // Subtitle
//                   SizedBox(
//                     width: 255.w,
//                     height: 22.h,
//                     child: Text(
//                       'Manage Your Dog daily Activity, Health',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15.sp,
//                         // height: 1.5,
//                         letterSpacing: -0.16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (RemoteConfigService.splashNativeAdEnabled)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: NativeAdWidget(
//                   location: 'splash',
//                   height: 480.h,
//                   templateType: TemplateType.medium,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
