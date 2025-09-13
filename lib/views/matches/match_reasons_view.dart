import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/match.dart';

/// MatchReasonsView - Shows why two users match
/// Displays the AI-generated reason in a gradient card
class MatchReasonsView extends StatelessWidget {
  final Match match;

  const MatchReasonsView({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      padding: AppModifiers.cardContentPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primair5Lavender.withValues(alpha: 0.2),
            AppColors.accent3Peach.withValues(alpha: 0.2),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              context.themedIcon(
                'bulb',
                selected: true,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Why you and ${match.profile_1.firstName} match',
                  style: AppTextStyles.subheadline.copyWith(
                    color: venyuTheme.primaryText,
                  ),
                ),
              ),
            ],
          ),
          if (match.reason != null && match.reason!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              match.reason!,
              style: AppTextStyles.subheadline.copyWith(
                color: venyuTheme.primaryText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}