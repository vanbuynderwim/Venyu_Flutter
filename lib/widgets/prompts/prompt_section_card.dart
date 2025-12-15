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

  const PromptSectionCard({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final gradientColor = venyuTheme.gradientPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColor.withValues(alpha: 0.1),
            venyuTheme.adaptiveBackground.withValues(alpha: 0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: Text(
        prompt.interactionType != null
            ? '${prompt.interactionType!.selectionTitle(context)} ${prompt.label}'
            : prompt.label,
        style: AppTextStyles.subheadline.copyWith(
          color: venyuTheme.primaryText,
          fontSize: 14,
          fontFamily: AppFonts.graphie,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
