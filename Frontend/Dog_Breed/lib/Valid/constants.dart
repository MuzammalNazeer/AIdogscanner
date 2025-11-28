import 'package:flutter/material.dart';

class Constants {
  // App-wide colors
  static const Color primaryColor = Color(0xFF0D47A1); // Blue
  static const Color accentColor = Color(0xFFFFC107); // Amber
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color vibrantPurple = Color(0xFF6D09E8);
  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  // API Endpoints
  static const String apiBaseUrl = "https://api.example.com";
  static const String loginEndpoint = "$apiBaseUrl/auth/login";
  static const String signupEndpoint = "$apiBaseUrl/auth/signup";
  static const String fetchDocumentsEndpoint = "$apiBaseUrl/documents";

  // Application Settings
  static const String appName = "My Flutter App";
  static const String version = "1.0.0";

  // Icons
  static const Icon defaultDocumentIcon = Icon(Icons.insert_drive_file, color: Colors.grey);
  static const Icon errorIcon = Icon(Icons.error, color: errorColor);

  // Miscellaneous
  static const double borderRadius = 8.0;
  static const double padding = 16.0;
  static const double margin = 16.0;

  // Placeholder image
  static const String placeholderImage = "assets/images/placeholder.png";

  // Environment variables
  static const bool isProduction = true;

  // Status List for document statuses
  static const List<Map<String, dynamic>> statusListDocument = [

    // {'name': 'ALLDocumets', 'value': 'allDocumets'},
    // {'name': 'Draft', 'value': 'draft'},
    // {'name': 'Pending', 'value': 'pending'},
    // {'name': 'Shared', 'value': 'shared'},
    // {'name': 'Signed', 'value': 'signed'},
    // {'name': 'Completed', 'value': 'completed'},
    // {'name': 'Void', 'value': 'void'},


  ];

  // Shared Preferences Keys for models and settings
  static var loginResponseModel = 'LOGIN_RESPONSE_MODEL';
  static var userProfileModel = 'USER_PROFILE_MODEL';
  static var userSettingsModel = 'USER_SETTINGS_MODEL';
  static var baseUrl = 'BASE_URL';
  static var languageCode = 'LANGUAGE_CODE';
  static var isLogin = 'IS_LOGIN';

  // Error handling function
  static String getErrorMessage(dynamic e) {
    final errorMessage = e.toString();
    return errorMessage.startsWith('Exception: ')
        ? errorMessage.substring('Exception: '.length)
        : errorMessage;
  }
}
