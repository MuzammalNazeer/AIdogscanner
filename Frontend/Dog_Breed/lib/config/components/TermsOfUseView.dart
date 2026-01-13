import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Header
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
                            l10n.termsOfUse,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // Placeholder for alignment
                      SizedBox(width: 40.w),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Effective Date: [Insert Date]",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        "Terms of Use",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'By accessing or using [App Name] (the "Service"), you agree be bound by these Terms of Use (the "Terms"). If you do not agree to these Terms, do not use the Service.',
                      style: _contentStyle(),
                    ),
                    SizedBox(height: 20.h),
                    
                    _buildSectionTitle("1 . Use of the service."),
                    SizedBox(height: 8.h),
                    Text(
                      "The Service is provided to help users manage dog-related information, including but not limited to pet profiles, reminders, activities, health records, and related features. You agree to use the Service only for lawful purposes and in accordance with these Terms.",
                      style: _contentStyle(),
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle("2 . User Accounts"),
                    SizedBox(height: 8.h),
                    Text(
                      "You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to provide accurate and complete information and to keep such information up to date.",
                      style: _contentStyle(),
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle("3 . User Accounts"),
                    SizedBox(height: 8.h),
                    Text(
                      'When using the [App Name] Service, you may be subject to additional guidelines, rules, or terms applicable to specific features or services, which may be posted from time to time (the "Guidelines"). All such Guidelines are hereby incorporated by reference into these Terms.\nIn addition, your use of the Service is governed by the [App Name] Privacy Policy (the "Privacy Policy"), which is incorporated by reference into these Terms. By using the Service, you consent to the collection, use, and disclosure of your information in accordance with the Privacy Policy.',
                      style: _contentStyle(),
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle("4 . Health and Veterinary Disclaimer"),
                    SizedBox(height: 8.h),
                    Text(
                      "The Service is provided for informational and organizational purposes only and does not constitute veterinary, medical, or professional advice. Always seek the advice of a licensed veterinarian regarding your dog's health, nutrition, or medical condition.",
                      style: _contentStyle(),
                    ),
                    SizedBox(height: 40.h), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _contentStyle() {
    return TextStyle(
      fontSize: 14.sp,
      color: Colors.grey.shade600,
      height: 1.5,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
