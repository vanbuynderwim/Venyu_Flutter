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
///   style: ActionButtonType.primary,
///   onPressed: () => save(),
/// )
/// ```
enum ActionButtonType {
  primary('primary'),
  secondary('secondary'),
  destructive('destructive'),
  linkedIn('linkedIn');

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
  Color backgroundColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    switch (this) {
      case ActionButtonType.primary:
        return venyuTheme.primary;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        // Use theme-aware background colors
        return venyuTheme.secondaryButtonBackground;
      case ActionButtonType.linkedIn:
        return venyuTheme.linkedIn;
    }
  }

  /// Returns the appropriate text color for this button type.
  /// 
  /// Ensures proper contrast ratios for accessibility across all themes.
  Color textColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    switch (this) {
      case ActionButtonType.primary:
      case ActionButtonType.linkedIn:
        return venyuTheme.cardBackground; // White in light mode, dark in dark mode
      case ActionButtonType.secondary:
        return venyuTheme.primary;
      case ActionButtonType.destructive:
        return venyuTheme.error;
    }
  }

  /// Returns the appropriate border color for this button type.
  /// 
  /// Provides visual definition and maintains design consistency.
  Color borderColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    switch (this) {
      case ActionButtonType.primary:
        return venyuTheme.primary;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return venyuTheme.borderColor;
      case ActionButtonType.linkedIn:
        return venyuTheme.linkedIn;
    }
  }
  


  /// Returns the appropriate font weight for this button type.
  /// 
  /// Primary and LinkedIn buttons use semibold weight for emphasis,
  /// while secondary and destructive buttons use regular weight.
  FontWeight get fontWeight {
    switch (this) {
      case ActionButtonType.primary:
      case ActionButtonType.linkedIn:
        return FontWeight.w600; // semibold
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return FontWeight.w400; // regular
    }
  }
}