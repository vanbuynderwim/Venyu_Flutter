import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../base/base_form_view.dart';

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
/// Refactored to use BaseFormView - reduced from 257 to ~100 lines
class EditBioView extends BaseFormView {
  const EditBioView({super.key}) : super(title: 'About you');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditBioViewState();
}

class _EditBioViewState extends BaseFormViewState<EditBioView> {
  final TextEditingController _bioController = TextEditingController();
  
  static const int _textLimit = 200;

  @override
  void initializeForm() {
    super.initializeForm();
    // Load current bio
    final profile = sessionManager.currentProfile;
    _bioController.text = profile?.bio ?? '';
    
    // Add listener for character limit enforcement
    _bioController.addListener(_limitText);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  String getSuccessMessage() => 'Profile bio saved';

  @override
  String getErrorMessage() => 'Failed to update profile bio, please try again';

  @override
  Future<void> performSave() async {
    final bio = _bioController.text;
    
    // Update in backend
    await supabaseManager.updateProfileBio(bio);
    
    // Update local state
    sessionManager.updateCurrentProfileFields(bio: bio);
  }

  @override
  bool get useScrollView => false; // We have an Expanded widget

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

  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description text
        Text(
          EditPersonalInfoType.bio.description,
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.secondaryText,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Bio text area with character counter
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
                enabled: !isUpdating,
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
    );
  }
}