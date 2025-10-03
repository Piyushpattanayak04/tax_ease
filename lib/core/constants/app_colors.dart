import 'package:flutter/material.dart';

/// Premium color palette for Tax Ease app with cyan/turquoise theme
class AppColors {
  AppColors._();

  // Primary cyan/turquoise colors
  static const Color primary = Color(0xFF00BCD4); // Main cyan
  static const Color primaryLight = Color(0xFF62EFFF); // Light cyan
  static const Color primaryDark = Color(0xFF008BA3); // Dark cyan
  
  // Secondary colors
  static const Color secondary = Color(0xFF26A69A); // Teal
  static const Color secondaryLight = Color(0xFF64D8CB); // Light teal
  static const Color secondaryDark = Color(0xFF00766C); // Dark teal
  
  // Accent colors for premium feel
  static const Color accent = Color(0xFF4DD0E1); // Bright cyan
  static const Color accentLight = Color(0xFF88FFFF); // Very light cyan
  static const Color accentDark = Color(0xFF009FAF); // Deep cyan
  
  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF2196F3);
  
  // Background colors for premium look
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Card and container colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color containerLight = Color(0xFFF8F9FA);
  static const Color containerDark = Color(0xFF1A1A1A);
  
  // Gradient colors for premium animations
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary, secondaryDark],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accent, accentDark],
  );
  
  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}
