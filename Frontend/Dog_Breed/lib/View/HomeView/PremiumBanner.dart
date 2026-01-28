import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';


class PremiumBanner extends StatelessWidget {
  final VoidCallback? onGetIt;


  const PremiumBanner({Key? key, this.onGetIt}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),

      decoration: BoxDecoration(
        color: const Color(0xFF820DFF), // soft yellow
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.tryPremiumFeatures, style: TextStyle
                  (color: Colors.white, fontFamily: 'Sora', fontSize: 15.sp, fontWeight:
                FontWeight
                    .w600)),
                SizedBox(height: 6.h),
                Text(AppLocalizations.of(context)!.premiumOfferDescription,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp,
                        color: Colors.white)),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            height: 30.h,
            child: ElevatedButton(
              onPressed: onGetIt,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5A905),
                padding: EdgeInsets.symmetric(horizontal: 25 .w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius
                    .circular(4.r)),
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(AppLocalizations.of(context)!.getIt, style: TextStyle(fontFamily: 'Inter',
                  fontSize: 12.sp,  color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}