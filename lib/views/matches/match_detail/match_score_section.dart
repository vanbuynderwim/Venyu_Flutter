import 'package:flutter/material.dart';
import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_layout_styles.dart';
import '../../../models/match.dart';
import '../../../widgets/common/score_detail_item.dart';

/// MatchScoreSection - Displays all score details for a match
///
/// Shows a list of score components with their breakdown,
/// visualizing how the overall match score is calculated.
class MatchScoreSection extends StatelessWidget {
  final Match match;

  const MatchScoreSection({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty if no score details available
    if (match.scoreDetails == null || match.scoreDetails!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppModifiers.cardContentPadding,
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Column(
        children: match.scoreDetails!.asMap().entries.map((entry) {
          final index = entry.key;
          final scoreDetail = entry.value;
          final isLast = index == match.scoreDetails!.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: ScoreDetailItem(scoreDetail: scoreDetail),
          );
        }).toList(),
      ),
    );
  }
}
