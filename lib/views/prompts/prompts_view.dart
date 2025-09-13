import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/enums/prompt_status.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../core/providers/app_providers.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/buttons/fab_button.dart';
import 'prompt_item.dart';
import 'prompt_edit_view.dart';
import 'prompt_detail_view.dart';
import 'interaction_type_selection_view.dart';

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
        title: Text("Your prompts"),
      ),
      floatingActionButton: _prompts.isNotEmpty
          ? FABButton(
              icon: context.themedIcon('edit'),
              label: 'Get matched',
              onPressed: _openAddPromptModal,
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
                          message: ServerListType.cards.emptyStateTitle,
                          description: ServerListType.cards.emptyStateDescription,
                          iconName: ServerListType.cards.emptyStateIcon,
                          onAction: _openAddPromptModal,
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PromptItem(
                          prompt: prompt,
                          showChevron: true,
                          onPromptSelected: (selectedPrompt) {
                            _navigateToPromptDetail(selectedPrompt);
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }


  /// Opens the interaction type selection view for creating a new prompt
  Future<void> _openAddPromptModal() async {
    HapticFeedback.selectionClick();
    AppLogger.debug('Opening interaction type selection for new card...', context: 'CardsView');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) {
          AppLogger.debug('Building InteractionTypeSelectionView...', context: 'CardsView');
          return const InteractionTypeSelectionView();
        },
      );
      
      AppLogger.debug('Card detail view closed with result: $result', context: 'CardsView');
      
      // If card was successfully added, refresh the list
      if (result == true) {
        await _handleRefresh();
      }
    } catch (error) {
      AppLogger.error('Error opening card detail view: $error', context: 'CardsView');
    }
  }

  /// Handles card selection based on status
  Future<void> _navigateToPromptDetail(Prompt prompt) async {
    AppLogger.debug('Card selected with status: ${prompt.status?.value}', context: 'CardsView');
    
    // Handle different card statuses
    switch (prompt.status) {
      case PromptStatus.draft:
        // Draft cards can be edited directly
        await _openPromptDetailView(prompt);
        break;
        
      case PromptStatus.pendingReview:
        // Show pending review dialog
        await DialogUtils.showInfoDialog(
          context: context,
          title: 'Card under review',
          message: 'Your card is still in review.',
          buttonText: 'OK',
        );
        break;
        
      case PromptStatus.rejected:
        // Show rejected dialog with edit/cancel options
        final shouldEdit = await DialogUtils.showConfirmationDialog(
          context: context,
          title: 'Card rejected',
          message: 'Your card is rejected because it didn\'t follow the community guidelines. Please edit and resubmit.',
          confirmText: 'Edit',
          cancelText: 'Cancel',
          isDestructive: false,
        );
        
        if (shouldEdit) {
          // Update status to draft before opening detail view
          await _updatePromptStatusToDraft(prompt);
        }
        break;
        
      case PromptStatus.approved:
      case PromptStatus.online:
      case PromptStatus.offline:
        // Approved/online/offline cards show matches (read-only)
        await _openPromptMatchesView(prompt);
        break;
        
      case null:
      case PromptStatus.pendingTranslation:
      case PromptStatus.archived:
        // For other statuses, show matches
        await _openPromptMatchesView(prompt);
        break;
    }
  }
  
  /// Updates a rejected prompt's status to draft and opens detail view
  Future<void> _updatePromptStatusToDraft(Prompt prompt) async {
    try {
      AppLogger.debug('Updating prompt ${prompt.promptID} status to draft', context: 'CardsView');
      
      await _contentManager.updatePromptStatus(
        promptId: prompt.promptID,
        status: PromptStatus.draft,
      );
      
      // Refresh cards list to reflect status change
      await _handleRefresh();
      
      // Open detail view for editing
      await _openPromptDetailView(prompt);
      
    } catch (error) {
      AppLogger.error('Error updating prompt status to draft: $error', context: 'CardsView');
      // Show error to user but still try to open detail view
      if (mounted) {
        await DialogUtils.showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to update card status. Please try again.',
        );
      }
    }
  }
  
  /// Opens the prompt detail view for editing
  Future<void> _openPromptDetailView(Prompt prompt) async {
    AppLogger.debug('Opening card detail view for editing card: ${prompt.label}', context: 'CardsView');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) => PromptEditView(existingPrompt: prompt),
      );
      
      AppLogger.debug('Card detail view closed with result: $result', context: 'CardsView');
      
      // If card was successfully updated, refresh the list
      if (result == true) {
        await _handleRefresh();
      }
    } catch (error) {
      AppLogger.error('Error opening card detail view: $error', context: 'CardsView');
    }
  }

  /// Opens the new prompt detail view to show matches
  Future<void> _openPromptMatchesView(Prompt prompt) async {
    AppLogger.debug('Opening card matches view for card: ${prompt.label}', context: 'CardsView');
    try {
      await Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptDetailView(prompt: prompt),
        ),
      );
      
      AppLogger.debug('Card matches view closed', context: 'CardsView');
    } catch (error) {
      AppLogger.error('Error opening card matches view: $error', context: 'CardsView');
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
            limit: PaginatedRequest.numberOfCards,
            list: ServerListType.cards,
          );

          final cards = await _contentManager.fetchCards(request);
          safeSetState(() {
            _prompts.addAll(cards);
            hasMorePages = cards.length == PaginatedRequest.numberOfCards;
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
          limit: PaginatedRequest.numberOfCards,
          cursorId: lastPrompt.promptID,
          cursorTime: lastPrompt.createdAt,
          cursorExpired: lastPrompt.expired,
          list: ServerListType.cards,
        );

        final cards = await _contentManager.fetchCards(request);
        safeSetState(() {
          _prompts.addAll(cards);
          hasMorePages = cards.length == PaginatedRequest.numberOfCards;
          isLoadingMore = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading more cards', context: 'CardsView', error: error);
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