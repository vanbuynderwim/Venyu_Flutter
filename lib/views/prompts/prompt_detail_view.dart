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
import '../../widgets/common/status_badge_view.dart';
import '../../widgets/common/community_guidelines_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../../core/utils/date_extensions.dart';
import '../venues/venue_item_view.dart';
import '../venues/venue_detail_view.dart';
import 'prompt_edit_view.dart';
import '../../services/notification_service.dart';
import '../../widgets/prompts/first_call_settings_widget.dart';
import '../../services/profile_service.dart';

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
  NotificationService? _notificationService;

  Prompt? _prompt;
  List<Match> _matches = [];
  bool _matchesLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _matchingManager = MatchingManager.shared;
    _notificationService = NotificationService.shared;
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
                  shouldShowStatus: false,
                ),
              ),
              const SizedBox(height: 16),

              // Status section with title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SubTitle(
                  iconName: 'report',
                  title: 'Status',
                ),
              ),
              const SizedBox(height: 12),

              // Status info section
              _buildStatusInfoSection(),

              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SubTitle(
                  iconName: 'eye',
                  title: 'First Call',
                ),
              ),
              const SizedBox(height: 12),

              // Prior Preview section
              _buildPreviewSection(),

              const SizedBox(height: 16),

              // Venue section - show if prompt has a venue
              if (_prompt!.venue != null) ...[
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubTitle(
                        iconName: 'venue',
                        title: 'Published in',
                      ),
                      const SizedBox(height: 8),
                      VenueItemView(
                        venue: _prompt!.venue!,
                        onTap: () => _navigateToVenueDetail(_prompt!.venue!.id),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),
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
      // Show empty state for online and offline prompts
      if (_prompt?.displayStatus == PromptStatus.online || _prompt?.displayStatus == PromptStatus.offline) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: EmptyStateWidget(
            message: 'No matches yet',
            description: 'When people match with your card, their profiles will appear here.',
            iconName: 'nomatches',
          ),
        );
      } else {
        // For non-approved prompts, don't show matches section at all
        return const SizedBox.shrink();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Introductions title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SubTitle(
            iconName: 'handshake',
            title: 'Matches & Introductions',
          ),
        ),
        const SizedBox(height: 8),

        // Matches list
        ..._matches.map((match) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: MatchItemView(
            match: match,
            shouldBlur: !((ProfileService.shared.currentProfile?.isPro ?? false) || match.isConnected),
            onMatchSelected: (selectedMatch) => _navigateToMatchDetail(selectedMatch),
          ),
        )),
      ],
    );
  }

  void _navigateToMatchDetail(Match match) {
    AppLogger.ui('Navigating to match detail from prompt: ${match.id}', context: 'PromptDetailView');

    // Mark match as viewed if it wasn't already
    if (match.isViewed != true) {
      setState(() {
        final matchIndex = _matches.indexWhere((m) => m.id == match.id);
        if (matchIndex != -1) {
          _matches[matchIndex] = match.copyWith(isViewed: true);
        }
      });

      // Decrease badge count manually
      _decreaseMatchesBadge();
    }

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchDetailView(matchId: match.id),
      ),
    );
  }

  /// Manually decrease the matches badge count by 1
  void _decreaseMatchesBadge() {
    try {
      _notificationService ??= NotificationService.shared;
      _notificationService!.decreaseMatchesBadge();
    } catch (error) {
      AppLogger.error('Failed to decrease matches badge', error: error, context: 'PromptDetailView');
    }
  }

  void _navigateToVenueDetail(String venueId) {
    AppLogger.ui('Navigating to venue detail from prompt: $venueId', context: 'PromptDetailView');

    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => VenueDetailView(venueId: venueId),
      ),
    );
  }

  Widget _buildStatusInfoSection() {
    if (_prompt?.status == null) return const SizedBox.shrink();

    final status = _prompt!.displayStatus;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: AppLayoutStyles.cardDecoration(context),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            StatusBadgeView(
              status: status,
              compact: false,
            ),
            const SizedBox(height: 12),

            // Status info text
            Text(
              status.statusInfo(_prompt),
              style: AppTextStyles.subheadline.copyWith(
                color: context.venyuTheme.primaryText,
              ),
            ),

            // Additional info for online/offline status
            if (status == PromptStatus.online || status == PromptStatus.offline) ...[
              const SizedBox(height: 16),
              _buildStatusDetails(),
            ],

            // Show community guidelines for rejected status
            if (status == PromptStatus.rejected) ...[
              const SizedBox(height: 16),
              const CommunityGuidelinesWidget(
                showTitle: false,
              ),
            ],

            // Edit button - only show if editing is allowed
            if (status.canEdit) ...[
              const SizedBox(height: 16),
              ActionButton(
                label: 'Edit Card',
                icon: context.themedIcon('edit'),
                onPressed: () => _editPrompt(),
                isCompact: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDetails() {
    if (_prompt == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Reviewed date
        if (_prompt!.reviewedAt != null)
          _buildDetailRow('Online:', _prompt!.reviewedAt!.formatDate(), iconName: 'event'),

        // Expires date
        if (_prompt!.expiresAt != null) ...[
          _buildDetailRow(
            _prompt!.expiresAt!.isBefore(DateTime.now()) ? 'Expired:' : 'Expires:',
            _prompt!.expiresAt!.formatDate(),
            iconName: 'event'
          ),
        ],

        // Match count
        if (_prompt!.matchCount != null)
          _buildDetailRow('Matches:', '${_prompt!.matchCount}', iconName: 'match'),

        // Connection count
        if (_prompt!.connectionCount != null)
          _buildDetailRow('Introductions:', '${_prompt!.connectionCount}', iconName: 'handshake'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {String? iconName}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (iconName != null) ...[
                context.themedIcon(iconName, size: 18, selected: true),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.subheadline.copyWith(
                  color: context.venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: AppTextStyles.subheadline.copyWith(
              color: context.venyuTheme.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        builder: (context) => PromptEditView(
          existingPrompt: _prompt!,
          venueId: _prompt!.venue?.id,
        ),
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

  /// Build the Prior Preview settings section
  Widget _buildPreviewSection() {
    return FirstCallSettingsWidget(
      withPreview: _prompt?.withPreview ?? false,
      showTitle: false,
      onChanged: (value) {
        // Handle toggle change
        _handlePreviewToggle(value);
      },
      isEditing: true, // This is always editing an existing prompt
      hasVenue: _prompt?.venue != null, // Check if prompt has a venue
    );
  }

  /// Handle preview toggle change
  void _handlePreviewToggle(bool value) async {
    if (_prompt?.promptID == null) return;

    AppLogger.debug('Preview toggle changed to: $value for prompt: ${_prompt?.promptID}', context: 'PromptDetailView');

    await executeWithLoading(
      operation: () async {
        await _contentManager.togglePreview(_prompt!.promptID, value);

        // Reload prompt data to get updated state
        await _loadPromptData();

        AppLogger.success('Preview setting updated successfully', context: 'PromptDetailView');
      },
      showSuccessToast: true,
      successMessage: 'Preview setting updated',
      showErrorToast: true,
    );
  }
}