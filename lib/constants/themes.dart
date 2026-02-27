import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF5F52EE);
  static const Color lightSecondary = Color(0xFFDA4040);
  static const Color lightBackground = Color(0xFFEEEFF5);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF3A3A3A);
  static const Color lightTextSecondary = Color(0xFF717171);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF7B6FFF);
  static const Color darkSecondary = Color(0xFFFF6B6B);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Priority Colors (same for both themes)
  static const Color priorityHigh = Color(0xFFDA4040);
  static const Color priorityMedium = Color(0xFFFFA500);
  static const Color priorityLow = Color(0xFF4CAF50);

  // Category Colors
  static const Color categoryHealth = Color(0xFF4CAF50);
  static const Color categoryProductivity = Color(0xFF2196F3);
  static const Color categorySocial = Color(0xFFFF9800);
  static const Color categoryOther = Color(0xFF9E9E9E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: lightTextSecondary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightSecondary,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: lightTextSecondary,
        thickness: 0.5,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkSecondary,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: darkTextSecondary,
        thickness: 0.5,
      ),
    );
  }

  // Helper method to get category color
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return categoryHealth;
      case 'productivity':
        return categoryProductivity;
      case 'social':
        return categorySocial;
      default:
        return categoryOther;
    }
  }

  // Helper method to get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return priorityHigh;
      case 'low':
        return priorityLow;
      default:
        return priorityMedium;
    }
  }
}
