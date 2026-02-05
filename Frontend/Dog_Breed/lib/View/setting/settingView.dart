  // import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For Clipboard
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../View_model/ThemeNotifier.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Settingview extends StatefulWidget {
//   const Settingview({super.key});
//
//   @override
//   State<Settingview> createState() => _SettingviewState();
// }
//
// class _SettingviewState extends State<Settingview> {
//   int _selectedStars = 0;
//   bool _hasRated = false;
//
//   static const String _androidPackageName = 'com.example.hiddencamerafinder';
//   static const String _iosAppId = '123456789';
//   static const String _appName = 'Hidden Camera Finder';
//   static const String _shareMessage = 'Check out Hidden Camera Finder - an amazing app for detecting hidden cameras!';
//   static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_androidPackageName';
//   static const String _appStoreUrl = 'https://apps.apple.com/app/id$_iosAppId';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 19.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               SizedBox(height: 20.h),
//               Transform.translate(offset: Offset(0, -30.h),
//               child: _buildSettingsSection()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildHeader() {
//     final colors = Theme.of(context).colorScheme;
//     return SizedBox(
//       height: 90.h,
//       child: Stack(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Settings',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 30.sp,
//                   height: 1.0,
//                   letterSpacing: 0.0,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//
//           Positioned(
//             bottom: 5,
//             right: 10,
//             child: SizedBox(
//               height: 78.h,
//               width: 80.w,
//               child: Center(
//                 child: Transform.rotate(
//                   angle: -81.51,
//                   child: SvgPicture.asset(
//                     "assets/images/Group099.svg",
//                     width: 92.w,
//                     height: 92.h,
//                     color: colors.surfaceContainerLow,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildHeader() {
//   //   return Stack(
//   //     children: [
//   //       Row(
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           Text(
//   //             'Settings',
//   //             style: TextStyle(
//   //               fontFamily: 'Sora',
//   //               fontWeight: FontWeight.w400,
//   //               fontStyle: FontStyle.normal,
//   //               fontSize: 30.sp,
//   //               height: 1.0,
//   //               letterSpacing: 0.0,
//   //               color: Theme.of(context).colorScheme.onSurface,
//   //             ),
//   //           ),
//   //           SizedBox(width: 188.w),
//   //           SizedBox(
//   //             height: 92.h,
//   //             width: 92.w,
//   //             child: Center(
//   //               child: Transform.rotate(
//   //                 angle: -81.51,
//   //                 child: SvgPicture.asset(
//   //                   "assets/images/Group099.svg",
//   //                   width: 102.w,
//   //                   height: 102.h,
//   //                   color: const Color(0xFF353635),
//   //                   fit: BoxFit.contain,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),          ],
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget _buildSettingsSection() {
//     return Column(
//       children: [
//         _buildSettingOptionTile(
//           iconPath: 'assets/images/ff.svg',
//           title: 'My Favorites',
//           onTap: () => Navigator.pushNamed(context, RoutesName.myFavourites),
//           iconBackgroundColor: const Color(0xFFFEF2F2),
//           iconColor: const Color(0xFFDD2E44),
//         ),
//
//         _buildSettingOptionTile(
//           iconPath: 'assets/images/fd.svg',
//           title: 'Feedback',
//           onTap: () {
//             Navigator.pushNamed(context, RoutesName.feedback);
//           },
//           iconBackgroundColor: const Color(0xFFF0F9FF),
//           iconColor: const Color(0xFF00D9FF),
//         ),
//
//         _buildSettingOptionTile(
//           iconPath: 'assets/images/rs.svg',
//           title: 'Rate us',
//           onTap: () {
//             _showRateUsDialog(context);
//           },
//           iconBackgroundColor: const Color(0xFFFFF7ED),
//           iconColor: const Color(0xFFF6B03F),
//         ),
//
//         _buildSettingOptionTile(
//           iconPath: 'assets/images/sh.svg',
//           title: 'Share',
//           onTap: () async {
//             await _shareApp();
//           },
//           iconBackgroundColor: const Color(0xFFF0FDF4),
//           iconColor: const Color(0xFF0B75FF),
//         ),
//
//         _buildSettingOptionTile(
//           iconPath: 'assets/images/mp.svg',
//           title: 'My Premium Service',
//           onTap: () => Navigator.pushNamed(context, RoutesName.premium),
//           iconBackgroundColor: const Color(0xFFFAF5FF),
//           iconColor: const Color(0xFFF69104),
//         ),
//
//         _buildSettingsTile(
//           icon: Icons.description_outlined,
//           title: AppLocalizations.of(context)!.termsOfUse,
//           onTap: () {
//             final Uri url = Uri.parse('https://nabatiah.com/privacy-policy/');
//             launchUrl(url);
//           },
//         ),
//
//         _buildThemeSwitchTile(),
//       ],
//     );
//   }
//
//   Widget _buildThemeSwitchTile() {
//     return Consumer<ThemeNotifier>(
//       builder: (context, themeProvider, child) {
//         final colors = Theme.of(context).colorScheme;
//
//         return Container(
//           height: 55.h,
//           margin: EdgeInsets.only(bottom: 10.h),
//           padding: EdgeInsets.symmetric(horizontal: 12.w),
//           decoration: BoxDecoration(
//             color:  colors.secondaryContainer,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: colors.surface.withOpacity(0.05),
//                 blurRadius: 8.r,
//                 offset: Offset(0, 2.h),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8.r),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.background,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: SvgPicture.asset(
//                   'assets/images/tm.svg',
//                   color: const Color(0xFFF8C600),
//                   width: 24.w,
//                   height: 24.h,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   'Theme',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Sora',
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Switch(
//                 value: themeProvider.isDarkMode,
//                 onChanged: (val) {
//                   themeProvider.toggleTheme(val);
//                 },
//                 activeColor: const Color(0xFFCBD8CB),
//                 activeTrackColor: const Color(0xFFFFFFFF),
//                 inactiveTrackColor: const Color(0xFFFFFFFF),
//               ),
//               SizedBox(width: 4.w),
//               Text(
//                 themeProvider.isDarkMode ? 'Dark' : 'Light',
//                 style: TextStyle(
//                   color: Theme.of(
//                     context,
//                   ).colorScheme.onSurface.withOpacity(0.7),
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSettingOptionTile({
//     required String iconPath,
//     required String title,
//     required VoidCallback onTap,
//     Color borderColor = Colors.transparent,
//     Color? iconColor,
//     required Color iconBackgroundColor,
//   }) {
//     final colors = Theme.of(context).colorScheme;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         height: 55.h,
//         margin: EdgeInsets.only(bottom: 10.h),
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         decoration: BoxDecoration(
//           color:  colors.secondaryContainer,
//           borderRadius: BorderRadius.circular(12.r),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: colors.surface,
//           //     blurRadius: 8.r,
//           //     offset: Offset(0, 2.h),
//           //   ),
//           // ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               height: 40.h,
//               width: 40.w,
//               padding: EdgeInsets.all(8.r),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.background,
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: borderColor, width: 2.w),
//               ),
//               child: SvgPicture.asset(
//                 iconPath,
//                 color: iconColor ?? Theme.of(context).colorScheme.primary,
//                 width: 24.w,
//                 height: 24.h,
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Soro',
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 18.w,
//               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // ⭐⭐⭐⭐⭐ RATE US DIALOG (4 stars → feedback, 5 stars → store)
//   void _showRateUsDialog(BuildContext context) {
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
//                     'Enjoying the app?',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text('Tap to rate:'),
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
//                                 : Colors.grey[300],
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
//                       // ✅ NEW LOGIC
//                       if (_selectedStars == 5) {
//                         setState(() {
//                           _hasRated = true;
//                         });
//                         Future.delayed(
//                             const Duration(milliseconds: 300), () {
//                           Navigator.pop(context);
//                           _launchStoreRating();
//                         });
//                       } else if (_selectedStars == 4) {
//                         Navigator.pop(context);
//                         Navigator.pushNamed(context, RoutesName.feedback);
//                       } else {
//                         Navigator.pop(context);
//                         _showFeedbackDialog(context);
//                       }
//                     }
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedStars > 0
//                           ? const Color(0xFFF6B03F)
//                           : Colors.grey[300],
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       _selectedStars > 0 ? 'Rate Us' : 'Select Stars',
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
//             _showErrorSnackBar('Could not open app store. Please try again later.');
//           }
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error launching store: $e');
//       }
//       if (context.mounted) {
//         _showErrorSnackBar('Error opening app store.');
//       }
//     }
//   }
//
//   Future<void> _shareApp() async {
//     try {
//       if (!mounted) return;
//
//       // App info for Dog_Breed
//       const appName = 'Dog_Breed';
//       const androidPackageId = 'com.example.dog_breed';
//       const iosAppId = '123456789'; // Replace with actual App Store ID
//       const shareMessage = 'Check out Dog_Breed - an amazing app for dog lovers!';
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
//         shareText = '📱 Discover $appName on the App Store!';
//       } else if (Platform.isAndroid) {
//         shareUrl = playStoreUrl;
//         shareText = '📱 Get $appName on Google Play!';
//       } else {
//         shareUrl = playStoreUrl;
//         shareText = '📱 Check out $appName!';
//       }
//
//       // Full share content
//       final shareContent = '''
// $shareText
//
// 🔍 $shareMessage
//
// 🔗 Download now: $shareUrl
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
//         subject: '$appName - Dog Breed App',
//         sharePositionOrigin: sharePosition,
//       );
//     } on PlatformException catch (e) {
//       if (kDebugMode) {
//         print('Share PlatformException: ${e.message}');
//       }
//       if (mounted) {
//         _showErrorSnackBar(
//             'Unable to open share options. Error: ${e.message}');
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
//
//   void _showManualShareOptions() {
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
//                 'Share App',
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
//                 title: Text('Copy Link', style: TextStyle(
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
//                 title: Text('Share via WhatsApp', style: TextStyle(
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
//                 title: Text('Share via Email', style: TextStyle(
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
//                 title: Text('Share via SMS', style: TextStyle(
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
//                 child: Text('Cancel', style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                 )),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Custom share dialog with multiple options
//   void _showCustomShareDialog() {
//     final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//     final _ = '$_shareMessage\n\n$shareUrl';
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Share $_appName'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Choose how you want to share:'),
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
//                     label: const Text('Copy'),
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       await _copyToClipboard();
//                     },
//                   ),
//
//                   // WhatsApp
//                   ActionChip(
//                     avatar: const Icon(Icons.chat, size: 18, color: Colors.green),
//                     label: const Text('WhatsApp'),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _shareViaWhatsApp();
//                     },
//                   ),
//
//                   // More Options
//                   ActionChip(
//                     avatar: const Icon(Icons.more_horiz, size: 18),
//                     label: const Text('More'),
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
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Copy to clipboard fallback
//   Future<void> _copyToClipboard() async {
//     try {
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareContent = '$_shareMessage\n\n$shareUrl';
//
//       await Clipboard.setData(ClipboardData(text: shareContent));
//
//       if (mounted) {
//         _showSuccessSnackBar('Link copied to clipboard! You can now paste and share it.');
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Failed to copy to clipboard.');
//       }
//     }
//   }
//
//   // Share via WhatsApp
//   Future<void> _shareViaWhatsApp() async {
//     try {
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final whatsappUrl = Platform.isIOS
//           ? 'whatsapp://send?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}'
//           : 'https://wa.me/?text=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
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
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final emailUrl = 'mailto:?subject=$_appName&body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
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
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final smsUrl = 'sms:?body=${Uri.encodeComponent('$_shareMessage\n\n$shareUrl')}';
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
//       final shareUrl = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
//       final shareContent = '$_shareMessage\n\n$shareUrl';
//
//       await Share.share(
//         shareContent,
//         subject: '$_appName - Hidden Camera Detection App',
//       );
//     } catch (e) {
//       await _copyToClipboard();
//     }
//   }
//
//   // Method to save rating locally
//   void _saveRating(int stars) {
//     if (kDebugMode) {
//       print('User rated: $stars stars');
//     }
//   }
//
//   // Method to show feedback dialog for low ratings
//   void _showFeedbackDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text('We\'re sorry to hear that'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'What can we do better? Your feedback helps us improve.',
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: 'Tell us what we can improve...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showSuccessSnackBar('Thank you for your feedback!');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFF6B03F),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Submit Feedback'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
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
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
//
