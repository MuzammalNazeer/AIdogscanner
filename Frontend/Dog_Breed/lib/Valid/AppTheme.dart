import 'package:flutter/material.dart';

class AppTheme {
  // ----- Light Theme -----
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F9FB),

    colorScheme:  ColorScheme.light(
      primary: Color(0xFF820DFF),
      secondary: Color(0xFF00D9FF).withOpacity(0.1),
      background: Color(0xFFF7F9FB),
      onBackground: Color(0xFF7B2CBF),
      surface: Color(0xFF323332),
      onPrimary: Color(0xFF371B34),
      onSurface: Color(0xFF0A0A0A),
      onSecondary: Colors.black,

    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0A0A0A),
      elevation: 0,
    ),

    fontFamily: 'Inter',
  );

  // ----- Dark Theme -----
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF101418),

    colorScheme:  ColorScheme.dark(
      primary: const Color(0xFF820DFF),
      secondary: const Color(0xFF21241F).withOpacity(0.1),
      background: const Color(0xFF21241F),
      onBackground: const Color(0xFF21241F),
      surface: Color(0xFF323332),
      onPrimary: Color(0xFF371B34),
      onSecondary: Colors.black,
      onSurface: Color(0xFFFFFFFF),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1F23),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    fontFamily: 'Inter',
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


// import 'package:flutter/material.dart';
// class AppTheme {
//   // ----- Light Theme -----
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: const Color(0xFFF7F9FB),
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFF820DFF),
//       secondary: Color(0xFF2E7D32),
//       background: Color(0xFFFFFFFF),
//       onBackground: Color(0xFF7B2CBF),
//       surface: Color(0xFFD4ACFF),
//       onPrimary: Color(0xFF371B34),
//       onSecondary: Colors.white,
//       onSurface: Color(0xFF0A0A0A),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF0A0A0A),
//       elevation: 0,
//     ),
//     fontFamily: 'Inter, Monserrat',
//   );
//
//   // ----- Dark Theme -----
//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF101418),
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF820DFF),
//       secondary: Color(0xFF81C784),
//       background: Color(0xFF21241F),
//       onBackground: Color(0xFF21241F),    // Dark greenish background for onboarding
//       surface: Color(0xFF323332),
//       onPrimary: Color(0xFF371B34),
//       onSecondary: Colors.black,
//       onSurface: Colors.white,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF1C1F23),
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     fontFamily: 'Inter, Monserrat',
//   );
//
//   // ----- Common Color Constants -----
//   static const Color accentGreen = Color(0xFF05E584);
//   static const Color lightBackground = Color(0xFFF7F9FB);
//   static const Color darkBackground = Color(0xFF101418);
//   static const Color cardLight = Colors.white;
//   static const Color cardDark = Color(0xFF1C1F23);
//   static const Color textDark = Color(0xFF0A0A0A);
//   static const Color textLight = Colors.white70;
//   static const Color dividerLight = Color(0xFFE0E0E0);
//   static const Color dividerDark = Color(0xFF2A2A2A);
// }
