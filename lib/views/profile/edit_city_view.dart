import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../base/base_form_view.dart';

/// A form screen for editing city information.
///
/// Refactored to use BaseFormView
class EditCityView extends BaseFormView {
  const EditCityView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditCityViewState();
}

class _EditCityViewState extends BaseFormViewState<EditCityView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.editCityTitle;

  // Form controllers
  final _cityController = TextEditingController();

  // Form validation state
  bool _cityTouched = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();

    // Add listeners for validation
    _cityController.addListener(_onCityChanged);
  }

  void _preloadValues() {
    final profile = ProfileService.shared.currentProfile;
    if (profile != null) {
      _cityController.text = profile.city ?? '';
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => _cityController.text.trim().isNotEmpty;

  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editCitySavedMessage;
  }

  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editCityErrorMessage;
  }

  @override
  Future<void> performSave() async {
    await profileManager.updateProfileCity(_cityController.text.trim());

    // Update only the changed field in ProfileService
    ProfileService.shared.updateCurrentProfileFields(
      city: _cityController.text.trim(),
    );
  }

  void _onCityChanged() {
    setState(() {
      if (!_cityTouched) {
        _cityTouched = true;
      }
    });
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
              pageNumber: 3,
              numberOfPages: 10,
            ),
          ),


        // City field
        buildFieldSection(
          title: l10n.editCityCityLabel,
          content: AppTextField(
            controller: _cityController,
            hintText: l10n.editCityCityHint,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _cityTouched && _cityController.text.trim().isEmpty
                ? AppTextFieldState.error
                : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.addressCity],
            enabled: !isUpdating,
          ),
        ),

         FormInfoBox(
          content: l10n.editCityInfoMessage,
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
