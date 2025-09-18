import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/models.dart';
import '../common/interaction_tag.dart';

/// Reusable widget for displaying a prompt
///
/// This widget displays a prompt in the same style as used in daily_prompts_view.
/// Can be used across different views for consistent prompt display.
class PromptDisplayWidget extends StatelessWidget {
  final String promptLabel;
  final InteractionType? interactionType;
  final bool showInteractionType;

  const PromptDisplayWidget({
    super.key,
    required this.promptLabel,
    this.interactionType,
    this.showInteractionType = false,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main prompt text
              Text(
                promptLabel,
                style: TextStyle(
                  color: venyuTheme.darkText,
                  fontSize: 36,
                  fontFamily: AppFonts.graphie,
                ),
                textAlign: TextAlign.center,
              ),

              // Interaction tag (if provided and showInteractionType is true)
              if (showInteractionType && interactionType != null) ...[
                const SizedBox(height: 24),
                InteractionTag(
                  interactionType: interactionType!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}