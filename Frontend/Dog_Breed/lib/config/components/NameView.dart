import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'CommonApp.dart';

class NameView extends StatefulWidget {
  final String initialName; // ← Receive current name

  const NameView({super.key, required this.initialName});

  @override
  State<NameView> createState() => _NameViewState();
}

class _NameViewState extends State<NameView> {
  late TextEditingController _nameController;
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
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
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 20.sp),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              Text(l10n.lastName, style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),

              // Text Field
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                style: TextStyle(fontSize: 18.sp, color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Enter the first name',
                  hintStyle: TextStyle(fontSize: 18.sp, color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.secondaryContainer,
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
                    final name = _nameController.text.trim();
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



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dog_breed/Valid/AppColors.dart'; // Assuming you have vibrantPurple here
//
// class NameView extends StatefulWidget {
//   const NameView({super.key, required String initialName});
//
//   @override
//   State<NameView> createState() => _NameViewState();
// }
//
// class _NameViewState extends State<NameView> {
//   final TextEditingController _nameController = TextEditingController();
//   final FocusNode _nameFocus = FocusNode();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _nameFocus.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
//
//               // Back Button
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40.w,
//                   height: 40.h,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.arrow_back_ios_new,
//                       color: Colors.black,
//                       size: 20.sp,
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 32.h),
//
//               // Title
//               Text(
//                 'Name',
//                 style: TextStyle(
//                   fontSize: 32.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//
//               SizedBox(height: 32.h),
//
//               // Name Text Field
//               TextField(
//                 controller: _nameController,
//                 focusNode: _nameFocus,
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   color: Colors.black87,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'Enter the first name',
//                   hintStyle: TextStyle(
//                     fontSize: 18.sp,
//                     color: Colors.grey[400],
//                   ),
//                   filled: true,
//                   fillColor: const Color(0xFFF5F5F5),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 18.h,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                     borderSide: BorderSide(
//                       color: AppColors.vibrantPurple,
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56.h,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // TODO: Save name logic
//                     final name = _nameController.text.trim();
//                     if (name.isNotEmpty) {
//                       // Save and go back or navigate
//                       Navigator.pop(context);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.vibrantPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28.r),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'Save',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }