import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/prompt.dart';

/// Reusable prompt section card widget
///
/// Displays a prompt with gradient background, interaction type icon, and label.
/// Used in notification items and match items.
class PromptSectionCard extends StatelessWidget {
  final Prompt prompt;
  final String? matchFirstName;
  final bool compact;

  const PromptSectionCard({
    super.key,
    required this.prompt,
    this.matchFirstName,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Use matchInteractionType color if available, otherwise fallback to gradientPrimary
    final gradientColor = prompt.matchInteractionType?.color ?? prompt.interactionType?.color ?? venyuTheme.gradientPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradientColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: Text(
        prompt.buildTitle(context, matchFirstName: matchFirstName, compact: compact),
        style: AppTextStyles.footnote.copyWith(
          color: venyuTheme.primaryText
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
