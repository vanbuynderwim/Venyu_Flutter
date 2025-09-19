import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/models.dart';
import '../../models/venue.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/prompts/prompt_display_widget.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/buttons/action_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../services/supabase_managers/venue_manager.dart';
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
  late final ContentManager _contentManager;
  late final VenueManager _venueManager;

  // State
  List<Venue> _venues = [];
  bool _venuesLoaded = false;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
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
            body: !_venuesLoaded
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

                        // Next button at bottom
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          child: ActionButton(
                            label: 'Next',
                            onInvertedBackground: true,
                            onPressed: _venuesLoaded ? () {
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
                                // Navigate to first call view
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