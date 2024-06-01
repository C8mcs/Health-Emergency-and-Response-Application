import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const String _fontFamily = 'Montserrat'; // Adjusted font family name

  static final TextStyle headline = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 80,
    color: const Color(0xFFBD2D29),
  );

  static final TextStyle subheading = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFBD2D29),
  );

  static final TextStyle subheading2 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFF2F2F2),
  );

  static final TextStyle bodyText1 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFF2F2F2),
  );

  static final TextStyle bodyText2 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: const Color(0xFF656573),
  );
}

class AppColors {
  static const Color primary = Color(0xFFD92B4B);
  static const Color primaryVariant = Color(0xFFF24171);
  static const Color secondary = Color(0xFFF2F2F2);
  static const Color tertiary = Color(0xFF656573);
  static const Color tertiaryVariant = Color(0xFF363740);
}
