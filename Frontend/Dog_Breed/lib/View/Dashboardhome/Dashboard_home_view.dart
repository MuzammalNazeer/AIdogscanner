import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';
import 'package:dog_breed/View_model/PetProvider.dart';
import 'package:dog_breed/config/components/roundButton.dart';

import 'package:dog_breed/View/MyPetsView/addPetView.dart';
import '../../l10n/app_localizations.dart';
import '../Calendar/add_activities_View.dart';
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
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 30,
                      ),

                    ],
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
    final homeProvider = context.watch<HomeViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appColorWhite,
      body: IndexedStack(
        index: homeProvider.selectedIndex,
        children: _widgetOptions,
      ),
      floatingActionButton: _buildAddPetFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
    );
  }

  Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 82.h,
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
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.h),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
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
            height: 2,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            height: 2,
          ),
          iconSize: 24.w,
          elevation: 0,
          onTap: (index) {
            // Handle the middle FAB placeholder
            if (index == 2) return; // Do nothing for the middle item

            // Map navigation bar index to widget index
            int widgetIndex;
            if (index < 2) {
              widgetIndex = index; // Home (0) and Calendar (1)
            } else {
              widgetIndex = index - 1; // My Pets (2) and Profile (3)
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
              activeIcon: Icon(Icons.calendar_month, size: 25.sp, color: colors.tertiary),
              label: AppLocalizations.of(context)!.navCalendar,
            ),
            // Middle placeholder for FAB
            BottomNavigationBarItem(
              icon: SizedBox(width: 48.w, height: 32.h),
              label: '',
              tooltip: '',
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
// import '../ActivitesView/ActivitesView.dart';
// import '../Calendar/calendarView.dart';
// import '../Favourites/favouritesView.dart';
// import '../History/historyView.dart';
// import '../ProfileView/ProfileView.dart';
// import '../setting/settingView.dart';
// import '../shop/shopview.dart';
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
//           Navigator.pushNamed(context, RoutesName.addPet);
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
//               // BoxShadow(
//               //   color: const Color(0x16223308).withOpacity(0.1),
//               //   offset: const Offset(0, 4),
//               //   blurRadius: 10,
//               // ),
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
//               child:  Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.add,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                       SizedBox(height: 2,),
//                       Text("Add Pet",style: TextStyle(fontSize:12.sp,color: Colors.white),),
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
//   Widget _buildFloatingActionButton(bool isOverlayView) {
//     return Padding(
//       padding: isOverlayView ? EdgeInsets.only(bottom: 30.h) : EdgeInsets.zero,
//       child: FloatingActionButton(
//         backgroundColor: isOverlayView ? Colors.red : Colors.amber,
//         onPressed: () {
//           Navigator.pushNamed(context, RoutesName.addPet);
//         },
//         elevation: 4,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   BottomNavigationBarItem _buildNavItem(
//       IconData icon, String text, int index, int selectedIndex) {
//     final isSelected = context.read<HomeViewModel>().selectedIndex == index;
//     return BottomNavigationBarItem(
//       icon: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? AppColors.appColorBlack : AppColors.grayColor,
//           ),
//         ],
//       ),
//       label: text,
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
//       floatingActionButton:_buildAddPetFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
//     );
//   }
//
//
//
//   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       height: 82.h,
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
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 0.h),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           currentIndex: _getCurrentIndexForNavigationBar(homeProvider.selectedIndex),
//           selectedFontSize: 12.sp,
//           unselectedFontSize: 12.sp,
//           selectedItemColor: colors.onSecondary,
//           unselectedItemColor: const Color(0xFF7E808F),
//           selectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF000000),
//             fontSize: 12.sp,
//             height: 2,
//           ),
//           unselectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w500,
//             fontSize: 12.sp,
//             height: 2,
//           ),
//           iconSize: 24.w,
//           elevation: 0,
//           onTap: (navBarIndex) {
//             // Convert navigation bar index to widget index
//             int widgetIndex = _convertNavBarIndexToWidgetIndex(navBarIndex);
//             if (widgetIndex != -1) {
//               homeProvider.selectedIndex = widgetIndex;
//             }
//           },
//           items: [
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/home.png',
//                   color: homeProvider.selectedIndex == 0
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/home.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 size: 25,
//                 Icons.calendar_month,
//                 color: homeProvider.selectedIndex == 1
//                     ? colors.tertiary
//                     : const Color(0xFF666666),
//               ),
//               activeIcon: Icon(Icons.calendar_month, size: 25.sp, color: colors.tertiary),
//               label: 'Calendar',
//             ),
//             // BottomNavigationBarItem(
//             //   icon:SizedBox(
//             //     width: 25.w,
//             //     height: 25.h,
//             //     child: Image.asset(
//             //       'assets/images/s12.png',
//             //       color: homeProvider.selectedIndex == 2
//             //           ? colors.tertiary
//             //           : const Color(0xFF7E808F),
//             //     ),
//             //   ),
//             //   activeIcon: SizedBox(
//             //     width: 25.w,
//             //     height: 25.h,
//             //     child: Image.asset(
//             //       'assets/images/s12.png',
//             //       color: colors.tertiary,
//             //     ),
//             //   ),
//             //   label: 'My Pets',
//             // ),
//             BottomNavigationBarItem(
//               icon:  SizedBox(width: 48.w, height: 32.h), // invisible space
//               label: '', // can keep empty
//               tooltip: '', // prevents long-press tooltip
//             ),
//
//             BottomNavigationBarItem(
//               icon:SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s12.png',
//                   color: homeProvider.selectedIndex == 3
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s12.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'My Pets',
//             ),
//
//             // BottomNavigationBarItem(
//             //   icon: SizedBox(
//             //     width: 25.w,
//             //     height: 25.h,
//             //     child: Image.asset(
//             //       'assets/images/s13.png',
//             //       color: homeProvider.selectedIndex == 3
//             //           ? colors.tertiary
//             //           : const Color(0xFF7E808F),
//             //     ),
//             //   ),
//             //   activeIcon: SizedBox(
//             //     width: 25,
//             //     height: 25,
//             //     child: Image.asset(
//             //       'assets/images/s13.png',
//             //       color: colors.tertiary,
//             //     ),
//             //   ),
//             //   label: 'Shop',
//             // ),
//             // BottomNavigationBarItem(
//             //   icon: SizedBox(
//             //     width: 25.w,
//             //     height: 25.h,
//             //     child: Image.asset(
//             //       'assets/images/s14.png',
//             //       color: homeProvider.selectedIndex == 4
//             //           ? colors.tertiary
//             //           : const Color(0xFF7E808F),
//             //     ),
//             //   ),
//             //   activeIcon: SizedBox(
//             //     width: 25.w,
//             //     height: 25.h,
//             //     child: Image.asset(
//             //       'assets/images/s14.png',
//             //       color: colors.tertiary,
//             //     ),
//             //   ),
//             //   label: 'Activities',
//             // ),
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s15.png',
//                   color: homeProvider.selectedIndex == 3
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s15.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int _convertNavBarIndexToWidgetIndex(int navBarIndex) {
//
//     if (navBarIndex == 3) return -1;
//     if (navBarIndex > 3) return navBarIndex - 1;
//     return navBarIndex;
//   }
//
//   int _getCurrentIndexForNavigationBar(int widgetIndex) {
//     if (widgetIndex >= 3) return widgetIndex + 1;
//     return widgetIndex;
//   }
// }
//
//
//
//
//
//
//
//


// import 'package:dog_breed/View/HomeView/HomeView.dart';
// import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import 'package:dog_breed/View_model/PetProvider.dart';
// import 'package:dog_breed/config/components/roundButton.dart';
//
// import 'package:dog_breed/View/MyPetsView/addPetView.dart';
// import '../Calendar/add_activities_View.dart';
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
//               child: Padding(
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
//       height: 82.h,
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
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 0.h),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           currentIndex: homeProvider.selectedIndex >= 2
//               ? homeProvider.selectedIndex + 1
//               : homeProvider.selectedIndex,
//           selectedFontSize: 12.sp,
//           unselectedFontSize: 12.sp,
//           selectedItemColor: colors.onSecondary,
//           unselectedItemColor: const Color(0xFF7E808F),
//           selectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF000000),
//             fontSize: 12.sp,
//             height: 2,
//           ),
//           unselectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w500,
//             fontSize: 12.sp,
//             height: 2,
//           ),
//           iconSize: 24.w,
//           elevation: 0,
//           onTap: (index) {
//             // Handle the middle FAB placeholder
//             if (index == 2) return; // Do nothing for the middle item
//
//             // Map navigation bar index to widget index
//             int widgetIndex;
//             if (index < 2) {
//               widgetIndex = index; // Home (0) and Calendar (1)
//             } else {
//               widgetIndex = index - 1; // My Pets (2) and Profile (3)
//             }
//
//             homeProvider.selectedIndex = widgetIndex;
//           },
//           items: [
//             // Home
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/home.png',
//                   color: homeProvider.selectedIndex == 0
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/home.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'Home',
//             ),
//             // Calendar
//             BottomNavigationBarItem(
//               icon: Icon(
//                 size: 25,
//                 Icons.calendar_month,
//                 color: homeProvider.selectedIndex == 1
//                     ? colors.tertiary
//                     : const Color(0xFF666666),
//               ),
//               activeIcon: Icon(Icons.calendar_month, size: 25.sp, color: colors.tertiary),
//               label: 'Calendar',
//             ),
//             // Middle placeholder for FAB
//             BottomNavigationBarItem(
//               icon: SizedBox(width: 48.w, height: 32.h),
//               label: '',
//               tooltip: '',
//             ),
//             // My Pets
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s12.png',
//                   color: homeProvider.selectedIndex == 2
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s12.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'My Pets',
//             ),
//             // Profile
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s15.png',
//                   color: homeProvider.selectedIndex == 3
//                       ? colors.tertiary
//                       : const Color(0xFF7E808F),
//                 ),
//               ),
//               activeIcon: SizedBox(
//                 width: 25.w,
//                 height: 25.h,
//                 child: Image.asset(
//                   'assets/images/s15.png',
//                   color: colors.tertiary,
//                 ),
//               ),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:dog_breed/View/HomeView/HomeView.dart';
// // import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/View_model/home/home_view_model.dart';
// //
// // import '../ActivitesView/ActivitesView.dart';
// // import '../Calendar/calendarView.dart';
// // import '../Favourites/favouritesView.dart';
// // import '../History/historyView.dart';
// // import '../ProfileView/ProfileView.dart';
// // import '../setting/settingView.dart';
// // import '../shop/shopview.dart';
// //
// // class DashboardHomeView extends StatefulWidget {
// //   const DashboardHomeView({super.key});
// //
// //   @override
// //   State<DashboardHomeView> createState() => _DashboardHomeViewState();
// // }
// //
// // class _DashboardHomeViewState extends State<DashboardHomeView> {
// //   late final List<Widget> _widgetOptions;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _widgetOptions = <Widget>[
// //       const Homeview(),
// //       const Calendarview(),
// //       const Mypetsview(),
// //       const Profileview(),
// //     ];
// //   }
// //
// //   Widget _buildAddPetFAB() {
// //     return SizedBox(
// //       width: 97.w,
// //       height: 97.h,
// //       child: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.pushNamed(context, RoutesName.addPet);
// //         },
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         shape: const CircleBorder(),
// //         child: Container(
// //           width: 87.w,
// //           height: 87.h,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: Colors.white,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: const Color(0x1919190D).withOpacity(0.15),
// //                 offset: const Offset(0, 8),
// //                 blurRadius: 20,
// //               ),
// //               // BoxShadow(
// //               //   color: const Color(0x16223308).withOpacity(0.1),
// //               //   offset: const Offset(0, 4),
// //               //   blurRadius: 10,
// //               // ),
// //             ],
// //           ),
// //           child: Center(
// //             child: Container(
// //               width: 73.w,
// //               height: 73.h,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Color(0xFF820DFF),
// //               ),
// //               child:  Padding(
// //                 padding: EdgeInsets.all(4.0),
// //                 child: Center(
// //                   child: Column(
// //                     children: [
// //                       Icon(
// //                         Icons.add,
// //                         color: Colors.white,
// //                         size: 30,
// //                       ),
// //                       SizedBox(height: 2,),
// //                       Text("Add Pet",style: TextStyle(fontSize:12.sp,color: Colors.white),),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFloatingActionButton(bool isOverlayView) {
// //     return Padding(
// //       padding: isOverlayView ? EdgeInsets.only(bottom: 30.h) : EdgeInsets.zero,
// //       child: FloatingActionButton(
// //         backgroundColor: isOverlayView ? Colors.red : Colors.amber,
// //         onPressed: () {
// //           Navigator.pushNamed(context, RoutesName.addPet);
// //         },
// //         elevation: 4,
// //         child: const Icon(Icons.add, color: Colors.white),
// //       ),
// //     );
// //   }
// //
// //   BottomNavigationBarItem _buildNavItem(
// //       IconData icon, String text, int index, int selectedIndex) {
// //     final isSelected = context.read<HomeViewModel>().selectedIndex == index;
// //     return BottomNavigationBarItem(
// //       icon: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             icon,
// //             color: isSelected ? AppColors.appColorBlack : AppColors.grayColor,
// //           ),
// //         ],
// //       ),
// //       label: text,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final homeProvider = context.watch<HomeViewModel>();
// //
// //     return Scaffold(
// //       resizeToAvoidBottomInset: true,
// //       backgroundColor: AppColors.appColorWhite,
// //       body: IndexedStack(
// //         index: homeProvider.selectedIndex,
// //         children: _widgetOptions,
// //       ),
// //       floatingActionButton:_buildAddPetFAB(),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
// //     );
// //   }
// //
// //
// //
// //   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Container(
// //       height: 82.h,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 12,
// //             offset: const Offset(0, -4),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.only(bottom: 0.h),
// //         child: BottomNavigationBar(
// //           type: BottomNavigationBarType.fixed,
// //           backgroundColor: Colors.white,
// //           currentIndex: _getCurrentIndexForNavigationBar(homeProvider.selectedIndex),
// //           selectedFontSize: 12.sp,
// //           unselectedFontSize: 12.sp,
// //           selectedItemColor: colors.onSecondary,
// //           unselectedItemColor: const Color(0xFF7E808F),
// //           selectedLabelStyle: TextStyle(
// //             fontFamily: 'Sora',
// //             fontWeight: FontWeight.bold,
// //             color: const Color(0xFF000000),
// //             fontSize: 12.sp,
// //             height: 2,
// //           ),
// //           unselectedLabelStyle: TextStyle(
// //             fontFamily: 'Sora',
// //             fontWeight: FontWeight.w500,
// //             fontSize: 12.sp,
// //             height: 2,
// //           ),
// //           iconSize: 24.w,
// //           elevation: 0,
// //           onTap: (navBarIndex) {
// //             // Convert navigation bar index to widget index
// //             int widgetIndex = _convertNavBarIndexToWidgetIndex(navBarIndex);
// //             if (widgetIndex != -1) {
// //               homeProvider.selectedIndex = widgetIndex;
// //             }
// //           },
// //           items: [
// //             BottomNavigationBarItem(
// //               icon: SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/home.png',
// //                   color: homeProvider.selectedIndex == 0
// //                       ? colors.tertiary
// //                       : const Color(0xFF7E808F),
// //                 ),
// //               ),
// //               activeIcon: SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/home.png',
// //                   color: colors.tertiary,
// //                 ),
// //               ),
// //               label: 'Home',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(
// //                 size: 25,
// //                 Icons.calendar_month,
// //                 color: homeProvider.selectedIndex == 1
// //                     ? colors.tertiary
// //                     : const Color(0xFF666666),
// //               ),
// //               activeIcon: Icon(Icons.calendar_month, size: 25.sp, color: colors.tertiary),
// //               label: 'Calendar',
// //             ),
// //             // BottomNavigationBarItem(
// //             //   icon:SizedBox(
// //             //     width: 25.w,
// //             //     height: 25.h,
// //             //     child: Image.asset(
// //             //       'assets/images/s12.png',
// //             //       color: homeProvider.selectedIndex == 2
// //             //           ? colors.tertiary
// //             //           : const Color(0xFF7E808F),
// //             //     ),
// //             //   ),
// //             //   activeIcon: SizedBox(
// //             //     width: 25.w,
// //             //     height: 25.h,
// //             //     child: Image.asset(
// //             //       'assets/images/s12.png',
// //             //       color: colors.tertiary,
// //             //     ),
// //             //   ),
// //             //   label: 'My Pets',
// //             // ),
// //             BottomNavigationBarItem(
// //               icon:  SizedBox(width: 48.w, height: 32.h), // invisible space
// //               label: '', // can keep empty
// //               tooltip: '', // prevents long-press tooltip
// //             ),
// //
// //             BottomNavigationBarItem(
// //               icon:SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/s12.png',
// //                   color: homeProvider.selectedIndex == 3
// //                       ? colors.tertiary
// //                       : const Color(0xFF7E808F),
// //                 ),
// //               ),
// //               activeIcon: SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/s12.png',
// //                   color: colors.tertiary,
// //                 ),
// //               ),
// //               label: 'My Pets',
// //             ),
// //
// //             // BottomNavigationBarItem(
// //             //   icon: SizedBox(
// //             //     width: 25.w,
// //             //     height: 25.h,
// //             //     child: Image.asset(
// //             //       'assets/images/s13.png',
// //             //       color: homeProvider.selectedIndex == 3
// //             //           ? colors.tertiary
// //             //           : const Color(0xFF7E808F),
// //             //     ),
// //             //   ),
// //             //   activeIcon: SizedBox(
// //             //     width: 25,
// //             //     height: 25,
// //             //     child: Image.asset(
// //             //       'assets/images/s13.png',
// //             //       color: colors.tertiary,
// //             //     ),
// //             //   ),
// //             //   label: 'Shop',
// //             // ),
// //             // BottomNavigationBarItem(
// //             //   icon: SizedBox(
// //             //     width: 25.w,
// //             //     height: 25.h,
// //             //     child: Image.asset(
// //             //       'assets/images/s14.png',
// //             //       color: homeProvider.selectedIndex == 4
// //             //           ? colors.tertiary
// //             //           : const Color(0xFF7E808F),
// //             //     ),
// //             //   ),
// //             //   activeIcon: SizedBox(
// //             //     width: 25.w,
// //             //     height: 25.h,
// //             //     child: Image.asset(
// //             //       'assets/images/s14.png',
// //             //       color: colors.tertiary,
// //             //     ),
// //             //   ),
// //             //   label: 'Activities',
// //             // ),
// //             BottomNavigationBarItem(
// //               icon: SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/s15.png',
// //                   color: homeProvider.selectedIndex == 3
// //                       ? colors.tertiary
// //                       : const Color(0xFF7E808F),
// //                 ),
// //               ),
// //               activeIcon: SizedBox(
// //                 width: 25.w,
// //                 height: 25.h,
// //                 child: Image.asset(
// //                   'assets/images/s15.png',
// //                   color: colors.tertiary,
// //                 ),
// //               ),
// //               label: 'Profile',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   int _convertNavBarIndexToWidgetIndex(int navBarIndex) {
// //
// //     if (navBarIndex == 3) return -1;
// //     if (navBarIndex > 3) return navBarIndex - 1;
// //     return navBarIndex;
// //   }
// //
// //   int _getCurrentIndexForNavigationBar(int widgetIndex) {
// //     if (widgetIndex >= 3) return widgetIndex + 1;
// //     return widgetIndex;
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
