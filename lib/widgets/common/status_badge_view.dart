import 'package:flutter/material.dart';
import '../../models/enums/prompt_status.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// StatusBadgeView - Component voor het weergeven van prompt status badges
class StatusBadgeView extends StatelessWidget {
  final PromptStatus status;
  final double? fontSize;
  final EdgeInsets? padding;

  const StatusBadgeView({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        border: Border.all(
          color: status.borderColor,
          width: 1,
        ),
      ),
      child: Text(
        status.displayText,
        style: AppTextStyles.caption1.copyWith(
          color: status.textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

}