import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_modifiers.dart';
import 'app_text_styles.dart';

/// Venyu ThemeData - Minimal theme with automatic platform adaptations
class VenyuThemeData {
  VenyuThemeData._();

  /// Main theme data - Let Flutter handle platform differences automatically
  static ThemeData get theme => ThemeData(
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
    
    // Let Flutter handle everything else automatically based on platform
    // This includes: page transitions, scroll physics, tab bar behavior, etc.
  );
  
  /// Cupertino theme for iOS - used by flutter_platform_widgets
  static CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
  );
}