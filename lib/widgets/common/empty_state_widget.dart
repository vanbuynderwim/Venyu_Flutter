import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';

/// EmptyStateWidget - Reusable empty state component
/// 
/// Provides a consistent empty state UI across the app with custom messaging.
/// Designed to replace duplicated empty state code in various views.
/// 
/// Features:
/// - Configurable message and description
/// - Custom icon support (themed or custom)
/// - Optional action button
/// - Consistent styling with app theme
/// - Accessibility support
/// - Responsive height configuration
/// 
/// Example usage:
/// ```dart
/// EmptyStateWidget(
///   message: 'No matches yet',
///   description: 'Start connecting to see matches here',
///   iconName: 'match',
///   onAction: () => Navigator.push(...),
///   actionText: 'Explore',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// Primary message to display
  final String message;
  
  /// Optional description/subtitle
  final String? description;
  
  /// Themed icon name (from assets/images/icons/)
  final String? iconName;
  
  /// Custom icon widget (overrides iconName if provided)
  final Widget? customIcon;
  
  /// Optional action button callback
  final VoidCallback? onAction;
  
  /// Text for the action button
  final String? actionText;
  
  /// Height of the empty state container
  final double height;
  
  /// Whether to show the empty state at full widget height
  final bool fullHeight;
  
  /// Size of the icon
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.description,
    this.iconName,
    this.customIcon,
    this.onAction,
    this.actionText,
    this.height = 300,
    this.fullHeight = false,
    this.iconSize = 80,
  });

  /// Builds the icon with safe fallback for themedIcon errors
  Widget _buildIcon(BuildContext context) {
    if (customIcon != null) {
      return customIcon!;
    } else if (iconName != null) {
      return context.themedIcon(iconName!, size: iconSize);
    } else {
      return Icon(
        Icons.inbox_outlined,
        size: iconSize,
        color: context.venyuTheme.disabledText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with safe fallback
        _buildIcon(context),
        
        AppModifiers.verticalSpaceMedium,
        
        // Primary message
        Text(
          message,
          style: AppTextStyles.subheadline.primaryText(context),
          textAlign: TextAlign.center,
        ),
        
        // Description
        if (description != null) ...[
          AppModifiers.verticalSpaceSmall,
          Text(
            description!,
            style: AppTextStyles.body.secondary(context),
            textAlign: TextAlign.center,
          ),
        ],
        
        // Action button
        if (onAction != null && actionText != null) ...[
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
        ],
      ],
    );

    if (fullHeight) {
      return Center(child: content);
    }

    return SizedBox(
      height: height,
      child: Center(child: content),
    );
  }
}