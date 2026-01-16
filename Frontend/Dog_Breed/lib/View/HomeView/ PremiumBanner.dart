import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PremiumBanner extends StatelessWidget {
  final VoidCallback? onGetIt;


  const PremiumBanner({Key? key, this.onGetIt}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                Text('Try Premium Features 🌵', style: TextStyle
                  (color: Colors.white, fontFamily: 'Sora', fontSize: 15.sp, fontWeight:
                FontWeight
                    .w600)),
                SizedBox(height: 6.h),
                Text('Claim your offer now and get unlimited recognition, health check and more',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp,
                        color: Colors.white)),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            height: 30.h, // Set a fixed height for the button area
            child: ElevatedButton(
              onPressed: onGetIt,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5A905),
                padding: EdgeInsets.symmetric(horizontal: 25 .w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius
                    .circular(4.r)),
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks the tap area
              ),
              child: Text('GET IT', style: TextStyle(fontFamily: 'Inter',
                  fontSize: 12.sp,  color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}