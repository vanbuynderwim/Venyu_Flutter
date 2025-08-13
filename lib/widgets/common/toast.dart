import 'package:flutter/material.dart';

import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/enums/toast_type.dart';

/// A toast notification widget that displays temporary messages.
/// 
/// This widget provides a consistent way to show feedback messages
/// across the app with different types (success, error, warning, info).
/// 
/// The toast automatically dismisses after a duration and can be
/// manually dismissed by tapping.
class Toast extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;

  const Toast({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start the entrance animation
    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: _dismiss,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 56, // Same height as ActionButton
            decoration: BoxDecoration(
              color: widget.type.backgroundColor(context),
              borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    widget.type.icon,
                    color: widget.type.textColor(context),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: AppTextStyles.body.copyWith(
                        color: widget.type.textColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}