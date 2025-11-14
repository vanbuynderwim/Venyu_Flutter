import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../models/enums/prompt_status.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// StatusBadgeView - Component voor het weergeven van prompt status badges
class StatusBadgeView extends StatelessWidget {
  final PromptStatus status;
  final double? fontSize;
  final EdgeInsets? padding;
  final bool compact;

  const StatusBadgeView({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = compact
        ? Text(
            status.emoji
          )
        : Text(
            '${status.emoji} ${status.displayText(context)}',
            style: AppTextStyles.footnote.copyWith(
              color: context.venyuTheme.darkText,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          );

    if (compact) {
      // In compact mode, show only the emoji without container/decoration
      return child;
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(context).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
        border: Border.all(
          color: status.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: child,
    );
  }

}