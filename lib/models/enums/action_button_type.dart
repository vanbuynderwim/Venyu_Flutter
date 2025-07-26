import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/venyu_theme.dart';

enum ActionButtonType {
  primary('primary'),
  secondary('secondary'),
  destructive('destructive'),
  linkedIn('linkedIn');

  const ActionButtonType(this.value);
  
  final String value;

  static ActionButtonType fromJson(String value) {
    return ActionButtonType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ActionButtonType.primary,
    );
  }

  String toJson() => value;

  /// Get the background color for this button type
  Color backgroundColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    switch (this) {
      case ActionButtonType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        // Use theme-aware background colors
        return venyuTheme.secondaryButtonBackground;
      case ActionButtonType.linkedIn:
        return AppColors.linkedIn;
    }
  }

  /// Get the text color for this button type
  Color textColor(BuildContext context) {
    switch (this) {
      case ActionButtonType.primary:
      case ActionButtonType.linkedIn:
        return AppColors.white;
      case ActionButtonType.secondary:
        return AppColors.primair4Lilac;
      case ActionButtonType.destructive:
        return AppColors.accent1Tangerine;
    }
  }

  /// Get the border color for this button type
  Color borderColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    switch (this) {
      case ActionButtonType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return venyuTheme.borderColor;
      case ActionButtonType.linkedIn:
        return AppColors.linkedIn;
    }
  }
  


  /// Get the font weight for this button type
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