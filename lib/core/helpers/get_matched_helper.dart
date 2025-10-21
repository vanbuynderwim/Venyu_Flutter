import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../utils/app_logger.dart';
import '../../views/prompts/interaction_type_selection_view.dart';

/// Helper class to handle "Get Matched" functionality across the app
/// This avoids code duplication between different views
class GetMatchedHelper {
  /// Opens the interaction type selection modal
  /// Returns true if a prompt was created, false or null otherwise
  static Future<bool?> openGetMatchedModal({
    required BuildContext context,
    String? venueId,
    bool isFromPrompts = false,
    String? callerContext = 'GetMatchedHelper',
  }) async {
    HapticFeedback.selectionClick();
    AppLogger.debug(
      'Opening interaction type selection${venueId != null ? " for venue: $venueId" : ""}...',
      context: callerContext
    );

    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (modalContext) {
          AppLogger.debug('Building InteractionTypeSelectionView...', context: callerContext);
          return InteractionTypeSelectionView(
            venueId: venueId,
            isFromPrompts: isFromPrompts,
          );
        },
      );

      if (result == true) {
        AppLogger.success(
          'Interaction type selection completed successfully',
          context: callerContext
        );
      }

      return result;
    } catch (error) {
      AppLogger.error(
        'Error opening interaction type selection modal: $error',
        context: callerContext
      );
      return null;
    }
  }
}