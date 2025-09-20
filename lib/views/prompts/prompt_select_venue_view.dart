import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../models/simple_prompt_option.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/sub_title.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../core/config/app_config.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/helpers/prompt_submission_helper.dart';
import '../../mixins/error_handling_mixin.dart';
import '../venues/venue_item_view.dart';
import 'prompt_settings_view.dart';

/// Prompt venue selection view - allows user to select a venue for their prompt
///
/// This view displays available venues and allows the user to:
/// - Select a venue to publish their prompt to
/// - Skip venue selection to publish publicly
/// - Navigate to the preview step
class PromptSelectVenueView extends StatefulWidget {
  final InteractionType interactionType;
  final String promptLabel;
  final List<Venue> venues;
  final Prompt? existingPrompt;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;
  final String? preselectedVenueId;

  const PromptSelectVenueView({
    super.key,
    required this.interactionType,
    required this.promptLabel,
    required this.venues,
    this.existingPrompt,
    this.isFromPrompts = false,
    this.onCloseModal,
    this.preselectedVenueId,
  });

  @override
  State<PromptSelectVenueView> createState() => _PromptSelectVenueViewState();
}

class _PromptSelectVenueViewState extends State<PromptSelectVenueView> with ErrorHandlingMixin {
  Venue? _selectedVenue;

  @override
  void initState() {
    super.initState();
    // Pre-select venue if venueId is provided
    if (widget.preselectedVenueId != null) {
      _selectedVenue = widget.venues.where((venue) => venue.id == widget.preselectedVenueId).firstOrNull;
    }
  }

  Future<void> _handleNext() async {
    if (AppConfig.showPro) {
      // If Pro features are enabled, navigate to settings view
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptSettingsView(
            interactionType: widget.interactionType,
            promptLabel: widget.promptLabel,
            selectedVenue: _selectedVenue,
            existingPrompt: widget.existingPrompt,
            isFromPrompts: widget.isFromPrompts,
            onCloseModal: widget.onCloseModal,
          ),
        ),
      );
    } else {
      // If Pro features are disabled, submit directly
      await executeWithLoading(
        operation: () async {
          await PromptSubmissionHelper.submitPrompt(
            context: context,
            interactionType: widget.interactionType,
            promptLabel: widget.promptLabel,
            promptId: widget.existingPrompt?.promptID,
            venueId: _selectedVenue?.id,
            withPreview: false, // First Call is disabled when showPro is false
            isFromPrompts: widget.isFromPrompts,
            onCloseModal: widget.onCloseModal,
          );
        },
        useProcessingState: true,
        showSuccessToast: false, // Don't show toast as we're navigating
        showErrorToast: true,
        errorMessage: 'Failed to submit prompt',
      );
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
                'Select audience',
                style: TextStyle(
                  color: venyuTheme.darkText,
                ),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with subtitle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SubTitle(
                      title: 'Where would you like to publish?',
                      iconName: 'target',
                    ),
                  ),

                  // List of venues
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.venues.isNotEmpty
                          ? widget.venues.length + 2  // +1 for public option, +1 for subtitle
                          : 1, // Just the public option
                      itemBuilder: (context, index) {

                  if (index == 0) {
                    // "Publish publicly" option using OptionButton
                    final publicOption = SimplePromptOption(
                      id: 'public',
                      title: 'Publish publicly',
                      description: 'Visible to all users',
                      icon: null,
                      color: venyuTheme.primary,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OptionButton(
                        option: publicOption,
                        isSelected: _selectedVenue == null,
                        isMultiSelect: false,
                        withDescription: true,
                        onSelect: () {
                          if (_selectedVenue != null) {
                            HapticFeedback.mediumImpact();
                          }
                          setState(() => _selectedVenue = null);
                        },
                      ),
                    );
                  }

                  // Add subtitle before first venue
                  if (index == 1 && widget.venues.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: SubTitle(
                        title: 'Or select a specific venue',
                        iconName: 'venue',
                      ),
                    );
                  }

                  final venueIndex = widget.venues.isNotEmpty && index > 1 ? index - 2 : index - 1;
                  final venue = widget.venues[venueIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: VenueItemView(
                      venue: venue,
                      selectable: true,
                      isSelected: _selectedVenue?.id == venue.id,
                      isMultiSelect: false,
                      onTap: () {
                        if (_selectedVenue?.id != venue.id) {
                          HapticFeedback.mediumImpact();
                        }
                        setState(() => _selectedVenue = venue);
                      },
                    ),
                  );
                },
              ),
            ),

                  // Next button at bottom
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ActionButton(
                      label: AppConfig.showPro ? 'Next' : 'Submit',
                      onInvertedBackground: true,
                      onPressed: _handleNext,
                      isLoading: isProcessing,
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