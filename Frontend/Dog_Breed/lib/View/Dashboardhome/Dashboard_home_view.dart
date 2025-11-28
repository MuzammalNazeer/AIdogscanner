import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
import 'package:dog_breed/View/HomeView/HomeView.dart';
import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
import 'package:dog_breed/View/ProfileView/ProfileView.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/View_model/home/home_view_model.dart';

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
      const Homeview(),        // index 0
      const Mypetsview(),      // index 1
      const SizedBox(),        // index 2 (FAB Placeholder)
      const Activitesview(),   // index 3
      const Profileview(),     // index 4
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
      width: 70.w,
      height: 70.h,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.addPet);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF820DFF),
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
              Icon(Icons.add, color: Colors.white, size: 24.w),
              SizedBox(height: 2.h),
              Text(
                'Add Pet',
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
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: homeProvider.selectedIndex,
          selectedFontSize: 11.sp,
          unselectedFontSize: 11.sp,
          selectedItemColor: const Color(0xFF820DFF),
          unselectedItemColor: const Color(0xFF666666),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
            height: 1.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            height: 1.0,
          ),
          iconSize: 22.w,
          elevation: 0,
          onTap: (index) {
            if (index == 2) return; // Don't select FAB
            homeProvider.selectedIndex = index;
          },
          items: [
            // Home
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: homeProvider.selectedIndex == 0
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.home_filled, color: Color(0xFF820DFF)),
              label: 'Home',
            ),

            // My Pets
            BottomNavigationBarItem(
              icon: Icon(
                Icons.pets_outlined,
                color: homeProvider.selectedIndex == 1
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.pets, color: Color(0xFF820DFF)),
              label: 'My Pets',
            ),

            // FAB gap
            const BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: '',
            ),

            // Activities
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history_outlined,
                color: homeProvider.selectedIndex == 3
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.history, color: Color(0xFF820DFF)),
              label: 'Activites',
            ),

            // Profile
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
                color: homeProvider.selectedIndex == 4
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.person, color: Color(0xFF820DFF)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
// import 'package:dog_breed/View/HomeView/HomeView.dart';
// import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// import 'package:dog_breed/View/ProfileView/ProfileView.dart';
// import 'package:dog_breed/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:dog_breed/View_model/home/home_view_model.dart';
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
//       const Mypetsview(),
//       const Activitesview(),
//       const Profileview(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final homeProvider = context.watch<HomeViewModel>();
//
//     return Scaffold(
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
//   Widget _buildAddPetFAB() {
//     return SizedBox(
//       width: 70.w,
//       height: 70.h,
//       child: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, RoutesName.addPet);
//         },
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         shape: const CircleBorder(),
//         child: Container(
//           width: 65.w,
//           height: 65.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: const Color(0xFF820DFF),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0x1919190D).withOpacity(0.15),
//                 offset: const Offset(0, 8),
//                 blurRadius: 20,
//               ),
//               BoxShadow(
//                 color: const Color(0x16223308).withOpacity(0.1),
//                 offset: const Offset(0, 4),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.add, color: Colors.white, size: 24.w),
//               SizedBox(height: 2.h),
//               Text(
//                 'Add Pet',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontSize: 10.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                   height: 1.1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
//     return Container(
//       height: 70.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 8.h),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           currentIndex: homeProvider.selectedIndex,
//           selectedFontSize: 11.sp,
//           unselectedFontSize: 11.sp,
//           selectedItemColor: const Color(0xFF820DFF),
//           unselectedItemColor: const Color(0xFF666666),
//           selectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w600,
//             fontSize: 11.sp,
//             height: 1.0,
//           ),
//           unselectedLabelStyle: TextStyle(
//             fontFamily: 'Sora',
//             fontWeight: FontWeight.w500,
//             fontSize: 11.sp,
//             height: 1.0,
//           ),
//           iconSize: 22.w,
//           elevation: 0,
//           onTap: (index) {
//             if (index == 2) {
//
//               return;
//             } else {
//               homeProvider.selectedIndex = index;
//             }
//           },
//           items: [
//             // Home
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.home_outlined,
//                   color: homeProvider.selectedIndex == 0
//                       ? const Color(0xFF820DFF)
//                       : const Color(0xFF666666),
//                 ),
//               ),
//               activeIcon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.home_filled,
//                   color: const Color(0xFF820DFF),
//                 ),
//               ),
//               label: 'Home',
//             ),
//             // My Pets
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.pets_outlined,
//                   color: homeProvider.selectedIndex == 1
//                       ? const Color(0xFF820DFF)
//                       : const Color(0xFF666666),
//                 ),
//               ),
//               activeIcon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.pets,
//                   color: const Color(0xFF820DFF),
//                 ),
//               ),
//               label: 'My Pets',
//             ),
//             // Empty space for Add Pet FAB
//             const BottomNavigationBarItem(
//               icon: SizedBox.shrink(),
//               label: '',
//             ),
//             // History
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.history_outlined,
//                   color: homeProvider.selectedIndex == 3
//                       ? const Color(0xFF820DFF)
//                       : const Color(0xFF666666),
//                 ),
//               ),
//               activeIcon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.history,
//                   color: const Color(0xFF820DFF),
//                 ),
//               ),
//               label: 'Activites',
//             ),
//             // Profile
//             BottomNavigationBarItem(
//               icon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.person_outlined,
//                   color: homeProvider.selectedIndex == 4
//                       ? const Color(0xFF820DFF)
//                       : const Color(0xFF666666),
//                 ),
//               ),
//               activeIcon: Container(
//                 padding: EdgeInsets.only(bottom: 4.h),
//                 child: Icon(
//                   Icons.person,
//                   color: const Color(0xFF820DFF),
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
// //       const Homeview(),           // 0
// //       const Mypetsview(),         // 1
// //       const Activitesview(),      // 2 → History
// //       const Profileview(),        // 3
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
// //   Widget _buildAddPetFAB() {
// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.pushNamed(context, RoutesName.hygiene);
// //       },
// //       child: Container(
// //         width: 83,
// //         height: 83,
// //         padding: const EdgeInsets.all(10),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF820DFF), // background color
// //           shape: BoxShape.circle,
// //           boxShadow: [
// //             BoxShadow(
// //               color: const Color(0x1919190D), // first shadow
// //               offset: const Offset(0, 16),
// //               blurRadius: 31,
// //             ),
// //             BoxShadow(
// //               color: const Color(0x16223308), // second shadow
// //               offset: const Offset(0, 10),
// //               blurRadius: 15,
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: const [
// //             Icon(Icons.add, color: Colors.white, size: 32),
// //             SizedBox(height: 4),
// //             Text(
// //               'Add Pet',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontFamily: 'Sora',
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
// //     return Container(
// //       margin: EdgeInsets.only(top: 10.h),
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black12,
// //             blurRadius: 4,
// //             offset: Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: BottomNavigationBar(
// //         type: BottomNavigationBarType.fixed,
// //         backgroundColor: AppColors.appWhiteColor,
// //         currentIndex: homeProvider.selectedIndex,
// //         selectedFontSize: 12.sp,
// //         unselectedFontSize: 11.sp,
// //         selectedItemColor: AppColors.appColorBlack,
// //         unselectedItemColor: AppColors.grayColor,
// //         onTap: (index) {
// //           if (index == 2) {
// //             Navigator.pushNamed(context, RoutesName.hygiene);
// //           } else {
// //             homeProvider.selectedIndex = index;
// //           }
// //         },
// //         items: [
// //           _buildNavItem(Icons.home, 'Home', 0, homeProvider.selectedIndex),
// //           _buildNavItem(Icons.pets, 'My Pets', 1, homeProvider.selectedIndex),
// //           _buildNavItem(null, '', 2, homeProvider.selectedIndex),
// //           _buildNavItem(Icons.history, 'History', 3, homeProvider.selectedIndex),
// //           _buildNavItem(Icons.person, 'Profile', 4, homeProvider.selectedIndex),
// //         ],
// //       ),
// //     );
// //   }
// //
// //
// //   BottomNavigationBarItem _buildNavItem(
// //       IconData? icon, String label, int index, int selectedIndex) {
// //     final isSelected = selectedIndex == index;
// //     if (index == 2) {
// //       return const BottomNavigationBarItem(
// //         icon: SizedBox(width: 40),
// //         label: '',
// //       );
// //     }
// //
// //     return BottomNavigationBarItem(
// //       icon: Icon(
// //         icon!,
// //         color: isSelected ? AppColors.appColorBlack : AppColors.grayColor,
// //         size: 24,
// //       ),
// //       label: label,
// //     );
// //   }
// // }
// //
// // //
// // //
// // // import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
// // // import 'package:dog_breed/View/HomeView/HomeView.dart';
// // // import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// // // import 'package:dog_breed/View/ProfileView/ProfileView.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:dog_breed/Valid/AppColors.dart';
// // // import 'package:dog_breed/View_model/home/home_view_model.dart';
// // //
// // //
// // // class DashboardHomeView extends StatefulWidget {
// // //   const DashboardHomeView({super.key});
// // //
// // //   @override
// // //   State<DashboardHomeView> createState() => _DashboardHomeViewState();
// // // }
// // //
// // // class _DashboardHomeViewState extends State<DashboardHomeView> {
// // //   late final List<Widget> _widgetOptions;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _widgetOptions = <Widget>[
// // //       const Homeview(),
// // //       const Mypetsview(),
// // //       const Activitesview(),
// // //       const Profileview(),
// // //     ];
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final homeProvider = context.watch<HomeViewModel>();
// // //
// // //     return Scaffold(
// // //       backgroundColor: AppColors.appColorWhite,
// // //       body: IndexedStack(
// // //         index: homeProvider.selectedIndex,
// // //         children: _widgetOptions,
// // //       ),
// // //       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
// // //     );
// // //   }
// // //
// // //   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
// // //     return Container(
// // //       decoration: const BoxDecoration(
// // //         color: Colors.white,
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black12,
// // //             blurRadius: 4,
// // //             offset: Offset(0, -2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: BottomNavigationBar(
// // //         type: BottomNavigationBarType.fixed,
// // //         backgroundColor: AppColors.appWhiteColor,
// // //         currentIndex: homeProvider.selectedIndex,
// // //         selectedFontSize: 12.sp,
// // //         unselectedFontSize: 11.sp,
// // //         selectedItemColor: AppColors.appColorBlack,
// // //         unselectedItemColor: AppColors.grayColor,
// // //         onTap: (index) => homeProvider.selectedIndex = index, // use setter
// // //         items: [
// // //           _buildNavItem(Icons.home, 'Home', 0, homeProvider.selectedIndex),
// // //           _buildNavItem(Icons.document_scanner, 'Mypets', 1, homeProvider.selectedIndex),
// // //           _buildNavItem(Icons.cases_rounded, 'Organization', 2, homeProvider.selectedIndex),
// // //           _buildNavItem(Icons.person, 'Activites', 3, homeProvider.selectedIndex),
// // //           _buildNavItem(Icons.settings, 'Profile', 4, homeProvider.selectedIndex),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   BottomNavigationBarItem _buildNavItem(
// // //       IconData icon, String label, int index, int selectedIndex) {
// // //     final isSelected = selectedIndex == index;
// // //     return BottomNavigationBarItem(
// // //       icon: Icon(
// // //         icon,
// // //         color: isSelected ? AppColors.appColorBlack : AppColors.grayColor,
// // //       ),
// // //       label: label,
// // //     );
// // //   }
// // // }
// // //
// // //
// // // // import 'package:dog_breed/View/ActivitesView/ActivitesView.dart';
// // // // import 'package:dog_breed/View/HomeView/HomeView.dart';
// // // // import 'package:dog_breed/View/MyPetsView/MyPetsView.dart';
// // // // import 'package:dog_breed/View/ProfileView/ProfileView.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:dog_breed/Valid/AppColors.dart';
// // // // import 'package:dog_breed/View_model/home/home_view_model.dart';
// // // //
// // // //
// // // // class DashboardHomeView extends StatefulWidget {
// // // //   const DashboardHomeView({super.key});
// // // //
// // // //   @override
// // // //   State<DashboardHomeView> createState() => _DashboardHomeViewState();
// // // // }
// // // //
// // // // class _DashboardHomeViewState extends State<DashboardHomeView> {
// // // //   late final List<Widget> _widgetOptions;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _widgetOptions = <Widget>[
// // // //       const Homeview(),
// // // //       const Mypetsview(),
// // // //       const Activitesview(),
// // // //       const Profileview(),
// // // //     ];
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final homeProvider = context.watch<HomeViewModel>();
// // // //
// // // //     return Scaffold(
// // // //       backgroundColor: AppColors.appColorWhite,
// // // //       body: IndexedStack(
// // // //         index: homeProvider.selectedIndex,
// // // //         children: _widgetOptions,
// // // //       ),
// // // //       bottomNavigationBar: _buildBottomNavigationBar(homeProvider),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildBottomNavigationBar(HomeViewModel homeProvider) {
// // // //     return Container(
// // // //       decoration: const BoxDecoration(
// // // //         color: Colors.white,
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.black12,
// // // //             blurRadius: 4,
// // // //             offset: Offset(0, -2),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: BottomNavigationBar(
// // // //         type: BottomNavigationBarType.fixed,
// // // //         backgroundColor: AppColors.appWhiteColor,
// // // //         currentIndex: homeProvider.selectedIndex,
// // // //         selectedFontSize: 12.sp,
// // // //         unselectedFontSize: 11.sp,
// // // //         selectedItemColor: AppColors.appColorBlack,
// // // //         unselectedItemColor: AppColors.grayColor,
// // // //         onTap: (index) => homeProvider.selectedIndex = index, // use setter
// // // //         items: [
// // // //           _buildNavItem(Icons.home, 'Home', 0, homeProvider.selectedIndex),
// // // //           _buildNavItem(Icons.document_scanner, 'Mypets', 1, homeProvider.selectedIndex),
// // // //           _buildNavItem(Icons.cases_rounded, 'Organization', 2, homeProvider.selectedIndex),
// // // //           _buildNavItem(Icons.person, 'Activites', 3, homeProvider.selectedIndex),
// // // //           _buildNavItem(Icons.settings, 'Profile', 4, homeProvider.selectedIndex),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   BottomNavigationBarItem _buildNavItem(
// // // //       IconData icon, String label, int index, int selectedIndex) {
// // // //     final isSelected = selectedIndex == index;
// // // //     return BottomNavigationBarItem(
// // // //       icon: Icon(
// // // //         icon,
// // // //         color: isSelected ? AppColors.appColorBlack : AppColors.grayColor,
// // // //       ),
// // // //       label: label,
// // // //     );
// // // //   }
// // // // }
