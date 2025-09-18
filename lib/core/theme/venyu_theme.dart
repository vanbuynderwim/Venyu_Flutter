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
  
  /// Accent color for unlock buttons.
  final Color accent;
  
  /// Accent background color.
  final Color accentBackground;
  
  /// Color for unselected/inactive UI elements.
  /// Secondary text color in light mode, white in dark mode.
  final Color unselectedText;
  
  /// Background color for unselected/inactive UI elements.
  /// White in light mode, Pinball gray in dark mode.
  final Color unselectedBackground;
  
  /// Success color for snackbars and positive feedback messages.
  final Color snackbarSuccess;
  
  /// Error color for snackbars and error feedback messages.
  final Color snackbarError;

  /// Primary gradient color for backgrounds.
  /// Lilac in light mode, Rocket in dark mode.
  final Color gradientPrimary;

  /// Dark text color that adapts between light and dark themes.
  /// Off-black in light mode, Slate gray in dark mode.
  final Color darkText;


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
    required this.accent,
    required this.accentBackground,
    required this.unselectedText,
    required this.unselectedBackground,
    required this.snackbarSuccess,
    required this.snackbarError,
    required this.gradientPrimary,
    required this.darkText,
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
    accent: AppColors.accent1Tangerine,    // Tangerine color for unlock buttons
    accentBackground: AppColors.accent4Bluch,        // Blush color for accent backgrounds
    unselectedText: AppColors.secundair3Slategray,                // Gray color for unselected elements
    unselectedBackground: AppColors.primair7Pearl,           // White background for unselected elements
    snackbarSuccess: AppColors.me,                // Success color for snackbars
    snackbarError: AppColors.na,                  // Error color for snackbars
    gradientPrimary: AppColors.primair4Lilac,     // Lilac for gradient backgrounds
    darkText: AppColors.secundair2Offblack,       // Off-black for dark text in light mode
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
    primary: Colors.white,                // Primary brand color
    error: AppColors.na,                             // Error/NA color
    success: AppColors.me,                           // Success/Me color
    warning: AppColors.know,                         // Warning/Know color
    info: AppColors.need,                            // Info/Need color
    linkedIn: AppColors.linkedIn,                    // LinkedIn brand color
    accent: Colors.white,                  // White color for unlock buttons in dark mode
    accentBackground: AppColors.secundair2Offblack,  // Dark background for accent elements in dark mode
    unselectedText: Colors.white,                    // White for unselected elements in dark mode
    unselectedBackground: AppColors.secundair3Slategray, // Pinball gray background for unselected elements
    snackbarSuccess: AppColors.me,                   // Success color for snackbars
    snackbarError: AppColors.na,                     // Error color for snackbars
    gradientPrimary: AppColors.secundair1Deepblack,     // Rocket for gradient backgrounds in dark mode
    darkText: AppColors.secundair1Deepblack,         // Slate gray for dark text in dark mode
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
    Color? accent,
    Color? accentBackground,
    Color? unselectedText,
    Color? unselectedBackground,
    Color? snackbarSuccess,
    Color? snackbarError,
    Color? gradientPrimary,
    Color? darkText,
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
      accent: accent ?? this.accent,
      accentBackground: accentBackground ?? this.accentBackground,
      unselectedText: unselectedText ?? this.unselectedText,
      unselectedBackground: unselectedBackground ?? this.unselectedBackground,
      snackbarSuccess: snackbarSuccess ?? this.snackbarSuccess,
      snackbarError: snackbarError ?? this.snackbarError,
      gradientPrimary: gradientPrimary ?? this.gradientPrimary,
      darkText: darkText ?? this.darkText,
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
      accent: Color.lerp(accent, other.accent, t)!,
      accentBackground: Color.lerp(accentBackground, other.accentBackground, t)!,
      unselectedText: Color.lerp(unselectedText, other.unselectedText, t)!,
      unselectedBackground: Color.lerp(unselectedBackground, other.unselectedBackground, t)!,
      snackbarSuccess: Color.lerp(snackbarSuccess, other.snackbarSuccess, t)!,
      snackbarError: Color.lerp(snackbarError, other.snackbarError, t)!,
      gradientPrimary: Color.lerp(gradientPrimary, other.gradientPrimary, t)!,
      darkText: Color.lerp(darkText, other.darkText, t)!,
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
  
  
  
  /// Helper to get the correct icon path (only _regular and _selected variants)
  String getIconPath(String baseName, {bool selected = false}) {
    final suffix = selected ? '_selected' : '_regular';
    return 'assets/images/icons/$baseName$suffix.png';
  }
  
  /// Helper to get the correct icon color based on theme and state
  Color getIconColor({bool selected = false}) {
    if (selected) {
      return venyuTheme.primary;
    } else {
      return venyuTheme.secondaryText;
    }
  }
  
  /// Helper widget to create a themed icon with proper coloring
  Widget themedIcon(String baseName, {
    bool selected = false,
    double? width,
    double? height,
    double size = 24,
    Color? overrideColor,
  }) {
    try {
      return Image.asset(
        getIconPath(baseName, selected: selected),
        width: width ?? size,
        height: height ?? size,
        color: overrideColor ?? getIconColor(selected: selected),
        errorBuilder: (context, error, stackTrace) {
          debugPrint('⚠️ themedIcon error for "$baseName": $error');
          return _getFallbackIcon(baseName, size, overrideColor ?? getIconColor(selected: selected));
        },
      );
    } catch (error) {
      debugPrint('⚠️ themedIcon exception for "$baseName": $error');
      return _getFallbackIcon(baseName, size, overrideColor ?? getIconColor(selected: selected));
    }
  }
  
  /// Get fallback icon when themedIcon fails
  Widget _getFallbackIcon(String baseName, double size, Color color) {
    return Icon(
      Icons.help_outline,
      size: size,
      color: color,
    );
  }
  
  /// Helper to get the correct opacity for interactive elements based on state
  /// 
  /// This centralizes the opacity values for all interactive widgets in the app.
  /// Change these values here to affect all buttons, cards, and interactive elements.
  /// 
  /// Returns:
  /// - 0.7 for disabled state
  /// - 0.8 for pressed state  
  /// - 1.0 for normal state
  double getInteractiveOpacity({
    bool isDisabled = false,
    bool isPressed = false,
  }) {
    if (isDisabled) return 0.7;
    if (isPressed) return 0.8;
    return 1.0;
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
    
    // AppBar theming for Android - match iOS style
    appBarTheme: AppBarTheme(
      backgroundColor: VenyuTheme.light.pageBackground, // Pearl background
      foregroundColor: VenyuTheme.light.primaryText, // Text color
      elevation: 0, // No shadow, like iOS
      scrolledUnderElevation: 0, // No elevation when scrolled
      centerTitle: true, // Center title like iOS
    ),
    
    // Bottom navigation bar theming (older Material 2)
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primair4Lilac,
      unselectedItemColor: AppColors.secundair3Slategray,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Navigation bar theming (Material 3 for Android)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent, // No capsule background, just like iOS
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primair4Lilac); // Same as iOS
        }
        return const IconThemeData(color: AppColors.secundair3Slategray);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.primair4Lilac,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: AppColors.secundair3Slategray,
          fontSize: 12,
        );
      }),
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
    
    // AppBar theming for Android - match iOS style
    appBarTheme: AppBarTheme(
      backgroundColor: VenyuTheme.dark.pageBackground, // Dark background
      foregroundColor: VenyuTheme.dark.primaryText, // White text
      elevation: 0, // No shadow, like iOS
      scrolledUnderElevation: 0, // No elevation when scrolled
      centerTitle: true, // Center title like iOS
    ),
    
    // Bottom navigation bar theming (older Material 2)
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.secundair4Quicksilver,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Navigation bar theming (Material 3 for Android)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.secundair2Offblack,
      indicatorColor: Colors.transparent, // No capsule background, just like iOS
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Colors.white); // Same as iOS
        }
        return const IconThemeData(color: AppColors.secundair4Quicksilver);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: AppColors.secundair4Quicksilver,
          fontSize: 12,
        );
      }),
    ),
    
    // Extensions
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacingTheme.defaultSpacing,
      VenyuTheme.dark, // Our custom theme
    ],
  );
  
  /// Light Cupertino theme for iOS
  static CupertinoThemeData get cupertinoLightTheme => CupertinoThemeData(
    primaryColor: AppColors.primair4Lilac, // Tab bar active color
    scaffoldBackgroundColor: VenyuTheme.light.pageBackground,
    brightness: Brightness.light,
  );
  
  /// Dark Cupertino theme for iOS
  static CupertinoThemeData get cupertinoDarkTheme => CupertinoThemeData(
    primaryColor: Colors.white, // Tab bar active color in dark mode
    scaffoldBackgroundColor: VenyuTheme.dark.pageBackground,
    brightness: Brightness.dark,
  );
}