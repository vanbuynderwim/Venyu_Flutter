import 'package:flutter/material.dart';

import '../../models/requests/update_company_request.dart';
import '../../utils/website_validator.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
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
    final profile = sessionManager.currentProfile;
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
    _companyNameController.text.isNotEmpty &&
    _websiteController.text.isNotEmpty &&
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
    
    final request = UpdateCompanyRequest(
      companyName: _companyNameController.text,
      websiteURL: cleanedWebsiteURL,
    );
    
    await supabaseManager.updateCompanyInfo(request);
    
    // Update only the changed fields in SessionManager
    sessionManager.updateCurrentProfileFields(
      companyName: _companyNameController.text,
      websiteURL: cleanedWebsiteURL,
    );
  }

  void _onCompanyNameChanged() {
    if (!_companyNameTouched) {
      setState(() {
        _companyNameTouched = true;
      });
    }
  }

  void _onWebsiteChanged() {
    if (!_websiteTouched) {
      setState(() {
        _websiteTouched = true;
      });
    }
    
    final isValid = _websiteController.text.isEmpty || 
        WebsiteValidator.isValidFormat(_websiteController.text);
    
    if (isValid != _websiteFormatIsValid) {
      setState(() {
        _websiteFormatIsValid = isValid;
      });
    }
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
              pageNumber: 4,
              numberOfPages: 10,
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
            state: _companyNameTouched && _companyNameController.text.isEmpty 
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
            style: AppTextFieldStyle.large,
            state: _websiteTouched && !_websiteFormatIsValid
                ? AppTextFieldState.error
                : AppTextFieldState.normal,
            errorText: _websiteTouched && !_websiteFormatIsValid
                ? 'Please enter a valid website URL'
                : null,
            autofillHints: const [AutofillHints.url],
            enabled: !isUpdating,
          ),
        ),
      ],
    );
  }
}