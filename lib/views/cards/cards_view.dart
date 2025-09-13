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
import 'card_item.dart';
import 'card_edit_view.dart';
import 'card_detail_view.dart';
import 'interaction_type_selection_view.dart';

/// CardsView - Dedicated view for user's cards and prompts
/// 
/// This view displays the user's cards and prompt responses in a dedicated tab.
/// Previously this content was part of the ProfileView's cards section.
/// 
/// Features:
/// - Display user's cards in a scrollable list
/// - Pull-to-refresh functionality
/// - Empty state when no cards available
/// - Card selection handling
class CardsView extends StatefulWidget {
  const CardsView({super.key});

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> 
    with PaginatedListViewMixin<CardsView>, ErrorHandlingMixin<CardsView> {
  // Services
  late final ContentManager _contentManager;
  
  // State
  final List<Prompt> _cards = [];

  @override
  void initState() {
    super.initState();
    AppLogger.debug('initState', context: 'CardsView');
    _contentManager = ContentManager.shared;
    initializePagination();
    _loadCards();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMoreCards();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text("Your cards"),
      ),
      floatingActionButton: _cards.isNotEmpty
          ? FABButton(
              icon: context.themedIcon('edit'),
              label: 'Get matched',
              onPressed: _openAddCardModal,
            )
          : null,
      usePadding: true,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const LoadingStateWidget()
            : _cards.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.cards.emptyStateTitle,
                          description: ServerListType.cards.emptyStateDescription,
                          iconName: ServerListType.cards.emptyStateIcon,
                          onAction: _openAddCardModal,
                          actionText: "Get matched",
                          actionButtonIcon: context.themedIcon('edit'),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _cards.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _cards.length) {
                        return buildLoadingIndicator();
                      }

                      final prompt = _cards[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardItem(
                          prompt: prompt,
                          showChevron: true,
                          onCardSelected: (selectedPrompt) {
                            _navigateToCardDetail(selectedPrompt);
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }


  /// Opens the interaction type selection view for creating a new card
  Future<void> _openAddCardModal() async {
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
  Future<void> _navigateToCardDetail(Prompt prompt) async {
    AppLogger.debug('Card selected with status: ${prompt.status?.value}', context: 'CardsView');
    
    // Handle different card statuses
    switch (prompt.status) {
      case PromptStatus.draft:
        // Draft cards can be edited directly
        await _openCardDetailView(prompt);
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
        await _openCardMatchesView(prompt);
        break;
        
      case null:
      case PromptStatus.pendingTranslation:
      case PromptStatus.archived:
        // For other statuses, show matches
        await _openCardMatchesView(prompt);
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
      await _openCardDetailView(prompt);
      
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
  
  /// Opens the card detail view for editing
  Future<void> _openCardDetailView(Prompt prompt) async {
    AppLogger.debug('Opening card detail view for editing card: ${prompt.label}', context: 'CardsView');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) => CardEditView(existingPrompt: prompt),
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

  /// Opens the new card detail view to show matches
  Future<void> _openCardMatchesView(Prompt prompt) async {
    AppLogger.debug('Opening card matches view for card: ${prompt.label}', context: 'CardsView');
    try {
      await Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => CardDetailView(prompt: prompt),
        ),
      );
      
      AppLogger.debug('Card matches view closed', context: 'CardsView');
    } catch (error) {
      AppLogger.error('Error opening card matches view: $error', context: 'CardsView');
    }
  }

  Future<void> _loadCards({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _cards.isEmpty) {
      if (forceRefresh) {
        safeSetState(() {
          _cards.clear();
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
            _cards.addAll(cards);
            hasMorePages = cards.length == PaginatedRequest.numberOfCards;
          });
        },
        showSuccessToast: false,
        showErrorToast: false,  // Silent load for initial data
      );
    }
  }

  Future<void> _loadMoreCards() async {
    if (_cards.isEmpty || !hasMorePages) return;

    safeSetState(() {
      isLoadingMore = true;
    });

    await executeSilently(
      operation: () async {
        final lastCard = _cards.last;
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfCards,
          cursorId: lastCard.promptID,
          cursorTime: lastCard.createdAt,
          cursorExpired: lastCard.expired,
          list: ServerListType.cards,
        );

        final cards = await _contentManager.fetchCards(request);
        safeSetState(() {
          _cards.addAll(cards);
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
    await _loadCards(forceRefresh: true);
  }
}