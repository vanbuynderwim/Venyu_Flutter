import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

    setState(() => _error = null);

    final matches = await executeWithLoadingAndReturn<List<Match>>(
      operation: () => _matchingManager.fetchPromptMatches(widget.prompt!.promptID),
      showErrorToast: false,
      onError: (error) {
        AppLogger.error('Error loading matches: $error', context: 'PromptIntroSection');
        if (mounted) {
          setState(() => _error = 'Failed to load matches');
        }
      },
    );

    if (matches != null && mounted) {
      setState(() {
        _matches = matches;
        _matchesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _error!,
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
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    if (_matches.isEmpty) {
      return EmptyStateWidget(
        message: 'No matches yet',
        description: 'When people match with your card, their profiles will appear here.',
        iconName: 'couple',
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