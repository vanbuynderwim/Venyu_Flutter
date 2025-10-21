import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/helpers/get_matched_helper.dart';
import '../buttons/fab_button.dart';
import '../buttons/action_button.dart';
import '../../l10n/app_localizations.dart';

/// Reusable GetMatchedButton widget that opens InteractionTypeSelectionView
///
/// This widget provides a consistent "Get matched" button that can be used
/// across the app in different contexts. It can be displayed as either:
/// - A FABButton (floating action button style)
/// - An ActionButton (full-width button style)
///
/// The optional venueId parameter allows the button to pass venue context
/// to the interaction type selection view when opened from venue-specific screens.
class GetMatchedButton extends StatelessWidget {
  /// The type of button to display
  final GetMatchedButtonType buttonType;

  /// Optional venue ID to pass to the interaction selection
  final String? venueId;

  /// Optional callback when the modal is closed with a result
  final Function(bool?)? onModalClosed;

  /// Whether the button should be visible (for FAB button type)
  final bool isVisible;

  /// Whether this button is used in PromptsView (affects modal behavior)
  final bool isFromPrompts;

  const GetMatchedButton({
    super.key,
    required this.buttonType,
    this.venueId,
    this.onModalClosed,
    this.isVisible = true,
    this.isFromPrompts = false,
  });

  /// Opens the interaction type selection modal
  Future<void> _openAddPromptModal(BuildContext context) async {
    final result = await GetMatchedHelper.openGetMatchedModal(
      context: context,
      venueId: venueId,
      isFromPrompts: isFromPrompts,
      callerContext: 'GetMatchedButton',
    );

    // Call the optional callback with the result
    onModalClosed?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case GetMatchedButtonType.fab:
        if (!isVisible) return const SizedBox.shrink();
        return FABButton(
          icon: context.themedIcon('edit'),
          label: null,
          onPressed: () => _openAddPromptModal(context),
        );

      case GetMatchedButtonType.action:
        return ActionButton(
          label: AppLocalizations.of(context)!.getMatchedButtonLabel,
          onPressed: () => _openAddPromptModal(context),
          icon: context.themedIcon('edit'),
        );
    }
  }
}

/// The type of button to display
enum GetMatchedButtonType {
  /// Floating action button style (used in PromptsView)
  fab,

  /// Full-width action button style (used in VenueDetailView and empty states)
  action,
}