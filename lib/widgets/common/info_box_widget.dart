import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// Reusable info box widget for displaying informational messages
///
/// This widget creates a styled container with an info icon and text.
/// It uses AppLayoutStyles.cardDecoration for consistent card styling.
class InfoBoxWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? iconColor;

  const InfoBoxWidget({
    super.key,
    required this.text,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Row(
        children: [
          context.themedIcon(
            'info',
            size: 24,
            overrideColor: iconColor ?? venyuTheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.footnote.copyWith(
                color: textColor ?? venyuTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}