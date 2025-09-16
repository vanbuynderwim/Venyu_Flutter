import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/buttons/action_button.dart';
import 'prompt_detail/prompt_gradient_container.dart';
import 'prompt_detail/prompt_content_field.dart';

/// Prompt detail view for creating or editing prompts.
/// 
/// This view provides a clean form interface for users to create new prompts or edit existing ones.
/// Features:
/// - Toggle between "Searching for" and "I can help with" interaction types
/// - Clean, borderless textarea-like content field
/// - Scrollable content area
class PromptEditView extends StatefulWidget {
  final Prompt? existingPrompt; // null for new prompt, non-null for editing
  final InteractionType? initialInteractionType; // Pre-selected type for new prompts
  final bool isNewPrompt; // Whether this is a new prompt (hides toggle buttons)
  final bool isFromPrompts; // Whether coming from prompts flow
  final VoidCallback? onCloseModal; // Callback to close modal when from prompts
  final String? venueId; // Optional venue ID to associate with the new prompt

  const PromptEditView({
    super.key,
    this.existingPrompt,
    this.initialInteractionType,
    this.isNewPrompt = false,
    this.isFromPrompts = false,
    this.onCloseModal,
    this.venueId,
  });

  @override
  State<PromptEditView> createState() => _PromptEditViewState();
}

class _PromptEditViewState extends State<PromptEditView> with ErrorHandlingMixin {
  // Controllers
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  
  // Services
  late final ContentManager _contentManager;
  
  // State
  InteractionType _selectedInteractionType = InteractionType.lookingForThis;
  bool _contentIsEmpty = true;
  // _isUpdating removed - using mixin's isProcessing
  String _originalContent = '';
  InteractionType _originalInteractionType = InteractionType.lookingForThis;
  
  // Constants
  static const int _maxLength = 200;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    
    // Load existing data if editing
    if (widget.existingPrompt != null) {
      _originalContent = widget.existingPrompt!.label;
      _originalInteractionType = widget.existingPrompt!.interactionType ?? InteractionType.lookingForThis;
      _contentController.text = _originalContent;
      _selectedInteractionType = _originalInteractionType;
      _contentIsEmpty = false;
    } else if (widget.initialInteractionType != null) {
      // Use pre-selected interaction type for new prompts
      _selectedInteractionType = widget.initialInteractionType!;
      _originalInteractionType = widget.initialInteractionType!;
    }
    
    // Add listener for validation and character limiting
    _contentController.addListener(() {
      _limitText();
      setState(() {
        _contentIsEmpty = _contentController.text.trim().isEmpty;
      });
    });
    
    // Auto-focus the content field to open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
  
  /// Enforces character limit on prompt content.
  void _limitText() {
    final text = _contentController.text;
    if (text.length > _maxLength) {
      final truncated = text.substring(0, _maxLength);
      _contentController.value = _contentController.value.copyWith(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
  }



  Future<void> _handleSave() async {
    if (_contentIsEmpty || isProcessing) return;
    
    await executeWithLoading(
      operation: () async {
        await _contentManager.upsertPrompt(
          widget.existingPrompt?.promptID,
          _selectedInteractionType,
          _contentController.text.trim(),
          venueId: widget.venueId,
        );
      },
      successMessage: "Thank you for your submission! Your prompt is under review and you'll receive a notification once it's approved.",
      errorMessage: 'Failed to save prompt. Please try again.',
      useProcessingState: true,
      onSuccess: () {
        if (widget.isFromPrompts && widget.onCloseModal != null) {
          // Use the callback to close the entire modal stack
          widget.onCloseModal!();
        } else {
          // Normal flow - just pop this view with result
          Navigator.of(context).pop(true);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return PromptGradientContainer(
      interactionType: _selectedInteractionType,
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          trailingActions: [
            ActionButton(
              label: 'Submit',
              isDisabled: _contentIsEmpty,
              isLoading: isProcessing,
              onPressed: _handleSave,
              isCompact: true,
            ),
          ],
          cupertino: (_, __) => CupertinoNavigationBarData(
            backgroundColor: Colors.transparent,
            border: null, // Remove border
          ),
          material: (_, __) => MaterialAppBarData(
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow
            surfaceTintColor: Colors.transparent,
          ),
        ),
        body: SafeArea(
          bottom: false, // Allow keyboard to overlay the bottom safe area
          child: Column(
            children: [
              // Main content field with character counter
              PromptContentField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                interactionType: _selectedInteractionType,
                isEnabled: !isProcessing,
                maxLength: _maxLength,
              ),
          
              // Add bottom padding when toggle buttons are hidden
              if (widget.isNewPrompt)
                const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}