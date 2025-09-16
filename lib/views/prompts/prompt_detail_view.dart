import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
// import '../../models/enums/prompt_sections.dart';
import '../../models/prompt.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import 'prompt_item.dart';
// import 'prompt_detail/prompt_section_button_bar.dart';
// import 'prompt_detail/prompt_card_section.dart';
// import 'prompt_detail/prompt_stats_section.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../models/match.dart';
import '../matches/match_detail_view.dart';
import '../matches/match_item_view.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/prompt_status.dart';
import 'prompt_edit_view.dart';

/// PromptDetailView - Shows a prompt with its associated matches
/// 
/// This view displays:
/// - The prompt at the top (using PromptItem)
/// - List of matches associated with this prompt
/// - Navigation to match details when tapping a match
class PromptDetailView extends StatefulWidget {
  final String promptId;

  const PromptDetailView({
    super.key,
    required this.promptId,
  });

  @override
  State<PromptDetailView> createState() => _PromptDetailViewState();
}

class _PromptDetailViewState extends State<PromptDetailView> with ErrorHandlingMixin {
  late final ContentManager _contentManager;
  late final MatchingManager _matchingManager;

  Prompt? _prompt;
  List<Match> _matches = [];
  bool _matchesLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _matchingManager = MatchingManager.shared;
    _loadPromptData();
  }

  Future<void> _loadPromptData() async {
    if (!mounted) return;
    setState(() => _error = null);

    await executeWithLoading(
      operation: () async {
        // Fetch the prompt
        final prompt = await _contentManager.fetchPrompt(widget.promptId);

        if (prompt != null && mounted) {
          setState(() => _prompt = prompt);
          // Load matches after prompt is loaded
          _loadMatches();
        } else if (mounted) {
          setState(() => _error = 'Failed to load prompt');
        }
      },
      showErrorToast: false,
      onError: (error) {
        AppLogger.error('Error loading prompt data: $error', context: 'PromptDetailView');
        if (mounted) {
          setState(() => _error = 'Failed to load prompt data');
        }
      },
    );
  }

  Future<void> _loadMatches() async {
    if (_prompt == null) return;

    try {
      AppLogger.debug('Loading matches for prompt: ${_prompt!.promptID}', context: 'PromptDetailView');

      final matches = await _matchingManager.fetchPromptMatches(_prompt!.promptID).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.warning('fetchPromptMatches timed out', context: 'PromptDetailView');
          return <Match>[];
        },
      );

      AppLogger.debug('Received ${matches.length} matches', context: 'PromptDetailView');

      if (mounted) {
        setState(() {
          _matches = matches;
          _matchesLoaded = true;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading matches: $e', context: 'PromptDetailView');
      if (mounted) {
        setState(() {
          _matches = [];
          _matchesLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('Your card'),
      ),
      usePadding: false,
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: _loadPromptData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32.0),
          children: [
            // Prompt item header (scrolls with content)
            if (_prompt != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PromptItem(
                  prompt: _prompt!,
                  reviewing: false,
                  isFirst: true,
                  isLast: true,
                  showMatchInteraction: false,
                ),
              ),
              const SizedBox(height: 16),

              // Status info section
              _buildStatusInfoSection(),
              const SizedBox(height: 16),
            ],

            // Section button bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: PromptSectionButtonBar(
            //     selectedSection: _selectedSection,
            //     onSectionSelected: (section) {
            //       setState(() {
            //         _selectedSection = section;
            //       });
            //     },
            //   ),
            // ),

            // const SizedBox(height: 16),

            // Matches content
            _buildMatchesContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesContent() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingStateWidget(),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          children: [
            Text(
              _error!,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadPromptData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show loading while matches are being loaded
    if (!_matchesLoaded) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingStateWidget(),
      );
    }

    // Show matches content
    if (_matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: EmptyStateWidget(
          message: 'No matches yet',
          description: 'When people match with your card, their profiles will appear here.',
          iconName: 'nomatches',
        ),
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
            shouldBlur: false,
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

  Widget _buildStatusInfoSection() {
    if (_prompt?.status == null) return const SizedBox.shrink();

    final status = _prompt!.status!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: AppLayoutStyles.cardDecoration(context),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status info text
            Text(
              status.statusInfo,
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.primaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Edit button
            ActionButton(
              label: 'Edit Card',
              onPressed: status.canEdit ? () => _editPrompt() : null,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }

  void _editPrompt() async {
    if (_prompt == null) return;

    AppLogger.debug('Opening prompt edit view for: ${_prompt!.label}', context: 'PromptDetailView');

    try {
      final result = await showPlatformModalSheet<bool>(
        context: context,
        material: MaterialModalSheetData(
          isScrollControlled: true,
          useSafeArea: true,
        ),
        builder: (context) => PromptEditView(existingPrompt: _prompt!),
      );

      if (result == true) {
        AppLogger.debug('Prompt updated, refreshing data', context: 'PromptDetailView');
        // Refresh the prompt data after edit
        _loadPromptData();
      }
    } catch (error) {
      AppLogger.error('Error opening prompt edit view: $error', context: 'PromptDetailView');
    }
  }
}