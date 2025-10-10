import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../services/profile_service.dart';
import '../common/sub_title.dart';
import '../common/upgrade_prompt_widget.dart';
import '../common/info_box_widget.dart';

/// First Call settings widget for prompts
///
/// This widget displays the First Call (preview) settings for prompts.
/// It can be used in both prompt creation and editing flows.
///
/// Features:
/// - Optional SubTitle display (showTitle parameter)
/// - Explanation of First Call functionality
/// - Toggle to enable/disable (Pro feature or free with venue)
/// - Upgrade prompt for free users (only when no venue selected)
class FirstCallSettingsWidget extends StatelessWidget {
  final bool withPreview;
  final Function(bool) onChanged;
  final bool isEditing; // Whether editing existing prompt vs creating new
  final bool hasVenue; // Whether a venue is selected (makes First Call free)
  final bool showTitle; // Whether to show the SubTitle

  const FirstCallSettingsWidget({
    super.key,
    required this.withPreview,
    required this.onChanged,
    this.isEditing = false,
    this.hasVenue = false,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPro = ProfileService.shared.currentProfile?.isPro ?? false;
    final venyuTheme = context.venyuTheme;
    // First Call is available if: user is Pro OR venue is selected
    final canUseFirstCall = isPro || hasVenue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppLayoutStyles.cardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Conditionally show SubTitle
                if (showTitle) ...[
                  SubTitle(
                    iconName: 'eye',
                    title: l10n.firstCallSettingsTitle,
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  l10n.firstCallSettingsDescription,
                  style: AppTextStyles.subheadline.copyWith(
                    color: venyuTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle section
                Row(
                  children: [
                    if (canUseFirstCall)
                      Text(
                        l10n.firstCallSettingsEnableLabel,
                        style: AppTextStyles.headline.copyWith(
                          color: venyuTheme.primaryText,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    else
                      SizedBox(
                        width: 140,
                        child: UpgradePromptWidget(
                          title: l10n.firstCallSettingsEnableLabel,
                          subtitle: l10n.firstCallSettingsUpgradeSubtitle,
                          buttonText: l10n.firstCallSettingsUpgradeButton,
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
                      onChanged: canUseFirstCall ? onChanged : null,
                      material: (_, __) => MaterialSwitchData(
                        activeColor: AppColors.primair4Lilac,
                      ),
                      cupertino: (_, __) => CupertinoSwitchData(
                        activeColor: AppColors.primair4Lilac,
                        thumbColor: Theme.of(context).brightness == Brightness.dark
                            ? venyuTheme.adaptiveBackground
                            : null,
                      )
                    ),
                  ],
                ),

                // Info text about venue benefit
                if (hasVenue && !isPro) ...[
                  const SizedBox(height: 12),
                  InfoBoxWidget(
                    text: l10n.firstCallSettingsVenueInfo,
                  ),
                ],
              ],
            ),
          ),
    );
  }
}