import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// Reusable warning box widget for displaying warning messages
///
/// This widget creates a styled container with a border and background
/// in warning color. It displays text with a notifications icon.
class WarningBoxWidget extends StatelessWidget {
  final String text;

  const WarningBoxWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.warning,
          width: AppModifiers.extraThinBorder,
        ),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.themedIcon('notification', overrideColor: context.venyuTheme.primaryText),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.footnote.copyWith(
                color: context.venyuTheme.primaryText,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
