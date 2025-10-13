import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_input_styles.dart';
import '../../services/supabase_managers/public_manager.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../base/base_form_view.dart';
import 'waitlist_finish_view.dart';

/// WaitlistView - Waitlist signup screen for users without invite codes
///
/// This view allows users to join the waitlist by providing their name, company and email.
/// Features the same visual styling as login_view with radar background and
/// Venyu branding, but focuses on waitlist registration functionality.
class WaitlistView extends BaseFormView {
  const WaitlistView({super.key}) : super(title: '');

  @override
  BaseFormViewState<BaseFormView> createState() => _WaitlistViewState();
}

class _WaitlistViewState extends BaseFormViewState<WaitlistView> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initializeForm() {
    super.initializeForm();
    _nameController.addListener(_validateForm);
    _companyController.addListener(_validateForm);
    _roleController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Validate all form fields
  void _validateForm() {
    setState(() {
      final nameValid = _nameController.text.trim().isNotEmpty;
      final companyValid = _companyController.text.trim().isNotEmpty;
      final roleValid = _roleController.text.trim().isNotEmpty;
      final emailValid = InputValidation.validateEmail(_emailController.text.trim()) == null;
      _isFormValid = nameValid && companyValid && roleValid && emailValid;
    });
  }

  /// Check if form can be saved
  @override
  bool get canSave => _isFormValid;

  /// Perform waitlist submission
  @override
  Future<void> performSave() async {
    // Get l10n before async gap
    final l10n = AppLocalizations.of(context)!;

    try {
      await PublicManager.shared.joinWaitlist(
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        role: _roleController.text.trim(),
        email: _emailController.text.trim(),
      );
    } on PostgrestException catch (e) {
      // Handle specific database errors
      String message = e.message;
      if (e.code == 'validation_error') {
        // Use the specific validation error message
        throw Exception(message);
      } else if (e.message.contains('duplicate key') || e.message.contains('already exists')) {
        throw Exception(l10n.waitlistErrorDuplicate);
      } else {
        throw Exception('${l10n.waitlistErrorFailed}: $message');
      }
    } catch (e) {
      // Handle any other errors
      throw Exception(l10n.waitlistErrorFailed);
    }
  }

  /// Get success message
  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.waitlistSuccessMessage;
  }

  /// Get error message
  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    return l10n.waitlistErrorFailed;
  }

  /// Override navigation to show finish view
  @override
  void navigateAfterSave() {
    Navigator.of(context).pushReplacement(
      platformPageRoute(
        context: context,
        builder: (context) => const WaitlistFinishView(),
      ),
    );
  }


  @override
  Widget buildFormContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description
        Center(
          child: Column(
            children: [
              Text(
                l10n.waitlistTitle,
                style: AppTextStyles.title1.copyWith(
                  color: venyuTheme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.graphie,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.waitlistDescription,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w400,
                  color: venyuTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Name field
        AppTextField(
          controller: _nameController,
          hintText: l10n.waitlistNameHint,
          style: AppTextFieldStyle.large,
          state: AppTextFieldState.normal,
          autofillHints: const [AutofillHints.name],
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 8),

        // Company field
        AppTextField(
          controller: _companyController,
          hintText: l10n.waitlistCompanyHint,
          style: AppTextFieldStyle.large,
          state: AppTextFieldState.normal,
          autofillHints: const [AutofillHints.organizationName],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 8),

        // Role field
        AppTextField(
          controller: _roleController,
          hintText: l10n.waitlistRoleHint,
          style: AppTextFieldStyle.large,
          state: AppTextFieldState.normal,
          autofillHints: const [AutofillHints.jobTitle],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 8),

        // Email field
        AppTextField(
          controller: _emailController,
          hintText: l10n.waitlistEmailHint,
          style: AppTextFieldStyle.large,
          state: AppTextFieldState.normal,
          autofillHints: const [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
        ),
      ],
    );
  }

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: ActionButton(
          label: label ?? l10n.waitlistButton,
          onPressed: !canSave ? null : (onPressed ?? handleSave),
          isLoading: isProcessing,
        ),
      ),
    );
  }
}