import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/character_counter_overlay.dart';
import '../../services/supabase_manager.dart';
import '../../services/session_manager.dart';

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
  
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  InteractionType _selectedInteractionType = InteractionType.lookingForThis;
  bool _contentIsEmpty = true;
  bool _isUpdating = false;
  
  // Constants
  static const int _maxLength = 200;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    // Load existing data if editing
    if (widget.existingPrompt != null) {
      _contentController.text = widget.existingPrompt!.label;
      _selectedInteractionType = widget.existingPrompt!.interactionType ?? InteractionType.lookingForThis;
      _contentIsEmpty = false;
    }
    
    // Add listener for validation and character limiting
    _contentController.addListener(() {
      _limitText();
      setState(() {
        _contentIsEmpty = _contentController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
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
    if (_contentIsEmpty || _isUpdating) return;
    
    setState(() {
      _isUpdating = true;
    });
    
    try {
      // TODO: Implement actual save logic
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      debugPrint('Error saving card: $error');
      // TODO: Show error message
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
    
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.existingPrompt != null ? 'Edit Card' : 'New Card'),
      ),
      body: SafeArea(
        bottom: false, // Allow keyboard to overlay the bottom safe area
        child: Column(
          children: [
            // Fixed toggle buttons at top
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
            
            const SizedBox(height: 16),
            
            // Scrollable text field with character counter
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PlatformTextField(
                      controller: _contentController,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isUpdating,
                      cupertino: (_, __) => CupertinoTextFieldData(
                        placeholder: 'What would you like to share?',
                        placeholderStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          fontSize: 24,
                        ),
                        decoration: const BoxDecoration(), // No borders
                        padding: EdgeInsets.zero, // No internal padding
                      ),
                      material: (_, __) => MaterialTextFieldData(
                        decoration: InputDecoration(
                          hintText: 'What would you like to share?',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontSize: 24,
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
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ActionButton(
                label: 'Save',
                onPressed: _contentIsEmpty ? null : _handleSave,
                isLoading: _isUpdating,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}