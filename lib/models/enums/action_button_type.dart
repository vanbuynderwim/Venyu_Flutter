import 'package:flutter/material.dart';
import '../../core/theme/venyu_theme.dart';

/// Button style variants for [ActionButton] widgets.
/// 
/// Defines the visual appearance and behavior of action buttons throughout the app.
/// Each type has specific color schemes, typography, and interaction patterns.
/// 
/// Example usage:
/// ```dart
/// ActionButton(
///   label: 'Save',
///   type: ActionButtonType.primary,
///   onPressed: () => save(),
/// )
/// ```
enum ActionButtonType {
  primary('primary'),
  secondary('secondary'),
  destructive('destructive'),
  unlock('unlock');

  const ActionButtonType(this.value);
  
  final String value;

  /// Creates an [ActionButtonType] from a JSON string value.
  /// 
  /// Returns [ActionButtonType.primary] if the value doesn't match any type.
  static ActionButtonType fromJson(String value) {
    return ActionButtonType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ActionButtonType.primary,
    );
  }

  /// Converts this [ActionButtonType] to a JSON string value.
  String toJson() => value;

  /// Returns the appropriate background color for this button type.
  ///
  /// Uses theme-aware colors that adapt to light/dark mode automatically.
  /// When [onInvertedBackground] is true and in dark mode, primary buttons
  /// use dark background instead of white.
  Color backgroundColor(BuildContext context, {bool onInvertedBackground = false}) {
    final venyuTheme = context.venyuTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case ActionButtonType.primary:
        if (onInvertedBackground && isDarkMode) {
          return venyuTheme.pageBackground; // Dark background in dark mode when on inverted background
        }
        return venyuTheme.primary;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        // Use theme-aware background colors
        return venyuTheme.secondaryButtonBackground;
      case ActionButtonType.unlock:
        return venyuTheme.info;
    }
  }

  /// Returns the appropriate text color for this button type.
  ///
  /// Ensures proper contrast ratios for accessibility across all themes.
  /// When [onInvertedBackground] is true and in dark mode, primary buttons
  /// use white text instead of dark text.
  Color textColor(BuildContext context, {bool onInvertedBackground = false}) {
    final venyuTheme = context.venyuTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case ActionButtonType.primary:
        if (onInvertedBackground && isDarkMode) {
          return Colors.white; // White text in dark mode when on inverted background
        }
        return venyuTheme.cardBackground; // White in light mode, dark in dark mode
      case ActionButtonType.secondary:
        return venyuTheme.primary;
      case ActionButtonType.destructive:
        return venyuTheme.error;
      case ActionButtonType.unlock:
        return venyuTheme.cardBackground; // White text for good contrast on tangerine background
    }
  }

  /// Returns the appropriate border color for this button type.
  ///
  /// Provides visual definition and maintains design consistency.
  /// When [onInvertedBackground] is true and in dark mode, primary buttons
  /// use dark border instead of primary color border.
  Color borderColor(BuildContext context, {bool onInvertedBackground = false}) {
    final venyuTheme = context.venyuTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case ActionButtonType.primary:
        if (onInvertedBackground && isDarkMode) {
          return venyuTheme.pageBackground; // Dark border in dark mode when on inverted background
        }
        return venyuTheme.primary;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return venyuTheme.borderColor;
      case ActionButtonType.unlock:
        return venyuTheme.info;
    }
  }
  


  /// Returns the appropriate font weight for this button type.
  /// 
  /// All button types use semibold weight for consistency and emphasis.
  FontWeight get fontWeight {
    switch (this) {
      case ActionButtonType.primary:
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
      case ActionButtonType.unlock:
        return FontWeight.w600; // semibold
    }
  }

  /// Returns the appropriate highlight color for this button type.
  ///
  /// Uses contrasting colors to ensure the highlight effect is visible
  /// against different button background colors in both light and dark themes.
  /// When [onInvertedBackground] is true and in dark mode, primary buttons
  /// use light highlight instead of dark highlight.
  Color highlightColor(BuildContext context, {bool onInvertedBackground = false}) {
    final venyuTheme = context.venyuTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case ActionButtonType.primary:
        if (onInvertedBackground && isDarkTheme) {
          return Colors.white.withValues(alpha: 0.3); // Light highlight on dark button when inverted
        }
        // In dark theme, primary buttons have white background, so use dark highlight
        // In light theme, primary buttons have dark background, so use light highlight
        return isDarkTheme
            ? Colors.black.withValues(alpha: 0.1) // Dark highlight on white button
            : Colors.white.withValues(alpha: 0.3); // Light highlight on dark button
      case ActionButtonType.secondary:
        // For light background with primary text, use primary color highlight
        return venyuTheme.primary.withValues(alpha: 0.2);
      case ActionButtonType.destructive:
        // For light background with error text, use error color highlight
        return venyuTheme.error.withValues(alpha: 0.2);
      case ActionButtonType.unlock:
        // For tangerine background with white text, use white highlight
        return Colors.white.withValues(alpha: 0.3);
    }
  }
}