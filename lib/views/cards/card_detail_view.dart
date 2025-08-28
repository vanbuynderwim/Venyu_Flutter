import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import 'card_detail/card_gradient_container.dart';
import 'card_detail/card_submit_button.dart';
import 'card_detail/card_content_field.dart';

/// Card detail view for creating or editing cards/prompts.
/// 
/// This view provides a clean form interface for users to create new cards or edit existing ones.
/// Features:
/// - Toggle between "Searching for" and "I can help with" interaction types
/// - Clean, borderless textarea-like content field
/// - Scrollable content area
class CardDetailView extends StatefulWidget {
  final Prompt? existingPrompt; // null for new card, non-null for editing
  final InteractionType? initialInteractionType; // Pre-selected type for new cards
  final bool isNewCard; // Whether this is a new card (hides toggle buttons)
  final bool isFromPrompts; // Whether coming from prompts flow
  final VoidCallback? onCloseModal; // Callback to close modal when from prompts

  const CardDetailView({
    super.key,
    this.existingPrompt,
    this.initialInteractionType,
    this.isNewCard = false,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> with ErrorHandlingMixin {
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
      // Use pre-selected interaction type for new cards
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
  
  /// Enforces character limit on card content.
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
        );
      },
      successMessage: "Thank you for your submission! Your card is under review and you'll receive a notification once it's approved.",
      errorMessage: 'Failed to save card. Please try again.',
      useProcessingState: true,
      onSuccess: () {
        if (widget.isFromPrompts && widget.onCloseModal != null) {
          // Close the entire modal stack when coming from prompts
          // We need to pop: CardDetailView -> InteractionType -> Prompts -> PromptEntry
          int popCount = 0;
          Navigator.of(context).popUntil((route) {
            popCount++;
            // We want to pop 3 times (CardDetail -> InteractionType -> Prompts -> PromptEntry)
            return popCount > 3;
          });
          // Now close the modal itself
          widget.onCloseModal!();
        } else {
          // Normal flow - just pop this view
          Navigator.of(context).pop(true);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return CardGradientContainer(
      interactionType: _selectedInteractionType,
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          trailingActions: [
            CardSubmitButton(
              isEnabled: !_contentIsEmpty,
              isLoading: isProcessing,
              onPressed: _handleSave,
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
              CardContentField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                interactionType: _selectedInteractionType,
                isEnabled: !isProcessing,
                maxLength: _maxLength,
              ),
          
              // Add bottom padding when toggle buttons are hidden
              if (widget.isNewCard)
                const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}