import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// SubTitle - Reusable section header widget
///
/// This widget displays a consistent section header with an optional icon and title
/// used throughout the app for different sections.
///
/// Features:
/// - Optional themed icon display with consistent 24px size
/// - Consistent typography with semibold weight with optional color override
/// - Flexible icon and title content
class SubTitle extends StatelessWidget {
  final String? iconName;
  final String title;
  final Color? textColor;

  const SubTitle({
    super.key,
    this.iconName,
    required this.title,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (iconName != null) ...[
          context.themedIcon(iconName!, size: 24, selected: true, overrideColor: textColor ?? context.venyuTheme.primary),
          const SizedBox(width: 8),
        ],
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