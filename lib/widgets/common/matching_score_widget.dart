import 'package:flutter/material.dart';
import '../../core/theme/venyu_theme.dart';

/// MatchingScoreWidget - Displays a matching score as 5 dots
///
/// Shows a visual representation of a matching score (0-10) using 5 dots.
/// Scores of 8+ fill all 5 dots, making it easier to reach maximum.
///
/// Example:
/// - score 0: 0 dots filled (no data/null case)
/// - score > 0 and <= 2: 1 dot filled
/// - score > 2 and <= 4: 2 dots filled
/// - score > 4 and <= 6: 3 dots filled
/// - score > 6 and <= 8: 4 dots filled
/// - score > 8: 5 dots filled (maximum)
class MatchingScoreWidget extends StatelessWidget {
  /// The matching score from 0 to 10
  final double score;

  /// Size of each dot
  final double dotSize;

  /// Spacing between dots
  final double spacing;

  const MatchingScoreWidget({
    super.key,
    required this.score,
    this.dotSize = 8,
    this.spacing = 6,
  });

  /// Calculate how many dots should be filled based on the score
  int _getFilledDots() {
    // Clamp score between 0 and 10
    final clampedScore = score.clamp(0.0, 10.0);

    // 0 = 0 bolletjes
    if (clampedScore == 0.0) return 0;

    // > 0 en <= 2: 1 bolletje
    if (clampedScore <= 2.0) return 1;

    // > 2 en <= 4: 2 bolletjes
    if (clampedScore <= 4.0) return 2;

    // > 4 en <= 6: 3 bolletjes
    if (clampedScore <= 6.0) return 3;

    // > 6 en <= 8: 4 bolletjes
    if (clampedScore <= 8.0) return 4;

    // > 8: 5 bolletjes
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    final filledDots = _getFilledDots();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(9, (index) {
        // Even indices are dots, odd indices are lines
        if (index.isEven) {
          final dotIndex = index ~/ 2;
          final isFilled = dotIndex < filledDots;
          return Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isFilled
                  ? context.venyuTheme.primary
                  : context.venyuTheme.borderColor,
              shape: BoxShape.circle,
            ),
          );
        } else {
          // This is a line between dots
          final nextDotIndex = (index + 1) ~/ 2;
          final isNextDotFilled = nextDotIndex < filledDots;
          return Container(
            width: spacing,
            height: 1.8,
            color: isNextDotFilled
                ? context.venyuTheme.primary
                : context.venyuTheme.borderColor,
          );
        }
      }),
    );
  }
}
