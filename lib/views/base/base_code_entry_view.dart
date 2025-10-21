import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../mixins/error_handling_mixin.dart';
import '../../widgets/buttons/action_button.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/utils/app_logger.dart';
import '../../services/toast_service.dart';
import '../../models/enums/toast_type.dart';
import '../../widgets/common/radar_background.dart';

/// Base code entry view for shared code input functionality.
///
/// This abstract base class provides common functionality for views that
/// require users to enter an 8-character code (venue codes, invite codes, etc).
///
/// Features:
/// - Radar background
/// - Customizable title and subtitle
/// - 8-character code input with validation
/// - FilteringTextInputFormatter for alphanumeric uppercase
/// - Error handling with ToastService
/// - Loading states
abstract class BaseCodeEntryView extends StatefulWidget {
  /// Title displayed at the top
  final String title;

  /// Subtitle/description displayed below title
  final String subtitle;

  /// Label for the action button
  final String buttonLabel;

  /// Placeholder text for the code input field
  final String placeholder;

  /// Whether to show a close button in the top right
  final bool showCloseButton;

  const BaseCodeEntryView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.placeholder,
    this.showCloseButton = false,
  });
}

abstract class BaseCodeEntryViewState<T extends BaseCodeEntryView> extends State<T> with ErrorHandlingMixin {
  // Controllers
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  // State
  bool _codeIsValid = false;

  // Constants
  static const int _maxLength = 8;

  @override
  void initState() {
    super.initState();

    // Add listener for validation and character limiting
    _codeController.addListener(() {
      _limitText();
      setState(() {
        _codeIsValid = _codeController.text.trim().length == _maxLength;
      });
    });

    // Auto-focus the content field to open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  /// Enforces character limit and uppercase conversion on code.
  void _limitText() {
    try {
      final text = _codeController.text;
      if (text.length > _maxLength) {
        final truncated = text.substring(0, _maxLength);

        // Check if the controller is still mounted and valid
        if (!mounted || _codeController.value.text != text) {
          return;
        }

        // Safely update the controller value
        final newOffset = truncated.length.clamp(0, truncated.length);

        _codeController.value = TextEditingValue(
          text: truncated,
          selection: TextSelection.collapsed(offset: newOffset),
        );
      }
    } catch (e) {
      // Log the error but don't crash the app
      AppLogger.warning('Error in _limitText: $e', context: runtimeType.toString());
    }
  }

  /// Handle code submission - must be implemented by subclasses
  Future<void> handleCodeSubmission(String code);

  /// Handle successful code submission - must be implemented by subclasses
  void handleSuccess();

  /// Get the context name for logging - must be implemented by subclasses
  String get logContext;

  Future<void> _handleSubmit() async {
    if (!_codeIsValid || isProcessing) return;

    final code = _codeController.text.trim();

    try {
      setProcessingState(true);

      AppLogger.info('Attempting to submit code', context: logContext);

      // Call the specific implementation
      await handleCodeSubmission(code);

      AppLogger.success('Successfully submitted code', context: logContext);

      if (mounted) {
        handleSuccess();
      }
    } catch (error) {
      AppLogger.error('Failed to submit code', error: error, context: logContext);

      if (mounted) {
        // Show error message to user using ToastService
        final errorMessage = error.toString().replaceAll('Exception: ', '');
        ToastService.show(
          context: context,
          message: errorMessage,
          type: ToastType.error,
        );

        // Keep keyboard open and focus on the code field
        _codeFocusNode.requestFocus();
      }
    } finally {
      if (mounted) {
        setProcessingState(false);
      }
    }
  }

  /// Build the platform-aware text field
  Widget _buildCodeField(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    if (isCupertino(context)) {
      // iOS/macOS Cupertino style
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
          border: Border.all(
            color: venyuTheme.borderColor,
            width: AppModifiers.thinBorder,
          ),
        ),
        child: CupertinoTextField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          placeholder: widget.placeholder,
          placeholderStyle: AppTextStyles.body.copyWith(
            color: venyuTheme.secondaryText,
          ),
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.primaryText,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: const BoxDecoration(), // No decoration, handled by container
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          maxLength: _maxLength,
          enabled: !isProcessing,
          inputFormatters: [
            // Only allow specific characters used in invite codes
            // Excludes confusing characters like 0, O, 1, I, L
            FilteringTextInputFormatter.allow(RegExp(r'[ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789]')),
            // Convert to uppercase
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(text: newValue.text.toUpperCase());
            }),
          ],
          onSubmitted: _codeIsValid ? (_) => _handleSubmit() : null,
        ),
      );
    } else {
      // Android Material style
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: venyuTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
          border: Border.all(
            color: venyuTheme.borderColor,
            width: AppModifiers.thinBorder,
          ),
        ),
        child: TextField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: AppTextStyles.body.copyWith(
              color: venyuTheme.secondaryText,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            counterText: '', // Hide character counter
          ),
          style: AppTextStyles.body.copyWith(
            color: venyuTheme.primaryText,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          maxLength: _maxLength,
          enabled: !isProcessing,
          inputFormatters: [
            // Only allow specific characters used in invite codes
            // Excludes confusing characters like 0, O, 1, I, L
            FilteringTextInputFormatter.allow(RegExp(r'[ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789]')),
            // Convert to uppercase
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(text: newValue.text.toUpperCase());
            }),
          ],
          onSubmitted: _codeIsValid ? (_) => _handleSubmit() : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Check if keyboard is open and add extra bottom padding if so
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return PlatformScaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),

          // Content overlay
          SafeArea(
            bottom: true, // Respect bottom safe area
            child: Column(
              children: [
                // Close button (optional)
                if (widget.showCloseButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 24),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: venyuTheme.cardBackground.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: venyuTheme.borderColor,
                              width: AppModifiers.extraThinBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: venyuTheme.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Main content area (scrollable)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const Spacer(),

                                // Title and description
                                Column(
                                  children: [
                                    Text(
                                      widget.title,
                                      style: AppTextStyles.title1.copyWith(
                                        color: venyuTheme.primaryText,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.graphie,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      widget.subtitle,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: venyuTheme.secondaryText,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // Platform-aware code input field
                                _buildCodeField(context),

                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Action button (fixed at bottom, above keyboard)
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: isKeyboardOpen ? 16 : 24, // Extra padding when keyboard is closed
                  ),
                  child: ActionButton(
                    label: widget.buttonLabel,
                    isDisabled: !_codeIsValid,
                    isLoading: isProcessing,
                    onPressed: _handleSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}