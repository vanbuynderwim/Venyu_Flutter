import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ToastStyle {
  error,
  warning,
  success,
  info;

  // Helper methods - using exact colors from Swift Theme
  Color get themeColor {
    switch (this) {
      case ToastStyle.error:
        return AppColors.na; // Red
      case ToastStyle.warning:
        return AppColors.know; // Orange
      case ToastStyle.success:
        return AppColors.me; // Green
      case ToastStyle.info:
        return AppColors.need; // Blue-green
    }
  }

  String get iconFileName {
    switch (this) {
      case ToastStyle.error:
        return 'error';
      case ToastStyle.warning:
        return 'warning';
      case ToastStyle.success:
        return 'success';
      case ToastStyle.info:
        return 'info';
    }
  }

  String get title {
    switch (this) {
      case ToastStyle.error:
        return 'Error';
      case ToastStyle.warning:
        return 'Warning';
      case ToastStyle.success:
        return 'Success';
      case ToastStyle.info:
        return 'Info';
    }
  }
}