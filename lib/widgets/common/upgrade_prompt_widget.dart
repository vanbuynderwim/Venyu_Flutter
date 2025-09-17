import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../views/subscription/paywall_view.dart';
import '../../core/theme/app_modifiers.dart';

/// Reusable upgrade prompt widget for non-Pro users
/// 
/// This widget displays a customizable upgrade prompt with a lock icon,
/// title, subtitle, and upgrade button. When the button is pressed,
/// it shows a fullscreen paywall modal using showPlatformModalSheet.
/// 
/// Example usage:
/// ```dart
/// UpgradePromptWidget(
///   title: 'Unlock mutual interests',
///   subtitle: 'See what you share on a personal level with Venyu Pro',
///   buttonText: 'Upgrade now',
/// )
/// ```
class UpgradePromptWidget extends StatelessWidget {
  /// The main title text displayed in the prompt
  final String title;
  
  /// The subtitle/description text displayed below the title
  final String subtitle;
  
  /// The text displayed on the upgrade button
  final String buttonText;
  
  /// Optional override color for the icon
  final Color? iconColor;
  
  /// Optional override color for the container background
  final Color? backgroundColor;
  
  /// Optional override color for the border
  final Color? borderColor;
  
  /// Optional callback when subscription is completed
  final VoidCallback? onSubscriptionCompleted;

  const UpgradePromptWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.onSubscriptionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? venyuTheme.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? venyuTheme.info.withValues(alpha: 0.2),
          width: AppModifiers.thinBorder,
        ),
      ),
      child: Column(
        children: [
          context.themedIcon(
            'lock',
            size: 40,
            selected: true,
            overrideColor: iconColor ?? venyuTheme.info,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: venyuTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.subheadline2.copyWith(
              color: venyuTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              type: ActionButtonType.unlock,
              label: buttonText,
              onPressed: () => _showPaywall(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Show paywall in fullscreen modal
  void _showPaywall(BuildContext context) async {
    final result = await showPlatformModalSheet<bool>(
      context: context,
      material: MaterialModalSheetData(
        useRootNavigator: false,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: true,
      ),
      builder: (sheetContext) => const PaywallView(),
    );
    
    // If subscription was completed, trigger callback
    if (result == true && onSubscriptionCompleted != null) {
      onSubscriptionCompleted!();
    }
  }
}