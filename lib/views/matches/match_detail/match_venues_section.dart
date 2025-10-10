import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_layout_styles.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/match.dart';
import '../../venues/venue_item_view.dart';
import '../../venues/venue_detail_view.dart';

/// Match venues section showing shared venues between match profiles
/// 
/// Displays a list of venues that both the current user and the match
/// are members of. Uses VenueItemView for consistent venue display.
class MatchVenuesSection extends StatelessWidget {
  final Match match;

  const MatchVenuesSection({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    if (match.venues == null || match.venues!.isEmpty) {
      return Container(
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          AppLocalizations.of(context)!.matchSectionNoSharedVenues,
          style: AppTextStyles.body.secondary(context),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: match.venues!.asMap().entries.map((entry) {
        final index = entry.key;
        final venue = entry.value;
        final isLast = index == match.venues!.length - 1;
        
        return Column(
          children: [
            VenueItemView(
              venue: venue,
              onTap: () {
                // Navigate to venue detail
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (context) => VenueDetailView(venueId: venue.id),
                  ),
                );
              },
            ),
            // Add spacing between venue items
            if (!isLast)
              const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}