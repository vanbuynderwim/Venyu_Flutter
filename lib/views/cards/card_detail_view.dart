import 'package:flutter/material.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../base/base_form_view.dart';

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
  bool get useScrollView => false; // We manage our own layout

  @override
  EdgeInsets get formContentPadding => const EdgeInsets.symmetric(
    horizontal: 8, // Minimal horizontal padding
    vertical: 8,
  );

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interaction type toggle buttons
        buildFieldSection(
          title: 'TYPE',
          content: CardDetailToggleButtons(
            selectedInteractionType: _selectedInteractionType,
            onInteractionChanged: (type) {
              setState(() {
                _selectedInteractionType = type;
              });
            },
            isUpdating: isUpdating,
          ),
        ),
        
        // Content field - expands to fill remaining space
        Expanded(
          child: buildFieldSection(
            title: 'CONTENT',
            content: buildTextarea(
              controller: _contentController,
              hintText: 'What would you like to share?',
              enabled: !isUpdating,
              hasError: _contentIsEmpty,
              minLines: 8, // Start with 8 lines to fill more space
            ),
          ),
        ),
        
        // Add 16pt spacing before save button
        //const SizedBox(height: 16),
      ],
    );
  }

}