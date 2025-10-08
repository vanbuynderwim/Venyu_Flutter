import 'package:app/views/profile/edit_city_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:location/location.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../../models/enums/onboarding_benefit.dart';
import '../../core/utils/dialog_utils.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/onboarding_benefits_card.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/visual_icon_widget.dart';
import '../base/base_form_view.dart';

/// A placeholder form screen for editing user location information.
/// 
/// This is a temporary implementation for the registration wizard.
/// Will be expanded later with actual location selection functionality.
class EditLocationView extends BaseFormView {
  const EditLocationView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  }) : super(title: 'Location');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditLocationViewState();
}

class _EditLocationViewState extends BaseFormViewState<EditLocationView> {
  final Location _location = Location();
  bool _isEnablingLocation = false;
  
  @override
  bool get canSave => true;

  @override
  String getSuccessMessage() => 'Location saved';

  @override
  String getErrorMessage() => 'Failed to save location';

  @override
  Future<void> performSave() async {
    // Placeholder - no actual save logic yet
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 3,
            numberOfPages: 11,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Location image in circle
        VisualIconWidget(
          iconName: 'location',
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Center(
          child: Text(
            'Enable location to',
            style: AppTextStyles.title2,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Location benefits
        OnboardingBenefitsCard(
          benefits: [
            OnboardingBenefit.nearbyMatches,
            OnboardingBenefit.distanceAwareness,
            OnboardingBenefit.betterMatching,
          ],
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
          
          const SizedBox(width: 8),
          
          // Enable button (primary)
          Expanded(
            child: ActionButton(
              label: 'Enable',
              type: ActionButtonType.primary,
              onPressed: _enableLocationService,
              isLoading: _isEnablingLocation,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to the next step without enabling location
  void _navigateToNext() {
    // Navigate directly to city view
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => const EditCityView(
          registrationWizard: true,
          currentStep: RegistrationStep.city,
        ),
      ),
    );
  }

  /// Enable location service and save coordinates
  Future<void> _enableLocationService() async {
    if (_isEnablingLocation) return;
    
    setState(() {
      _isEnablingLocation = true;
    });
    
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          // Service not enabled, show error
          if (mounted) {
            ToastService.error(
              context: context,
              message: 'Location services are disabled. Please enable them in settings.',
            );
            setState(() {
              _isEnablingLocation = false;
            });
          }
          return;
        }
      }
      
      // Check permission status
      PermissionStatus permissionGranted = await _location.hasPermission();
      
      if (permissionGranted == PermissionStatus.denied) {
        // Request permission
        permissionGranted = await _location.requestPermission();
        
        if (permissionGranted == PermissionStatus.denied) {
          // Permission denied, navigate without location
          if (mounted) {
            ToastService.info(
              context: context,
              message: 'Location permission denied. You can enable it later in settings.',
            );
            _navigateToNext();
          }
          return;
        }
      }
      
      if (permissionGranted == PermissionStatus.deniedForever) {
        // Permission permanently denied, open settings
        if (!mounted) return;
        
        final bool? shouldOpenSettings = await DialogUtils.showChoiceDialog<bool>(
          context: context,
          title: 'Location Permission Required',
          message: 'Location permission has been permanently denied. '
              'Please enable it in your device settings to use this feature.',
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
        
        if (shouldOpenSettings == true && mounted) {
          // Open app settings
          await DialogUtils.openAppSettings(context);
        }
        
        if (mounted) {
          setState(() {
            _isEnablingLocation = false;
          });
        }
        return;
      }
      
      // Permission granted, get location
      final LocationData locationData = await _location.getLocation();
      
      if (locationData.latitude != null && locationData.longitude != null) {
        AppLogger.success('Location obtained: ${locationData.latitude}, ${locationData.longitude}', context: 'EditLocationView');
        
        // Save location to database
        await ProfileManager.shared.updateProfileLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        );
        
        if (mounted) {
          //ToastService.success(
          //  context: context,
          //  message: 'Location enabled successfully',
          //);
          
          // Navigate to next step
          _navigateToNext();
        }
      } else {
        throw Exception('Could not get location coordinates');
      }
    } catch (error) {
      AppLogger.error('Error enabling location', context: 'EditLocationView', error: error);
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to enable location. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnablingLocation = false;
        });
      }
    }
  }
}