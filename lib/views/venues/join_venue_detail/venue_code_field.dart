import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../widgets/common/character_counter_overlay.dart';

/// VenueCodeField - Main code input field for join venue view
/// 
/// This widget provides the large, centered text field where users
/// input their venue invite code, with character counting and validation.
/// 
/// Features:
/// - Large, centered text input with custom styling
/// - Character counter overlay
/// - Platform-aware text field styling
/// - 8-character limit with uppercase formatting
/// - Auto-focus capability
/// - Single line input
class VenueCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEnabled;
  final int maxLength;
  final VoidCallback? onSubmit;

  const VenueCodeField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEnabled,
    required this.maxLength,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PlatformTextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: 1,
              keyboardType: TextInputType.text,
              inputFormatters: [
                // Only allow alphanumeric characters (letters and numbers)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                // Convert to uppercase
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              style: TextStyle(
                color: venyuTheme.primaryText,
                fontSize: 36,
                fontFamily: AppFonts.graphie // Add letter spacing for better readability
              ),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters, // Force uppercase
              enabled: isEnabled,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                // Only submit if we have 8 characters, otherwise keep focus
                if (onSubmit != null && controller.text.length == maxLength) {
                  onSubmit!();
                } else {
                  // Keep the keyboard open by re-requesting focus
                  focusNode.requestFocus();
                }
              },
              cupertino: (_, __) => CupertinoTextFieldData(
                placeholder: 'Enter invite code',
                placeholderStyle: TextStyle(
                  color: venyuTheme.disabledText,
                  fontSize: 36,
                  fontFamily: AppFonts.graphie,
                ),
                decoration: const BoxDecoration(), // No borders
                padding: EdgeInsets.zero, // No internal padding
              ),
              material: (_, __) => MaterialTextFieldData(
                decoration: InputDecoration(
                  hintText: 'Enter invite code',
                  hintStyle: TextStyle(
                    color: venyuTheme.disabledText,
                    fontSize: 36,
                    fontFamily: AppFonts.graphie,

                  ),
                  border: InputBorder.none, // No borders
                  contentPadding: EdgeInsets.zero, // No internal padding
                ),
              ),
            ),
            
            // Character counter overlay
            CharacterCounterOverlay(
              currentLength: controller.text.length,
              maxLength: maxLength,
            ),
          ],
        ),
      ),
    );
  }
}