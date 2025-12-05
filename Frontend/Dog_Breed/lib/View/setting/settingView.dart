import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../View_model/ThemeNotifier.dart';
import '../../utils/routes/routes_name.dart';

class Settingview extends StatefulWidget {
  const Settingview({super.key});

  @override
  State<Settingview> createState() => _SettingviewState();
}

class _SettingviewState extends State<Settingview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20.h),
              _buildSettingsSection(),
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
                color: Theme.of(context).colorScheme.onBackground,
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
            ),          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingOptionTile(
          iconPath: 'assets/images/ff.svg',
          title: 'My Favorites',
          onTap: () => Navigator.pushNamed(context, RoutesName.favourites),
          iconBackgroundColor: const Color(0xFFFEF2F2), // Light red
          iconColor: const Color(0xFFDD2E44), // Red icon
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/fd.svg',
          title: 'Feedback',
          onTap: () {
            // Navigate to feedback
          },
          iconBackgroundColor: const Color(0xFFF0F9FF), // Light blue
          iconColor: const Color(0xFF00D9FF), // Blue icon
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/rs.svg',
          title: 'Rate us',
          onTap: () {
            // Navigate to rate
          },
          iconBackgroundColor: const Color(0xFFFFF7ED), // Light orange
          iconColor: const Color(0xFFF6B03F), // Orange icon
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/sh.svg',
          title: 'Share',
          onTap: () {
            // Share functionality
          },
          iconBackgroundColor: const Color(0xFFF0FDF4), // Light green
          iconColor: const Color(0xFF0B75FF), // Green icon
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/mp.svg',
          title: 'My Premium Service',
          onTap: () => Navigator.pushNamed(context, RoutesName.pro),
          iconBackgroundColor: const Color(0xFFFAF5FF), // Light purple
          iconColor: const Color(0xFFF69104), // Purple icon
        ),

        _buildThemeSwitchTile(),
      ],
    );
  }
  Widget _buildThemeSwitchTile() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeProvider, child) {
        return Container(
          height: 55.h,
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SvgPicture.asset(
                  'assets/images/th.svg',
                  color:  const Color(0xFF000000),
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Theme',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (val) {
                  themeProvider.toggleTheme(val);
                },
                activeColor: const Color(0xFFCBD8CB),
                activeTrackColor:  const Color(0xFFFFFFFF),
                inactiveTrackColor:  const Color(0xFFFFFFFF),
              ),
              SizedBox(width: 4.w),
              Text(
                themeProvider.isDarkMode ? 'Dark' : 'Light',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingOptionTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    Color borderColor = Colors.transparent,
    Color? iconColor, required Color iconBackgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 55.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: borderColor,
                  width: 2.w,
                ),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
                width: 20.w,
                height: 20.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Soro',
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.w,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

