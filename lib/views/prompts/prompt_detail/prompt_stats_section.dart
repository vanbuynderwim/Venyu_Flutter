import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/prompt.dart';
import '../../../widgets/common/loading_state_widget.dart';

/// PromptStatsSection - Displays prompt performance statistics
///
/// This widget shows analytics and performance data for the prompt including:
/// - View counts, match counts, interaction metrics
/// - Performance over time
/// - Engagement statistics
///
/// Features:
/// - Loading state while data is being fetched
/// - Empty state for prompts without stats
/// - Future expansion for detailed analytics
class PromptStatsSection extends StatelessWidget {
  final Prompt? prompt;
  final bool isLoading;

  const PromptStatsSection({
    super.key,
    required this.prompt,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading || prompt == null) {
      return const LoadingStateWidget();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.analytics_outlined,
            size: 48,
            color: context.venyuTheme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.promptStatsTitle,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.promptStatsDescription,
            style: AppTextStyles.body.copyWith(
              color: context.venyuTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}