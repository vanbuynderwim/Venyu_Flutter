import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/enums/interaction_type.dart';
import '../../../widgets/prompts/selection_title_with_icon.dart';

/// Custom text input formatter that prevents capitalization of the first character
/// but allows normal sentence capitalization for subsequent sentences.
class _PreventFirstLetterCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only lowercase the very first character if text is being added at the start
    if (newValue.text.isNotEmpty && oldValue.text.isEmpty) {
      final firstChar = newValue.text[0];
      if (firstChar.toUpperCase() == firstChar && firstChar.toLowerCase() != firstChar) {
        // First character is uppercase, make it lowercase
        final newText = firstChar.toLowerCase() + newValue.text.substring(1);
        return TextEditingValue(
          text: newText,
          selection: newValue.selection,
        );
      }
    }

    return newValue;
  }
}

/// PromptContentField - Main content input field for prompt detail view
///
/// This widget provides the large, centered text field where users
/// input their prompt content.
///
/// Features:
/// - Large, centered text input with custom styling
/// - Platform-aware text field styling
/// - Dynamic placeholder based on interaction type
/// - Auto-focus capability
/// - Multiline support with flexible height
class PromptContentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final InteractionType interactionType;
  final bool isEnabled;

  const PromptContentField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.interactionType,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            // Interaction type selection title with icon
            Center(
              child: SelectionTitleWithIcon(
                interactionType: interactionType,
                size: 24,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 2),

            // Content text field
            PlatformTextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              inputFormatters: [
                _PreventFirstLetterCapitalizationFormatter(),
              ],
              style: TextStyle(
                color: venyuTheme.darkText,
                fontSize: 24,
                fontFamily: AppFonts.graphie,
              ),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              enabled: isEnabled,
              cupertino: (_, _) => CupertinoTextFieldData(
                placeholder: interactionType.hintText(context),
                placeholderStyle: TextStyle(
                  color: venyuTheme.darkText.withValues(alpha: 0.5),
                  fontSize: 24,
                  fontFamily: AppFonts.graphie,
                ),
                decoration: const BoxDecoration(), // No borders
                padding: EdgeInsets.zero, // No internal padding
              ),
              material: (_, _) => MaterialTextFieldData(
                decoration: InputDecoration(
                  hintText: interactionType.hintText(context),
                  hintStyle: TextStyle(
                    color: venyuTheme.darkText.withValues(alpha: 0.5),
                    fontSize: 24,
                    fontFamily: AppFonts.graphie,
                  ),
                  border: InputBorder.none, // No borders
                  contentPadding: EdgeInsets.zero, // No internal padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}