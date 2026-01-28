import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  // SendGrid Configuration - REPLACE WITH YOUR ACTUAL API KEY
  static const String _sendgridApiKey = 'SG.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  static const String _sendgridUrl = 'https://api.sendgrid.com/v3/mail/send';
  static const String _yourEmail = 'anapplemuzammal@gmail.com';
  static const String _senderEmail = 'noreply@dogbreedapp.com';

  static const String _pendingFeedbackKey = 'pending_feedback';

  // Check internet connection
  static Future<bool> isOnline() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Connectivity check error: $e');
      }
      return false;
    }
  }

  // Store feedback locally
  static Future<void> storeFeedbackLocally({
    required String issue,
    required String details,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];

      final feedbackData = {
        'issue': issue,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
        'attempts': 0,
      };

      feedbackList.add(json.encode(feedbackData));
      await prefs.setStringList(_pendingFeedbackKey, feedbackList);

      if (kDebugMode) {
        print('✅ Feedback stored locally. Total pending: ${feedbackList.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error storing feedback: $e');
      }
      rethrow;
    }
  }

  // Send feedback using SendGrid
  static Future<void> sendFeedback({
    required String issue,
    required String details,
    String? timestamp,
  }) async {
    try {
      if (kDebugMode) {
        print('🚀 Starting to send feedback...');
      }

      final headers = {
        'Authorization': 'Bearer $_sendgridApiKey',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'personalizations': [
          {
            'to': [
              {'email': _yourEmail, 'name': 'App Admin'}
            ],
            'subject': '🐕 Dog Breed App - Feedback: $issue'
          }
        ],
        'from': {'email': _senderEmail, 'name': 'Dog Breed App'},
        'content': [
          {
            'type': 'text/plain',
            'value': '''
NEW FEEDBACK FROM DOG BREED APP

Issue Type: $issue
Details: ${details.isNotEmpty ? details : 'No additional details provided'}
Timestamp: ${timestamp ?? DateTime.now()}
App Version: 1.0.0
            '''
          }
        ]
      });

      if (kDebugMode) {
        print('📤 Sending to SendGrid...');
      }

      final response = await http.post(
        Uri.parse(_sendgridUrl),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📩 SendGrid Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 202) {
        if (kDebugMode) {
          print('🎉 Feedback sent successfully! Check email at $_yourEmail');
        }
        if (kDebugMode) {
          print('📧 Also check SPAM folder if not in inbox');
        }
      } else {
        if (kDebugMode) {
          print('❌ SendGrid Error Response: ${response.body}');
        }
        throw Exception('SendGrid Error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('❌ Network error: $e');
      }
      throw Exception('Network error. Please check internet connection.');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in sendFeedback: $e');
      }
      throw Exception('Failed to send feedback: $e');
    }
  }

  // Process pending feedback
  static Future<void> processPendingFeedback() async {
    try {
      if (kDebugMode) {
        print('🔍 Checking for pending feedback...');
      }

      if (!await isOnline()) {
        if (kDebugMode) {
          print('📶 No internet connection. Skipping pending feedback.');
        }
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];

      if (feedbackList.isEmpty) {
        if (kDebugMode) {
          print('📭 No pending feedback found.');
        }
        return;
      }

      if (kDebugMode) {
        print('🔄 Processing ${feedbackList.length} pending feedback(s)...');
      }

      List<String> successful = [];

      for (var feedbackJson in feedbackList) {
        try {
          final feedback = json.decode(feedbackJson);
          final attempts = (feedback['attempts'] ?? 0) + 1;

          if (attempts > 3) {
            if (kDebugMode) {
              print('⚠️ Skipping feedback after 3 failed attempts');
            }
            continue;
          }

          await sendFeedback(
            issue: feedback['issue'],
            details: feedback['details'],
            timestamp: feedback['timestamp'],
          );

          successful.add(feedbackJson);
          if (kDebugMode) {
            print('✅ Sent one pending feedback');
          }

          // Small delay to avoid rate limiting
          await Future.delayed(const Duration(seconds: 1));

        } catch (e) {
          if (kDebugMode) {
            print('❌ Failed to send pending feedback: $e');
          }
          // Don't update attempts for now to keep it simple
        }
      }

      // Remove successfully sent feedback
      if (successful.isNotEmpty) {
        feedbackList.removeWhere((item) => successful.contains(item));
        await prefs.setStringList(_pendingFeedbackKey, feedbackList);
        if (kDebugMode) {
          print('✅ Removed ${successful.length} sent feedback(s) from storage');
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in processPendingFeedback: $e');
      }
    }
  }

  // Get count of pending feedback
  static Future<int> getPendingCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];
      return feedbackList.length;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting pending count: $e');
      }
      return 0;
    }
  }

  // Test function - call this to verify email sending works
  static Future<void> testEmailSending() async {
    try {
      if (kDebugMode) {
        print('🧪 TEST: Sending test email...');
      }
      await sendFeedback(
        issue: 'TEST - App Feedback System',
        details: 'This is a test email from the Dog Breed App feedback system. If you receive this, the system is working correctly!',
      );
      if (kDebugMode) {
        print('✅ TEST COMPLETE: Check your email at $_yourEmail');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ TEST FAILED: $e');
      }
    }
  }
}

// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
// class FeedbackService {
//   // Your email credentials (CHANGE THESE)
//   static const String _yourEmail = 'anapplemuzammal@gmail.com';
//   static const String _yourPassword = 'your-app-password-here'; // Use App Password, not regular password
//
//   static const String _pendingFeedbackKey = 'pending_feedback';
//
//   // Check internet connection
//   static Future<bool> isOnline() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
//
//   // Store feedback locally
//   static Future<void> storeFeedbackLocally({
//     required String issue,
//     required String details,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];
//
//       final feedbackData = {
//         'issue': issue,
//         'details': details,
//         'timestamp': DateTime.now().toIso8601String(),
//         'attempts': 0,
//       };
//
//       feedbackList.add(json.encode(feedbackData));
//       await prefs.setStringList(_pendingFeedbackKey, feedbackList);
//
//       print('✅ Feedback stored locally');
//     } catch (e) {
//       print('❌ Error storing feedback: $e');
//       rethrow;
//     }
//   }
//
//   // Send feedback using SMTP
//   static Future<void> sendFeedback({
//     required String issue,
//     required String details,
//     String? timestamp,
//   }) async {
//     try {
//       // For Gmail - Use App Password (not regular password)
//       // Create App Password: https://myaccount.google.com/apppasswords
//       final smtpServer = gmail(_yourEmail, _yourPassword);
//
//       final message = Message()
//         ..from = Address(_yourEmail, 'Dog Breed App')
//         ..recipients.add(_yourEmail) // Send to yourself
//         ..subject = 'App Feedback: $issue'
//         ..text = '''
// 📱 NEW FEEDBACK FROM DOG BREED APP 📱
//
// Issue Type: $issue
// Details: ${details.isNotEmpty ? details : 'No additional details provided'}
// Timestamp: ${timestamp ?? DateTime.now()}
//
// Sent from Dog Breed App Feedback System
//         '''
//         ..html = '''
// <!DOCTYPE html>
// <html>
// <body style="font-family: Arial, sans-serif;">
//   <h2 style="color: #9C27B0;">🐕 New Feedback from Dog Breed App 🐕</h2>
//
//   <div style="background-color: #f5f5f5; padding: 20px; border-radius: 10px; margin: 20px 0;">
//     <h3 style="color: #333;">Issue Details:</h3>
//     <p><strong>Issue Type:</strong> $issue</p>
//     <p><strong>Details:</strong> ${details.isNotEmpty ? details : 'No additional details provided'}</p>
//     <p><strong>Timestamp:</strong> ${timestamp ?? DateTime.now()}</p>
//   </div>
//
//   <hr style="border: 1px solid #ddd;">
//   <p style="color: #666; font-size: 12px;">
//     This feedback was submitted from the Dog Breed App.<br>
//     App Version: 1.0.0
//   </p>
// </body>
// </html>
//         ''';
//
//       final sendReport = await send(message, smtpServer);
//       print('📧 Feedback sent successfully: ${sendReport.toString()}');
//
//     } catch (e) {
//       print('❌ Error sending email: $e');
//       throw Exception('Failed to send feedback');
//     }
//   }
//
//   // Process pending feedback
//   static Future<void> processPendingFeedback() async {
//     try {
//       if (!await isOnline()) return;
//
//       final prefs = await SharedPreferences.getInstance();
//       final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];
//
//       if (feedbackList.isEmpty) return;
//
//       print('🔄 Processing ${feedbackList.length} pending feedback(s)');
//
//       List<String> successful = [];
//       List<String> updated = [];
//
//       for (var feedbackJson in feedbackList) {
//         try {
//           final feedback = json.decode(feedbackJson);
//           final attempts = (feedback['attempts'] ?? 0) + 1;
//
//           if (attempts > 3) {
//             print('⚠️ Skipping feedback after 3 failed attempts');
//             continue;
//           }
//
//           await sendFeedback(
//             issue: feedback['issue'],
//             details: feedback['details'],
//             timestamp: feedback['timestamp'],
//           );
//
//           successful.add(feedbackJson);
//         } catch (e) {
//           final feedback = json.decode(feedbackJson);
//           feedback['attempts'] = (feedback['attempts'] ?? 0) + 1;
//           updated.add(json.encode(feedback));
//           print('❌ Failed to send feedback, attempt ${feedback['attempts']}: $e');
//         }
//       }
//
//       // Update storage
//       feedbackList.removeWhere((item) => successful.contains(item));
//       for (var updatedItem in updated) {
//         final index = feedbackList.indexWhere((item) =>
//         json.decode(item)['timestamp'] == json.decode(updatedItem)['timestamp']);
//         if (index != -1) {
//           feedbackList[index] = updatedItem;
//         }
//       }
//
//       await prefs.setStringList(_pendingFeedbackKey, feedbackList);
//
//       if (successful.isNotEmpty) {
//         print('✅ Successfully sent ${successful.length} feedback(s)');
//       }
//     } catch (e) {
//       print('❌ Error processing pending feedback: $e');
//     }
//   }
//
//   // Get count of pending feedback
//   static Future<int> getPendingCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     final feedbackList = prefs.getStringList(_pendingFeedbackKey) ?? [];
//     return feedbackList.length;
//   }
// }
//
// // // feedback_service.dart
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // class FeedbackService {
// //   static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';
// //   static const String _serviceId = 'service_kiwwacp';
// //   static const String _templateId = 'template_5i6spsc';
// //   static const String _userId = 'cUk8TRxQIDhTbmn1k';
// //   static const String _yourEmail = 'anapplemuzammal@gmail.com';
// //
// //   static Future<void> sendFeedback({
// //     required String issueType,
// //     required String details,
// //   }) async {
// //     final response = await http.post(
// //       Uri.parse(_apiUrl),
// //       headers: {
// //         'origin': 'http://localhost',
// //         'Content-Type': 'application/json',
// //       },
// //       body: json.encode({
// //         'service_id': _serviceId,
// //         'template_id': _templateId,
// //         'user_id': _userId,
// //         'template_params': {
// //           'to_email': _yourEmail,
// //           'issue_type': issueType,
// //           'details': details,
// //           'date_time': DateTime.now().toString(),
// //         }
// //       }),
// //     );
// //
// //     if (response.statusCode != 200) {
// //       throw Exception('Failed to send feedback: ${response.body}');
// //     }
// //   }
// // }