import 'package:flutter/material.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// ActionButton - Flutter equivalent van Swift ActionButton
class ActionButton extends StatefulWidget {
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
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActuallyDisabled = widget.isDisabled || widget.onPressed == null;
    final isIconOnlyButton = widget.isIconOnly && widget.icon != null;
    
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActuallyDisabled ? null : widget.onPressed,
          onTapDown: isActuallyDisabled ? null : (_) => setState(() => isPressed = true),
          onTapUp: isActuallyDisabled ? null : (_) => setState(() => isPressed = false),
          onTapCancel: isActuallyDisabled ? null : () => setState(() => isPressed = false),
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Opacity(
            opacity: isActuallyDisabled ? 0.7 : (isPressed ? 0.8 : 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.style.backgroundColor(context),
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                border: Border.all(
                  color: widget.style.borderColor(context),
                  width: AppModifiers.thinBorder,
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
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.style.textColor(context),
                        size: 20,
                      ),
                      if (!isIconOnlyButton && widget.label != null) const SizedBox(width: 8),
                    ],
                    if (widget.label != null && !isIconOnlyButton)
                      Text(
                        widget.label!,
                        style: AppTextStyles.body.copyWith(
                          color: widget.style.textColor(context),
                          fontWeight: widget.style.fontWeight,
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