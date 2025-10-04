import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../buttons/action_button.dart';
import 'visual_icon_widget.dart';

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
  
  /// Themed icon name (from assets/images/icons/ or visuals/)
  final String iconName;
  
  /// Optional action button callback
  final VoidCallback? onAction;
  
  /// Text for the action button
  final String? actionText;
  
  /// Optional icon for the action button
  final Widget? actionButtonIcon;
  
  /// Height of the empty state container
  final double height;
  
  /// Whether to show the empty state at full widget height
  final bool fullHeight;
  
  /// Size of the icon
  final double iconSize;
  

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.iconName,
    this.description,
    this.onAction,
    this.actionText,
    this.actionButtonIcon,
    this.height = 300,
    this.fullHeight = false,
    this.iconSize = 60
  });

  /// Builds the icon with safe fallback for themedIcon errors
  Widget _buildIcon(BuildContext context) {
    return VisualIconWidget(
        iconName: iconName,
        imageSize: iconSize,
      );
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
          style: AppTextStyles.headline.primaryText(context),
          textAlign: TextAlign.center,
        ),
        
        // Description
        if (description != null) ...[
          AppModifiers.verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description!,
              style: AppTextStyles.subheadline.secondary(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        
        // Action button
        if (onAction != null && actionText != null) ...[
          const SizedBox(height: 24),
          ActionButton(
            label: actionText!,
            icon: actionButtonIcon,
            onPressed: onAction,
            width: 200,
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