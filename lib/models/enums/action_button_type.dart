import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

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
  Color get backgroundColor {
    switch (this) {
      case ActionButtonType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return AppColors.alabasterWhite;
      case ActionButtonType.linkedIn:
        return AppColors.linkedIn;
    }
  }

  /// Get the text color for this button type
  Color get textColor {
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
  Color get borderColor {
    switch (this) {
      case ActionButtonType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonType.secondary:
      case ActionButtonType.destructive:
        return AppColors.secundair6Rocket;
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