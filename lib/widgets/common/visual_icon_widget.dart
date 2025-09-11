import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// VisualIconWidget - Reusable circular visual icon component
/// 
/// A standardized component for displaying visual icons in a circular container.
/// Commonly used in edit views, empty states, and other UI components that need
/// a prominent visual element.
/// 
/// Features:
/// - Circular container with consistent styling
/// - Asset image loading with error handling
/// - Fallback icon support
/// - Configurable sizes and colors
/// - Theme-aware styling
/// - Automatic asset path generation from icon name
/// 
/// Example usage:
/// ```dart
/// VisualIconWidget(
///   iconName: 'notification',
///   fallbackIcon: Icons.notifications_outlined,
///   size: 120,
///   imageSize: 100,
/// )
/// ```
class VisualIconWidget extends StatelessWidget {
  /// Name of the icon (without path or extension)
  final String iconName;
  
  /// Size of the circular container
  final double size;
  
  /// Size of the image/icon inside the container
  final double imageSize;
  
  /// Color tint to apply to the image
  final Color? imageColor;

  const VisualIconWidget({
    super.key,
    required this.iconName,
    this.size = 80,
    this.imageSize = 60,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: AppLayoutStyles.circleDecoration(context),
        child: Center(
          child: Image.asset(
            'assets/images/visuals/$iconName.png',
            width: imageSize,
            height: imageSize,
            color: imageColor ?? venyuTheme.primary
          ),
        ),
      ),
    );
  }
}