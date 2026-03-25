import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFE53935);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color black = Color(0xFF080808);
  static const Color darkGrey = Color(0xFF141414);
  static const Color cardGrey = Color(0xFF1E1E1E);
  static const Color surfaceGrey = Color(0xFF2A2A2A);
  static const Color borderGrey = Color(0xFF333333);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        onPrimary: white,
        secondary: accentRed,
        onSecondary: white,
        surface: cardGrey,
        onSurface: white,
        error: Color(0xFFFF6B6B),
      ),
      scaffoldBackgroundColor: black,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: GoogleFonts.poppins(
              color: white,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: GoogleFonts.poppins(color: white),
            bodyLarge: GoogleFonts.poppins(color: white),
            bodyMedium: GoogleFonts.poppins(color: textGrey),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: black,
        foregroundColor: white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: white),
      ),
      cardTheme: CardThemeData(
        color: cardGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: white,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
        ),
        labelStyle: const TextStyle(color: textGrey),
        hintStyle: TextStyle(color: textGrey.withValues(alpha: 0.6)),
        prefixIconColor: primaryRed,
        suffixIconColor: textGrey,
      ),
      dividerTheme: const DividerThemeData(color: borderGrey, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardGrey,
        contentTextStyle: GoogleFonts.poppins(color: white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.poppins(
          color: white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.poppins(color: textGrey, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceGrey,
        selectedColor: primaryRed.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.poppins(color: white, fontSize: 13),
        side: const BorderSide(color: borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
