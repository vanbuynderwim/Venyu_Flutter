import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../mixins/error_handling_mixin.dart';
import '../../../models/match.dart';
import '../../../models/prompt.dart';
import '../../../services/supabase_managers/matching_manager.dart';
import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../matches/match_detail_view.dart';
import '../../matches/match_item_view.dart';

/// PromptIntroSection - Displays matches and introductions for this prompt
///
/// This widget shows all the matches generated from this prompt including:
/// - List of matches with match details
/// - Navigation to individual match detail views
/// - Loading and empty states
///
/// Features:
/// - Lazy loading of matches when section is selected
/// - Match interaction handling
/// - Error state management
/// - Refresh capability
class PromptIntroSection extends StatefulWidget {
  final Prompt? prompt;
  final bool isLoading;

  const PromptIntroSection({
    super.key,
    required this.prompt,
    required this.isLoading,
  });

  @override
  State<PromptIntroSection> createState() => _PromptIntroSectionState();
}

class _PromptIntroSectionState extends State<PromptIntroSection> with ErrorHandlingMixin {
  late final MatchingManager _matchingManager;

  List<Match> _matches = [];
  bool _matchesLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _loadMatches();
  }

  @override
  void didUpdateWidget(PromptIntroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload matches if prompt changed
    if (oldWidget.prompt?.promptID != widget.prompt?.promptID) {
      _matches.clear();
      _matchesLoaded = false;
      _loadMatches();
    }
  }

  Future<void> _loadMatches() async {
    if (widget.prompt == null || _matchesLoaded) return;

    setState(() {
      _error = null;
    });

    AppLogger.debug('Starting to load matches for prompt: ${widget.prompt!.promptID}', context: 'PromptIntroSection');

    try {
      // Use simple approach without executeWithLoadingAndReturn to avoid loading state issues
      final matches = await _matchingManager.fetchPromptMatches(widget.prompt!.promptID).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.warning('fetchPromptMatches timed out after 10 seconds', context: 'PromptIntroSection');
          return <Match>[]; // Return empty list on timeout
        },
      );

      AppLogger.debug('Received ${matches.length} matches', context: 'PromptIntroSection');

      if (mounted) {
        setState(() {
          _matches = matches;
          _matchesLoaded = true;
        });
      }
    } catch (e) {
      AppLogger.error('Exception loading matches: $e', context: 'PromptIntroSection');
      if (mounted) {
        setState(() {
          _matches = [];
          _matchesLoaded = true;
          _error = 'Failed to load matches';
        });
      }
    }

    AppLogger.debug('Finished loading matches, matchesLoaded: $_matchesLoaded', context: 'PromptIntroSection');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    AppLogger.debug(
      'PromptIntroSection build: widget.isLoading=${widget.isLoading}, '
      'widget.prompt=${widget.prompt?.label}, '
      'isLoading=$isLoading, '
      'matchesLoaded=$_matchesLoaded, '
      'matches.length=${_matches.length}, '
      'error=$_error',
      context: 'PromptIntroSection'
    );

    if (widget.isLoading || widget.prompt == null) {
      return const LoadingStateWidget();
    }

    if (isLoading) {
      return const LoadingStateWidget();
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              l10n.promptIntroErrorMessage,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _matchesLoaded = false;
                });
                _loadMatches();
              },
              child: Text(l10n.promptIntroRetryButton),
            ),
          ],
        ),
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context)!;

    if (_matches.isEmpty) {
      return EmptyStateWidget(
        message: l10n.promptIntroEmptyTitle,
        description: l10n.promptIntroEmptyDescription,
        iconName: 'match_regular',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Matches list
        ..._matches.map((match) => Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: MatchItemView(
            match: match,
            shouldBlur: false, // Don't blur in prompt detail view
            onMatchSelected: (selectedMatch) => _navigateToMatchDetail(selectedMatch),
          ),
        )),
      ],
    );
  }

  void _navigateToMatchDetail(Match match) {
    AppLogger.ui('Navigating to match detail from prompt: ${match.id}', context: 'PromptIntroSection');

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchDetailView(matchId: match.id),
      ),
    );
  }
}