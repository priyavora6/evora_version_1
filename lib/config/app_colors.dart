import 'package:flutter/material.dart';

class AppColors {
  // -------------------
  // 💎 Core Theme Colors (Matched to Logo)
  // -------------------
  static const Color primary = Color(0xFF1B2F5E);
  static const Color secondary = Color(0xFFC59D89);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9F6F3);
  static const Color error = Color(0xFFD9534F);

  // -------------------
  // 🌑 Dark Theme Colors
  // -------------------
  // A deep, rich navy-charcoal that feels premium
  static const Color backgroundDark = Color(0xFF0F172A);
  // Slightly lighter for cards in dark mode
  static const Color surfaceDark = Color(0xFF1E293B);
  // Light gold/off-white for text in dark mode
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // -------------------
  // ✍️ Text Colors (Light Mode)
  // -------------------
  static const Color textPrimary = Color(0xFF1B2F5E);
  static const Color textSecondary = Color(0xFF7D726E);
  static const Color textHint = Color(0xFFAAB2C2);

  // -------------------
  // 🖼️ UI Component Colors
  // -------------------
  static const Color border = Color(0xFFE6DCD6);
  static const Color divider = Color(0xFFF2EBE5);
  static const Color disabled = Color(0xFFE0E0E0);

  // -------------------
  // 🎨 Detailed Palette
  // -------------------

  // 🔵 Royal Navy Palette
  static const Color primaryNavy = Color(0xFF1B2F5E);
  static const Color navyLight = Color(0xFF324A7E);
  static const Color navyDark = Color(0xFF0F1E3D);

  // 🌸 Rose Gold Palette
  static const Color roseGold = Color(0xFFC59D89);
  static const Color roseGoldDark = Color(0xFFA67C69);
  static const Color roseGoldLight = Color(0xFFE3C9BC);
  static const Color roseGoldShimmer = Color(0xFFF2E6DF);

  // 🤍 Backgrounds
  static const Color softCream = Color(0xFFF9F6F3);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // ✅ Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFE8A838);

  // 🌟 Premium Gradients

  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF1B2F5E), Color(0xFF0F1E3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGoldGradient = LinearGradient(
    colors: [Color(0xFFC59D89), Color(0xFFE3C9BC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalGradient = LinearGradient(
    colors: [Color(0xFF1B2F5E), Color(0xFF5B3E31)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🔥 New Dark Gradient for Dark Mode Banners
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}