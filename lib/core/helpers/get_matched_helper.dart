import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../utils/app_logger.dart';
import '../../models/enums/interaction_type.dart';
import '../../views/prompts/prompt_edit_view.dart';

/// Helper class to handle "Get Matched" functionality across the app
/// This avoids code duplication between different views
class GetMatchedHelper {
  /// Opens the prompt edit modal directly with the specified interaction type
  /// Returns true if a prompt was created, false or null otherwise
  static Future<bool?> openGetMatchedModal({
    required BuildContext context,
    required InteractionType initialInteractionType,
    String? venueId,
    bool isFromPrompts = false,
    String? callerContext = 'GetMatchedHelper',
  }) async {
    HapticFeedback.selectionClick();
    AppLogger.debug(
      'Opening prompt edit with type: ${initialInteractionType.value}${venueId != null ? " for venue: $venueId" : ""}...',
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
          AppLogger.debug('Building PromptEditView...', context: callerContext);
          return PromptEditView(
            initialInteractionType: initialInteractionType,
            isNewPrompt: true,
            isFromPrompts: isFromPrompts,
            venueId: venueId,
          );
        },
      );

      if (result == true) {
        AppLogger.success(
          'Prompt created successfully',
          context: callerContext
        );
      }

      return result;
    } catch (error) {
      AppLogger.error(
        'Error opening prompt edit modal: $error',
        context: callerContext
      );
      return null;
    }
  }
}