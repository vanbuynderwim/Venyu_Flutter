import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/helpers/get_matched_helper.dart';
import '../../models/enums/interaction_type.dart';
import '../buttons/fab_button.dart';
import '../buttons/action_button.dart';
import '../../l10n/app_localizations.dart';

/// Reusable GetMatchedButton widget that opens PromptEditView directly
///
/// This widget provides a consistent "Get matched" button that can be used
/// across the app in different contexts. It can be displayed as either:
/// - A FABButton (floating action button style)
/// - An ActionButton (full-width button style)
///
/// The initialInteractionType parameter determines which type of prompt
/// will be created (lookingForThis or thisIsMe).
class GetMatchedButton extends StatelessWidget {
  /// The type of button to display
  final GetMatchedButtonType buttonType;

  /// The interaction type to use when creating a new prompt
  final InteractionType initialInteractionType;

  /// Optional venue ID to pass to the prompt edit view
  final String? venueId;

  /// Optional callback when the modal is closed with a result
  final Function(bool?)? onModalClosed;

  /// Whether the button should be visible (for FAB button type)
  final bool isVisible;

  /// Whether this button is used in PromptsView (affects modal behavior)
  final bool isFromPrompts;

  /// Custom background color for FAB button type
  final Color? backgroundColor;

  const GetMatchedButton({
    super.key,
    required this.buttonType,
    required this.initialInteractionType,
    this.venueId,
    this.onModalClosed,
    this.isVisible = true,
    this.isFromPrompts = false,
    this.backgroundColor,
  });

  /// Opens the prompt edit modal directly
  Future<void> _openAddPromptModal(BuildContext context) async {
    final result = await GetMatchedHelper.openGetMatchedModal(
      context: context,
      initialInteractionType: initialInteractionType,
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
          backgroundColor: backgroundColor,
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