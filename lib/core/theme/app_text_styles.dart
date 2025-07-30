import 'package:flutter/material.dart';
import 'app_fonts.dart';
import 'venyu_theme.dart';

/// Centralized text styles following iOS typography guidelines.
/// 
/// This class provides a comprehensive set of text styles that match
/// iOS Human Interface Guidelines typography scale. All styles are
/// designed to work consistently across the app and support accessibility.
/// 
/// The typography scale includes:
/// - Display styles for large headings and titles
/// - Body styles for content and descriptions
/// - Caption styles for labels and metadata
/// 
/// Colors are applied separately using extension methods, giving views
/// full control over text appearance based on context.
/// 
/// Example usage:
/// ```dart
/// // Use predefined styles
/// Text('Heading', style: AppTextStyles.title1)
/// Text('Body text', style: AppTextStyles.body)
/// Text('Caption', style: AppTextStyles.caption1)
/// 
/// // Apply theme colors using extension methods
/// Text('Primary text', style: AppTextStyles.headline.primaryText(context))
/// Text('Secondary text', style: AppTextStyles.body.secondary(context))
/// Text('Brand text', style: AppTextStyles.title1.primary(context))
/// 
/// // Modify styles for specific use cases
/// Text('Custom', style: AppTextStyles.headline.copyWith(
///   fontWeight: FontWeight.bold,
/// ))
/// ```
class AppTextStyles {
  AppTextStyles._();

  // iOS Typography Scale - using both system and Graphie fonts
  // Note: Colors are applied separately using extension methods
  
  /// Extra Large Title - 36.0pt Bold (iOS 17+)
  static const TextStyle extraLargeTitle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
    height: 1.2,
  );

  /// Extra Large Title 2 - 28.0pt Bold (iOS 17+)
  static const TextStyle extraLargeTitle2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
    height: 1.25,
  );

  /// Large Title - 34.0pt Regular
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Title 1 - 28.0pt Regular
  static const TextStyle title1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    height: 1.25,
  );

  /// Title 2 - 22.0pt Regular
  static const TextStyle title2 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    height: 1.3,
  );

  /// Title 3 - 20.0pt Regular
  static const TextStyle title3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Headline - 17.0pt Semibold
  static const TextStyle headline = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Subheadline - 15.0pt Regular
  static const TextStyle subheadline = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Body - 17.0pt Regular
  static const TextStyle body = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Callout - 16.0pt Regular
  static const TextStyle callout = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Footnote - 13.0pt Regular
  static const TextStyle footnote = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Caption 1 - 12.0pt Regular
  static const TextStyle caption1 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  /// Caption 2 - 11.0pt Regular
  static const TextStyle caption2 = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
  );

  // Special Graphie styles for branding
  /// App Title - Large Graphie style
  static const TextStyle appTitle = TextStyle(
    fontSize: 46.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.graphie,
  );

  /// App Subtitle - Medium Graphie style
  static const TextStyle appSubtitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.graphie,
  );

  /// Prompt Label - Large Graphie style
  static const TextStyle promptLabel = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.graphie,
  );
}

/// Extension to add theme colors to TextStyle
extension ThemeAwareTextStyle on TextStyle {
  /// Helper methods for applying theme colors to text styles
  TextStyle primary(BuildContext context) => copyWith(color: context.venyuTheme.primary);
  TextStyle primaryText(BuildContext context) => copyWith(color: context.venyuTheme.primaryText);
  TextStyle secondary(BuildContext context) => copyWith(color: context.venyuTheme.secondaryText);
  TextStyle disabled(BuildContext context) => copyWith(color: context.venyuTheme.disabledText);
  TextStyle error(BuildContext context) => copyWith(color: context.venyuTheme.error);
  TextStyle success(BuildContext context) => copyWith(color: context.venyuTheme.success);
  TextStyle onCard(BuildContext context) => copyWith(color: context.venyuTheme.cardBackground);
  TextStyle snackbarSuccess(BuildContext context) => copyWith(color: context.venyuTheme.snackbarSuccess);
  TextStyle snackbarError(BuildContext context) => copyWith(color: context.venyuTheme.snackbarError);
}