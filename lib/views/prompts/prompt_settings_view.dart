import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../models/venue.dart';
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

  final bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  /// Handle submit button - saves the prompt
  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    

    await executeWithLoading(
      operation: () async {
        await PromptSubmissionHelper.submitPrompt(
          context: context,
          interactionType: widget.interactionType,
          promptLabel: widget.promptLabel,
          promptId: widget.existingPrompt?.promptID,
          venueId: widget.selectedVenue?.id,
          isFromPrompts: widget.isFromPrompts,
          onCloseModal: widget.onCloseModal,
        );
      },
      useProcessingState: true,
      showSuccessToast: false, // Don't show success toast as we're navigating away
      showErrorToast: true,
      errorMessage: l10n.promptSettingsErrorSubmit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.promptSettingsTitle,
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
                        ],
                      ),
                    ),
                  ),

                  // Submit button at bottom
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ActionButton(
                      label: l10n.promptSettingsSubmitButton,
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