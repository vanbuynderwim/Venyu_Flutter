import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// SubTitle - Reusable section header widget
///
/// This widget displays a consistent section header with an icon and title
/// used throughout the app for different sections.
///
/// Features:
/// - Themed icon display with consistent 18px size
/// - Consistent typography with semibold weight with optional color override
/// - Flexible icon and title content
class SubTitle extends StatelessWidget {
  final String iconName;
  final String title;
  final Color? textColor;

  const SubTitle({
    super.key,
    required this.iconName,
    required this.title,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        context.themedIcon(iconName, size: 24, selected: true, overrideColor: textColor ?? context.venyuTheme.primaryText),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.subheadline.copyWith(
            color: textColor ?? context.venyuTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}