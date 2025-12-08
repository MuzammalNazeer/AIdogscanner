import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../View_model/ThemeNotifier.dart';
import '../../utils/routes/routes_name.dart';

class Settingview extends StatefulWidget {
  const Settingview({super.key});

  @override
  State<Settingview> createState() => _SettingviewState();
}

class _SettingviewState extends State<Settingview> {
  int _selectedStars = 0;
  bool _hasRated = false;

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
              SizedBox(height: 10.h),
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
            ),
          ],
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
          iconBackgroundColor: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFDD2E44),
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/fd.svg',
          title: 'Feedback',
          onTap: () {
            // Navigator.pushNamed(context, RoutesName.feedback);
          },
          iconBackgroundColor: const Color(0xFFF0F9FF),
          iconColor: const Color(0xFF00D9FF),
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/rs.svg',
          title: 'Rate us',
          onTap: () {
            _showRateUsDialog(context);
          },
          iconBackgroundColor: const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFF6B03F),
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/sh.svg',
          title: 'Share',
          onTap: () {},
          iconBackgroundColor: const Color(0xFFF0FDF4),
          iconColor: const Color(0xFF0B75FF),
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/mp.svg',
          title: 'My Premium Service',
          onTap: () => Navigator.pushNamed(context, RoutesName.pro),
          iconBackgroundColor: const Color(0xFFFAF5FF),
          iconColor: const Color(0xFFF69104),
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
            color: const Color(0xFFF4F7F6).withOpacity(0.1),
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
                  'assets/images/tm.svg',
                  color: const Color(0xFFF8C600),
                  width: 24.w,
                  height: 24.h,
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
                activeTrackColor: const Color(0xFFFFFFFF),
                inactiveTrackColor: const Color(0xFFFFFFFF),
              ),
              SizedBox(width: 4.w),
              Text(
                themeProvider.isDarkMode ? 'Dark' : 'Light',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
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
    Color? iconColor,
    required Color iconBackgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 55.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7F6).withOpacity(0.1),
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
              height: 40.h,
              width: 40.w,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor, width: 2.w),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
                width: 24.w,
                height: 24.h,
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

  void _showRateUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Text(
                    'Enjoying the app?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(text: 'Do you enjoy using the\n'),
                        TextSpan(
                          text: 'Hidden Camera Finder?',
                          style: TextStyle(fontSize: 16,
                            color: Colors.grey,),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  const Text(
                    "We'd greatly appreciate it if\nyou could rate us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_hasRated) ...[
                    const Text(
                      'Tap to rate:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStars = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              index < _selectedStars
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 40,
                              color: index < _selectedStars
                                  ? const Color(0xFFF6B03F)
                                  : Colors.grey[300],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _selectedStars > 0
                          ? () {
                        // Save rating locally
                        _saveRating(_selectedStars);

                        // Show different UI based on rating
                        if (_selectedStars >= 4) {
                          // High rating - ask to rate in store
                          setState(() {
                            _hasRated = true;
                          });
                          // You can launch store immediately or show another dialog
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                            _launchStoreRating();
                          });
                        } else {
                          // Low rating - ask for feedback
                          Navigator.pop(context);
                          _showFeedbackDialog(context);
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedStars > 0
                            ? const Color(0xFFF6B03F)
                            : Colors.grey[300],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedStars > 0
                            ? 'Rate Us '
                            : '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Thank you message after rating
                    Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thank you for your rating!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your feedback helps us improve.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchStoreRating();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6B03F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Rate ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                ],
              ),
            );
          },
        );
      },
    );
  }
// Add this method to your State class
  Future<void> _launchStoreRating() async {
    try {
      // For Android - replace 'com.your.package.name' with your actual package name
      const String androidPackageName = 'com.example.hiddencamerafinder';

      // For iOS - replace '123456789' with your actual App Store ID
      const String iosAppId = '123456789';

      String url;

      // Check platform and create appropriate store URL
      if (Platform.isAndroid) {
        url = 'market://details?id=$androidPackageName';
      } else if (Platform.isIOS) {
        url = 'https://apps.apple.com/app/id$iosAppId';
      } else {
        // Fallback for other platforms
        url = 'https://play.google.com/store/apps/details?id=$androidPackageName';
      }

      // Launch the URL
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Fallback to web URL if the store app can't be launched
        final webUrl = Platform.isIOS
            ? 'https://apps.apple.com/app/id$iosAppId'
            : 'https://play.google.com/store/apps/details?id=$androidPackageName';

        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(Uri.parse(webUrl));
        } else {
          // Show error message if nothing works
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open app store. Please try again later.'),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching store: $e');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening app store.'),
          ),
        );
      }
    }
  }
// Method to save rating locally
  void _saveRating(int stars) {
    // Save rating to SharedPreferences or local storage
    // This prevents showing the dialog again if already rated
    // Example using shared_preferences:

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('app_rating', stars);
    // await prefs.setBool('has_rated', true);

    print('User rated: $stars stars');
  }

// Method to show feedback dialog for low ratings
  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('We\'re sorry to hear that'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'What can we do better? Your feedback helps us improve.',
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us what we can improve...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Submit feedback
                Navigator.pop(context);
                // Show thank you message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Submit Feedback'),
            ),
          ],
        );
      },
    );
  }
}
