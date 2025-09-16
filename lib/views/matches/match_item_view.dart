import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/venyu_theme.dart';
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
    final theme = context.venyuTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isConnection ? theme.cardBackground : null,
        gradient: !isConnection
            ? LinearGradient(
                colors: [
                  AppColors.primair4Lilac.withValues(alpha: 0.25),
                  AppColors.primair4Lilac.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              )
            : null,
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        border: Border.all(
          color: theme.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onMatchSelected != null
              ? () => widget.onMatchSelected!(widget.match)
              : null,
          splashFactory: NoSplash.splashFactory,
          highlightColor: theme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Padding(
            padding: AppModifiers.cardContentPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoleView(
                  profile: widget.match.profile_1,
                  avatarSize: 60,
                  showChevron: true,
                  buttonDisabled: false,
                  shouldBlur: widget.shouldBlur,
                  showNotificationDot: !widget.match.isConnected,
                  match: widget.match,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}