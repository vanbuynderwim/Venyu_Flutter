import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../match.dart';
import '../tag.dart';

/// MatchDetailSectionType enum - represents different sections in match detail view
///
/// This enum defines the available sections that can be viewed in detail
/// from the match detail screen.
enum MatchDetailSectionType {
  sharedIntros,
  sharedVenues,
  personalInterests,
  companyFacts,
  score;

  /// Get the icon name for this section
  String get iconName {
    switch (this) {
      case MatchDetailSectionType.sharedIntros:
        return 'match';
      case MatchDetailSectionType.sharedVenues:
        return 'venue';
      case MatchDetailSectionType.personalInterests:
        return 'profile';
      case MatchDetailSectionType.companyFacts:
        return 'company';
      case MatchDetailSectionType.score:
        return 'target';
    }
  }

  /// Get the dynamic title for this section based on match data
  String dynamicTitle(BuildContext context, Match match) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MatchDetailSectionType.sharedIntros:
        return l10n.matchDetailSharedIntros(
          match.nrOfConnections,
          match.nrOfConnections == 1 ? l10n.matchDetailIntroduction : l10n.matchDetailIntroductions,
        );
      case MatchDetailSectionType.sharedVenues:
        return l10n.matchDetailSharedVenues(
          match.nrOfVenues,
          match.nrOfVenues == 1 ? l10n.matchDetailVenue : l10n.matchDetailVenues,
        );
      case MatchDetailSectionType.personalInterests:
        return l10n.matchDetailPersonalInterests(
          match.nrOfPersonalTags,
          match.nrOfPersonalTags == 1 ? l10n.matchDetailArea : l10n.matchDetailAreas,
        );
      case MatchDetailSectionType.companyFacts:
        return l10n.matchDetailCompanyFacts(
          match.nrOfCompanyTags,
          match.nrOfCompanyTags == 1 ? l10n.matchDetailArea : l10n.matchDetailAreas,
        );
      case MatchDetailSectionType.score:
        final filledDots = _getFilledDots(match.score ?? 0);
        return '${l10n.matchDetailScoreBreakdown}: $filledDots / 5';
    }
  }

  /// Calculate how many dots should be filled based on the score
  /// Same logic as MatchingScoreWidget
  static int _getFilledDots(double score) {
    final clampedScore = score.clamp(0.0, 10.0);
    if (clampedScore == 0.0) return 0;
    if (clampedScore <= 2.0) return 1;
    if (clampedScore <= 4.0) return 2;
    if (clampedScore <= 6.0) return 3;
    if (clampedScore <= 8.0) return 4;
    return 5;
  }

  /// Check if this section should be visible for the given match
  bool isVisible(Match match) {
    switch (this) {
      case MatchDetailSectionType.sharedIntros:
        return match.nrOfConnections > 0;
      case MatchDetailSectionType.sharedVenues:
        return match.nrOfVenues > 0;
      case MatchDetailSectionType.personalInterests:
        return match.nrOfPersonalTags > 0;
      case MatchDetailSectionType.companyFacts:
        return match.nrOfCompanyTags > 0;
      case MatchDetailSectionType.score:
        return match.scoreDetails != null && match.scoreDetails!.isNotEmpty;
    }
  }
}

/// Wrapper class that implements OptionType for MatchDetailSectionType
///
/// This class wraps a MatchDetailSectionType and Match to provide
/// dynamic titles and descriptions based on the match data.
class MatchSectionOption implements OptionType {
  final MatchDetailSectionType sectionType;
  final Match match;
  final BuildContext context;

  const MatchSectionOption({
    required this.sectionType,
    required this.match,
    required this.context,
  });

  @override
  String get id => sectionType.name;

  @override
  String title(BuildContext context) => sectionType.dynamicTitle(context, match);

  @override
  String description(BuildContext context) => '';

  @override
  String? get icon => sectionType.iconName;

  @override
  String? get emoji => null;

  @override
  Color get color => AppColors.primair4Lilac;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => null;
}
