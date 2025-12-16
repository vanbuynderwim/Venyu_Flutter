import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../base/base_form_view.dart';

/// A form screen for editing company name.
class EditCompanyNameView extends BaseFormView {
  const EditCompanyNameView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditCompanyNameViewState();
}

class _EditCompanyNameViewState extends BaseFormViewState<EditCompanyNameView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.editCompanyNameTitle;

  // Form controllers
  final _companyNameController = TextEditingController();

  // Form validation state
  bool _companyNameTouched = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();

    // Add listeners for validation
    _companyNameController.addListener(_onCompanyNameChanged);
  }

  void _preloadValues() {
    final profile = ProfileService.shared.currentProfile;
    if (profile != null) {
      _companyNameController.text = profile.companyName ?? '';
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => _companyNameController.text.trim().isNotEmpty;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editCompanyNameSuccessMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editCompanyNameErrorMessage;
  }

  @override
  Future<void> performSave() async {
    await profileManager.updateCompanyName(_companyNameController.text);

    // Update only the changed fields in ProfileService
    ProfileService.shared.updateCurrentProfileFields(
      companyName: _companyNameController.text,
    );
  }

  void _onCompanyNameChanged() {
    setState(() {
      if (!_companyNameTouched) {
        _companyNameTouched = true;
      }
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
              pageNumber: 4,
              numberOfPages: 10,
            ),
          ),

        // Company Name field
        buildFieldSection(
          title: l10n.editCompanyNameCompanyLabel,
          content: AppTextField(
            controller: _companyNameController,
            hintText: l10n.editCompanyNameCompanyHint,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _companyNameTouched && _companyNameController.text.trim().isEmpty
                ? AppTextFieldState.error
                : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.organizationName],
            enabled: !isUpdating,
          ),
        ),
      ],
    );
  }
}
