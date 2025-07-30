import 'package:flutter/material.dart';

/// BaseButton - Abstract base class for consistent button behavior
/// 
/// Provides shared button properties and behavior patterns across all custom buttons.
/// Eliminates code duplication in button implementations and ensures consistent
/// press handling, state management, and accessibility support.
/// 
/// Features:
/// - Consistent press state handling
/// - Disabled state management  
/// - Accessibility support
/// - Platform-aware touch feedback
/// 
/// Usage:
/// ```dart
/// class MyButton extends BaseButton {
///   const MyButton({super.key, super.onPressed, super.isDisabled});
///   
///   @override
///   State<MyButton> createState() => _MyButtonState();
/// }
/// 
/// class _MyButtonState extends State<MyButton> with ButtonPressMixin {
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTapDown: handleTapDown,
///       onTapUp: handleTapUp,  
///       onTapCancel: handleTapCancel,
///       child: AnimatedOpacity(
///         opacity: pressOpacity,
///         duration: const Duration(milliseconds: 100),
///         child: /* your button UI */,
///       ),
///     );
///   }
/// }
/// ```
abstract class BaseButton extends StatefulWidget {
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is disabled
  final bool isDisabled;
  
  /// Optional semantic label for accessibility
  final String? semanticLabel;

  const BaseButton({
    super.key,
    this.onPressed,
    this.isDisabled = false,
    this.semanticLabel,
  });

  /// Whether the button should respond to user interaction
  bool get isInteractive => !isDisabled && onPressed != null;
}

/// ButtonPressMixin - Shared press handling behavior for buttons
/// 
/// Provides consistent press state management across all button implementations.
/// Handles visual feedback during press interactions with proper state cleanup.
mixin ButtonPressMixin<T extends BaseButton> on State<T> {
  bool _isPressed = false;
  
  /// Current press state
  bool get isPressed => _isPressed;
  
  /// Opacity to apply during press (lower = more pressed effect)
  double get pressOpacity => _isPressed ? 0.6 : 1.0;
  
  /// Whether the button is actually disabled (combines widget disabled + null callback)
  bool get isActuallyDisabled => widget.isDisabled || widget.onPressed == null;

  /// Handle tap down - show pressed state
  void handleTapDown(TapDownDetails? details) {
    if (!isActuallyDisabled && mounted) {
      setState(() => _isPressed = true);
    }
  }

  /// Handle tap up - clear pressed state and execute callback
  void handleTapUp(TapUpDetails? details) {
    if (!isActuallyDisabled && mounted) {
      setState(() => _isPressed = false);
      // Small delay to show press feedback before executing callback
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          widget.onPressed?.call();
        }
      });
    }
  }

  /// Handle tap cancel - clear pressed state
  void handleTapCancel() {
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  /// Get disabled opacity
  double get disabledOpacity => isActuallyDisabled ? 0.5 : 1.0;

  /// Combine press and disabled opacity
  double get combinedOpacity => isActuallyDisabled ? disabledOpacity : pressOpacity;
}