import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';

import '../Favourites/favouritesView.dart';
import '../History/historyView.dart';
import '../setting/settingView.dart';

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
      const Favouritesview(),
       const SizedBox(),
      const Historyview(),
      const Settingview(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeViewModel>();

    return Scaffold(
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

  Widget _buildAddPetFAB() {
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.camera);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onTertiary,
            boxShadow: [
              BoxShadow(
                color: const Color(0x1919190D).withOpacity(0.15),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
              BoxShadow(
                color: const Color(0x16223308).withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined,color: Colors.white,),
              Text(
                'Camera',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.h),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          currentIndex: homeProvider.selectedIndex,
          selectedFontSize: 11.sp,
          unselectedFontSize: 11.sp,
          selectedItemColor: colors.tertiary,
          unselectedItemColor: const Color(0xFF666666),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            height: 1.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            height: 1.0,
          ),
          iconSize: 24.w,
          elevation: 0,
          onTap: (index) {
            if (index == 2) return;
            homeProvider.selectedIndex = index;
          },
          items: [
            // Home
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  'assets/images/home.png',
                  color: homeProvider.selectedIndex == 0
                      ? colors.tertiary
                      : const Color(0xFF666666),
                ),
              ),
              activeIcon: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  'assets/images/home.png',
                  color: colors.tertiary,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: 25,
                Icons.favorite,
                color: homeProvider.selectedIndex == 1
                    ? colors.tertiary
                    : const Color(0xFF666666),
              ),
              activeIcon: Icon(Icons.favorite,size: 25, color: colors.tertiary),
              label: 'Favourites',
            ),

            // FAB gap
            const BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: '',
            ),

            // History
            BottomNavigationBarItem(
              icon: Icon(
                size: 25,
                Icons.history,
                color: homeProvider.selectedIndex == 3
                    ? colors.tertiary
                    : const Color(0xFF666666),
              ),
              activeIcon:  Icon(Icons.history,size: 25, color: colors.tertiary),
              label: 'History',
            ),

            // Setting
            BottomNavigationBarItem(
              icon: Icon(
                size: 25,
                Icons.settings,
                color: homeProvider.selectedIndex == 4
                    ? colors.tertiary
                    : const Color(0xFF666666),
              ),
              activeIcon:  Icon(Icons.settings,size: 25, color: colors.tertiary),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
//
// import '../Favourites/favouritesView.dart';
// import '../History/historyView.dart';
// import '../HomeView/HomeView.dart';
// import '../setting/settingView.dart';
//
// class DashboardHomeView extends StatefulWidget {
//   const DashboardHomeView({super.key});
//
//   @override
//   State<DashboardHomeView> createState() => _DashboardHomeViewState();
// }
//
// class _DashboardHomeViewState extends State<DashboardHomeView> {
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     _pages = <Widget>[
//       const Homeview(),
//       const Favouritesview(),
//       const SizedBox(),
//       const Historyview(),
//       const Settingview(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final homeProvider = context.watch<HomeViewModel>();
//     final colors = Theme.of(context).colorScheme;
//
//     return Scaffold(
//       backgroundColor: AppColors.appColorWhite,
//       body: IndexedStack(
//         index: homeProvider.selectedIndex,
//         children: _pages,
//       ),
//       floatingActionButton: _buildAddPetFAB(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape:  const CircularNotchedRectangle(),
//         notchMargin: 10.0,
//         child: SizedBox(
//           height: 30.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildBottomNavItem(
//                 icon: Icons.home,
//                 index: 0,
//                 label: 'Home',
//                 homeProvider: homeProvider,
//               ),
//               _buildBottomNavItem(
//                 icon: Icons.favorite,
//                 index: 1,
//                 label: 'Favourites',
//                 homeProvider: homeProvider,
//               ),
//               const SizedBox(width: 40),
//               _buildBottomNavItem(
//                 icon: Icons.history,
//                 index: 3,
//                 label: 'History',
//                 homeProvider: homeProvider,
//               ),
//               _buildBottomNavItem(
//                 icon: Icons.settings,
//                 index: 4,
//                 label: 'Setting',
//                 homeProvider: homeProvider,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddPetFAB() {
//     return SizedBox(
//       width: 80.w, // Bigger circle
//       height: 80.h,
//       child: FloatingActionButton(
//         onPressed: () => Navigator.pushNamed(context, RoutesName.camera),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         shape: const CircleBorder(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 30),
//             SizedBox(height: 2.h),
//             Text(
//               'Camera',
//               style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavItem({
//     required IconData icon,
//     required int index,
//     required String label,
//     required HomeViewModel homeProvider,
//   }) {
//     final colors = Theme.of(context).colorScheme;
//     final isSelected = homeProvider.selectedIndex == index;
//
//     return InkWell(
//       onTap: () => homeProvider.selectedIndex = index,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: isSelected ? colors.tertiary : const Color(0xFF666666),size: 26,),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ?  colors.tertiary
//                      : const Color(0xFF666666),
//               fontSize: 16.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
// // import 'package:dog_breed/View/HomeView/HomeView.dart';
// // import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// // import 'package:dog_breed/View/ProfileView/ProfileView.dart';
// // import 'package:dog_breed/utils/routes/routes_name.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:dog_breed/View_model/home/home_view_model.dart';
// //
// // import '../Favourites/favouritesView.dart';
// // import '../History/historyView.dart';
// // import '../setting/settingView.dart';
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
// //       const Favouritesview(),
// //        const SizedBox(),
// //       const Historyview(),
// //       const Settingview(),
// //     ];
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final homeProvider = context.watch<HomeViewModel>();
// //
// //     return Scaffold(
// //       backgroundColor: AppColors.appColorWhite,
// //       body: IndexedStack(
// //         index: homeProvider.selectedIndex,
// //         children: _widgetOptions,
// //       ),
// //       floatingActionButton: _buildAddPetFAB(),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
// //     );
// //   }
// //
// //   Widget _buildAddPetFAB() {
// //     return SizedBox(
// //       width: 80.w,
// //       height: 80.h,
// //       child: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.pushNamed(context, RoutesName.camera);
// //         },
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         shape: const CircleBorder(),
// //         child: Container(
// //           width: 65.w,
// //           height: 65.h,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: Theme.of(context).colorScheme.onBackground,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: const Color(0x1919190D).withOpacity(0.15),
// //                 offset: const Offset(0, 8),
// //                 blurRadius: 20,
// //               ),
// //               BoxShadow(
// //                 color: const Color(0x16223308).withOpacity(0.1),
// //                 offset: const Offset(0, 4),
// //                 blurRadius: 10,
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.camera_alt_outlined,color: Colors.white,),
// //               Text(
// //                 'Camera',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontFamily: 'Sora',
// //                   fontSize: 10.sp,
// //                   fontWeight: FontWeight.w600,
// //                   color: Colors.white,
// //                   height: 1.1,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
// //     final colors = Theme.of(context).colorScheme;
// //     return Container(
// //       height: 70.h,
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).colorScheme.background,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Theme.of(context).colorScheme.background,
// //             blurRadius: 10,
// //             offset: const Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.only(bottom: 0.h),
// //         child: BottomNavigationBar(
// //           type: BottomNavigationBarType.fixed,
// //           backgroundColor: Theme.of(context).colorScheme.background,
// //           currentIndex: homeProvider.selectedIndex,
// //           selectedFontSize: 11.sp,
// //           unselectedFontSize: 11.sp,
// //           selectedItemColor: colors.tertiary,
// //           unselectedItemColor: const Color(0xFF666666),
// //           selectedLabelStyle: TextStyle(
// //             fontFamily: 'Sora',
// //             fontWeight: FontWeight.w600,
// //             fontSize: 14.sp,
// //             height: 1.0,
// //           ),
// //           unselectedLabelStyle: TextStyle(
// //             fontFamily: 'Sora',
// //             fontWeight: FontWeight.w500,
// //             fontSize: 14.sp,
// //             height: 1.0,
// //           ),
// //           iconSize: 24.w,
// //           elevation: 0,
// //           onTap: (index) {
// //             if (index == 2) return;
// //             homeProvider.selectedIndex = index;
// //           },
// //           items: [
// //             // Home
// //             BottomNavigationBarItem(
// //               icon: SizedBox(
// //                 width: 25,
// //                 height: 25,
// //                 child: Image.asset(
// //                   'assets/images/home.png',
// //                   color: homeProvider.selectedIndex == 0
// //                       ? colors.tertiary
// //                       : const Color(0xFF666666),
// //                 ),
// //               ),
// //               activeIcon: SizedBox(
// //                 width: 25,
// //                 height: 25,
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
// //                 Icons.favorite,
// //                 color: homeProvider.selectedIndex == 1
// //                     ? colors.tertiary
// //                     : const Color(0xFF666666),
// //               ),
// //               activeIcon: Icon(Icons.favorite,size: 25, color: colors.tertiary),
// //               label: 'Favourites',
// //             ),
// //
// //             // FAB gap
// //             const BottomNavigationBarItem(
// //               icon: SizedBox.shrink(),
// //               label: '',
// //             ),
// //
// //             // History
// //             BottomNavigationBarItem(
// //               icon: Icon(
// //                 size: 25,
// //                 Icons.history,
// //                 color: homeProvider.selectedIndex == 3
// //                     ? colors.tertiary
// //                     : const Color(0xFF666666),
// //               ),
// //               activeIcon:  Icon(Icons.history,size: 25, color: colors.tertiary),
// //               label: 'History',
// //             ),
// //
// //             // Setting
// //             BottomNavigationBarItem(
// //               icon: Icon(
// //                 size: 25,
// //                 Icons.settings,
// //                 color: homeProvider.selectedIndex == 4
// //                     ? colors.tertiary
// //                     : const Color(0xFF666666),
// //               ),
// //               activeIcon:  Icon(Icons.settings,size: 25, color: colors.tertiary),
// //               label: 'Setting',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
