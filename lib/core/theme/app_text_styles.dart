import 'package:flutter/material.dart';
import 'app_fonts.dart';
import 'app_colors.dart';

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
/// Example usage:
/// ```dart
/// // Use predefined styles
/// Text('Heading', style: AppTextStyles.title1)
/// Text('Body text', style: AppTextStyles.body)
/// Text('Caption', style: AppTextStyles.caption1)
/// 
/// // Modify styles for specific use cases
/// Text('Custom', style: AppTextStyles.headline.copyWith(
///   color: Colors.blue,
///   fontWeight: FontWeight.bold,
/// ))
/// ```
class AppTextStyles {
  AppTextStyles._();

  // iOS Typography Scale - using both system and Graphie fonts
  
  /// Extra Large Title - 36.0pt Bold (iOS 17+)
  static TextStyle extraLargeTitle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Extra Large Title 2 - 28.0pt Bold (iOS 17+)
  static TextStyle extraLargeTitle2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  /// Large Title - 34.0pt Regular
  static TextStyle largeTitle = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary
  );

  /// Title 1 - 28.0pt Regular
  static TextStyle title1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  /// Title 2 - 22.0pt Regular
  static TextStyle title2 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Title 3 - 20.0pt Regular
  static TextStyle title3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Headline - 17.0pt Semibold
  static TextStyle headline = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  /// Subheadline - 15.0pt Regular
  static TextStyle subheadline = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Body - 17.0pt Regular
  static TextStyle body = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Callout - 16.0pt Regular
  static TextStyle callout = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Footnote - 13.0pt Regular
  static TextStyle footnote = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Caption 1 - 12.0pt Regular
  static TextStyle caption1 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Caption 2 - 11.0pt Regular
  static TextStyle caption2 = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.defaultFontFamily,
    color: AppColors.textLight,
    height: 1.4,
  );

  // Special Graphie styles for branding
  /// App Title - Large Graphie style
  static TextStyle appTitle = TextStyle(
    fontSize: 46.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.graphie,
    color: AppColors.primair4Lilac,
    height: 1.1,
  );

  /// App Subtitle - Medium Graphie style
  static TextStyle appSubtitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.graphie,
    color: AppColors.secundair3Slategray,
    height: 1.3,
  );

  /// Prompt Label - Large Graphie style
  static TextStyle promptLabel = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.graphie,
    color: AppColors.secundair2Offblack,
    height: 1.2,
  );

  // Extension methods for easy color variations
  static TextStyle onPrimary(TextStyle base) => base.copyWith(color: AppColors.textOnPrimary);
  static TextStyle onAccent(TextStyle base) => base.copyWith(color: AppColors.textOnAccent);
  static TextStyle primary(TextStyle base) => base.copyWith(color: AppColors.primary);
  static TextStyle accent(TextStyle base) => base.copyWith(color: AppColors.accent);
  static TextStyle secondary(TextStyle base) => base.copyWith(color: AppColors.secondary);
}