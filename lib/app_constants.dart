import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const String _fontFamily = 'Montserrat'; // Adjusted font family name

  static final TextStyle headline = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 80,
    color: const Color(0xFFBD2D29),
    shadows: [
      Shadow(
        offset: Offset(0, 2), // Position the shadow below the text
        blurRadius: 3.0, // Adjust the blur radius as needed
        color: Colors.black
            .withOpacity(0.5), // Adjust the shadow color and opacity
      ),
    ],
  );

  static final TextStyle subheading = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFBD2D29),
    shadows: [
      Shadow(
        offset: Offset(0, 2), // Position the shadow below the text
        blurRadius: 3.0, // Adjust the blur radius as needed
        color: Colors.black
            .withOpacity(0.5), // Adjust the shadow color and opacity
      ),
    ],
  );

  static final TextStyle subheading2 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFF2F2F2),
    shadows: [
      Shadow(
        offset: Offset(0, 2), // Position the shadow below the text
        blurRadius: 3.0, // Adjust the blur radius as needed
        color: Colors.black
            .withOpacity(0.5), // Adjust the shadow color and opacity
      ),
    ],
  );

  static final TextStyle subheading3 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 38,
    color: const Color(0xFFF2F2F2),
    shadows: [
      Shadow(
        offset: Offset(0, 2), // Position the shadow below the text
        blurRadius: 3.0, // Adjust the blur radius as needed
        color: Colors.black
            .withOpacity(0.5), // Adjust the shadow color and opacity
      ),
    ],
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

  static final TextStyle bodyHintTexts = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 10,
    color: const Color(0xFFF2F2F2),
  );

  static final TextStyle bodyHintTexts2 = GoogleFonts.getFont(
    _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 10,
    color: const Color(0x00008ecc),
  );
}

class AppColors {
  static const Color primary = Color(0xFFD92B4B);
  static const Color primaryVariant = Color(0xFFF24171);
  static const Color secondary = Color(0xFFF2F2F2);
  static const Color tertiary = Color(0xFF656573);
  static const Color tertiaryVariant = Color(0xFF363740);
}
