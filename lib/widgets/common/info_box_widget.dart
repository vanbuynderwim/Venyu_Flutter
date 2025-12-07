import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// Reusable info box widget for displaying informational messages
///
/// This widget creates a styled container with an optional icon and text.
/// It uses AppLayoutStyles.cardDecoration for consistent card styling.
/// If [iconName] is null, no icon is shown. Defaults to 'info'.
class InfoBoxWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? iconColor;
  final String? iconName;

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
    final showIcon = iconName != null;

    return Container(
      padding: const EdgeInsets.only(top: 0),
      //decoration: AppLayoutStyles.cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            context.themedIcon(
              iconName!,
              size: 18,
              overrideColor: iconColor ?? venyuTheme.primaryText,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.subheadline2.copyWith(
                color: textColor ?? venyuTheme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}