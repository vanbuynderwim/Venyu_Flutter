import 'package:app/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../mixins/error_handling_mixin.dart';

import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import 'prompt_detail/prompt_content_field.dart';
import 'prompt_preview_view.dart';

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
  
  // State
  InteractionType _selectedInteractionType = InteractionType.lookingForThis;
  bool _contentIsEmpty = true;
  String _originalContent = '';
  InteractionType _originalInteractionType = InteractionType.lookingForThis;

  @override
  void initState() {
    super.initState();

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

    // Add listener for validation
    _contentController.addListener(() {
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



  /// Handle next button - navigate to preview
  void _handleNext() {
    if (_contentIsEmpty) return;

    final promptLabel = _contentController.text.trim();

    // Always navigate to preview first
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => PromptPreviewView(
          interactionType: _selectedInteractionType,
          promptLabel: promptLabel,
          existingPrompt: widget.existingPrompt,
          isFromPrompts: widget.isFromPrompts,
          onCloseModal: widget.onCloseModal,
          venueId: widget.venueId,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _selectedInteractionType.color,
            context.venyuTheme.adaptiveBackground,
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
              cupertino: (_, _) => CupertinoNavigationBarData(
                backgroundColor: Colors.transparent,
                border: null, // Remove border
              ),
              material: (_, _) => MaterialAppBarData(
                backgroundColor: Colors.transparent,
                elevation: 0, // Remove shadow
                surfaceTintColor: Colors.transparent,
              ),
            ),
            body: SafeArea(
              bottom: false, // Allow keyboard to overlay the bottom safe area
              child: Column(
                children: [
                  // Main content field
                  Expanded(
                    child: PromptContentField(
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      interactionType: _selectedInteractionType,
                      isEnabled: !isProcessing,
                    ),
                  ),

                  // Next button moved from app bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ActionButton(
                      label: AppLocalizations.of(context)!.promptEditNextButton,
                      onInvertedBackground: true,
                      isDisabled: _contentIsEmpty,
                      onPressed: _handleNext,
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