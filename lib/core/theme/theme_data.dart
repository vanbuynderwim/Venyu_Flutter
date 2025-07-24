import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_modifiers.dart';
import 'app_text_styles.dart';
import 'app_spacing_theme.dart';

/// Venyu ThemeData - Minimal theme with automatic platform adaptations
class VenyuThemeData {
  VenyuThemeData._();

  /// Light theme data - Let Flutter handle platform differences automatically
  static ThemeData get lightTheme => ThemeData(
    // Use Material 3 - Flutter automatically adapts behavior per platform
    useMaterial3: true,
    
    // Color scheme - Flutter handles platform-specific color adaptations
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    
    // Scaffold - Let Flutter use platform defaults
    scaffoldBackgroundColor: AppColors.background,
    
    // Only override essential text styles, let Flutter handle the rest
    textTheme: const TextTheme().copyWith(
      headlineLarge: AppTextStyles.largeTitle,
      titleLarge: AppTextStyles.headline,
      bodyLarge: AppTextStyles.body,
    ),
    
    // Minimal button theming - let Flutter handle platform behavior
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
      ),
    ),
    
    // Custom spacing theme extension
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacingTheme.defaultSpacing,
    ],
    
    // Let Flutter handle everything else automatically based on platform
    // This includes: page transitions, scroll physics, tab bar behavior, etc.
  );
  
  /// Light Cupertino theme for iOS - used by flutter_platform_widgets
  static CupertinoThemeData get cupertinoLightTheme => CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,
  );
  
  /// Dark theme data
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Dark color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
    
    // Dark scaffold background
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // Dark text theme
    textTheme: const TextTheme().copyWith(
      headlineLarge: AppTextStyles.largeTitle.copyWith(color: AppColors.white),
      titleLarge: AppTextStyles.headline.copyWith(color: AppColors.white),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.white),
    ),
    
    // Dark button theming
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
      ),
    ),
    
    // Custom spacing theme extension (same for both themes)
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacingTheme.defaultSpacing,
    ],
  );
  
  /// Dark Cupertino theme for iOS
  static CupertinoThemeData get cupertinoDarkTheme => CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    brightness: Brightness.dark,
  );
}