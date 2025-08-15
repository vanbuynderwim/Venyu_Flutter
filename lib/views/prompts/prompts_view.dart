import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/requests/update_prompt_interaction_request.dart';
import '../../services/supabase_manager.dart';

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

class _PromptsViewState extends State<PromptsView> {
  InteractionType? _selectedInteractionType;
  bool _isUpdating = false;
  int _currentPromptIndex = 0;
  List<InteractionType?> _promptInteractions = [];
  
  // Services
  late final SupabaseManager _supabaseManager;

  Prompt get _currentPrompt => widget.prompts[_currentPromptIndex];
  
  /// Get the current gradient color based on selected interaction type or default
  Color get _currentGradientColor {
    return _selectedInteractionType?.color ?? AppColors.primair4Lilac;
  }

  void _handleInteractionPressed(InteractionType interactionType) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedInteractionType = interactionType;
      _promptInteractions[_currentPromptIndex] = interactionType;
    });
    
    debugPrint('User selected interaction: ${interactionType.value} for prompt: ${_currentPrompt.label}');
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    // Initialize interactions list with null values
    _promptInteractions = List.filled(widget.prompts.length, null);
  }

  Future<void> _handleNext() async {
    if (_selectedInteractionType == null || _isUpdating) return;
    
    setState(() {
      _isUpdating = true;
    });

    try {
      // Create the interaction request
      final request = UpdatePromptInteractionRequest(
        promptFeedID: _currentPrompt.feedID ?? 0,
        promptID: _currentPrompt.promptID,
        interactionType: _selectedInteractionType!,
      );

      debugPrint('🔍 Request payload: ${request.toJson()}');

      // Submit interaction to backend
      await _supabaseManager.insertPromptInteraction(request);

      debugPrint('✅ Interaction submitted: ${_selectedInteractionType!.value} for prompt: ${_currentPrompt.label}');
      
      if (mounted) {
        // Check if there are more prompts
        if (_currentPromptIndex < widget.prompts.length - 1) {
          // Move to next prompt and reset interaction selection
          setState(() {
            _currentPromptIndex++;
            _selectedInteractionType = null;
            _isUpdating = false;
          });
        } else {
          // Last prompt - close the modal
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      debugPrint('❌ Error submitting interaction: $error');
      
      if (mounted) {
        // Show error feedback to user if needed
        // For now, just close the modal
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted && _currentPromptIndex >= widget.prompts.length - 1) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
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
                    isUpdating: _isUpdating,
                    spacing: AppModifiers.smallSpacing,
                  ),
                ),
                
                const SizedBox(height: AppModifiers.largeSpacing),
                
                // Next button - enabled when interaction is selected
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActionButton(
                    label: 'Confirm',
                    onPressed: _selectedInteractionType != null ? _handleNext : null,
                    isLoading: _isUpdating,
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