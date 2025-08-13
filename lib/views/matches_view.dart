import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/venyu_theme.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../widgets/common/empty_state_widget.dart';
import '../models/match.dart';
import '../models/enums/match_status.dart';
import '../models/requests/paginated_request.dart';
import '../widgets/common/match_item_view.dart';
import '../services/supabase_manager.dart';
import '../services/session_manager.dart';
import '../mixins/paginated_list_view_mixin.dart';
import 'matches/match_detail_view.dart';

/// MatchesView - Matches page with ListView for server data
class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  State<MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> 
    with PaginatedListViewMixin<MatchesView> {
  final List<Match> _matches = [];

  @override
  void initState() {
    super.initState();
    initializePagination();
    _loadMatches();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMoreMatches();
  }

  Future<void> _loadMatches({bool forceRefresh = false}) async {
    if (!SessionManager.shared.isAuthenticated) return;

    if (forceRefresh || _matches.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = true;
          if (forceRefresh) {
            _matches.clear();
            hasMorePages = true;
          }
        });
      }

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfMatches,
          list: ServerListType.matches,
        );

        final matches = await SupabaseManager.shared.fetchMatches(request);
        if (mounted) {
          setState(() {
            _matches.addAll(matches);
            hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
            isLoading = false;
          });
        }
      } catch (error) {
        debugPrint('Error fetching matches: $error');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loadMoreMatches() async {
    if (_matches.isEmpty || !hasMorePages) return;

    if (mounted) {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final lastMatch = _matches.last;
      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfMatches,
        cursorId: lastMatch.id,
        cursorTime: lastMatch.updatedAt,
        cursorStatus: lastMatch.status,
        list: ServerListType.matches,
      );

      final matches = await SupabaseManager.shared.fetchMatches(request);
      if (mounted) {
        setState(() {
          _matches.addAll(matches);
          hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
          isLoadingMore = false;
        });
      }
    } catch (error) {
      debugPrint('Error loading more matches: $error');
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadMatches(forceRefresh: true);
  }

  bool _shouldShowDivider(int index) {
    // Check if we have at least 2 items and we're not at the last item
    if (_matches.length < 2 || index >= _matches.length - 1) return false;
    
    final currentMatch = _matches[index];
    final nextMatch = _matches[index + 1];
    
    // Debug logging
    debugPrint('Checking divider at index $index: current=${currentMatch.status.value}, next=${nextMatch.status.value}');
    
    return currentMatch.status == MatchStatus.matched && 
           nextMatch.status == MatchStatus.connected;
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.matches),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _matches.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.matches.emptyStateTitle,
                          description: ServerListType.matches.emptyStateDescription,
                          iconName: ServerListType.matches.emptyStateIcon,
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
                            onMatchSelected: (selectedMatch) {
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
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          if (_shouldShowDivider(index))
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: context.venyuTheme.borderColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Connections',
                                      style: AppTextStyles.subheadline.copyWith(
                                        color: context.venyuTheme.primaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: context.venyuTheme.borderColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}