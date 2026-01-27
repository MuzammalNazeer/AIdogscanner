import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/components/FAQView.dart';
import '../../utils/routes/routes_name.dart';
import 'listSave.dart';

class Profileview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Profileview({super.key, this.onShowSnackBar});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  bool _isProfileDeleted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  l10n.settingsTitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                height: 610.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF686868).withOpacity(0.1),
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
                      title: l10n.savedActivities,
                      onTap: () =>
                          Navigator.pushNamed(context, RoutesName.listsave),
                    ),
                    _buildSettingsTile(
                      imagePath: "assets/images/change.png",
                      title: l10n.changePassword,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RoutesName.changePassword,
                      ),
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
                      onTap: () => Navigator.pushNamed(context, RoutesName.pro),
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
                      onTap: () async {
                        final Uri url = Uri.parse('https://nabatiah.com/privacy-policy/');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                    ),
                    _buildSettingsTile(
                      imagePath: "assets/images/delete.png",
                      title: l10n.deleteOwnerProfile,
                      isRed: true,
                      onTap: () => _showDeleteConfirmationDialog(),
                    ),
                    _buildSettingsTile(
                      imagePath: "assets/images/logout.png",
                      title: l10n.logout,
                      isRed: true,
                      onTap: () => _showLogoutConfirmationDialog(),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            leading: imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 33.w,
                    height: 33.h,
                    color: isRed ? Colors.red : AppColors.vibrantPurple,
                  )
                : Icon(
                    icon,
                    size: 33.sp,
                    color: isRed ? Colors.red : AppColors.vibrantPurple,
                  ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF371B34),
              ),
            ),
            onTap: onTap,
            minVerticalPadding: 8.h,
            dense: true,
          ),
        ),
        if (showDivider)
          Divider(
            color: const Color(0xFFE4E4E4),
            height: 0,
            thickness: 1,
            indent: 0.w,
          ),
      ],
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
                color: Colors.white,
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
                      color: const Color(0xFF877084),
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
                              backgroundColor: const Color(0xFFC8C8C8),
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
                              backgroundColor: const Color(0xFFDB5959),
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Center(
          child: Text(
            l10n.dialogLogoutTitle,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDB5959),
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

                // Delete Button
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF05E584),
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

// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';
// import '../../utils/routes/routes_name.dart';
//
// class Profileview extends StatefulWidget {
//   const Profileview({super.key});
//
//   @override
//   State<Profileview> createState() => _ProfileviewState();
// }
//
// class _ProfileviewState extends State<Profileview> {
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
//                 children: [
//                   Center(
//                     child: Text(
//                       l10n.settingsTitle,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 30.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h,),
//                   _buildSettingsTile(
//                     icon: Icons.person_outline,
//                     color: Colors.purple,
//                     title: l10n.editProfile,
//                     onTap: () => Navigator.pushNamed(context, RoutesName.editProfile),
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.lock_outline,
//                     color: Colors.purple,
//                     title: l10n.changePassword,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.notifications_outlined,
//                     color: Colors.purple,
//                     title: l10n.notifications,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.language,
//                     color: Colors.purple,
//                     title: l10n.appLanguageTitle,
//                     onTap: () => Navigator.pushNamed(context, RoutesName.appLanguage),
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.diamond_outlined,
//                     color: Colors.purple,
//                     title: l10n.premiumSubscription,
//                     onTap: () => Navigator.pushNamed(context, RoutesName.pro),
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.info_outline,
//                     color: Colors.blue,
//                     title: l10n.aboutUs,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.help_outline,
//                     color: Colors.blue,
//                     title: l10n.faq,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.description_outlined,
//                     color: Colors.blue,
//                     title: l10n.termsOfUse,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.pets,
//                     color: Colors.orange,
//                     title: l10n.supportAnimalIdProject,
//                     onTap: () {},
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.delete_outline,
//                     color: Colors.red,
//                     title: l10n.deleteOwnerProfile,
//                     onTap: () => _showDeleteConfirmationDialog(),
//                   ),
//                   _buildSettingsTile(
//                     icon: Icons.logout,
//                     color: Colors.red,
//                     title: l10n.logout,
//                     onTap: () => _showLogoutConfirmationDialog(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildSettingsTile({
//     required IconData icon,
//     required Color color,
//     required String title,
//     required VoidCallback onTap,
//     bool showBottomDivider = true,
//   }) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Color(0xFF686868).withOpacity(0.1),
//           ),
//           child: ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0),
//             leading: Icon(
//               icon,
//               color: AppColors.vibrantPurple,
//               size: 28.sp,
//             ),
//             title: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF371B34),
//               ),
//             ),
//             onTap: onTap,
//           ),
//         ),
//         if (showBottomDivider)
//           Divider(
//            color: Colors.grey.shade400,
//            height: 1.h,
//            thickness: 1.h,
//          )
//       ],
//     );
//   }
//   void _showDeleteConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: Text(
//           l10n.dialogDeleteProfileTitle,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Text(
//           l10n.dialogDeleteProfileMessage,
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: Colors.grey[700],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               l10n.dialogCancel,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Implement actual delete logic
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(l10n.deleteOwnerProfile + ' successful'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             child: Text(
//               l10n.dialogDelete,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showLogoutConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: Text(
//           l10n.dialogLogoutTitle,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Text(
//           l10n.dialogLogoutMessage,
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: Colors.grey[700],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               l10n.dialogCancel,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Clear session, go to login
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 RoutesName.login,
//                     (route) => false,
//               );
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             child: Text(
//               l10n.logout,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//               ),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:flutter_svg/flutter_svg.dart';
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
//   bool _isProfileDeleted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 20.h),
//               child: Center(
//                 child: Text(
//                   l10n.settingsTitle,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//               child: Container(
//                 height: 550.h,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF686868).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(18.r),
//                 ),
//                 child: ListView(
//                   children: [
//                       _buildSettingsTile(
//                         icon: Icons.person_outline,
//                         title: l10n.editProfile,
//                         onTap: () => Navigator.pushNamed(context, RoutesName.editProfile),
//                       ),
//                     _buildSettingsTile(
//                       icon: Icons.lock_outline,
//                       title: l10n.changePassword,
//                       onTap: () => Navigator.pushNamed(context, RoutesName.changePassword),
//                     ),
//                     _buildSettingsTile(
//                       icon: Icons.notifications_outlined,
//                       title: l10n.notifications,
//                       onTap: () => Navigator.pushNamed(context, RoutesName.notification),
//                     ),
//                     _buildSettingsTile(
//                       icon: Icons.language,
//                       title: l10n.appLanguageTitle,
//                       onTap: () => Navigator.pushNamed(context, RoutesName.appLanguage),
//                     ),
//                     _buildSettingsTile(
//                       icon: Icons.diamond_outlined,
//                       title: l10n.premiumSubscription,
//                       onTap: () => Navigator.pushNamed(context, RoutesName.pro),
//                     ),
//
//                     _buildSettingsTile(
//                       icon: Icons.help_outline,
//                       title: l10n.faq,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const FAQView(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildSettingsTile(
//                       icon: Icons.description_outlined,
//                       title: l10n.termsOfUse,
//                       onTap: () => Navigator.pushNamed(context, RoutesName.termsOfUse),
//                     ),
//
//                     _buildSettingsTile(
//                       icon: Icons.delete_outline,
//                       title: l10n.deleteOwnerProfile,
//                       isRed: true,
//                       onTap: () => _showDeleteConfirmationDialog(),
//                     ),
//                     _buildSettingsTile(
//                       icon: Icons.logout,
//                       title: l10n.logout,
//                       isRed: true,
//                       onTap: () => _showLogoutConfirmationDialog(),
//                       showDivider: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSettingsTile({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isRed = false,
//     bool showDivider = true,
//   }) {
//     return Column(
//       children: [
//
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: ListTile(
//             contentPadding: EdgeInsets.symmetric(horizontal: 16.w,),
//             leading: Icon(
//               icon,
//               color: isRed ? Colors.red : AppColors.vibrantPurple,
//               size: 28.sp,
//             ),
//             title: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF371B34),
//               ),
//             ),
//             onTap: onTap,
//             minVerticalPadding: 8.h,
//             dense: true,
//           ),
//         ),
//         if (showDivider)
//           Divider(
//             color: const Color(0xFFE4E4E4),
//             height: 0,
//             thickness: 1,
//             indent: 0.w,
//           ),
//       ],
//     );
//   }
//
//
//   void _showDeleteConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         contentPadding: EdgeInsets.zero,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 24.h),
//             // Dog Illustration
//             SvgPicture.asset(
//               'assets/images/Dog.svg',
//               height: 120.h,
//             ),
//
//             SizedBox(height: 24.h),
//
//             // Warning Title
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Text(
//                 "Warning! The profile and all its content will be deleted permanently and cannot be recovered. If you have an active Premium Subscription, deactivate it in your App Store Subscription settings",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 32.h),
//
//             // Buttons
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Row(
//                 children: [
//                   // Cancel Button
//                   Expanded(
//                     child: SizedBox(
//                       height: 48.h,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFC8C8C8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(24.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           l10n.dialogCancel,
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//
//                   // Delete Button
//                   Expanded(
//                     child: SizedBox(
//                       height: 48.h,
//                       child: ElevatedButton(
//                         onPressed: () {
//
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFDB5959),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(24.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           l10n.dialogDelete,
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 24.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   void _showLogoutConfirmationDialog() {
//     final l10n = AppLocalizations.of(context)!;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//         title: Center(
//           child: Text(
//             l10n.dialogLogoutTitle,
//             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
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
//
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFDB5959),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         l10n.dialogCancel,
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
//                       Navigator.pushNamed(context, RoutesName.login);
//
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF05E584),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24.r),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         l10n.dialogLogoutTitle,
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
//
//         ],
//       ),
//     );
//   }
// }
//
//
//
// // import 'package:dog_breed/Valid/AppColors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:dog_breed/l10n/app_localizations.dart';
// // import '../../utils/routes/routes_name.dart';
// //
// // class Profileview extends StatefulWidget {
// //   const Profileview({super.key});
// //
// //   @override
// //   State<Profileview> createState() => _ProfileviewState();
// // }
// //
// // class _ProfileviewState extends State<Profileview> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final l10n = AppLocalizations.of(context)!;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: ListView(
// //                 padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),
// //                 children: [
// //                   Center(
// //                     child: Text(
// //                       l10n.settingsTitle,
// //                       style: TextStyle(
// //                         color: Colors.black,
// //                         fontSize: 30.sp,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 20.h,),
// //                   _buildSettingsTile(
// //                     icon: Icons.person_outline,
// //                     color: Colors.purple,
// //                     title: l10n.editProfile,
// //                     onTap: () => Navigator.pushNamed(context, RoutesName.editProfile),
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.lock_outline,
// //                     color: Colors.purple,
// //                     title: l10n.changePassword,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.notifications_outlined,
// //                     color: Colors.purple,
// //                     title: l10n.notifications,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.language,
// //                     color: Colors.purple,
// //                     title: l10n.appLanguageTitle,
// //                     onTap: () => Navigator.pushNamed(context, RoutesName.appLanguage),
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.diamond_outlined,
// //                     color: Colors.purple,
// //                     title: l10n.premiumSubscription,
// //                     onTap: () => Navigator.pushNamed(context, RoutesName.pro),
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.info_outline,
// //                     color: Colors.blue,
// //                     title: l10n.aboutUs,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.help_outline,
// //                     color: Colors.blue,
// //                     title: l10n.faq,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.description_outlined,
// //                     color: Colors.blue,
// //                     title: l10n.termsOfUse,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.pets,
// //                     color: Colors.orange,
// //                     title: l10n.supportAnimalIdProject,
// //                     onTap: () {},
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.delete_outline,
// //                     color: Colors.red,
// //                     title: l10n.deleteOwnerProfile,
// //                     onTap: () => _showDeleteConfirmationDialog(),
// //                   ),
// //                   _buildSettingsTile(
// //                     icon: Icons.logout,
// //                     color: Colors.red,
// //                     title: l10n.logout,
// //                     onTap: () => _showLogoutConfirmationDialog(),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildSettingsTile({
// //     required IconData icon,
// //     required Color color,
// //     required String title,
// //     required VoidCallback onTap,
// //     bool showBottomDivider = true,
// //   }) {
// //     return Column(
// //       children: [
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Color(0xFF686868).withOpacity(0.1),
// //           ),
// //           child: ListTile(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0),
// //             leading: Icon(
// //               icon,
// //               color: AppColors.vibrantPurple,
// //               size: 28.sp,
// //             ),
// //             title: Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 18.sp,
// //                 fontWeight: FontWeight.bold,
// //                 color: const Color(0xFF371B34),
// //               ),
// //             ),
// //             onTap: onTap,
// //           ),
// //         ),
// //         if (showBottomDivider)
// //           Divider(
// //            color: Colors.grey.shade400,
// //            height: 1.h,
// //            thickness: 1.h,
// //          )
// //       ],
// //     );
// //   }
// //   void _showDeleteConfirmationDialog() {
// //     final l10n = AppLocalizations.of(context)!;
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16.r),
// //         ),
// //         title: Text(
// //           l10n.dialogDeleteProfileTitle,
// //           style: TextStyle(
// //             fontSize: 18.sp,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //         content: Text(
// //           l10n.dialogDeleteProfileMessage,
// //           style: TextStyle(
// //             fontSize: 14.sp,
// //             color: Colors.grey[700],
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text(
// //               l10n.dialogCancel,
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // TODO: Implement actual delete logic
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Text(l10n.deleteOwnerProfile + ' successful'),
// //                   backgroundColor: Colors.green,
// //                 ),
// //               );
// //             },
// //             style: TextButton.styleFrom(
// //               foregroundColor: Colors.red,
// //             ),
// //             child: Text(
// //               l10n.dialogDelete,
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _showLogoutConfirmationDialog() {
// //     final l10n = AppLocalizations.of(context)!;
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16.r),
// //         ),
// //         title: Text(
// //           l10n.dialogLogoutTitle,
// //           style: TextStyle(
// //             fontSize: 18.sp,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //         content: Text(
// //           l10n.dialogLogoutMessage,
// //           style: TextStyle(
// //             fontSize: 14.sp,
// //             color: Colors.grey[700],
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text(
// //               l10n.dialogCancel,
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // TODO: Clear session, go to login
// //               Navigator.pushNamedAndRemoveUntil(
// //                 context,
// //                 RoutesName.login,
// //                     (route) => false,
// //               );
// //             },
// //             style: TextButton.styleFrom(
// //               foregroundColor: Colors.red,
// //             ),
// //             child: Text(
// //               l10n.logout,
// //               style: TextStyle(
// //                 fontSize: 14.sp,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
