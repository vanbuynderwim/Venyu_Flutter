import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import 'role_view.dart';

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

  const MatchItemView({
    super.key,
    required this.match,
    this.onMatchSelected,
  });

  @override
  State<MatchItemView> createState() => _MatchItemViewState();
}

class _MatchItemViewState extends State<MatchItemView> {
  /// Tracks whether the item is currently being pressed for visual feedback
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onMatchSelected == null;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () => widget.onMatchSelected!(widget.match),
          onTapDown: isDisabled ? null : (_) => setState(() => isPressed = true),
          onTapUp: isDisabled ? null : (_) => setState(() => isPressed = false),
          onTapCancel: isDisabled ? null : () => setState(() => isPressed = false),
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Opacity(
            opacity: context.getInteractiveOpacity(
              isDisabled: isDisabled, 
              isPressed: isPressed,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoleView(
                    profile: widget.match.profile,
                    avatarSize: 60,
                    showChevron: true,
                    buttonDisabled: false,
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