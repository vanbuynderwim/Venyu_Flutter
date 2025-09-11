import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/enums/prompt_status.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/prompt.dart';
import '../../core/providers/app_providers.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/fab_button.dart';
import 'card_item.dart';
import 'card_detail_view.dart';
import 'interaction_type_selection_view.dart';
import '../../widgets/common/empty_state_widget.dart';

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

class _CardsViewState extends State<CardsView> with ErrorHandlingMixin {
  // Services
  late final ContentManager _contentManager;
  
  // State
  List<Prompt>? _cards;

  @override
  void initState() {
    super.initState();
    AppLogger.debug('initState', context: 'CardsView');
    _contentManager = ContentManager.shared;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLogger.debug('Loading cards...', context: 'CardsView');
      _loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Back to original AppScaffold approach but with FAB support
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.cards),
      ),
      floatingActionButton: _cards != null && _cards!.isNotEmpty
          ? FABButton(
              icon: context.themedIcon('edit'),
              label: 'New',
              onPressed: _openAddCardModal,
            )
          : null,
      usePadding: true,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: () => _loadCards(forceRefresh: true),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildCardsContent(),
      ),
    );
  }

  /// Builds the cards content - list or empty state
  Widget _buildCardsContent() {
    if (_cards == null || _cards!.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _cards!.length,
      itemBuilder: (context, index) {
        final prompt = _cards![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CardItem(
            prompt: prompt,
            onCardSelected: (selectedPrompt) {
              _navigateToCardDetail(selectedPrompt);
            },
          ),
        );
      },
    );
  }

  /// Builds the empty state when no cards are available
  Widget _buildEmptyState() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: EmptyStateWidget(
            message: "Ready to get matched?",
            description: "Cards open the door to meaningful introductions. Add yours and match with the right people.",
            iconName: "nocards",
            onAction: _openAddCardModal,
            actionText: "Add card",
            actionButtonIcon: context.themedIcon('edit'),
          ),
        ),
      ],
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
        await _loadCards(forceRefresh: true);
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
        // Show approved dialog
        await DialogUtils.showInfoDialog(
          context: context,
          title: 'Card approved',
          message: 'Your card has been approved and can not be changed.',
          buttonText: 'OK',
        );
        break;
        
      case null:
      case PromptStatus.pendingTranslation:
      case PromptStatus.archived:
        // For other statuses, open detail view
        await _openCardDetailView(prompt);
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
      await _loadCards(forceRefresh: true);
      
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
        builder: (context) => CardDetailView(existingPrompt: prompt),
      );
      
      AppLogger.debug('Card detail view closed with result: $result', context: 'CardsView');
      
      // If card was successfully updated, refresh the list
      if (result == true) {
        await _loadCards(forceRefresh: true);
      }
    } catch (error) {
      AppLogger.error('Error opening card detail view: $error', context: 'CardsView');
    }
  }

  /// Loads cards from the server
  Future<void> _loadCards({bool forceRefresh = false}) async {
    final authService = context.authService;
    AppLogger.debug('_loadCards called, authenticated: ${authService.isAuthenticated}', context: 'CardsView');
    if (!authService.isAuthenticated) {
      AppLogger.debug('Not authenticated, skipping load', context: 'CardsView');
      safeSetState(() {
        _cards = [];
      });
      return;
    }
    
    final fetchedCards = await executeWithLoadingAndReturn<List<Prompt>>(
      operation: () async {
        AppLogger.debug('Fetching cards from Supabase...', context: 'CardsView');
        // Add timeout to prevent hanging
        return await _contentManager.fetchCards().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            AppLogger.warning('Fetch cards timeout!', context: 'CardsView');
            return <Prompt>[]; // Return empty list on timeout
          },
        );
      },
      defaultValue: <Prompt>[],
      showErrorToast: false,  // Don't show error toast for silent refresh
    );
    
    if (fetchedCards != null) {
      AppLogger.success('Loaded ${fetchedCards.length} cards', context: 'CardsView');
      safeSetState(() {
        _cards = fetchedCards;
      });
    }
  }
}