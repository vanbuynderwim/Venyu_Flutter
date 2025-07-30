import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/requests/update_company_request.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../utils/website_validator.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// A form screen for editing company name and website information.
/// 
/// This widget provides a comprehensive form for updating:
/// - Company name (required)
/// - Website URL (required, with format validation)
/// 
/// The form includes:
/// - Real-time validation for website URL format
/// - Automatic URL normalization for storage
/// - Progressive disclosure for registration wizard mode
/// - Automatic data persistence to user profile
/// 
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => EditCompanyNameView(
///       registrationWizard: true, // For onboarding flow
///     ),
///   ),
/// );
/// ```
/// 
/// See also:
/// * [WebsiteValidator] for URL validation logic
/// * [UpdateCompanyRequest] for the data model
class EditCompanyNameView extends StatefulWidget {
  /// Whether this view is part of the registration wizard flow.
  /// 
  /// When true:
  /// - Shows progress indicator
  /// - Button text shows "Next" instead of "Save changes"
  /// - Navigation behavior differs after successful save
  final bool registrationWizard;

  /// Creates an [EditCompanyNameView] widget.
  /// 
  /// Set [registrationWizard] to true when using this view as part
  /// of the initial user onboarding flow.
  const EditCompanyNameView({
    super.key,
    this.registrationWizard = false,
  });

  @override
  State<EditCompanyNameView> createState() => _EditCompanyNameViewState();
}

class _EditCompanyNameViewState extends State<EditCompanyNameView> {
  // Form controllers for text input management
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();

  // Form validation state
  bool _companyNameTouched = false;
  bool _websiteTouched = false;
  bool _websiteFormatIsValid = true;

  // UI state
  bool _isUpdating = false;
  bool _initialValuesLoaded = false;

  // Service dependencies
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;

  /// Whether the form has all required fields completed and valid.
  bool get _formIsValid => 
    _companyNameController.text.isNotEmpty &&
    _websiteController.text.isNotEmpty &&
    _websiteFormatIsValid;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    // Add listeners for validation
    _companyNameController.addListener(_onCompanyNameChanged);
    _websiteController.addListener(_onWebsiteChanged);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: const Text('Company name'),
      ),
      body: Column(
        children: [
          if (widget.registrationWizard)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ProgressBar(
                pageNumber: 6,
                numberOfPages: 10,
              ),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 16),
                  
                  // Company Name
                  _buildFieldSection(
                    label: 'COMPANY NAME',
                    child: AppTextField(
                      controller: _companyNameController,
                      hintText: 'Company name',
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      style: AppTextFieldStyle.large,
                      state: _companyNameTouched && _companyNameController.text.isEmpty 
                          ? AppTextFieldState.error 
                          : AppTextFieldState.normal,
                      autofillHints: const [AutofillHints.organizationName],
                    ),
                  ),
                  
                  // Website URL
                  _buildFieldSection(
                    label: 'WEBSITE',
                    child: AppTextField(
                      controller: _websiteController,
                      hintText: 'your-company.com',
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.none,
                      style: AppTextFieldStyle.large,
                      state: !_websiteFormatIsValid ? AppTextFieldState.error : AppTextFieldState.normal,
                      autofillHints: const [AutofillHints.url],
                    ),
                  ),

                  
                ],
              ),
            ),
          ),
          // Save button at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ActionButton(
                label: _isUpdating 
                    ? 'Saving...' 
                    : (widget.registrationWizard ? 'Next' : 'Save changes'),
                isDisabled: !_formIsValid || _isUpdating,
                onPressed: _isUpdating ? null : _saveCompanyInfo,
              ),
          ),
        ],
      ),
    );
  }

  /// Builds a labeled field section with consistent styling.
  /// 
  /// Creates a consistent form field layout with:
  /// - Uppercase label text
  /// - Custom child widget (typically a PlatformTextField)
  Widget _buildFieldSection({
    required String label,
    required Widget child,
  }) {
    final venyuTheme = context.venyuTheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.subheadline.copyWith(
              color: venyuTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  /// Called when the view appears to load existing values.
  void _preloadValues() {
    if (_initialValuesLoaded) return;
    
    final profile = _sessionManager.currentProfile;
    
    _companyNameController.text = profile?.companyName?.isNotEmpty == true 
        ? profile!.companyName! 
        : '';
    
    _websiteController.text = profile?.websiteURL?.isNotEmpty == true 
        ? profile!.websiteURL! 
        : '';

    _computeWebsiteValidation();
    _initialValuesLoaded = true;
  }

  /// Called when company name field changes.
  void _onCompanyNameChanged() {
    if (!_companyNameTouched && _companyNameController.text.isNotEmpty) {
      setState(() {
        _companyNameTouched = true;
      });
    }
  }

  /// Called when website field changes.
  void _onWebsiteChanged() {
    _computeWebsiteValidation();
    if (!_websiteTouched && _websiteController.text.isNotEmpty) {
      setState(() {
        _websiteTouched = true;
      });
    }
  }

  /// Performs real-time validation on website URL field.
  /// 
  /// Validates:
  /// - Website URL format using [WebsiteValidator.isValidFormat]
  void _computeWebsiteValidation() {
    final websiteURL = _websiteController.text;
    
    setState(() {
      if (websiteURL.isEmpty) {
        _websiteFormatIsValid = true; // Empty URL is "valid" for UI purposes
      } else {
        _websiteFormatIsValid = WebsiteValidator.isValidFormat(websiteURL);
      }
    });
  }

  /// Saves the company information to the backend.
  /// 
  /// Handles:
  /// - Loading state management
  /// - URL normalization using [WebsiteValidator.normalizeForStorage]
  /// - API communication via [SupabaseManager]
  /// - Success/error user feedback
  /// - Navigation after successful save
  /// - SessionManager update with new values
  void _saveCompanyInfo() async {
    // Preload values if not already done (in case of direct navigation)
    _preloadValues();
    
    setState(() {
      _isUpdating = true;
    });

    try {
      // Normalize the website URL for storage
      final cleanedWebsiteURL = WebsiteValidator.normalizeForStorage(_websiteController.text) 
          ?? _websiteController.text;
      
      final request = UpdateCompanyRequest(
        companyName: _companyNameController.text,
        websiteURL: cleanedWebsiteURL,
      );
      
      await _supabaseManager.updateCompanyInfo(request);
      
      // Update only the changed fields in SessionManager (efficient)
      _sessionManager.updateCurrentProfileFields(
        companyName: _companyNameController.text,
        websiteURL: cleanedWebsiteURL,
      );
      
      if (widget.registrationWizard) {
        // Navigate to next step in registration wizard
        // TODO: Implement navigation to next registration step
      } else {
        // Update loading state
        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
        }
        
        // Show success message and go back
        if (mounted) {
          try {
            // Show the snackbar first
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Company info changes saved'),
                backgroundColor: context.venyuTheme.snackbarSuccess,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Then pop after a small delay to ensure snackbar is shown
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                Navigator.of(context).pop(true); // Return true to indicate changes were saved
              }
            });
          } catch (e) {
            // If showing snackbar fails, still try to pop
            debugPrint('Failed to show success snackbar: $e');
            if (mounted) {
              Navigator.of(context).pop(true); // Return true to indicate changes were saved
            }
          }
        }
      }
    } catch (error) {
      // Always update loading state first
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
      
      // Then show error if still mounted
      if (mounted) {
        // Use a post frame callback to ensure context is valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Failed to update company info, please try again'),
                backgroundColor: context.venyuTheme.snackbarError,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
      
      // Log error for debugging
      debugPrint('Error updating company info: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load values when the widget becomes active
    _preloadValues();
  }
}