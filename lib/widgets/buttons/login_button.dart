import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../models/enums/login_button_type.dart';
import '../../core/theme/venyu_theme.dart';

/// A specialized button widget for authentication/login purposes.
/// 
/// This widget provides consistent login button interface with provider-specific
/// styling (LinkedIn, Apple, Google) while maintaining brand requirements.
/// The button automatically uses the correct label and icon based on the type.
/// 
/// Example usage:
/// ```dart
/// LoginButton(
///   type: LoginButtonType.google,
///   onPressed: () => signInWithGoogle(),
/// )
/// ```
/// 
/// See also:
/// * [LoginButtonType] for available login providers
/// * [ActionButton] for general-purpose buttons
class LoginButton extends StatefulWidget {
  /// Called when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;
  
  /// The login provider type (LinkedIn, Apple, Google).
  /// This determines the label and icon automatically.
  final LoginButtonType type;
  
  /// Whether the button should appear disabled. Defaults to false.
  final bool isDisabled;
  
  /// Whether the button is in a loading state.
  /// When true, shows a progress indicator and disables the button.
  final bool isLoading;

  /// Whether this was the last used login method.
  /// When true, shows a small indicator dot.
  final bool isLastUsed;

  /// Creates a [LoginButton] widget.
  ///
  /// The button automatically uses the correct label and icon based on [type].
  const LoginButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.isLastUsed = false,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  void initState() {
    super.initState();
    // Debug logging
    if (widget.isLastUsed) {
      print('🔵 LoginButton: ${widget.type.label} - isLastUsed = true');
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final isActuallyDisabled = widget.isDisabled || widget.onPressed == null || widget.isLoading;
    final textColor = widget.type.textColor(context);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AppLayoutStyles.interactiveButton(
        context: context,
        onTap: isActuallyDisabled ? null : widget.onPressed,
        backgroundColor: Colors.white, // Always white for login buttons
        borderColor: venyuTheme.borderColor,
        highlightColor: Colors.grey,
        opacity: isActuallyDisabled ? 0.7 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: PlatformCircularProgressIndicator(
                      cupertino: (_, _) => CupertinoProgressIndicatorData(
                        color: textColor,
                      ),
                      material: (_, _) => MaterialProgressIndicatorData(
                        color: textColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    // Main content - centered
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Login buttons always preserve original logo colors
                          widget.type.icon,
                          const SizedBox(width: 8),
                          Text(
                            widget.type.label,
                            style: AppTextStyles.subheadline.copyWith(
                              color: textColor,
                              fontWeight: widget.type.fontWeight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Last used indicator - positioned on the right
                    if (widget.isLastUsed)
                      Positioned(
                        right: 6,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}