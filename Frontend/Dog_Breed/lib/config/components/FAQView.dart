import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/l10n/app_localizations.dart';
import 'CommonApp.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  // Track which FAQ is expanded (-1 = none)
  int _expandedIndex = -1;

  List<Map<String, String>> get faqs {
    final loc = AppLocalizations.of(context)!;
    return [
      {
        'question': loc.faqQuestion1,
        'answer': loc.faqAnswer1,
      },
      {
        'question': loc.faqQuestion2,
        'answer': loc.faqAnswer2,
      },
      {
        'question': loc.faqQuestion3,
        'answer': loc.faqAnswer3,
      },
      {
        'question': loc.faqQuestion4,
        'answer': loc.faqAnswer4,
      },
      {
        'question': loc.faqQuestion5,
        'answer': loc.faqAnswer5,
      },
      {
        'question': loc.faqQuestion6,
        'answer': loc.faqAnswer6,
      },
      {
        'question': loc.faqQuestion7,
        'answer': loc.faqAnswer7,
      },
      {
        'question': loc.faqQuestion8,
        'answer': loc.faqAnswer8,
      },
      {
        'question': loc.faqQuestion9,
        'answer': loc.faqAnswer9,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 12,horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                  ),

                  // Center text
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.faq,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w300,
                        fontSize: 29.75.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),

                  // Invisible placeholder to balance
                  SizedBox(
                    width: 40.305.w,
                    height: 40.305.h,
                  ),
                ],
              ),

              // Header
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
                          color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.grey.shade200,
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
                                        color: Theme.of(context).colorScheme.onSurface,
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
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                                ),
                                child: Text(
                                  faq['answer']!,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Theme.of(context).colorScheme.onSurface,
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
      ),
    );
  }
}