import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/character_counter_overlay.dart';
import '../../widgets/common/sub_title.dart';
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
    final profile = ProfileService.shared.currentProfile;
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
    await profileManager.updateProfileBio(bio);
    
    // Update local state
    ProfileService.shared.updateCurrentProfileFields(bio: bio);
  }

  @override
  bool get useScrollView => true; // Enable scroll view to prevent overflow

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

        // About your bio info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: venyuTheme.info.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: venyuTheme.info.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitle(
                iconName: 'bulb',
                title: 'About your bio',
              ),
              const SizedBox(height: 8),
              Text(
                'Your bio is visible to everyone you match with. Keep in mind: if you don\'t want certain personal details to be known before an introduction (such as your company name, LinkedIn profile, or other identifying information), please leave those out.\n\nUse this space to highlight your experience, interests, and what you\'re open to, without sharing sensitive details you\'d rather keep private until after an introduction is made.',
                style: AppTextStyles.subheadline2.copyWith(
                  color: venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Bio text area with character counter
        SizedBox(
          height: 300, // Fixed height for text area
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
              CharacterCounterOverlay(
                currentLength: _bioController.text.length,
                maxLength: _textLimit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}