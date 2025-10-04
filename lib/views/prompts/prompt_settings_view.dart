import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../widgets/prompts/first_call_settings_widget.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/buttons/action_button.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/helpers/prompt_submission_helper.dart';
import '../../mixins/error_handling_mixin.dart';

/// Prompt First Call configuration view
///
/// This view allows users to configure First Call settings for their prompt.
/// Features:
/// - Shows First Call settings widget
/// - No prompt preview (as requested)
/// - Submit button to save prompt
class PromptSettingsView extends StatefulWidget {
  final InteractionType interactionType;
  final String promptLabel;
  final Venue? selectedVenue;
  final Prompt? existingPrompt;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;

  const PromptSettingsView({
    super.key,
    required this.interactionType,
    required this.promptLabel,
    this.selectedVenue,
    this.existingPrompt,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  @override
  State<PromptSettingsView> createState() => _PromptSettingsViewState();
}

class _PromptSettingsViewState extends State<PromptSettingsView> with ErrorHandlingMixin {
  bool _withPreview = false;
  final bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    // If editing existing prompt, use its preview setting
    if (widget.existingPrompt != null) {
      _withPreview = widget.existingPrompt!.withPreview ?? false;
    }
  }

  /// Handle submit button - saves the prompt
  Future<void> _handleSubmit() async {
    AppLogger.info('Submitting prompt with First Call: $_withPreview', context: 'PromptSettingsView');

    await executeWithLoading(
      operation: () async {
        await PromptSubmissionHelper.submitPrompt(
          context: context,
          interactionType: widget.interactionType,
          promptLabel: widget.promptLabel,
          promptId: widget.existingPrompt?.promptID,
          venueId: widget.selectedVenue?.id,
          withPreview: _withPreview,
          isFromPrompts: widget.isFromPrompts,
          onCloseModal: widget.onCloseModal,
        );
      },
      useProcessingState: true,
      showSuccessToast: false, // Don't show success toast as we're navigating away
      showErrorToast: true,
      errorMessage: 'Failed to submit prompt',
    );
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.interactionType.color,
            venyuTheme.adaptiveBackground,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Radar background overlay
          const RadarBackgroundOverlay(),

          // Main content
          PlatformScaffold(
            backgroundColor: Colors.transparent,
            appBar: PlatformAppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: venyuTheme.darkText,
                ),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // First Call settings widget
                          FirstCallSettingsWidget(
                            withPreview: _withPreview,
                            onChanged: (value) {
                              setState(() => _withPreview = value);
                            },
                            isEditing: widget.existingPrompt != null,
                            hasVenue: widget.selectedVenue != null,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Submit button at bottom
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ActionButton(
                      label: 'Submit',
                      onInvertedBackground: true,
                      onPressed: _isProcessing ? null : _handleSubmit,
                      isLoading: _isProcessing,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}