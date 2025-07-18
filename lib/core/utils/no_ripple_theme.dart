import 'package:flutter/material.dart';

/// Widget that forces no ripple effects for all child widgets
class NoRippleTheme extends StatelessWidget {
  final Widget child;

  const NoRippleTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          surfaceTint: Colors.transparent,
        ),
      ),
      child: child,
    );
  }
}

/// Custom InkWell that never shows ripple effects
class NoRippleInkWell extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const NoRippleInkWell({
    super.key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: child,
      ),
    );
  }
}