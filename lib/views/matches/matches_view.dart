import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../models/match.dart';
import '../../models/requests/paginated_request.dart';
import 'match_item_view.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../services/notification_service.dart';
import '../../core/providers/app_providers.dart';
import '../../services/profile_service.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import 'match_detail_view.dart';

/// MatchesView - Matches page with ListView for server data
class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  State<MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView>
    with PaginatedListViewMixin<MatchesView>, ErrorHandlingMixin<MatchesView> {
  // Services
  late final MatchingManager _matchingManager;
  NotificationService? _notificationService;

  // State
  final List<Match> _matches = [];

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _notificationService = NotificationService.shared;
    initializePagination();
    _loadMatches();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMoreMatches();
  }

  Future<void> _loadMatches({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _matches.isEmpty) {
      if (forceRefresh) {
        safeSetState(() {
          _matches.clear();
          hasMorePages = true;
        });
      }

      await executeWithLoading(
        operation: () async {
          final request = PaginatedRequest(
            limit: PaginatedRequest.numberOfMatches,
            list: ServerListType.matches,
          );

          final matches = await _matchingManager.fetchMatches(request);
          safeSetState(() {
            _matches.addAll(matches);
            hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
          });
        },
        showSuccessToast: false,
        showErrorToast: false,  // Silent load for initial data
      );
    }
  }

  Future<void> _loadMoreMatches() async {
    if (_matches.isEmpty || !hasMorePages) return;

    safeSetState(() {
      isLoadingMore = true;
    });

    await executeSilently(
      operation: () async {
        final lastMatch = _matches.last;
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfMatches,
          cursorId: lastMatch.id,
          cursorTime: lastMatch.updatedAt,
          cursorStatus: lastMatch.status,
          list: ServerListType.matches,
        );

        final matches = await _matchingManager.fetchMatches(request);
        safeSetState(() {
          _matches.addAll(matches);
          hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
          isLoadingMore = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading more matches', context: 'MatchesView', error: error);
        safeSetState(() {
          isLoadingMore = false;
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    await _loadMatches(forceRefresh: true);
    // Update badges after refreshing matches
    _fetchBadges();
  }

  /// Fetch badge counts to update tab bar
  Future<void> _fetchBadges() async {
    try {
      _notificationService ??= NotificationService.shared;
      await _notificationService!.fetchBadges();
    } catch (error) {
      AppLogger.error('Failed to fetch badges after matches refresh', error: error, context: 'MatchesView');
    }
  }

  /// Manually decrease the matches badge count by 1
  void _decreaseMatchesBadge() {
    try {
      _notificationService ??= NotificationService.shared;
      _notificationService!.decreaseMatchesBadge();
    } catch (error) {
      AppLogger.error('Failed to decrease matches badge', error: error, context: 'MatchesView');
    }
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text("Matches & Introductions"),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const LoadingStateWidget()
            : _matches.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.matches.emptyStateTitle,
                          description: ServerListType.matches.emptyStateDescription,
                          iconName: "nomatches",
                          height: MediaQuery.of(context).size.height * 0.6,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _matches.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _matches.length) {
                        return buildLoadingIndicator();
                      }

                      final match = _matches[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MatchItemView(
                            match: match,
                            shouldBlur: !((ProfileService.shared.currentProfile?.isPro ?? false) || match.isConnected),
                            onMatchSelected: (selectedMatch) {
                              // Mark match as viewed if it wasn't already
                              if (selectedMatch.isViewed != true) {
                                setState(() {
                                  final matchIndex = _matches.indexWhere((m) => m.id == selectedMatch.id);
                                  if (matchIndex != -1) {
                                    _matches[matchIndex] = selectedMatch.copyWith(isViewed: true);
                                  }
                                });

                                // Decrease badge count manually
                                _decreaseMatchesBadge();
                              }

                              Navigator.push(
                                context,
                                platformPageRoute(
                                  context: context,
                                  builder: (context) => MatchDetailView(
                                    matchId: selectedMatch.id,
                                    onMatchRemoved: () {
                                      if (mounted) {
                                        setState(() {
                                          _matches.removeWhere((m) => m.id == selectedMatch.id);
                                        });
                                        // Update badges after match is removed
                                        _fetchBadges();
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      );
                    },
                  ),
      ),
    );
  }
}