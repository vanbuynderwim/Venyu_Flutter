import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';

/// Toast notification types with associated styling.
enum ToastType {
  success,
  error,
  warning,
  info;

  /// Get the background color for this toast type.
  Color backgroundColor(BuildContext context) {
    final theme = context.venyuTheme;
    switch (this) {
      case ToastType.success:
        return theme.snackbarSuccess;
      case ToastType.error:
        return theme.snackbarError;
      case ToastType.warning:
        return theme.warning;
      case ToastType.info:
        return theme.primary;
    }
  }

  /// Get the icon for this toast type.
  IconData get icon {
    switch (this) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  /// Get the text color for this toast type.
  Color textColor(BuildContext context) {
    // All toast types use white text for good contrast
    return Colors.white;
  }
}