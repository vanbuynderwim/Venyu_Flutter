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
          if (match.motivation != null && match.motivation!.isNotEmpty) ...[
            ...match.motivation!.asMap().entries.map((entry) {
              final index = entry.key;
              final reason = entry.value;
              final isLast = index == match.motivation!.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 10),
                      child: context.themedIcon('checkbox', selected: true, overrideColor: venyuTheme.primary, size: 18),
                    ),
                    Expanded(
                      child: Text(
                        reason,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}