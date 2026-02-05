import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController {
  static const String _userTokenKey = "USER_TOKEN";
  static const String _userIdKey = "USER_ID";
  static const String _userEmailKey = "USER_EMAIL";
  static const String _languageCodeKey = "LANGUAGE_CODE";

  // ... (existing methods)

  Future<void> saveUserSession(String token, int userId, String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userTokenKey, token);
      await prefs.setInt(_userIdKey, userId);
      await prefs.setString(_userEmailKey, email);
      if (kDebugMode) {
        print("User session saved: $userId, $email");
      }
    } catch (e) {
      if (kDebugMode) print("Failed to save user session: $e");
      rethrow;
    }
  }

  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<void> clearUserSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userTokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      if (kDebugMode) print("User session cleared.");
    } catch (e) {
      if (kDebugMode) print("Failed to clear user session: $e");
    }
  }


  Future<void> saveUserTokenToPreference(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userTokenKey, token);
      if (kDebugMode) {
        print("Token saved successfully: $token");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to save token: $e");
      }
      rethrow;
    }
  }

  Future<String?> getUserTokenFromPreference() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(_userTokenKey);
      if (token != null) {
        if (kDebugMode) {
          print("Token retrieved: $token");
        }
      } else {
        if (kDebugMode) {
          print("No token found.");
        }
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print("Failed to retrieve token: $e");
      }
      return null;
    }
  }

  Future<void> clearUserToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userTokenKey);
      if (kDebugMode) {
        print("Token cleared successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to clear token: $e");
      }
    }
  }
  Future<Locale> getLanguage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString(_languageCodeKey);
      if (languageCode != null) {
        return Locale(languageCode);
      } else {
        return const Locale('en'); // Default to English
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get language: $e");
      }
      return const Locale('en');
    }
  }

  Future<void> saveLanguage(String languageCode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, languageCode);
      if (kDebugMode) {
        print("Language saved successfully: $languageCode");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to save language: $e");
      }
    }
  }
  Future<void> changeLanguage(Locale type) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, type.languageCode);
      if (kDebugMode) {
        print("Language changed to: ${type.languageCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to change language: $e");
      }
    }
  }
}
