import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../widgets/common/empty_state_widget.dart';
import '../models/match.dart';
import '../models/requests/paginated_request.dart';
import '../widgets/common/match_item_view.dart';
import '../services/supabase_manager.dart';
import '../services/session_manager.dart';

/// MatchesView - Matches page with ListView for server data
class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  State<MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  final List<Match> _matches = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMatches();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMorePages) {
      _loadMoreMatches();
    }
  }

  Future<void> _loadMatches({bool forceRefresh = false}) async {
    if (!SessionManager.shared.isAuthenticated) return;

    if (forceRefresh || _matches.isEmpty) {
      setState(() {
        _isLoading = true;
        if (forceRefresh) {
          _matches.clear();
          _hasMorePages = true;
        }
      });

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfMatches,
          list: ServerListType.matches,
        );

        final matches = await SupabaseManager.shared.fetchMatches(request);
        setState(() {
          _matches.addAll(matches);
          _hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
          _isLoading = false;
        });
      } catch (error) {
        debugPrint('Error fetching matches: $error');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreMatches() async {
    if (_matches.isEmpty || !_hasMorePages) return;

    setState(() {
      _isLoadingMore = true;
    });

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
      setState(() {
        _matches.addAll(matches);
        _hasMorePages = matches.length == PaginatedRequest.numberOfMatches;
        _isLoadingMore = false;
      });
    } catch (error) {
      debugPrint('Error loading more matches: $error');
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadMatches(forceRefresh: true);
  }


  @override
  Widget build(BuildContext context) {

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.matches),
      ),
      usePadding: false, // We handle padding manually for the ListView
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
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
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _matches.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _matches.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final match = _matches[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header logic - no headers unlike iOS
                          // if (_shouldShowHeader(match, index))
                          //   _buildHeader(match.status, index == 0),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: MatchItemView(
                              match: match,
                              onMatchSelected: (selectedMatch) {
                                debugPrint(
                                    'Tapped on match: ${selectedMatch.profile.fullName}');
                                // TODO: Navigate to match detail page
                              },
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