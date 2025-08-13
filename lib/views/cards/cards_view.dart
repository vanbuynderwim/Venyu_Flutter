import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/prompt.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_manager.dart';
import 'card_item.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

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
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.cards),
      ),
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
    
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: _cards!.map((prompt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CardItem(
            prompt: prompt,
            onCardSelected: (selectedPrompt) {
              // TODO: Handle card selection (navigate to detail view)
              debugPrint('Card selected: ${selectedPrompt.label}');
            },
          ),
        );
      }).toList(),
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

  /// Loads cards from the server
  Future<void> _loadCards({bool forceRefresh = false}) async {
    if (!_sessionManager.isAuthenticated) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      _cards = await _supabaseManager.fetchCards();
      
      setState(() {
        _isLoading = false;
      });
      
    } catch (error) {
      debugPrint('Error loading cards: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }
}