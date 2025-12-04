import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Settingview extends StatefulWidget {
  const Settingview({super.key});

  @override
  State<Settingview> createState() => _SettingviewState();
}

class _SettingviewState extends State<Settingview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 5.h),
              _buildSettingsList(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.normal,
                fontSize: 30.sp,
                height: 1.0,
                letterSpacing: 0.0,
                color: const Color(0xFF371B34),
              ),
            ),
            SizedBox(width: 188.w),
            SizedBox(
              height: 92.h,
              width: 92.w,
              child: Center(
                child: Transform.rotate(
                  angle: -80.11,
                  child: Image.asset(
                    'assets/images/Group88.png',
                    width: 92.w,
                    height: 92.h,
                    color: const Color(0xFFF3F6F3),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF686868).withOpacity(0.08), // 8% opacity
      ),
      child: Column(
        children: [
          _buildSettingItem(
            title: 'Edit Profile',

            onTap: () {
            },
            imagePath: 'assets/images/p1.png',
          ),
          _buildSettingItem(
            title: 'Notifications',

            onTap: () {
            }, imagePath: 'assets/images/n.png',
          ),
          _buildSettingItem(
            title: 'App Language',

            onTap: () {
            }, imagePath: 'assets/images/l.png',
          ),
          _buildSettingItem(
            title: 'Notification language',

            onTap: () {
            }, imagePath: 'assets/images/nl.png',
          ),
          _buildSettingItem(
            title: 'Premium Subscription',

            onTap: () {
            }, imagePath: 'assets/images/ps.png',
          ),
          _buildSettingItem(
            title: 'About us',

            onTap: () {
            }, imagePath: 'assets/images/b (2).png',
          ),
          _buildSettingItem(
            title: 'FAQ',

            onTap: () {
            }, imagePath: 'assets/images/fa.png',
          ),
          _buildSettingItem(
            title: 'Terms of Use',

            onTap: () {
            }, imagePath: 'assets/images/to.png',
          ),
          _buildSettingItem(
            title: 'Customer Care',

            onTap: () {
            }, imagePath: 'assets/images/cc.png',
          ),
          _buildSettingItem(
            title: 'Measurement units',

            onTap: () {
            }, imagePath: 'assets/images/mu.png',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String imagePath,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF686868).withOpacity(0.08),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 24.w,
                  height: 24.h,
                  color: const Color(0xFF820DFF),
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: const Color(0xFF371B34),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}
