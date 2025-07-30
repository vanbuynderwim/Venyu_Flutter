import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import 'role_view.dart';

/// MatchItemView - Flutter equivalent of Swift MatchItemView
/// 
/// Displays a match item with profile information in a card layout.
/// Based on the Swift implementation that shows a RoleView with avatar,
/// name, and company information in a tappable card format.
/// 
/// Example usage:
/// ```dart
/// MatchItemView(
///   match: myMatch,
///   onMatchSelected: (match) => handleMatchSelection(match),
/// )
/// ```
class MatchItemView extends StatelessWidget {
  /// The match data to display
  final Match match;
  
  /// Callback when the match is selected/tapped
  final Function(Match)? onMatchSelected;

  const MatchItemView({
    super.key,
    required this.match,
    this.onMatchSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onMatchSelected != null
              ? () => onMatchSelected!(match)
              : null,
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Container(
            decoration: AppLayoutStyles.cardDecoration(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoleView(
                    profile: match.profile,
                    avatarSize: 60,
                    showChevron: true,
                    buttonDisabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}