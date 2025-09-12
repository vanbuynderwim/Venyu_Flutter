import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// LoadingStateWidget - Reusable loading state component
/// 
/// Provides a consistent fullscreen loading state UI across the app.
/// Designed to replace duplicated loading state code in various views.
/// 
/// Features:
/// - Platform-aware progress indicator
/// - Always centered and fullscreen
/// - Consistent with app theme
/// 
/// Example usage:
/// ```dart
/// const LoadingStateWidget()
/// ```
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlatformCircularProgressIndicator(),
    );
  }
}