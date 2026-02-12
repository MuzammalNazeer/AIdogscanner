import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../l10n/app_localizations.dart';

class Wizardview extends StatefulWidget {
  const Wizardview({super.key});

  @override
  State<Wizardview> createState() => _WizardviewState();
}

class _WizardviewState extends State<Wizardview> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:colors.onBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => currentPage = i),
                children: const [
                  OnboardingPage1(),
                  OnboardingPage2(),
                  OnboardingPage3(),
                  OnboardingPage4(),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: currentPage == 0 ? null : colors.onBackground,
                image: currentPage == 0
                    ?  DecorationImage(
                        image: AssetImage(
                          Theme.of(context).brightness == Brightness.dark
                            ? 'assets/images/Wizard2.png'
                            : 'assets/images/Wizard1.png',),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      )
                    : null,
              ),
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage < 3)
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.dashboard,
                              (route) => false,
                        );
                      },
                      child:  Text(
                        AppLocalizations.of(context)!.skip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.h,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  else
                    SizedBox(width: 50.w),

                  // Page Dots
                  Row(
                    children: List.generate(
                      4,
                          (i) => AnimatedContainer(
                        duration:  const Duration(milliseconds: 300),
                        margin:  const EdgeInsets.only(right: 8),
                        width: currentPage == i ? 28 : 10,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: currentPage == i
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started Button
                  GestureDetector(
                    onTap: () {
                      if (currentPage == 3) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.dashboard,
                              (route) => false,
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 36.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        currentPage == 3 ? AppLocalizations.of(context)!.getStarted : AppLocalizations.of(context)!.next,
                        style: TextStyle(
                          color: colors.onBackground,
                          fontSize: 18.h,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool _ = Theme.of(context).brightness == Brightness.dark;    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/Wizard2.png'  // Dark mode
                : 'assets/images/Wizard1.png', // Light mode
            fit: BoxFit.cover,
          ),
        ),
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/Wizard1.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 360.w,
                      height: 360.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D9FF).withOpacity(0.4),
                            blurRadius: 54,
                            spreadRadius: 0,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                    ),
                    // Middle Circle
                    Container(
                      width: 300.w,
                      height: 300.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          color: colors.onTertiary
                        // color: colors.onTertiary,
                      ),
                    ),
                    // Inner Circle
                    Container(
                      width: 240.w,
                      height: 240.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.onBackground,
                      ),
                    ),
                    // Dog Image
                    Image.asset(
                      'assets/images/ddoogg_1.png',
                      width: 296.w,
                      height: 512.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.onboardingWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: "Sora"
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.onboardingWelcomeDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.5,
                        fontFamily: "Inter"
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  const  OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool _ = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(16.r),
        child: Column(
          children: [
            SizedBox(height: 30.h,),
            SizedBox(
              width: 380.w,
              height: 420.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: 400.w,
                    height: 380.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:  const Color(0xFF00D9FF).withOpacity(0.6),
                          blurRadius: 54,
                          spreadRadius: 0,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 320.w,
                    height: 320.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.onTertiary
                    ),
                  ),
                  Container(
                    width: 260.w,
                    height: 260.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color:Color(0xFF7B2CBF),
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/Ellipse_77.png',
                      width: 258.w,
                      height: 260.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse_789.png', context)),
                  Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse_788.png',context)),
                  Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse_808.png',context)),
                ],
              ),
            ),
            SizedBox(height: 140.h),
            Text(
              AppLocalizations.of(context)!.onboardingTitle2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Sora',
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.onboardingDesc2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.white,fontFamily: 'Inter',fontWeight: FontWeight.w500,),
            ),
          ],
        ),
      ),
    );
  }
}


Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 115.w,
        height: 115.h,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          color:colors.onTertiary,
        ),
      ),
      Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.onTertiary
        ),
        child: ClipOval(
          child: Image.asset(
            assetPath,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
        ),
      )
    ],
  );
}
// PAGE 3 - Image Quality Grid
class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(32.r),
      child: Column(
        children: [
          SizedBox(height: 120.h,),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                bool showCloseIcon = index == 0 || index == 1 || index == 3;
                bool showCheckIcon = index == 2 || index == 4 || index == 5;
                final List<String> imagePaths = [
                  'assets/images/Ellipse_81_1.png',
                  'assets/images/Ellipse_82.png',
                  'assets/images/Ellipse_83.png',
                  'assets/images/Ellipse_81_2.png',
                  'assets/images/Ellipse_82_1.png',
                  'assets/images/Ellipse_833.png',
                ];

                return Stack(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        imagePaths[index],
                        width: 105.w,
                        height: 105.h,
                      ),
                    ),
                    if (showCloseIcon)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      )
                    else if (showCheckIcon)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 210.h),
          Text(
            AppLocalizations.of(context)!.onboardingTitle3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Sora',
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.onboardingDesc3,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,fontFamily: 'Inter',fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(32.r),
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 225.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.asset(
                          'assets/images/Rectangle_3194.png',
                          height: 230.h,
                          width: 142.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle_3197.png',
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle_3194.png',
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 7.w),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle_3195.png',
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              'assets/images/Rectangle_3196.png',
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 370.w,
                  height: 120.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: AspectRatio(
                      aspectRatio: 3.5,
                      child: Image.asset(
                        'assets/images/Rectangle_319.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
          SizedBox(height: 150.h),
          Text(
            AppLocalizations.of(context)!.onboardingTitle4,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Sora',
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.onboardingDesc4,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white,fontFamily: 'Inter',fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }
}





// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class Wizardview extends StatefulWidget {
//   const Wizardview({super.key});
//
//   @override
//   State<Wizardview> createState() => _WizardviewState();
// }
//
// class _WizardviewState extends State<Wizardview> {
//   final PageController _pageController = PageController();
//   int currentPage = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor:colors.onBackground,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (i) => setState(() => currentPage = i),
//                 children: const [
//                   OnboardingPage1(),
//                   OnboardingPage2(),
//                   OnboardingPage3(),
//                   OnboardingPage4(),
//                 ],
//               ),
//             ),
//
//             // Bottom Navigation Bar
//             Container(
//               height: 100.h,
//               color: colors.onBackground,
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (currentPage < 3)
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           RoutesName.dashboard,
//                               (route) => false,
//                         );
//                       },
//                       child:  Text(
//                         "Skip",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     )
//                   else
//                      SizedBox(width: 50.w),
//
//                   // Page Dots
//                   Row(
//                     children: List.generate(
//                       4,
//                       (i) => AnimatedContainer(
//                         duration:  const Duration(milliseconds: 300),
//                         margin:  const EdgeInsets.only(right: 8),
//                         width: currentPage == i ? 28 : 10,
//                         height: 10.h,
//                         decoration: BoxDecoration(
//                           color: currentPage == i
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Next / Get Started Button
//                   GestureDetector(
//                     onTap: () {
//                       if (currentPage == 3) {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           RoutesName.dashboard,
//                               (route) => false,
//                         );
//                       } else {
//                         _pageController.nextPage(
//                           duration: const Duration(milliseconds: 400),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 36,
//                         vertical: 14,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 12,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         currentPage == 3 ? "Get Started" : "Next",
//                         style: TextStyle(
//                           color: colors.onBackground,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class OnboardingPage1 extends StatelessWidget {
//   const OnboardingPage1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool _ = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding:  EdgeInsets.all(10.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h,),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 width: 360.w,
//                 height: 360.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//
//                   boxShadow: [
//                     BoxShadow(
//                       color:  const Color(0xFF00D9FF).withOpacity(0.6),  // Light theme
//                       blurRadius: 54,
//                       spreadRadius: 0,
//                       offset: Offset.zero,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: 340.w,
//                 height: 340.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: colors.onTertiary,
//
//                 ),
//               ),
//               Container(
//                 width: 280.w,
//                 height: 245.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                     color: colors.onBackground
//                 ),
//               ),
//               ClipOval(
//                 child: Image.asset(
//                   'assets/images/Ellipse 777.png',
//                   width: 246.w,
//                   height: 266.h,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 210.h),
//            Text(
//             "Find Out Your Dog's\nBreed Fast!",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//                 color: Colors.white
//             ),
//           ),
//           SizedBox(height: 16.h),
//            Text(
//             "Capture a photo or upload from your gallery\nand discover your dog’s breed instantly!",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage2 extends StatelessWidget {
//   const  OnboardingPage2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding:  EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h,),
//           SizedBox(
//             width: 380.w,
//             height: 420.h,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer glow
//                 Container(
//                   width: 400.w,
//                   height: 380.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
//                         blurRadius: 54,
//                         spreadRadius: 0,
//                         offset: Offset.zero,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 320.w,
//                   height: 320.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: colors.onTertiary
//                   ),
//                 ),
//                 Container(
//                   width: 260.w,
//                   height: 260.h,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color:Color(0xFF7B2CBF),
//                   ),
//                 ),
//                 ClipOval(
//                   child: Image.asset(
//                     'assets/images/Ellipse 77.png',
//                     width: 258.w,
//                     height: 260.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
//                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
//                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
//               ],
//             ),
//           ),
//           SizedBox(height: 140.h),
//            Text(
//             "We need your\n permission",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "We need camera permission so you can make live \nscans of your pet.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
//   final colors = Theme.of(context).colorScheme;
//   return Stack(
//     alignment: Alignment.center,
//     children: [
//       Container(
//         width: 115.w,
//         height: 115.h,
//         decoration:  BoxDecoration(
//           shape: BoxShape.circle,
//           color:colors.onTertiary,
//         ),
//       ),
//     Container(
//     width: 100.w,
//     height: 100.h,
//     decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: colors.onTertiary
//     ),
//     child: ClipOval(
//       child: Image.asset(
//         assetPath,
//         width: 100.w,
//         height: 100.h,
//         fit: BoxFit.cover,
//       ),
//     ),
//   )
//     ],
//   );
// }
// // PAGE 3 - Image Quality Grid
// class OnboardingPage3 extends StatelessWidget {
//   const OnboardingPage3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//           SizedBox(height: 120.h,),
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
//                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
//                 final List<String> imagePaths = [
//                   'assets/images/Ellipse 81 (1).png',
//                   'assets/images/Ellipse 82.png',
//                   'assets/images/Ellipse 83.png',
//                   'assets/images/Ellipse 81 (2).png',
//                   'assets/images/Ellipse 82 (1).png',
//                   'assets/images/Ellipse 833.png',
//                 ];
//
//                 return Stack(
//                   children: [
//                     ClipRRect(
//                       child: Image.asset(
//                         imagePaths[index],
//                         width: 105.w,
//                         height: 105.h,
//                       ),
//                     ),
//                     if (showCloseIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.red,
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       )
//                     else if (showCheckIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.green,
//                           child: Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 210.h),
//           Text(
//             "Maintain image quality",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "Capture the full body if possible. The head must be \nvisible.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage4 extends StatelessWidget {
//   const OnboardingPage4({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//            SizedBox(height: 60.h),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 210.h,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.r),
//                         child: Image.asset(
//                           'assets/images/Rectangle 3194.png',
//                           height: 230.h,
//                           width: 142.w,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3197.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3194.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 10.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3195.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3196.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 SizedBox(
//                   width: 370.w,
//                   height: 120.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15.r),
//                     child: AspectRatio(
//                       aspectRatio: 3.5,
//                       child: Image.asset(
//                         'assets/images/Rectangle 319.png',
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 150.h),
//           Text(
//             "Ensure your dog stays \n healthy and active.",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../app_preferences.dart';
//
// class Wizardview extends StatefulWidget {
//   const Wizardview({super.key});
//
//   @override
//   State<Wizardview> createState() => _WizardviewState();
// }
//
// class _WizardviewState extends State<Wizardview> {
//   final PageController _pageController = PageController();
//   int currentPage = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor:colors.onBackground,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (i) => setState(() => currentPage = i),
//                 children: const [
//                   OnboardingPage1(),
//                   OnboardingPage2(),
//                   OnboardingPage3(),
//                   OnboardingPage4(),
//                 ],
//               ),
//             ),
//
//             // Bottom Navigation Bar
//             Container(
//               height: 100.h,
//               color: colors.onBackground,
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (currentPage < 3)
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           RoutesName.dashboard,
//                               (route) => false,
//                         );
//                       },
//                       child:  Text(
//                         "Skip",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     )
//                   else
//                     SizedBox(width: 50.w),
//
//                   // Page Dots
//                   Row(
//                     children: List.generate(
//                       4,
//                           (i) => AnimatedContainer(
//                         duration:  const Duration(milliseconds: 300),
//                         margin:  const EdgeInsets.only(right: 8),
//                         width: currentPage == i ? 28 : 10,
//                         height: 10.h,
//                         decoration: BoxDecoration(
//                           color: currentPage == i
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Next / Get Started Button
//                   GestureDetector(
//                     onTap: () async {
//                       if (currentPage == 3) {
//                         await AppPreferences.markOnboardingShown();
//                         if (context.mounted) {
//                           Navigator.pushNamedAndRemoveUntil(
//                             context,
//                             RoutesName.dashboard,
//                             (route) => false,
//                           );
//                         }
//                       } else {
//                         _pageController.nextPage(
//                           duration: const Duration(milliseconds: 400),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 36,
//                         vertical: 14,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 12,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         currentPage == 3 ? "Get Started" : "Next",
//                         style: TextStyle(
//                           color: colors.onBackground,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class OnboardingPage1 extends StatelessWidget {
//   const OnboardingPage1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Padding(
//       padding: EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h),
//           Text(
//             "Satellite Director",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             "Explore Nearby Places with GPS Satellite\nMapping & Find Satellite",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 40.h),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer glow
//                 Container(
//                   width: 360.w,
//                   height: 360.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF00D9FF).withOpacity(0.6),
//                         blurRadius: 54,
//                         spreadRadius: 0,
//                         offset: Offset.zero,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Middle Circle
//                 Container(
//                   width: 300.w,
//                   height: 300.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: colors.onTertiary,
//                   ),
//                 ),
//                 // Inner Circle
//                 Container(
//                   width: 240.w,
//                   height: 240.w,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF7B2CBF),
//                   ),
//                 ),
//                 // Dog Image
//                 Image.asset(
//                   'assets/images/ddoogg 1.png',
//                   width: 350.w,
//                   height: 400.h,
//                   fit: BoxFit.contain,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage2 extends StatelessWidget {
//   const  OnboardingPage2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding:  EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h,),
//           SizedBox(
//             width: 380.w,
//             height: 420.h,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer glow
//                 Container(
//                   width: 400.w,
//                   height: 380.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
//                         blurRadius: 54,
//                         spreadRadius: 0,
//                         offset: Offset.zero,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 320.w,
//                   height: 320.h,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: colors.onTertiary
//                   ),
//                 ),
//                 Container(
//                   width: 260.w,
//                   height: 260.h,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color:Color(0xFF7B2CBF),
//                   ),
//                 ),
//                 ClipOval(
//                   child: Image.asset(
//                     'assets/images/Ellipse 77.png',
//                     width: 258.w,
//                     height: 260.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
//                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
//                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
//               ],
//             ),
//           ),
//           SizedBox(height: 140.h),
//           Text(
//             "We need your\n permission",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "We need camera permission so you can make live \nscans of your pet.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
//   final colors = Theme.of(context).colorScheme;
//   return Stack(
//     alignment: Alignment.center,
//     children: [
//       Container(
//         width: 115.w,
//         height: 115.h,
//         decoration:  BoxDecoration(
//           shape: BoxShape.circle,
//           color:colors.onTertiary,
//         ),
//       ),
//       Container(
//         width: 100.w,
//         height: 100.h,
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: colors.onTertiary
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             assetPath,
//             width: 100.w,
//             height: 100.h,
//             fit: BoxFit.cover,
//           ),
//         ),
//       )
//     ],
//   );
// }
// // PAGE 3 - Image Quality Grid
// class OnboardingPage3 extends StatelessWidget {
//   const OnboardingPage3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//           SizedBox(height: 120.h,),
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
//                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
//                 final List<String> imagePaths = [
//                   'assets/images/Ellipse 81 (1).png',
//                   'assets/images/Ellipse 82.png',
//                   'assets/images/Ellipse 83.png',
//                   'assets/images/Ellipse 81 (2).png',
//                   'assets/images/Ellipse 82 (1).png',
//                   'assets/images/Ellipse 833.png',
//                 ];
//
//                 return Stack(
//                   children: [
//                     ClipRRect(
//                       child: Image.asset(
//                         imagePaths[index],
//                         width: 105.w,
//                         height: 105.h,
//                       ),
//                     ),
//                     if (showCloseIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.red,
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       )
//                     else if (showCheckIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.green,
//                           child: Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 210.h),
//           Text(
//             "Maintain image quality",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "Capture the full body if possible. The head must be \nvisible.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage4 extends StatelessWidget {
//   const OnboardingPage4({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 213.h,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.r),
//                         child: Image.asset(
//                           'assets/images/Rectangle 3194.png',
//                           height: 230.h,
//                           width: 142.w,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3197.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3194.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 7.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3195.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3196.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 SizedBox(
//                   width: 370.w,
//                   height: 120.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15.r),
//                     child: AspectRatio(
//                       aspectRatio: 3.5,
//                       child: Image.asset(
//                         'assets/images/Rectangle 319.png',
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 150.h),
//           Text(
//             "Ensure your dog stays \n healthy and active.",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class Wizardview extends StatefulWidget {
// //   const Wizardview({super.key});
// //
// //   @override
// //   State<Wizardview> createState() => _WizardviewState();
// // }
// //
// // class _WizardviewState extends State<Wizardview> {
// //   final PageController _pageController = PageController();
// //   int currentPage = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Scaffold(
// //       backgroundColor:colors.onBackground,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: PageView(
// //                 controller: _pageController,
// //                 onPageChanged: (i) => setState(() => currentPage = i),
// //                 children: const [
// //                   OnboardingPage1(),
// //                   OnboardingPage2(),
// //                   OnboardingPage3(),
// //                   OnboardingPage4(),
// //                 ],
// //               ),
// //             ),
// //
// //             // Bottom Navigation Bar
// //             Container(
// //               height: 100.h,
// //               color: colors.onBackground,
// //               padding: const EdgeInsets.symmetric(horizontal: 24),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   if (currentPage < 3)
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pushNamedAndRemoveUntil(
// //                           context,
// //                           RoutesName.dashboard,
// //                               (route) => false,
// //                         );
// //                       },
// //                       child:  Text(
// //                         "Skip",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 17.sp,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     )
// //                   else
// //                      SizedBox(width: 50.w),
// //
// //                   // Page Dots
// //                   Row(
// //                     children: List.generate(
// //                       4,
// //                       (i) => AnimatedContainer(
// //                         duration:  const Duration(milliseconds: 300),
// //                         margin:  const EdgeInsets.only(right: 8),
// //                         width: currentPage == i ? 28 : 10,
// //                         height: 10.h,
// //                         decoration: BoxDecoration(
// //                           color: currentPage == i
// //                               ? Colors.white
// //                               : Colors.white.withOpacity(0.4),
// //                           borderRadius: BorderRadius.circular(5),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   // Next / Get Started Button
// //                   GestureDetector(
// //                     onTap: () {
// //                       if (currentPage == 3) {
// //                         Navigator.pushNamedAndRemoveUntil(
// //                           context,
// //                           RoutesName.dashboard,
// //                               (route) => false,
// //                         );
// //                       } else {
// //                         _pageController.nextPage(
// //                           duration: const Duration(milliseconds: 400),
// //                           curve: Curves.easeInOut,
// //                         );
// //                       }
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 36,
// //                         vertical: 14,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(30),
// //                         boxShadow: const [
// //                           BoxShadow(
// //                             color: Colors.black26,
// //                             blurRadius: 12,
// //                             offset: Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Text(
// //                         currentPage == 3 ? "Get Started" : "Next",
// //                         style: TextStyle(
// //                           color: colors.onBackground,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // class OnboardingPage1 extends StatelessWidget {
// //   const OnboardingPage1({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     final bool _ = Theme.of(context).brightness == Brightness.dark;
// //     return Padding(
// //       padding:  EdgeInsets.all(10.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h,),
// //           Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               Container(
// //                 width: 360.w,
// //                 height: 360.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color:  const Color(0xFF00D9FF).withOpacity(0.6),  // Light theme
// //                       blurRadius: 54,
// //                       spreadRadius: 0,
// //                       offset: Offset.zero,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Container(
// //                 width: 340.w,
// //                 height: 340.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: colors.onTertiary,
// //
// //                 ),
// //               ),
// //               Container(
// //                 width: 280.w,
// //                 height: 245.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                     color: colors.onBackground
// //                 ),
// //               ),
// //               ClipOval(
// //                 child: Image.asset(
// //                   'assets/images/Ellipse 777.png',
// //                   width: 246.w,
// //                   height: 266.h,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 210.h),
// //            Text(
// //             "Find Out Your Dog's\nBreed Fast!",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //                 color: Colors.white
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //            Text(
// //             "Capture a photo or upload from your gallery\nand discover your dog’s breed instantly!",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage2 extends StatelessWidget {
// //   const  OnboardingPage2({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
// //     return Padding(
// //       padding:  EdgeInsets.all(16.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h,),
// //           SizedBox(
// //             width: 380.w,
// //             height: 420.h,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 // Outer glow
// //                 Container(
// //                   width: 400.w,
// //                   height: 380.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
// //                         blurRadius: 54,
// //                         spreadRadius: 0,
// //                         offset: Offset.zero,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 320.w,
// //                   height: 320.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: colors.onTertiary
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 260.w,
// //                   height: 260.h,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color:Color(0xFF7B2CBF),
// //                   ),
// //                 ),
// //                 ClipOval(
// //                   child: Image.asset(
// //                     'assets/images/Ellipse 77.png',
// //                     width: 258.w,
// //                     height: 260.h,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
// //                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
// //                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 140.h),
// //            Text(
// //             "We need your\n permission",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "We need camera permission so you can make live \nscans of your pet.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
// //   final colors = Theme.of(context).colorScheme;
// //   return Stack(
// //     alignment: Alignment.center,
// //     children: [
// //       Container(
// //         width: 115.w,
// //         height: 115.h,
// //         decoration:  BoxDecoration(
// //           shape: BoxShape.circle,
// //           color:colors.onTertiary,
// //         ),
// //       ),
// //     Container(
// //     width: 100.w,
// //     height: 100.h,
// //     decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: colors.onTertiary
// //     ),
// //     child: ClipOval(
// //       child: Image.asset(
// //         assetPath,
// //         width: 100.w,
// //         height: 100.h,
// //         fit: BoxFit.cover,
// //       ),
// //     ),
// //   )
// //     ],
// //   );
// // }
// // // PAGE 3 - Image Quality Grid
// // class OnboardingPage3 extends StatelessWidget {
// //   const OnboardingPage3({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 120.h,),
// //           Expanded(
// //             child: GridView.builder(
// //               physics: const NeverScrollableScrollPhysics(),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 crossAxisSpacing: 16,
// //                 mainAxisSpacing: 10,
// //               ),
// //               itemCount: 6,
// //               itemBuilder: (context, index) {
// //                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
// //                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
// //                 final List<String> imagePaths = [
// //                   'assets/images/Ellipse 81 (1).png',
// //                   'assets/images/Ellipse 82.png',
// //                   'assets/images/Ellipse 83.png',
// //                   'assets/images/Ellipse 81 (2).png',
// //                   'assets/images/Ellipse 82 (1).png',
// //                   'assets/images/Ellipse 833.png',
// //                 ];
// //
// //                 return Stack(
// //                   children: [
// //                     ClipRRect(
// //                       child: Image.asset(
// //                         imagePaths[index],
// //                         width: 105.w,
// //                         height: 105.h,
// //                       ),
// //                     ),
// //                     if (showCloseIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.red,
// //                           child: Icon(
// //                             Icons.close,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       )
// //                     else if (showCheckIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.green,
// //                           child: Icon(
// //                             Icons.check,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           SizedBox(height: 210.h),
// //           Text(
// //             "Maintain image quality",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Capture the full body if possible. The head must be \nvisible.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage4 extends StatelessWidget {
// //   const OnboardingPage4({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //            SizedBox(height: 60.h),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   height: 210.h,
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(15.r),
// //                         child: Image.asset(
// //                           'assets/images/Rectangle 3194.png',
// //                           height: 230.h,
// //                           width: 142.w,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3197.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3194.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3195.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3196.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 20.h),
// //                 SizedBox(
// //                   width: 370.w,
// //                   height: 120.h,
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(15.r),
// //                     child: AspectRatio(
// //                       aspectRatio: 3.5,
// //                       child: Image.asset(
// //                         'assets/images/Rectangle 319.png',
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 150.h),
// //           Text(
// //             "Ensure your dog stays \n healthy and active.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }




// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../l10n/app_localizations.dart';
//
// class Wizardview extends StatefulWidget {
//   const Wizardview({super.key});
//
//   @override
//   State<Wizardview> createState() => _WizardviewState();
// }
//
// class _WizardviewState extends State<Wizardview> {
//   final PageController _pageController = PageController();
//   int currentPage = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor:colors.onBackground,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (i) => setState(() => currentPage = i),
//                 children: const [
//                   OnboardingPage1(),
//                   OnboardingPage2(),
//                   OnboardingPage3(),
//                   OnboardingPage4(),
//                 ],
//               ),
//             ),
//
//             // Bottom Navigation Bar
//             Expanded(
//               child: Container(
//                 height: 100.h,
//                 color: colors.onBackground,
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (currentPage < 3)
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamedAndRemoveUntil(
//                             context,
//                             RoutesName.dashboard,
//                                 (route) => false,
//                           );
//                         },
//                         child:  Text(
//                           AppLocalizations.of(context)!.skip,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       )
//                     else
//                       SizedBox(width: 50.w),
//
//                     // Page Dots
//                     Row(
//                       children: List.generate(
//                         4,
//                             (i) => AnimatedContainer(
//                           duration:  const Duration(milliseconds: 300),
//                           margin:  const EdgeInsets.only(right: 8),
//                           width: currentPage == i ? 28 : 10,
//                           height: 10.h,
//                           decoration: BoxDecoration(
//                             color: currentPage == i
//                                 ? Colors.white
//                                 : Colors.white.withOpacity(0.4),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // Next / Get Started Button
//                     GestureDetector(
//                       onTap: () {
//                         if (currentPage == 3) {
//                           Navigator.pushNamedAndRemoveUntil(
//                             context,
//                             RoutesName.dashboard,
//                                 (route) => false,
//                           );
//                         } else {
//                           _pageController.nextPage(
//                             duration: const Duration(milliseconds: 400),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 36,
//                           vertical: 14,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 12,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           currentPage == 3 ? AppLocalizations.of(context)!.getStarted : AppLocalizations.of(context)!.next,
//                           style: TextStyle(
//                             color: colors.onBackground,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class OnboardingPage1 extends StatelessWidget {
//   const OnboardingPage1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Padding(
//       padding: EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingTitle1,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingDesc1,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 40.h),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer glow
//                 Container(
//                   width: 360.w,
//                   height: 360.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF00D9FF).withOpacity(0.6),
//                         blurRadius: 54,
//                         spreadRadius: 0,
//                         offset: Offset.zero,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Middle Circle
//                 Container(
//                   width: 300.w,
//                   height: 300.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: colors.onTertiary,
//                   ),
//                 ),
//                 // Inner Circle
//                 Container(
//                   width: 240.w,
//                   height: 240.w,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFF7B2CBF),
//                   ),
//                 ),
//                 // Dog Image
//                 Image.asset(
//                   'assets/images/ddoogg 1.png',
//                   width: 350.w,
//                   height: 400.h,
//                   fit: BoxFit.contain,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage2 extends StatelessWidget {
//   const  OnboardingPage2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding:  EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h,),
//           SizedBox(
//             width: 380.w,
//             height: 420.h,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer glow
//                 Container(
//                   width: 400.w,
//                   height: 380.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
//                         blurRadius: 54,
//                         spreadRadius: 0,
//                         offset: Offset.zero,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 320.w,
//                   height: 320.h,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: colors.onTertiary
//                   ),
//                 ),
//                 Container(
//                   width: 260.w,
//                   height: 260.h,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color:Color(0xFF7B2CBF),
//                   ),
//                 ),
//                 ClipOval(
//                   child: Image.asset(
//                     'assets/images/Ellipse 77.png',
//                     width: 258.w,
//                     height: 260.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
//                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
//                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
//               ],
//             ),
//           ),
//           SizedBox(height: 140.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingTitle2,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingDesc2,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
//   final colors = Theme.of(context).colorScheme;
//   return Stack(
//     alignment: Alignment.center,
//     children: [
//       Container(
//         width: 115.w,
//         height: 115.h,
//         decoration:  BoxDecoration(
//           shape: BoxShape.circle,
//           color:colors.onTertiary,
//         ),
//       ),
//       Container(
//         width: 100.w,
//         height: 100.h,
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: colors.onTertiary
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             assetPath,
//             width: 100.w,
//             height: 100.h,
//             fit: BoxFit.cover,
//           ),
//         ),
//       )
//     ],
//   );
// }
// // PAGE 3 - Image Quality Grid
// class OnboardingPage3 extends StatelessWidget {
//   const OnboardingPage3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//           SizedBox(height: 120.h,),
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
//                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
//                 final List<String> imagePaths = [
//                   'assets/images/Ellipse 81 (1).png',
//                   'assets/images/Ellipse 82.png',
//                   'assets/images/Ellipse 83.png',
//                   'assets/images/Ellipse 81 (2).png',
//                   'assets/images/Ellipse 82 (1).png',
//                   'assets/images/Ellipse 833.png',
//                 ];
//
//                 return Stack(
//                   children: [
//                     ClipRRect(
//                       child: Image.asset(
//                         imagePaths[index],
//                         width: 105.w,
//                         height: 105.h,
//                       ),
//                     ),
//                     if (showCloseIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.red,
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       )
//                     else if (showCheckIcon)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: CircleAvatar(
//                           radius: 15.r,
//                           backgroundColor: Colors.green,
//                           child: Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 20.sp,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 210.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingTitle3,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingDesc3,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage4 extends StatelessWidget {
//   const OnboardingPage4({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all(32.r),
//       child: Column(
//         children: [
//           SizedBox(height: 60.h),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 213.h,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(15.r),
//                         child: Image.asset(
//                           'assets/images/Rectangle 3194.png',
//                           height: 230.h,
//                           width: 142.w,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(width: 10.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3197.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3194.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 7.w),
//                       Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3195.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15.r),
//                             child: Image.asset(
//                               'assets/images/Rectangle 3196.png',
//                               width: 100.w,
//                               height: 100.w,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 SizedBox(
//                   width: 370.w,
//                   height: 120.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15.r),
//                     child: AspectRatio(
//                       aspectRatio: 3.5,
//                       child: Image.asset(
//                         'assets/images/Rectangle 319.png',
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 150.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingTitle4,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 26.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             AppLocalizations.of(context)!.onboardingDesc4,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class Wizardview extends StatefulWidget {
// //   const Wizardview({super.key});
// //
// //   @override
// //   State<Wizardview> createState() => _WizardviewState();
// // }
// //
// // class _WizardviewState extends State<Wizardview> {
// //   final PageController _pageController = PageController();
// //   int currentPage = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Scaffold(
// //       backgroundColor:colors.onBackground,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: PageView(
// //                 controller: _pageController,
// //                 onPageChanged: (i) => setState(() => currentPage = i),
// //                 children: const [
// //                   OnboardingPage1(),
// //                   OnboardingPage2(),
// //                   OnboardingPage3(),
// //                   OnboardingPage4(),
// //                 ],
// //               ),
// //             ),
// //
// //             // Bottom Navigation Bar
// //             Container(
// //               height: 100.h,
// //               color: colors.onBackground,
// //               padding: const EdgeInsets.symmetric(horizontal: 24),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   if (currentPage < 3)
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pushNamedAndRemoveUntil(
// //                           context,
// //                           RoutesName.dashboard,
// //                               (route) => false,
// //                         );
// //                       },
// //                       child:  Text(
// //                         "Skip",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 17.sp,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     )
// //                   else
// //                      SizedBox(width: 50.w),
// //
// //                   // Page Dots
// //                   Row(
// //                     children: List.generate(
// //                       4,
// //                       (i) => AnimatedContainer(
// //                         duration:  const Duration(milliseconds: 300),
// //                         margin:  const EdgeInsets.only(right: 8),
// //                         width: currentPage == i ? 28 : 10,
// //                         height: 10.h,
// //                         decoration: BoxDecoration(
// //                           color: currentPage == i
// //                               ? Colors.white
// //                               : Colors.white.withOpacity(0.4),
// //                           borderRadius: BorderRadius.circular(5),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   // Next / Get Started Button
// //                   GestureDetector(
// //                     onTap: () {
// //                       if (currentPage == 3) {
// //                         Navigator.pushNamedAndRemoveUntil(
// //                           context,
// //                           RoutesName.dashboard,
// //                               (route) => false,
// //                         );
// //                       } else {
// //                         _pageController.nextPage(
// //                           duration: const Duration(milliseconds: 400),
// //                           curve: Curves.easeInOut,
// //                         );
// //                       }
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 36,
// //                         vertical: 14,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(30),
// //                         boxShadow: const [
// //                           BoxShadow(
// //                             color: Colors.black26,
// //                             blurRadius: 12,
// //                             offset: Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Text(
// //                         currentPage == 3 ? "Get Started" : "Next",
// //                         style: TextStyle(
// //                           color: colors.onBackground,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // class OnboardingPage1 extends StatelessWidget {
// //   const OnboardingPage1({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     final bool _ = Theme.of(context).brightness == Brightness.dark;
// //     return Padding(
// //       padding:  EdgeInsets.all(10.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h,),
// //           Stack(
// //             alignment: Alignment.center,
// //             children: [
// //               Container(
// //                 width: 360.w,
// //                 height: 360.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color:  const Color(0xFF00D9FF).withOpacity(0.6),  // Light theme
// //                       blurRadius: 54,
// //                       spreadRadius: 0,
// //                       offset: Offset.zero,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Container(
// //                 width: 340.w,
// //                 height: 340.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: colors.onTertiary,
// //
// //                 ),
// //               ),
// //               Container(
// //                 width: 280.w,
// //                 height: 245.h,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                     color: colors.onBackground
// //                 ),
// //               ),
// //               ClipOval(
// //                 child: Image.asset(
// //                   'assets/images/Ellipse 777.png',
// //                   width: 246.w,
// //                   height: 266.h,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 210.h),
// //            Text(
// //             "Find Out Your Dog's\nBreed Fast!",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //                 color: Colors.white
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //            Text(
// //             "Capture a photo or upload from your gallery\nand discover your dog’s breed instantly!",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage2 extends StatelessWidget {
// //   const  OnboardingPage2({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
// //     return Padding(
// //       padding:  EdgeInsets.all(16.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h,),
// //           SizedBox(
// //             width: 380.w,
// //             height: 420.h,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 // Outer glow
// //                 Container(
// //                   width: 400.w,
// //                   height: 380.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
// //                         blurRadius: 54,
// //                         spreadRadius: 0,
// //                         offset: Offset.zero,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 320.w,
// //                   height: 320.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: colors.onTertiary
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 260.w,
// //                   height: 260.h,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color:Color(0xFF7B2CBF),
// //                   ),
// //                 ),
// //                 ClipOval(
// //                   child: Image.asset(
// //                     'assets/images/Ellipse 77.png',
// //                     width: 258.w,
// //                     height: 260.h,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
// //                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
// //                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 140.h),
// //            Text(
// //             "We need your\n permission",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "We need camera permission so you can make live \nscans of your pet.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
// //   final colors = Theme.of(context).colorScheme;
// //   return Stack(
// //     alignment: Alignment.center,
// //     children: [
// //       Container(
// //         width: 115.w,
// //         height: 115.h,
// //         decoration:  BoxDecoration(
// //           shape: BoxShape.circle,
// //           color:colors.onTertiary,
// //         ),
// //       ),
// //     Container(
// //     width: 100.w,
// //     height: 100.h,
// //     decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: colors.onTertiary
// //     ),
// //     child: ClipOval(
// //       child: Image.asset(
// //         assetPath,
// //         width: 100.w,
// //         height: 100.h,
// //         fit: BoxFit.cover,
// //       ),
// //     ),
// //   )
// //     ],
// //   );
// // }
// // // PAGE 3 - Image Quality Grid
// // class OnboardingPage3 extends StatelessWidget {
// //   const OnboardingPage3({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 120.h,),
// //           Expanded(
// //             child: GridView.builder(
// //               physics: const NeverScrollableScrollPhysics(),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 crossAxisSpacing: 16,
// //                 mainAxisSpacing: 10,
// //               ),
// //               itemCount: 6,
// //               itemBuilder: (context, index) {
// //                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
// //                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
// //                 final List<String> imagePaths = [
// //                   'assets/images/Ellipse 81 (1).png',
// //                   'assets/images/Ellipse 82.png',
// //                   'assets/images/Ellipse 83.png',
// //                   'assets/images/Ellipse 81 (2).png',
// //                   'assets/images/Ellipse 82 (1).png',
// //                   'assets/images/Ellipse 833.png',
// //                 ];
// //
// //                 return Stack(
// //                   children: [
// //                     ClipRRect(
// //                       child: Image.asset(
// //                         imagePaths[index],
// //                         width: 105.w,
// //                         height: 105.h,
// //                       ),
// //                     ),
// //                     if (showCloseIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.red,
// //                           child: Icon(
// //                             Icons.close,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       )
// //                     else if (showCheckIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.green,
// //                           child: Icon(
// //                             Icons.check,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           SizedBox(height: 210.h),
// //           Text(
// //             "Maintain image quality",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Capture the full body if possible. The head must be \nvisible.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage4 extends StatelessWidget {
// //   const OnboardingPage4({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //            SizedBox(height: 60.h),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   height: 210.h,
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(15.r),
// //                         child: Image.asset(
// //                           'assets/images/Rectangle 3194.png',
// //                           height: 230.h,
// //                           width: 142.w,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3197.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3194.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3195.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3196.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 20.h),
// //                 SizedBox(
// //                   width: 370.w,
// //                   height: 120.h,
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(15.r),
// //                     child: AspectRatio(
// //                       aspectRatio: 3.5,
// //                       child: Image.asset(
// //                         'assets/images/Rectangle 319.png',
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 150.h),
// //           Text(
// //             "Ensure your dog stays \n healthy and active.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // import '../../app_preferences.dart';
// //
// // class Wizardview extends StatefulWidget {
// //   const Wizardview({super.key});
// //
// //   @override
// //   State<Wizardview> createState() => _WizardviewState();
// // }
// //
// // class _WizardviewState extends State<Wizardview> {
// //   final PageController _pageController = PageController();
// //   int currentPage = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Scaffold(
// //       backgroundColor:colors.onBackground,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: PageView(
// //                 controller: _pageController,
// //                 onPageChanged: (i) => setState(() => currentPage = i),
// //                 children: const [
// //                   OnboardingPage1(),
// //                   OnboardingPage2(),
// //                   OnboardingPage3(),
// //                   OnboardingPage4(),
// //                 ],
// //               ),
// //             ),
// //
// //             // Bottom Navigation Bar
// //             Container(
// //               height: 100.h,
// //               color: colors.onBackground,
// //               padding: const EdgeInsets.symmetric(horizontal: 24),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   if (currentPage < 3)
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pushNamedAndRemoveUntil(
// //                           context,
// //                           RoutesName.dashboard,
// //                               (route) => false,
// //                         );
// //                       },
// //                       child:  Text(
// //                         "Skip",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 17.sp,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     )
// //                   else
// //                     SizedBox(width: 50.w),
// //
// //                   // Page Dots
// //                   Row(
// //                     children: List.generate(
// //                       4,
// //                           (i) => AnimatedContainer(
// //                         duration:  const Duration(milliseconds: 300),
// //                         margin:  const EdgeInsets.only(right: 8),
// //                         width: currentPage == i ? 28 : 10,
// //                         height: 10.h,
// //                         decoration: BoxDecoration(
// //                           color: currentPage == i
// //                               ? Colors.white
// //                               : Colors.white.withOpacity(0.4),
// //                           borderRadius: BorderRadius.circular(5),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   // Next / Get Started Button
// //                   GestureDetector(
// //                     onTap: () async {
// //                       if (currentPage == 3) {
// //                         await AppPreferences.markOnboardingShown();
// //                         if (context.mounted) {
// //                           Navigator.pushNamedAndRemoveUntil(
// //                             context,
// //                             RoutesName.dashboard,
// //                             (route) => false,
// //                           );
// //                         }
// //                       } else {
// //                         _pageController.nextPage(
// //                           duration: const Duration(milliseconds: 400),
// //                           curve: Curves.easeInOut,
// //                         );
// //                       }
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 36,
// //                         vertical: 14,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(30),
// //                         boxShadow: const [
// //                           BoxShadow(
// //                             color: Colors.black26,
// //                             blurRadius: 12,
// //                             offset: Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Text(
// //                         currentPage == 3 ? "Get Started" : "Next",
// //                         style: TextStyle(
// //                           color: colors.onBackground,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // class OnboardingPage1 extends StatelessWidget {
// //   const OnboardingPage1({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Padding(
// //       padding: EdgeInsets.all(16.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h),
// //           Text(
// //             "Satellite Director",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 30.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 12.h),
// //           Text(
// //             "Explore Nearby Places with GPS Satellite\nMapping & Find Satellite",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 14.sp,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 40.h),
// //           Expanded(
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 // Outer glow
// //                 Container(
// //                   width: 360.w,
// //                   height: 360.w,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: const Color(0xFF00D9FF).withOpacity(0.6),
// //                         blurRadius: 54,
// //                         spreadRadius: 0,
// //                         offset: Offset.zero,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 // Middle Circle
// //                 Container(
// //                   width: 300.w,
// //                   height: 300.w,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: colors.onTertiary,
// //                   ),
// //                 ),
// //                 // Inner Circle
// //                 Container(
// //                   width: 240.w,
// //                   height: 240.w,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Color(0xFF7B2CBF),
// //                   ),
// //                 ),
// //                 // Dog Image
// //                 Image.asset(
// //                   'assets/images/ddoogg 1.png',
// //                   width: 350.w,
// //                   height: 400.h,
// //                   fit: BoxFit.contain,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage2 extends StatelessWidget {
// //   const  OnboardingPage2({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final colors = Theme.of(context).colorScheme;
// //     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
// //     return Padding(
// //       padding:  EdgeInsets.all(16.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h,),
// //           SizedBox(
// //             width: 380.w,
// //             height: 420.h,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 // Outer glow
// //                 Container(
// //                   width: 400.w,
// //                   height: 380.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
// //                         blurRadius: 54,
// //                         spreadRadius: 0,
// //                         offset: Offset.zero,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 320.w,
// //                   height: 320.h,
// //                   decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: colors.onTertiary
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 260.w,
// //                   height: 260.h,
// //                   decoration: const BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color:Color(0xFF7B2CBF),
// //                   ),
// //                 ),
// //                 ClipOval(
// //                   child: Image.asset(
// //                     'assets/images/Ellipse 77.png',
// //                     width: 258.w,
// //                     height: 260.h,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
// //                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
// //                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 140.h),
// //           Text(
// //             "We need your\n permission",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "We need camera permission so you can make live \nscans of your pet.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
// //   final colors = Theme.of(context).colorScheme;
// //   return Stack(
// //     alignment: Alignment.center,
// //     children: [
// //       Container(
// //         width: 115.w,
// //         height: 115.h,
// //         decoration:  BoxDecoration(
// //           shape: BoxShape.circle,
// //           color:colors.onTertiary,
// //         ),
// //       ),
// //       Container(
// //         width: 100.w,
// //         height: 100.h,
// //         decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: colors.onTertiary
// //         ),
// //         child: ClipOval(
// //           child: Image.asset(
// //             assetPath,
// //             width: 100.w,
// //             height: 100.h,
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //       )
// //     ],
// //   );
// // }
// // // PAGE 3 - Image Quality Grid
// // class OnboardingPage3 extends StatelessWidget {
// //   const OnboardingPage3({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 120.h,),
// //           Expanded(
// //             child: GridView.builder(
// //               physics: const NeverScrollableScrollPhysics(),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 crossAxisSpacing: 16,
// //                 mainAxisSpacing: 10,
// //               ),
// //               itemCount: 6,
// //               itemBuilder: (context, index) {
// //                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
// //                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
// //                 final List<String> imagePaths = [
// //                   'assets/images/Ellipse 81 (1).png',
// //                   'assets/images/Ellipse 82.png',
// //                   'assets/images/Ellipse 83.png',
// //                   'assets/images/Ellipse 81 (2).png',
// //                   'assets/images/Ellipse 82 (1).png',
// //                   'assets/images/Ellipse 833.png',
// //                 ];
// //
// //                 return Stack(
// //                   children: [
// //                     ClipRRect(
// //                       child: Image.asset(
// //                         imagePaths[index],
// //                         width: 105.w,
// //                         height: 105.h,
// //                       ),
// //                     ),
// //                     if (showCloseIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.red,
// //                           child: Icon(
// //                             Icons.close,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       )
// //                     else if (showCheckIcon)
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: CircleAvatar(
// //                           radius: 15.r,
// //                           backgroundColor: Colors.green,
// //                           child: Icon(
// //                             Icons.check,
// //                             color: Colors.white,
// //                             size: 20.sp,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           SizedBox(height: 210.h),
// //           Text(
// //             "Maintain image quality",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Capture the full body if possible. The head must be \nvisible.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class OnboardingPage4 extends StatelessWidget {
// //   const OnboardingPage4({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding:  EdgeInsets.all(32.r),
// //       child: Column(
// //         children: [
// //           SizedBox(height: 60.h),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   height: 213.h,
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(15.r),
// //                         child: Image.asset(
// //                           'assets/images/Rectangle 3194.png',
// //                           height: 230.h,
// //                           width: 142.w,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                       SizedBox(width: 10.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3197.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3194.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(width: 7.w),
// //                       Column(
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3195.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                           SizedBox(height: 5.h),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(15.r),
// //                             child: Image.asset(
// //                               'assets/images/Rectangle 3196.png',
// //                               width: 100.w,
// //                               height: 100.w,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 20.h),
// //                 SizedBox(
// //                   width: 370.w,
// //                   height: 120.h,
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(15.r),
// //                     child: AspectRatio(
// //                       aspectRatio: 3.5,
// //                       child: Image.asset(
// //                         'assets/images/Rectangle 319.png',
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 150.h),
// //           Text(
// //             "Ensure your dog stays \n healthy and active.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontSize: 26.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Text(
// //             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // import 'package:dog_breed/utils/routes/routes_name.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // //
// // // class Wizardview extends StatefulWidget {
// // //   const Wizardview({super.key});
// // //
// // //   @override
// // //   State<Wizardview> createState() => _WizardviewState();
// // // }
// // //
// // // class _WizardviewState extends State<Wizardview> {
// // //   final PageController _pageController = PageController();
// // //   int currentPage = 0;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final colors = Theme.of(context).colorScheme;
// // //     return Scaffold(
// // //       backgroundColor:colors.onBackground,
// // //       body: SafeArea(
// // //         child: Column(
// // //           children: [
// // //             Expanded(
// // //               child: PageView(
// // //                 controller: _pageController,
// // //                 onPageChanged: (i) => setState(() => currentPage = i),
// // //                 children: const [
// // //                   OnboardingPage1(),
// // //                   OnboardingPage2(),
// // //                   OnboardingPage3(),
// // //                   OnboardingPage4(),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             // Bottom Navigation Bar
// // //             Container(
// // //               height: 100.h,
// // //               color: colors.onBackground,
// // //               padding: const EdgeInsets.symmetric(horizontal: 24),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   if (currentPage < 3)
// // //                     TextButton(
// // //                       onPressed: () {
// // //                         Navigator.pushNamedAndRemoveUntil(
// // //                           context,
// // //                           RoutesName.dashboard,
// // //                               (route) => false,
// // //                         );
// // //                       },
// // //                       child:  Text(
// // //                         "Skip",
// // //                         style: TextStyle(
// // //                           color: Colors.white,
// // //                           fontSize: 17.sp,
// // //                           fontWeight: FontWeight.w500,
// // //                         ),
// // //                       ),
// // //                     )
// // //                   else
// // //                      SizedBox(width: 50.w),
// // //
// // //                   // Page Dots
// // //                   Row(
// // //                     children: List.generate(
// // //                       4,
// // //                       (i) => AnimatedContainer(
// // //                         duration:  const Duration(milliseconds: 300),
// // //                         margin:  const EdgeInsets.only(right: 8),
// // //                         width: currentPage == i ? 28 : 10,
// // //                         height: 10.h,
// // //                         decoration: BoxDecoration(
// // //                           color: currentPage == i
// // //                               ? Colors.white
// // //                               : Colors.white.withOpacity(0.4),
// // //                           borderRadius: BorderRadius.circular(5),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //
// // //                   // Next / Get Started Button
// // //                   GestureDetector(
// // //                     onTap: () {
// // //                       if (currentPage == 3) {
// // //                         Navigator.pushNamedAndRemoveUntil(
// // //                           context,
// // //                           RoutesName.dashboard,
// // //                               (route) => false,
// // //                         );
// // //                       } else {
// // //                         _pageController.nextPage(
// // //                           duration: const Duration(milliseconds: 400),
// // //                           curve: Curves.easeInOut,
// // //                         );
// // //                       }
// // //                     },
// // //                     child: Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                         horizontal: 36,
// // //                         vertical: 14,
// // //                       ),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(30),
// // //                         boxShadow: const [
// // //                           BoxShadow(
// // //                             color: Colors.black26,
// // //                             blurRadius: 12,
// // //                             offset: Offset(0, 4),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       child: Text(
// // //                         currentPage == 3 ? "Get Started" : "Next",
// // //                         style: TextStyle(
// // //                           color: colors.onBackground,
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 16,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // // class OnboardingPage1 extends StatelessWidget {
// // //   const OnboardingPage1({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final colors = Theme.of(context).colorScheme;
// // //     final bool _ = Theme.of(context).brightness == Brightness.dark;
// // //     return Padding(
// // //       padding:  EdgeInsets.all(10.r),
// // //       child: Column(
// // //         children: [
// // //           SizedBox(height: 60.h,),
// // //           Stack(
// // //             alignment: Alignment.center,
// // //             children: [
// // //               Container(
// // //                 width: 360.w,
// // //                 height: 360.h,
// // //                 decoration: BoxDecoration(
// // //                   shape: BoxShape.circle,
// // //
// // //                   boxShadow: [
// // //                     BoxShadow(
// // //                       color:  const Color(0xFF00D9FF).withOpacity(0.6),  // Light theme
// // //                       blurRadius: 54,
// // //                       spreadRadius: 0,
// // //                       offset: Offset.zero,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               Container(
// // //                 width: 340.w,
// // //                 height: 340.h,
// // //                 decoration: BoxDecoration(
// // //                   shape: BoxShape.circle,
// // //                   color: colors.onTertiary,
// // //
// // //                 ),
// // //               ),
// // //               Container(
// // //                 width: 280.w,
// // //                 height: 245.h,
// // //                 decoration: BoxDecoration(
// // //                   shape: BoxShape.circle,
// // //                     color: colors.onBackground
// // //                 ),
// // //               ),
// // //               ClipOval(
// // //                 child: Image.asset(
// // //                   'assets/images/Ellipse 777.png',
// // //                   width: 246.w,
// // //                   height: 266.h,
// // //                   fit: BoxFit.cover,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           SizedBox(height: 210.h),
// // //            Text(
// // //             "Find Out Your Dog's\nBreed Fast!",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(
// // //               fontSize: 26.sp,
// // //               fontWeight: FontWeight.bold,
// // //                 color: Colors.white
// // //             ),
// // //           ),
// // //           SizedBox(height: 16.h),
// // //            Text(
// // //             "Capture a photo or upload from your gallery\nand discover your dog’s breed instantly!",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class OnboardingPage2 extends StatelessWidget {
// // //   const  OnboardingPage2({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final colors = Theme.of(context).colorScheme;
// // //     final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
// // //     return Padding(
// // //       padding:  EdgeInsets.all(16.r),
// // //       child: Column(
// // //         children: [
// // //           SizedBox(height: 60.h,),
// // //           SizedBox(
// // //             width: 380.w,
// // //             height: 420.h,
// // //             child: Stack(
// // //               alignment: Alignment.center,
// // //               children: [
// // //                 // Outer glow
// // //                 Container(
// // //                   width: 400.w,
// // //                   height: 380.h,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                         color:  const Color(0xFF00D9FF).withOpacity(0.6),
// // //                         blurRadius: 54,
// // //                         spreadRadius: 0,
// // //                         offset: Offset.zero,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Container(
// // //                   width: 320.w,
// // //                   height: 320.h,
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     color: colors.onTertiary
// // //                   ),
// // //                 ),
// // //                 Container(
// // //                   width: 260.w,
// // //                   height: 260.h,
// // //                   decoration: const BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     color:Color(0xFF7B2CBF),
// // //                   ),
// // //                 ),
// // //                 ClipOval(
// // //                   child: Image.asset(
// // //                     'assets/images/Ellipse 77.png',
// // //                     width: 258.w,
// // //                     height: 260.h,
// // //                     fit: BoxFit.cover,
// // //                   ),
// // //                 ),
// // //                 Positioned(top: 50.h,  left: 45.w,   child: _buildSmallDogCircle('assets/images/Ellipse 789.png', context)),
// // //                 Positioned(top: 160.h,  right: 10.w,  child: _buildSmallDogCircle('assets/images/Ellipse 788.png',context)),
// // //                 Positioned(bottom: 38.h, left: 68.w, child: _buildSmallDogCircle('assets/images/Ellipse 808.png',context)),
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: 140.h),
// // //            Text(
// // //             "We need your\n permission",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(
// // //               fontSize: 26.sp,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           SizedBox(height: 16.h),
// // //           Text(
// // //             "We need camera permission so you can make live \nscans of your pet.",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // // Widget _buildSmallDogCircle(String assetPath, BuildContext context) {
// // //   final colors = Theme.of(context).colorScheme;
// // //   return Stack(
// // //     alignment: Alignment.center,
// // //     children: [
// // //       Container(
// // //         width: 115.w,
// // //         height: 115.h,
// // //         decoration:  BoxDecoration(
// // //           shape: BoxShape.circle,
// // //           color:colors.onTertiary,
// // //         ),
// // //       ),
// // //     Container(
// // //     width: 100.w,
// // //     height: 100.h,
// // //     decoration: BoxDecoration(
// // //         shape: BoxShape.circle,
// // //         color: colors.onTertiary
// // //     ),
// // //     child: ClipOval(
// // //       child: Image.asset(
// // //         assetPath,
// // //         width: 100.w,
// // //         height: 100.h,
// // //         fit: BoxFit.cover,
// // //       ),
// // //     ),
// // //   )
// // //     ],
// // //   );
// // // }
// // // // PAGE 3 - Image Quality Grid
// // // class OnboardingPage3 extends StatelessWidget {
// // //   const OnboardingPage3({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding:  EdgeInsets.all(32.r),
// // //       child: Column(
// // //         children: [
// // //           SizedBox(height: 120.h,),
// // //           Expanded(
// // //             child: GridView.builder(
// // //               physics: const NeverScrollableScrollPhysics(),
// // //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //                 crossAxisCount: 3,
// // //                 crossAxisSpacing: 16,
// // //                 mainAxisSpacing: 10,
// // //               ),
// // //               itemCount: 6,
// // //               itemBuilder: (context, index) {
// // //                 bool showCloseIcon = index == 0 || index == 1 || index == 3;
// // //                 bool showCheckIcon = index == 2 || index == 4 || index == 5;
// // //                 final List<String> imagePaths = [
// // //                   'assets/images/Ellipse 81 (1).png',
// // //                   'assets/images/Ellipse 82.png',
// // //                   'assets/images/Ellipse 83.png',
// // //                   'assets/images/Ellipse 81 (2).png',
// // //                   'assets/images/Ellipse 82 (1).png',
// // //                   'assets/images/Ellipse 833.png',
// // //                 ];
// // //
// // //                 return Stack(
// // //                   children: [
// // //                     ClipRRect(
// // //                       child: Image.asset(
// // //                         imagePaths[index],
// // //                         width: 105.w,
// // //                         height: 105.h,
// // //                       ),
// // //                     ),
// // //                     if (showCloseIcon)
// // //                       Positioned(
// // //                         top: 6,
// // //                         right: 6,
// // //                         child: CircleAvatar(
// // //                           radius: 15.r,
// // //                           backgroundColor: Colors.red,
// // //                           child: Icon(
// // //                             Icons.close,
// // //                             color: Colors.white,
// // //                             size: 20.sp,
// // //                           ),
// // //                         ),
// // //                       )
// // //                     else if (showCheckIcon)
// // //                       Positioned(
// // //                         top: 6,
// // //                         right: 6,
// // //                         child: CircleAvatar(
// // //                           radius: 15.r,
// // //                           backgroundColor: Colors.green,
// // //                           child: Icon(
// // //                             Icons.check,
// // //                             color: Colors.white,
// // //                             size: 20.sp,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                   ],
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //           SizedBox(height: 210.h),
// // //           Text(
// // //             "Maintain image quality",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(
// // //               fontSize: 26.sp,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           SizedBox(height: 16.h),
// // //           Text(
// // //             "Capture the full body if possible. The head must be \nvisible.",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class OnboardingPage4 extends StatelessWidget {
// // //   const OnboardingPage4({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding:  EdgeInsets.all(32.r),
// // //       child: Column(
// // //         children: [
// // //            SizedBox(height: 60.h),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 SizedBox(
// // //                   height: 210.h,
// // //                   child: Row(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       ClipRRect(
// // //                         borderRadius: BorderRadius.circular(15.r),
// // //                         child: Image.asset(
// // //                           'assets/images/Rectangle 3194.png',
// // //                           height: 230.h,
// // //                           width: 142.w,
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: 10.w),
// // //                       Column(
// // //                         children: [
// // //                           ClipRRect(
// // //                             borderRadius: BorderRadius.circular(15.r),
// // //                             child: Image.asset(
// // //                               'assets/images/Rectangle 3197.png',
// // //                               width: 100.w,
// // //                               height: 100.w,
// // //                               fit: BoxFit.cover,
// // //                             ),
// // //                           ),
// // //                           SizedBox(height: 5.h),
// // //                           ClipRRect(
// // //                             borderRadius: BorderRadius.circular(15.r),
// // //                             child: Image.asset(
// // //                               'assets/images/Rectangle 3194.png',
// // //                               width: 100.w,
// // //                               height: 100.w,
// // //                               fit: BoxFit.cover,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       SizedBox(width: 10.w),
// // //                       Column(
// // //                         children: [
// // //                           ClipRRect(
// // //                             borderRadius: BorderRadius.circular(15.r),
// // //                             child: Image.asset(
// // //                               'assets/images/Rectangle 3195.png',
// // //                               width: 100.w,
// // //                               height: 100.w,
// // //                               fit: BoxFit.cover,
// // //                             ),
// // //                           ),
// // //                           SizedBox(height: 5.h),
// // //                           ClipRRect(
// // //                             borderRadius: BorderRadius.circular(15.r),
// // //                             child: Image.asset(
// // //                               'assets/images/Rectangle 3196.png',
// // //                               width: 100.w,
// // //                               height: 100.w,
// // //                               fit: BoxFit.cover,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 20.h),
// // //                 SizedBox(
// // //                   width: 370.w,
// // //                   height: 120.h,
// // //                   child: ClipRRect(
// // //                     borderRadius: BorderRadius.circular(15.r),
// // //                     child: AspectRatio(
// // //                       aspectRatio: 3.5,
// // //                       child: Image.asset(
// // //                         'assets/images/Rectangle 319.png',
// // //                         fit: BoxFit.cover,
// // //                         width: double.infinity,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: 150.h),
// // //           Text(
// // //             "Ensure your dog stays \n healthy and active.",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(
// // //               fontSize: 26.sp,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           SizedBox(height: 16.h),
// // //           Text(
// // //             "Manage every detail of your dog—health, photos,\n activities, and more in one simple place.",
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(fontSize: 14.sp, color: Colors.white,),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
