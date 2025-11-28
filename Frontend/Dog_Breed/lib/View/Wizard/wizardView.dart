import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Wizardview extends StatefulWidget {
  const Wizardview({super.key});

  @override
  State<Wizardview> createState() => _WizardviewState();
}

class _WizardviewState extends State<Wizardview> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final int totalPages = 4; // You can change this anytime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vibrantPurple,
      body: SafeArea(
        child: Column(
          children: [
            // PAGE VIEW
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                children: [
                  _buildPage("Satellite Director"),
                  _buildPage("Track Satellites Easily"),
                  _buildPage("Find Nearby Places"),
                  _buildPage("Navigate in Real-time"),
                ],
              ),
            ),

            // BOTTOM NAVIGATION
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF6D09E8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  if (currentPage < totalPages - 1)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.login);
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            color: Color(0xFF6D09E8),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  Row(
                    children: List.generate(
                      totalPages,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 8),
                        width: currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? Colors.white
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  // --- NEXT or GET STARTED ---
                  GestureDetector(
                    onTap: () {
                      if (currentPage < totalPages - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                        );
                      } else {
                        Navigator.pushNamed(context, RoutesName.login);
                      }
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        currentPage == totalPages - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          color: Color(0xFF6D09E8),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- SINGLE ONBOARDING PAGE BUILDER ---
  Widget _buildPage(String title) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w400,
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            width: 250,
            child: Text(
              'Explore Nearby Places with GPS Satellite Mapping & Find Satellite',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // IMAGE STACK
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 102,
                left: 12,
                right: 12,
                child: Center(
                  child: Container(
                    width: 356,
                    height: 356,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D09E8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9FF).withOpacity(0.2),
                          blurRadius: 140,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: 45,
                child: Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6304C9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        // BoxShadow(
                        //   color: Color(0xFF00D9FF),
                        //   blurRadius: 120,
                        //   spreadRadius: 30,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/image 42 (1).png',
                    width: 266,
                    height: 518,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
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
//   /// TOTAL ONBOARDING PAGES
//   final int totalPages = 4;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.vibrantPurple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(() => currentPage = index);
//                 },
//                 children: List.generate(
//                   4,
//                       (_) => _buildOnboardingScreen(),
//                 ),
//               ),
//             ),
//
//             /// Bottom Navigation: Dots + Next Button
//             Container(
//               height: 56,
//               color: const Color(0xFF6D09E8),
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   /// --- DOTS ---
//                   Row(
//                     children: [
//                       /// Active long indicator
//                       Container(
//                         width: 24,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//
//                       /// Inactive dots
//                       ...List.generate(
//                         3,
//                             (_) => Container(
//                           margin: const EdgeInsets.only(left: 8),
//                           width: 6,
//                           height: 6,
//                           decoration: const BoxDecoration(
//                             color: Colors.white24,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   /// --- NEXT or GET STARTED BUTTON ---
//                   GestureDetector(
//                     onTap: () {
//                       if (currentPage < totalPages - 1) {
//                         /// Go to next page
//                         _pageController.nextPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       } else {
//                         /// Last page → Navigate to next screen
//                         Navigator.pushNamed(context, RoutesName.login);
//                       }
//                     },
//                     child: Container(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(28),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         currentPage == totalPages - 1
//                             ? "Get Started"
//                             : "Next",
//                         style: const TextStyle(
//                           color: Color(0xFF6D09E8),
//                           fontWeight: FontWeight.w600,
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
//
//   /// SINGLE ONBOARDING PAGE UI REUSED FOR ALL 4 PAGES
//   Widget _buildOnboardingScreen() {
//     return Column(
//       children: [
//         const SizedBox(height: 30),
//         const Text(
//           'Satellite Director',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w400,
//             fontSize: 26,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           width: 250,
//           child: const Text(
//             'Explore Nearby Places with GPS Satellite Mapping & Find Satellite',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//               fontSize: 14,
//               height: 1.5,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//
//         /// MAIN STACK
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               top: 102,
//               left: 12,
//               right: 12,
//               child: Container(
//                 width: 356,
//                 height: 356,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6D09E8),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF00D9FF).withOpacity(0.7),
//                       blurRadius: 140,
//                       spreadRadius: 40,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 150,
//               left: 30,
//               child: Container(
//                 width: 260,
//                 height: 260,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6D09E8),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF00D9FF),
//                       blurRadius: 120,
//                       spreadRadius: 30,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(24),
//                 child: Image.asset(
//                   'assets/images/image 42 (1).png',
//                   width: 304,
//                   height: 518,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
//
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // class Wizardview extends StatefulWidget {
// //   const Wizardview({super.key});
// //
// //   @override
// //   State<Wizardview> createState() => _WizardviewState();
// // }
// //
// // class _WizardviewState extends State<Wizardview> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.vibrantPurple,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               SizedBox(height: 30),
// //               Center(
// //                 child: const Text(
// //                   'Satellite Director',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontFamily: 'Sora',
// //                     fontWeight: FontWeight.w400,
// //                     fontSize: 26,
// //                     height: 1.0,
// //                     letterSpacing: 0.0,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               Center(
// //                 child: SizedBox(
// //                   width: 250,
// //                   child: const Text(
// //                     'Explore Nearby Places with GPS Satellite Mapping & Find Satellite',
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       fontFamily: 'Inter',
// //                       fontWeight: FontWeight.w500,
// //                       fontSize: 14,
// //                       height: 1.5,
// //                       letterSpacing: -0.16,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               Stack(
// //                 clipBehavior: Clip.none,
// //                 children: [
// //                   Positioned(
// //                     top: 102,
// //                     left: 12,
// //                     right: 12,
// //                     child: Container(
// //                       width: 356,
// //                       height: 356,
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF6D09E8),
// //                         shape: BoxShape.circle,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: const Color(0xFF00D9FF).withOpacity(0.7),
// //                             blurRadius: 140,
// //                             spreadRadius: 40,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   Positioned(
// //                     top: 150,
// //                     left: 30,
// //                     child: Container(
// //                       width: 260,
// //                       height: 260,
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF6D09E8),
// //                         shape: BoxShape.circle,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: const Color(0xFF00D9FF).withOpacity(1),
// //                             blurRadius: 120,
// //                             spreadRadius: 30,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   Center(
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(24),
// //                       child: Image.asset(
// //                         'assets/images/image 42 (1).png',
// //                         width: 304,
// //                         height: 518,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                   ),
// //                   Positioned.fill(
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(24),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.35),
// //                             blurRadius: 30,
// //                             spreadRadius: -8,
// //                             offset: const Offset(0, 8),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 40),
// //               Container(
// //                 height: 56,
// //                 color: const Color(0xFF6D09E8),
// //                 padding: const EdgeInsets.symmetric(horizontal: 24),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Container(
// //                           width: 24,
// //                           height: 4,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(2),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         ...List.generate(
// //                           3,
// //                           (_) => Container(
// //                             margin: const EdgeInsets.only(left: 8),
// //                             width: 6,
// //                             height: 6,
// //                             decoration: const BoxDecoration(
// //                               color: Colors.white24,
// //                               shape: BoxShape.circle,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.pushNamed(context, RoutesName.login);
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 32,
// //                           vertical: 12,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(28),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.1),
// //                               blurRadius: 8,
// //                               offset: const Offset(0, 2),
// //                             ),
// //                           ],
// //                         ),
// //                         child: const Text(
// //                           'Next',
// //                           style: TextStyle(
// //                             color: Color(0xFF6D09E8),
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
