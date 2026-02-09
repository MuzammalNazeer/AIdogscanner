import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../Calendar/calendarView.dart';
import '../ProfileView/ProfileView.dart';

class DashboardHomeView extends StatefulWidget {
  const DashboardHomeView({super.key});

  @override
  State<DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends State<DashboardHomeView> {
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const Homeview(),
      const Calendarview(),
      const Mypetsview(),
      const Profileview(),
    ];
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<HomeViewModel>(
        builder: (context, homeProvider, child) {
          return IndexedStack(
            index: homeProvider.selectedIndex,
            children: _widgetOptions,
          );
        },
      ),
      // floatingActionButton: _buildAddPetFAB(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: _buildBottomNavigationBar(),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return Consumer<HomeViewModel>(
      builder: (context, homeProvider, child) {
        final colors = Theme.of(context).colorScheme;
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Navigation Bar Background
            Container(
              margin: const EdgeInsets.only(bottom: 0), // Push to bottom
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 12.h,
                  bottom: bottomPadding > 0 ? bottomPadding : 12.h
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Home
                    _buildNavItem(
                      context,
                      homeProvider,
                      0,
                      'assets/images/home1.svg',
                      AppLocalizations.of(context)!.navHome,
                      activeIcon: 'assets/images/home1.svg'
                    ),

                    // Calendar
                    _buildNavItem(
                      context,
                      homeProvider,
                      1,
                      'assets/images/ic_calendar_1.svg',
                      AppLocalizations.of(context)!.navCalendar,
                      activeIcon: 'assets/images/calendar.svg',
                      tint: false
                    ),

                    // Space for FAB
                    SizedBox(width: 80.w),

                    // My Pets
                    _buildNavItem(
                      context,
                      homeProvider,
                      2,
                      'assets/images/pets.svg',
                      AppLocalizations.of(context)!.navMyPets,
                      activeIcon: 'assets/images/pets.svg'
                    ),

                    // Profile
                    _buildNavItem(
                      context,
                      homeProvider,
                      3,
                      'assets/images/profile.svg',
                      AppLocalizations.of(context)!.navProfile,
                      activeIcon: 'assets/images/profile.svg'
                    ),
                  ],
                ),
              ),
            ),

            // Floating Action Button
            Positioned(
              top: -20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.camera);
                },
                child: Container(
                  width: 87.w,
                  height: 87.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1919190D).withOpacity(0.15),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 73.w,
                      height: 73.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF820DFF),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, 
    HomeViewModel provider, 
    int index, 
    String iconPath, 
    String label, 
    {String? activeIcon, bool tint = true}
  ) {
    final isSelected = provider.selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => provider.selectedIndex = index,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: SvgPicture.asset(
                isSelected && activeIcon != null ? activeIcon : iconPath,
                color: tint ? (isSelected ? AppColors.vibrantPurple : const Color(0xFF7E808F)) : null,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 10.sp,
                color: isSelected ? Theme.of(context).colorScheme.onSurface : const Color(0xFF7E808F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:dog_breed/View/HomeView/HomeView.dart';
// import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import 'package:flutter/services.dart';
//
// import '../../l10n/app_localizations.dart';
// import '../Calendar/calendarView.dart';
// import '../ProfileView/ProfileView.dart';
//
// class DashboardHomeView extends StatefulWidget {
//   const DashboardHomeView({super.key});
//
//   @override
//   State<DashboardHomeView> createState() => _DashboardHomeViewState();
// }
//
// class _DashboardHomeViewState extends State<DashboardHomeView> {
//   late final List<Widget> _widgetOptions;
//
//   @override
//   void initState() {
//     super.initState();
//     _widgetOptions = <Widget>[
//       const Homeview(),
//       const Calendarview(),
//       const Mypetsview(),
//       const Profileview(),
//     ];
//   }
//
//   Widget _buildAddPetFAB() {
//     return SizedBox(
//       width: 97.w,
//       height: 97.h,
//       child: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, RoutesName.camera);
//         },
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         shape: const CircleBorder(),
//         child: Container(
//           width: 87.w,
//           height: 87.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color:Theme.of(context).colorScheme.background,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0x1919190D).withOpacity(0.15),
//                 offset: const Offset(0, 8),
//                 blurRadius: 20,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Container(
//               width: 73.w,
//               height: 73.h,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0xFF820DFF),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: Center(
//                   child: Icon(
//                     Icons.camera_alt_outlined,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//         systemNavigationBarColor: Colors.white,
//         systemNavigationBarIconBrightness: Brightness.dark,
//       ),
//     );
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Consumer<HomeViewModel>(
//         builder: (context, homeProvider, child) {
//           return IndexedStack(
//             index: homeProvider.selectedIndex,
//             children: _widgetOptions,
//           );
//         },
//       ),
//       floatingActionButton: _buildAddPetFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
//
//   Widget _buildBottomNavigationBar() {
//     return Consumer<HomeViewModel>(
//       builder: (context, homeProvider, child) {
//         final colors = Theme.of(context).colorScheme;
//         final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
//
//         return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.tertiaryContainer,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 12,
//                 offset: const Offset(0, -4),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Divider(
//               //   height: 1,
//               //   color: Colors.grey[200],
//               // ),
//               SizedBox(
//                 height: 82.h,
//                 child: BottomNavigationBar(
//                   type: BottomNavigationBarType.fixed,
//                   backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   currentIndex: homeProvider.selectedIndex >= 2
//                       ? homeProvider.selectedIndex + 1
//                       : homeProvider.selectedIndex,
//                   selectedFontSize: 12.sp,
//                   unselectedFontSize: 12.sp,
//                   selectedItemColor: colors.onSecondary,
//                   unselectedItemColor: const Color(0xFF7E808F),
//                   selectedLabelStyle: TextStyle(
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF000000),
//                     fontSize: 12.sp,
//                     height: 1.5,
//                   ),
//                   unselectedLabelStyle: TextStyle(
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12.sp,
//                     height: 1.5,
//                   ),
//                   iconSize: 24.w,
//                   elevation: 0,
//                   onTap: (index) {
//                     // Handle the middle FAB placeholder
//                     if (index == 2) return;
//
//                     // Map navigation bar index to widget index
//                     int widgetIndex;
//                     if (index < 2) {
//                       widgetIndex = index;
//                     } else {
//                       widgetIndex = index - 1;
//                     }
//
//                     homeProvider.selectedIndex = widgetIndex;
//                   },
//                   items: [
//                     // Home
//                     BottomNavigationBarItem(
//                       icon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/home1.svg',
//                           color: homeProvider.selectedIndex == 0
//                               ? AppColors.vibrantPurple
//                               : const Color(0xFF7E808F),
//                         ),
//                       ),
//                       activeIcon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/home1.svg',
//                           color: AppColors.vibrantPurple,
//                         ),
//                       ),
//                       label: AppLocalizations.of(context)!.navHome,
//                     ),
//
//                     // Calendar
//                     BottomNavigationBarItem(
//                       icon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/ic_calendar_1.svg',
//                         ),
//                       ),
//                       activeIcon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/calendar.svg',
//                         ),
//                       ),
//                       label: AppLocalizations.of(context)!.navCalendar,
//                     ),
//                     // Middle placeholder for FAB
//                     BottomNavigationBarItem(
//                       icon: SizedBox(
//                         width: 48.w,
//                         height: 32.h,
//                       ),
//                       label: '',
//                     ),
//                     // My Pets
//                     BottomNavigationBarItem(
//                       icon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/pets.svg',
//                           color: homeProvider.selectedIndex == 2
//                               ? AppColors.vibrantPurple
//                               : const Color(0xFF7E808F),
//                         ),
//                       ),
//                       activeIcon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/pets.svg',
//                           color: AppColors.vibrantPurple,
//                         ),
//                       ),
//                       label: AppLocalizations.of(context)!.navMyPets,
//                     ),
//                     // Profile
//                     BottomNavigationBarItem(
//                       icon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/profile.svg',
//                           color: homeProvider.selectedIndex == 3
//                               ? AppColors.vibrantPurple
//                               : const Color(0xFF7E808F),
//                         ),
//                       ),
//                       activeIcon: SizedBox(
//                         width: 25.w,
//                         height: 25.h,
//                         child: SvgPicture.asset(
//                           'assets/images/profile.svg',
//                           color: AppColors.vibrantPurple,
//                         ),
//                       ),
//                       label: AppLocalizations.of(context)!.navProfile,
//                     ),
//                   ],
//                 ),
//               ),
//               // Add safe area padding at the bottom
//               SizedBox(height: bottomPadding),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
