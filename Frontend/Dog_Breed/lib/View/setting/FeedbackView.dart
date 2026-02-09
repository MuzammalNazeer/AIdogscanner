import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/components/CommonApp.dart';
import 'package:dog_breed/l10n/app_localizations.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String? _selectedIssue;
  final TextEditingController _detailsController = TextEditingController();

  List<String> get _issues {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.feedbackIssueLagging,
      l10n.feedbackIssueCrashes,
      l10n.feedbackIssueAds,
      l10n.feedbackIssueOther,
      l10n.feedbackIssueNotWorking,
    ];
  }

  void _showCenterMessage(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  void _showEmailOptions() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.submitFeedback,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.feedbackChooseEmailApp,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'anapplemuzammal@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.dialogCancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: _sendFeedbackEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.feedbackSendEmail,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  void _sendFeedbackEmail() async {
    Navigator.pop(context);

    const email = 'anapplemuzammal@gmail.com';
    final l10n = AppLocalizations.of(context)!;

    // Subject: ALWAYS just "DogBreed: Feedback"
    final rawSubject = l10n.feedbackEmailSubject;
    final encodedSubject = Uri.encodeComponent(rawSubject);

    // Body: Include issue type AND user's text
    String rawBody;

    if (_detailsController.text.isNotEmpty && _selectedIssue != null) {
      rawBody = '${l10n.feedbackIssueType} $_selectedIssue\n\n${l10n.feedbackDetails}\n${_detailsController.text}';
    } else if (_detailsController.text.isNotEmpty) {
      rawBody = '${l10n.feedbackDetails}\n${_detailsController.text}';
    } else if (_selectedIssue != null) {
      rawBody = '${l10n.feedbackIssueType} $_selectedIssue';
    } else {
      rawBody = l10n.feedbackGeneral;
    }

    final encodedBody = Uri.encodeComponent(rawBody);

    final emailUrl = 'mailto:$email?subject=$encodedSubject&body=$encodedBody';

    try {
      final bool launched = await launchUrl(
        Uri.parse(emailUrl),
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context);
      } else {
        _showManualEmailOption(email, rawSubject, rawBody);
      }
    } catch (e) {
      _showManualEmailOption(email, rawSubject, rawBody);
    }
  }

  void _showManualEmailOption(String email, String subject, String body) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.feedbackManualEmailTitle,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.feedbackManualEmailBody),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.feedbackSubject),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(subject),
                ),
                const SizedBox(height: 12),
                Text(l10n.feedbackMessage),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(body),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.dialogCancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close feedback screen
                _showCenterMessage(l10n.feedbackManualEmailSuccess);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
              ),
              child: Text(l10n.okAction, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _submitFeedback() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedIssue == null) {
      _showCenterMessage(l10n.feedbackSelectIssue);
      return;
    }

    _showEmailOptions();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      l10n.feedbackTitle,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w300,
                        fontSize: 29.75.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    // Invisible placeholder to balance
                    SizedBox(
                      width: 40.305.w,
                      height: 40.305.h,
                    ),
                  ],
                ),

                SizedBox(height: 30.h),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/feed.png',
                        fit: BoxFit.cover,
                        width: 63.w,
                        height: 63.h,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        l10n.feedbackDescribeIssue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final currentIssues = _issues;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 120 / 40,
                      ),
                      itemCount: currentIssues.length,
                      itemBuilder: (context, index) {
                        final issue = currentIssues[index];
                        final bool isSelected = _selectedIssue == issue;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIssue = issue;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE3D4FF) : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  issue,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF9C27B0) : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.background.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: colors.onSurface.withOpacity(0.1),
                        blurRadius: 42.w,
                        spreadRadius: 2.w,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _detailsController,
                    maxLines: 6,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.feedbackTellUsMore,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: colors.onSurface, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        l10n.submitButton,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
