import 'dart:async';

import 'package:app/views/profile/edit_city_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:location/location.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
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
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditLocationViewState();
}

class _EditLocationViewState extends BaseFormViewState<EditLocationView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.registrationStepLocationTitle;

  final Location _location = Location();
  bool _isEnablingLocation = false;

  @override
  bool get canSave => true;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editLocationSavedMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editLocationSaveErrorMessage;
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
            l10n.registrationStepLocationTitle,
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ActionButton(
        label: l10n.actionNext,
        type: ActionButtonType.primary,
        onPressed: _enableLocationService,
        isLoading: _isEnablingLocation,
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
            final l10n = AppLocalizations.of(context)!;
            ToastService.error(
              context: context,
              message: l10n.editLocationServicesDisabledMessage,
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
            setState(() {
              _isEnablingLocation = false;
            });
            final l10n = AppLocalizations.of(context)!;
            ToastService.info(
              context: context,
              message: l10n.editLocationPermissionDeniedMessage,
            );
            _navigateToNext();
          }
          return;
        }
      }

      if (permissionGranted == PermissionStatus.deniedForever) {
        // Permission permanently denied, open settings
        if (!mounted) return;

        final l10n = AppLocalizations.of(context)!;
        final bool? shouldOpenSettings = await DialogUtils.showChoiceDialog<bool>(
          context: context,
          title: l10n.editLocationPermissionDialogTitle,
          message: l10n.editLocationPermissionDialogMessage,
          choices: [
            DialogChoice<bool>(
              label: l10n.editLocationPermissionDialogNotNow,
              value: false,
              isDefault: true,
            ),
            DialogChoice<bool>(
              label: l10n.editLocationPermissionDialogOpenSettings,
              value: true,
            ),
          ],
        );

        if (shouldOpenSettings == true && mounted) {
          // Open app settings
          await DialogUtils.openAppSettings(context);

          if (mounted) {
            setState(() {
              _isEnablingLocation = false;
            });
          }
        } else {
          // User chose "Not now" - continue to next step without location
          if (mounted) {
            setState(() {
              _isEnablingLocation = false;
            });
            _navigateToNext();
          }
        }
        return;
      }

      // Configure location settings to accept approximate/reduced accuracy location
      // This is mapped to kCLLocationAccuracyReduced on iOS 14+
      await _location.changeSettings(
        accuracy: LocationAccuracy.reduced,
        interval: 1000, // Update every second if available
        distanceFilter: 0,
      );

      AppLogger.debug('Starting background location listener - user can continue immediately', context: 'EditLocationView');

      // Start listening for location updates in the background via ProfileManager
      // This persists even after this view is disposed
      // The location will be saved automatically when GPS gets a fix
      // User doesn't have to wait!
      ProfileManager.shared.startBackgroundLocationListener(_location);

      if (mounted) {
        setState(() {
          _isEnablingLocation = false;
        });

        // Navigate to next step immediately - location will be saved in background
        _navigateToNext();
      }
    } catch (error) {
      AppLogger.error('Error enabling location', context: 'EditLocationView', error: error);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.error(
          context: context,
          message: l10n.editLocationEnableErrorMessage,
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