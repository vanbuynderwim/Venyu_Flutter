import 'package:flutter/material.dart';

enum ToastStyle {
  error,
  warning,
  success,
  info;

  // Helper methods
  Color get themeColor {
    switch (this) {
      case ToastStyle.error:
        return Colors.red;
      case ToastStyle.warning:
        return Colors.orange;
      case ToastStyle.success:
        return Colors.green;
      case ToastStyle.info:
        return Colors.blue;
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