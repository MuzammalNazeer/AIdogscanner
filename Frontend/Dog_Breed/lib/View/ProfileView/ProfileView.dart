import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/components/FAQView.dart';
import '../../utils/routes/routes_name.dart';

class Profileview extends StatefulWidget {
  const Profileview({super.key});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_outline,
                    title: l10n.editProfile,
                    onTap: () => Navigator.pushNamed(context, RoutesName.editProfile),
                  ),
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: l10n.changePassword,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.language,
                    title: l10n.appLanguageTitle,
                    onTap: () => Navigator.pushNamed(context, RoutesName.appLanguage),
                  ),
                  _buildSettingsTile(
                    icon: Icons.diamond_outlined,
                    title: l10n.premiumSubscription,
                    onTap: () => Navigator.pushNamed(context, RoutesName.pro),
                  ),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: l10n.aboutUs,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.help_outline,
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
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.pets,
                    title: l10n.supportAnimalIdProject,
                    isRed: true,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.delete_outline,
                    title: l10n.deleteOwnerProfile,
                    isRed: true,
                    onTap: () => _showDeleteConfirmationDialog(),
                  ),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: l10n.logout,
                    isRed: true,
                    onTap: () => _showLogoutConfirmationDialog(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF686868).withOpacity(0.1),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w,),
            leading: Icon(
              icon,
              color: isRed ? Colors.red : AppColors.vibrantPurple,
              size: 28.sp,
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
        Divider(
          color: Colors.grey.shade400,
          height: 1.h,
          thickness: 1.h,
          indent: 0.w,
          endIndent: 0.w,
        ),
      ],
    );
  }

  // void _showDeleteConfirmationDialog() {
  //   final l10n = AppLocalizations.of(context)!;
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
  //       title: Text(
  //         l10n.dialogDeleteProfileTitle,
  //         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
  //       ),
  //       content: Text(
  //         l10n.dialogDeleteProfileMessage,
  //         style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             l10n.dialogCancel,
  //             style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //
  //           },
  //           style: TextButton.styleFrom(foregroundColor: Colors.red),
  //           child: Text(
  //             l10n.dialogDelete,
  //             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showDeleteConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.zero, // To control padding ourselves
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dog Illustration
            SvgPicture.asset(
              'assets/images/DOG.svg',
              height: 40.h,
            ),

            SizedBox(height: 24.h),

            // Warning Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                "Warning! The profile and all its content will be "
                "deleted permanent and cannot be recovered"
              "if your have an active Premium Subscription"
                "Deactivate it in your App Store Subscriptio"
              "settigns",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Buttons
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
                          backgroundColor: Color(0xFFC8C8C8),
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

                  // Delete Button
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
            ),

            SizedBox(height: 24.h),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
                        l10n.dialogLogoutTitle,
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
