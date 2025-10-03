import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Premium app theme configuration for Tax Ease
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        
        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.white,
          surface: AppColors.surface,
          onSurface: AppColors.grey800,
          background: AppColors.backgroundLight,
          onBackground: AppColors.grey800,
          error: AppColors.error,
          onError: AppColors.white,
        ),

        // Typography
        textTheme: _buildTextTheme(Brightness.light),
        
        // App bar theme
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.grey800,
          titleTextStyle: _buildTextTheme(Brightness.light).headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey800,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),

        // Card theme
        cardTheme: CardThemeData(
          elevation: AppDimensions.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          color: AppColors.cardLight,
          shadowColor: AppColors.shadowLight,
        ),

        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
            minimumSize: const Size(0, AppDimensions.buttonHeightLg),
            textStyle: const TextStyle(
              inherit: true,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.grey100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.grey300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          contentPadding: const EdgeInsets.all(AppDimensions.spacingMd),
          labelStyle: TextStyle(color: AppColors.grey600),
          hintStyle: TextStyle(color: AppColors.grey500),
        ),

        // Bottom navigation bar theme (using custom floating nav)
        // bottomNavigationBarTheme removed as we use custom implementation

        // Floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),

        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.grey200,
          thickness: 1,
          space: 1,
        ),

        // Page transitions for smooth animations
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),

        // Scroll behavior for smooth scrolling
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(AppColors.grey400),
          trackColor: MaterialStateProperty.all(AppColors.grey200),
          thickness: MaterialStateProperty.all(4.0),
          radius: const Radius.circular(AppDimensions.radiusSm),
        ),

        // Visual density for premium feel
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Splash factory for ripple effects
        splashFactory: InkRipple.splashFactory,
      );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        
        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.black,
          secondary: AppColors.secondary,
          onSecondary: AppColors.black,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.white,
          background: AppColors.backgroundDark,
          onBackground: AppColors.white,
          error: AppColors.error,
          onError: AppColors.white,
        ),

        // Typography
        textTheme: _buildTextTheme(Brightness.dark),
        
        // App bar theme
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.white,
          titleTextStyle: _buildTextTheme(Brightness.dark).headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),

        // Card theme
        cardTheme: CardThemeData(
          elevation: AppDimensions.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          color: AppColors.cardDark,
          shadowColor: AppColors.shadowDark,
        ),

        // Elevated button theme for dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
            minimumSize: const Size(0, AppDimensions.buttonHeightLg),
            textStyle: const TextStyle(
              inherit: true,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text button theme for dark mode
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
          ),
        ),

        // Input decoration theme for dark mode
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.grey800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.grey600, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          contentPadding: const EdgeInsets.all(AppDimensions.spacingMd),
          labelStyle: TextStyle(color: AppColors.grey400),
          hintStyle: TextStyle(color: AppColors.grey500),
        ),

        // Bottom navigation bar theme for dark mode (using custom floating nav)
        // bottomNavigationBarTheme removed as we use custom implementation

        // Floating action button theme for dark mode
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),

        // Divider theme for dark mode
        dividerTheme: const DividerThemeData(
          color: AppColors.grey600,
          thickness: 1,
          space: 1,
        ),

        // Page transitions for smooth animations
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),

        // Scroll behavior for smooth scrolling
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(AppColors.grey400),
          trackColor: MaterialStateProperty.all(AppColors.grey700),
          thickness: MaterialStateProperty.all(4.0),
          radius: const Radius.circular(AppDimensions.radiusSm),
        ),

        // Visual density for premium feel
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Splash factory for ripple effects
        splashFactory: InkRipple.splashFactory,
      );

  /// Build custom text theme with consistent inherit values
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light 
        ? AppColors.grey800 
        : AppColors.white;
    
    return TextTheme(
      displayLarge: TextStyle(
        inherit: true,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: baseColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        inherit: true,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        inherit: true,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        inherit: true,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        inherit: true,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        inherit: true,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        inherit: true,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        inherit: true,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        inherit: true,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        inherit: true,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        inherit: true,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        inherit: true,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: baseColor.withOpacity(0.7),
        height: 1.5,
      ),
      labelLarge: TextStyle(
        inherit: true,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        inherit: true,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        inherit: true,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: baseColor.withOpacity(0.7),
        height: 1.4,
      ),
    );
  }
}
