import 'package:flutter/material.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// A customizable floating action button that follows the app's design system.
/// 
/// This component provides a consistent FAB interface with proper theming support,
/// highlight effects, and accessibility features. It uses the same interaction
/// patterns as ActionButton for consistency.
/// 
/// Example usage:
/// ```dart
/// FABButton(
///   icon: context.themedIcon('edit'),
///   onPressed: () => openModal(),
///   tooltip: 'Add new item',
/// )
/// ```
class FABButton extends StatelessWidget {
  /// The icon widget to display in the FAB
  final Widget icon;
  
  /// Called when the button is pressed
  final VoidCallback? onPressed;
  
  /// Optional text label to display next to the icon
  final String? label;
  
  /// Custom background color. If null, uses theme primary color
  final Color? backgroundColor;
  
  /// Custom icon color. If null, uses appropriate contrast color based on background
  final Color? iconColor;
  
  /// Size of the FAB. Defaults to 56 (standard Material FAB size)
  final double size;

  const FABButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.iconColor,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    // Use ActionButtonType.primary for all styling to ensure consistency
    final buttonType = ActionButtonType.primary;
    final effectiveBackgroundColor = backgroundColor ?? buttonType.backgroundColor(context);
    final effectiveIconColor = iconColor ?? buttonType.textColor(context);
    final isDisabled = onPressed == null;
    
    return Material(
      color: effectiveBackgroundColor,
      elevation: isDisabled ? 2 : 6, // Standard FAB elevations
      borderRadius: BorderRadius.circular(AppModifiers.defaultRadius), // Consistent with other buttons
      child: Opacity(
        opacity: isDisabled ? 0.7 : 1.0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          highlightColor: buttonType.highlightColor(context),
          splashFactory: NoSplash.splashFactory,
          child: SizedBox(
            width: label != null ? null : size, // Allow width to expand if there's a label
            height: size,
            child: Padding(
              padding: label != null 
                  ? const EdgeInsets.symmetric(horizontal: 16) 
                  : EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      effectiveIconColor,
                      BlendMode.srcIn,
                    ),
                    child: icon,
                  ),
                  if (label != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      label!,
                      style: AppTextStyles.body.copyWith(
                        color: effectiveIconColor,
                        fontWeight: buttonType.fontWeight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}