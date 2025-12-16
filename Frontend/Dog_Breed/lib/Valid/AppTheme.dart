import 'package:flutter/material.dart';

class AppTheme {
  // ----- Light Theme -----
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F9FB),
    colorScheme:  ColorScheme.light(
      primary: const Color(0xFF820DFF),
      secondary: const Color(0xFF00D9FF).withOpacity(0.1),
      background: const Color(0xFFF7F9FB),
      onBackground: const Color(0xFF7B2CBF),
      surface: const Color(0xFF323332),
      onPrimary: const Color(0xFF371B34),
      onSurface: const Color(0xFF0A0A0A),
      onSecondary: const Color(0xFF000000),
        tertiary:const Color(0xFF7B2CBF),
        onTertiary: const Color(0xFF820DFF),
        tertiaryContainer: const Color(0xFFF2F5F4),
        surfaceBright:const Color(0xFFCBE4DC),
        secondaryContainer: const Color(0xFFF4F7F6),
        surfaceContainerLow:const Color(0xFFF3F6F3),
        surfaceContainerHigh:const Color(0xFFD4ACFF),
        surfaceContainerHighest: const Color(0xFF7B2CBF),
       surfaceContainerLowest: const Color(0xFF512717),
        surfaceContainer: const Color(0xFF7B2CBF),


    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0A0A0A),
      elevation: 0,
    ),
    fontFamily: 'Inter',
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF101418),
    colorScheme:  ColorScheme.dark(
      primary: const Color(0xFF820DFF),
      secondary: const Color(0xFF21241F).withOpacity(0.1),
      background: const Color(0xFF21241F),
      onBackground: const Color(0xFF21241F),
      surface: const Color(0xFF323332),
      onPrimary: const Color(0xFF371B34),
        onSecondary: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFFFFFFFF),
      tertiary:const Color(0xFFFFFFFF),
      onTertiary: const Color(0xFF323332),
      tertiaryContainer: const Color(0xFF323332),
      surfaceBright:const Color(0xFF323332),
      secondaryContainer: const Color(0xFF323332),
      surfaceContainerLow:const Color(0xFF353635),
      surfaceContainerHigh:const Color(0xFF353635),
      surfaceContainerHighest: const Color(0xFF21241F),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFFFFFFF)


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


