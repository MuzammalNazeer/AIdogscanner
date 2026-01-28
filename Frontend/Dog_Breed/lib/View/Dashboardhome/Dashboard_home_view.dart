import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Widget _buildAddPetFAB() {
    return SizedBox(
      width: 97.w,
      height: 97.h,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.camera);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Container(
          width: 87.w,
          height: 87.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
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
    );
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
      backgroundColor: AppColors.appColorWhite,
      body: Consumer<HomeViewModel>(
        builder: (context, homeProvider, child) {
          return IndexedStack(
            index: homeProvider.selectedIndex,
            children: _widgetOptions,
          );
        },
      ),
      floatingActionButton: _buildAddPetFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<HomeViewModel>(
      builder: (context, homeProvider, child) {
        final colors = Theme.of(context).colorScheme;
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 82.h,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.grey.shade200,
                  currentIndex: homeProvider.selectedIndex >= 2
                      ? homeProvider.selectedIndex + 1
                      : homeProvider.selectedIndex,
                  selectedFontSize: 12.sp,
                  unselectedFontSize: 12.sp,
                  selectedItemColor: colors.onSecondary,
                  unselectedItemColor: const Color(0xFF7E808F),
                  selectedLabelStyle: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF000000),
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                  iconSize: 24.w,
                  elevation: 0,
                  onTap: (index) {
                    // Handle the middle FAB placeholder
                    if (index == 2) return;

                    // Map navigation bar index to widget index
                    int widgetIndex;
                    if (index < 2) {
                      widgetIndex = index;
                    } else {
                      widgetIndex = index - 1;
                    }

                    homeProvider.selectedIndex = widgetIndex;
                  },
                  items: [
                    // Home
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/home.png',
                          color: homeProvider.selectedIndex == 0
                              ? colors.tertiary
                              : const Color(0xFF7E808F),
                        ),
                      ),
                      activeIcon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/home.png',
                          color: colors.tertiary,
                        ),
                      ),
                      label: AppLocalizations.of(context)!.navHome,
                    ),
                    // Calendar
                    BottomNavigationBarItem(
                      icon: Icon(
                        size: 25,
                        Icons.calendar_month,
                        color: homeProvider.selectedIndex == 1
                            ? colors.tertiary
                            : const Color(0xFF666666),
                      ),
                      activeIcon: Icon(
                        Icons.calendar_month,
                        size: 25.sp,
                        color: colors.tertiary,
                      ),
                      label: AppLocalizations.of(context)!.navCalendar,
                    ),
                    // Middle placeholder for FAB
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 48.w,
                        height: 32.h,
                      ),
                      label: '',
                    ),
                    // My Pets
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/s12.png',
                          color: homeProvider.selectedIndex == 2
                              ? colors.tertiary
                              : const Color(0xFF7E808F),
                        ),
                      ),
                      activeIcon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/s12.png',
                          color: colors.tertiary,
                        ),
                      ),
                      label: AppLocalizations.of(context)!.navMyPets,
                    ),
                    // Profile
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/s15.png',
                          color: homeProvider.selectedIndex == 3
                              ? colors.tertiary
                              : const Color(0xFF7E808F),
                        ),
                      ),
                      activeIcon: SizedBox(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset(
                          'assets/images/s15.png',
                          color: colors.tertiary,
                        ),
                      ),
                      label: AppLocalizations.of(context)!.navProfile,
                    ),
                  ],
                ),
              ),
              // Add safe area padding at the bottom
              SizedBox(height: bottomPadding),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:dog_breed/View/HomeView/HomeView.dart';
// import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
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
//             color: Colors.white,
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
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.camera_alt_outlined,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//
//                     ],
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
//     final homeProvider = context.watch<HomeViewModel>();
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: AppColors.appColorWhite,
//       body: IndexedStack(
//         index: homeProvider.selectedIndex,
//         children: _widgetOptions,
//       ),
//       floatingActionButton: _buildAddPetFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
//     );
//   }
//
//   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           height: 82.h,
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: const Color(0xFFF4F7F6),
//             currentIndex: homeProvider.selectedIndex >= 2
//                 ? homeProvider.selectedIndex + 1
//                 : homeProvider.selectedIndex,
//             selectedFontSize: 12.sp,
//             unselectedFontSize: 12.sp,
//             selectedItemColor: colors.onSecondary,
//             unselectedItemColor: const Color(0xFF7E808F),
//             selectedLabelStyle: TextStyle(
//               fontFamily: 'Sora',
//               fontWeight: FontWeight.bold,
//               color: const Color(0xFF000000),
//               fontSize: 12.sp,
//               height: 2,
//             ),
//             unselectedLabelStyle: TextStyle(
//               fontFamily: 'Sora',
//               fontWeight: FontWeight.w500,
//               fontSize: 12.sp,
//               height: 2,
//             ),
//             iconSize: 24.w,
//             elevation: 0,
//             onTap: (index) {
//               // Handle the middle FAB placeholder
//               if (index == 2) return; // Do nothing for the middle item
//
//               // Map navigation bar index to widget index
//               int widgetIndex;
//               if (index < 2) {
//                 widgetIndex = index; // Home (0) and Calendar (1)
//               } else {
//                 widgetIndex = index - 1; // My Pets (2) and Profile (3)
//               }
//
//               homeProvider.selectedIndex = widgetIndex;
//             },
//             items: [
//               // Home
//               BottomNavigationBarItem(
//                 icon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/home.png',
//                     color: homeProvider.selectedIndex == 0
//                         ? colors.tertiary
//                         : const Color(0xFF7E808F),
//                   ),
//                 ),
//                 activeIcon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/home.png',
//                     color: colors.tertiary,
//                   ),
//                 ),
//                 label: AppLocalizations.of(context)!.navHome,
//               ),
//               // Calendar
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   size: 25,
//                   Icons.calendar_month,
//                   color: homeProvider.selectedIndex == 1
//                       ? colors.tertiary
//                       : const Color(0xFF666666),
//                 ),
//                 activeIcon: Icon(Icons.calendar_month, size: 25.sp, color: colors.tertiary),
//                 label: AppLocalizations.of(context)!.navCalendar,
//               ),
//               // Middle placeholder for FAB
//               BottomNavigationBarItem(
//                 icon: SizedBox(width: 48.w, height: 32.h),
//                 label: '',
//                 tooltip: '',
//               ),
//               // My Pets
//               BottomNavigationBarItem(
//                 icon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/s12.png',
//                     color: homeProvider.selectedIndex == 2
//                         ? colors.tertiary
//                         : const Color(0xFF7E808F),
//                   ),
//                 ),
//                 activeIcon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/s12.png',
//                     color: colors.tertiary,
//                   ),
//                 ),
//                 label: AppLocalizations.of(context)!.navMyPets,
//               ),
//               // Profile
//               BottomNavigationBarItem(
//                 icon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/s15.png',
//                     color: homeProvider.selectedIndex == 3
//                         ? colors.tertiary
//                         : const Color(0xFF7E808F),
//                   ),
//                 ),
//                 activeIcon: SizedBox(
//                   width: 25.w,
//                   height: 25.h,
//                   child: Image.asset(
//                     'assets/images/s15.png',
//                     color: colors.tertiary,
//                   ),
//                 ),
//                 label: AppLocalizations.of(context)!.navProfile,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
