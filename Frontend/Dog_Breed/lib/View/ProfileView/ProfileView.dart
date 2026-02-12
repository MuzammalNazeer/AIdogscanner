import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../View_model/ThemeNotifier.dart';
import '../../config/components/CommonApp.dart';
import '../../config/components/FAQView.dart';
import '../../utils/routes/routes_name.dart';

class Profileview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Profileview({super.key, this.onShowSnackBar});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  int _selectedStars = 0;
  bool _hasRated = false;

  static const String _androidPackageName = 'com.nabatiah.carepaw.aidogscanner';
  static const String _iosAppId = '123456789';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidPackageName';
  static const String _appStoreUrl = 'https://apps.apple.com/app/id$_iosAppId';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CommonApp(title: l10n.navProfile, showBackButton: false),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(
                  height: 850.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: ListView(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: l10n.editProfile,
                        onTap: () =>
                            Navigator.pushNamed(context, RoutesName.editProfile),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/save.png",
                        title: l10n.profileRecentScan,
                        onTap: () =>
                            Navigator.pushNamed(context, RoutesName.listsave),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/notafication.png",
                        title: l10n.profileHistory,
                        onTap: () =>
                            Navigator.pushNamed(context, RoutesName.history),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/notafication.png",
                        title: l10n.notifications,
                        onTap: () =>
                            Navigator.pushNamed(context, RoutesName.notification),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/language.png",
                        title: l10n.appLanguageTitle,
                        onTap: () =>
                            Navigator.pushNamed(context, RoutesName.appLanguage),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/premium.png",
                        title: l10n.premiumSubscription,
                        onTap: () => Navigator.pushNamed(
                            context, RoutesName.pro,
                            arguments: {'fromProfile': true}),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/heart.png",
                        title: l10n.profileMyFavorites,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RoutesName.favourites,
                        ),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/feed.png",
                        title: l10n.feedbackTitle,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RoutesName.feedback,
                        ),
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/rates.png",
                        title: l10n.rateUsTitle,
                        onTap: () {
                          _showRateUsDialog(context);
                        },
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/sha.png",
                        title: l10n.shareTitle,
                        onTap: () async {
                          await _shareApp();
                        },
                      ),
                      _buildThemeSwitchTile(),
                      Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                        height: 1,
                        thickness: 1,
                        indent: 0.w,
                      ),
                      _buildSettingsTile(
                        imagePath: "assets/images/faq.png",
                        title: l10n.faq,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FAQView(),
                            ),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: l10n.termsOfUse,
                        showDivider: false,
                        onTap: () async {
                          final Uri url = Uri.parse('https://nabatiah.com/privacy-policy/');
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            throw Exception(l10n.errorLaunchUrl(url.toString()));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitchTile() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeProvider, child) {
        final colors = Theme.of(context).colorScheme;
        bool isDarkTheme = themeProvider.isDarkMode;

        return Container(
          height: 55.h,
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset(
                  'assets/images/theme.png',
                  color: AppColors.vibrantPurple,
                  height: 25.h,
                  width: 25.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.themeTitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              FlutterSwitch(
                width: 85.w,
                height: 35.h,
                toggleSize: 27.h,
                valueFontSize: 16.sp,
                value: isDarkTheme,
                borderRadius: 25.r,
                padding: 3,
                activeText: AppLocalizations.of(context)!.darkTheme,
                inactiveText: AppLocalizations.of(context)!.lightTheme,
                activeTextColor: Colors.grey,
                inactiveTextColor: Colors.black,
                activeTextFontWeight: FontWeight.w400,
                inactiveTextFontWeight: FontWeight.w400,
                activeColor: AppColors.vibrantPurple,
                inactiveColor: Theme.of(context).disabledColor,
                showOnOff: true,
                onToggle: (val) => themeProvider.toggleTheme(val),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareApp() async {
    try {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;

      // App info for Dog_Breed
      const androidPackageId = 'com.example.dog_breed';
      const iosAppId = '123456789';
      final shareMessage = l10n.shareMessageBody;
      const playStoreUrl =
          'https://play.google.com/store/apps/details?id=$androidPackageId';
      final appStoreUrl = 'https://apps.apple.com/app/id$iosAppId';

      // Determine platform
      String shareUrl;
      String shareText;

      if (Platform.isIOS) {
        shareUrl = appStoreUrl;
        shareText = l10n.shareIOS;
      } else if (Platform.isAndroid) {
        shareUrl = playStoreUrl;
        shareText = l10n.shareAndroid;
      } else {
        shareUrl = playStoreUrl;
        shareText = l10n.shareDefault;
      }

      // Full share content
      final shareContent = '''
$shareText

🔍 $shareMessage

🔗 ${l10n.shareDownloadNow}$shareUrl

#DogBreed #Dogs #Pets
''';

      // Position for share sheet
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      final Rect? sharePosition =
      box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      // Show system share dialog
      await Share.share(
        shareContent,
        subject: l10n.shareSubject,
        sharePositionOrigin: sharePosition,
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Share PlatformException: ${e.message}');
      }
      if (mounted) {
        _showManualShareOptions();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in _shareApp: $e\n$stackTrace');
      }
      if (mounted) {
        _showCustomShareDialog();
      }
    }
  }

  void _showCustomShareDialog() {
    final l10n = AppLocalizations.of(context)!;
    final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    final shareMessage = l10n.shareMessageBody;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.dialogShareTitle(l10n.aiAppName)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.chooseShare),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.copy, size: 18),
                    label: Text(l10n.copy),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _copyToClipboard();
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.chat, size: 18, color: Colors.green),
                    label: Text(l10n.whatsapp),
                    onPressed: () {
                      Navigator.pop(context);
                      _shareViaWhatsApp();
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.more_horiz, size: 18),
                    label: Text(l10n.more),
                    onPressed: () {
                      Navigator.pop(context);
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
              child: Text(l10n.dialogCancel),
            ),
          ],
        );
      },
    );
  }

  void _showManualShareOptions() {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.shareApp,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.link, color: Theme.of(context).primaryColor),
                title: Text(l10n.copyLink,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                onTap: () async {
                  Navigator.pop(context);
                  await _copyToClipboard();
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: Text(l10n.shareWhatsApp,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaWhatsApp();
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: Text(l10n.shareEmail,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaEmail();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sms, color: Colors.blue),
                title: Text(l10n.shareSMS,
                    style: TextStyle(
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
                child: Text(l10n.dialogCancel,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _copyToClipboard() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareMessage = l10n.shareMessageBody;
      final shareContent = '$shareMessage\n\n$shareUrl';

      await Clipboard.setData(ClipboardData(text: shareContent));

      if (mounted) {
        _showSuccessSnackBar(l10n.linkCopied);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(AppLocalizations.of(context)!.copyFailed);
      }
    }
  }

  Future<void> _shareViaWhatsApp() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareMessage = l10n.shareMessageBody;
      final whatsappUrl = Platform.isIOS
          ? 'whatsapp://send?text=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}'
          : 'https://wa.me/?text=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  Future<void> _shareViaEmail() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareMessage = l10n.shareMessageBody;
      final emailUrl =
          'mailto:?subject=${l10n.aiAppName}&body=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  Future<void> _shareViaSMS() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareMessage = l10n.shareMessageBody;
      final smsUrl = 'sms:?body=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';

      if (await canLaunchUrl(Uri.parse(smsUrl))) {
        await launchUrl(Uri.parse(smsUrl));
      } else {
        await _copyToClipboard();
      }
    } catch (e) {
      await _copyToClipboard();
    }
  }

  Future<void> _retrySystemShare() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
      final shareMessage = l10n.shareMessageBody;
      final shareContent = '$shareMessage\n\n$shareUrl';

      await Share.share(
        shareContent,
        subject: l10n.shareSubject,
      );
    } catch (e) {
      await _copyToClipboard();
    }
  }

  Widget _buildSettingsTile({
    IconData? icon,
    String? imagePath,
    required String title,
    required VoidCallback onTap,
    bool isRed = false,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            leading: imagePath != null
                ? Image.asset(
              imagePath,
              height: 25.h,
              width: 25.w,
              color: isRed
                  ? Theme.of(context).colorScheme.error
                  : AppColors.vibrantPurple,
            )
                : Icon(
              icon,
              size: 25.sp,
              color: isRed
                  ? Theme.of(context).colorScheme.error
                  : AppColors.vibrantPurple,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: onTap,
            minVerticalPadding: 8.h,
            dense: true,
          ),
        ),
        if (showDivider)
          Divider(
            color: Theme.of(context).colorScheme.onPrimary,
            height: 1,
            thickness: 1,
            indent: 0.w,
          ),
      ],
    );
  }

  void _showRateUsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Text(
                    l10n.enjoyingApp,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.tapToRate),
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
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectedStars > 0
                        ? () {
                      _saveRating(_selectedStars);

                      if (_selectedStars == 5) {
                        setState(() {
                          _hasRated = true;
                        });
                        Future.delayed(const Duration(milliseconds: 300),
                                () {
                              Navigator.pop(context);
                              _launchStoreRating();
                            });
                      } else {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RoutesName.feedback);
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStars > 0
                          ? const Color(0xFFF6B03F)
                          : Theme.of(context).disabledColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedStars > 0 ? l10n.rateUsAction : l10n.selectStars,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveRating(int stars) {
    if (kDebugMode) {
      print('User rated: $stars stars');
    }
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
            _showErrorSnackBar(AppLocalizations.of(context)!.errorAppStore);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching store: $e');
      }
      if (context.mounted) {
        _showErrorSnackBar(AppLocalizations.of(context)!.errorOpenStore);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 400.h,
              margin: EdgeInsets.only(top: 60.h),
              padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 24.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    l10n.deleteProfileWarning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).disabledColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              l10n.dialogCancel,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Add delete logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              l10n.dialogDelete,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset('assets/images/image104.png', height: 230.h),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Center(
          child: Text(
            l10n.dialogLogoutTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.no,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.yes,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../View_model/ThemeNotifier.dart';
// import '../../config/components/CommonApp.dart';
// import '../../config/components/FAQView.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Profileview extends StatefulWidget {
//   final void Function(String message)? onShowSnackBar;
//
//   const Profileview({super.key, this.onShowSnackBar});
//
//   @override
//   State<Profileview> createState() => _ProfileviewState();
// }
//
// class _ProfileviewState extends State<Profileview> {
//   int _selectedStars = 0;
//   bool _hasRated = false;
//
//   static const String _androidPackageName = 'com.nabatiah.carepaw.aidogscanner';
//   static const String _iosAppId = '123456789';
//   // Removed static const _appName and _shareMessage to allow localization
//   static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidPackageName';
//   static const String _appStoreUrl = 'https://apps.apple.com/app/id$_iosAppId';
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: CommonApp(title: l10n.navProfile, showBackButton: false),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding:  EdgeInsets.symmetric( horizontal: 15.w),
//                 child: Container(
//                   height: 850.h,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondaryContainer,
//                     borderRadius: BorderRadius.circular(18.r),
//                   ),
//                   child: ListView(
//                     children: [
//                       _buildSettingsTile(
//                         icon: Icons.person_outline,
//                         title: l10n.editProfile,
//                         onTap: () =>
//                             Navigator.pushNamed(context, RoutesName.editProfile),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/save.png",
//                         title: l10n.profileRecentScan,
//                         onTap: () =>
//                             Navigator.pushNamed(context, RoutesName.listsave),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/notafication.png",
//                         title: l10n.profileHistory,
//                         onTap: () =>
//                             Navigator.pushNamed(context, RoutesName.history),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/notafication.png",
//                         title: l10n.notifications,
//                         onTap: () =>
//                             Navigator.pushNamed(context, RoutesName.notification),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/language.png",
//                         title: l10n.appLanguageTitle,
//                         onTap: () =>
//                             Navigator.pushNamed(context, RoutesName.appLanguage),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/premium.png",
//                         title: l10n.premiumSubscription,
//                         onTap: () => Navigator.pushNamed(context, RoutesName.pro, arguments: {'fromProfile': true}),                      ),
//
//                       _buildSettingsTile(
//                         imagePath: "assets/images/heart.png",
//                         title: l10n.profileMyFavorites,
//                         onTap: () => Navigator.pushNamed(
//                           context,
//                           RoutesName.favourites,
//                         ),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/feed.png",
//                         title: l10n.feedbackTitle,
//                         onTap: () => Navigator.pushNamed(
//                           context,
//                           RoutesName.feedback,
//                         ),
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/rates.png",
//                         title: l10n.rateUsTitle,
//                         onTap: () {
//                           _showRateUsDialog(context);
//                         },
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/sha.png",
//                         title: l10n.shareTitle,
//                         onTap: () async {
//                           await _shareApp();
//                         },
//                       ),
//                       _buildThemeSwitchTile(),
//                       Divider(
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
//                         height: 0,
//                         thickness: 1,
//                         indent: 0.w,
//                       ),
//                       _buildSettingsTile(
//                         imagePath: "assets/images/faq.png",
//                         title: l10n.faq,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const FAQView(),
//                             ),
//                           );
//                         },
//                       ),
//                       _buildSettingsTile(
//                         icon: Icons.description_outlined,
//                         title: l10n.termsOfUse,
//                         showDivider: false,
//                         onTap: () async {
//                           final Uri url = Uri.parse('https://nabatiah.com/privacy-policy/');
//                           if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//                             final l10n = AppLocalizations.of(context)!;
//                             throw Exception(l10n.errorLaunchUrl(url.toString()));
//                           }
//                         },
//                       ),
//                       // _buildSettingsTile(
//                       //   imagePath: "assets/images/delete.png",
//                       //   title: l10n.deleteOwnerProfile,
//                       //   isRed: true,
//                       //   onTap: () => _showDeleteConfirmationDialog(),
//                       // ),
//                       // _buildSettingsTile(
//                       //   imagePath: "assets/images/logout.png",
//                       //   title: l10n.logout,
//                       //   isRed: true,
//                       //   onTap: () => _showLogoutConfirmationDialog(),
//                       //   showDivider: false,
//                       // ),
//                     ],
//                   ),
//
//                 ),
//
//               ),
//             ],
//
//           ),
//
//         ),
//       ),
//
//     );
//   }
//
//   Widget _buildThemeSwitchTile() {
//     return Consumer<ThemeNotifier>(
//       builder: (context, themeProvider, child) {
//         final colors = Theme.of(context).colorScheme;
//         bool isDarkTheme = themeProvider.isDarkMode;
//
//         return Container(
//           height: 55.h,
//           margin: EdgeInsets.only(bottom: 10.h),
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             color:  colors.surface,
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Row(
//             children: [
//               Padding(
//                 padding:  EdgeInsets.symmetric(horizontal: 8.w),
//                 child: Image.asset(
//                   isDarkTheme
//                       ? 'assets/images/theme.png'
//                       : 'assets/images/theme.png',
//                   color: isDarkTheme ? AppColors.vibrantPurple: AppColors.vibrantPurple,
//                   height: 38.h,
//                   width: 38.w,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   AppLocalizations.of(context)!.themeTitle,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Sora',
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               FlutterSwitch(
//                 width: 85.w,
//                 height: 35.h,
//                 toggleSize: 27.h,
//                 valueFontSize: 16.sp,
//                 value: isDarkTheme,
//                 borderRadius: 25.r,
//                 padding: 3,
//                 activeText: AppLocalizations.of(context)!.darkTheme,
//                 inactiveText: AppLocalizations.of(context)!.lightTheme,
//                 activeTextColor: Colors.grey,
//                 inactiveTextColor: Colors.black,
//                 activeTextFontWeight: FontWeight.w500,
//                 inactiveTextFontWeight: FontWeight.w500,
//                 activeColor: AppColors.vibrantPurple,
//                 inactiveColor: Theme.of(context).disabledColor,
//                 showOnOff: true,
//                 onToggle: (val) => themeProvider.toggleTheme(val),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//   Future<void> _shareApp() async {
//     try {
//       if (!mounted) return;
//       final l10n = AppLocalizations.of(context)!;
//
//       // App info for Dog_Breed
//       const androidPackageId = 'com.example.dog_breed';
//       const iosAppId = '123456789'; // Replace with actual App Store ID
//       final shareMessage = l10n.shareMessageBody;
//       const playStoreUrl =
//           'https://play.google.com/store/apps/details?id=$androidPackageId';
//       final appStoreUrl = 'https://apps.apple.com/app/id$iosAppId';
//
//       // Determine platform
//       String shareUrl;
//       String shareText;
//
//       if (Platform.isIOS) {
//         shareUrl = appStoreUrl;
//         shareText = l10n.shareIOS;
//       } else if (Platform.isAndroid) {
//         shareUrl = playStoreUrl;
//         shareText = l10n.shareAndroid;
//       } else {
//         shareUrl = playStoreUrl;
//         shareText = l10n.shareDefault;
//       }
//
//       // Full share content
//       final shareContent = '''
// $shareText
//
// 🔍 $shareMessage
//
// 🔗 ${l10n.shareDownloadNow}$shareUrl
//
// #DogBreed #Dogs #Pets
// ''';
//
//       // Position for share sheet (optional)
//       final RenderBox? box = context.findRenderObject() as RenderBox?;
//       final Rect? sharePosition =
//       box != null ? box.localToGlobal(Offset.zero) & box.size : null;
//
//       // Show system share dialog
//       await Share.share(
//         shareContent,
//         subject: l10n.shareSubject,
//         sharePositionOrigin: sharePosition,
//       );
//     } on PlatformException catch (e) {
//       if (kDebugMode) {
//         print('Share PlatformException: ${e.message}');
//       }
//       if (mounted) {
//         _showErrorSnackBar(
//             AppLocalizations.of(context)!.errorShare(e.message ?? ''));
//         _showManualShareOptions();
//       }
//     } catch (e, stackTrace) {
//       if (kDebugMode) {
//         print('Error in _shareApp: $e\n$stackTrace');
//       }
//       if (mounted) {
//         _showCustomShareDialog();
//       }
//     }
//   }
//   // Custom share dialog with multiple options
//   void _showCustomShareDialog() {
//     final l10n = AppLocalizations.of(context)!;
//     final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//     final shareMessage = l10n.shareMessageBody;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(l10n.dialogShareTitle(l10n.aiAppName)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(l10n.chooseShare),
//               const SizedBox(height: 20),
//
//               // Quick actions
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   // Copy
//                   ActionChip(
//                     avatar: const Icon(Icons.copy, size: 18),
//                     label: Text(l10n.copy),
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       await _copyToClipboard();
//                     },
//                   ),
//
//                   // WhatsApp
//                   ActionChip(
//                     avatar: const Icon(Icons.chat, size: 18, color: Colors.green),
//                     label: Text(l10n.whatsapp),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _shareViaWhatsApp();
//                     },
//                   ),
//
//                   // More Options
//                   ActionChip(
//                     avatar: const Icon(Icons.more_horiz, size: 18),
//                     label: Text(l10n.more),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Try system share again
//                       _retrySystemShare();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(l10n.dialogCancel),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showManualShareOptions() {
//     final l10n = AppLocalizations.of(context)!;
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 l10n.shareApp,
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // Copy Link Option
//               ListTile(
//                 leading: Icon(Icons.link, color: Theme.of(context).primaryColor),
//                 title: Text(l10n.copyLink, style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 )),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _copyToClipboard();
//                 },
//               ),
//
//               // Share via WhatsApp
//               ListTile(
//                 leading: const Icon(Icons.chat, color: Colors.green),
//                 title: Text(l10n.shareWhatsApp, style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 )),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _shareViaWhatsApp();
//                 },
//               ),
//
//               // Share via Email
//               ListTile(
//                 leading: const Icon(Icons.email, color: Colors.red),
//                 title: Text(l10n.shareEmail, style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 )),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _shareViaEmail();
//                 },
//               ),
//
//               // Share via SMS
//               ListTile(
//                 leading: const Icon(Icons.sms, color: Colors.blue),
//                 title: Text(l10n.shareSMS, style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 )),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _shareViaSMS();
//                 },
//               ),
//
//               SizedBox(height: 10.h),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(l10n.dialogCancel, style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                 )),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   // Copy to clipboard fallback
//   Future<void> _copyToClipboard() async {
//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareMessage = l10n.shareMessageBody;
//       final shareContent = '$shareMessage\n\n$shareUrl';
//
//       await Clipboard.setData(ClipboardData(text: shareContent));
//
//       if (mounted) {
//         _showSuccessSnackBar(l10n.linkCopied);
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar(AppLocalizations.of(context)!.copyFailed);
//       }
//     }
//   }
//
//   // Share via WhatsApp
//   Future<void> _shareViaWhatsApp() async {
//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareMessage = l10n.shareMessageBody;
//       final whatsappUrl = Platform.isIOS
//           ? 'whatsapp://send?text=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}'
//           : 'https://wa.me/?text=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';
//
//       if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
//         await launchUrl(Uri.parse(whatsappUrl));
//       } else {
//         await _copyToClipboard();
//       }
//     } catch (e) {
//       await _copyToClipboard();
//     }
//   }
//
//   // Share via Email
//   Future<void> _shareViaEmail() async {
//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareMessage = l10n.shareMessageBody;
//       final emailUrl = 'mailto:?subject=${l10n.aiAppName}&body=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';
//
//       if (await canLaunchUrl(Uri.parse(emailUrl))) {
//         await launchUrl(Uri.parse(emailUrl));
//       } else {
//         await _copyToClipboard();
//       }
//     } catch (e) {
//       await _copyToClipboard();
//     }
//   }
//
//   // Share via SMS
//   Future<void> _shareViaSMS() async {
//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareMessage = l10n.shareMessageBody;
//       final smsUrl = 'sms:?body=${Uri.encodeComponent('$shareMessage\n\n$shareUrl')}';
//
//       if (await canLaunchUrl(Uri.parse(smsUrl))) {
//         await launchUrl(Uri.parse(smsUrl));
//       } else {
//         await _copyToClipboard();
//       }
//     } catch (e) {
//       await _copyToClipboard();
//     }
//   }
//
//   // Retry system share
//   Future<void> _retrySystemShare() async {
//     try {
//       final l10n = AppLocalizations.of(context)!;
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareMessage = l10n.shareMessageBody;
//       final shareContent = '$shareMessage\n\n$shareUrl';
//
//       await Share.share(
//         shareContent,
//         subject: l10n.shareSubject,
//       );
//     } catch (e) {
//       await _copyToClipboard();
//     }
//   }
//   Widget _buildSettingsTile({
//     IconData? icon,
//     String? imagePath,
//     required String title,
//     required VoidCallback onTap,
//     bool isRed = false,
//     bool showDivider = true,
//   }) {
//     return SingleChildScrollView(
//       child:  Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
//               leading: imagePath != null
//                   ? Image.asset(
//                 imagePath,
//                 width: 33.w,
//                 height: 33.h,
//                 color: isRed ? Theme.of(context).colorScheme.error : AppColors.vibrantPurple,
//               )
//                   : Icon(
//                 icon,
//                 size: 33.sp,
//                 color: isRed ? Theme.of(context).colorScheme.error : AppColors.vibrantPurple,
//               ),
//               title: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               onTap: onTap,
//               minVerticalPadding: 8.h,
//               dense: true,
//             ),
//           ),
//           if (showDivider)
//             Divider(
//               color: Theme.of(context).colorScheme.onPrimary,
//               height: 0,
//               thickness: 1,
//               indent: 0.w,
//             ),
//         ],
//       ),
//     );
//   }
//
//
//
// // ⭐⭐⭐⭐⭐ RATE US DIALOG (4 stars → feedback, 5 stars → store)
//   void _showRateUsDialog(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Theme.of(context).colorScheme.background,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               contentPadding: const EdgeInsets.all(24),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     l10n.enjoyingApp,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(l10n.tapToRate),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedStars = index + 1;
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 2),
//                           child: Icon(
//                             index < _selectedStars
//                                 ? Icons.star
//                                 : Icons.star_border,
//                             size: 40,
//                             color: index < _selectedStars
//                                 ? const Color(0xFFF6B03F)
//                                 : Theme.of(context).disabledColor,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _selectedStars > 0
//                         ? () {
//                       _saveRating(_selectedStars);
//
//                       if (_selectedStars == 5) {
//                         setState(() {
//                           _hasRated = true;
//                         });
//                         Future.delayed(
//                             const Duration(milliseconds: 300), () {
//                           Navigator.pop(context);
//                           _launchStoreRating();
//                         });
//                       } else {
//                         Navigator.pop(context);
//                         Navigator.pushNamed(context, RoutesName.feedback);
//                       }
//                     }
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedStars > 0
//                           ? const Color(0xFFF6B03F)
//                           : Theme.of(context).disabledColor,
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       _selectedStars > 0 ? l10n.rateUsAction : l10n.selectStars,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   // Method to save rating locally
//   void _saveRating(int stars) {
//     if (kDebugMode) {
//       print('User rated: $stars stars');
//     }
//   }
//
//   Future<void> _launchStoreRating() async {
//     try {
//       String url;
//
//       // Check platform and create appropriate store URL
//       if (Platform.isAndroid) {
//         url = 'market://details?id=$_androidPackageName';
//       } else if (Platform.isIOS) {
//         url = 'itms-apps://itunes.apple.com/app/id$_iosAppId';
//       } else {
//         // Fallback for other platforms
//         url = _playStoreUrl;
//       }
//
//       // Try to launch the deep link
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(
//           Uri.parse(url),
//           mode: LaunchMode.externalApplication,
//         );
//       } else {
//         // If deep link fails, try the web URL
//         final webUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//
//         if (await canLaunchUrl(Uri.parse(webUrl))) {
//           await launchUrl(
//             Uri.parse(webUrl),
//             mode: LaunchMode.externalApplication,
//           );
//         } else {
//           // Show error message if nothing works
//           if (context.mounted) {
//             _showErrorSnackBar(AppLocalizations.of(context)!.errorAppStore);
//           }
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error launching store: $e');
//       }
//       if (context.mounted) {
//         _showErrorSnackBar(AppLocalizations.of(context)!.errorOpenStore);
//       }
//     }
//   }
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(context).colorScheme.error,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
//   void _showDeleteConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.topCenter,
//           children: [
//             Container(
//               height: 400.h,
//               margin: EdgeInsets.only(top: 60.h),
//               padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 24.h),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 80.h),
//                   Text(
//                     l10n.deleteProfileWarning,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//                   SizedBox(height: 32.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           height: 48.h,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).disabledColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24.r),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               l10n.dialogCancel,
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       Expanded(
//                         child: SizedBox(
//                           height: 48.h,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // TODO: Add delete logic
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).colorScheme.error,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24.r),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               l10n.dialogDelete,
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 0,
//               child: Image.asset('assets/images/image104.png', height: 230.h),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showLogoutConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: Theme.of(context).cardColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: Center(
//           child: Text(
//             l10n.dialogLogoutTitle,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ),
//
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Row(
//               children: [
//                 // Cancel Button
//                 Expanded(
//                   child: SizedBox(
//                     height: 48.h,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.error,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         l10n.no,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//
//                 // Delete Button
//                 Expanded(
//                   child: SizedBox(
//                     height: 48.h,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, RoutesName.login);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.surface,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         l10n.yes,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:provider/provider.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import '../../View_model/ThemeNotifier.dart';
// // import '../../config/components/FAQView.dart';
// // import '../../utils/routes/routes_name.dart';
// //
// // class Profileview extends StatefulWidget {
// //   final void Function(String message)? onShowSnackBar;
// //
// //   const Profileview({super.key, this.onShowSnackBar});
// //
// //   @override
// //   State<Profileview> createState() => _ProfileviewState();
// // }
// //
// // class _ProfileviewState extends State<Profileview> {
// //   int _selectedStars = 0;
// //   bool _hasRated = false;
// //
// //   static const String _androidPackageName = 'com.nabatiah.carepaw.aidogscanner';
// //   static const String _iosAppId = '123456789';
// //   static const String _appName = 'AI Dog Breed';
// //   static const String _shareMessage = 'Check out AI Dog Breed - an amazing app for detecting Dog Breeds!';
// //   static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidPackageName';
// //   static const String _appStoreUrl = 'https://apps.apple.com/app/id$_iosAppId';
// //   @override
// //   Widget build(BuildContext context) {
// //     final l10n = AppLocalizations.of(context)!;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SingleChildScrollView(
// //         child: SafeArea(
// //           child: Column(
// //             children: [
// //               // Header
// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 13.h),
// //                 child: Center(
// //                   child: Text(
// //                     l10n.settingsTitle,
// //                     style: TextStyle(
// //                       color: Colors.black,
// //                       fontSize: 30.sp,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric( horizontal: 15),
// //                 child: Container(
// //                   height: 850.h,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF686868).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(18.r),
// //                   ),
// //                   child: ListView(
// //                     children: [
// //                       _buildSettingsTile(
// //                         icon: Icons.person_outline,
// //                         title: l10n.editProfile,
// //                         onTap: () =>
// //                             Navigator.pushNamed(context, RoutesName.editProfile),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/save.png",
// //                         title: "Recent Scan",
// //                         onTap: () =>
// //                             Navigator.pushNamed(context, RoutesName.listsave),
// //                       ),
// //
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/change.png",
// //                         title: "My Favourites",
// //                         onTap: () => Navigator.pushNamed(
// //                           context,
// //                           RoutesName.favourites,
// //                         ),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/change.png",
// //                         title: " Feedback",
// //                         onTap: () => Navigator.pushNamed(
// //                           context,
// //                           RoutesName.feedback,
// //                         ),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/change.png",
// //                         title: " Share",
// //                         onTap: () async {
// //                           await _shareApp();
// //                         },
// //                       ),_buildSettingsTile(
// //                         imagePath: "assets/images/change.png",
// //                         title: " Feedback",
// //                         onTap: () => Navigator.pushNamed(
// //                           context,
// //                           RoutesName.feedback,
// //                         ),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/change.png",
// //                         title: "Rate us",
// //                         onTap: () {
// //                           _showRateUsDialog(context);
// //                         },
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/notafication.png",
// //                         title: l10n.notifications,
// //                         onTap: () =>
// //                             Navigator.pushNamed(context, RoutesName.notification),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/notafication.png",
// //                         title: "History",
// //                         onTap: () =>
// //                             Navigator.pushNamed(context, RoutesName.history),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/language.png",
// //                         title: l10n.appLanguageTitle,
// //                         onTap: () =>
// //                             Navigator.pushNamed(context, RoutesName.appLanguage),
// //                       ),
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/premium.png",
// //                         title: l10n.premiumSubscription,
// //                         onTap: () => Navigator.pushNamed(context, RoutesName.pro),
// //                       ),
// //
// //                       _buildSettingsTile(
// //                         imagePath: "assets/images/faq.png",
// //                         title: l10n.faq,
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const FAQView(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       _buildSettingsTile(
// //                         icon: Icons.description_outlined,
// //                         title: l10n.termsOfUse,
// //                         showDivider: false,
// //                         onTap: () async {
// //                           final Uri url = Uri.parse('https://nabatiah.com/privacy-policy/');
// //                           if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
// //                             throw Exception('Could not launch $url');
// //                           }
// //                         },
// //                       ),
// //                       _buildThemeSwitchTile(),
// //                       // _buildSettingsTile(
// //                       //   imagePath: "assets/images/delete.png",
// //                       //   title: l10n.deleteOwnerProfile,
// //                       //   isRed: true,
// //                       //   onTap: () => _showDeleteConfirmationDialog(),
// //                       // ),
// //                       // _buildSettingsTile(
// //                       //   imagePath: "assets/images/logout.png",
// //                       //   title: l10n.logout,
// //                       //   isRed: true,
// //                       //   onTap: () => _showLogoutConfirmationDialog(),
// //                       //   showDivider: false,
// //                       // ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildThemeSwitchTile() {
// //     return Consumer<ThemeNotifier>(
// //       builder: (context, themeProvider, child) {
// //         final colors = Theme.of(context).colorScheme;
// //         bool isDarkTheme = themeProvider.isDarkMode;
// //
// //         return Container(
// //           height: 55.h,
// //           margin: EdgeInsets.only(bottom: 10.h),
// //           padding: EdgeInsets.symmetric(horizontal: 12.w),
// //           decoration: BoxDecoration(
// //             color:  colors.secondaryContainer,
// //             borderRadius: BorderRadius.circular(12.r),
// //           ),
// //           child: Row(
// //             children: [
// //               Container(
// //                 height: 44.h,
// //                 width: 44.w,
// //                 padding: EdgeInsets.all(6.r),
// //                 decoration: BoxDecoration(
// //                   color: Theme.of(context).colorScheme.background,
// //                   borderRadius: BorderRadius.circular(12.r),
// //                   border: Border.all(color: Colors.transparent, width: 2.w),
// //                 ),
// //                 child: Icon(
// //                   isDarkTheme ? Icons.dark_mode : Icons.light_mode,
// //                   color: isDarkTheme ? Colors.blueAccent : Colors.orange,
// //                   size: 24.sp,
// //                 ),
// //               ),
// //               SizedBox(width: 12.w),
// //               Expanded(
// //                 child: Text(
// //                   'Theme',
// //                   style: TextStyle(
// //                     color: Theme.of(context).colorScheme.onSurface,
// //                     fontSize: 15.sp,
// //                     fontWeight: FontWeight.w500,
// //                     fontFamily: 'Sora',
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(width: 8.w),
// //               FlutterSwitch(
// //                 width: 85.w,
// //                 height: 35.h,
// //                 toggleSize: 27.h,
// //                 valueFontSize: 16.sp,
// //                 value: isDarkTheme,
// //                 borderRadius: 25.r,
// //                 padding: 3,
// //                 activeText: "Dark",
// //                 inactiveText: "Light",
// //                 activeTextColor: Colors.white,
// //                 inactiveTextColor: Colors.black,
// //                 activeTextFontWeight: FontWeight.w500,
// //                 inactiveTextFontWeight: FontWeight.w500,
// //                 activeColor: Theme.of(context).colorScheme.primary,
// //                 inactiveColor: Colors.grey.shade300,
// //                 showOnOff: true,
// //                 onToggle: (val) => themeProvider.toggleTheme(val),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //
// //   Future<void> _shareApp() async {
// //     try {
// //       if (!mounted) return;
// //
// //       // App info for Dog_Breed
// //       const appName = 'Dog_Breed';
// //       const androidPackageId = 'com.example.dog_breed';
// //       const iosAppId = '123456789'; // Replace with actual App Store ID
// //       const shareMessage = 'Check out Dog_Breed - an amazing app for dog lovers!';
// //       const playStoreUrl =
// //           'https://play.google.com/store/apps/details?id=$androidPackageId';
// //       final appStoreUrl = 'https://apps.apple.com/app/id$iosAppId';
// //
// //       // Determine platform
// //       String shareUrl;
// //       String shareText;
// //
// //       if (Platform.isIOS) {
// //         shareUrl = appStoreUrl;
// //         shareText = '📱 Discover $appName on the App Store!';
// //       } else if (Platform.isAndroid) {
// //         shareUrl = playStoreUrl;
// //         shareText = '📱 Get $appName on Google Play!';
// //       } else {
// //         shareUrl = playStoreUrl;
// //         shareText = '📱 Check out $appName!';
// //       }
// //
// //       // Full share content
// //       final shareContent = '''
// // $shareText
// //
// // 🔍 $shareMessage
// //
// // 🔗 Download now: $shareUrl
// //
// // #DogBreed #Dogs #Pets
// // ''';
// //
// //       // Position for share sheet (optional)
// //       final RenderBox? box = context.findRenderObject() as RenderBox?;
// //       final Rect? sharePosition =
// //       box != null ? box.localToGlobal(Offset.zero) & box.size : null;
// //
// //       // Show system share dialog
// //       await Share.share(
// //         shareContent,
// //         subject: '$appName - Dog Breed App',
// //         sharePositionOrigin: sharePosition,
// //       );
// //     } on PlatformException catch (e) {
// //       if (kDebugMode) {
// //         print('Share PlatformException: ${e.message}');
// //       }
// //       if (mounted) {
// //         _showErrorSnackBar(
// //             'Unable to open share options. Error: ${e.message}');
// //         _showManualShareOptions();
// //       }
// //     } catch (e, stackTrace) {
// //       if (kDebugMode) {
// //         print('Error in _shareApp: $e\n$stackTrace');
// //       }
// //       if (mounted) {
// //         _showCustomShareDialog();
// //       }
// //     }
// //   }
// //   // Custom share dialog with multiple options
// //   void _showCustomShareDialog() {
// //     final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //     final _ = '$_shareMessage\n\n$shareUrl';
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text('Share $_appName'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const Text('Choose how you want to share:'),
// //               const SizedBox(height: 20),
// //
// //               // Quick actions
// //               Wrap(
// //                 spacing: 10,
// //                 runSpacing: 10,
// //                 children: [
// //                   // Copy
// //                   ActionChip(
// //                     avatar: const Icon(Icons.copy, size: 18),
// //                     label: const Text('Copy'),
// //                     onPressed: () async {
// //                       Navigator.pop(context);
// //                       await _copyToClipboard();
// //                     },
// //                   ),
// //
// //                   // WhatsApp
// //                   ActionChip(
// //                     avatar: const Icon(Icons.chat, size: 18, color: Colors.green),
// //                     label: const Text('WhatsApp'),
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                       _shareViaWhatsApp();
// //                     },
// //                   ),
// //
// //                   // More Options
// //                   ActionChip(
// //                     avatar: const Icon(Icons.more_horiz, size: 18),
// //                     label: const Text('More'),
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                       // Try system share again
// //                       _retrySystemShare();
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('Cancel'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _showManualShareOptions() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) {
// //         return Container(
// //           decoration: BoxDecoration(
// //             color: Theme.of(context).scaffoldBackgroundColor,
// //             borderRadius: const BorderRadius.only(
// //               topLeft: Radius.circular(20),
// //               topRight: Radius.circular(20),
// //             ),
// //           ),
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 'Share App',
// //                 style: TextStyle(
// //                   fontSize: 20.sp,
// //                   fontWeight: FontWeight.bold,
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //               ),
// //               SizedBox(height: 20.h),
// //
// //               // Copy Link Option
// //               ListTile(
// //                 leading: Icon(Icons.link, color: Theme.of(context).primaryColor),
// //                 title: Text('Copy Link', style: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 )),
// //                 onTap: () async {
// //                   Navigator.pop(context);
// //                   await _copyToClipboard();
// //                 },
// //               ),
// //
// //               // Share via WhatsApp
// //               ListTile(
// //                 leading: const Icon(Icons.chat, color: Colors.green),
// //                 title: Text('Share via WhatsApp', style: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 )),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _shareViaWhatsApp();
// //                 },
// //               ),
// //
// //               // Share via Email
// //               ListTile(
// //                 leading: const Icon(Icons.email, color: Colors.red),
// //                 title: Text('Share via Email', style: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 )),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _shareViaEmail();
// //                 },
// //               ),
// //
// //               // Share via SMS
// //               ListTile(
// //                 leading: const Icon(Icons.sms, color: Colors.blue),
// //                 title: Text('Share via SMS', style: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 )),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _shareViaSMS();
// //                 },
// //               ),
// //
// //               SizedBox(height: 10.h),
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: Text('Cancel', style: TextStyle(
// //                   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
// //                 )),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //   // Copy to clipboard fallback
// //   Future<void> _copyToClipboard() async {
// //     try {
// //       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //       final shareContent = '$_shareMessage\n\n$shareUrl';
// //
// //       await Clipboard.setData(ClipboardData(text: shareContent));
// //
// //       if (mounted) {
// //         _showSuccessSnackBar('Link copied to clipboard! You can now paste and share it.');
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         _showErrorSnackBar('Failed to copy to clipboard.');
// //       }
// //     }
// //   }
// //
// //   // Share via WhatsApp
// //   Future<void> _shareViaWhatsApp() async {
// //     try {
// //       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //       final whatsappUrl = Platform.isIOS
// //           ? 'whatsapp://send?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}'
// //           : 'https://wa.me/?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
// //
// //       if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
// //         await launchUrl(Uri.parse(whatsappUrl));
// //       } else {
// //         await _copyToClipboard();
// //       }
// //     } catch (e) {
// //       await _copyToClipboard();
// //     }
// //   }
// //
// //   // Share via Email
// //   Future<void> _shareViaEmail() async {
// //     try {
// //       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //       final emailUrl = 'mailto:?subject=$_appName&body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
// //
// //       if (await canLaunchUrl(Uri.parse(emailUrl))) {
// //         await launchUrl(Uri.parse(emailUrl));
// //       } else {
// //         await _copyToClipboard();
// //       }
// //     } catch (e) {
// //       await _copyToClipboard();
// //     }
// //   }
// //
// //   // Share via SMS
// //   Future<void> _shareViaSMS() async {
// //     try {
// //       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //       final smsUrl = 'sms:?body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
// //
// //       if (await canLaunchUrl(Uri.parse(smsUrl))) {
// //         await launchUrl(Uri.parse(smsUrl));
// //       } else {
// //         await _copyToClipboard();
// //       }
// //     } catch (e) {
// //       await _copyToClipboard();
// //     }
// //   }
// //
// //   // Retry system share
// //   Future<void> _retrySystemShare() async {
// //     try {
// //       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //       final shareContent = '$_shareMessage\n\n$shareUrl';
// //
// //       await Share.share(
// //         shareContent,
// //         subject: '$_appName - Hidden Camera Detection App',
// //       );
// //     } catch (e) {
// //       await _copyToClipboard();
// //     }
// //   }
// //   Widget _buildSettingsTile({
// //     IconData? icon,
// //     String? imagePath,
// //     required String title,
// //     required VoidCallback onTap,
// //     bool isRed = false,
// //     bool showDivider = true,
// //   }) {
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 20.w),
// //           child: ListTile(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
// //             leading: imagePath != null
// //                 ? Image.asset(
// //                     imagePath,
// //                     width: 33.w,
// //                     height: 33.h,
// //                     color: isRed ? Colors.red : AppColors.vibrantPurple,
// //                   )
// //                 : Icon(
// //                     icon,
// //                     size: 33.sp,
// //                     color: isRed ? Colors.red : AppColors.vibrantPurple,
// //                   ),
// //             title: Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 18.sp,
// //                 fontWeight: FontWeight.bold,
// //                 color: const Color(0xFF371B34),
// //               ),
// //             ),
// //             onTap: onTap,
// //             minVerticalPadding: 8.h,
// //             dense: true,
// //           ),
// //         ),
// //         if (showDivider)
// //           Divider(
// //             color: const Color(0xFFE4E4E4),
// //             height: 0,
// //             thickness: 1,
// //             indent: 0.w,
// //           ),
// //       ],
// //     );
// //   }
// //
// //
// //
// // // ⭐⭐⭐⭐⭐ RATE US DIALOG (4 stars → feedback, 5 stars → store)
// //   void _showRateUsDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (context, setState) {
// //             return AlertDialog(
// //               backgroundColor: Theme.of(context).colorScheme.background,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               contentPadding: const EdgeInsets.all(24),
// //               content: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text(
// //                     'Enjoying the app?',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                       color: Theme.of(context).colorScheme.onSurface,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   const Text('Tap to rate:'),
// //                   const SizedBox(height: 12),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: List.generate(5, (index) {
// //                       return GestureDetector(
// //                         onTap: () {
// //                           setState(() {
// //                             _selectedStars = index + 1;
// //                           });
// //                         },
// //                         child: Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 2),
// //                           child: Icon(
// //                             index < _selectedStars
// //                                 ? Icons.star
// //                                 : Icons.star_border,
// //                             size: 40,
// //                             color: index < _selectedStars
// //                                 ? const Color(0xFFF6B03F)
// //                                 : Colors.grey[300],
// //                           ),
// //                         ),
// //                       );
// //                     }),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: _selectedStars > 0
// //                         ? () {
// //                       _saveRating(_selectedStars);
// //
// //                       if (_selectedStars == 5) {
// //                         setState(() {
// //                           _hasRated = true;
// //                         });
// //                         Future.delayed(
// //                             const Duration(milliseconds: 300), () {
// //                           Navigator.pop(context);
// //                           _launchStoreRating();
// //                         });
// //                       } else {
// //                         Navigator.pop(context);
// //                         Navigator.pushNamed(context, RoutesName.feedback);
// //                       }
// //                     }
// //                         : null,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: _selectedStars > 0
// //                           ? const Color(0xFFF6B03F)
// //                           : Colors.grey[300],
// //                       foregroundColor: Colors.white,
// //                       minimumSize: const Size(double.infinity, 50),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 0,
// //                     ),
// //                     child: Text(
// //                       _selectedStars > 0 ? 'Rate Us' : 'Select Stars',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //   // Method to save rating locally
// //   void _saveRating(int stars) {
// //     if (kDebugMode) {
// //       print('User rated: $stars stars');
// //     }
// //   }
// //
// //   Future<void> _launchStoreRating() async {
// //     try {
// //       String url;
// //
// //       // Check platform and create appropriate store URL
// //       if (Platform.isAndroid) {
// //         url = 'market://details?id=$_androidPackageName';
// //       } else if (Platform.isIOS) {
// //         url = 'itms-apps://itunes.apple.com/app/id$_iosAppId';
// //       } else {
// //         // Fallback for other platforms
// //         url = _playStoreUrl;
// //       }
// //
// //       // Try to launch the deep link
// //       if (await canLaunchUrl(Uri.parse(url))) {
// //         await launchUrl(
// //           Uri.parse(url),
// //           mode: LaunchMode.externalApplication,
// //         );
// //       } else {
// //         // If deep link fails, try the web URL
// //         final webUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
// //
// //         if (await canLaunchUrl(Uri.parse(webUrl))) {
// //           await launchUrl(
// //             Uri.parse(webUrl),
// //             mode: LaunchMode.externalApplication,
// //           );
// //         } else {
// //           // Show error message if nothing works
// //           if (context.mounted) {
// //             _showErrorSnackBar('Could not open app store. Please try again later.');
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print('Error launching store: $e');
// //       }
// //       if (context.mounted) {
// //         _showErrorSnackBar('Error opening app store.');
// //       }
// //     }
// //   }
// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.red,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showSuccessSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.green,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     );
// //   }
// //   void _showDeleteConfirmationDialog() {
// //     final l10n = AppLocalizations.of(context)!;
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => Dialog(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
// //         child: Stack(
// //           clipBehavior: Clip.none,
// //           alignment: Alignment.topCenter,
// //           children: [
// //             Container(
// //               height: 400.h,
// //               margin: EdgeInsets.only(top: 60.h),
// //               padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 24.h),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20.r),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   SizedBox(height: 80.h),
// //                   Text(
// //                     l10n.deleteProfileWarning,
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       color: const Color(0xFF877084),
// //                     ),
// //                   ),
// //                   SizedBox(height: 32.h),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: SizedBox(
// //                           height: 48.h,
// //                           child: ElevatedButton(
// //                             onPressed: () {
// //                               Navigator.pop(context);
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: const Color(0xFFC8C8C8),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(24.r),
// //                               ),
// //                               elevation: 0,
// //                             ),
// //                             child: Text(
// //                               l10n.dialogCancel,
// //                               style: TextStyle(
// //                                 fontSize: 16.sp,
// //                                 fontWeight: FontWeight.w600,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 16.w),
// //                       Expanded(
// //                         child: SizedBox(
// //                           height: 48.h,
// //                           child: ElevatedButton(
// //                             onPressed: () {
// //                               // TODO: Add delete logic
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: const Color(0xFFDB5959),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(24.r),
// //                               ),
// //                               elevation: 0,
// //                             ),
// //                             child: Text(
// //                               l10n.dialogDelete,
// //                               style: TextStyle(
// //                                 fontSize: 16.sp,
// //                                 fontWeight: FontWeight.w600,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Positioned(
// //               top: 0,
// //               child: Image.asset('assets/images/image104.png', height: 230.h),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showLogoutConfirmationDialog() {
// //     final l10n = AppLocalizations.of(context)!;
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: Colors.white,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16.r),
// //         ),
// //         title: Center(
// //           child: Text(
// //             l10n.dialogLogoutTitle,
// //             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
// //           ),
// //         ),
// //
// //         actions: [
// //           Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 24.w),
// //             child: Row(
// //               children: [
// //                 // Cancel Button
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 48.h,
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.pop(context);
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFDB5959),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(24.r),
// //                         ),
// //                         elevation: 0,
// //                       ),
// //                       child: Text(
// //                         l10n.no,
// //                         style: TextStyle(
// //                           fontSize: 16.sp,
// //                           fontWeight: FontWeight.w600,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 16.w),
// //
// //                 // Delete Button
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 48.h,
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.pushNamed(context, RoutesName.login);
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF05E584),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(24.r),
// //                         ),
// //                         elevation: 0,
// //                       ),
// //                       child: Text(
// //                         l10n.yes,
// //                         style: TextStyle(
// //                           fontSize: 16.sp,
// //                           fontWeight: FontWeight.w600,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
