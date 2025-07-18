import 'package:flutter/material.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// ActionButton - Flutter equivalent van Swift ActionButton
class ActionButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final ActionButtonType style;
  final IconData? icon;
  final bool isDisabled;
  final double? width;
  final bool isIconOnly;

  const ActionButton({
    super.key,
    this.label,
    this.onPressed,
    this.style = ActionButtonType.primary,
    this.icon,
    this.isDisabled = false,
    this.width,
    this.isIconOnly = false,
  }) : assert(label != null || (icon != null && isIconOnly), 
         'Either label must be provided or icon must be provided with isIconOnly=true');

  @override
  Widget build(BuildContext context) {
    final isActuallyDisabled = isDisabled || onPressed == null;
    final isIconOnlyButton = isIconOnly && icon != null;
    
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActuallyDisabled ? null : onPressed,
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Opacity(
            opacity: isActuallyDisabled ? 0.7 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                border: Border.all(
                  color: style.borderColor,
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isIconOnlyButton ? 0 : 16,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: style.textColor,
                        size: 20,
                      ),
                      if (!isIconOnlyButton && label != null) const SizedBox(width: 8),
                    ],
                    if (label != null && !isIconOnlyButton)
                      Text(
                        label!,
                        style: AppTextStyles.body.copyWith(
                          color: style.textColor,
                          fontWeight: style.fontWeight,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}