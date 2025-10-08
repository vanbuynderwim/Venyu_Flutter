import 'package:flutter/material.dart';

import '../../utils/website_validator.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../base/base_form_view.dart';

/// A form screen for editing company name and website information.
/// 
/// Refactored to use BaseFormView - reduced from 365 to ~140 lines
class EditCompanyNameView extends BaseFormView {
  const EditCompanyNameView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  }) : super(title: 'Company name');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditCompanyNameViewState();
}

class _EditCompanyNameViewState extends BaseFormViewState<EditCompanyNameView> {
  // Form controllers
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();

  // Form validation state
  bool _companyNameTouched = false;
  bool _websiteTouched = false;
  bool _websiteFormatIsValid = true;

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadValues();
    
    // Add listeners for validation
    _companyNameController.addListener(_onCompanyNameChanged);
    _websiteController.addListener(_onWebsiteChanged);
  }

  void _preloadValues() {
    final profile = ProfileService.shared.currentProfile;
    if (profile != null) {
      _companyNameController.text = profile.companyName ?? '';
      _websiteController.text = profile.websiteURL ?? '';
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  bool get canSave => 
    _companyNameController.text.trim().isNotEmpty &&
    _websiteFormatIsValid;

  @override
  String getSuccessMessage() => 'Company info changes saved';

  @override
  String getErrorMessage() => 'Failed to update company info, please try again';

  @override
  Future<void> performSave() async {
    // Normalize the website URL for storage
    final cleanedWebsiteURL = WebsiteValidator.normalizeForStorage(_websiteController.text) 
        ?? _websiteController.text;
    
    await profileManager.updateCompanyInfo(_companyNameController.text, cleanedWebsiteURL);
    
    // Update only the changed fields in ProfileService
    ProfileService.shared.updateCurrentProfileFields(
      companyName: _companyNameController.text,
      websiteURL: cleanedWebsiteURL,
    );
  }

  void _onCompanyNameChanged() {
    setState(() {
      if (!_companyNameTouched) {
        _companyNameTouched = true;
      }
    });
  }

  void _onWebsiteChanged() {
    final isValid = _websiteController.text.isEmpty || 
        WebsiteValidator.isValidFormat(_websiteController.text);
    
    setState(() {
      if (!_websiteTouched) {
        _websiteTouched = true;
      }
      _websiteFormatIsValid = isValid;
    });
  }

  @override
  bool get useScrollView => true; // Enable scroll view for info box content

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
              pageNumber: 5,
              numberOfPages: 11,
            ),
          ),

        // Company Name field
        buildFieldSection(
          title: 'COMPANY NAME',
          content: AppTextField(
            controller: _companyNameController,
            hintText: 'Company name',
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            style: AppTextFieldStyle.large,
            state: _companyNameTouched && _companyNameController.text.trim().isEmpty
                ? AppTextFieldState.error
                : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.organizationName],
            enabled: !isUpdating,
          ),
        ),

        // Website URL field
        buildFieldSection(
          title: 'WEBSITE',
          content: AppTextField(
            controller: _websiteController,
            hintText: 'Website',
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            style: AppTextFieldStyle.large,
            state: _websiteTouched && !_websiteFormatIsValid
                ? AppTextFieldState.error
                : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.url],
            enabled: !isUpdating,
          ),
        ),

        // Company info box
        FormInfoBox(
          content: 'Your company name and website are only shared with people you get introduced to, not with matches. They help make introductions more meaningful and relevant.',
        ),
      ],
    );
  }
}