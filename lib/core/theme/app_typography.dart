import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium mobile typography system for Tax Ease
/// Uses Inter (Google Fonts) with a Material 3-aligned type scale
class AppTypography {
  AppTypography._();

  // Base font families
  static const String primaryFontFamily = 'Inter';
  static const String altHeadingFontFamily = 'Poppins'; // Optional for headings if desired

  // === Core style helpers ===
  static TextStyle _inter(
    double size, {
    FontWeight weight = FontWeight.w400,
    double? height,
    double letterSpacing = 0,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height ?? (size >= 20 ? 1.2 : 1.4),
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle _poppins(
    double size, {
    FontWeight weight = FontWeight.w600,
    double? height,
    double letterSpacing = 0,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      height: height ?? 1.2,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // === Type scale (key roles) ===
  /// Display Large – used sparingly for hero numbers/headlines
  static TextStyle get displayLarge => _inter(
        32,
        weight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  /// Title Large – primary section titles
  static TextStyle get titleLarge => _inter(
        20,
        weight: FontWeight.w600,
        letterSpacing: 0.0,
      );

  /// Body Medium – primary body copy
  static TextStyle get bodyMedium => _inter(
        14,
        weight: FontWeight.w400,
        letterSpacing: 0.1,
      );

  /// Label Small – chips, helper labels, meta text
  static TextStyle get labelSmall => _inter(
        11,
        weight: FontWeight.w500,
        letterSpacing: 0.3,
      );

  // === Legacy-style helpers mapped onto Inter ===
  static TextStyle get h1Large => _poppins(32, weight: FontWeight.w600, letterSpacing: -0.2);
  static TextStyle get h1Medium => _poppins(28, weight: FontWeight.w600, letterSpacing: -0.1);

  static TextStyle get h2Large => _poppins(24, weight: FontWeight.w600);
  static TextStyle get h2Medium => _poppins(22, weight: FontWeight.w600);

  static TextStyle get h2Futura => _poppins(20, weight: FontWeight.w500);
  static TextStyle get h2FuturaSmall => _poppins(18, weight: FontWeight.w500);

  static TextStyle get h3Tiempos => _poppins(20, weight: FontWeight.w500);
  static TextStyle get h3Futura => _poppins(18, weight: FontWeight.w500);
  static TextStyle get h3FuturaSmall => _poppins(16, weight: FontWeight.w500);
  static TextStyle get h3FuturaMini => _poppins(14, weight: FontWeight.w500);

  static TextStyle get largeTitle => _poppins(20, weight: FontWeight.w600);
  static TextStyle get heading => titleLarge;

  /// Body text
  static TextStyle get bodyLarge => _inter(16);
  static TextStyle get body => _inter(14);
  static TextStyle get bodySmall => _inter(13);
  static TextStyle get bodyXSmall => _inter(12);

  static TextStyle get largeBodyExpanded => _inter(16, height: 1.5);
  static TextStyle get largeBody => _inter(16);
  static TextStyle get smallBody => _inter(12);

  /// Links
  static TextStyle get linkLarge => _inter(16, weight: FontWeight.w500);
  static TextStyle get linkMedium => _inter(15, weight: FontWeight.w500);
  static TextStyle get link => _inter(14, weight: FontWeight.w500);
  static TextStyle get linkSmall => _inter(13, weight: FontWeight.w500);
  static TextStyle get linkXSmall => _inter(12, weight: FontWeight.w500);

  /// Buttons & labels
  static TextStyle get button => _inter(14, weight: FontWeight.w600, letterSpacing: 0.3);
  static TextStyle get buttonSmall => _inter(13, weight: FontWeight.w600, letterSpacing: 0.2);

  static TextStyle get label => _inter(13, weight: FontWeight.w500, letterSpacing: 0.2);
  static TextStyle get labelMedium => labelSmall;

  /// Material 3 TextTheme mapping using Inter
  static TextTheme buildTextTheme(Brightness brightness, {Color? baseColor}) {
    final bool isLight = brightness == Brightness.light;
    final Color primaryColor = baseColor ?? (isLight ? const Color(0xFF1C1C1E) : const Color(0xFFE3E6F1));
    final Color secondaryColor = isLight ? const Color(0xFF5A5E66) : const Color(0xFFB7BCC8);

    return TextTheme(
      // Display / headline
      displayLarge: displayLarge.copyWith(color: primaryColor),
      displayMedium: _inter(28, weight: FontWeight.w600, letterSpacing: -0.1, color: primaryColor),
      displaySmall: _inter(24, weight: FontWeight.w600, color: primaryColor),

      headlineLarge: _inter(22, weight: FontWeight.w600, color: primaryColor),
      headlineMedium: _inter(20, weight: FontWeight.w600, color: primaryColor),
      headlineSmall: _inter(18, weight: FontWeight.w600, color: primaryColor),

      // Titles
      titleLarge: titleLarge.copyWith(color: primaryColor),
      titleMedium: _inter(16, weight: FontWeight.w500, color: primaryColor),
      titleSmall: _inter(14, weight: FontWeight.w500, color: secondaryColor),

      // Body
      bodyLarge: _inter(16, weight: FontWeight.w400, color: primaryColor),
      bodyMedium: bodyMedium.copyWith(color: primaryColor),
      bodySmall: _inter(12, weight: FontWeight.w400, color: secondaryColor),

      // Labels
      labelLarge: button.copyWith(color: primaryColor),
      labelMedium: _inter(12, weight: FontWeight.w500, letterSpacing: 0.3, color: secondaryColor),
      labelSmall: labelSmall.copyWith(color: secondaryColor),
    );
  }

  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get text style with custom opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withValues(alpha: opacity));
  }
}
