import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/role_view.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/prompts/prompt_section_card.dart';

/// MatchItemView - Flutter equivalent of Swift MatchItemView
/// 
/// Displays a match item with profile information in a card layout.
/// Based on the Swift implementation that shows a RoleView with avatar,
/// name, and company information in a tappable card format.
/// 
/// Features:
/// - Tactile feedback with pressed state highlighting
/// - Same interaction feel as SectionButton and OptionButton
/// - Visual opacity changes during press
/// 
/// Example usage:
/// ```dart
/// MatchItemView(
///   match: myMatch,
///   onMatchSelected: (match) => handleMatchSelection(match),
/// )
/// ```
class MatchItemView extends StatefulWidget {
  /// The match data to display
  final Match match;
  
  /// Callback when the match is selected/tapped
  final Function(Match)? onMatchSelected;
  
  /// Whether the avatar should be blurred (true when user is not Pro and not connected)


  const MatchItemView({
    super.key,
    required this.match,
    this.onMatchSelected
  });

  @override
  State<MatchItemView> createState() => _MatchItemViewState();
}

class _MatchItemViewState extends State<MatchItemView> {
  @override
  Widget build(BuildContext context) {
  
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return AppLayoutStyles.interactiveCard(
      context: context,
      onTap: widget.onMatchSelected != null
          ? () => widget.onMatchSelected!(widget.match)
          : null,
      useGradient: false,
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoleView(
              profile: widget.match.profile,
              avatarSize: 85,
              showChevron: true,
              buttonDisabled: false,
              showNotificationDot: widget.match.isViewed == false,
              match: widget.match,
              matchingScore: widget.match.score,
            ),
            if (widget.match.prompt != null) ...[
              AppModifiers.verticalSpaceMedium,
              PromptSectionCard(prompt: widget.match.prompt!),
            ],
            // Stage tag for connections with a stage
            if (widget.match.stage != null) ...[
              AppModifiers.verticalSpaceSmall,
              TagView(
                id: widget.match.stage!.id,
                label: widget.match.stage!.label,
                icon: widget.match.stage!.icon,
                fontSize: AppTextStyles.caption1,
                backgroundColor: venyuTheme.tagBackground,
                textColor: venyuTheme.primaryText,
              ),
            // Reach out info box for connections without stage
            ] else ...[
              AppModifiers.verticalSpaceSmall,
              TagView(
                id: 'match_reach_out',
                label: l10n.matchItemReachOut,
                fontSize: AppTextStyles.caption1,
                backgroundColor: context.venyuTheme.gradientPrimary,
                textColor: Colors.white,
                icon: 'edit',
                color: Colors.white,
                isLocal: true,
              ),
            ],
            // Optional prompt section
            
          ],
        ),
      ),
    );
  }
}