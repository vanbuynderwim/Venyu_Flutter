import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/enums/interaction_type.dart';
import '../../../widgets/common/character_counter_overlay.dart';

/// PromptContentField - Main content input field for prompt detail view
///
/// This widget provides the large, centered text field where users
/// input their prompt content, with character counting and validation.
///
/// Features:
/// - Large, centered text input with custom styling
/// - Character counter overlay
/// - Platform-aware text field styling
/// - Dynamic placeholder based on interaction type
/// - Auto-focus capability
/// - Multiline support with flexible height
class PromptContentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final InteractionType interactionType;
  final bool isEnabled;
  final int maxLength;

  const PromptContentField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.interactionType,
    required this.isEnabled,
    required this.maxLength,
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
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                color: venyuTheme.darkText,
                fontSize: 36,
                fontFamily: AppFonts.graphie,
              ),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
              enabled: isEnabled,
              cupertino: (_, __) => CupertinoTextFieldData(
                placeholder: interactionType.hintText,
                placeholderStyle: TextStyle(
                  color: venyuTheme.darkText.withValues(alpha: 0.5),
                  fontSize: 36,
                  fontFamily: AppFonts.graphie,
                ),
                decoration: const BoxDecoration(), // No borders
                padding: EdgeInsets.zero, // No internal padding
              ),
              material: (_, __) => MaterialTextFieldData(
                decoration: InputDecoration(
                  hintText: interactionType.hintText,
                  hintStyle: TextStyle(
                    color: venyuTheme.darkText.withValues(alpha: 0.5),
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