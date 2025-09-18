import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/prompts/prompt_display_widget.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import 'interaction_type_selection_view.dart';

/// DailyPromptsView - Fullscreen modal for displaying daily prompts to users
/// 
/// This view shows available prompts to users on app startup when prompts are available.
/// Features:
/// - Fullscreen modal design
/// - Displays first prompt prominently
/// - Interactive buttons for user response
/// - Gradient background with theming support
class DailyPromptsView extends StatefulWidget {
  final List<Prompt> prompts;

  final VoidCallback? onCloseModal;

  const DailyPromptsView({
    super.key,
    required this.prompts,
    this.onCloseModal,
  });

  @override
  State<DailyPromptsView> createState() => _DailyPromptsViewState();
}

class _DailyPromptsViewState extends State<DailyPromptsView> with ErrorHandlingMixin {
  InteractionType? _selectedInteractionType;
  int _currentPromptIndex = 0;
  List<InteractionType?> _promptInteractions = [];
  
  
  // Services
  late final ContentManager _contentManager;

  Prompt get _currentPrompt => widget.prompts[_currentPromptIndex];
  
  /// Get the current gradient color based on selected interaction type or default
  Color get _currentGradientColor {
    // Use theme-aware gradient primary color when no selection is made
    return _selectedInteractionType?.color ?? context.venyuTheme.gradientPrimary;
  }

  void _handleInteractionPressed(InteractionType interactionType) {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    setState(() {
      _selectedInteractionType = interactionType;
      _promptInteractions[_currentPromptIndex] = interactionType;
    });
    
    AppLogger.ui('User selected interaction: ${interactionType.value} for prompt: ${_currentPrompt.label}', context: 'PromptsView');
  }


  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    // Initialize interactions list with null values
    _promptInteractions = List.filled(widget.prompts.length, null);
  }

  Future<void> _handleNext() async {
    if (_selectedInteractionType == null || isProcessing) return;
    
    await executeWithLoading(
      operation: () async {
        HapticFeedback.heavyImpact();
        
        final promptFeedID = _currentPrompt.feedID ?? 0;
        final promptID = _currentPrompt.promptID;
        final interactionType = _selectedInteractionType!;
        
        AppLogger.network('Request payload: {prompt_feed_id: $promptFeedID, prompt_id: $promptID, interaction_type: ${interactionType.toJson()}}', context: 'PromptsView');

        await _contentManager.insertPromptInteraction(promptFeedID, promptID, interactionType);
        AppLogger.success('Interaction submitted: ${_selectedInteractionType!.value} for prompt: ${_currentPrompt.label}', context: 'PromptsView');
      },
      showSuccessToast: false,
      showErrorToast: false, // Handle navigation in callbacks
      useProcessingState: true,
      onSuccess: () async {
        // Check if there are more prompts
        if (_currentPromptIndex < widget.prompts.length - 1) {
          // Move to next prompt and reset interaction selection
          setState(() {
            _currentPromptIndex++;
            _selectedInteractionType = null;
          });
        } else {
          // Last prompt - navigate to InteractionTypeSelectionView
          final result = await Navigator.of(context).push<bool>(
            platformPageRoute(
              context: context,
              builder: (_) => InteractionTypeSelectionView(
                isFromPrompts: true,
                onCloseModal: widget.onCloseModal,
              ),
            ),
          );

          // If prompt was successfully created, close the modal
          if (result == true && widget.onCloseModal != null) {
            widget.onCloseModal!();
          }
        }
      },
      onError: (error) {
        AppLogger.error('Error submitting interaction', error: error, context: 'PromptsView');
        // Close modal on error
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.prompts.length, (index) {
        final isCompleted = _promptInteractions[index] != null;
        final isCurrent = index == _currentPromptIndex;
        
        Color fillColor;
        Color? borderColor;
        double borderWidth = 0;
        
        if (isCompleted) {
          // Completed: Use the selected interaction type color
          fillColor = _promptInteractions[index]!.color;
        } else if (isCurrent && _selectedInteractionType != null) {
          // Current with selection: Use current selection color
          fillColor = _selectedInteractionType!.color;
        } else {
          // Not completed: White with light gray border
          fillColor = Colors.white;
          borderColor = AppColors.secundair4Quicksilver;
          borderWidth = 1.0;
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: borderWidth)
                : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Early return if no prompts available
    if (widget.prompts.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No prompts available'),
        ),
      );
    }

    return PopScope(
      canPop: _currentPromptIndex == 0 || _selectedInteractionType != null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _currentGradientColor,
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
              body: SafeArea(
                bottom: false, // Allow keyboard to overlay the bottom safe area
                child: Column(
                children: [
                  // Prompt content - takes all available space
                  Expanded(
                    child: PromptDisplayWidget(
                      promptLabel: _currentPrompt.label,
                    ),
                  ),

                  // Progress indicator dots
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildProgressIndicator(),
                  ),

                  const SizedBox(height: AppModifiers.largeSpacing),

                  // Interaction buttons - fixed at bottom (base_form_view pattern)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: InteractionButtonRow(
                      onInteractionPressed: _handleInteractionPressed,
                      selectedInteractionType: _selectedInteractionType,
                      isUpdating: isProcessing,
                      spacing: AppModifiers.smallSpacing,
                    ),
                  ),

                  const SizedBox(height: AppModifiers.largeSpacing),

                  // Next button - enabled when interaction is selected, wrapped in light theme
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionButton(
                        label: 'Next',
                        onPressed: (_selectedInteractionType != null && !isProcessing) ? _handleNext : null,
                        isLoading: isProcessing,
                        onInvertedBackground: true,
                      ),
                  ),

                  const SizedBox(height: AppModifiers.extraLargeSpacing),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}