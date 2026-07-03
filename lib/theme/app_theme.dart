import 'package:flutter/material.dart';

/// Minimal Black & White theme (DocuKit-style).
class AppTheme {
  static const Color black = Color(0xFF0A0A0A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8A8A8A);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color danger = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFB8860B);
  static const Color safe = Color(0xFF1B5E20);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: black,
        onPrimary: white,
        secondary: black,
        surface: white,
        onSurface: black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black,
          side: const BorderSide(color: black, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: black,
        foregroundColor: white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardTheme(                      // ✅ Changed from CardThemeData
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
      ),
    );
  }
}