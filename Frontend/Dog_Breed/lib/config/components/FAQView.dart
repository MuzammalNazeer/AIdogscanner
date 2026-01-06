import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  // Track which FAQ is expanded (-1 = none)
  int _expandedIndex = -1;

  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I register a pet?',
      'answer':
      'You can register your pet by going to the "Add Pet" section, filling in the required details (name, breed, age, etc.), and attaching a photo. Once registered, you’ll receive a unique QR pet tag ID.',
    },
    {
      'question': 'Why should I register my pet?',
      'answer':
      'Registering your pet helps in case they get lost. Anyone who finds your pet can scan the QR tag and instantly contact you with the pet’s location.',
    },
    {
      'question': 'QR pet tag activation?',
      'answer':
      'After registering, you’ll get a digital or physical QR tag. Scan it with any phone camera to link it to your pet’s profile. No app needed for finders!',
    },
    {
      'question': 'How does QR code scanning work?',
      'answer':
      'Anyone can scan the QR tag using their phone’s camera. It opens a web page with your contact info and pet details so they can reach you immediately.',
    },
    {
      'question': 'Who can register a pet?',
      'answer': 'Any pet owner can register their dog, cat, or other companion animal.',
    },
    {
      'question': 'How can I change my data?',
      'answer': 'Go to Profile → tap any field (Name, Email, Phone, etc.) to edit and save.',
    },
    {
      'question': 'How can I change my pet\'s data?',
      'answer': 'Go to your pet’s profile and tap the edit button to update name, breed, photos, etc.',
    },
    {
      'question': 'What is a pet ID number?',
      'answer': 'It’s a unique identifier linked to your pet’s QR tag for quick identification.',
    },
    {
      'question': 'My pet is lost what should I do?',
      'answer':
      'Mark your pet as "Lost" in the app. This alerts anyone who scans the tag and shows your emergency contact info.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'FAQ',
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Dog Illustration
            Image.asset(
              'assets/images/106.png',
              height: 260.h,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 32.h),

            // Expandable FAQ List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  final isExpanded = _expandedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? -1 : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(bottom: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16.r),

                      ),
                      child: Column(
                        children: [
                          // Question Row
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faq['question']!,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: AppColors.vibrantPurple,
                                  size: 28.sp,
                                ),
                              ],
                            ),
                          ),

                          // Answer (only when expanded)
                          if (isExpanded)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                              ),
                              child: Text(
                                faq['answer']!,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}