import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../widgets/prompts/prompt_display_widget.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/buttons/action_button.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/config/app_config.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../core/utils/app_logger.dart';
import '../../core/helpers/prompt_submission_helper.dart';
import 'prompt_select_venue_view.dart';
import 'prompt_settings_view.dart';

/// Prompt preview view - final step before publishing prompt
///
/// This view displays the final prompt preview and handles the actual save operation.
/// Features:
/// - Shows prompt preview with selected venue (if any)
/// - Handles the upsertPrompt API call
/// - Success/error handling and navigation
class PromptPreviewView extends StatefulWidget {
  final InteractionType interactionType;
  final String promptLabel;
  final Prompt? existingPrompt;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;
  final String? venueId;

  const PromptPreviewView({
    super.key,
    required this.interactionType,
    required this.promptLabel,
    this.existingPrompt,
    this.isFromPrompts = false,
    this.onCloseModal,
    this.venueId,
  });

  @override
  State<PromptPreviewView> createState() => _PromptPreviewViewState();
}

class _PromptPreviewViewState extends State<PromptPreviewView> with ErrorHandlingMixin {
  late final VenueManager _venueManager;

  // State
  List<Venue> _venues = [];
  bool _venuesLoaded = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _venueManager = VenueManager.shared;

    // Fetch venues to determine next step options
    _fetchVenues();
  }

  /// Fetch venues to determine next navigation step
  Future<void> _fetchVenues() async {
    try {
      final venues = await _venueManager.fetchVenues();
      setState(() {
        _venues = venues;
        _venuesLoaded = true;
      });
    } catch (e) {
      // If venues fail to load, just proceed without them
      setState(() {
        _venues = [];
        _venuesLoaded = true;
      });
    }
  }

  /// Handle direct submit for existing prompts
  Future<void> _handleDirectSubmit() async {
    AppLogger.info('Submitting existing prompt update: ${widget.promptLabel}', context: 'PromptPreviewView');

    await executeWithLoading(
      operation: () async {
        await PromptSubmissionHelper.submitPrompt(
          context: context,
          interactionType: widget.interactionType,
          promptLabel: widget.promptLabel,
          promptId: widget.existingPrompt?.promptID,
          venueId: widget.venueId,
          withPreview: widget.existingPrompt?.withPreview ?? false,
          isFromPrompts: widget.isFromPrompts,
          onCloseModal: widget.onCloseModal,
        );
      },
      useProcessingState: true,
      showSuccessToast: false, // Don't show success toast as we're navigating away
      showErrorToast: true,
      errorMessage: 'Failed to update prompt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.interactionType.color,
            Colors.white,
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
                'Preview',
                style: TextStyle(
                  color: context.venyuTheme.darkText,
                ),
              ),
            ),
            body: !_venuesLoaded || _isProcessing
                ? const LoadingStateWidget()
                : SafeArea(
                    bottom: false, // Allow content to go under bottom safe area for button
                    child: Column(
                      children: [
                        // Scrollable prompt content
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: PromptDisplayWidget(
                                promptLabel: widget.promptLabel,
                                interactionType: widget.interactionType,
                                showInteractionType: false,
                              ),
                            ),
                          ),
                        ),

                        // Next/Submit button at bottom
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          child: ActionButton(
                            label: widget.existingPrompt != null ? 'Submit' : 'Next',
                            onInvertedBackground: true,
                            isLoading: _isProcessing,
                            onPressed: _venuesLoaded && !_isProcessing ? () async {
                              // If editing existing prompt, submit directly
                              if (widget.existingPrompt != null) {
                                _handleDirectSubmit();
                                return;
                              }

                              // Otherwise, continue with normal flow
                              if (_venues.isNotEmpty) {
                                // Navigate to venue selection
                                Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (context) => PromptSelectVenueView(
                                      interactionType: widget.interactionType,
                                      promptLabel: widget.promptLabel,
                                      venues: _venues,
                                      existingPrompt: widget.existingPrompt,
                                      isFromPrompts: widget.isFromPrompts,
                                      onCloseModal: widget.onCloseModal,
                                      preselectedVenueId: widget.venueId,
                                    ),
                                  ),
                                );
                              } else {
                                // No venues available
                                if (AppConfig.showPro) {
                                  // Navigate to settings view if Pro features are enabled
                                  Navigator.push(
                                    context,
                                    platformPageRoute(
                                      context: context,
                                      builder: (context) => PromptSettingsView(
                                        interactionType: widget.interactionType,
                                        promptLabel: widget.promptLabel,
                                        existingPrompt: widget.existingPrompt,
                                        isFromPrompts: widget.isFromPrompts,
                                        onCloseModal: widget.onCloseModal,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Submit directly if Pro features are disabled
                                  await executeWithLoading(
                                    operation: () async {
                                      await PromptSubmissionHelper.submitPrompt(
                                        context: context,
                                        interactionType: widget.interactionType,
                                        promptLabel: widget.promptLabel,
                                        promptId: widget.existingPrompt?.promptID,
                                        venueId: null,
                                        withPreview: false, // First Call is disabled when showPro is false
                                        isFromPrompts: widget.isFromPrompts,
                                        onCloseModal: widget.onCloseModal,
                                      );
                                    },
                                    useProcessingState: true,
                                    showSuccessToast: false,
                                    showErrorToast: true,
                                    errorMessage: 'Failed to submit prompt',
                                  );
                                }
                              }
                            } : null,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}