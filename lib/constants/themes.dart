import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFFD92B4B);
  static const Color lightPrimaryVariant = Color(0xFFF24171);
  static const Color lightSecondary = Color(0xFFF2F2F2);
  static const Color lightTertiary = Color(0xFF656573);
  static const Color lightTertiaryVariant = Color(0xFF363740);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF1E1E1E);
  static const Color darkPrimaryVariant = Color(0xFFF24171);
  static const Color darkSecondary = Color(0xFF2E2E2E);
  static const Color darkTertiary = Color(0xFF757575);
  static const Color darkTertiaryVariant = Color(0xFF424242);
}

class AppTextStyles {
  static const String _fontFamily = 'Montserrat';

  // Light theme text styles
  static final TextStyle lightHeadline = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 80,
    color: AppColors.lightPrimary,
    shadows: [
      Shadow(
        offset: const Offset(0, 2),
        blurRadius: 3.0,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  );

  // Define other light theme text styles similarly

  // Dark theme text styles
  static final TextStyle darkHeadline = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 80,
    color: AppColors.darkPrimary,
    shadows: [
      Shadow(
        offset: const Offset(0, 2),
        blurRadius: 3.0,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  );

  // Define other dark theme text styles similarly
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryVariant,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSecondary,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.lightHeadline,
      // Add other text styles here
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryVariant,
      secondary: AppColors.darkTertiary,
      surface: AppColors.darkSecondary,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.darkHeadline,
      // Add other text styles here
    ),
  );
}
