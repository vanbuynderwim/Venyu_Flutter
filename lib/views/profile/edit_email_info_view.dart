import 'package:flutter/material.dart';

import '../../core/theme/app_input_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../services/profile_service.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/form_info_box.dart';
import '../../widgets/common/info_box_widget.dart';
import '../base/base_form_view.dart';

/// A form screen for editing user email address with OTP verification.
///
/// This view handles a two-step process:
/// 1. Enter and validate email address, send OTP
/// 2. Enter OTP code to verify and save
class EditEmailInfoView extends BaseFormView {
  const EditEmailInfoView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  });

  @override
  BaseFormViewState<BaseFormView> createState() => _EditEmailInfoViewState();
}

class _EditEmailInfoViewState extends BaseFormViewState<EditEmailInfoView> {
  @override
  String getFormTitle() => AppLocalizations.of(context)!.editEmailTitle;

  // Form controllers
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  
  // Form state
  bool _showOTPField = false;
  bool _isEmailValid = false;
  bool _emailFieldDisabled = false;
  String? _buttonLabel;
  bool _isSendingOTP = false;
  bool _isVerifyingOTP = false;

  String get buttonLabel {
    if (_buttonLabel != null) return _buttonLabel!;
    final l10n = AppLocalizations.of(context)!;
    return l10n.editEmailSendCodeButton;
  }

  @override
  void initializeForm() {
    super.initializeForm();
    _preloadEmail();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Preload current email if exists
  void _preloadEmail() {
    final profile = ProfileService.shared.currentProfile;

    // Only preload email outside registration wizard
    // During registration, start with empty field to avoid Apple private relay addresses
    if (!widget.registrationWizard) {
      final currentEmail = profile?.contactEmail;
      if (currentEmail != null && currentEmail.isNotEmpty) {
        _emailController.text = currentEmail;
        _isEmailValid = true;
      }
    }
  }

  /// Validate email format
  void _validateEmail() {
    setState(() {
      _isEmailValid = InputValidation.validateEmail(_emailController.text.trim()) == null;
    });
  }

  /// Get appropriate form title based on current state
  String get _formTitle {
    final l10n = AppLocalizations.of(context)!;
    return l10n.editEmailAddressLabel;
  }

  /// Check if we should show the email helper info box
  bool get _showEmailHelperBox {
    return !_showOTPField;
  }

  /// Check if form can be saved
  @override
  bool get canSave {
    if (!_showOTPField) {
      return _isEmailValid;
    }
    return _isEmailValid && _otpController.text.length == 6;
  }

  /// Get success message
  @override
  String getSuccessMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (!_showOTPField) {
      return l10n.editEmailCodeSentMessage(_emailController.text.trim());
    }
    return l10n.editEmailSuccessMessage;
  }

  /// Get error message
  @override
  String getErrorMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (!_showOTPField) {
      return l10n.editEmailSendCodeErrorMessage;
    }
    return l10n.editEmailVerifyCodeErrorMessage;
  }

  /// Override navigation to avoid snackbar issues during OTP step
  @override
  void navigateAfterSave() {
    if (_showOTPField) {
      // This is the final step - use parent navigation
      super.navigateAfterSave();
    } else {
      // This is after OTP send - don't navigate yet
      AppLogger.debug('OTP sent, waiting for verification', context: 'EditEmailInfoView');
    }
  }

  /// Override save button behavior
  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    // Check if keyboard is open and add extra bottom padding if so
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: isKeyboardOpen ? 16 : 0, // Extra padding when keyboard is open
      ),
      child: ActionButton(
        label: buttonLabel,
        onPressed: !canSave ? null : _handleCustomSave,
        isLoading: _isSendingOTP || _isVerifyingOTP,
      ),
    );
  }

  /// Custom save handler for two-step process
  Future<void> _handleCustomSave() async {
    if (isUpdating || _isSendingOTP) return;

    if (!_showOTPField) {
      // Step 1: Send OTP
      await _sendOTP();
    } else {
      // Step 2: Verify OTP and save - use custom handler to avoid BaseFormView snackbar issues
      await _handleOTPVerification();
    }
  }

  /// Handle OTP verification without BaseFormView snackbar issues
  Future<void> _handleOTPVerification() async {
    if (!canSave) return;

    setState(() {
      _isVerifyingOTP = true;
    });

    try {
      await performSave();
      
      if (mounted) {
        setState(() {
          _isVerifyingOTP = false;
        });
        
        // Show success toast and navigate
        //ToastService.success(
        //  context: context,
        //  message: getSuccessMessage(),
        //);
        navigateAfterSave();
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isVerifyingOTP = false;
        });
        
        // Show error toast
        ToastService.error(
          context: context,
          message: getErrorMessage(),
        );
        AppLogger.error('Error verifying OTP: $error', context: 'EditEmailInfoView');
      }
    }
  }

  /// Send OTP to email
  Future<void> _sendOTP() async {
    if (_isSendingOTP || isUpdating) return;
    
    AppLogger.debug('Starting OTP send process...', context: 'EditEmailInfoView');
    
    setState(() {
      _isSendingOTP = true;
    });

    try {
      AppLogger.info('Calling profileManager.sendContactEmailOTP...', context: 'EditEmailInfoView');
      await profileManager.sendContactEmailOTP(_emailController.text.trim());
      AppLogger.success('OTP API call successful', context: 'EditEmailInfoView');
      
      if (mounted) {
        AppLogger.ui('Updating UI state after successful OTP send...', context: 'EditEmailInfoView');

        final l10n = AppLocalizations.of(context)!;
        // Show success toast BEFORE updating state
        ToastService.success(
          context: context,
          message: l10n.editEmailCodeSentMessage(_emailController.text.trim()),
        );

        setState(() {
          _isSendingOTP = false;
          _emailFieldDisabled = true;
          _buttonLabel = l10n.editEmailVerifyCodeButton;
          _showOTPField = true;
        });
        
        AppLogger.success('UI state updated - OTP field should now be visible and focused', context: 'EditEmailInfoView');
      } else {
        AppLogger.warning('Widget not mounted after OTP send', context: 'EditEmailInfoView');
      }
    } catch (error, stackTrace) {
      AppLogger.error('Error in _sendOTP: $error', context: 'EditEmailInfoView');
      AppLogger.error('Stack trace: $stackTrace', context: 'EditEmailInfoView');
      
      if (mounted) {
        setState(() {
          _isSendingOTP = false;
        });
        
        // Show error toast
        ToastService.error(
          context: context,
          message: getErrorMessage(),
        );
      } else {
        AppLogger.warning('Widget not mounted during error handling', context: 'EditEmailInfoView');
      }
    }
  }

  /// Perform OTP verification and save
  @override
  Future<void> performSave() async {
    // Always send false for newsletter subscription (not shown in UI)
    await profileManager.verifyEmailOTP(
      _emailController.text.trim(),
      _otpController.text.trim(),
      false,
    );

    // Update local profile
    ProfileService.shared.updateCurrentProfileFields(
      contactEmail: _emailController.text.trim(),
    );
  }

  @override
  bool get useScrollView => true; // Enable scroll view for info box content

  @override
  Widget buildFormContent(BuildContext context) {
    AppLogger.ui('Building form content - _showOTPField: $_showOTPField, _isSendingOTP: $_isSendingOTP', context: 'EditEmailInfoView');

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 2,
            numberOfPages: 13,
          ),
          const SizedBox(height: 16),
        ],

        // Email input section
        buildFieldSection(
          title: _formTitle,
          content: AppTextField(
            controller: _emailController,
            hintText: l10n.editEmailAddressHint,
            style: AppTextFieldStyle.large,
            state: _isEmailValid ? AppTextFieldState.normal : AppTextFieldState.normal,
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofocus: true,
            textCapitalization: TextCapitalization.none,
            enabled: !_emailFieldDisabled,
          ),
        ),

        // Email info box (shown before OTP)
        if (_showEmailHelperBox) ...[
          FormInfoBox(
            content: l10n.editEmailInfoMessage,
          ),
        ],

        // OTP input section (shown after sending OTP)
        if (_showOTPField) ...[
          buildFieldSection(
            title: l10n.editEmailVerificationCodeLabel,
            content: AppTextField(
              controller: _otpController,
              hintText: l10n.editEmailVerificationCodeHint,
              style: AppTextFieldStyle.large,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofocus: true,
              onChanged: (value) {
                // Only allow numeric values and max 6 characters
                final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (numericValue.length <= 6) {
                  if (numericValue != value) {
                    _otpController.value = _otpController.value.copyWith(
                      text: numericValue,
                      selection: TextSelection.collapsed(offset: numericValue.length),
                    );
                  }
                  // Force rebuild to update button state
                  setState(() {});
                } else {
                  // Prevent input longer than 6 characters
                  _otpController.value = _otpController.value.copyWith(
                    text: numericValue.substring(0, 6),
                    selection: const TextSelection.collapsed(offset: 6),
                  );
                }
              },
            ),
          ),
          
          // OTP info box
          InfoBoxWidget(
            text: l10n.editEmailOtpInfoMessage,
            iconName: 'bulb',
          ),
        ],
      ],
    );
  }
}