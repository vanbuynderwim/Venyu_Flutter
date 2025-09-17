import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// PromptCounters - Displays match and connection counts for a prompt
///
/// Shows compact counters with icons for matches and connections.
/// Only displays counters that have a value greater than 0.
class PromptCounters extends StatelessWidget {
  final int? matchCount;
  final int? connectionCount;

  const PromptCounters({
    super.key,
    this.matchCount,
    this.connectionCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasMatches = (matchCount ?? 0) > 0;
    final hasConnections = (connectionCount ?? 0) > 0;

    // Don't render anything if no counters to show
    if (!hasMatches && !hasConnections) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Match counter
        if (hasMatches) ...[
          _buildCounter(
            context: context,
            icon: 'match',
            count: matchCount!,
          ),
          if (hasConnections) const SizedBox(width: 12),
        ],
        // Connection counter
        if (hasConnections)
          _buildCounter(
            context: context,
            icon: 'handshake',
            count: connectionCount!,
          ),
      ],
    );
  }

  Widget _buildCounter({
    required BuildContext context,
    required String icon,
    required int count,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        context.themedIcon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: AppTextStyles.footnote.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}