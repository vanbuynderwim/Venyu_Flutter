import 'package:flutter/material.dart';
import '../../core/theme/venyu_theme.dart';

/// MatchingScoreWidget - Displays a matching score as 5 dots
///
/// Shows a visual representation of a matching score (0-10) using 5 dots.
/// Scores of 8+ fill all 5 dots, making it easier to reach maximum.
///
/// Example:
/// - score 0-1.9: 1 dot filled
/// - score 2-3.9: 2 dots filled
/// - score 4-5.9: 3 dots filled
/// - score 6-7.9: 4 dots filled
/// - score 8+: 5 dots filled (maximum)
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
    this.spacing = 8,
  });

  /// Calculate how many dots should be filled based on the score
  int _getFilledDots() {
    // Clamp score between 0 and 10
    final clampedScore = score.clamp(0.0, 10.0);

    // Scores of 8 or higher fill all 5 dots
    if (clampedScore >= 8.0) return 5;

    // Otherwise: divide by 2, floor, and add 1
    // This gives: 0-1.9→1, 2-3.9→2, 4-5.9→3, 6-7.9→4
    return ((clampedScore / 2).floor() + 1).clamp(1, 5);
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
