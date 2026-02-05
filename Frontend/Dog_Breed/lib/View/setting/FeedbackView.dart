import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/components/CommonApp.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String? _selectedIssue;
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _issues = [
    'Lagging Issue',
    'App Crashes',
    'Too Many Ads',
    'Other Problem',
    "Doesn't Work",
  ];

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Submit Feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please choose an email app to send your feedback to:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
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
              child: const Text(
                'Send Email',
                style: TextStyle(color: Colors.white),
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

    // Subject: ALWAYS just "DogBreed: Feedback"
    const rawSubject = 'DogBreed: Feedback';  // Fixed - no issue type in subject
    final encodedSubject = Uri.encodeComponent(rawSubject);

    // Body: Include issue type AND user's text
    String rawBody;

    if (_detailsController.text.isNotEmpty && _selectedIssue != null) {
      rawBody = 'Issue Type: $_selectedIssue\n\nFeedback Details:\n${_detailsController.text}';
    } else if (_detailsController.text.isNotEmpty) {
      rawBody = 'Feedback Details:\n${_detailsController.text}';
    } else if (_selectedIssue != null) {
      rawBody = 'Issue Type: $_selectedIssue';
    } else {
      rawBody = 'General Feedback';
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Send Email Manually',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please send an email to:'),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Subject:'),
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
                const Text('Message:'),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close feedback screen
                _showCenterMessage('Thank you! Please send the email manually.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _submitFeedback() {
    if (_selectedIssue == null) {
      _showCenterMessage("Please select an issue");
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CommonApp(title: 'Feedback'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      const Text(
                        "Could You Describe The Issue\nYou're Experiencing",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 120 / 40,
                      ),
                      itemCount: _issues.length,
                      itemBuilder: (context, index) {
                        final issue = _issues[index];
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
                      hintText: 'Please Tell Us More Details...',
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
                      child: const Text(
                        'Submit',
                        style: TextStyle(
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

// // feedback_view.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class FeedbackView extends StatefulWidget {
//   const FeedbackView({Key? key}) : super(key: key);
//
//   @override
//   State<FeedbackView> createState() => _FeedbackViewState();
// }
//
// class _FeedbackViewState extends State<FeedbackView> {
//   String? _selectedIssue;
//   final TextEditingController _detailsController = TextEditingController();
//
//   final List<String> _issues = [
//     'Lagging Issue',
//     'App Crashes',
//     'Too Many Ads',
//     'Other Problem',
//     "Doesn't Work",
//   ];
//
//   void _showCenterMessage(String message) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           content: Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showEmailOptions() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             'Submit Feedback',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           content: const Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Please choose an email app to send your feedback to:',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'anapplemuzammal@gmail.com',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF9C27B0),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _sendFeedbackEmail,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF9C27B0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Send Email',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _sendFeedbackEmail() async {
//     Navigator.pop(context); // Close the dialog
//
//     final email = 'anapplemuzammal@gmail.com';
//     final subject = 'App Feedback: ${_selectedIssue ?? "General Feedback"}';
//     final body = _detailsController.text.isNotEmpty
//         ? _detailsController.text
//         : 'Issue Type: ${_selectedIssue ?? "Not specified"}';
//
//     // Use the recommended Uri construction with encoding[citation:6]
//     final Uri emailLaunchUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {
//         'subject': subject,
//         'body': body,
//       },
//     );
//
//     try {
//       // Try to launch the email app directly.
//       final bool launched = await launchUrl(emailLaunchUri);
//       if (!launched) {
//         // If launchUrl returns false, show a fallback message.
//         _showCenterMessage("Could not open email app. Please send feedback to: $email");
//       } else {
//         // Email app opened successfully. Close screen after a delay.
//         Future.delayed(const Duration(seconds: 1), () {
//           if (mounted) Navigator.pop(context);
//         });
//       }
//     } catch (e) {
//       // Catch any other errors.
//       _showCenterMessage("An error occurred: $e");
//     }
//   }
//   void _submitFeedback() {
//     if (_selectedIssue == null) {
//       _showCenterMessage("Please select an issue");
//       return;
//     }
//
//     _showEmailOptions();
//   }
//
//   @override
//   void dispose() {
//     _detailsController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_back, color: colors.onSurface),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     SizedBox(width: 65.w),
//                     Text(
//                       'Feedback',
//                       style: TextStyle(
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 30.sp,
//                         height: 1.0,
//                         letterSpacing: 0.0,
//                         color: colors.onSurface,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30.h),
//                 Center(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/images/feed.png',
//                         fit: BoxFit.cover,
//                         width: 63.w,
//                         height: 63.h,
//                       ),
//                       SizedBox(height: 24.h),
//                       const Text(
//                         "Could You Describe The Issue\nYou're Experiencing",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 40.h),
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     return GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 120 / 40,
//                       ),
//                       itemCount: _issues.length,
//                       itemBuilder: (context, index) {
//                         final issue = _issues[index];
//                         final bool isSelected = _selectedIssue == issue;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedIssue = issue;
//                             });
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: isSelected ? const Color(0xFFE3D4FF) : const Color(0xFFF5F5F5),
//                               borderRadius: BorderRadius.circular(30),
//                               border: Border.all(
//                                 color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   issue,
//                                   style: TextStyle(
//                                     color: isSelected ? const Color(0xFF9C27B0) : Colors.black87,
//                                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                     fontSize: 12,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(height: 40.h),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: colors.background,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: colors.background.withOpacity(0.2)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: colors.onSurface.withOpacity(0.1),
//                         blurRadius: 42.w,
//                         spreadRadius: 2.w,
//                         offset: Offset(0, 8.h),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _detailsController,
//                     maxLines: 6,
//                     style: TextStyle(
//                       color: colors.onSurface,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Please Tell Us More Details...',
//                       border: InputBorder.none,
//                       hintStyle: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Center(
//                   child: SizedBox(
//                     width: 220,
//                     height: 54,
//                     child: ElevatedButton(
//                       onPressed: _submitFeedback,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF9C27B0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 3,
//                       ),
//                       child: const Text(
//                         'Submit',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
