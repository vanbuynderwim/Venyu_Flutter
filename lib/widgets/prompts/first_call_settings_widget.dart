import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../services/profile_service.dart';
import '../common/sub_title.dart';
import '../common/upgrade_prompt_widget.dart';

/// First Call settings widget for prompts
///
/// This widget displays the First Call (preview) settings for prompts.
/// It can be used in both prompt creation and editing flows.
///
/// Features:
/// - Explanation of First Call functionality
/// - Toggle to enable/disable (Pro feature)
/// - Upgrade prompt for free users
class FirstCallSettingsWidget extends StatelessWidget {
  final bool withPreview;
  final Function(bool) onChanged;
  final bool isEditing; // Whether editing existing prompt vs creating new

  const FirstCallSettingsWidget({
    super.key,
    required this.withPreview,
    required this.onChanged,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPro = ProfileService.shared.currentProfile?.isPro ?? false;
    final venyuTheme = context.venyuTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubTitle(
            iconName: 'eye',
            title: 'First Call',
          ),
          const SizedBox(height: 16),

          // Preview explanation card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppLayoutStyles.cardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Others see your card, but the match opens for them only if you show interest first. That way, your profile stays private.',
                  style: AppTextStyles.subheadline.copyWith(
                    color: venyuTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle section
                Row(
                  children: [
                    if (isPro)
                      Text(
                        'Enable',
                        style: AppTextStyles.headline.copyWith(
                          color: venyuTheme.primaryText,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    else
                      SizedBox(
                        width: 140,
                        child: UpgradePromptWidget(
                          title: 'Enable',
                          subtitle: 'Unlock First Call and see the matches first.',
                          buttonText: 'Upgrade to Pro',
                          isCompact: true,
                          onSubscriptionCompleted: () {
                            // Trigger callback with true to enable after upgrade
                            onChanged(true);
                          },
                        ),
                      ),
                    const Spacer(),
                    PlatformSwitch(
                      value: withPreview,
                      onChanged: isPro ? onChanged : null,
                      material: (_, __) => MaterialSwitchData(
                        activeColor: venyuTheme.primary,
                      ),
                      cupertino: (_, __) => CupertinoSwitchData(
                        activeColor: venyuTheme.primary,
                        thumbColor: Theme.of(context).brightness == Brightness.dark
                            ? venyuTheme.cardBackground
                            : null,
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}