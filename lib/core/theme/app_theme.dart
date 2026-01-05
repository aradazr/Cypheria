import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme([Locale? locale]) {
    final fontFamily = locale?.languageCode == 'fa' ? 'PelakFA' : null;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF6366F1),
        secondary: const Color(0xFF8B5CF6),
        surface: const Color(0xFF1E1E2E),
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E2E),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E1E2E),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      fontFamily: fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontFamily: fontFamily),
        displayMedium: TextStyle(color: Colors.white, fontFamily: fontFamily),
        displaySmall: TextStyle(color: Colors.white, fontFamily: fontFamily),
        headlineLarge: TextStyle(color: Colors.white, fontFamily: fontFamily),
        headlineMedium: TextStyle(color: Colors.white, fontFamily: fontFamily),
        headlineSmall: TextStyle(color: Colors.white, fontFamily: fontFamily),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(color: Colors.white, fontFamily: fontFamily),
        titleSmall: TextStyle(color: Colors.white, fontFamily: fontFamily),
        bodyLarge: TextStyle(color: Colors.white70, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: Colors.white70, fontFamily: fontFamily),
        bodySmall: TextStyle(color: Colors.white60, fontFamily: fontFamily),
      ),
    );
  }

  static ThemeData lightTheme([Locale? locale]) {
    final fontFamily = locale?.languageCode == 'fa' ? 'PelakFA' : null;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF6366F1),
        secondary: const Color(0xFF8B5CF6),
        surface: const Color(0xFFF5F5F5),
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(fontFamily: fontFamily),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: TextStyle(fontFamily: fontFamily),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      fontFamily: fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        displayMedium: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        displaySmall: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        headlineLarge: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        headlineMedium: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        headlineSmall: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        titleLarge: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        titleSmall: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        bodyLarge: TextStyle(color: Colors.black54, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: Colors.black54, fontFamily: fontFamily),
        bodySmall: TextStyle(color: Colors.black45, fontFamily: fontFamily),
      ),
    );
  }
}

