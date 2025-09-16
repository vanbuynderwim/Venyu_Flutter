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
    final child = Text(
      status.displayText,
      style: AppTextStyles.caption2.copyWith(
        color: status.textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: 1.0,
      ),
    );

    return Container(
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: 10,
        vertical: compact ? 4.0 : 6.0,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(context),
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),

      ),
      child: compact 
        ? SizedBox(
            height: 16, // Match icon height in InteractionTag
            child: Center(child: child),
          )
        : child,
    );
  }

}