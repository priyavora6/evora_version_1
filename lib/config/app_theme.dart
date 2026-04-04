import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: isDark ? AppColors.surfaceDark : AppColors.surface,
        onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : Colors.white,
        ),
      ),

      textTheme: TextTheme(
        displayLarge: AppFonts.h1.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        bodyLarge: AppFonts.bodyLarge.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        bodyMedium: AppFonts.bodyMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
      ),

      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: isDark ? Colors.white54 : AppColors.textSecondary,
      ),
    );
  }
}
