import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../utils/linked_in_validator.dart';
import '../../services/supabase_managers/base_supabase_manager.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
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
  }) : super(title: 'You');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditNameViewState();
}

class _EditNameViewState extends BaseFormViewState<EditNameView> {
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
    final profile = sessionManager.currentProfile;
    
    _firstNameController.text = profile?.firstName.isNotEmpty == true 
        ? profile!.firstName 
        : '';
    
    _lastNameController.text = profile?.lastName?.isNotEmpty == true 
        ? profile!.lastName! 
        : '';
    
    _linkedInController.text = profile?.linkedInURL ?? '';

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
  String getSuccessMessage() => 'Changes successfully saved';

  @override
  String getErrorMessage() => 'Failed to update, please try again';

  @override
  Future<void> performSave() async {
    await _validateAndSave();
  }

  @override
  void onSaveError(dynamic error) {
    // Don't show error toast for user-cancelled URL check
    if (error is _UserCancelledForUrlCheckException) {
      // User chose to check URL - don't show error or navigate
      return;
    }
    // For other errors, the base class already shows the error toast
    super.onSaveError(error);
  }

  /// Custom save handler that includes LinkedIn validation
  Future<void> _validateAndSave() async {
    _computeValidation();
    
    if (!_linkedInFormatIsValid) {
      throw Exception('LinkedIn URL format is invalid');
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
    sessionManager.updateCurrentProfileFields(
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
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text("We couldn't find your name in your LinkedIn URL"),
        content: const Text("Your LinkedIn URL doesn't seem to contain your first and last name. You can continue or double-check your URL."),
        actions: [
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false); // Don't continue
            },
            child: const Text('Check URL'),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDefaultAction: true,
            ),
          ),
          PlatformDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true); // Continue anyway
            },
            child: const Text('Continue anyway'),
          ),
        ],
      ),
    );
    
    return result ?? false; // Default to false if dialog was dismissed
  }

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar for registration wizard
        if (widget.registrationWizard)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProgressBar(
              pageNumber: 1,
              numberOfPages: 10,
            ),
          ),
        
        // First Name field
        buildFieldSection(
          title: 'FIRST NAME',
          content: AppTextField(
            controller: _firstNameController,
            hintText: 'First name',
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
          title: 'LAST NAME',
          content: AppTextField(
            controller: _lastNameController,
            hintText: 'Last name',
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
          title: 'LINKEDIN URL',
          content: AppTextField(
            controller: _linkedInController,
            hintText: 'linkedin.com/in/your-name',
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            style: AppTextFieldStyle.large,
            state: !_linkedInFormatIsValid ? AppTextFieldState.error : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.url],
            enabled: !isUpdating,
          ),
        ),
      ],
    );
  }
}