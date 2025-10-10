import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/prompt_interaction.dart';
import '../../models/enums/action_button_type.dart';
import '../common/interaction_tag.dart';
import '../buttons/action_button.dart';

/// PromptInteractionItemView - Displays a single prompt interaction
///
/// Shows:
/// - Interaction type tag
/// - Timestamp (time ago)
/// - Action button to enable/disable matching
class PromptInteractionItemView extends StatelessWidget {
  final PromptInteraction interaction;
  final ValueChanged<bool>? onMatchingToggled;

  const PromptInteractionItemView({
    super.key,
    required this.interaction,
    this.onMatchingToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppLayoutStyles.cardDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Interaction tag
          InteractionTag(
            interactionType: interaction.interactionType,
            compact: false,
          ),

          const SizedBox(width: 12),

          // Spacer to push button to the right
          Expanded(child: SizedBox.shrink()),

          // Action button
          ActionButton(
            label: interaction.matchingEnabled
                ? l10n.promptInteractionPauseButton
                : l10n.promptInteractionResumeButton,
            type: interaction.matchingEnabled
                ? ActionButtonType.destructive
                : ActionButtonType.primary,
            onPressed: onMatchingToggled != null
                ? () => onMatchingToggled!(!interaction.matchingEnabled)
                : null,
            isCompact: true,
          ),
        ],
      ),
    );
  }
}
