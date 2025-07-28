import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/requests/update_name_request.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../utils/linked_in_validator.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// A form screen for editing user name and LinkedIn profile information.
/// 
/// This widget provides a comprehensive form for updating:
/// - First name (required)
/// - Last name (required)
/// - LinkedIn URL (optional, with format validation)
/// 
/// The form includes:
/// - Real-time validation for all fields
/// - LinkedIn URL format checking and name matching
/// - Progressive disclosure for registration wizard mode
/// - Automatic data persistence to user profile
/// 
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => EditNameView(
///       registrationWizard: true, // For onboarding flow
///     ),
///   ),
/// );
/// ```
/// 
/// See also:
/// * [LinkedInValidator] for URL validation logic
/// * [UpdateNameRequest] for the data model
class EditNameView extends StatefulWidget {
  /// Whether this view is part of the registration wizard flow.
  /// 
  /// When true:
  /// - Shows progress indicator
  /// - Button text shows "Next" instead of "Save changes"
  /// - Navigation behavior differs after successful save
  final bool registrationWizard;

  /// Creates an [EditNameView] widget.
  /// 
  /// Set [registrationWizard] to true when using this view as part
  /// of the initial user onboarding flow.
  const EditNameView({
    super.key,
    this.registrationWizard = false,
  });

  @override
  State<EditNameView> createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView> {
  // Form controllers for text input management
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _linkedInController = TextEditingController();

  // Form validation state
  bool _firstNameIsEmpty = false;
  bool _lastNameIsEmpty = false;
  bool _linkedInFormatIsValid = true;
  bool _linkedInNameMatches = true;

  // UI state
  bool _isUpdating = false;

  // Service dependencies
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;

  /// Whether the form has all required fields completed.
  bool get _formIncomplete => _firstNameController.text.isEmpty || _lastNameController.text.isEmpty;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    _preloadValues();
    
    // Add listeners for validation
    _firstNameController.addListener(_computeValidation);
    _lastNameController.addListener(_computeValidation);
    _linkedInController.addListener(_computeValidation);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: const Text('You'),
      ),
      body: Column(
        children: [
          if (widget.registrationWizard)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ProgressBar(
                pageNumber: 1,
                numberOfPages: 10,
              ),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // First Name
                  _buildFieldSection(
                    label: 'FIRST NAME',
                    controller: _firstNameController,
                    placeholder: 'First name',
                    textInputAction: TextInputAction.next,
                    isEmpty: _firstNameIsEmpty,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Last Name
                  _buildFieldSection(
                    label: 'LAST NAME',
                    controller: _lastNameController,
                    placeholder: 'Last name',
                    textInputAction: TextInputAction.next,
                    isEmpty: _lastNameIsEmpty,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // LinkedIn URL
                  _buildFieldSection(
                    label: 'LINKEDIN URL',
                    controller: _linkedInController,
                    placeholder: 'linkedin.com/in/your-name',
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                    isValid: _linkedInFormatIsValid,
                  ),
                  
                  const SizedBox(height: 100), // Space for save button
                ],
              ),
            ),
          ),
          // Save button at bottom
          Container(
            padding: const EdgeInsets.all(16),
            child: ActionButton(
              label: _isUpdating 
                  ? 'Saving...' 
                  : (widget.registrationWizard ? 'Next' : 'Save changes'),
              isDisabled: _formIncomplete || !_linkedInFormatIsValid || _isUpdating,
              onPressed: _isUpdating ? null : _validateAndMaybeSave,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a labeled text input field with validation styling.
  /// 
  /// Creates a consistent form field layout with:
  /// - Uppercase label text
  /// - Themed input styling
  /// - Error state visual feedback
  /// - Platform-specific input behavior
  Widget _buildFieldSection({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    TextCapitalization textCapitalization = TextCapitalization.words,
    bool isEmpty = false,
    bool isValid = true,
  }) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subheadline.copyWith(
            color: venyuTheme.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        PlatformTextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          enabled: !isEmpty,
          style: AppTextStyles.body.copyWith(
            color: isEmpty ? venyuTheme.primaryText : venyuTheme.primaryText,
          ),
          hintText: placeholder,
          material: (_, __) => MaterialTextFormFieldData(
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.body.copyWith(
                color: venyuTheme.secondaryText,
              ),
              filled: true,
              fillColor: venyuTheme.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                borderSide: BorderSide(
                  color: controller.text.isEmpty ? venyuTheme.borderColor : venyuTheme.borderColor,
                  width: controller.text.isEmpty ? 1 : 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                borderSide: BorderSide(
                  color: isValid ? venyuTheme.borderColor : Colors.red,
                  width: isValid ? 0.5 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                borderSide: BorderSide(
                  color: isValid ? venyuTheme.borderColor : Colors.red,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          cupertino: (_, __) => CupertinoTextFormFieldData(
            placeholder: placeholder,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: venyuTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              border: Border.all(
                color: isValid ? venyuTheme.borderColor : Colors.red,
                width: isValid ? 0.5 : 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Loads existing profile data into the form fields.
  /// 
  /// Populates the form with current user profile information
  /// and initializes validation state.
  void _preloadValues() {
    final profile = _sessionManager.currentProfile;
    
    _firstNameController.text = profile?.firstName.isNotEmpty == true 
        ? profile!.firstName 
        : ''; // Could load from keychain like iOS version
    
    _lastNameController.text = profile?.lastName?.isNotEmpty == true 
        ? profile!.lastName! 
        : '';
    
    _linkedInController.text = profile?.linkedInURL ?? '';

    _firstNameIsEmpty = _firstNameController.text.isEmpty;
    _lastNameIsEmpty = _lastNameController.text.isEmpty;
    
    _computeValidation();
  }

  /// Performs real-time validation on form fields.
  /// 
  /// Validates:
  /// - LinkedIn URL format using [LinkedInValidator.isValidFormat]
  /// - LinkedIn URL name matching using [LinkedInValidator.nameMatches]
  void _computeValidation() {
    final linkedInURL = _linkedInController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    
    setState(() {
      _linkedInFormatIsValid = linkedInURL.isEmpty || LinkedInValidator.isValidFormat(linkedInURL);
      _linkedInNameMatches = linkedInURL.isEmpty || LinkedInValidator.nameMatches(linkedInURL, firstName, lastName);
    });
  }

  /// Validates the complete form and initiates save if valid.
  /// 
  /// Shows a confirmation dialog if LinkedIn name validation fails
  /// but allows the user to proceed anyway.
  void _validateAndMaybeSave() {
    _computeValidation();
    
    if (!_linkedInFormatIsValid) {
      return;
    }
    
    if (!_linkedInNameMatches) {
      _showNameMismatchDialog();
      return;
    }
    
    _saveProfile();
  }

  /// Shows a dialog when LinkedIn URL doesn't match the entered name.
  /// 
  /// Provides options to:
  /// - Review and correct the LinkedIn URL
  /// - Continue with the current URL anyway
  void _showNameMismatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("We couldn't find your name in your LinkedIn URL"),
        content: const Text("Your LinkedIn URL doesn't seem to contain your first and last name. You can continue or double-check your URL."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Check URL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveProfile(withValidLinkedInURL: false);
            },
            child: const Text('Continue anyway'),
          ),
        ],
      ),
    );
  }

  /// Saves the profile data to the backend.
  /// 
  /// [withValidLinkedInURL] indicates whether the LinkedIn URL
  /// passed validation. This information is stored for future reference.
  /// 
  /// Handles:
  /// - Loading state management
  /// - API communication via [SupabaseManager]
  /// - Success/error user feedback
  /// - Navigation after successful save
  void _saveProfile({bool withValidLinkedInURL = true}) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      // Normalize the LinkedIn URL for storage
      final cleanedLinkedInURL = LinkedInValidator.normalizeForStorage(_linkedInController.text) 
          ?? _linkedInController.text;
      
      final request = UpdateNameRequest(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        linkedInURL: cleanedLinkedInURL,
        linkedInURLValid: withValidLinkedInURL,
      );
      
      await _supabaseManager.updateProfileName(request);
      
      if (widget.registrationWizard) {
        // Navigate to next step in registration wizard
        // TODO: Implement navigation to next registration step
      } else {
        // Show success message and go back
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Changes successfully saved'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update, please try again'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }
}