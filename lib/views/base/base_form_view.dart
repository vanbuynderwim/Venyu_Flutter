import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_modifiers.dart';
import '../../models/enums/registration_step.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../services/tag_group_service.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../profile/edit_company_name_view.dart';
import '../profile/edit_email_info_view.dart';
import '../profile/edit_location_view.dart';
import '../profile/edit_tag_group_view.dart';
import '../profile/edit_avatar_view.dart';
import '../profile/edit_notifications_view.dart';
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
///     sessionManager.updateCurrentProfileFields(...);
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

abstract class BaseFormViewState<T extends BaseFormView> extends State<T> {
  /// Service instances
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  /// Loading state for save operations
  bool _isUpdating = false;
  
  /// Getters for services (available to subclasses)
  SupabaseManager get supabaseManager => _supabaseManager;
  SessionManager get sessionManager => _sessionManager;
  
  /// Whether the form is currently saving
  bool get isUpdating => _isUpdating;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
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
  String getSuccessMessage() => AppStrings.saved;

  /// Get the error message to display after failed save
  @protected
  String getErrorMessage() => 'Failed to update, please try again';

  /// Get the form title
  @protected
  String getFormTitle() => widget.title ?? AppStrings.edit;

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
      debugPrint('Registration wizard complete!');
      Navigator.of(context).pop(true);
      return;
    }

    debugPrint('Navigating from $currentStep to $nextStep');

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
        
      case RegistrationStep.location:
        nextView = const EditLocationView(
          registrationWizard: true,
          currentStep: RegistrationStep.location,
        );
        
      case RegistrationStep.company:
        nextView = EditCompanyNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.company,
        );
        
      case RegistrationStep.roles:
        final tagGroup = TagGroupService.shared.getTagGroupByCode('roles');
        if (tagGroup == null) {
          debugPrint('⚠️ TagGroup "roles" not found in cache, skipping step');
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
          debugPrint('⚠️ TagGroup "sectors" not found in cache, skipping step');
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
          debugPrint('⚠️ TagGroup "meeting_preferences" not found in cache, skipping step');
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
          debugPrint('⚠️ TagGroup "network_goals" not found in cache, skipping step');
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
    if (!canSave || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      // Perform the specific save operation
      await performSave();
      
      // Update loading state
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Navigate immediately after successful save
      if (mounted) {
        navigateAfterSave();
      }
    } catch (error) {
      // Always update loading state first
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Show error toast
      if (mounted) {
        ToastService.error(
          context: context,
          message: getErrorMessage(),
        );
      }
      
      // Log error for debugging
      debugPrint('Error in ${widget.runtimeType}: $error');
    }
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
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
    // Use "Next" for registration wizard, "Save" for regular forms
    final defaultLabel = widget.registrationWizard ? AppStrings.next : AppStrings.save;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ActionButton(
        label: label ?? defaultLabel,
        onPressed: !canSave ? null : (onPressed ?? handleSave),
        isLoading: _isUpdating,
      ),
    );
  }

  /// Whether to use scroll view for the form content
  /// 
  /// Override to false if your form needs to manage its own scrolling
  /// or has Expanded widgets
  @protected
  bool get useScrollView => true;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(getFormTitle()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: useScrollView
                  ? SingleChildScrollView(
                      padding: AppModifiers.cardContentPadding,
                      child: buildFormContent(context),
                    )
                  : Padding(
                      padding: AppModifiers.cardContentPadding,
                      child: buildFormContent(context),
                    ),
            ),
            buildSaveButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}