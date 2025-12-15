import 'package:flutter/material.dart';

import '../../services/supabase_managers/base_supabase_manager.dart';
import '../../services/profile_service.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../base/base_form_view.dart';

/// A form screen for editing user name.
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

  // Form validation state
  bool _firstNameIsEmpty = false;
  bool _lastNameIsEmpty = false;

  // OAuth provider state
  bool _isOAuthUser = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();

    // Add listeners for validation
    _firstNameController.addListener(_computeValidation);
    _lastNameController.addListener(_computeValidation);
  }

  void _preloadValues() async {
    final profile = ProfileService.shared.currentProfile;

    _firstNameController.text = profile?.firstName.isNotEmpty == true
        ? profile!.firstName
        : '';

    _lastNameController.text = profile?.lastName?.isNotEmpty == true
        ? profile!.lastName!
        : '';

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
    super.dispose();
  }

  @override
  bool get canSave => !_formIncomplete;

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
    await _saveProfileData();
  }

  Future<void> _saveProfileData() async {
    await profileManager.updateProfileName(
      _firstNameController.text,
      _lastNameController.text,
    );

    // Update local state
    ProfileService.shared.updateCurrentProfileFields(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );
  }

  void _computeValidation() {
    setState(() {
      // Just trigger rebuild to update canSave
    });
  }

  @override
  bool get useScrollView => true;

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
            enabled: (widget.registrationWizard || _firstNameIsEmpty) && !isUpdating,
          ),
        ),

        // Last Name field
        buildFieldSection(
          title: l10n.editNameLastNameLabel,
          content: AppTextField(
            controller: _lastNameController,
            hintText: l10n.editNameLastNameHint,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _lastNameIsEmpty ? AppTextFieldState.error : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.familyName],
            enabled: (widget.registrationWizard || _lastNameIsEmpty) && !isUpdating,
          ),
        ),
      ],
    );
  }
}
