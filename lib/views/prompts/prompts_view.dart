import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../cards/interaction_type_selection_view.dart';

/// PromptsView - Fullscreen modal for displaying prompts to users
/// 
/// This view shows available prompts to users on app startup when prompts are available.
/// Features:
/// - Fullscreen modal design
/// - Displays first prompt prominently
/// - Interactive buttons for user response
/// - Gradient background with theming support
class PromptsView extends StatefulWidget {
  final List<Prompt> prompts;

  const PromptsView({
    super.key,
    required this.prompts,
  });

  @override
  State<PromptsView> createState() => _PromptsViewState();
}

class _PromptsViewState extends State<PromptsView> with ErrorHandlingMixin {
  InteractionType? _selectedInteractionType;
  int _currentPromptIndex = 0;
  List<InteractionType?> _promptInteractions = [];
  
  // Services
  late final ContentManager _contentManager;

  Prompt get _currentPrompt => widget.prompts[_currentPromptIndex];
  
  /// Get the current gradient color based on selected interaction type or default
  Color get _currentGradientColor {
    return _selectedInteractionType?.color ?? AppColors.primair4Lilac;
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

  void _handleClose() {
    Navigator.of(context).pop();
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
      onSuccess: () {
        // Check if there are more prompts
        if (_currentPromptIndex < widget.prompts.length - 1) {
          // Move to next prompt and reset interaction selection
          setState(() {
            _currentPromptIndex++;
            _selectedInteractionType = null;
          });
        } else {
          // Last prompt - navigate to InteractionTypeSelectionView
          Navigator.of(context).pop(); // Close the prompts modal first
          Navigator.of(context).push(
            platformPageRoute(
              context: context,
              builder: (context) => const InteractionTypeSelectionView(),
            ),
          );
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
    final venyuTheme = context.venyuTheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.prompts.length, (index) {
        final isCompleted = _promptInteractions[index] != null;
        final isCurrent = index == _currentPromptIndex;
        
        Color dotColor;
        if (isCompleted) {
          // Use the selected interaction type color
          dotColor = _promptInteractions[index]!.color;
        } else if (isCurrent && _selectedInteractionType != null) {
          // Use current selection color for current dot
          dotColor = _selectedInteractionType!.color;
        } else {
          // Use theme primary color for dark mode compatibility
          dotColor = venyuTheme.primary;
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _currentGradientColor,
            isDark ? AppColors.secundair3Slategray : Colors.white,
          ],
        ),
      ),
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false, // Allow keyboard to overlay the bottom safe area
          child: GestureDetector(
            onTap: () {
              // Allow dismissing by tapping outside the content area
              // Only close if no interaction is selected yet
              if (_selectedInteractionType == null) {
                _handleClose();
              }
            },
            child: Column(
              children: [
                // Prompt content - takes all available space
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: AppModifiers.pagePadding,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _currentPrompt.label,
                            style: TextStyle(
                              color: venyuTheme.primaryText,
                              fontSize: 36,
                              fontFamily: AppFonts.graphie,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
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
                
                // Next button - enabled when interaction is selected
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActionButton(
                    label: 'Next',
                    onPressed: _selectedInteractionType != null ? _handleNext : null,
                    isLoading: isProcessing,
                  ),
                ),
                
                const SizedBox(height: AppModifiers.extraLargeSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}