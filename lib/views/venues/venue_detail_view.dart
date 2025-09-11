import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/date_extensions.dart';
import '../../core/utils/url_helper.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../models/venue.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/avatar_view.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/buttons/action_button.dart';

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
  String? _error;

  @override
  void initState() {
    super.initState();
    _venueManager = VenueManager.shared;
    _loadVenueDetail();
  }

  Future<void> _loadVenueDetail() async {
    setState(() => _error = null);
    
    final venue = await executeWithLoadingAndReturn<Venue>(
      operation: () => _venueManager.fetchVenue(widget.venueId),
      showErrorToast: false,  // We show custom error UI
      onError: (error) {
        setState(() => _error = 'Failed to load venue details');
      },
    );
    
    if (venue != null) {
      setState(() => _venue = venue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_venue?.name ?? 'Loading...'),
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
          // Fixed bottom action button
          if (_venue != null)
            _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_venue == null) {
      return const Center(
        child: Text('Venue not found'),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
        // Venue Header
        _buildVenueHeader(_venue!),
        
        const SizedBox(height: 24),
        
        // About section
        if (_venue!.about != null && _venue!.about!.isNotEmpty) ...[
          _buildAboutSection(_venue!),
          const SizedBox(height: 24),
        ],

        // Website section
        if (_venue!.website != null && _venue!.website!.isNotEmpty) ...[
          _buildWebsiteSection(_venue!),
          const SizedBox(height: 24),
        ],
        
        // Event info section (only for events)
        if (_venue!.isEvent && (_venue!.eventDate != null || _venue!.eventLocation != null)) ...[
          _buildEventInfoSection(_venue!),
          const SizedBox(height: 24),
        ],

        // Event dates section (only for events)
        if (_venue!.isEvent) ...[
          _buildEventDatesSection(_venue!),
          const SizedBox(height: 24),
        ],

        // Stats section        
        _buildStatsSection(_venue!),
        
        const SizedBox(height: 24),
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
              if (venue.baseline != null && venue.baseline.isNotEmpty) ...[
                Text(
                  venue.baseline,
                  style: AppTextStyles.subheadline.secondary(context),
                ),
                const SizedBox(height: 8),
              ],
              
              // Venue type tag
              TagView(
                id: venue.type.name,
                label: venue.type.displayName,
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
          'About',
          style: AppTextStyles.headline.primaryText(context),
        ),
        const SizedBox(height: 8),
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
        Text(
          'Event Details',
          style: AppTextStyles.headline.primaryText(context),
        ),
        const SizedBox(height: 8),
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
                              venue.eventDate!.formatDateWithWeekday(),
                              style: AppTextStyles.body.primaryText(context),
                            ),
                            if (venue.eventHour != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                venue.eventHour!.formatTime(),
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
                    color: context.venyuTheme.borderColor.withValues(alpha: 0.7),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the website section
  Widget _buildWebsiteSection(Venue venue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Website',
          style: AppTextStyles.headline.primaryText(context),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => UrlHelper.openWebsite(context, venue.website!),
          child: Text(
            venue.website!,
            style: AppTextStyles.body.copyWith(
              color: context.venyuTheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the stats section with all venue counters
  Widget _buildStatsSection(Venue venue) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Venue Statistics',
          style: AppTextStyles.headline.primaryText(context),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: venyuTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: venyuTheme.borderColor.withValues(alpha: 0.1),
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
                    venue.profileCount == 1 ? 'Member' : 'Members',
                  ),
                ),
                
                // Separator
                Container(
                  width: 1,
                  height: 40,
                  color: venyuTheme.borderColor.withValues(alpha: 0.7),
                ),
                
                // Cards count
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildStatItem(
                      context.themedIcon('card', size: 24, selected: true),
                      '${venue.promptCount ?? 0}',
                      venue.promptCount == 1 ? 'Card' : 'Cards',
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
                    venue.matchCount == 1 ? 'Match' : 'Matches',
                  ),
                ),
                
                // Separator
                Container(
                  width: 1,
                  height: 40,
                  color: venyuTheme.borderColor.withValues(alpha: 0.7),
                ),
                
                // Connections count
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildStatItem(
                      context.themedIcon('handshake', size: 24, selected: true),
                      '${venue.connectionCount ?? 0}',
                      venue.connectionCount == 1 ? 'Introduction' : 'Introductions',
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
  Widget _buildStatItem(Widget icon, String count, String label) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: AppTextStyles.headline.primaryText(context),
              ),
              Text(
                label,
                style: AppTextStyles.caption1.secondary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the bottom action button section
  Widget _buildBottomSection() {
    return ActionButton(
        label: 'Add Card',
        onPressed: _handleAddCard,
        icon: context.themedIcon('plus', size: 20),
      );
  }

  /// Builds the event dates section (only for events)
  Widget _buildEventDatesSection(Venue venue) {
    if (!venue.isEvent) return const SizedBox.shrink();
    
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Open for matchmaking',
          style: AppTextStyles.headline.primaryText(context),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: venyuTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: venyuTheme.borderColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Start date
                if (venue.startsAt != null) ...[
                  Row(
                    children: [
                      context.themedIcon('event', size: 20, selected: false),
                      const SizedBox(width: 16),
                      Text(
                        'From',
                        style: AppTextStyles.subheadline.secondary(context),
                      ),
                      const Spacer(),
                      Text(
                        venue.startsAt!.formatDate(),
                        style: AppTextStyles.subheadline.primaryText(context),
                      ),
                    ],
                  ),
                ],
                
                // Separator if both dates are present
                if (venue.startsAt != null && venue.expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Divider(
                    color: context.venyuTheme.borderColor.withValues(alpha: 0.7),
                    height: 1,
                  ),
                  const SizedBox(height: 8),
                ],
                
                // End date
                if (venue.expiresAt != null) ...[
                  Row(
                    children: [
                      context.themedIcon('event', size: 20, selected: false),
                      const SizedBox(width: 16),
                      Text(
                        'Until',
                        style: AppTextStyles.subheadline.secondary(context),
                      ),
                      const Spacer(),
                      Text(
                        venue.expiresAt!.formatDate(),
                        style: AppTextStyles.subheadline.primaryText(context),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Handles add card button press
  void _handleAddCard() {
    AppLogger.ui('Add card button pressed for venue: ${_venue?.name}', context: 'VenueDetailView');
    
    // TODO: Implement navigation to add card view
    // For now, just show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add card functionality coming soon'),
      ),
    );
  }
}