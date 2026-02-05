import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';

class CommonApp extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? appBarColor;
  final String? locale; // 'en' or 'zh'

  const CommonApp({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.appBarColor,
    this.locale = 'en',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 30.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 40.305.w,
          height: 40.305.h,
          padding: const EdgeInsets.all(8.96),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.96),
          ),
          child: Icon(
            CupertinoIcons.chevron_left,
            size: 20.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}