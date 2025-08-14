import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/prompt.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/buttons/fab_button.dart';
import 'card_item.dart';
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

class _CardsViewState extends State<CardsView> {
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  // State
  List<Prompt>? _cards;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint('CardsView: initState');
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('CardsView: Loading cards...');
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
      floatingActionButton: FABButton(
        icon: context.themedIcon('edit'),
        label: 'New',
        onPressed: _openAddCardModal,
      ),
      usePadding: true,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: () => _loadCards(forceRefresh: true),
        child: _isLoading
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
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 64,
                    color: context.venyuTheme.secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No cards',
                    style: AppTextStyles.headline.copyWith(
                      color: context.venyuTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You don't have any cards yet.",
                    style: AppTextStyles.body.copyWith(
                      color: context.venyuTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Opens the interaction type selection view for creating a new card
  Future<void> _openAddCardModal() async {
    HapticFeedback.selectionClick();
    debugPrint('CardsView: Opening interaction type selection for new card...');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) {
          debugPrint('CardsView: Building InteractionTypeSelectionView...');
          return const InteractionTypeSelectionView();
        },
      );
      
      debugPrint('CardsView: Card detail view closed with result: $result');
      
      // If card was successfully added, refresh the list
      if (result == true) {
        await _loadCards(forceRefresh: true);
      }
    } catch (error) {
      debugPrint('CardsView: Error opening card detail view: $error');
    }
  }

  /// Navigates to the card detail view for editing an existing card
  Future<void> _navigateToCardDetail(Prompt prompt) async {
    debugPrint('CardsView: Opening card detail view for editing card: ${prompt.label}');
    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) => CardDetailView(existingPrompt: prompt),
      );
      
      debugPrint('CardsView: Card detail view closed with result: $result');
      
      // If card was successfully updated, refresh the list
      if (result == true) {
        await _loadCards(forceRefresh: true);
      }
    } catch (error) {
      debugPrint('CardsView: Error opening card detail view: $error');
    }
  }

  /// Loads cards from the server
  Future<void> _loadCards({bool forceRefresh = false}) async {
    debugPrint('CardsView: _loadCards called, authenticated: ${_sessionManager.isAuthenticated}');
    if (!_sessionManager.isAuthenticated) {
      debugPrint('CardsView: Not authenticated, skipping load');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _cards = [];
        });
      }
      return;
    }
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      debugPrint('CardsView: Fetching cards from Supabase...');
      // Add timeout to prevent hanging
      final fetchedCards = await _supabaseManager.fetchCards().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('CardsView: Fetch cards timeout!');
          return <Prompt>[]; // Return empty list on timeout
        },
      );
      debugPrint('CardsView: Loaded ${fetchedCards.length} cards');
      
      if (mounted) {
        setState(() {
          _cards = fetchedCards;
          _isLoading = false;
        });
      }
      
    } catch (error) {
      debugPrint('CardsView: Error loading cards: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _cards = [];
        });
      }
    }
  }
}