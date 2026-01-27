import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../View_model/ReminderNotifier.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool _allowNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool('notifications_enabled') ?? true;
    setState(() {
      _allowNotifications = storedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Header with Back Button and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: const Color(0xFFF3F6F3),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.notifications,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Placeholder to balance the row (same width as back button)
                  SizedBox(width: 40.w),
                ],
              ),
              SizedBox(height: 30.h),
              
              // Notification Toggle Tile
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.allowNotifications,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Switch(
                      value: _allowNotifications,
                      onChanged: (value) async {
                        setState(() {
                          _allowNotifications = value;
                        });

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('notifications_enabled', value);

                        final reminderNotifier =
                            context.read<ReminderNotifier>();

                        if (!value) {
                          await reminderNotifier.cancelAllReminders();
                        }
                      },
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF7B2CBF),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dog_breed/l10n/app_localizations.dart';

// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});

//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }

// class _NotificationViewState extends State<NotificationView> {
//   bool _allowNotifications = true;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
    
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               SizedBox(height: 20.h),
//               // Header with Back Button and Title
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       width: 40.w,
//                       height: 40.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.r),
//                         color: const Color(0xFFF3F6F3),
//                       ),
//                       child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         l10n.notifications,
//                         style: TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Placeholder to balance the row (same width as back button)
//                   SizedBox(width: 40.w),
//                 ],
//               ),
//               SizedBox(height: 30.h),
              
//               // Notification Toggle Tile
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF3F6F3),
//                   borderRadius: BorderRadius.circular(16.r),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Allow Notifications",
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Switch(
//                       value: _allowNotifications,
//                       onChanged: (value) {
//                         setState(() {
//                           _allowNotifications = value;
//                         });
//                       },
//                       activeColor: Colors.white,
//                       activeTrackColor: const Color(0xFF7B2CBF),
//                       inactiveThumbColor: Colors.white,
//                       inactiveTrackColor: Colors.grey.shade300,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
