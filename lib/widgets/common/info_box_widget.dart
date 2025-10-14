import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// Reusable info box widget for displaying informational messages
///
/// This widget creates a styled container with an icon and text.
/// It uses AppLayoutStyles.cardDecoration for consistent card styling.
class InfoBoxWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? iconColor;
  final String iconName;

  const InfoBoxWidget({
    super.key,
    required this.text,
    this.textColor,
    this.iconColor,
    this.iconName = 'info',
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.themedIcon(
            iconName,
            size: 24,
            overrideColor: iconColor ?? venyuTheme.primary,
          ),
          const SizedBox(width: 16),
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