import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../widgets/common/role_view.dart';

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
  final bool shouldBlur;

  const MatchItemView({
    super.key,
    required this.match,
    this.onMatchSelected,
    this.shouldBlur = false,
  });

  @override
  State<MatchItemView> createState() => _MatchItemViewState();
}

class _MatchItemViewState extends State<MatchItemView> {
  @override
  Widget build(BuildContext context) {
    final isConnection = widget.match.isConnected;

    return AppLayoutStyles.interactiveCard(
      context: context,
      onTap: widget.onMatchSelected != null
          ? () => widget.onMatchSelected!(widget.match)
          : null,
      useGradient: !isConnection,
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoleView(
              profile: widget.match.profile_1,
              avatarSize: 80,
              showChevron: true,
              buttonDisabled: false,
              shouldBlur: widget.shouldBlur,
              showNotificationDot: !widget.match.isConnected,
              match: widget.match,
            ),
          ],
        ),
      ),
    );
  }
}