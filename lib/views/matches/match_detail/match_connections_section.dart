import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_layout_styles.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/match.dart';
import '../match_item_view.dart';
import '../match_detail_view.dart';

/// MatchConnectionsSection - Displays shared connections section
/// 
/// This widget shows mutual connections between the current user and the match.
/// Each connection is displayed as a match item that can be tapped to view details.
/// 
/// Features:
/// - List of shared connections as match items
/// - Navigation to connection detail views
/// - Empty state when no connections are shared
/// - Debug logging for connection data
class MatchConnectionsSection extends StatelessWidget {
  final Match match;

  const MatchConnectionsSection({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('DEBUG: connections = ${match.connections}');
    debugPrint('DEBUG: nrOfConnections = ${match.nrOfConnections}');
    
    if (match.connections == null || match.connections!.isEmpty) {
      return Container(
        padding: AppModifiers.cardContentPadding,
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No shared connections',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Column(
      children: match.connections!.asMap().entries.map((entry) {
        final index = entry.key;
        final connection = entry.value;
        final isLast = index == match.connections!.length - 1;
        
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
          child: MatchItemView(
            match: connection,
            onMatchSelected: (selectedMatch) {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => MatchDetailView(
                    matchId: selectedMatch.id,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}