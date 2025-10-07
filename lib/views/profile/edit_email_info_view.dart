import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_input_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../services/profile_service.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/app_text_field.dart';
import '../base/base_form_view.dart';

/// A form screen for editing user email address with OTP verification.
/// 
/// This view handles a two-step process:
/// 1. Enter and validate email address, send OTP
/// 2. Enter OTP code and newsletter subscription preference, verify and save
/// 
/// Equivalent to iOS EditEmailInfoView with complete functionality migration.
class EditEmailInfoView extends BaseFormView {
  const EditEmailInfoView({
    super.key,
    super.registrationWizard = false,
    super.currentStep,
  }) : super(title: 'Email address');

  @override
  BaseFormViewState<BaseFormView> createState() => _EditEmailInfoViewState();
}

class _EditEmailInfoViewState extends BaseFormViewState<EditEmailInfoView> {
  // Form controllers
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  
  // Form state
  bool _showOTPField = false;
  bool _isEmailValid = false;
  bool _emailFieldDisabled = false;
  bool _isSubscribedToNewsletter = true;
  String _buttonLabel = 'Send verification code';
  bool _isSendingOTP = false;
  bool _isVerifyingOTP = false;

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
    final currentEmail = ProfileService.shared.currentProfile?.contactEmail;
    if (currentEmail != null && currentEmail.isNotEmpty) {
      _emailController.text = currentEmail;
      _isEmailValid = true;
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
    return 'EMAIL ADDRESS';
    
  }

  /// Get helper text for email field
  String get _emailHelperText {
    if (_showOTPField) {
      return '';
    }
    return "This email address will be used for all app notifications, including new matches, introductions and other information.";
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
    if (!_showOTPField) {
      return 'A verification code has been sent to ${_emailController.text.trim()}';
    }
    return 'Contact email address updated';
  }

  /// Get error message
  @override
  String getErrorMessage() {
    if (!_showOTPField) {
      return 'Failed to send confirmation code, please try again';
    }
    return 'Failed to verify code, please try again';
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
        label: _buttonLabel,
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
        
        // Show success toast BEFORE updating state
        ToastService.success(
          context: context,
          message: 'A verification code has been sent to ${_emailController.text.trim()}',
        );
        
        setState(() {
          _isSendingOTP = false;
          _emailFieldDisabled = true;
          _buttonLabel = 'Verify code';
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
    await profileManager.verifyEmailOTP(
      _emailController.text.trim(),
      _otpController.text.trim(),
      _isSubscribedToNewsletter,
    );
    
    // Update local profile
    ProfileService.shared.updateCurrentProfileFields(
      contactEmail: _emailController.text.trim(),
    );
  }

  @override
  Widget buildFormContent(BuildContext context) {
    AppLogger.ui('Building form content - _showOTPField: $_showOTPField, _isSendingOTP: $_isSendingOTP', context: 'EditEmailInfoView');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Registration wizard progress bar
        if (widget.registrationWizard) ...[
          ProgressBar(
            pageNumber: 2,
            numberOfPages: 11,
          ),
          const SizedBox(height: 16),
        ],

        // Email input section
        buildFieldSection(
          title: _formTitle,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _emailController,
                hintText: 'A valid email address',
                style: AppTextFieldStyle.large,
                state: _isEmailValid ? AppTextFieldState.normal : AppTextFieldState.normal,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofocus: true,
                textCapitalization: TextCapitalization.none,
                enabled: !_emailFieldDisabled,
              ),
              if (_emailHelperText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _emailHelperText,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.venyuTheme.secondaryText,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Newsletter subscription toggle (shown when OTP field is visible)
        if (_showOTPField) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'SUBSCRIBE FOR VENYU UPDATES',
                    style: AppTextStyles.caption1.copyWith(
                      letterSpacing: 0.5,
                      color: context.venyuTheme.secondaryText,
                    ),
                  ),
                ),
                PlatformSwitch(
                  value: _isSubscribedToNewsletter,
                  onChanged: (value) {
                    setState(() {
                      _isSubscribedToNewsletter = value;
                    });
                  },
                  material: (_, __) => MaterialSwitchData(
                    activeColor: AppColors.primair4Lilac,
                    // For Material Design, the thumb color is automatically handled
                  ),
                  cupertino: (_, __) => CupertinoSwitchData(
                    activeColor: AppColors.primair4Lilac,
                    // For iOS, we can set thumbColor for better contrast in dark mode
                    thumbColor: Theme.of(context).brightness == Brightness.dark 
                        ? context.venyuTheme.adaptiveBackground  // Dark thumb on light track
                        : null,  // Default white thumb
                  ),
                ),
              ],
            ),
          ),
        ],

        // OTP input section (shown after sending OTP)
        if (_showOTPField)
          buildFieldSection(
            title: 'Enter verification code',
            content: AppTextField(
              controller: _otpController,
              hintText: 'Enter 6-digit code',
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
      ],
    );
  }
}