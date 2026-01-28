
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';

import '../../l10n/app_localizations.dart';

class GenderView extends StatefulWidget {
  final String currentGender;

  const GenderView({super.key, required this.currentGender});

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  late String _selectedGender;

  final List<String> _genderKeys = [
    'Male',
    'Female',
    'Other',
    'I don’t want to indicate',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.currentGender.isEmpty ? _genderKeys[0] : widget.currentGender;
  }

  String _getLocalizedGender(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'Male':
        return l10n.genderMale;
      case 'Female':
        return l10n.genderFemale;
      case 'Other':
        return l10n.genderOther;
      case 'I don’t want to indicate':
        return l10n.genderPreferNotToSay;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration:  BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: _genderKeys.length,
                  itemBuilder: (context, index) {
                    final key = _genderKeys[index];
                    final isSelected = key == _selectedGender;
                    final label = _getLocalizedGender(context, key);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = key;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          color:  Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.r),

                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? AppColors.vibrantPurple : Colors.grey,
                              size: 28.sp,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedGender);
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
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dog_breed/Valid/AppColors.dart';
//
// class GenderView extends StatelessWidget {
//   final String currentGender;
//
//   const GenderView({super.key, required this.currentGender});
//
//   @override
//   Widget build(BuildContext context) {
//     final options = ['Male', 'Female', 'Other','I don’t want to indicate'];
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               Text(
//                 'Select Gender',
//                 style: TextStyle(
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 24.h),
//
//               // Options
//               ...options.map((option) {
//                 final isSelected = option == currentGender;
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context, option); // Return selected gender
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 16.h),
//                     padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12.r),
//
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           option,
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const Spacer(),
//                         Icon(
//                           isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
//                           color: isSelected ? AppColors.vibrantPurple : Colors.grey,
//                           size: 24.sp,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }