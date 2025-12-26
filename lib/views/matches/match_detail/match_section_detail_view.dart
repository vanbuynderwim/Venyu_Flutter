import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../models/enums/match_detail_section_type.dart';
import '../../../models/match.dart';
import '../../../widgets/scaffolds/app_scaffold.dart';
import 'match_connections_section.dart';
import 'match_venues_section.dart';
import 'match_tags_section.dart';
import 'match_score_section.dart';

/// MatchSectionDetailView - Detail view for a specific match section
///
/// This view displays the full content of a selected section from the
/// match detail screen. The section type determines what content is shown.
class MatchSectionDetailView extends StatelessWidget {
  final Match match;
  final MatchDetailSectionType sectionType;

  const MatchSectionDetailView({
    super.key,
    required this.match,
    required this.sectionType,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_getTitle(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          width: double.infinity,
          child: _buildContent(context),
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    return sectionType.dynamicTitle(context, match);
  }

  Widget _buildContent(BuildContext context) {
    switch (sectionType) {
      case MatchDetailSectionType.sharedIntros:
        return _buildSharedIntrosSection(context);
      case MatchDetailSectionType.sharedVenues:
        return _buildSharedVenuesSection(context);
      case MatchDetailSectionType.personalInterests:
        return _buildPersonalInterestsSection(context);
      case MatchDetailSectionType.companyFacts:
        return _buildCompanyFactsSection(context);
      case MatchDetailSectionType.score:
        return _buildScoreSection(context);
    }
  }

  Widget _buildSharedIntrosSection(BuildContext context) {
    return MatchConnectionsSection(match: match);
  }

  Widget _buildSharedVenuesSection(BuildContext context) {
    return MatchVenuesSection(match: match);
  }

  Widget _buildPersonalInterestsSection(BuildContext context) {
    return MatchTagsSection(tagGroups: match.personalTagGroups);
  }

  Widget _buildCompanyFactsSection(BuildContext context) {
    return MatchTagsSection(tagGroups: match.companyTagGroups);
  }

  Widget _buildScoreSection(BuildContext context) {
    return MatchScoreSection(match: match);
  }
}
