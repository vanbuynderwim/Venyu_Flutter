import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../../models/enums/onboarding_benefit.dart';
import '../../core/utils/dialog_utils.dart';
import '../../services/notification_service.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../base/base_form_view.dart';
import './registration_complete_view.dart';

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
  }) : super(title: 'Notifications');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditNotificationsViewState();
}

class _EditNotificationsViewState extends BaseFormViewState<EditNotificationsView> {
  bool _isEnablingNotifications = false;
  
  @override
  bool get canSave => true;

  @override
  String getSuccessMessage() => 'Notifications saved';

  @override
  String getErrorMessage() => 'Failed to save notifications';

  @override
  Future<void> performSave() async {
    // Placeholder - no actual save logic yet
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 10,
            numberOfPages: 10,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Notification image in circle
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: AppLayoutStyles.circleDecoration(context),
            child: Center(
              child: Image.asset(
                'assets/images/visuals/notification.png',
                width: 100,
                height: 100,
                color: venyuTheme.primary,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image not found
                  return Icon(
                    Icons.notifications_outlined,
                    size: 60,
                    color: venyuTheme.secondaryText,
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Center(
          child: Text(
            'Enable notifications to ...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Notification benefits
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              OptionButton(
                option: OnboardingBenefit.matchNotifications,
                isSelectable: false,
                disabled: true,
              ),
              OptionButton(
                option: OnboardingBenefit.connectionNotifications,
                isSelectable: false,
                disabled: true,
              ),
              OptionButton(
                option: OnboardingBenefit.dailyReminders,
                isSelectable: false,
                disabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Not now button (secondary)
          Expanded(
            child: ActionButton(
              label: 'Not now',
              type: ActionButtonType.secondary,
              onPressed: _navigateToNext,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Enable button (primary)
          Expanded(
            child: ActionButton(
              label: 'Enable',
              type: ActionButtonType.primary,
              onPressed: _enableNotifications,
              isLoading: _isEnablingNotifications,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to the next step without enabling notifications
  void _navigateToNext() {
    debugPrint('🔔 Navigating to next step');
    
    // If this is the last step in registration wizard, complete registration
    if (widget.registrationWizard) {
      debugPrint('✅ Registration wizard completed!');
      // Navigate to registration complete screen
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => const RegistrationCompleteView(),
        ),
      );
    } else {
      // If not in wizard mode, just pop back
      Navigator.of(context).pop();
    }
  }

  /// Enable notifications and navigate to next step
  Future<void> _enableNotifications() async {
    if (_isEnablingNotifications) return;
    
    debugPrint('🔔 _enableNotifications called');
    
    setState(() {
      _isEnablingNotifications = true;
    });
    
    try {
      debugPrint('🔔 Initializing notification service...');
      // Initialize notification service if needed
      await NotificationService.shared.initialize();
      
      debugPrint('🔔 Checking current permission status...');
      // Check current permission status first
      final currentStatus = await NotificationService.shared.getPermissionStatus();
      debugPrint('🔔 Current permission status: $currentStatus');
      
      if (currentStatus == AuthorizationStatus.denied) {
        debugPrint('🔔 Permission denied, showing settings dialog...');
        // Permission was previously denied, show dialog to go to settings
        if (!mounted) return;
        
        final bool? shouldOpenSettings = await DialogUtils.showChoiceDialog<bool>(
          context: context,
          title: 'Notification Permission Required',
          message: 'Notification permission has been denied. '
              'Please enable it in your device settings to receive updates.',
          choices: [
            const DialogChoice<bool>(
              label: 'Not now',
              value: false,
              isDefault: true,
            ),
            const DialogChoice<bool>(
              label: 'Open Settings',
              value: true,
            ),
          ],
        );
        
        if (shouldOpenSettings == true) {
          // Open app settings
          await DialogUtils.openAppSettings(context);
        }
        
        if (mounted) {
          setState(() {
            _isEnablingNotifications = false;
          });
        }
        return;
      }
      
      debugPrint('🔔 Requesting notification permission...');
      // Request notification permission
      final granted = await NotificationService.shared.requestPermission();
      debugPrint('🔔 Permission granted: $granted');
      
      if (granted) {
        debugPrint('✅ Notification permission granted');
        
        // Check if device token was registered
        final fcmToken = NotificationService.shared.fcmToken;
        debugPrint('🔔 FCM Token: $fcmToken');
        
        if (mounted) {
          // Navigate to next step
          _navigateToNext();
        }
      } else {
        debugPrint('❌ Notification permission denied');
        
        if (mounted) {
          ToastService.info(
            context: context,
            message: 'You can enable notifications later in settings',
          );
          
          // Still navigate to next step even if permission denied
          _navigateToNext();
        }
      }
    } catch (error) {
      debugPrint('❌ Error enabling notifications: $error');
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to enable notifications. You can try again in settings.',
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