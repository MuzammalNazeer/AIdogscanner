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
                      ? const Color(0xFF820DFF)
                      : const Color(0xFF666666),
                ),
              ),
              activeIcon: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  'assets/images/home.png',
                  color: const Color(0xFF820DFF),
                ),
              ),
              label: 'Home',
            ),

            // BottomNavigationBarItem(
            //   icon: Icon(
            //     size: 25,
            //     Icons.home_filled,
            //     color: homeProvider.selectedIndex == 0
            //         ? const Color(0xFF820DFF)
            //         : const Color(0xFF666666),
            //   ),
            //   activeIcon: const Icon(Icons.home_filled, color: Color(0xFF820DFF)),
            //   label: 'Home',
            // ),

            // Favourites
            BottomNavigationBarItem(
              icon: Icon(
                size: 25,
                Icons.favorite,
                color: homeProvider.selectedIndex == 1
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.favorite,size: 25, color: Color(0xFF820DFF)),
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
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.history,size: 25, color: Color(0xFF820DFF)),
              label: 'History',
            ),

            // Setting
            BottomNavigationBarItem(
              icon: Icon(
                size: 25,
                Icons.settings,
                color: homeProvider.selectedIndex == 4
                    ? const Color(0xFF820DFF)
                    : const Color(0xFF666666),
              ),
              activeIcon: const Icon(Icons.settings,size: 25, color: Color(0xFF820DFF)),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}

