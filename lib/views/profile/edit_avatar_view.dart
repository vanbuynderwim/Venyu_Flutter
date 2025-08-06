import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_layout_styles.dart';
import '../base/base_form_view.dart';

/// Placeholder view for avatar upload during registration
/// 
/// This view serves as a placeholder for the avatar upload step in the 
/// registration wizard. Currently skips to next step as avatar upload
/// functionality will be implemented later.
class EditAvatarView extends BaseFormView {
  const EditAvatarView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
    super.title = 'Profile Photo',
  });

  @override
  BaseFormViewState<EditAvatarView> createState() => _EditAvatarViewState();
}

class _EditAvatarViewState extends BaseFormViewState<EditAvatarView> {
  @override
  String getSuccessMessage() => 'Profile updated successfully';

  @override
  String getErrorMessage() => 'Failed to update profile photo';

  @override
  Future<void> performSave() async {
    // Placeholder implementation - skip avatar for now
    debugPrint('Avatar step - skipping for now');
    
    // Small delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        
        // Avatar placeholder
        Container(
          width: 120,
          height: 120,
          decoration: AppLayoutStyles.circleDecoration(context),
          child: Icon(
            Icons.person,
            size: 60,
            color: venyuTheme.secondaryText,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Add a Profile Photo',
          style: AppTextStyles.headline.copyWith(
            color: venyuTheme.primaryText,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Help others recognize you by adding a profile photo. You can always add or change it later.',
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Upload button placeholder
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: AppLayoutStyles.cardDecoration(context),
          child: Column(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: venyuTheme.secondaryText,
              ),
              const SizedBox(height: 8),
              Text(
                'Photo upload coming soon',
                style: AppTextStyles.body.copyWith(
                  color: venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        if (widget.registrationWizard)
          Text(
            'For now, you can continue without adding a photo',
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}