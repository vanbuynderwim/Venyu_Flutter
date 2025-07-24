import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Custom theme extension for consistent spacing across the app
@immutable
class AppSpacingTheme extends ThemeExtension<AppSpacingTheme> {
  const AppSpacingTheme({
    required this.pageHorizontalPadding,
    required this.listViewPadding,
    required this.sectionSpacing,
  });

  /// Standard horizontal padding for all app pages
  final EdgeInsets pageHorizontalPadding;
  
  /// Standard padding for ListView widgets  
  final EdgeInsets listViewPadding;
  
  /// Standard spacing between sections
  final double sectionSpacing;

  /// Default spacing values for the app
  static const AppSpacingTheme defaultSpacing = AppSpacingTheme(
    pageHorizontalPadding: EdgeInsets.symmetric(horizontal: 16),
    listViewPadding: EdgeInsets.symmetric(horizontal: 16),
    sectionSpacing: 24,
  );

  @override
  AppSpacingTheme copyWith({
    EdgeInsets? pageHorizontalPadding,
    EdgeInsets? listViewPadding,
    double? sectionSpacing,
  }) {
    return AppSpacingTheme(
      pageHorizontalPadding: pageHorizontalPadding ?? this.pageHorizontalPadding,
      listViewPadding: listViewPadding ?? this.listViewPadding,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
    );
  }

  @override
  AppSpacingTheme lerp(AppSpacingTheme? other, double t) {
    if (other is! AppSpacingTheme) {
      return this;
    }
    return AppSpacingTheme(
      pageHorizontalPadding: EdgeInsets.lerp(pageHorizontalPadding, other.pageHorizontalPadding, t)!,
      listViewPadding: EdgeInsets.lerp(listViewPadding, other.listViewPadding, t)!,
      sectionSpacing: lerpDouble(sectionSpacing, other.sectionSpacing, t)!,
    );
  }
}

/// Extension on ThemeData to easily access spacing
extension AppSpacingThemeData on ThemeData {
  AppSpacingTheme get appSpacing => extension<AppSpacingTheme>() ?? AppSpacingTheme.defaultSpacing;
}