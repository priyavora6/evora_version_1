import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  // -------------------
  // Font Families
  // -------------------

  /// Elegant, serif font for headings and display text. Gives a premium feel.
  static const String primary = 'Cormorant';

  /// Clean, sans-serif font for body text. Ensures readability.
  static const String secondary = 'Jost';

  @Deprecated('Use primary instead')
  static const String displayFont = primary;

  @Deprecated('Use secondary instead')
  static const String bodyFont = secondary;

  // -------------------
  // Text Styles
  // -------------------

  // Heading Styles (using the primary font)
  static const TextStyle h1 = TextStyle(
    fontFamily: primary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: primary,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: primary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Styles (using the secondary font)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Label & Caption Styles
  static const TextStyle label = TextStyle(
    fontFamily: secondary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint, // Using textHint now
    letterSpacing: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: secondary,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint, // Using textHint now
    letterSpacing: 1.0,
  );

  // Button Style
  static const TextStyle button = TextStyle(
    fontFamily: secondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
  );

  // Special-purpose Styles
  static const TextStyle price = TextStyle(
    fontFamily: primary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary, // Aligned with primary theme color
  );
}
