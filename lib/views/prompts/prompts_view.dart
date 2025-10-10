import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/helpers/get_matched_helper.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../core/providers/app_providers.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/buttons/get_matched_button.dart';
import 'prompt_item.dart';
import 'prompt_detail_view.dart';

/// PromptsView - Dedicated view for user's prompts
/// 
/// This view displays the user's prompts and prompt responses in a dedicated tab.
/// Previously this content was part of the ProfileView's cards section.
/// 
/// Features:
/// - Display user's prompts in a scrollable list
/// - Pull-to-refresh functionality
/// - Empty state when no prompts available
/// - Prompt selection handling
class PromptsView extends StatefulWidget {
  const PromptsView({super.key});

  @override
  State<PromptsView> createState() => _PromptsViewState();
}

class _PromptsViewState extends State<PromptsView>
    with PaginatedListViewMixin<PromptsView>, ErrorHandlingMixin<PromptsView> {
  // Services
  late final ContentManager _contentManager;
  
  // State
  final List<Prompt> _prompts = [];

  @override
  void initState() {
    super.initState();
    AppLogger.debug('initState', context: 'PromptsView');
    _contentManager = ContentManager.shared;
    initializePagination();
    _loadPrompts();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMorePrompts();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text("Your cards"),
      ),
      floatingActionButton: _prompts.isNotEmpty
          ? GetMatchedButton(
              buttonType: GetMatchedButtonType.fab,
              onModalClosed: (result) {
                if (result == true) {
                  AppLogger.debug('Prompt creation completed, refreshing list', context: 'PromptsView');
                  _handleRefresh();
                }
              },
            )
          : null,
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
                          message: ServerListType.profilePrompts.emptyStateTitle(context),
                          description: ServerListType.profilePrompts.emptyStateDescription(context),
                          iconName: ServerListType.profilePrompts.emptyStateIcon,
                          onAction: () => _handleGetMatchedPressed(),
                          actionText: "Get matched",
                          actionButtonIcon: context.themedIcon('edit'),
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
                      return PromptItem(
                        prompt: prompt,
                        showChevron: true,
                        showCounters: true,
                        onPromptSelected: _openPromptDetail,
                      );
                    },
                  ),
      ),
    );
  }


  /// Handles the Get Matched button press (both FAB and EmptyState button)
  Future<void> _handleGetMatchedPressed() async {
    final result = await GetMatchedHelper.openGetMatchedModal(
      context: context,
      callerContext: 'PromptsView',
    );

    // If prompt was successfully added, refresh the list
    if (result == true) {
      await _handleRefresh();
    }
  }

  

  /// Opens the new prompt detail view to show matches
  Future<void> _openPromptDetail(Prompt prompt) async {
    AppLogger.debug('Opening prompt detail view for prompt: ${prompt.label}', context: 'PromptsView');
    try {
      await Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptDetailView(promptId: prompt.promptID),
        ),
      );

      AppLogger.debug('Prompt detail view closed', context: 'PromptsView');
    } catch (error) {
      AppLogger.error('Error opening prompt detail view: $error', context: 'PromptsView');
    }
  }

  Future<void> _loadPrompts({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _prompts.isEmpty) {
      if (forceRefresh) {
        safeSetState(() {
          _prompts.clear();
          hasMorePages = true;
        });
      }

      await executeWithLoading(
        operation: () async {
          final request = PaginatedRequest(
            limit: PaginatedRequest.numberOfPrompts,
            list: ServerListType.profilePrompts,
          );

          final prompts = await _contentManager.fetchProfilePrompts(request);
          safeSetState(() {
            _prompts.addAll(prompts);
            hasMorePages = prompts.length == PaginatedRequest.numberOfPrompts;
          });
        },
        showSuccessToast: false,
        showErrorToast: false,  // Silent load for initial data
      );
    }
  }

  Future<void> _loadMorePrompts() async {
    if (_prompts.isEmpty || !hasMorePages) return;

    safeSetState(() {
      isLoadingMore = true;
    });

    await executeSilently(
      operation: () async {
        final lastPrompt = _prompts.last;
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfPrompts,
          cursorId: lastPrompt.promptID,
          cursorTime: lastPrompt.createdAt,
          list: ServerListType.profilePrompts,
        );

        final prompts = await _contentManager.fetchProfilePrompts(request);
        safeSetState(() {
          _prompts.addAll(prompts);
          hasMorePages = prompts.length == PaginatedRequest.numberOfPrompts;
          isLoadingMore = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading more prompts', context: 'PromptsView', error: error);
        safeSetState(() {
          isLoadingMore = false;
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    await _loadPrompts(forceRefresh: true);
  }
}