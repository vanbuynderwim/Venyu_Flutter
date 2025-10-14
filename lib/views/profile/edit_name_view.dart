import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../utils/linked_in_validator.dart';
import '../../services/supabase_managers/base_supabase_manager.dart';
import '../../services/profile_service.dart';
import '../../services/toast_service.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../../widgets/common/info_box_widget.dart';
import '../base/base_form_view.dart';

/// Special exception for when user chooses to check LinkedIn URL
/// This should not trigger an error toast
class _UserCancelledForUrlCheckException implements Exception {
  const _UserCancelledForUrlCheckException();
}

/// A form screen for editing user name and LinkedIn profile information.
///
/// Refactored to use BaseFormView - reduced from 423 to ~180 lines
class EditNameView extends BaseFormView {
  const EditNameView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditNameViewState();
}

class _EditNameViewState extends BaseFormViewState<EditNameView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.editNameTitle;

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _linkedInController = TextEditingController();

  // Form validation state
  bool _firstNameIsEmpty = false;
  bool _lastNameIsEmpty = false;
  bool _linkedInFormatIsValid = true;
  bool _linkedInNameMatches = true;
  
  // OAuth provider state
  bool _isOAuthUser = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();
    
    // Add listeners for validation
    _firstNameController.addListener(_computeValidation);
    _lastNameController.addListener(_computeValidation);
    _linkedInController.addListener(_computeValidation);
  }

  void _preloadValues() async {
    final profile = ProfileService.shared.currentProfile;

    _firstNameController.text = profile?.firstName.isNotEmpty == true
        ? profile!.firstName
        : '';

    _lastNameController.text = profile?.lastName?.isNotEmpty == true
        ? profile!.lastName!
        : '';

    // Pre-fill LinkedIn URL with 'linkedin.com/in/' if empty
    final linkedInURL = profile?.linkedInURL ?? '';
    _linkedInController.text = linkedInURL.isEmpty ? 'linkedin.com/in/' : linkedInURL;

    _firstNameIsEmpty = _firstNameController.text.isEmpty;
    _lastNameIsEmpty = _lastNameController.text.isEmpty;
    
    // Check if user signed in with OAuth provider
    try {
      final storedInfo = await BaseSupabaseManager.getStoredUserInfo();
      final authProvider = storedInfo['auth_provider'];
      _isOAuthUser = authProvider != null && authProvider.isNotEmpty;
    } catch (e) {
      AppLogger.error('Failed to get stored user info', context: 'EditNameView', error: e);
      _isOAuthUser = false;
    }
    
    if (mounted) {
      setState(() {}); // Trigger rebuild with OAuth state
    }
    
    _computeValidation();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => !_formIncomplete && _linkedInFormatIsValid;

  bool get _formIncomplete => 
    !_isOAuthUser && (
      (_firstNameIsEmpty && _firstNameController.text.isEmpty) || 
      (_lastNameIsEmpty && _lastNameController.text.isEmpty)
    );

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editNameSuccessMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editNameErrorMessage;
  }

  @override
  Future<void> performSave() async {
    await _validateAndSave();
  }

  @override
  Future<void> handleSave() async {
    if (!canSave || isProcessing) return;

    await executeWithLoading(
      operation: performSave,
      successMessage: null,
      showSuccessToast: false,
      showErrorToast: false,  // We'll handle error toasts ourselves
      useProcessingState: true,
      onSuccess: navigateAfterSave,
      onError: (error) {
        // Only show error toast if it's not the user-cancelled exception
        if (error is! _UserCancelledForUrlCheckException) {
          ToastService.error(
            context: context,
            message: getErrorMessage(),
          );
        }
        // else: User chose to check URL - don't show error
      },
    );
  }

  /// Custom save handler that includes LinkedIn validation
  Future<void> _validateAndSave() async {
    _computeValidation();

    if (!_linkedInFormatIsValid) {
      final l10n = AppLocalizations.of(context)!;
      throw Exception(l10n.editNameLinkedInFormatError);
    }
    
    if (!_linkedInNameMatches) {
      // Show dialog and wait for user choice
      final shouldContinue = await _showNameMismatchDialog();
      if (!shouldContinue) {
        // User chose to check URL - throw a special exception that won't show error toast
        throw _UserCancelledForUrlCheckException();
      }
    }
    
    // Perform the actual save
    await _saveProfileData();
  }

  Future<void> _saveProfileData({bool withValidLinkedInURL = true}) async {
    // Normalize the LinkedIn URL for storage
    final cleanedLinkedInURL = LinkedInValidator.normalizeForStorage(_linkedInController.text) 
        ?? _linkedInController.text;
    
    await profileManager.updateProfileName(
      _firstNameController.text, 
      _lastNameController.text, 
      cleanedLinkedInURL, 
      withValidLinkedInURL,
    );
    
    // Update local state
    ProfileService.shared.updateCurrentProfileFields(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      linkedInURL: cleanedLinkedInURL,
    );
  }

  void _computeValidation() {
    final linkedInURL = _linkedInController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    
    setState(() {
      _linkedInFormatIsValid = linkedInURL.isNotEmpty && LinkedInValidator.isValidFormat(linkedInURL);
      _linkedInNameMatches = linkedInURL.isEmpty || LinkedInValidator.nameMatches(linkedInURL, firstName, lastName);
    });
  }

  /// Shows dialog when LinkedIn URL doesn't match name
  /// Returns true if user wants to continue anyway
  Future<bool> _showNameMismatchDialog() async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(l10n.editNameLinkedInMismatchDialogTitle),
        content: Text(l10n.editNameLinkedInMismatchDialogMessage),
        actions: [
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false); // Don't continue
            },
            child: Text(l10n.editNameLinkedInMismatchDialogCheckUrl),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDefaultAction: true,
            ),
          ),
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true); // Continue anyway
            },
            child: Text(l10n.editNameLinkedInMismatchDialogContinue),
          ),
        ],
      ),
    );

    return result ?? false; // Default to false if dialog was dismissed
  }

  @override
  bool get useScrollView => true; // Enable scroll view for info box content

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar for registration wizard
        if (widget.registrationWizard)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProgressBar(
              pageNumber: 1,
              numberOfPages: 11,
            ),
          ),

        // First Name field
        buildFieldSection(
          title: l10n.editNameFirstNameLabel,
          content: AppTextField(
            controller: _firstNameController,
            hintText: l10n.editNameFirstNameHint,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _firstNameIsEmpty ? AppTextFieldState.error : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.givenName],
            enabled: _firstNameIsEmpty && !isUpdating,
          ),
        ),

        // Last Name field
        buildFieldSection(
          title: l10n.editNameLastNameLabel,
          content: AppTextField(
            controller: _lastNameController,
            hintText: l10n.editNameLastNameHint,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _lastNameIsEmpty ? AppTextFieldState.error : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.familyName],
            enabled: _lastNameIsEmpty && !isUpdating,
          ),
        ),


        // LinkedIn URL field
        buildFieldSection(
          title: l10n.editNameLinkedInLabel,
          content: AppTextField(
            controller: _linkedInController,
            hintText: l10n.editNameLinkedInHint,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            style: AppTextFieldStyle.large,
            state: !_linkedInFormatIsValid ? AppTextFieldState.error : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.url],
            enabled: !isUpdating,
          ),
        ),

        // LinkedIn info box
        FormInfoBox(
          content: l10n.editNameLinkedInInfoMessage,
        ),

        const SizedBox(height: 12),

        // LinkedIn mobile tip
        InfoBoxWidget(
          text: l10n.editNameLinkedInMobileTip,
          iconName: 'bulb',
        ),

        const SizedBox(height: 16),

      ],
    );
  }
}