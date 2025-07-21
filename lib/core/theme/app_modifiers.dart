import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Venyu App Modifiers - Swift-inspired styling system for consistent UI
class AppModifiers {
  AppModifiers._();

  /// Corner radius values
  static const double tinyRadius = 2.0;      // Progress bars, small elements
  static const double miniRadius = 4.0;      // Checkboxes, small badges
  static const double smallRadius = 8.0;     // Small containers
  static const double defaultRadius = 10.0;  // Default for components
  static const double mediumRadius = 12.0;   // Cards, dialogs
  static const double largeRadius = 16.0;    // Large containers
  static const double extraLargeRadius = 24.0; // Very large containers
  static const double capsuleRadius = 100.0; // Capsule/pill shape

  /// Spacing values
  static const double tinySpacing = 4.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  /// Shadow values
  static const double noElevation = 0.0;
  static const double smallElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double largeElevation = 8.0;

  /// Border widths
  static const double thinBorder = 1.0;
  static const double mediumBorder = 2.0;
  static const double thickBorder = 3.0;

  /// Common rounded corner decorations
  static BoxDecoration get roundedSmall => BoxDecoration(
    borderRadius: BorderRadius.circular(smallRadius),
  );

  static BoxDecoration get roundedMedium => BoxDecoration(
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  static BoxDecoration get roundedLarge => BoxDecoration(
    borderRadius: BorderRadius.circular(largeRadius),
  );

  static BoxDecoration get roundedExtraLarge => BoxDecoration(
    borderRadius: BorderRadius.circular(extraLargeRadius),
  );

  /// Card decorations with shadows
  static BoxDecoration get cardSmall => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(smallRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.1),
        blurRadius: smallElevation,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static BoxDecoration get cardMedium => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(mediumRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.15),
        blurRadius: mediumElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get cardLarge => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(largeRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.2),
        blurRadius: largeElevation,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Surface decorations
  static BoxDecoration get surface => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  static BoxDecoration get surfaceElevated => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(mediumRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.1),
        blurRadius: smallElevation,
        offset: const Offset(0, 1),
      ),
    ],
  );

  /// Border decorations
  static BoxDecoration borderDecoration({
    required Color borderColor,
    double borderWidth = thinBorder,
    double radius = mediumRadius,
    Color? backgroundColor,
  }) => BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
  );

  /// Gradient decorations
  static BoxDecoration get primaryGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primair3Berry,
        AppColors.primair4Lilac,
      ],
    ),
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  static BoxDecoration get accentGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.accent1Tangerine,
        AppColors.accent2Coral,
      ],
    ),
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  /// Common padding values
  static const EdgeInsets paddingTiny = EdgeInsets.all(tinySpacing);
  static const EdgeInsets paddingSmall = EdgeInsets.all(smallSpacing);
  static const EdgeInsets paddingMedium = EdgeInsets.all(mediumSpacing);
  static const EdgeInsets paddingLarge = EdgeInsets.all(largeSpacing);
  static const EdgeInsets paddingExtraLarge = EdgeInsets.all(extraLargeSpacing);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: smallSpacing);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: mediumSpacing);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: largeSpacing);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: smallSpacing);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: mediumSpacing);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: largeSpacing);

  /// Input field specific padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: mediumSpacing,
    vertical: mediumSpacing,
  );

  /// Button specific padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: largeSpacing,
    vertical: mediumSpacing,
  );

  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: mediumSpacing,
    vertical: smallSpacing,
  );

  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: extraLargeSpacing,
    vertical: mediumSpacing,
  );

  /// Page layout padding - standard horizontal padding voor alle pagina's
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: mediumSpacing, // 16px links en rechts
    vertical: largeSpacing,    // 24px boven en onder
  );

  static const EdgeInsets pagePaddingHorizontal = EdgeInsets.symmetric(
    horizontal: mediumSpacing, // 16px links en rechts
  );
}