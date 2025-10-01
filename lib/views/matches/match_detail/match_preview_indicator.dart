import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/match.dart';

/// MatchPreviewIndicator - Shows preview mode information
/// Displays a notification card when a match is in preview mode
class MatchPreviewIndicator extends StatelessWidget {
  final Match match;

  const MatchPreviewIndicator({
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
      child: Text(
        '${match.profile.firstName} sees this match only if you\'re interested.',
        style: AppTextStyles.body.copyWith(
          color: venyuTheme.primaryText,
        ),
      ),
    );
  }
}