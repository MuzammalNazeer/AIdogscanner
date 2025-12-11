import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = "theme";
  SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    try {
      await _initPrefs();
      final isDarkMode = _prefs?.getBool(_themeKey);
      if (isDarkMode != null) {
        _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme: $e');
      }
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      await _initPrefs();
      await _prefs?.setBool(_themeKey, isDark);
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving theme: $e');
      }
      // Still update UI even if save fails
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    await toggleTheme(mode == ThemeMode.dark);
  }

  // Convenience method to toggle without parameter
  Future<void> toggle() async {
    await toggleTheme(!isDarkMode);
  }

  // Clear saved theme preference
  Future<void> clearSavedTheme() async {
    try {
      await _initPrefs();
      await _prefs?.remove(_themeKey);
      _themeMode = ThemeMode.light;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing theme: $e');
      }
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ThemeNotifier extends ChangeNotifier {
//   final String key = "theme";
//   SharedPreferences? _prefs;
//   ThemeMode _themeMode = ThemeMode.light;
//
//   ThemeMode get themeMode => _themeMode;
//   bool get isDarkMode => _themeMode == ThemeMode.dark;
//
//   void toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
//
//   void setTheme(ThemeMode mode) {
//     _themeMode = mode;
//     notifyListeners();
//   }
// }
//
//
// // // theme_notifier.dart
// // import 'package:flutter/material.dart';
// //
// // class ThemeNotifier extends ChangeNotifier {
// //   ThemeMode _themeMode = ThemeMode.light;
// //
// //   ThemeMode get themeMode => _themeMode;
// //   bool get isDarkMode => _themeMode == ThemeMode.dark;
// //
// //   void toggleTheme(bool isDark) {
// //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     notifyListeners();
// //   }
// //
// //   void setTheme(ThemeMode mode) {
// //     _themeMode = mode;
// //     notifyListeners();
// //   }
// // }