import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_layout_styles.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/match.dart';
import '../../../models/profile.dart';
import '../../prompts/prompt_item.dart';
import '../../prompts/prompt_detail_view.dart';
import '../match_overview_header.dart';

/// MatchPromptsSection - Displays matching prompts/cards section
/// 
/// This widget shows the matching cards between the current user and the match,
/// including the match overview header and individual card items.
/// 
/// Features:
/// - Match overview header with interaction counts
/// - Individual card items with shared view styling
/// - Empty state when no prompts are available
/// - Card selection handling (currently placeholder)
class MatchPromptsSection extends StatelessWidget {
  final Match match;
  final Profile currentProfile;
  final bool? shouldBlur;

  const MatchPromptsSection({
    super.key,
    required this.match,
    required this.currentProfile,
    this.shouldBlur,
  });

  @override
  Widget build(BuildContext context) {
    if (match.prompts == null || match.prompts!.isEmpty) {
      return Container(
        padding: AppModifiers.cardContentPadding,
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No matching cards',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Match Overview Header
        MatchOverviewHeader(
          match: match,
          currentProfile: currentProfile,
          shouldBlur: shouldBlur,
        ),
        
        // Prompt Cards - no spacing between cards in shared view
        ...match.prompts!.asMap().entries.map((entry) {
          final index = entry.key;
          final prompt = entry.value;
          final isFirst = index == 0;
          final isLast = index == match.prompts!.length - 1;

          return PromptItem(
            prompt: prompt,
            isSharedPromptView: true,
            showMatchInteraction: true,
            isFirst: isFirst,
            isLast: isLast,
            limitPromptLines: true,
            onPromptSelected: (selectedPrompt) => _navigateToPromptDetail(context, selectedPrompt.promptID),
          );
        }),
      ],
    );
  }

  /// Navigate to prompt detail view
  void _navigateToPromptDetail(BuildContext context, String promptId) {
    AppLogger.ui('Navigating to prompt detail: $promptId', context: 'MatchPromptsSection');

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => PromptDetailView(promptId: promptId),
      ),
    );
  }
}