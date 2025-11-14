import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../models/venue.dart';
import '../common/interaction_tag.dart';
import '../common/venue_tag.dart';
import '../common/tag_view.dart';
import 'selection_title_with_icon.dart';

/// Reusable widget for displaying a prompt
///
/// This widget displays a prompt in the same style as used in daily_prompts_view.
/// Can be used across different views for consistent prompt display.
class PromptDisplayWidget extends StatelessWidget {
  final String promptLabel;
  final InteractionType? interactionType;
  final bool showInteractionType;
  final Venue? venue;
  final bool isFirstTimeUser;
  final bool showSelectionTitle;

  const PromptDisplayWidget({
    super.key,
    required this.promptLabel,
    this.interactionType,
    this.showInteractionType = false,
    this.venue,
    this.isFirstTimeUser = false,
    this.showSelectionTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selection title (if enabled)
              if (showSelectionTitle && interactionType != null) ...[
                Center(
                  child: SelectionTitleWithIcon(
                    interactionType: interactionType!,
                    size: 18,
                    color: venyuTheme.darkText,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
              ],

              // Main prompt text
              Text(
                promptLabel,
                style: TextStyle(
                  color: venyuTheme.darkText,
                  fontSize: 18,
                  fontFamily: AppFonts.graphie,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              // Example tag (for first time users)
              if (isFirstTimeUser) ...[
                const SizedBox(height: 16),
                TagView(
                  id: 'example',
                  emoji: '👆',
                  label: l10n.dailyPromptsExampleTag
                ),
              ],

              // Venue tag (if provided)
              if (venue != null) ...[
                const SizedBox(height: 16),
                VenueTag(
                  venue: venue!,
                  compact: true,
                ),
              ],

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