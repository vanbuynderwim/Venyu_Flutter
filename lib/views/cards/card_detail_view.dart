import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/character_counter_overlay.dart';
import '../../services/supabase_manager.dart';
import '../../services/session_manager.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/requests/upsert_prompt_request.dart';
import '../../models/enums/toast_type.dart';
import '../../services/toast_service.dart';

/// Card detail view for creating or editing cards/prompts.
/// 
/// This view provides a clean form interface for users to create new cards or edit existing ones.
/// Features:
/// - Toggle between "Searching for" and "I can help with" interaction types
/// - Clean, borderless textarea-like content field
/// - Scrollable content area
class CardDetailView extends StatefulWidget {
  final Prompt? existingPrompt; // null for new card, non-null for editing

  const CardDetailView({
    super.key,
    this.existingPrompt,
  });

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  // Controllers
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  InteractionType _selectedInteractionType = InteractionType.lookingForThis;
  bool _contentIsEmpty = true;
  bool _isUpdating = false;
  String _originalContent = '';
  InteractionType _originalInteractionType = InteractionType.lookingForThis;
  
  // Constants
  static const int _maxLength = 200;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    // Load existing data if editing
    if (widget.existingPrompt != null) {
      _originalContent = widget.existingPrompt!.label;
      _originalInteractionType = widget.existingPrompt!.interactionType ?? InteractionType.lookingForThis;
      _contentController.text = _originalContent;
      _selectedInteractionType = _originalInteractionType;
      _contentIsEmpty = false;
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

  /// Checks if there are unsaved changes
  bool get _hasUnsavedChanges {
    final currentContent = _contentController.text.trim();
    return currentContent != _originalContent || _selectedInteractionType != _originalInteractionType;
  }

  Future<void> _handleClose() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await DialogUtils.showConfirmationDialog(
        context: context,
        title: 'Discard Changes',
        message: 'You have unsaved changes. Are you sure you want to discard them?',
        confirmText: 'Discard',
        cancelText: 'Cancel',
        isDestructive: true,
      );
      
      if (!shouldDiscard) return;
    }
    
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  Future<void> _handleSave() async {
    if (_contentIsEmpty || _isUpdating) return;
    
    setState(() {
      _isUpdating = true;
    });
    
    try {
      // Create the upsert request
      final request = UpsertPromptRequest(
        promptID: widget.existingPrompt?.promptID,
        interactionType: _selectedInteractionType,
        label: _contentController.text.trim(),
      );
      
      // Call the Supabase upsert function
      await _supabaseManager.upsertPrompt(request);
      
      if (mounted) {
        // Show success toast
        ToastService.show(
          context: context,
          message: "Thank you for your submission! Your card is under review and you'll receive a notification once it's approved.",
          type: ToastType.success,
          duration: const Duration(seconds: 4),
        );
        
        // Close the dialog
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      debugPrint('Error saving card: $error');
      if (mounted) {
        ToastService.show(
          context: context,
          message: 'Failed to save card. Please try again.',
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
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
            _selectedInteractionType.color,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
          ],
        ),
      ),
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          leading: PlatformIconButton(
            icon: Icon(
              context.platformIcons.clear,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: _handleClose,
            padding: EdgeInsets.zero,
          ),
          trailingActions: [
            Opacity(
              opacity: _contentIsEmpty ? 0.5 : 1.0, // Lower opacity when disabled
              child: Container(
                decoration: BoxDecoration(
                  color: venyuTheme.primary, // Always use primary color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PlatformTextButton(
                  onPressed: _contentIsEmpty || _isUpdating ? null : _handleSave,
                  child: _isUpdating 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: PlatformCircularProgressIndicator(
                          cupertino: (_, __) => CupertinoProgressIndicatorData(
                            color: venyuTheme.cardBackground, // ActionButton text color
                          ),
                          material: (_, __) => MaterialProgressIndicatorData(
                            color: venyuTheme.cardBackground, // ActionButton text color
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(
                          color: venyuTheme.cardBackground, // ActionButton text color
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  cupertino: (_, __) => CupertinoTextButtonData(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  material: (_, __) => MaterialTextButtonData(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent, // Container handles background
                      foregroundColor: venyuTheme.cardBackground, // ActionButton text color
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(60, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
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
            // Scrollable text field with character counter
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PlatformTextField(
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: venyuTheme.primaryText,
                        fontSize: 36,
                        fontFamily: AppFonts.graphie,
                      ),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isUpdating,
                      cupertino: (_, __) => CupertinoTextFieldData(
                        placeholder: _selectedInteractionType.hintText,
                        placeholderStyle: TextStyle(
                          color: venyuTheme.secondaryText,
                          fontSize: 36,
                          fontFamily: AppFonts.graphie,
                        ),
                        decoration: const BoxDecoration(), // No borders
                        padding: EdgeInsets.zero, // No internal padding
                      ),
                      material: (_, __) => MaterialTextFieldData(
                        decoration: InputDecoration(
                          hintText: _selectedInteractionType.hintText,
                          hintStyle: TextStyle(
                            color: venyuTheme.secondaryText,
                            fontSize: 36,
                            fontFamily: AppFonts.graphie,
                          ),
                          border: InputBorder.none, // No borders
                          contentPadding: EdgeInsets.zero, // No internal padding
                        ),
                      ),
                    ),
                    
                    // Character counter overlay
                    CharacterCounterOverlay(
                      currentLength: _contentController.text.length,
                      maxLength: _maxLength,
                    ),
                  ],
                ),
              ),
            ),
            
            // Interaction toggle buttons at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: CardDetailToggleButtons(
                selectedInteractionType: _selectedInteractionType,
                onInteractionChanged: (type) {
                  setState(() {
                    _selectedInteractionType = type;
                  });
                },
                isUpdating: _isUpdating,
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}