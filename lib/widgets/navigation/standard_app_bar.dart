import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/theme/app_text_styles.dart';

/// StandardAppBar - Consistent AppBar creation across the app
/// 
/// Provides standardized AppBar patterns with consistent styling and behavior.
/// Eliminates minor inconsistencies in AppBar property usage while maintaining
/// platform-specific behavior through PlatformAppBar.
/// 
/// Features:
/// - Standard, transparent, and elevated styles
/// - Consistent title handling
/// - Platform-aware styling
/// - Reusable action patterns
/// 
/// Usage:
/// ```dart
/// appBar: StandardAppBar.create(
///   title: 'My Page',
///   style: AppBarStyle.standard,
///   trailingActions: [myActionButton],
/// ),
/// ```
class StandardAppBar {
  /// Create a standardized PlatformAppBar with consistent styling
  static PlatformAppBar create({
    required String title,
    AppBarStyle style = AppBarStyle.standard,
    List<Widget>? trailingActions,
    Widget? leading,
    TextStyle? titleStyle,
  }) {
    return PlatformAppBar(
      title: Text(
        title,
        style: titleStyle ?? _getTitleStyle(style),
      ),
      trailingActions: trailingActions,
      leading: leading,
      material: (_, __) => MaterialAppBarData(
        backgroundColor: _getMaterialBackgroundColor(style),
        elevation: _getElevation(style),
      ),
      cupertino: (_, __) => CupertinoNavigationBarData(
        backgroundColor: _getCupertinoBackgroundColor(style),
      ),
    );
  }

  /// Create AppBar for profile-related views with settings action
  static PlatformAppBar forProfile({
    required String title,
    required VoidCallback onSettingsPressed,
    required Widget settingsIcon,
  }) {
    return create(
      title: title,
      trailingActions: [
        PlatformIconButton(
          padding: EdgeInsets.zero,
          icon: settingsIcon,
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }

  /// Create transparent AppBar for onboarding/welcome screens
  static PlatformAppBar transparent({
    required String title,
    TextStyle? titleStyle,
  }) {
    return create(
      title: title,
      style: AppBarStyle.transparent,
      titleStyle: titleStyle ?? AppTextStyles.headline,
    );
  }

  // Private helper methods
  static TextStyle? _getTitleStyle(AppBarStyle style) {
    switch (style) {
      case AppBarStyle.onboarding:
        return AppTextStyles.headline;
      case AppBarStyle.standard:
      case AppBarStyle.transparent:
      case AppBarStyle.elevated:
        return null; // Use theme default
    }
  }

  static Color? _getMaterialBackgroundColor(AppBarStyle style) {
    switch (style) {
      case AppBarStyle.transparent:
      case AppBarStyle.onboarding:
        return Colors.transparent;
      case AppBarStyle.standard:
      case AppBarStyle.elevated:
        return null; // Use theme default
    }
  }

  static Color? _getCupertinoBackgroundColor(AppBarStyle style) {
    switch (style) {
      case AppBarStyle.transparent:
      case AppBarStyle.onboarding:
        return Colors.transparent;
      case AppBarStyle.standard:
      case AppBarStyle.elevated:
        return null; // Use theme default
    }
  }

  static double _getElevation(AppBarStyle style) {
    switch (style) {
      case AppBarStyle.transparent:
      case AppBarStyle.onboarding:
        return 0;
      case AppBarStyle.elevated:
        return 4;
      case AppBarStyle.standard:
        return 1; // Default elevation
    }
  }
}

/// AppBar style variants for consistent theming
enum AppBarStyle {
  /// Default AppBar with theme styling
  standard,
  
  /// Transparent AppBar with no background
  transparent,
  
  /// AppBar with elevated shadow
  elevated,
  
  /// Special styling for onboarding screens
  onboarding,
}