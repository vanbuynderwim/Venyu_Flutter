import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// ErrorStateWidget - Reusable error state component
/// 
/// Provides a consistent error state UI across the app with retry functionality.
/// Designed to replace duplicated error state code in various views.
/// 
/// Features:
/// - Configurable error message and title
/// - Optional retry button with callback
/// - Consistent styling with app theme
/// - Accessibility support
/// - Responsive height configuration
/// 
/// Example usage:
/// ```dart
/// ErrorStateWidget(
///   error: 'Failed to load data',
///   title: 'Something went wrong',
///   onRetry: () => _refreshData(),
/// )
/// ```
class ErrorStateWidget extends StatelessWidget {
  /// The error message to display
  final String error;
  
  /// Optional retry callback - if provided, shows retry button
  final VoidCallback? onRetry;
  
  /// Title for the error (defaults to generic message)
  final String title;
  
  /// Height of the error container
  final double height;
  
  /// Whether to show the error at full widget height
  final bool fullHeight;
  
  /// Custom icon to display (defaults to error_outline)
  final IconData? icon;

  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    String? title,
    this.height = 200,
    this.fullHeight = false,
    this.icon,
  }) : title = title ?? '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayTitle = title.isEmpty ? l10n.errorStateDefaultTitle : title;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon ?? Icons.error_outline,
          size: 48,
          color: context.venyuTheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          displayTitle,
          style: AppTextStyles.headline.primaryText(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          error,
          style: AppTextStyles.body.secondary(context),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          PlatformElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.errorStateRetryButton),
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