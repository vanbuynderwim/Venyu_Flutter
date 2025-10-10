import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/date_extensions.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../models/venue.dart';
import '../../models/match.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/avatar_view.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/buttons/get_matched_button.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../matches/match_item_view.dart';
import '../matches/match_detail_view.dart';
import '../../services/profile_service.dart';
import 'venue_profiles_view.dart';
import 'venue_prompts_view.dart';

/// VenueDetailView - Detailed view of a venue showing information and member stats
/// 
/// This view displays comprehensive information about a venue including:
/// - Venue header with avatar, name, and baseline
/// - Venue type as tag
/// - About section
/// - Member and card statistics
/// - Add card action button
/// 
/// Based on ProfileView structure with venue-specific styling.
class VenueDetailView extends StatefulWidget {
  final String venueId;

  const VenueDetailView({
    super.key,
    required this.venueId,
  });

  @override
  State<VenueDetailView> createState() => _VenueDetailViewState();
}

class _VenueDetailViewState extends State<VenueDetailView> with ErrorHandlingMixin {
  // Services
  late final VenueManager _venueManager;

  // State
  Venue? _venue;
  List<Match> _matches = [];
  bool _matchesLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _venueManager = VenueManager.shared;
    _loadVenueDetail();
  }

  Future<void> _loadVenueDetail() async {
    if (!mounted) return;
    setState(() => _error = null);

    final l10n = AppLocalizations.of(context)!;

    final venue = await executeWithLoadingAndReturn<Venue>(
      operation: () => _venueManager.fetchVenue(widget.venueId),
      showErrorToast: false,  // We show custom error UI
      onError: (error) {
        if (mounted) {
          setState(() => _error = l10n.venueDetailErrorLoading);
        }
      },
    );

    if (venue != null && mounted) {
      setState(() => _venue = venue);
      // Load matches after venue is loaded
      _loadMatches();
    }
  }

  Future<void> _loadMatches() async {
    if (_venue == null) return;

    try {
      AppLogger.debug('Loading matches for venue: ${_venue!.id}', context: 'VenueDetailView');

      final matches = await _venueManager.fetchVenueMatches(_venue!.id).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.warning('fetchVenueMatches timed out', context: 'VenueDetailView');
          return <Match>[];
        },
      );

      AppLogger.debug('Received ${matches.length} matches', context: 'VenueDetailView');

      if (mounted) {
        setState(() {
          _matches = matches;
          _matchesLoaded = true;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading matches: $e', context: 'VenueDetailView');
      if (mounted) {
        setState(() {
          _matches = [];
          _matchesLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.venueDetailTitle),
      ),
      usePadding: true,
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadVenueDetail,
              child: _buildContent(),
            ),
          ),
          // Fixed bottom sections
          if (_venue != null) ...[
            // Fixed bottom action button
            _buildBottomSection(),

            // Event dates section fixed at bottom (only for events)
            if (_venue!.isEvent) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildEventDatesSection(_venue!),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const LoadingStateWidget();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            PlatformTextButton(
              onPressed: _loadVenueDetail,
              child: Text(l10n.venueDetailRetryButton),
            ),
          ],
        ),
      );
    }

    if (_venue == null) {
      return Center(
        child: Text(l10n.venueDetailNotFound),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        // Venue Header
        _buildVenueHeader(_venue!),
        
        const SizedBox(height: 16),
         // Stats section        
        _buildStatsSection(_venue!),

        
        // About section
        if (_venue!.about != null && _venue!.about!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildAboutSection(_venue!),          
        ],

        
        // Event info section (for events or venues with website)
        if ((_venue!.isEvent && (_venue!.eventDate != null || _venue!.eventLocation != null)) ||
            (_venue!.website != null && _venue!.website!.isNotEmpty)) ...[
          const SizedBox(height: 16),
          _buildEventInfoSection(_venue!),
        ],

        const SizedBox(height: 16),

        // Matches section
        _buildVenueMatches(),

      ],
    );
  }

  /// Builds the venue header with avatar, name, baseline, and type
  Widget _buildVenueHeader(Venue venue) {
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar (not editable)
        AvatarView(
          avatarId: venue.avatarId,
          size: 80,
          showBorder: true,
        ),
        
        const SizedBox(width: 16),
        
        // Venue info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue name
              Text(
                venue.name,
                style: AppTextStyles.title2.primaryText(context),
              ),
              
              const SizedBox(height: 4),
              
              // Baseline
              if (venue.baseline.isNotEmpty) ...[
                Text(
                  venue.baseline,
                  style: AppTextStyles.subheadline.secondary(context),
                ),
                const SizedBox(height: 8),
              ],
              
              // Venue type tag
              TagView(
                id: venue.type.name,
                label: venue.type.displayName(context),
                icon: venue.type.icon,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the about section
  Widget _buildAboutSection(Venue venue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          venue.about!,
          style: AppTextStyles.body.secondary(context),
        ),
      ],
    );
  }

  /// Builds the event info section with date/time and location
  Widget _buildEventInfoSection(Venue venue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [  
        Container(
          decoration: AppLayoutStyles.cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Event date and time
                if (venue.eventDate != null) ...[
                  Row(
                    children: [
                      context.themedIcon('event', size: 20, selected: false),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.eventDate!.formatDateFull(context),
                              style: AppTextStyles.body.primaryText(context),
                            ),
                            if (venue.eventHour != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                venue.eventHour!.formatTime(context),
                                style: AppTextStyles.caption1.secondary(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                
                // Separator if both date and location are present
                if (venue.eventDate != null && venue.eventLocation != null) ...[
                  const SizedBox(height: 12),
                  Divider(
                    color: context.venyuTheme.borderColor.withValues(alpha: 0.5),
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Event location
                if (venue.eventLocation != null) ...[
                  GestureDetector(
                    onTap: () => UrlHelper.openMaps(context, venue.eventLocation!),
                    child: Row(
                      children: [
                        context.themedIcon('map', size: 20, selected: false),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            venue.eventLocation!,
                            style: AppTextStyles.body.copyWith(
                              color: context.venyuTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Separator if location and website are both present
                if (venue.eventLocation != null && venue.website != null && venue.website!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(
                    color: context.venyuTheme.borderColor.withValues(alpha: 0.5),
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Website
                if (venue.website != null && venue.website!.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () => UrlHelper.openWebsite(context, venue.website!),
                    child: Row(
                      children: [
                        context.themedIcon('link', size: 20, selected: false),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            venue.website!,
                            style: AppTextStyles.body.copyWith(
                              color: context.venyuTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }


  /// Builds the stats section with all venue counters
  Widget _buildStatsSection(Venue venue) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: venyuTheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: venyuTheme.borderColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
            // Top row: Members and Cards
            Row(
              children: [
                // Members count
                Expanded(
                  child: _buildStatItem(
                    context.themedIcon('venue', size: 24, selected: true),
                    '${venue.profileCount ?? 0}',
                    venue.profileCount == 1 ? l10n.venueDetailMemberSingular : l10n.venueDetailMembersPlural,
                    onTap: venue.isUserAdmin ? () => _navigateToVenueProfiles(venue) : null,
                    isClickable: venue.isUserAdmin,
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  height: 40,
                  color: venyuTheme.borderColor.withValues(alpha: 0.5),
                ),

                // Cards count
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildStatItem(
                      context.themedIcon('card', size: 24, selected: true),
                      '${venue.promptCount ?? 0}',
                      venue.promptCount == 1 ? l10n.venueDetailCardSingular : l10n.venueDetailCardsPlural,
                      onTap: venue.isUserAdmin ? () => _navigateToVenuePrompts(venue) : null,
                      isClickable: venue.isUserAdmin,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bottom row: Matches and Connections
            Row(
              children: [
                // Matches count
                Expanded(
                  child: _buildStatItem(
                    context.themedIcon('match', size: 24, selected: true),
                    '${venue.matchCount ?? 0}',
                    venue.matchCount == 1 ? l10n.venueDetailMatchSingular : l10n.venueDetailMatchesPlural,
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  height: 40,
                  color: venyuTheme.borderColor.withValues(alpha: 0.5),
                ),

                // Connections count
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildStatItem(
                      context.themedIcon('handshake', size: 24, selected: true),
                      '${venue.connectionCount ?? 0}',
                      venue.connectionCount == 1 ? l10n.venueDetailIntroductionSingular : l10n.venueDetailIntroductionsPlural,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
          ),
        ),
      ],
    );
  }

  /// Builds a single stat item with icon, count, and label
  Widget _buildStatItem(Widget icon, String count, String label, {VoidCallback? onTap, bool isClickable = false}) {
    final content = Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: AppTextStyles.headline.copyWith(
                  color: isClickable
                      ? context.venyuTheme.primary
                      : context.venyuTheme.primaryText,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.caption1.copyWith(
                  color: isClickable
                      ? context.venyuTheme.primary
                      : context.venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // If no onTap callback, return plain content
    if (onTap == null) {
      return content;
    }

    // Otherwise, make it tappable with subtle highlight
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: content,
      ),
    );
  }

  /// Builds the bottom action button section
  Widget _buildBottomSection() {
    return GetMatchedButton(
      buttonType: GetMatchedButtonType.action,
      venueId: _venue?.id,
      onModalClosed: (result) {
        if (result == true) {
          AppLogger.debug('Prompt creation completed for venue: ${_venue?.name}',
              context: 'VenueDetailView');
          // Optionally refresh venue data or show success message
        }
      },
    );
  }

  /// Builds the event dates section (only for events)
  Widget _buildEventDatesSection(Venue venue) {
    if (!venue.isEvent) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    String message;

    if (venue.startsAt != null && venue.expiresAt != null) {
      message = l10n.venueDetailOpenFromUntil(
        venue.startsAt!.formatDateShort(context),
        venue.expiresAt!.formatDateShort(context),
      );
    } else if (venue.startsAt != null) {
      message = l10n.venueDetailOpenFrom(venue.startsAt!.formatDateShort(context));
    } else if (venue.expiresAt != null) {
      message = l10n.venueDetailOpenUntil(venue.expiresAt!.formatDateShort(context));
    } else {
      message = l10n.venueDetailOpenForMatchmaking;
    }

    return Text(
      message,
      style: AppTextStyles.caption1.secondary(context),
      textAlign: TextAlign.center,
    );
  }

  /// Build venue matches section
  Widget _buildVenueMatches() {
    final l10n = AppLocalizations.of(context)!;

    // Show loading while matches are being loaded
    if (!_matchesLoaded) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingStateWidget(),
      );
    }

    // Show empty state if no matches
    if (_matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: EmptyStateWidget(
          message: l10n.venueDetailEmptyMatchesTitle,
          description: l10n.venueDetailEmptyMatchesDescription,
          iconName: 'nomatches',
          height: 200,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Matches title
        SubTitle(
          iconName: 'handshake',
          title: l10n.venueDetailMatchesAndIntrosTitle,
        ),
        const SizedBox(height: 8),

        // Matches list
        ..._matches.map((match) => Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: MatchItemView(
            match: match,
            shouldBlur: !((ProfileService.shared.currentProfile?.isPro ?? false) || match.isConnected),
            onMatchSelected: (selectedMatch) => _navigateToMatchDetail(selectedMatch),
          ),
        )),
      ],
    );
  }

  void _navigateToMatchDetail(Match match) {
    AppLogger.ui('Navigating to match detail from venue: ${match.id}', context: 'VenueDetailView');

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchDetailView(matchId: match.id),
      ),
    );
  }

  /// Navigate to venue profiles view (admin only)
  void _navigateToVenueProfiles(Venue venue) {
    AppLogger.ui('Navigating to venue profiles for: ${venue.name}', context: 'VenueDetailView');
    
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => VenueProfilesView(
          venueId: venue.id,
          venueName: venue.name,
        ),
      ),
    );
  }

  /// Navigate to venue prompts view (admin only)
  void _navigateToVenuePrompts(Venue venue) {
    AppLogger.ui('Navigating to venue prompts for: ${venue.name}', context: 'VenueDetailView');
    
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => VenuePromptsView(
          venueId: venue.id,
          venueName: venue.name,
        ),
      ),
    );
  }

}