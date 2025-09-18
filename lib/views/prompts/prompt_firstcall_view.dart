import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/prompts/first_call_settings_widget.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/buttons/action_button.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import 'prompt_finish_view.dart';

/// Prompt First Call configuration view
///
/// This view allows users to configure First Call settings for their prompt.
/// Features:
/// - Shows First Call settings widget
/// - No prompt preview (as requested)
/// - Submit button to save prompt
class PromptFirstCallView extends StatefulWidget {
  final InteractionType interactionType;
  final String promptLabel;
  final Venue? selectedVenue;
  final Prompt? existingPrompt;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;

  const PromptFirstCallView({
    super.key,
    required this.interactionType,
    required this.promptLabel,
    this.selectedVenue,
    this.existingPrompt,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  @override
  State<PromptFirstCallView> createState() => _PromptFirstCallViewState();
}

class _PromptFirstCallViewState extends State<PromptFirstCallView> {
  late final ContentManager _contentManager;
  bool _withPreview = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;

    // If editing existing prompt, use its preview setting
    if (widget.existingPrompt != null) {
      _withPreview = widget.existingPrompt!.withPreview ?? false;
    }
  }

  /// Handle submit button - saves the prompt
  Future<void> _handleSubmit() async {
    setState(() => _isProcessing = true);

    try {
      AppLogger.info('Submitting prompt with First Call: $_withPreview', context: 'PromptFirstCallView');

      // Call upsertPrompt with all configurations
      await _contentManager.upsertPrompt(
        widget.existingPrompt?.promptID,
        widget.interactionType,
        widget.promptLabel,
        venueId: widget.selectedVenue?.id,
        withPreview: _withPreview,
      );

      if (!mounted) return;

      // Navigate to finish view
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptFinishView(
            isFromPrompts: widget.isFromPrompts,
            onCloseModal: widget.onCloseModal,
          ),
        ),
      );
    } catch (e) {
      AppLogger.error('Failed to submit prompt', error: e, context: 'PromptFirstCallView');

      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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