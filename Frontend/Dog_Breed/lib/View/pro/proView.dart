
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Valid/AppColors.dart';
import '../../View_model/home/home_view_model.dart';
import '../../config/components/roundButton.dart';
import '../../utils/routes/routes_name.dart';
import '../../l10n/app_localizations.dart';

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
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: _CustomShapeClipper(),
                child: Container(
                  width: double.infinity,
                  height: 165.h,
                  color: AppColors.vibrantPurple, // APPLY COLOR HERE
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20.w,
                        top: 50.h,
                        child: GestureDetector(
                          onTap: () {
                            final args = ModalRoute.of(context)?.settings.arguments as Map?;
                            final bool fromProfile = args?['fromProfile'] ?? false;

                            if (fromProfile) {
                              Navigator.pop(context);
                            } else {
                              final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
                              homeViewModel.selectedIndex = 0; 
                              Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (route) => false);
                            }
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 36.sp,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 85.h,
                        left: 184.w,
                        child: Image.asset(
                          'assets/images/Group888.png',
                          height: 80.h,
                          width: 80.w,
                          color: Colors.white, // OPTIONAL: apply white tint
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppLocalizations.of(context)!.startLikeAPro,
                style: TextStyle(
                  fontSize: 28.sp,
                  height: 45.2 / 28,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  color:  AppColors.vibrantPurple,
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                AppLocalizations.of(context)!.unlockAllFeatures,
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 45.2 / 16,
                  letterSpacing: 0,
                  color: colors.primary,
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
                      AppLocalizations.of(context)!.premium,
                      style: TextStyle(
                        color:  colors.primary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      AppLocalizations.of(context)!.free,
                      style: TextStyle(
                        color:  colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              _FeatureRow(
                title: AppLocalizations.of(context)!.unlimitedDogScans,
                premium: true,
                free: true,
              ),
              _FeatureRow(
                title: AppLocalizations.of(context)!.supportedBreedDetection,
                premium: true,
                free: true,
              ),
              _FeatureRow(
                title: AppLocalizations.of(context)!.multiplePetProfiles,
                premium: true,
                free: true,
              ),
              _FeatureRow(
                title: AppLocalizations.of(context)!.removeAds,
                premium: true,
                free: false,
              ),
              _FeatureRow(
                title: AppLocalizations.of(context)!.vipCustomerSupport,
                premium: true,
                free: false,
              ),
              SizedBox(height: 130.h),
              Text(
                AppLocalizations.of(context)!.trialOffer,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 24 / 14,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              RoundButton(
                title: AppLocalizations.of(context)!.startFreeTrial,
                height: 62.h,
                width: 379.w,
                borderRadius: 41.r,
                backgroundColors:AppColors.vibrantPurple,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, RoutesName.wizard);
                },
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.w),
                child: Text(
                  AppLocalizations.of(context)!.subscriptionDisclaimer,
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 18 / 10,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: "Inter",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
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
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // First column (Premium)
          Icon(
            premium ? Icons.check : Icons.lock_outline,
            color: premium
                ? (isDarkTheme ? Color(0xFFFFFFFF): AppColors.vibrantPurple)
                : (isDarkTheme ? Color(0xFFFFFFFF) : AppColors.vibrantPurple),
            size: 20,
          ),
          const SizedBox(width: 40),
          // Second column (Free)
          Icon(
            free ? Icons.check : Icons.lock_outline,
            color: free
                ? (isDarkTheme ?Color(0xFFFFFFFF): AppColors.vibrantPurple)
                : (isDarkTheme ? Color(0xFFFFFFFF) : AppColors.vibrantPurple),
            size: 20,
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../app_preferences.dart';
// import 'SubscriptionManager.dart';
// import '../../Valid/AppColors.dart';
// import '../../ads_util.dart';
// import '../../remote_config_service.dart';
// import '../../utils/routes/routes_name.dart';
// import 'widgets/trial_button.dart';
// import '../../l10n/app_localizations.dart';
//
// class Proview extends StatefulWidget {
//   final String? from;
//
//   const Proview({super.key, this.from});
//
//   @override
//   State<Proview> createState() => _ProviewState();
// }
//
//
// class _ProviewState extends State<Proview> {
//
//   final SubscriptionManager _purchaseManager = SubscriptionManager();
//   String freeTrialLabel = '';
//   String subscriptionDurationLabel = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _purchaseManager.addListener(_onSubscriptionUpdate);
//     _purchaseManager.initialize();
//     getFreeLabels();
//   }
//
//   @override
//   void dispose() {
//     _purchaseManager.removeListener(_onSubscriptionUpdate);
//     _purchaseManager.dispose();
//     super.dispose();
//   }
//
//   void _onSubscriptionUpdate() {
//     if (mounted) {
//       setState(() {});
//     }
//
//     // Check if subscribed successfully
//     SubscriptionManager.isSubscribed().then((isSubscribed) {
//       if (isSubscribed && mounted) {
//         // Navigate away or show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Subscription Successful!")),
//         );
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   void getFreeLabels() {
//     setState(() {
//       freeTrialLabel = RemoteConfigService.freeSubscriptionText;
//       subscriptionDurationLabel = RemoteConfigService.freeSubscriptionDuration;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//
//     String buttonTitle = freeTrialLabel;
//     if (_purchaseManager.product != null) {
//       buttonTitle += " (${_purchaseManager.product!.price})";
//     }
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipPath(
//                 clipper: _CustomShapeClipper(),
//                 child: Container(
//                   width: double.infinity,
//                   height: 165.h,
//                   color: AppColors.vibrantPurple,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 10.w,
//                         top: 45.h,
//                         child: GestureDetector(
//                           onTap: () async {
//                             await AdService.showInterstitialAd(
//                                 () async {
//                                   if (widget.from != null) {
//                                     Navigator.pop(context);
//                                   } else if (context.mounted) {
//                                     final onboardingShown = await AppPreferences.isOnboardingShown();
//                                     if (onboardingShown) {
//                                       Navigator.pushReplacementNamed(
//                                         context,
//                                         RoutesName.dashboard,
//                                       );
//                                     } else {
//                                       Navigator.pushNamed(
//                                         context,
//                                         RoutesName.wizard,
//                                       );
//                                     }
//                                   }
//                                 },
//                               // featureEnabled: RemoteConfigService
//                               //     .subscriptionInterstitialEnabled,
//                               // isSubscription: true,
//                             );
//                           },
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                       ),
//
//                       Positioned(
//                         top: 85.h,
//                         left: 184.w,
//                         child: Image.asset(
//                           'assets/images/Group888.png',
//                           height: 80.h,
//                           width: 80.w,
//                           color: Colors.white, // OPTIONAL: apply white tint
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 "Start Like A Pro",
//                 style: TextStyle(
//                   fontSize: 28.sp,
//                   height: 45.2 / 28,
//                   letterSpacing: 0,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.vibrantPurple,
//                   fontFamily: "Inter",
//                 ),
//               ),
//               SizedBox(height: 4.h),
//
//               Text(
//                 "unlock All Features",
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   height: 45.2 / 16,
//                   letterSpacing: 0,
//                   color: Theme.of(context).colorScheme.onSecondaryContainer,
//                   fontFamily: "Inter",
//                 ),
//               ),
//               SizedBox(height: 18.h),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       "Premium",
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.onSecondaryContainer,
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(width: 20.w),
//                     Text(
//                       "Free",
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.onSecondaryContainer,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 5.h),
//               _FeatureRow(
//                 title: AppLocalizations.of(context)!.unlimitedDogScans,
//                 premium: true,
//                 free: true,
//               ),
//               _FeatureRow(
//                 title: AppLocalizations.of(context)!.supportedBreedDetection,
//                 premium: true,
//                 free: true,
//               ),
//               _FeatureRow(
//                 title: AppLocalizations.of(context)!.multiplePetProfiles,
//                 premium: true,
//                 free: true,
//               ),
//               _FeatureRow(
//                 title: AppLocalizations.of(context)!.removeAds,
//                 premium: true,
//                 free: false,
//               ),
//               _FeatureRow(
//                 title: AppLocalizations.of(context)!.vipCustomerSupport,
//                 premium: true,
//                 free: false,
//               ),
//               SizedBox(height: 80.h),
//               Text(
//                 subscriptionDurationLabel,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   height: 24 / 14,
//                   letterSpacing: 0,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF000000),
//                   fontFamily: "Inter",
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8.h),
//               if (_purchaseManager.isLoading)
//                  Padding(
//                    padding: EdgeInsets.symmetric(vertical: 10.h),
//                    child: const CircularProgressIndicator(),
//                  )
//               else
//                 TrialButton(
//                   title: buttonTitle,
//                   onPress: () {
//                     if (_purchaseManager.product != null) {
//                       _purchaseManager.buySubscription();
//                     } else {
//                        ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Product not available")),
//                       );
//                     }
//                   },
//                 ),
//               SizedBox(height: 10.h),
//               TextButton(
//                 onPressed: () {
//                   _purchaseManager.restorePurchases();
//                 },
//                 child: Text(
//                   "Restore Purchases",
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColors.vibrantPurple,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 36.w),
//                 child: Text(
//                   AppLocalizations.of(context)!.subscriptionDisclaimer,
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     height: 18 / 10,
//                     letterSpacing: 0,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF000000),
//                     fontFamily: "Inter",
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _CustomShapeClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(
//       size.width / 2,
//       size.height + 40,
//       size.width,
//       size.height - 40,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
//
// class _FeatureRow extends StatelessWidget {
//   final String title;
//   final bool premium;
//   final bool free;
//
//   const _FeatureRow({
//     required this.title,
//     required this.premium,
//     required this.free,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: const Color(0xFF0A0A0A),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           // First column (Premium)
//           Icon(
//             premium ? Icons.check : Icons.lock_outline,
//             color: premium
//                 ? (isDarkTheme ? colors.surface : AppColors.vibrantPurple)
//                 : (isDarkTheme ? colors.surface.withOpacity(0.9) : AppColors.vibrantPurple.withOpacity(0.9)),
//             size: 20,
//           ),
//           const SizedBox(width: 40),
//           // Second column (Free)
//           Icon(
//             free ? Icons.check : Icons.lock_outline,
//             color: free
//                 ? (isDarkTheme ? colors.surface : AppColors.vibrantPurple)
//                 : (isDarkTheme ? colors.surface.withOpacity(0.9) : AppColors.vibrantPurple.withOpacity(0.9)),
//             size: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
