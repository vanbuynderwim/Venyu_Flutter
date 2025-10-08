import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// FormInfoBox - Reusable info box with icon, title and content for forms
///
/// Displays contextual information in a styled container with an icon, title and description text.
/// Used to provide context and guidance to users in form fields.
class FormInfoBox extends StatelessWidget {
  
  final String content;

  const FormInfoBox({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: venyuTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: AppTextStyles.subheadline2.copyWith(
              color: venyuTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
