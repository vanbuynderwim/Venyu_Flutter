import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../core/theme/venyu_theme.dart';
import '../base/base_form_view.dart';
import '../../core/theme/app_modifiers.dart';

/// Card detail view for creating or editing cards/prompts.
/// 
/// This view provides a form interface for users to create new cards or edit existing ones.
/// Features:
/// - Toggle between "Searching for" and "I can help with" interaction types
/// - Content field for prompt text
/// - Uses BaseFormView pattern for consistent form handling
class CardDetailView extends BaseFormView {
  final Prompt? existingPrompt; // null for new card, non-null for editing

  const CardDetailView({
    super.key,
    this.existingPrompt,
  }) : super(title: 'Card');

  @override
  BaseFormViewState<BaseFormView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends BaseFormViewState<CardDetailView> {
  // Form controllers
  final _contentController = TextEditingController();
  
  // Form state
  InteractionType _selectedInteractionType = InteractionType.lookingForThis; // Default: "Searching for"
  bool _contentIsEmpty = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();
    
    // Add listener for validation
    _contentController.addListener(_computeValidation);
  }

  void _preloadValues() {
    if (widget.existingPrompt != null) {
      _contentController.text = widget.existingPrompt!.label;
      _selectedInteractionType = widget.existingPrompt!.interactionType ?? InteractionType.lookingForThis;
    }
    
    _computeValidation();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => !_contentIsEmpty;

  @override
  String getSuccessMessage() => widget.existingPrompt != null 
      ? 'Card updated successfully' 
      : 'Card created successfully';

  @override
  String getErrorMessage() => widget.existingPrompt != null
      ? 'Failed to update card, please try again'
      : 'Failed to create card, please try again';

  @override
  Future<void> performSave() async {
    // TODO: Implement save logic here
    // if (widget.existingPrompt != null) {
    //   await supabaseManager.updateCard(
    //     id: widget.existingPrompt!.id,
    //     content: _contentController.text.trim(),
    //     interactionType: _selectedInteractionType,
    //   );
    // } else {
    //   await supabaseManager.createCard(
    //     content: _contentController.text.trim(),
    //     interactionType: _selectedInteractionType,
    //   );
    // }
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  void _computeValidation() {
    setState(() {
      _contentIsEmpty = _contentController.text.trim().isEmpty;
    });
  }

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interaction type toggle buttons
        buildFieldSection(
          title: 'TYPE (TOGGLE BUTTONS)',
          content: _buildInteractionTypeToggle(),
        ),
        
        // InteractionButtons for comparison
        buildFieldSection(
          title: 'COMPARISON (INTERACTION BUTTONS)',
          content: _buildInteractionButtonsComparison(),
        ),
        
        // Content field
        buildFieldSection(
          title: 'CONTENT',
          content: AppTextField(
            controller: _contentController,
            hintText: 'What would you like to share?',
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            style: AppTextFieldStyle.textarea,
            maxLines: 6,
            minLines: 3,
            state: _contentIsEmpty ? AppTextFieldState.error : AppTextFieldState.normal,
            enabled: !isUpdating,
          ),
        ),
      ],
    );
  }

  /// Builds the interaction type toggle buttons
  Widget _buildInteractionTypeToggle() {
    return Row(
      children: [
        // "Searching for" button
        Expanded(
          child: _buildToggleButton(
            interactionType: InteractionType.lookingForThis,
            isSelected: _selectedInteractionType == InteractionType.lookingForThis,
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _selectedInteractionType = InteractionType.lookingForThis;
              });
            },
          ),
        ),
        
        const SizedBox(width: 12),
        
        // "I can help with" button  
        Expanded(
          child: _buildToggleButton(
            interactionType: InteractionType.thisIsMe,
            isSelected: _selectedInteractionType == InteractionType.thisIsMe,
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _selectedInteractionType = InteractionType.thisIsMe;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds InteractionButtons for comparison
  Widget _buildInteractionButtonsComparison() {
    return Row(
      children: [
        // "Searching for" InteractionButton
        Expanded(
          child: InteractionButton(
            interactionType: InteractionType.lookingForThis,
            onPressed: () {
              // Just for demo - doesn't change selection
              debugPrint('InteractionButton tapped: ${InteractionType.lookingForThis.buttonTitle}');
            },
          ),
        ),
        
        const SizedBox(width: 12),
        
        // "I can help with" InteractionButton  
        Expanded(
          child: InteractionButton(
            interactionType: InteractionType.thisIsMe,
            onPressed: () {
              // Just for demo - doesn't change selection
              debugPrint('InteractionButton tapped: ${InteractionType.thisIsMe.buttonTitle}');
            },
          ),
        ),
      ],
    );
  }

  /// Builds a single toggle button
  Widget _buildToggleButton({
    required InteractionType interactionType,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = context.venyuTheme;
    final unselectedColor = theme.unselectedText; // Gray in light mode, white in dark mode
    //final unselectedBorderColor = theme.borderColor;
    
    return GestureDetector(
      onTap: isUpdating ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? interactionType.color : theme.unselectedBackground,
          border: Border.all(
            color: isSelected ? interactionType.color : unselectedColor,
            width: AppModifiers.thinBorder,
          ),
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Image.asset(
              interactionType.assetPath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.white : unselectedColor,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  interactionType.fallbackIcon,
                  size: 24,
                  color: isSelected ? Colors.white : unselectedColor,
                );
              },
            ),
            
            const SizedBox(width: 8),
            
            // Title
            Flexible(
              child: Text(
                interactionType.buttonTitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? Colors.white : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}