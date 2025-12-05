import 'package:flutter/material.dart';
class AppTheme {
  // ----- Light Theme -----
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F9FB),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF820DFF),
      secondary: Color(0xFF2E7D32),
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFD4ACFF),
      onPrimary: Color(0xFFD4ACFF),
      onSecondary: Colors.white,
      onBackground: Color(0xFF0A0A0A),
      onSurface: Color(0xFF0A0A0A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0A0A0A),
      elevation: 0,
    ),
    fontFamily: 'Inter, Monserrat',
  );

  // ----- Dark Theme -----
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF101418),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF820DFF),
      secondary: Color(0xFF81C784),
      background: Color(0xFF21241F),
      surface: Color(0xFF323332),
      onPrimary: Color(0xFF323332),
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1F23),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    fontFamily: 'Inter, Monserrat',
  );

  // ----- Common Color Constants -----
  static const Color accentGreen = Color(0xFF05E584);
  static const Color lightBackground = Color(0xFFF7F9FB);
  static const Color darkBackground = Color(0xFF101418);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1C1F23);
  static const Color textDark = Color(0xFF0A0A0A);
  static const Color textLight = Colors.white70;
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2A2A2A);
}
