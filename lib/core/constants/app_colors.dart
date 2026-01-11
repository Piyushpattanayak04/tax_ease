import 'package:flutter/material.dart';

/// Diamond Accounts color palette for Tax Ease app
/// Refined to a premium navy + teal fintech look with subtle neutrals
class AppColors {
  AppColors._();

  // ===== CORE BRAND COLORS =====
  /// Core brand colors derived from the Diamond Accounts logo
  static const Color brandNavy = Color(0xFF0A2B68); // Deep navy blue (primary)
  static const Color brandActionBlue = Color(0xFF1E50A0); // Action blue (CTA emphasis)
  static const Color brandTeal = Color(0xFF2FA4C7); // Matte teal-turquoise accent

  // ===== TEXT COLORS =====
  /// WCAG-friendly text colors
  static const Color textPrimary = Color(0xFF1C1C1E); // Primary text
  static const Color textSecondary = Color(0xFF5A5E66); // Secondary text

  // ===== LIGHT THEME COLORS =====
  /// Light theme palette for bright environments
  static const Color backgroundLight = Color(0xFFF2F4F8); // Scaffold background
  static const Color surfaceLight = Color(0xFFFFFFFF); // Card / surfaces
  static const Color surfaceVariantLight = Color(0xFFE5E9F2); // Elevated containers
  static const Color borderSubtleLight = Color(0xFFCED4DA); // Card & input borders

  static const Color primaryLight = brandNavy; // Primary actions & headers
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = brandActionBlue; // High-emphasis CTAs when needed
  static const Color onSecondaryLight = Color(0xFFFFFFFF);

  static const Color accentTealLight = brandTeal; // Active icons & progress

  static const Color errorLight = Color(0xFFD32F2F);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // ===== DARK THEME COLORS =====
  /// Dark theme palette with near-black scaffold and navy surfaces
  static const Color backgroundDark = Color(0xFF000000); // Near-black with navy hue
  static const Color surfaceDark = Color(0xFF0E172A); // Cards / surfaces
  static const Color surfaceVariantDark = Color(0xFF1B2435);
  static const Color borderSubtleDark = Color(0xFF404556);

  static const Color primaryDark = brandTeal; // Teal primary reads better on dark
  static const Color onPrimaryDark = Color(0xFF001320);
  static const Color secondaryDark = brandActionBlue;
  static const Color onSecondaryDark = Color(0xFFE6F0FF);

  static const Color accentTealDark = brandTeal;

  static const Color errorDark = Color(0xFFEF5350);
  static const Color onErrorDark = Color(0xFF1F0002);

  // ===== NEUTRALS =====
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

  static const Color disabledFill = Color(0xFFBDBDBD); // Disabled buttons

  // ===== STATUS COLORS =====
  static const Color success = Color(0xFF22A652); // Calmer green
  static const Color warning = Color(0xFFF3A712); // Softer amber
  static const Color error = errorLight;
  static const Color info = brandActionBlue;

  // ===== SURFACE & CONTAINER HELPERS =====
  static const Color containerLight = Color(0xFFEFF2F7); // Inputs / chips
  static const Color containerDark = Color(0xFF151B2A);

  // Legacy compatibility aliases (mapped to new palette)
  static const Color primary = brandNavy;
  static const Color secondary = brandActionBlue;
  static const Color accent = brandTeal;
  static const Color accentLight = brandTeal; // Prefer using accentTealLight
  static const Color accentDark = brandTeal;  // Prefer using accentTealDark

  // ===== SHADOW COLORS =====
  static const Color shadowLight = Color(0x14000000); // 8% black
  static const Color shadowMedium = Color(0x26000000); // 15% black
  static const Color shadowDark = Color(0x40000000); // 25% black

  // ===== DIAMOND ACCOUNTS COLORSCHEME (LIGHT) =====
  /// Primary: Deep Navy, Accent: Teal, Neutral scaffolds
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: onPrimaryLight,
    secondary: secondaryLight,
    onSecondary: onSecondaryLight,
    error: errorLight,
    onError: onErrorLight,
    background: backgroundLight,
    onBackground: textPrimary,
    surface: surfaceLight,
    onSurface: textPrimary,
    // Additional Material 3 colors
    primaryContainer: Color(0xFFD6E0F5),
    onPrimaryContainer: Color(0xFF041330),
    secondaryContainer: Color(0xFFD7E2F7),
    onSecondaryContainer: Color(0xFF08142C),
    tertiary: brandTeal,
    onTertiary: Color(0xFF001017),
    tertiaryContainer: Color(0xFFC8F1FA),
    onTertiaryContainer: Color(0xFF002630),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    outline: borderSubtleLight,
    outlineVariant: Color(0xFFDDE1EA),
    surfaceContainerHighest: surfaceVariantLight,
    onSurfaceVariant: textSecondary,
    inverseSurface: Color(0xFF1C2030),
    onInverseSurface: Color(0xFFF5F7FF),
    inversePrimary: brandTeal,
    shadow: shadowLight,
    scrim: black,
    surfaceTint: primaryLight,
  );

  // ===== DIAMOND ACCOUNTS COLORSCHEME (DARK) =====
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    secondary: secondaryDark,
    onSecondary: onSecondaryDark,
    error: errorDark,
    onError: onErrorDark,
    background: backgroundDark,
    onBackground: Color(0xFFE3E6F1),
    surface: surfaceDark,
    onSurface: Color(0xFFE3E6F1),
    primaryContainer: Color(0xFF12334A),
    onPrimaryContainer: Color(0xFFC3EEFF),
    secondaryContainer: Color(0xFF13325D),
    onSecondaryContainer: Color(0xFFD0E1FF),
    tertiary: brandTeal,
    onTertiary: Color(0xFF00151C),
    tertiaryContainer: Color(0xFF114D5F),
    onTertiaryContainer: Color(0xFFB7EAFF),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    outline: borderSubtleDark,
    outlineVariant: Color(0xFF2B3243),
    surfaceContainerHighest: surfaceVariantDark,
    onSurfaceVariant: Color(0xFFBDC3D4),
    inverseSurface: Color(0xFFE3E6F1),
    onInverseSurface: Color(0xFF11141F),
    inversePrimary: brandNavy,
    shadow: shadowDark,
    scrim: black,
    surfaceTint: primaryDark,
  );
}
