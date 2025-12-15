import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/onboarding_benefit.dart';
import '../../models/enums/registration_step.dart';
import '../../core/utils/dialog_utils.dart';
import '../../services/notification_service.dart';
import '../../services/tag_group_service.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/onboarding_benefits_card.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/visual_icon_widget.dart';
import '../base/base_form_view.dart';
import 'edit_tag_group_view.dart';

/// A form screen for enabling notification permissions during registration.
///
/// This view allows users to enable notifications for matches, connections,
/// and daily reminders during the registration wizard or when editing
/// their notification preferences later.
class EditNotificationsView extends BaseFormView {
  const EditNotificationsView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditNotificationsViewState();
}

class _EditNotificationsViewState extends BaseFormViewState<EditNotificationsView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.registrationStepNotificationsTitle;

  bool _isEnablingNotifications = false;

  @override
  bool get canSave => true;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editNotificationsSavedMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editNotificationsSaveErrorMessage;
  }

  @override
  Future<void> performSave() async {
    // Placeholder - no actual save logic yet
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 10,
            numberOfPages: 11,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Notification image in circle
        VisualIconWidget(
          iconName: 'notification',
        ),

        const SizedBox(height: 24),

        // Title
        Center(
          child: Text(
            l10n.registrationStepNotificationsTitle,
            style: AppTextStyles.title2,
          ),
        ),

        const SizedBox(height: 24),

        // Notification benefits
        OnboardingBenefitsCard(
          benefits: [
            OnboardingBenefit.matchNotifications,
            OnboardingBenefit.connectionNotifications,
            OnboardingBenefit.dailyReminders,
          ],
        ),
      ],
    );
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ActionButton(
        label: l10n.actionNext,
        type: ActionButtonType.primary,
        onPressed: _enableNotifications,
        isLoading: _isEnablingNotifications,
      ),
    );
  }

  /// Navigate to the next step without enabling notifications
  void _navigateToNext() {
    AppLogger.debug('Navigating to next step', context: 'EditNotificationsView');

    // If this is in registration wizard, go to referrer step
    if (widget.registrationWizard) {
      final tagGroup = TagGroupService.shared.getTagGroupByCode('referrer');
      if (tagGroup != null) {
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => EditTagGroupView(
              tagGroup: tagGroup,
              registrationWizard: true,
              currentStep: RegistrationStep.referrer,
            ),
          ),
        );
      } else {
        // If referrer tag group not found, skip to complete via base form navigation
        AppLogger.warning('TagGroup "referrer" not found, using base form navigation', context: 'EditNotificationsView');
        navigateAfterSave();
      }
    } else {
      // If not in wizard mode, just pop back
      Navigator.of(context).pop();
    }
  }

  /// Enable notifications and navigate to next step
  Future<void> _enableNotifications() async {
    if (_isEnablingNotifications) return;
    
    AppLogger.debug('_enableNotifications called', context: 'EditNotificationsView');
    
    setState(() {
      _isEnablingNotifications = true;
    });
    
    try {
      AppLogger.debug('Initializing notification service...', context: 'EditNotificationsView');
      // Initialize notification service if needed
      await NotificationService.shared.initialize();
      
      AppLogger.debug('Checking current permission status...', context: 'EditNotificationsView');
      // Check current permission status first
      final currentStatus = await NotificationService.shared.getPermissionStatus();
      AppLogger.debug('Current permission status: $currentStatus', context: 'EditNotificationsView');
      
      if (currentStatus == AuthorizationStatus.denied) {
        AppLogger.debug('Permission denied, showing settings dialog...', context: 'EditNotificationsView');
        // Permission was previously denied, show dialog to go to settings
        if (!mounted) return;

        final l10n = AppLocalizations.of(context)!;
        final bool? shouldOpenSettings = await DialogUtils.showChoiceDialog<bool>(
          context: context,
          title: l10n.editNotificationsPermissionDialogTitle,
          message: l10n.editNotificationsPermissionDialogMessage,
          choices: [
            DialogChoice<bool>(
              label: l10n.editNotificationsPermissionDialogNotNow,
              value: false,
              isDefault: true,
            ),
            DialogChoice<bool>(
              label: l10n.editNotificationsPermissionDialogOpenSettings,
              value: true,
            ),
          ],
        );
        
        if (shouldOpenSettings == true && mounted) {
          // Open app settings
          await DialogUtils.openAppSettings(context);

          if (mounted) {
            setState(() {
              _isEnablingNotifications = false;
            });
          }
        } else {
          // User chose "Not now" - continue to next step without notifications
          if (mounted) {
            setState(() {
              _isEnablingNotifications = false;
            });
            _navigateToNext();
          }
        }
        return;
      }
      
      AppLogger.debug('Requesting notification permission...', context: 'EditNotificationsView');
      // Request notification permission
      final granted = await NotificationService.shared.requestPermission();
      AppLogger.debug('Permission granted: $granted', context: 'EditNotificationsView');
      
      if (granted) {
        AppLogger.success('Notification permission granted', context: 'EditNotificationsView');
        
        // Check if device token was registered
        final fcmToken = NotificationService.shared.fcmToken;
        AppLogger.debug('FCM Token: $fcmToken', context: 'EditNotificationsView');
        
        if (mounted) {
          // Navigate to next step
          _navigateToNext();
        }
      } else {
        AppLogger.warning('Notification permission denied', context: 'EditNotificationsView');

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastService.info(
            context: context,
            message: l10n.editNotificationsLaterMessage,
          );

          // Still navigate to next step even if permission denied
          _navigateToNext();
        }
      }
    } catch (error) {
      AppLogger.error('Error enabling notifications: $error', context: 'EditNotificationsView');

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.error(
          context: context,
          message: l10n.editNotificationsEnableErrorMessage,
        );

        // Navigate anyway to not block the user
        _navigateToNext();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnablingNotifications = false;
        });
      }
    }
  }
}