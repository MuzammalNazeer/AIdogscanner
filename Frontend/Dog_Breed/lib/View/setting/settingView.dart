import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart'; // For permissions
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

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

  // Update these with your actual app details
  static const String _androidPackageName = 'com.example.hiddencamerafinder';
  static const String _iosAppId = '123456789'; // Your actual iOS App ID
  static const String _appName = 'Hidden Camera Finder';
  static const String _shareMessage = 'Check out Hidden Camera Finder - an amazing app for detecting hidden cameras!';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidPackageName';
  static const String _appStoreUrl = 'https://apps.apple.com/app/id$_iosAppId';

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
                color: Theme.of(context).colorScheme.onSurface,
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
          onTap: () => Navigator.pushNamed(context, RoutesName.myFavourites),
          iconBackgroundColor: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFDD2E44),
        ),

        _buildSettingOptionTile(
          iconPath: 'assets/images/fd.svg',
          title: 'Feedback',
          onTap: () {
            Navigator.pushNamed(context, RoutesName.feedback);
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
          onTap: () async {
            await _shareApp();
          },
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
                  color: Theme.of(context).colorScheme.background,
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
                color: Theme.of(context).colorScheme.background,
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
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Expanded(
                        child: Text(
                          'Enjoying the app?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        const TextSpan(text: 'Do you enjoy using the\n'),
                        TextSpan(
                          text: 'Hidden Camera Finder?',
                          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                   Text(
                    "We'd greatly appreciate it if\nyou could rate us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
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
                          // Launch store after a short delay
                          Future.delayed(const Duration(milliseconds: 300), () {
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
                        _selectedStars > 0 ? 'Rate Us' : 'Select Stars',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
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
                        'Rate on Store',
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

  Future<void> _launchStoreRating() async {
    try {
      String url;

      // Check platform and create appropriate store URL
      if (Platform.isAndroid) {
        url = 'market://details?id=$_androidPackageName';
      } else if (Platform.isIOS) {
        url = 'itms-apps://itunes.apple.com/app/id$_iosAppId';
      } else {
        // Fallback for other platforms
        url = _playStoreUrl;
      }

      // Try to launch the deep link
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // If deep link fails, try the web URL
        final webUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;

        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(
            Uri.parse(webUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Show error message if nothing works
          if (context.mounted) {
            _showErrorSnackBar('Could not open app store. Please try again later.');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching store: $e');
      }
      if (context.mounted) {
        _showErrorSnackBar('Error opening app store.');
      }
    }
  }

  Future<void> _shareApp() async {
    try {
      if (!mounted) return;

      // Create optimized share content
      String shareUrl;
      String shareText;

      if (Platform.isIOS) {
        shareUrl = _appStoreUrl;
        shareText = '📱 Discover $_appName on the App Store!';
      } else if (Platform.isAndroid) {
        shareUrl = _playStoreUrl;
        shareText = '📱 Get $_appName on Google Play!';
      } else {
        shareUrl = _playStoreUrl;
        shareText = '📱 Check out $_appName!';
      }

      // Create the full share content
      final shareContent = '''
$shareText

🔍 $_shareMessage

🔗 Download now: $shareUrl

#HiddenCameraFinder #SecurityApp #Privacy''';

      // Get position for share dialog (optional, but helps positioning)
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      final Rect? sharePosition = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      // Call Share.share() - This will show ALL sharing options
      final result = await Share.share(
        shareContent,
        subject: '$_appName - Hidden Camera Detection App',
        sharePositionOrigin: sharePosition,
      );

      // // Log the result (optional)
      // if (kDebugMode) {
      //   print('Share completed: $result');
      // }

    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Share PlatformException: ${e.message}');
      }
      if (mounted) {
        _showErrorSnackBar('Unable to open share options. Error: ${e.message}');

        // Fallback: Show manual share options dialog
        _showManualShareOptions();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in _shareApp: $e\n$stackTrace');
      }
      if (mounted) {
        // Fallback: Show custom share dialog with options
        _showCustomShareDialog();
      }
    }
  }

  // Fallback method to show manual share options
  void _showManualShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share App',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 20.h),

              // Copy Link Option
              ListTile(
                leading: Icon(Icons.link, color: Theme.of(context).primaryColor),
                title: Text('Copy Link', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                onTap: () async {
                  Navigator.pop(context);
                  await _copyToClipboard();
                },
              ),

              // Share via WhatsApp
              ListTile(
                leading: Icon(Icons.chat, color: Colors.green),
                title: Text('Share via WhatsApp', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaWhatsApp();
                },
              ),

              // Share via Email
              ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text('Share via Email', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaEmail();
                },
              ),

              // Share via SMS
              ListTile(
                leading: Icon(Icons.sms, color: Colors.blue),
                title: Text('Share via SMS', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaSMS();
                },
              ),

              SizedBox(height: 10.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  // Custom share dialog with multiple options
  void _showCustomShareDialog() {
    final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    final shareContent = '$_shareMessage\n\n$shareUrl';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Share $_appName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose how you want to share:'),
              SizedBox(height: 20),

              // Quick actions
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // Copy
                  ActionChip(
                    avatar: Icon(Icons.copy, size: 18),
                    label: Text('Copy'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _copyToClipboard();
                    },
                  ),

                  // WhatsApp
                  ActionChip(
                    avatar: Icon(Icons.chat, size: 18, color: Colors.green),
                    label: Text('WhatsApp'),
                    onPressed: () {
                      Navigator.pop(context);
                      _shareViaWhatsApp();
                    },
                  ),

                  // More Options
                  ActionChip(
                    avatar: Icon(Icons.more_horiz, size: 18),
                    label: Text('More'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Try system share again
                      _retrySystemShare();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Copy to clipboard fallback
  Future<void> _copyToClipboard() async {
    try {
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareContent = '$_shareMessage\n\n$shareUrl';

      await Clipboard.setData(ClipboardData(text: shareContent));

      if (mounted) {
        _showSuccessSnackBar('Link copied to clipboard! You can now paste and share it.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to copy to clipboard.');
      }
    }
  }

  // Share via WhatsApp
  Future<void> _shareViaWhatsApp() async {
    try {
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final whatsappUrl = Platform.isIOS
          ? 'whatsapp://send?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}'
          : 'https://wa.me/?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  // Share via Email
  Future<void> _shareViaEmail() async {
    try {
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final emailUrl = 'mailto:?subject=$_appName&body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  // Share via SMS
  Future<void> _shareViaSMS() async {
    try {
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final smsUrl = 'sms:?body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(smsUrl))) {
        await launchUrl(Uri.parse(smsUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  // Retry system share
  Future<void> _retrySystemShare() async {
    try {
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareContent = '$_shareMessage\n\n$shareUrl';

      await Share.share(
        shareContent,
        subject: '$_appName - Hidden Camera Detection App',
      );
    } catch (e) {
      await _copyToClipboard();
    }
  }

  // Method to save rating locally
  void _saveRating(int stars) {
    if (kDebugMode) {
      print('User rated: $stars stars');
    }
  }

  // Method to show feedback dialog for low ratings
  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                Navigator.pop(context);
                _showSuccessSnackBar('Thank you for your feedback!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6B03F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Feedback'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

