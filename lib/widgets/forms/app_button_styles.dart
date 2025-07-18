import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// Venyu Button Styles - Consistent button styling across the app
class AppButtonStyles {
  AppButtonStyles._();

  /// Helper to create button style without ripple effects
  static ButtonStyle _baseButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    required TextStyle textStyle,
    required EdgeInsets padding,
    required Size minimumSize,
    double elevation = AppModifiers.noElevation,
    Color shadowColor = Colors.transparent,
    double radius = AppModifiers.mediumRadius,
    BorderSide? side,
  }) => ElevatedButton.styleFrom(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    elevation: elevation,
    shadowColor: shadowColor,
    splashFactory: NoSplash.splashFactory,
    side: side,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    padding: padding,
    minimumSize: minimumSize,
  );

  /// Helper for outlined button style without ripple effects
  static ButtonStyle _baseOutlinedButtonStyle({
    required Color foregroundColor,
    required TextStyle textStyle,
    required EdgeInsets padding,
    required Size minimumSize,
    required BorderSide side,
    double radius = AppModifiers.mediumRadius,
  }) => OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    splashFactory: NoSplash.splashFactory,
    side: side,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    padding: padding,
    minimumSize: minimumSize,
  );

  /// Helper for text button style without ripple effects
  static ButtonStyle _baseTextButtonStyle({
    required Color foregroundColor,
    required TextStyle textStyle,
    required EdgeInsets padding,
    required Size minimumSize,
  }) => TextButton.styleFrom(
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    splashFactory: NoSplash.splashFactory,
    padding: padding,
    minimumSize: minimumSize,
  );

  /// Primary button style - main actions
  static ButtonStyle get primary => _baseButtonStyle(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Secondary button style - alternative actions
  static ButtonStyle get secondary => _baseButtonStyle(
    backgroundColor: AppColors.secondaryLight,
    foregroundColor: AppColors.textPrimary,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Destructive button style - dangerous actions
  static ButtonStyle get destructive => _baseButtonStyle(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.textOnAccent,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Success button style - positive actions
  static ButtonStyle get success => _baseButtonStyle(
    backgroundColor: AppColors.success,
    foregroundColor: AppColors.textOnAccent,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Outlined button style - secondary actions
  static ButtonStyle get outlined => _baseOutlinedButtonStyle(
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.headline,
    side: BorderSide(
      color: AppColors.primary,
      width: AppModifiers.thinBorder,
    ),
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Outlined destructive button style
  static ButtonStyle get outlinedDestructive => _baseOutlinedButtonStyle(
    foregroundColor: AppColors.error,
    textStyle: AppTextStyles.headline,
    side: BorderSide(
      color: AppColors.error,
      width: AppModifiers.thinBorder,
    ),
    padding: AppModifiers.buttonPadding,
    minimumSize: const Size(120, 48),
  );

  /// Text button style - minimal actions
  static ButtonStyle get text => _baseTextButtonStyle(
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPaddingSmall,
    minimumSize: const Size(80, 40),
  );

  /// Text destructive button style
  static ButtonStyle get textDestructive => _baseTextButtonStyle(
    foregroundColor: AppColors.error,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.buttonPaddingSmall,
    minimumSize: const Size(80, 40),
  );

  /// Small button variations
  static ButtonStyle get primarySmall => _baseButtonStyle(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    textStyle: AppTextStyles.callout,
    padding: AppModifiers.buttonPaddingSmall,
    minimumSize: const Size(80, 36),
    radius: AppModifiers.smallRadius,
  );

  static ButtonStyle get secondarySmall => _baseButtonStyle(
    backgroundColor: AppColors.secondaryLight,
    foregroundColor: AppColors.textPrimary,
    textStyle: AppTextStyles.callout,
    padding: AppModifiers.buttonPaddingSmall,
    minimumSize: const Size(80, 36),
    radius: AppModifiers.smallRadius,
  );

  /// Large button variations
  static ButtonStyle get primaryLarge => _baseButtonStyle(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    textStyle: AppTextStyles.title3,
    padding: AppModifiers.buttonPaddingLarge,
    minimumSize: const Size(200, 56),
    radius: AppModifiers.largeRadius,
  );

  /// Floating Action Button style
  static ButtonStyle get fab => _baseButtonStyle(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    textStyle: AppTextStyles.headline,
    padding: AppModifiers.paddingMedium,
    minimumSize: const Size(56, 56),
    elevation: AppModifiers.mediumElevation,
    shadowColor: AppColors.secundair6Rocket.withValues(alpha: 0.3),
    radius: AppModifiers.extraLargeRadius,
  );

  /// Icon button style
  static ButtonStyle get icon => IconButton.styleFrom(
    foregroundColor: AppColors.textPrimary,
    backgroundColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
    ),
    padding: AppModifiers.paddingSmall,
    minimumSize: const Size(40, 40),
  );

  /// Gradient button styles
  static BoxDecoration get primaryGradientDecoration => AppModifiers.primaryGradient;
  static BoxDecoration get accentGradientDecoration => AppModifiers.accentGradient;
}

/// Helper widget for gradient buttons
class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final BoxDecoration decoration;
  final EdgeInsets? padding;
  final Size? minimumSize;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.decoration,
    this.padding,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
          child: Container(
            padding: padding ?? AppModifiers.buttonPadding,
            constraints: BoxConstraints(
              minWidth: minimumSize?.width ?? 120,
              minHeight: minimumSize?.height ?? 48,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}