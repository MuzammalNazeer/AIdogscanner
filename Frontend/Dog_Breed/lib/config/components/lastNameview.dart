import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'CommonApp.dart';

class Lastnameview extends StatefulWidget {
  final String initialLastName; // ← Receive current name

  const Lastnameview({super.key, required this.initialLastName});

  @override
  State<Lastnameview> createState() => _NameViewState();
}

class _NameViewState extends State<Lastnameview> {
  late TextEditingController _lastNameController;
  late final FocusNode _LastNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _lastNameController = TextEditingController(text: widget.initialLastName);
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _LastNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration:  BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              Text(l10n.lastName, style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),

              SizedBox(height: 32.h),

              // Text Field
              TextField(
                controller: _lastNameController,
                focusNode: _LastNameFocus,
                style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: l10n.enterLastName,
                  hintStyle: TextStyle(fontSize: 18.sp, color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : const Color(0xFFF5F5F5),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.vibrantPurple, width: 2),
                  ),
                ),
              ),

              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _lastNameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.pop(context, name); // ← Return the new name
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.save,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
