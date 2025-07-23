import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'app_colors.dart';
import 'app_modifiers.dart';
import 'app_text_styles.dart';

/// Venyu Custom ThemeData - Cross-platform consistent theme
class VenyuThemeData {
  VenyuThemeData._();

  /// Main theme data for the app
  static ThemeData get theme => ThemeData(
    // Use Material 3 for modern Android experience
    useMaterial3: true,
    
    // Platform-specific effects (dit geldt voor ALLE widgets)
    splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
    highlightColor: Platform.isAndroid ? null : Colors.transparent,
    splashColor: Platform.isAndroid ? null : Colors.transparent,
    
    // Primary colors
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    
    // Color scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.white,
      onTertiary: AppColors.textOnAccent,
      onSurface: AppColors.textPrimary,
      onError: AppColors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.background,
    
    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: Platform.isIOS, // Platform-specifiek
      titleTextStyle: AppTextStyles.headline,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    
    // Text theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.extraLargeTitle,
      displayMedium: AppTextStyles.largeTitle,
      displaySmall: AppTextStyles.title1,
      headlineLarge: AppTextStyles.extraLargeTitle2,
      headlineMedium: AppTextStyles.title2,
      headlineSmall: AppTextStyles.title3,
      titleLarge: AppTextStyles.headline,
      titleMedium: AppTextStyles.subheadline,
      titleSmall: AppTextStyles.callout,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.callout,
      bodySmall: AppTextStyles.footnote,
      labelLarge: AppTextStyles.headline,
      labelMedium: AppTextStyles.subheadline,
      labelSmall: AppTextStyles.caption1,
    ),
    
    // Button theme - GEEN splashFactory nodig, gebruikt automatisch de theme-level instelling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTextStyles.headline,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.headline,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.headline,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Icon button theme - leeg want gebruikt standaard theme waarden
    // iconButtonTheme kan volledig weg als je geen custom styling nodig hebt
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(color: AppColors.secondaryLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(color: AppColors.secondaryLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),
      labelStyle: AppTextStyles.subheadline,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.secondaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      ),
    ),
    
    // Divider theme
    dividerTheme: DividerThemeData(
      color: AppColors.secondaryLight,
      thickness: 1,
      space: 1,
    ),
    
    // Icon theme
    iconTheme: IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      selectedLabelStyle: AppTextStyles.caption1,
      unselectedLabelStyle: AppTextStyles.caption1,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Page transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        // iOS/macOS uses Cupertino transitions
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        // Android uses Material transitions
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        // Others use fade transitions
        TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}