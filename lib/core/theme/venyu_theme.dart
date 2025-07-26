import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_modifiers.dart';
import 'app_text_styles.dart';
import 'app_spacing_theme.dart';

/// Venyu Theme Extension - Simple and clear theming
class VenyuTheme extends ThemeExtension<VenyuTheme> {
  // Background colors
  final Color pageBackground;
  final Color cardBackground;
  final Color tagBackground;
  final Color disabledBackground;
  
  // Text colors
  final Color primaryText;
  final Color secondaryText;
  final Color disabledText;
  
  // Border colors
  final Color borderColor;
  
  // Icon theming
  final String iconSuffix;
  
  const VenyuTheme({
    required this.pageBackground,
    required this.cardBackground,
    required this.tagBackground,
    required this.disabledBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.disabledText,
    required this.borderColor,
    required this.iconSuffix,
  });

  /// Light theme colors
  static const VenyuTheme light = VenyuTheme(
    pageBackground: AppColors.primair7Pearl,      // Pearl7 - page background
    cardBackground: Colors.white,                 // Pure white - OptionButton background
    tagBackground: AppColors.primair7Pearl,       // Pearl7 - TagView background (same as page)
    disabledBackground: AppColors.secundair7Cascadingwhite, // Light gray - disabled states
    primaryText: AppColors.secundair2Offblack,    // Dark text
    secondaryText: AppColors.secundair3Slategray, // Gray text
    disabledText: AppColors.secundair4Quicksilver, // Light gray text
    borderColor: AppColors.secundair6Rocket,      // Light border
    iconSuffix: '_outlined',                      // Light theme uses outlined icons
  );

  /// Dark theme colors
  static const VenyuTheme dark = VenyuTheme(
    pageBackground: AppColors.secundair1Deepblack,   // Deep black - page background
    cardBackground: AppColors.secundair2Offblack,    // Off black - OptionButton background
    tagBackground: AppColors.secundair3Slategray,    // Slate gray - TagView background
    disabledBackground: AppColors.secundair2Offblack, // Off black - disabled states
    primaryText: Colors.white,                       // White text
    secondaryText: AppColors.secundair5Pinball,      // Light gray text
    disabledText: AppColors.secundair4Quicksilver,   // Gray text
    borderColor: AppColors.secundair3Slategray,      // Gray border
    iconSuffix: '_white',                            // Dark theme uses white icons
  );

  @override
  ThemeExtension<VenyuTheme> copyWith({
    Color? pageBackground,
    Color? cardBackground,
    Color? tagBackground,
    Color? disabledBackground,
    Color? primaryText,
    Color? secondaryText,
    Color? disabledText,
    Color? borderColor,
    String? iconSuffix,
  }) {
    return VenyuTheme(
      pageBackground: pageBackground ?? this.pageBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      tagBackground: tagBackground ?? this.tagBackground,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      disabledText: disabledText ?? this.disabledText,
      borderColor: borderColor ?? this.borderColor,
      iconSuffix: iconSuffix ?? this.iconSuffix,
    );
  }

  @override
  ThemeExtension<VenyuTheme> lerp(ThemeExtension<VenyuTheme>? other, double t) {
    if (other is! VenyuTheme) return this;
    
    return VenyuTheme(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t)!,
      disabledBackground: Color.lerp(disabledBackground, other.disabledBackground, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      iconSuffix: t < 0.5 ? iconSuffix : other.iconSuffix, // String lerp: use threshold
    );
  }
}

/// Extension to easily access VenyuTheme from context
extension VenyuThemeAccess on BuildContext {
  VenyuTheme get venyuTheme {
    final theme = Theme.of(this).extension<VenyuTheme>();
    if (theme != null) return theme;
    
    // Fallback to light theme if extension not found
    return Theme.of(this).brightness == Brightness.dark 
        ? VenyuTheme.dark 
        : VenyuTheme.light;
  }
}

/// Venyu ThemeData - Complete theming solution
class VenyuThemeData {
  VenyuThemeData._();

  /// Light theme data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    
    // Basic color scheme (minimal setup)
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: Colors.white,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.secundair7Cascadingwhite,
      surfaceContainerHigh: AppColors.primair7Pearl,
      outline: AppColors.secundair6Rocket,
    ),
    
    // Page background - use VenyuTheme
    scaffoldBackgroundColor: VenyuTheme.light.pageBackground,
    
    // Text theme
    textTheme: const TextTheme().copyWith(
      headlineLarge: AppTextStyles.largeTitle,
      titleLarge: AppTextStyles.headline,
      bodyLarge: AppTextStyles.body,
    ),
    
    // Button theming
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
      ),
    ),
    
    // Extensions - this is where the magic happens
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacingTheme.defaultSpacing,
      VenyuTheme.light, // Our custom theme
    ],
  );
  
  /// Dark theme data
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Basic color scheme for dark mode
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.secundair2Offblack,
      surfaceContainerHighest: AppColors.secundair2Offblack,
      surfaceContainerHigh: AppColors.secundair3Slategray,
      outline: AppColors.secundair3Slategray,
      error: AppColors.error,
    ),
    
    // Page background - use VenyuTheme
    scaffoldBackgroundColor: VenyuTheme.dark.pageBackground,
    
    // Text theme
    textTheme: const TextTheme().copyWith(
      headlineLarge: AppTextStyles.largeTitle.copyWith(color: AppColors.white),
      titleLarge: AppTextStyles.headline.copyWith(color: AppColors.white),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.white),
    ),
    
    // Button theming
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        ),
      ),
    ),
    
    // Extensions
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacingTheme.defaultSpacing,
      VenyuTheme.dark, // Our custom theme
    ],
  );
  
  /// Light Cupertino theme for iOS
  static CupertinoThemeData get cupertinoLightTheme => CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: VenyuTheme.light.pageBackground,
    brightness: Brightness.light,
  );
  
  /// Dark Cupertino theme for iOS
  static CupertinoThemeData get cupertinoDarkTheme => CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: VenyuTheme.dark.pageBackground,
    brightness: Brightness.dark,
  );
}