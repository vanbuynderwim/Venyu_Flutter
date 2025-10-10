import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../models/prompt.dart';
import '../../../models/enums/prompt_status.dart';
import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/status_badge_view.dart';
import '../../../widgets/common/upgrade_prompt_widget.dart';

/// PromptCardSection - Displays detailed prompt card information
///
/// This widget shows detailed information about the prompt card including:
/// - Creation and review dates
/// - Current status with badge
/// - Online duration with Pro upgrade prompt for free users
///
/// Features:
/// - Pro vs free user distinction
/// - Card online duration tracking
/// - Upgrade prompt for extended card visibility
class PromptCardSection extends StatelessWidget {
  final Prompt? prompt;
  final bool isLoading;

  const PromptCardSection({
    super.key,
    required this.prompt,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || prompt == null) {
      return const LoadingStateWidget();
    }

    final l10n = AppLocalizations.of(context)!;
    final isPro = context.profileService.currentProfile?.isPro ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: AppModifiers.cardContentPadding,
        decoration: BoxDecoration(
          color: context.venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          border: Border.all(
            color: context.venyuTheme.borderColor,
            width: AppModifiers.extraThinBorder,
          ),
        ),
        child: Column(
          children: [
            // Created date
            _buildInfoRow(
              context,
              label: l10n.promptCardCreatedLabel,
              value: prompt!.createdAt?.timeAgoFull() ?? '-',
            ),

            const SizedBox(height: 12),

            // Reviewed date
            _buildInfoRow(
              context,
              label: l10n.promptCardReviewedLabel,
              value: prompt!.reviewedAt?.timeAgoFull() ?? '-',
            ),

            const SizedBox(height: 12),

            // Status
            _buildStatusRow(context),

            // Upgrade prompt for free users
            if (AppConfig.showPro && !isPro && prompt!.status == PromptStatus.approved) ...[
              const SizedBox(height: 16),
              UpgradePromptWidget(
                title: l10n.promptCardUpgradeTitle,
                subtitle: l10n.promptCardUpgradeSubtitle,
                buttonText: l10n.promptCardUpgradeButton,
                onSubscriptionCompleted: () {
                  // The parent view will handle the refresh
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String label, required String value}) {
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.venyuTheme.secondaryText.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$label:',
            style: AppTextStyles.footnote.copyWith(
              color: context.venyuTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.subheadline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.venyuTheme.secondaryText.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${l10n.promptCardStatusLabel}:',
            style: AppTextStyles.footnote.copyWith(
              color: context.venyuTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        StatusBadgeView(
          status: prompt!.displayStatus,
          compact: true,
        ),
      ],
    );
  }

}