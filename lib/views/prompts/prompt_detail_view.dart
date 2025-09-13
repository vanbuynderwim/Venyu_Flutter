import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/match.dart';
import '../../models/prompt.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../matches/match_item_view.dart';
import '../matches/match_detail_view.dart';
import 'prompt_item.dart';

/// PromptDetailView - Shows a prompt with its associated matches
/// 
/// This view displays:
/// - The prompt at the top (using PromptItem)
/// - List of matches associated with this prompt
/// - Navigation to match details when tapping a match
class PromptDetailView extends StatefulWidget {
  final Prompt prompt;

  const PromptDetailView({
    super.key,
    required this.prompt,
  });

  @override
  State<PromptDetailView> createState() => _PromptDetailViewState();
}

class _PromptDetailViewState extends State<PromptDetailView> with ErrorHandlingMixin {
  late final MatchingManager _matchingManager;
  
  List<Match> _matches = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _loadPromptMatches();
  }

  Future<void> _loadPromptMatches() async {
    if (!mounted) return;
    setState(() => _error = null);
    
    final matches = await executeWithLoadingAndReturn<List<Match>>(
      operation: () => _matchingManager.fetchPromptMatches(widget.prompt.promptID),
      showErrorToast: false,
      onError: (error) {
        if (mounted) {
          setState(() => _error = 'Failed to load matches');
        }
      },
    );
    
    if (matches != null && mounted) {
      setState(() => _matches = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('Prompt matches'),
      ),
      usePadding: true,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: _loadPromptMatches,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const LoadingStateWidget();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            PlatformTextButton(
              onPressed: _loadPromptMatches,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        // Prompt at the top
        PromptItem(
          prompt: widget.prompt,
          reviewing: false,
          isFirst: true,
          isLast: true,
          showMatchInteraction: false,
        ),
        
        const SizedBox(height: 24),
        
        // Matches section header
        if (_matches.isNotEmpty) ...[
          Text(
            '${_matches.length} ${_matches.length == 1 ? 'match' : 'matches'}',
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Matches list
        if (_matches.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'No matches yet for this prompt',
                style: AppTextStyles.body.copyWith(
                  color: context.venyuTheme.secondaryText,
                ),
              ),
            ),
          )
        else
          ..._matches.map((match) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MatchItemView(
              match: match,
              shouldBlur: false, // Don't blur in card detail view
              onMatchSelected: (selectedMatch) => _navigateToMatchDetail(selectedMatch),
            ),
          )),
      ],
    );
  }

  void _navigateToMatchDetail(Match match) {
    AppLogger.ui('Navigating to match detail from prompt: ${match.id}', context: 'PromptDetailView');
    
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchDetailView(matchId: match.id),
      ),
    );
  }
}