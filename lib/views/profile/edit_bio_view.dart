import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// A form screen for editing user biography.
/// 
/// This widget provides a text area for updating:
/// - User biography (optional, max 200 characters)
/// 
/// The form includes:
/// - Multi-line text area (TextEditor equivalent)
/// - Character count display (current/max)
/// - Real-time character limit enforcement
/// - Automatic data persistence to user profile
/// 
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const EditBioView(),
///   ),
/// );
/// ```
class EditBioView extends StatefulWidget {
  const EditBioView({super.key});

  @override
  State<EditBioView> createState() => _EditBioViewState();
}

class _EditBioViewState extends State<EditBioView> {
  // Form controller for text input management
  final _bioController = TextEditingController();
  
  // Constants
  static const int _textLimit = 200;

  // UI state
  bool _isUpdating = false;

  // Service dependencies
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    _preloadValues();
    
    // Add listener for character limit enforcement
    _bioController.addListener(_limitText);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: const Text('About you'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  // Description text
                  Text(
                    EditPersonalInfoType.bio.description,
                    style: AppTextStyles.body.copyWith(
                      color: venyuTheme.secondaryText,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bio text area
                  Expanded(
                    child: Stack(
                      children: [
                        // Main text area
                        AppTextField(
                          controller: _bioController,
                          hintText: 'Write your bio here...',
                          style: AppTextFieldStyle.textarea,
                          maxLines: null, // Allow unlimited lines
                          minLines: 10,   // Minimum height
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        ),
                        
                        // Character counter overlay
                        Positioned(
                          bottom: 8,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: venyuTheme.cardBackground.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_bioController.text.length}/$_textLimit',
                              style: AppTextStyles.caption1.copyWith(
                                color: venyuTheme.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
          
          // Save button at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ActionButton(
              label: _isUpdating ? 'Saving...' : 'Save changes',
              isDisabled: _isUpdating,
              onPressed: _isUpdating ? null : _saveBio,
            ),
          ),
        ],
      ),
    );
  }

  /// Loads existing bio data into the form field.
  void _preloadValues() {
    final profile = _sessionManager.currentProfile;
    _bioController.text = profile?.bio ?? '';
  }

  /// Enforces character limit on bio text.
  void _limitText() {
    final text = _bioController.text;
    if (text.length > _textLimit) {
      final truncated = text.substring(0, _textLimit);
      _bioController.value = _bioController.value.copyWith(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
    // Trigger rebuild to update character counter
    setState(() {});
  }

  /// Saves the bio to the backend.
  /// 
  /// Handles:
  /// - Loading state management
  /// - API communication via [SupabaseManager]
  /// - Success/error user feedback
  /// - Navigation after successful save
  /// - SessionManager update with new value
  void _saveBio() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final bio = _bioController.text;
      
      await _supabaseManager.updateProfileBio(bio);
      
      // Update SessionManager with new bio (efficient)
      _sessionManager.updateCurrentProfileFields(bio: bio);
      
      // Update loading state
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Show success message and go back
      if (mounted) {
        try {
          // Show the snackbar first
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile bio saved'),
              backgroundColor: context.venyuTheme.snackbarSuccess,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Then pop after a small delay to ensure snackbar is shown
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              Navigator.of(context).pop(true); // Return true to indicate changes were saved
            }
          });
        } catch (e) {
          // If showing snackbar fails, still try to pop
          debugPrint('Failed to show success snackbar: $e');
          if (mounted) {
            Navigator.of(context).pop(true); // Return true to indicate changes were saved
          }
        }
      }
    } catch (error) {
      // Always update loading state first
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Then show error if still mounted
      if (mounted) {
        // Use a post frame callback to ensure context is valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to update profile bio, please try again'),
                backgroundColor: context.venyuTheme.snackbarError,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
      
      // Log error for debugging
      debugPrint('Error updating profile bio: $error');
    }
  }
}