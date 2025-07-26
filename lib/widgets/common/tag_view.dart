import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';
import 'option_icon_view.dart';

/// TagView - Flutter equivalent van Swift TagView
class TagView extends StatelessWidget {
  final String id;
  final String label;
  final String? icon;
  final String? emoji;
  final Color? color;
  final TextStyle? fontSize;
  final double iconSize;
  final Color? backgroundColor;

  const TagView({
    super.key,
    required this.id,
    required this.label,
    this.icon,
    this.emoji,
    this.color,
    this.fontSize,
    this.iconSize = 16,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: backgroundColor != null 
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
              border: Border.all(
                color: venyuTheme.borderColor,
                width: AppModifiers.extraThinBorder,
              ),
            )
          : AppLayoutStyles.tagDecoration(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon/Emoji
          if (icon != null || emoji != null) ...[
            OptionIconView(
              icon: icon,
              emoji: emoji,
              size: iconSize,
              color: color ?? AppColors.primair4Lilac,
              isLocal: false, // TagView meestal gebruikt voor remote icons van tags
            ),
            const SizedBox(width: 4),
          ],
          
          // Label
          Text(
            label,
            style: (fontSize ?? AppTextStyles.footnote).copyWith(
              color: venyuTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}