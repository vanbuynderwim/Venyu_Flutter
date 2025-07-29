import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_modifiers.dart';
import 'app_text_styles.dart';
import 'app_spacing_theme.dart';

/// Custom theme extension providing Venyu-specific design tokens.
/// 
/// This theme extension defines the complete visual language for the Venyu app,
/// including colors, backgrounds, text styles, and platform-specific assets.
/// It supports both light and dark mode with automatic adaptation.
/// 
/// The theme is designed to:
/// - Provide consistent visual identity across the app
/// - Support accessibility requirements
/// - Enable easy theming and customization
/// - Maintain platform-specific design patterns
/// 
/// Example usage:
/// ```dart
/// // Access theme colors
/// final theme = context.venyuTheme;
/// Container(color: theme.cardBackground)
/// 
/// // Use in text styling
/// Text('Hello', style: TextStyle(color: theme.primaryText))
/// ```
class VenyuTheme extends ThemeExtension<VenyuTheme> {
  /// Main page/screen background color.
  final Color pageBackground;
  
  /// Card and container background color.
  final Color cardBackground;
  
  /// Background color for tag components.
  final Color tagBackground;
  
  /// Background color for disabled elements.
  final Color disabledBackground;
  
  /// Primary text color for headings and important content.
  final Color primaryText;
  
  /// Secondary text color for descriptions and supporting content.
  final Color secondaryText;
  
  /// Text color for disabled elements.
  final Color disabledText;
  
  /// Color for borders, dividers, and outline elements.
  final Color borderColor;
  
  /// Background color for secondary buttons.
  final Color secondaryButtonBackground;
  
  /// Primary brand color for buttons, links, and highlights.
  final Color primary;
  
  /// Error color for warnings and destructive actions.
  final Color error;
  
  /// Success color for confirmations and positive feedback.
  final Color success;
  
  /// Warning color for cautionary messages.
  final Color warning;
  
  /// Information color for neutral notifications.
  final Color info;
  
  /// LinkedIn brand color for social authentication.
  final Color linkedIn;
  
  /// Selection color for highlights and active states.
  /// Primary color in light mode, white in dark mode.
  final Color selectionColor;
  
  /// File suffix for theme-appropriate icons (e.g., '_dark').
  final String iconSuffix;
  
  /// File suffix for selected checkbox assets.
  final String checkboxOnSuffix;
  
  /// File suffix for unselected checkbox assets.
  final String checkboxOffSuffix;
  
  const VenyuTheme({
    required this.pageBackground,
    required this.cardBackground,
    required this.tagBackground,
    required this.disabledBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.disabledText,
    required this.borderColor,
    required this.secondaryButtonBackground,
    required this.primary,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.linkedIn,
    required this.selectionColor,
    required this.iconSuffix,
    required this.checkboxOnSuffix,
    required this.checkboxOffSuffix,
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
    secondaryButtonBackground: AppColors.alabasterWhite, // Secondary button background
    primary: AppColors.primair4Lilac,             // Primary brand color
    error: AppColors.na,                          // Error/NA color
    success: AppColors.me,                        // Success/Me color
    warning: AppColors.know,                      // Warning/Know color
    info: AppColors.need,                         // Info/Need color
    linkedIn: AppColors.linkedIn,                 // LinkedIn brand color
    selectionColor: AppColors.primair4Lilac,      // Primary color for selections
    iconSuffix: '_outlined',                      // Light theme uses outlined icons
    checkboxOnSuffix: '_selected',                // Light theme uses selected for checked
    checkboxOffSuffix: '_regular',                // Light theme uses regular for unchecked
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
    secondaryButtonBackground: AppColors.secundair2Offblack, // Secondary button background
    primary: AppColors.primair4Lilac,                // Primary brand color
    error: AppColors.na,                             // Error/NA color
    success: AppColors.me,                           // Success/Me color
    warning: AppColors.know,                         // Warning/Know color
    info: AppColors.need,                            // Info/Need color
    linkedIn: AppColors.linkedIn,                    // LinkedIn brand color
    selectionColor: Colors.white,                    // White for selections in dark mode
    iconSuffix: '_white',                            // Dark theme uses white icons
    checkboxOnSuffix: '_white',                      // Dark theme uses white for checked
    checkboxOffSuffix: '_white',                     // Dark theme uses white for unchecked
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
    Color? secondaryButtonBackground,
    Color? primary,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? linkedIn,
    Color? selectionColor,
    String? iconSuffix,
    String? checkboxOnSuffix,
    String? checkboxOffSuffix,
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
      secondaryButtonBackground: secondaryButtonBackground ?? this.secondaryButtonBackground,
      primary: primary ?? this.primary,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      linkedIn: linkedIn ?? this.linkedIn,
      selectionColor: selectionColor ?? this.selectionColor,
      iconSuffix: iconSuffix ?? this.iconSuffix,
      checkboxOnSuffix: checkboxOnSuffix ?? this.checkboxOnSuffix,
      checkboxOffSuffix: checkboxOffSuffix ?? this.checkboxOffSuffix,
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
      secondaryButtonBackground: Color.lerp(secondaryButtonBackground, other.secondaryButtonBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      linkedIn: Color.lerp(linkedIn, other.linkedIn, t)!,
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t)!,
      iconSuffix: t < 0.5 ? iconSuffix : other.iconSuffix, // String lerp: use threshold
      checkboxOnSuffix: t < 0.5 ? checkboxOnSuffix : other.checkboxOnSuffix,
      checkboxOffSuffix: t < 0.5 ? checkboxOffSuffix : other.checkboxOffSuffix,
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
  
  /// Helper to get the correct icon path based on theme
  String getThemedIconPath(String baseName) {
    return 'assets/images/icons/$baseName${venyuTheme.iconSuffix}.png';
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