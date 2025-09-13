import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/utils/app_logger.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../cards/card_item.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_managers/venue_manager.dart';
import '../../core/providers/app_providers.dart';
import '../../mixins/paginated_list_view_mixin.dart';

/// VenuePromptsView - Paginated list of venue prompts
/// 
/// This view displays all approved prompts for a specific venue using pagination.
/// Only venue admins can access this view to see the prompt list.
/// Uses the same styling as CardsView for consistency.
/// 
/// Features:
/// - Paginated prompt loading
/// - Pull-to-refresh functionality  
/// - Card-style prompt display
/// - Empty state handling
/// - Error state management
class VenuePromptsView extends StatefulWidget {
  final String venueId;
  final String venueName;

  const VenuePromptsView({
    super.key,
    required this.venueId,
    required this.venueName,
  });

  @override
  State<VenuePromptsView> createState() => _VenuePromptsViewState();
}

class _VenuePromptsViewState extends State<VenuePromptsView> 
    with PaginatedListViewMixin<VenuePromptsView> {
  // Services
  late final VenueManager _venueManager;
  
  // State
  final List<Prompt> _prompts = [];

  @override
  void initState() {
    super.initState();
    _venueManager = VenueManager.shared;
    initializePagination();
    _loadPrompts();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMorePrompts();
  }

  Future<void> _loadPrompts({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _prompts.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = true;
          if (forceRefresh) {
            _prompts.clear();
            hasMorePages = true;
          }
        });
      }

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfMatches,
          list: ServerListType.matches,
        );

        final prompts = await _venueManager.fetchVenuePrompts(widget.venueId, request);
        if (mounted) {
          setState(() {
            _prompts.addAll(prompts);
            hasMorePages = prompts.length == PaginatedRequest.numberOfMatches;
            isLoading = false;
          });
        }
      } catch (error) {
        AppLogger.error('Error fetching venue prompts', context: 'VenuePromptsView', error: error);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loadMorePrompts() async {
    if (_prompts.isEmpty || !hasMorePages) return;

    if (mounted) {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final lastPrompt = _prompts.last;
      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfMatches,
        cursorId: lastPrompt.promptID,
        cursorTime: lastPrompt.createdAt,
        list: ServerListType.matches,
      );

      final prompts = await _venueManager.fetchVenuePrompts(widget.venueId, request);
      if (mounted) {
        setState(() {
          _prompts.addAll(prompts);
          hasMorePages = prompts.length == PaginatedRequest.numberOfMatches;
          isLoadingMore = false;
        });
      }
    } catch (error) {
      AppLogger.error('Error loading more venue prompts', context: 'VenuePromptsView', error: error);
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadPrompts(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('${widget.venueName} Cards'),
      ),
      usePadding: true,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const LoadingStateWidget()
            : _prompts.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: 'No cards found',
                          description: 'This venue doesn\'t have any cards yet.',
                          iconName: "nocards",
                          height: MediaQuery.of(context).size.height * 0.6,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _prompts.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _prompts.length) {
                        return buildLoadingIndicator();
                      }

                      final prompt = _prompts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardItem(
                          prompt: prompt,
                          onCardSelected: (selectedPrompt) {
                            AppLogger.debug('Prompt tapped: ${selectedPrompt.label}', context: 'VenuePromptsView');
                            // TODO: Navigate to card detail view if needed
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}