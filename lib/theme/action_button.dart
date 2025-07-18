import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// ActionButton style types
enum ActionButtonStyleType {
  primary, // Default style - colored background, white text
  secondary, // Cancel/Back style - light background, colored border and text
  destructive, // Delete/Remove style - light background, red text
}

/// ActionButton - Flutter equivalent van Swift ActionButton
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ActionButtonStyleType style;
  final IconData? icon;
  final bool isDisabled;
  final double? width;

  const ActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = ActionButtonStyleType.primary,
    this.icon,
    this.isDisabled = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isActuallyDisabled = isDisabled || onPressed == null;
    
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActuallyDisabled ? null : onPressed,
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(10),
          child: Opacity(
            opacity: isActuallyDisabled ? 0.7 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getBorderColor(),
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: _getForegroundColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      color: _getForegroundColor(),
                      fontWeight: _getFontWeight(),
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

  Color _getForegroundColor() {
    switch (style) {
      case ActionButtonStyleType.primary:
        return AppColors.white;
      case ActionButtonStyleType.secondary:
        return AppColors.primair4Lilac;
      case ActionButtonStyleType.destructive:
        return AppColors.accent1Tangerine;
    }
  }

  Color _getBackgroundColor() {
    switch (style) {
      case ActionButtonStyleType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonStyleType.secondary:
      case ActionButtonStyleType.destructive:
        return AppColors.alabasterWhite;
    }
  }

  Color _getBorderColor() {
    switch (style) {
      case ActionButtonStyleType.primary:
        return AppColors.primair4Lilac;
      case ActionButtonStyleType.secondary:
      case ActionButtonStyleType.destructive:
        return AppColors.secundair6Rocket;
    }
  }

  FontWeight _getFontWeight() {
    switch (style) {
      case ActionButtonStyleType.primary:
        return FontWeight.w600; // semibold
      case ActionButtonStyleType.secondary:
      case ActionButtonStyleType.destructive:
        return FontWeight.w400; // regular
    }
  }
}