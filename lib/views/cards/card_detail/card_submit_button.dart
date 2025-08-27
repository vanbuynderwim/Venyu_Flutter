import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/venyu_theme.dart';

/// CardSubmitButton - Submit button for card detail view
/// 
/// This widget displays the submit button in the app bar with proper
/// styling, loading states, and disabled states.
/// 
/// Features:
/// - Loading state with spinner animation
/// - Disabled state with reduced opacity
/// - Platform-aware styling (iOS/Android)
/// - Theme-aware colors
/// - Proper accessibility states
class CardSubmitButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  const CardSubmitButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5, // Lower opacity when disabled
      child: Container(
        decoration: BoxDecoration(
          color: venyuTheme.primary, // Always use primary color
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        ),
        child: PlatformTextButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading 
            ? SizedBox(
                width: 20,
                height: 20,
                child: PlatformCircularProgressIndicator(
                  cupertino: (_, __) => CupertinoProgressIndicatorData(
                    color: venyuTheme.cardBackground, // ActionButton text color
                  ),
                  material: (_, __) => MaterialProgressIndicatorData(
                    color: venyuTheme.cardBackground, // ActionButton text color
                    strokeWidth: AppModifiers.extraThinBorder * 4,
                  ),
                ),
              )
            : Text(
                'Submit',
                style: TextStyle(
                  color: venyuTheme.cardBackground, // ActionButton text color
                  fontSize: 16,
                ),
              ),
          cupertino: (_, __) => CupertinoTextButtonData(
            padding: AppModifiers.buttonPaddingSmall,
          ),
          material: (_, __) => MaterialTextButtonData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent, // Container handles background
              foregroundColor: venyuTheme.cardBackground, // ActionButton text color
              padding: AppModifiers.buttonPaddingSmall,
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}