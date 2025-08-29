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

  final VoidCallback? onCloseModal;

  const PromptsView({
    super.key,
    required this.prompts,
    this.onCloseModal,
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
    // Always use light theme colors
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
          Navigator.of(context).push(
            platformPageRoute(
              context: context,
              builder: (_) => InteractionTypeSelectionView(
                isFromPrompts: true,
                onCloseModal: widget.onCloseModal,
              ),
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
    // Always use light theme for prompt flow
    final venyuTheme = VenyuTheme.light;
    
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
          // Radar background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/visuals/radar.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5), // Semi-transparent overlay
              errorBuilder: (context, error, stackTrace) {
                // If image fails to load, just show the gradient
                return const SizedBox.shrink();
              },
            ),
          ),
          // Main content
          PlatformScaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false, // Allow keyboard to overlay the bottom safe area
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
                
                // Next button - enabled when interaction is selected, wrapped in light theme
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      extensions: [VenyuTheme.light],
                    ),
                    child: ActionButton(
                      label: 'Next',
                      onPressed: (_selectedInteractionType != null && !isProcessing) ? _handleNext : null,
                      isLoading: isProcessing,
                    ),
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