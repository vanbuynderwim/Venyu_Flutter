import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../views/prompts/interaction_type_selection_view.dart';
import '../buttons/fab_button.dart';
import '../buttons/action_button.dart';

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

  const GetMatchedButton({
    super.key,
    required this.buttonType,
    this.venueId,
    this.onModalClosed,
    this.isVisible = true,
  });

  /// Opens the interaction type selection modal
  Future<void> _openAddPromptModal(BuildContext context) async {
    HapticFeedback.selectionClick();
    AppLogger.debug(
      'Opening interaction type selection${venueId != null ? " for venue: $venueId" : ""}...',
      context: 'GetMatchedButton'
    );

    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) {
          AppLogger.debug('Building InteractionTypeSelectionView...', context: 'GetMatchedButton');
          return InteractionTypeSelectionView(
            venueId: venueId,
          );
        },
      );

      if (result != null) {
        AppLogger.success('Interaction type selection completed with result: $result',
            context: 'GetMatchedButton');
      }

      // Call the optional callback with the result
      onModalClosed?.call(result);
    } catch (error) {
      AppLogger.error('Error opening interaction type selection modal: $error',
          context: 'GetMatchedButton');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case GetMatchedButtonType.fab:
        if (!isVisible) return const SizedBox.shrink();
        return FABButton(
          icon: context.themedIcon('edit'),
          label: 'Get matched',
          onPressed: () => _openAddPromptModal(context),
        );

      case GetMatchedButtonType.action:
        return ActionButton(
          label: 'Get matched',
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