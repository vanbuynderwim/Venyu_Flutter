import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_layout_styles.dart';
import '../base/base_form_view.dart';

/// Placeholder view for notification settings during registration
/// 
/// This view serves as a placeholder for the notification preferences step 
/// in the registration wizard. Currently skips to next step as notification
/// settings functionality will be implemented later.
class EditNotificationsView extends BaseFormView {
  const EditNotificationsView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
    super.title = 'Notifications',
  });

  @override
  BaseFormViewState<EditNotificationsView> createState() => _EditNotificationsViewState();
}

class _EditNotificationsViewState extends BaseFormViewState<EditNotificationsView> {
  @override
  String getSuccessMessage() => 'Notification preferences updated';

  @override
  String getErrorMessage() => 'Failed to update notification preferences';

  @override
  Future<void> performSave() async {
    // Placeholder implementation - skip notifications for now
    debugPrint('Notifications step - skipping for now');
    
    // Small delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        
        // Header
        Text(
          'Stay Connected',
          style: AppTextStyles.headline.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Choose how you\'d like to be notified about new connections, matches, and opportunities.',
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.secondaryText,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Notification options placeholder
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppLayoutStyles.cardDecoration(context),
          child: Column(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 48,
                color: venyuTheme.secondaryText,
              ),
              const SizedBox(height: 16),
              Text(
                'Notification Settings',
                style: AppTextStyles.headline.copyWith(
                  color: venyuTheme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Notification preferences coming soon',
                style: AppTextStyles.body.copyWith(
                  color: venyuTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        if (widget.registrationWizard)
          Text(
            'You can customize your notification preferences later in settings',
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}