import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../core/utils/app_logger.dart';
import '../../views/prompts/prompt_finish_view.dart';

/// Helper class for handling prompt submissions across different views
///
/// This class provides a centralized way to submit prompts to avoid duplication
/// across prompt_preview_view, prompt_select_venue_view, and prompt_settings_view.
class PromptSubmissionHelper {
  /// Submit a prompt and navigate to the finish view
  ///
  /// This method handles the upsertPrompt call and navigation to PromptFinishView.
  /// It's used by multiple prompt creation/editing views to avoid code duplication.
  static Future<void> submitPrompt({
    required BuildContext context,
    required InteractionType interactionType,
    required String promptLabel,
    String? promptId,
    String? venueId,
    bool withPreview = false,
    bool isFromPrompts = false,
    VoidCallback? onCloseModal,
  }) async {
    AppLogger.info('Submitting prompt: $promptLabel', context: 'PromptSubmissionHelper');

    try {
      final contentManager = ContentManager.shared;

      // Call upsertPrompt with all configurations
      await contentManager.upsertPrompt(
        promptId,
        interactionType,
        promptLabel,
        venueId: venueId,
        withPreview: withPreview,
      );

      if (!context.mounted) return;

      // Navigate to finish view
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptFinishView(
            interactionType: interactionType,
            isFromPrompts: isFromPrompts,
            onCloseModal: onCloseModal,
          ),
        ),
      );

      AppLogger.success('Prompt submitted successfully', context: 'PromptSubmissionHelper');
    } catch (e) {
      AppLogger.error('Failed to submit prompt', error: e, context: 'PromptSubmissionHelper');
      rethrow; // Let the calling view handle the error with its own error handling
    }
  }
}