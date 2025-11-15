import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';

/// MenuOptionBuilder - Reusable widget for creating platform-aware PopupMenuOptions
///
/// This utility class simplifies the creation of PopupMenuOptions with consistent
/// styling across iOS and Android platforms. It handles:
/// - Icon and text layout with proper spacing
/// - Platform-specific styling (Cupertino vs Material)
/// - Destructive/error actions with proper coloring
/// - Default actions (iOS-specific)
///
/// Usage:
/// ```dart
/// MenuOptionBuilder.create(
///   context: context,
///   label: 'Delete',
///   iconName: 'delete',
///   onTap: () => handleDelete(),
///   isDestructive: true,
/// )
/// ```
class MenuOptionBuilder {
  MenuOptionBuilder._();

  /// Creates a standard PopupMenuOption with icon and text
  static PopupMenuOption create({
    required BuildContext context,
    required String label,
    required String iconName,
    required Function(PopupMenuOption) onTap,
    bool isDestructive = false,
    bool isDefaultAction = false,
    double iconSize = 24,
  }) {
    final venyuTheme = context.venyuTheme;
    final textColor = isDestructive ? venyuTheme.error : venyuTheme.primaryText;

    return PopupMenuOption(
      label: label,
      onTap: onTap,
      cupertino: (_, _) => CupertinoPopupMenuOptionData(
        isDestructiveAction: isDestructive,
        isDefaultAction: isDefaultAction,
        child: Row(
          children: [
            const SizedBox(width: 8),
            context.themedIcon(iconName, size: iconSize, overrideColor: isDestructive ? venyuTheme.error : venyuTheme.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body.copyWith(color: textColor),
            ),
          ],
        ),
      ),
      material: (_, _) => MaterialPopupMenuOptionData(
        child: Row(
          children: [
            const SizedBox(width: 8),
            context.themedIcon(iconName, size: iconSize, overrideColor: isDestructive ? venyuTheme.error : venyuTheme.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a PopupMenuOption without an icon
  static PopupMenuOption createTextOnly({
    required BuildContext context,
    required String label,
    required Function(PopupMenuOption) onTap,
    bool isDestructive = false,
    bool isDefaultAction = false,
  }) {
    final venyuTheme = context.venyuTheme;
    final textColor = isDestructive ? venyuTheme.error : venyuTheme.primaryText;

    return PopupMenuOption(
      label: label,
      onTap: onTap,
      cupertino: (_, _) => CupertinoPopupMenuOptionData(
        isDestructiveAction: isDestructive,
        isDefaultAction: isDefaultAction,
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(color: textColor),
        ),
      ),
      material: (_, _) => MaterialPopupMenuOptionData(
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(color: textColor),
        ),
      ),
    );
  }
}