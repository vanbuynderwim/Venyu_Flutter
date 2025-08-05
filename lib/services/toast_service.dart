import 'package:flutter/material.dart';

import '../models/enums/toast_type.dart';
import '../widgets/feedback/toast.dart';

/// Service for displaying toast notifications throughout the app.
/// 
/// This service provides a simple API for showing toast messages
/// without needing to manage overlays directly.
/// 
/// Usage:
/// ```dart
/// ToastService.show(
///   context: context,
///   message: 'Operation successful!',
///   type: ToastType.success,
/// );
/// ```
class ToastService {
  static OverlayEntry? _currentToast;

  /// Show a toast notification.
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Remove any existing toast
    _currentToast?.remove();
    _currentToast = null;

    // Create new toast
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final bottomPadding = mediaQuery.padding.bottom;
        
        // Always position above ActionButton area
        // ActionButton is positioned at: keyboardHeight + bottomPadding + 16px margin
        // Toast should be 16px above the ActionButton
        final bottomOffset = keyboardHeight + bottomPadding + 72 + 16;
            
        return Positioned(
          bottom: bottomOffset,
          left: 0,
          right: 0,
          child: Toast(
            message: message,
            type: type,
            duration: duration,
            onDismiss: () {
              overlayEntry.remove();
              if (_currentToast == overlayEntry) {
                _currentToast = null;
              }
            },
          ),
        );
      },
    );

    _currentToast = overlayEntry;

    // Insert the toast into the overlay
    Overlay.of(context).insert(overlayEntry);
  }

  /// Show a success toast.
  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.success,
      duration: duration,
    );
  }

  /// Show an error toast.
  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.error,
      duration: duration,
    );
  }

  /// Show a warning toast.
  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.warning,
      duration: duration,
    );
  }

  /// Show an info toast.
  static void info({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.info,
      duration: duration,
    );
  }

  /// Dismiss the current toast if any.
  static void dismiss() {
    _currentToast?.remove();
    _currentToast = null;
  }
}