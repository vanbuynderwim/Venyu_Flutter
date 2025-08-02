import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/action_button_type.dart';

/// A customizable action button widget with multiple visual styles.
/// 
/// This widget provides a consistent button interface across the app with support
/// for different button types (primary, secondary, destructive, LinkedIn), icons,
/// loading states, and accessibility features.
/// 
/// The button automatically handles press states with visual feedback and supports
/// both text-only and icon-only configurations.
/// 
/// Example usage:
/// ```dart
/// // Basic primary button
/// ActionButton(
///   label: 'Save Changes',
///   onPressed: () => saveData(),
/// )
/// 
/// // Icon button with custom style
/// ActionButton(
///   icon: context.themedIcon('add'),
///   isIconOnly: true,
///   style: ActionButtonType.secondary,
///   onPressed: () => addItem(),
/// )
/// 
/// // Disabled button
/// ActionButton(
///   label: 'Submit',
///   isDisabled: true,
///   onPressed: null,
/// )
/// ```
/// 
/// See also:
/// * [ActionButtonType] for available button styles
/// * [OptionButton] for selection-based buttons
class ActionButton extends StatefulWidget {
  /// The text label displayed on the button. Required unless [isIconOnly] is true.
  final String? label;
  
  /// Called when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;
  
  /// The visual style variant for this button. Defaults to [ActionButtonType.primary].
  final ActionButtonType style;
  
  /// Optional icon widget to display alongside or instead of the label.
  /// This can be any widget, typically a themed icon from context.themedIcon()
  final Widget? icon;
  
  /// Whether the button should appear disabled. Defaults to false.
  /// 
  /// When disabled, the button becomes non-interactive and uses reduced opacity.
  final bool isDisabled;
  
  /// Optional custom width for the button. Defaults to full width.
  final double? width;
  
  /// Whether this button should only show an icon without a label.
  /// 
  /// When true, [icon] must be provided and [label] is ignored.
  final bool isIconOnly;
  
  /// Whether the button is in a loading state.
  /// 
  /// When true, shows a progress indicator and disables the button.
  /// The label is hidden and replaced with a spinner.
  final bool isLoading;

  /// Creates an [ActionButton] widget.
  /// 
  /// Either [label] must be provided, or [icon] must be provided with [isIconOnly] set to true.
  const ActionButton({
    super.key,
    this.label,
    this.onPressed,
    this.style = ActionButtonType.primary,
    this.icon,
    this.isDisabled = false,
    this.width,
    this.isIconOnly = false,
    this.isLoading = false,
  }) : assert(label != null || (icon != null && isIconOnly), 
         'Either label must be provided or icon must be provided with isIconOnly=true');

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final isActuallyDisabled = widget.isDisabled || widget.onPressed == null || widget.isLoading;
    final isIconOnlyButton = widget.isIconOnly && widget.icon != null;
    final theme = context.venyuTheme;
    
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActuallyDisabled ? null : widget.onPressed,
          splashFactory: NoSplash.splashFactory,
          highlightColor: theme.highlightColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Opacity(
            opacity: isActuallyDisabled ? 0.7 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.style.backgroundColor(context),
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                border: Border.all(
                  color: widget.style.borderColor(context),
                  width: AppModifiers.extraThinBorder,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isIconOnlyButton ? 0 : 16,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: PlatformCircularProgressIndicator(
                          cupertino: (_, __) => CupertinoProgressIndicatorData(
                            color: widget.style.textColor(context),
                          ),
                          material: (_, __) => MaterialProgressIndicatorData(
                            color: widget.style.textColor(context),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            isIconOnlyButton
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    context.venyuTheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                  child: widget.icon!,
                                )
                              : widget.icon!,
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