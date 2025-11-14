import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/score_detail.dart';
import 'matching_score_widget.dart';
import 'option_icon_view.dart';

/// ScoreDetailItem - Displays a single score component breakdown
///
/// Shows icon, label, description, and weighted points visualization
/// in a horizontal layout. Non-interactive display component.
///
/// Layout:
/// [Icon] [Label + Description] [MatchingScoreWidget]
class ScoreDetailItem extends StatelessWidget {
  final ScoreDetail scoreDetail;

  const ScoreDetailItem({
    super.key,
    required this.scoreDetail,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Check if there's data
    final hasData = scoreDetail.weightedPoints != null && scoreDetail.weightedPoints != 0.0;

    // Use borderColor (gray) when no data, otherwise primary
    final iconColor = hasData ? venyuTheme.primary : venyuTheme.borderColor;

    // Lower opacity for text when no data
    final textOpacity = hasData ? 1.0 : 0.5;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon
        SizedBox(
          width: 20,
          height: 20,
          child: OptionIconView(
            icon: scoreDetail.icon,
            emoji: null,
            size: 24,
            color: iconColor,
            placeholder: 'match',
            opacity: 1.0,
            isLocal: false, // Remote icons from database
          ),
        ),

        const SizedBox(width: 16),

        // Label and Description
        Expanded(
          child: Opacity(
            opacity: textOpacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scoreDetail.label,
                  style: AppTextStyles.subheadline.copyWith(
                    color: venyuTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  scoreDetail.description,
                  style: AppTextStyles.caption2.copyWith(
                    color: venyuTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Matching Score Widget (right-aligned)
        // Show score if available, otherwise show empty (0) score
        MatchingScoreWidget(
          score: scoreDetail.weightedPoints ?? 0.0,
        ),
      ],
    );
  }
}
