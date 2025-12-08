import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/enums/registration_step.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/tag_group_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../profile/edit_company_name_view.dart';
import '../profile/edit_email_info_view.dart';
import '../profile/edit_location_view.dart';
import '../profile/edit_city_view.dart';
import '../profile/edit_tag_group_view.dart';
import '../profile/edit_avatar_view.dart';
import '../profile/edit_notifications_view.dart';
import '../profile/edit_optin_view.dart';
import '../profile/registration_complete_view.dart';

/// Base class for all form-based views in the application.
/// 
/// This abstract class provides common functionality for forms including:
/// - Service initialization (SupabaseManager, SessionManager)
/// - Loading state management
/// - Save operation with error handling
/// - Success/error feedback via SnackBars
/// - Navigation after successful save
/// - Common UI patterns (field sections, save buttons)
/// 
/// Subclasses must implement:
/// - [buildFormContent] to provide the form fields
/// - [performSave] to handle the specific save operation
/// - [getSuccessMessage] to provide a custom success message
/// - [getErrorMessage] to provide a custom error message
/// 
/// Example usage:
/// ```dart
/// class EditNameView extends BaseFormView {
///   @override
///   Future<void> performSave() async {
///     await supabaseManager.updateProfileName(...);
///     ProfileService.shared.updateCurrentProfileFields(...);
///   }
/// }
/// ```
abstract class BaseFormView extends StatefulWidget {
  /// Whether this form is part of the registration wizard
  final bool registrationWizard;
  
  /// Optional custom title for the form
  final String? title;
  
  /// Current step in the registration wizard (required if registrationWizard is true)
  final RegistrationStep? currentStep;

  const BaseFormView({
    super.key,
    this.registrationWizard = false,
    this.title,
    this.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState();
}

abstract class BaseFormViewState<T extends BaseFormView> extends State<T> with ErrorHandlingMixin<T> {
  /// Service instances
  late final ProfileManager _profileManager;
  late final ProfileService _profileService;
  
  /// Getters for services (available to subclasses)
  ProfileManager get profileManager => _profileManager;
  ProfileService get sessionManager => _profileService;
  ProfileService get profileService => _profileService;
  
  /// Whether the form is currently saving (uses mixin's isProcessing state)
  bool get isUpdating => isProcessing;

  @override
  void initState() {
    super.initState();
    _profileManager = ProfileManager.shared;
    _profileService = ProfileService.shared;
    initializeForm();
  }

  /// Initialize form-specific data (controllers, validation, etc.)
  /// 
  /// Override this method to set up form controllers, load initial data,
  /// or perform other initialization tasks.
  @protected
  void initializeForm() {
    // Default implementation - override in subclasses if needed
  }

  /// Build the form content (fields, sections, etc.)
  /// 
  /// This method should return the main content of the form,
  /// typically a Column with form fields.
  @protected
  Widget buildFormContent(BuildContext context);

  /// Perform the save operation
  /// 
  /// This method should contain the specific logic for saving the form data.
  /// It should throw an exception if the save fails.
  @protected
  Future<void> performSave();

  /// Get the success message to display after successful save
  @protected
  String getSuccessMessage() => AppLocalizations.of(context)!.successSaved;

  /// Get the error message to display after failed save
  @protected
  String getErrorMessage() => AppLocalizations.of(context)!.baseFormViewErrorUpdate;

  /// Get the form title
  @protected
  String getFormTitle() => widget.title ?? AppLocalizations.of(context)!.actionEdit;

  /// Whether the save button should be enabled
  /// 
  /// Override to add custom validation logic
  @protected
  bool get canSave => true;

  /// Navigate after successful save
  /// 
  /// Override to customize navigation behavior
  @protected
  void navigateAfterSave() {
    if (widget.registrationWizard && widget.currentStep != null) {
      _navigateToNextRegistrationStep();
    } else {
      // Return true to indicate changes were saved
      Navigator.of(context).pop(true);
    }
  }

  /// Navigate to the next step in the registration wizard
  void _navigateToNextRegistrationStep({RegistrationStep? fromStep}) {
    final currentStep = fromStep ?? widget.currentStep!;
    final nextStep = currentStep.nextStep;
    
    if (nextStep == null) {
      // Registration complete, navigate to main app
      AppLogger.success('Registration wizard complete!', context: 'BaseFormView');
      Navigator.of(context).pop(true);
      return;
    }

    AppLogger.debug('Navigating from $currentStep to $nextStep', context: 'BaseFormView');

    // Navigate to the appropriate view based on the next step
    Widget nextView;
    switch (nextStep) {
      case RegistrationStep.name:
        // This shouldn't happen as name is the first step
        throw Exception('Cannot navigate to name step from another step');
      
      case RegistrationStep.email:
        nextView = const EditEmailInfoView(
          registrationWizard: true,
          currentStep: RegistrationStep.email,
        );

      case RegistrationStep.optin:
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditOptinView(
              registrationWizard: true,
              currentStep: RegistrationStep.optin,
            ),
          ),
        );
        return;

      case RegistrationStep.location:
        nextView = const EditLocationView(
          registrationWizard: true,
          currentStep: RegistrationStep.location,
        );

      case RegistrationStep.city:
        nextView = const EditCityView(
          registrationWizard: true,
          currentStep: RegistrationStep.city,
        );

      case RegistrationStep.company:
        nextView = EditCompanyNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.company,
        );
        
      case RegistrationStep.roles:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('roles');
        if (tagGroup == null) {
          AppLogger.warning('TagGroup "roles" not found in cache, skipping step', context: 'BaseFormView');
          return _navigateToNextRegistrationStep(fromStep: RegistrationStep.roles);
        }
        nextView = EditTagGroupView(
          tagGroup: tagGroup,
          registrationWizard: true,
          currentStep: RegistrationStep.roles,
        );
        
      case RegistrationStep.sectors:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('sectors');
        if (tagGroup == null) {
          AppLogger.warning('TagGroup "sectors" not found in cache, skipping step', context: 'BaseFormView');
          return _navigateToNextRegistrationStep(fromStep: RegistrationStep.sectors);
        }
        nextView = EditTagGroupView(
          tagGroup: tagGroup,
          registrationWizard: true,
          currentStep: RegistrationStep.sectors,
        );
        
      case RegistrationStep.meetingPreferences:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('meeting_preferences');
        if (tagGroup == null) {
          AppLogger.warning('TagGroup "meeting_preferences" not found in cache, skipping step', context: 'BaseFormView');
          return _navigateToNextRegistrationStep(fromStep: RegistrationStep.meetingPreferences);
        }
        nextView = EditTagGroupView(
          tagGroup: tagGroup,
          registrationWizard: true,
          currentStep: RegistrationStep.meetingPreferences,
        );
        
      case RegistrationStep.networkingGoals:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('network_goals');
        if (tagGroup == null) {
          AppLogger.warning('TagGroup "network_goals" not found in cache, skipping step', context: 'BaseFormView');
          return _navigateToNextRegistrationStep(fromStep: RegistrationStep.networkingGoals);
        }
        nextView = EditTagGroupView(
          tagGroup: tagGroup,
          registrationWizard: true,
          currentStep: RegistrationStep.networkingGoals,
        );
        
      case RegistrationStep.avatar:
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditAvatarView(
              registrationWizard: true,
              currentStep: RegistrationStep.avatar,
            ),
          ),
        );
        return;
        
      case RegistrationStep.notifications:
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditNotificationsView(
              registrationWizard: true,
              currentStep: RegistrationStep.notifications,
            ),
          ),
        );
        return;

      case RegistrationStep.referrer:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('referrer');
        if (tagGroup == null) {
          AppLogger.warning('TagGroup "referrer" not found in cache, skipping step', context: 'BaseFormView');
          return _navigateToNextRegistrationStep(fromStep: RegistrationStep.referrer);
        }
        nextView = EditTagGroupView(
          tagGroup: tagGroup,
          registrationWizard: true,
          currentStep: RegistrationStep.referrer,
        );

      case RegistrationStep.complete:
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const RegistrationCompleteView(),
          ),
        );
        return;
    }

    // Navigate to next step (keeping current view in stack for back navigation)
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => nextView,
      ),
    );
  }

  /// Common save handler with error handling and feedback
  @protected
  Future<void> handleSave() async {
    if (!canSave || isProcessing) return;

    await executeWithLoading(
      operation: performSave,
      successMessage: null,  // Don't show success toast - we navigate immediately
      errorMessage: getErrorMessage(),
      showSuccessToast: false,  // We navigate on success, no need for toast
      useProcessingState: true,  // Use processing state for save operations
      onSuccess: navigateAfterSave,  // Navigate after successful save
      onError: (error) {
        // Additional error handling if needed by subclasses
        onSaveError(error);
      },
    );
  }
  
  /// Override this method in subclasses if you need custom error handling
  @protected
  void onSaveError(dynamic error) {
    // Default: do nothing extra (error toast already shown by mixin)
  }

  /// Build a standard field section with title and content
  @protected
  Widget buildFieldSection({
    required String title,
    required Widget content,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.caption1.copyWith(
              letterSpacing: 0.5,
              color: context.venyuTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  /// Build a standard save button
  @protected
  Widget buildSaveButton({
    String? label,
    VoidCallback? onPressed,
  }) {
    final l10n = AppLocalizations.of(context)!;
    // Use "Next" for registration wizard, "Save" for regular forms
    final defaultLabel = widget.registrationWizard ? l10n.actionNext : l10n.actionSave;
    
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8, // Extra padding when keyboard is open
      ),
      child: ActionButton(
        label: label ?? defaultLabel,
        onPressed: !canSave ? null : (onPressed ?? handleSave),
        isLoading: isProcessing,  // Use mixin's processing state
      ),
    );
  }


  /// Whether to use scroll view for the form content
  /// 
  /// Override to false if your form needs to manage its own scrolling
  /// or has Expanded widgets
  @protected
  bool get useScrollView => true;

  /// Custom padding for the form content
  /// 
  /// Override to provide custom padding instead of default cardContentPadding
  @protected
  EdgeInsets get formContentPadding => AppModifiers.cardContentPadding;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(getFormTitle()),
      ),
      body: SafeArea(
        bottom: true, // Allow keyboard to overlay the bottom safe area
        child: Column(
          children: [
            Expanded(
              child: useScrollView
                  ? SingleChildScrollView(
                      padding: formContentPadding,
                      child: buildFormContent(context),
                    )
                  : Padding(
                      padding: formContentPadding,
                      child: buildFormContent(context),
                    ),
            ),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }
}