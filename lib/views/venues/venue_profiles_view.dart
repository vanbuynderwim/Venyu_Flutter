import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import 'profile_item_view.dart';
import '../../models/profile.dart';
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../core/providers/app_providers.dart';
import '../../mixins/paginated_list_view_mixin.dart';

/// VenueProfilesView - Paginated list of venue members
/// 
/// This view displays all members of a specific venue using pagination.
/// Only venue admins can access this view to see the member list.
/// 
/// Features:
/// - Paginated member loading
/// - Pull-to-refresh functionality  
/// - Role-based profile display
/// - Empty state handling
/// - Error state management
class VenueProfilesView extends StatefulWidget {
  final String venueId;
  final String venueName;

  const VenueProfilesView({
    super.key,
    required this.venueId,
    required this.venueName,
  });

  @override
  State<VenueProfilesView> createState() => _VenueProfilesViewState();
}

class _VenueProfilesViewState extends State<VenueProfilesView> 
    with PaginatedListViewMixin<VenueProfilesView> {
  // Services
  late final VenueManager _venueManager;
  
  // State
  final List<Profile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _venueManager = VenueManager.shared;
    initializePagination();
    _loadProfiles();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMoreProfiles();
  }

  Future<void> _loadProfiles({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _profiles.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = true;
          if (forceRefresh) {
            _profiles.clear();
            hasMorePages = true;
          }
        });
      }

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfMatches,
          list: ServerListType.matches,
        );

        final profiles = await _venueManager.fetchVenueProfiles(widget.venueId, request, context);
        if (mounted) {
          setState(() {
            _profiles.addAll(profiles);
            hasMorePages = profiles.length == PaginatedRequest.numberOfMatches;
            isLoading = false;
          });
        }
      } catch (error) {
        AppLogger.error('Error fetching venue profiles', context: 'VenueProfilesView', error: error);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loadMoreProfiles() async {
    if (_profiles.isEmpty || !hasMorePages) return;

    if (mounted) {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final lastProfile = _profiles.last;
      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfMatches,
        cursorId: lastProfile.id,
        cursorTime: DateTime.now(),
        list: ServerListType.matches,
      );

      final profiles = await _venueManager.fetchVenueProfiles(widget.venueId, request, context);
      if (mounted) {
        setState(() {
          _profiles.addAll(profiles);
          hasMorePages = profiles.length == PaginatedRequest.numberOfMatches;
          isLoadingMore = false;
        });
      }
    } catch (error) {
      AppLogger.error('Error loading more venue profiles', context: 'VenueProfilesView', error: error);
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadProfiles(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.venueProfilesViewTitle(widget.venueName)),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const LoadingStateWidget()
            : _profiles.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: l10n.venueProfilesViewEmptyTitle,
                          description: l10n.venueProfilesViewEmptyDescription,
                          iconName: "venue",
                          height: MediaQuery.of(context).size.height * 0.6,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _profiles.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _profiles.length) {
                        return buildLoadingIndicator();
                      }

                      final profile = _profiles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ProfileItemView(
                          profile: profile,
                          onProfileSelected: (selectedProfile) {
                            AppLogger.debug('Profile tapped: ${selectedProfile.fullName}', context: 'VenueProfilesView');
                            // TODO: Navigate to profile detail view if needed
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}