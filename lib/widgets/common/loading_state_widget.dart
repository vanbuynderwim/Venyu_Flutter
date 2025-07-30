import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/theme/app_text_styles.dart';

/// LoadingStateWidget - Reusable loading state component
/// 
/// Provides a consistent loading state UI across the app with optional message.
/// Designed to replace duplicated loading state code in various views.
/// 
/// Features:
/// - Configurable height and message
/// - Platform-aware progress indicator
/// - Consistent styling with app theme
/// - Accessibility support
/// 
/// Example usage:
/// ```dart
/// LoadingStateWidget(
///   height: 200,
///   message: 'Loading your data...',
/// )
/// ```
class LoadingStateWidget extends StatelessWidget {
  /// Height of the loading container
  final double height;
  
  /// Optional loading message to display below the spinner
  final String? message;
  
  /// Whether to show the loading indicator at full widget height
  final bool fullHeight;

  const LoadingStateWidget({
    super.key,
    this.height = 200,
    this.message,
    this.fullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlatformCircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppTextStyles.body.secondary(context),
            textAlign: TextAlign.center,
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