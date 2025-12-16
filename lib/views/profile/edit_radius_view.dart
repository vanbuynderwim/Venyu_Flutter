import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/form_info_box.dart';
import '../../widgets/common/visual_icon_widget.dart';
import '../base/base_form_view.dart';

/// A form screen for editing match radius settings.
///
/// This view allows users to configure:
/// - How far they want to be matched from their current location (0-100 km)
///
/// Requires location permission to be enabled before radius can be set.
class EditRadiusView extends BaseFormView {
  const EditRadiusView({super.key});

  @override
  BaseFormViewState<BaseFormView> createState() => _EditRadiusViewState();
}

class _EditRadiusViewState extends BaseFormViewState<EditRadiusView> {
  double _radiusValue = 50;
  double _initialValue = 50;

  final Location _location = Location();
  bool _isCheckingLocation = true;
  bool _locationEnabled = false;
  bool _isEnablingLocation = false;

  @override
  String getFormTitle() => AppLocalizations.of(context)!.accountSettingsRadiusTitle;

  @override
  void initializeForm() {
    super.initializeForm();
    _loadCurrentRadius();
    _checkLocationPermission();
  }

  void _loadCurrentRadius() {
    final profile = ProfileService.shared.currentProfile;
    if (profile != null && profile.matchRadius != null) {
      _radiusValue = profile.matchRadius!.toDouble().clamp(0, 100);
      _initialValue = _radiusValue;
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      // Check if location service is enabled
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _isCheckingLocation = false;
            _locationEnabled = false;
          });
        }
        return;
      }

      // Check permission status
      final permissionStatus = await _location.hasPermission();
      final hasPermission = permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited;

      if (mounted) {
        setState(() {
          _isCheckingLocation = false;
          _locationEnabled = hasPermission;
        });
      }
    } catch (error) {
      AppLogger.error('Error checking location permission', error: error, context: 'EditRadiusView');
      if (mounted) {
        setState(() {
          _isCheckingLocation = false;
          _locationEnabled = false;
        });
      }
    }
  }

  Future<void> _enableLocation() async {
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
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ToastService.info(
              context: context,
              message: l10n.editLocationPermissionDeniedMessage,
            );
            setState(() {
              _isEnablingLocation = false;
            });
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
          await DialogUtils.openAppSettings(context);
        }

        if (mounted) {
          setState(() {
            _isEnablingLocation = false;
          });
          // Re-check permission after returning from settings
          _checkLocationPermission();
        }
        return;
      }

      // Permission granted - configure location and start background listener
      await _location.changeSettings(
        accuracy: LocationAccuracy.reduced,
        interval: 1000,
        distanceFilter: 0,
      );

      // Start background location listener
      ProfileManager.shared.startBackgroundLocationListener(_location);

      if (mounted) {
        setState(() {
          _isEnablingLocation = false;
          _locationEnabled = true;
        });
      }
    } catch (error) {
      AppLogger.error('Error enabling location', error: error, context: 'EditRadiusView');

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.error(
          context: context,
          message: l10n.editLocationEnableErrorMessage,
        );
        setState(() {
          _isEnablingLocation = false;
        });
      }
    }
  }

  @override
  bool get canSave => _locationEnabled && _radiusValue != _initialValue;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editRadiusSavedMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editRadiusSaveErrorMessage;
  }

  @override
  Future<void> performSave() async {
    try {
      final radiusInt = _radiusValue.round();
      await ProfileManager.shared.updateProfileRadius(radiusInt);
      ProfileService.shared.updateCurrentProfileFields(matchRadius: radiusInt);
      _initialValue = _radiusValue;
    } catch (error) {
      AppLogger.error('Failed to save radius', error: error, context: 'EditRadiusView');
      rethrow;
    }
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Radius image in circle
        const VisualIconWidget(
          iconName: 'radius',
        ),

        const SizedBox(height: 24),

        // Title
        Center(
          child: Text(
            l10n.accountSettingsRadiusTitle,
            style: AppTextStyles.title2,
          ),
        ),

        const SizedBox(height: 8),

        // Description
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.accountSettingsRadiusDescription,
              style: AppTextStyles.body.copyWith(
                color: venyuTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Loading state
        if (_isCheckingLocation) ...[
          const Center(
            child: CircularProgressIndicator(),
          ),
        ]
        // Location not enabled - show enable button
        else if (!_locationEnabled) ...[
          _buildLocationRequiredCard(context),
        ]
        // Location enabled - show slider
        else ...[
          _buildRadiusSlider(context),
        ],
      ],
    );
  }

  Widget _buildLocationRequiredCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: venyuTheme.warning.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: venyuTheme.warning,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.editRadiusLocationRequiredTitle,
              style: AppTextStyles.headline.copyWith(
                color: venyuTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.editRadiusLocationRequiredMessage,
              style: AppTextStyles.body.copyWith(
                color: venyuTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ActionButton(
              label: l10n.editRadiusEnableLocationButton,
              onPressed: _enableLocation,
              isLoading: _isEnablingLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusSlider(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return Column(
      children: [
        // Current value display
        Center(
          child: Text(
            _radiusValue == 0
                ? l10n.editRadiusUnlimited
                : '${_radiusValue.round()} km',
            style: AppTextStyles.title1.copyWith(
              color: venyuTheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Slider wrapped in Material for Cupertino compatibility
        Material(
          color: Colors.transparent,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: venyuTheme.primary,
              inactiveTrackColor: venyuTheme.primary.withValues(alpha: 0.2),
              thumbColor: venyuTheme.primary,
              overlayColor: venyuTheme.primary.withValues(alpha: 0.2),
              trackHeight: 16,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
            ),
            child: Slider(
              value: _radiusValue,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _radiusValue = value;
                });
              },
            ),
          ),
        ),

        // Min/Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.editRadiusUnlimited,
                style: AppTextStyles.caption1.copyWith(
                  color: venyuTheme.secondaryText,
                ),
              ),
              Text(
                '100 km',
                style: AppTextStyles.caption1.copyWith(
                  color: venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Info text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FormInfoBox(
            content: l10n.editRadiusInfoText,
          ),
        ),
      ],
    );
  }
}
