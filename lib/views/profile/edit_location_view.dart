import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../../models/enums/onboarding_benefit.dart';
import '../../core/utils/dialog_utils.dart';
import '../../services/supabase_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../base/base_form_view.dart';
import '../company/edit_company_name_view.dart';

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
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 3,
            numberOfPages: 10,
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // Location image in circle
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: AppLayoutStyles.circleDecoration(context),
            child: Center(
              child: Image.asset(
                'assets/images/visuals/location.png',
                width: 100,
                height: 100,
                color: venyuTheme.primary,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image not found
                  return Icon(
                    Icons.location_on_outlined,
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
            'Enable Location',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Location benefits
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              OptionButton(
                option: OnboardingBenefit.nearbyMatches,
                isSelectable: false,
                disabled: true,
              ),
              const SizedBox(height: 8),
              OptionButton(
                option: OnboardingBenefit.distanceAwareness,
                isSelectable: false,
                disabled: true,
              ),
              const SizedBox(height: 8),
              OptionButton(
                option: OnboardingBenefit.betterMatching,
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
              style: ActionButtonType.secondary,
              onPressed: _navigateToNext,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Enable button (primary)
          Expanded(
            child: ActionButton(
              label: 'Enable',
              style: ActionButtonType.primary,
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
    // Navigate directly to company name view
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditCompanyNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.company,
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
        
        if (shouldOpenSettings == true) {
          // Open app settings
          await _openAppSettings();
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
        debugPrint('📍 Got location: ${locationData.latitude}, ${locationData.longitude}');
        
        // Save location to database
        await SupabaseManager.shared.updateProfileLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        );
        
        if (mounted) {
          ToastService.success(
            context: context,
            message: 'Location enabled successfully',
          );
          
          // Navigate to next step
          _navigateToNext();
        }
      } else {
        throw Exception('Could not get location coordinates');
      }
    } catch (error) {
      debugPrint('❌ Error enabling location: $error');
      
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
  
  /// Open app settings for location permissions
  Future<void> _openAppSettings() async {
    // For iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final url = Uri.parse('app-settings:');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      // For Android, use location package's built-in method
      await _location.requestService();
    }
  }
}