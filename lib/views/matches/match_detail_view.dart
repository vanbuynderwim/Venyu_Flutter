import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../services/rating_service.dart';
import '../../core/providers/app_providers.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/avatar_fullscreen_viewer.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../widgets/menus/menu_option_builder.dart';
import '../profile/profile_header.dart';
import 'match_detail/match_connections_section.dart';
import 'match_detail/match_prompts_section.dart';
import '../../widgets/common/sub_title.dart';
import 'match_detail/match_tags_section.dart';
import 'match_detail/match_venues_section.dart';
import 'match_detail/match_preview_indicator.dart';
import 'match_detail/match_score_section.dart';
import 'match_detail/match_stages_view.dart';
import 'match_reach_out_view.dart';

/// Enum for match menu actions
enum _MatchAction { report, remove, block }

/// MatchDetailView - Detailed view of a match showing profile, prompts, connections, and tags
/// 
/// This view displays comprehensive information about a match including:
/// - Profile header with avatar, bio, and sectors
/// - Matching prompts/cards
/// - Shared connections (for connected matches)
/// - Shared tag groups
/// 
/// Based on iOS MatchDetailView structure with theme-aware styling.
class MatchDetailView extends StatefulWidget {
  final String matchId;
  final VoidCallback? onMatchRemoved;
  final void Function(Stage stage)? onStageUpdated;

  const MatchDetailView({
    super.key,
    required this.matchId,
    this.onMatchRemoved,
    this.onStageUpdated,
  });

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<MatchDetailView> with ErrorHandlingMixin {
  // Services
  late final MatchingManager _matchingManager;
  
  // State
  Match? _match;
  String? _error;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _loadMatchDetail();
  }

  Future<void> _loadMatchDetail() async {
    setState(() => _error = null);

    final match = await executeWithLoadingAndReturn<Match>(
      operation: () => _matchingManager.fetchMatchDetail(widget.matchId),
      showErrorToast: false,  // We show custom error UI
      onError: (error) {
        final l10n = AppLocalizations.of(context)!;
        setState(() => _error = l10n.matchDetailErrorLoad);
      },
    );

    if (match != null) {
      setState(() => _match = match);

      // Request app rating if match has no stage (first time viewing) and user hasn't been asked before
      // This is a positive moment to ask for a rating
      if (match.stage == null) {
        _requestAppRatingIfAppropriate();
      }
    }
  }

  /// Request app rating at an appropriate moment (when match is connected)
  Future<void> _requestAppRatingIfAppropriate() async {
    try {
      // Small delay to let the UI settle first
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        await RatingService.shared.requestReview();
      }
    } catch (error) {
      // Silently fail - rating is not critical
      AppLogger.debug('Rating request failed: $error', context: 'MatchDetailView');
    }
  }

  /// Shows the match menu using centralized DialogUtils component
  Future<void> _showMatchMenu(BuildContext context) async {
    final menuOptions = _buildMatchMenuOptions(context);
    final actions = _buildMatchActions();

    // Show the menu using centralized DialogUtils
    final selectedAction = await DialogUtils.showMenuModalSheet<_MatchAction>(
      context: context,
      menuOptions: menuOptions,
      actions: actions,
    );

    // Sheet is now closed - perform the action
    if (!context.mounted) return;

    switch (selectedAction) {
      case _MatchAction.report:
        await _handleReportMatch();
        break;
      case _MatchAction.remove:
        await _handleRemoveMatch();
        break;
      case _MatchAction.block:
        await _handleBlockMatch();
        break;
      case null:
        // User cancelled or tapped outside
        break;
    }
  }

  /// Builds the match menu options for DialogUtils
  List<PopupMenuOption> _buildMatchMenuOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<PopupMenuOption> options = [];

    // Report option (always available)
    options.add(
      MenuOptionBuilder.create(
        context: context,
        label: l10n.matchDetailMenuReport,
        iconName: 'report',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
        isDestructive: true,
      ),
    );

    // Remove option (only for connections)
    options.add(
        MenuOptionBuilder.create(
          context: context,
          label: l10n.matchDetailMenuRemove,
          iconName: 'delete',
          onTap: (_) {},  // Dummy onTap, handled by DialogUtils
          isDestructive: true,
        ),
      );

    // Block option (always available)
    options.add(
      MenuOptionBuilder.create(
        context: context,
        label: l10n.matchDetailMenuBlock,
        iconName: 'blocked',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
        isDestructive: true,
      ),
    );

    return options;
  }

  /// Builds the corresponding actions list for DialogUtils
  List<_MatchAction> _buildMatchActions() {
    final List<_MatchAction> actions = [];

    // Report option (always available)
    actions.add(_MatchAction.report);

    // Remove option (only for connections)
    actions.add(_MatchAction.remove);

    // Block option (always available)
    actions.add(_MatchAction.block);

    return actions;
  }

  /// Handles reporting a match
  Future<void> _handleReportMatch() async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Report match tapped for match: ${widget.matchId}', context: 'MatchDetailView');

    await executeWithLoading(
      operation: () async {
        await _matchingManager.reportProfile(_match!.profile.id);
        AppLogger.success('Profile reported successfully for match: ${widget.matchId}', context: 'MatchDetailView');
      },
      showSuccessToast: true,
      successMessage: l10n.matchDetailReportSuccess,
      showErrorToast: true,
    );
  }

  /// Handles blocking a match
  Future<void> _handleBlockMatch() async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Block match tapped for match: ${widget.matchId}', context: 'MatchDetailView');

    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.matchDetailBlockTitle,
      message: l10n.matchDetailBlockMessage,
      confirmText: l10n.matchDetailBlockButton,
      isDestructive: true,
    );

    if (confirmed) {
      await executeWithLoading(
        operation: () async {
          await _matchingManager.blockProfile(_match!.profile.id);
          AppLogger.success('Profile blocked successfully for match: ${widget.matchId}', context: 'MatchDetailView');

          // Call the callback to notify parent that match was removed
          widget.onMatchRemoved?.call();

          // Go back to previous screen
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        showSuccessToast: true,
        successMessage: l10n.matchDetailBlockSuccess,
        showErrorToast: true,
      );
    }
  }

  /// Handles removing a match
  Future<void> _handleRemoveMatch() async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Remove match tapped for match: ${widget.matchId}', context: 'MatchDetailView');
    final matchType = l10n.matchDetailTypeMatch;

    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.matchDetailRemoveTitle,
      message: l10n.matchDetailRemoveMessage(matchType),
      confirmText: l10n.matchDetailRemoveButton,
      isDestructive: true,
    );

    if (confirmed) {
      await executeWithLoading(
        operation: () async {
          await _matchingManager.removeMatch(widget.matchId);
          AppLogger.success('Match removed successfully: ${widget.matchId}', context: 'MatchDetailView');

          // Call the callback to notify parent that match was removed
          widget.onMatchRemoved?.call();

          // Go back to previous screen
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        showSuccessToast: true,
        successMessage: l10n.matchDetailRemoveSuccessMatch,
        showErrorToast: true,
      );
    }
  }

  /// Build the bottom section - either action buttons or upgrade prompt
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
   
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_match == null
          ? l10n.matchDetailLoading
          : l10n.matchDetailTitleMatch),
        trailingActions: _match != null
          ? [
              GestureDetector(
                onTap: () => _showMatchMenu(context),
                child: Icon(
                  PlatformIcons(context).ellipsis,
                  color: context.venyuTheme.primaryText,
                ),
              ),
            ]
          : null,
      ),
      usePadding: false,
      useSafeArea: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator(
                  onRefresh: _loadMatchDetail,
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context)!;

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
              onPressed: _loadMatchDetail,
              child: Text(l10n.matchDetailRetry),
            ),
          ],
        ),
      );
    }

    if (_match == null) {
      return Center(
        child: Text(l10n.matchDetailNotFound),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      children: [
            // Warning box for matches without stage (First Call)
            if (_match!.stage == null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 16),
                child: WarningBoxWidget(
                  text: l10n.matchDetailFirstCallWarning(_match!.profile.firstName),
                ),
              ),
            ],
            
            // Profile Header
            ProfileHeader(
              profile: _match!.profile,
              avatarSize: 85,
              isEditable: false,
              matchingScore: _match!.score,
              stage: _match!.stage,
              // Blur avatar when user is not Pro AND not connected (same logic as matches_view)
              onAvatarTap: _match!.profile.avatarID != null
                  // Only allow avatar tap for connections
                  // This prevents non-Pro users from viewing unblurred photos of matched profiles
                  ? () => _viewMatchAvatar(context)
                  : null,
              onReachOutTap: () => _handleReachOut(context),
              onStageTap: () => _handleStageTap(context),
            ),

            const SizedBox(height: 16),

            // Matching Cards Section
            if (_match!.nrOfPrompts > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SubTitle(
                  iconName: 'card',
                  title: l10n.matchDetailMatchingCards(_match!.nrOfPrompts, _match!.nrOfPrompts == 1 ? l10n.matchDetailCard : l10n.matchDetailCards),
                ),
              ),

              const SizedBox(height: 16),
              
              MatchPromptsSection(
                match: _match!,
                currentProfile: context.profileService.currentProfile!,
              ),
              const SizedBox(height: 16),
            ],
            
            // If connection limit is reached, show upgrade prompt instead of other sections
            if (_match!.nrOfConnections > 0) ...[
                SubTitle(
                  iconName: 'match',
                  title: l10n.matchDetailSharedIntros(_match!.nrOfConnections, _match!.nrOfConnections == 1 ? l10n.matchDetailIntroduction : l10n.matchDetailIntroductions),
                ),
                const SizedBox(height: 16),
                MatchConnectionsSection(match: _match!),
                const SizedBox(height: 16),
              ],

              // Shared Venues Section
              if (_match!.nrOfVenues > 0) ...[
                SubTitle(
                  iconName: 'venue',
                  title: l10n.matchDetailSharedVenues(_match!.nrOfVenues, _match!.nrOfVenues == 1 ? l10n.matchDetailVenue : l10n.matchDetailVenues),
                ),
                const SizedBox(height: 8),
                MatchVenuesSection(match: _match!),
                const SizedBox(height: 16),
              ],    
               
              // Personal matches section
              if (_match!.nrOfPersonalTags > 0) ...[
                SubTitle(
                  iconName: 'profile',
                  title: l10n.matchDetailPersonalInterests(_match!.nrOfPersonalTags, _match!.nrOfPersonalTags == 1 ? l10n.matchDetailArea : l10n.matchDetailAreas),
                ),
                const SizedBox(height: 16),
                _buildPersonalMatchesContent(),
               const SizedBox(height: 16),
              ],

              // Company matches section
              if (_match!.nrOfCompanyTags > 0) ...[
                SubTitle(
                  iconName: 'company',
                  title: l10n.matchDetailCompanyFacts(_match!.nrOfCompanyTags, _match!.nrOfCompanyTags == 1 ? l10n.matchDetailArea : l10n.matchDetailAreas),
                ),
                const SizedBox(height: 16),
                MatchTagsSection(tagGroups: _match!.companyTagGroups),
                const SizedBox(height: 16),
              ],

              // Match score breakdown section
              if (_match!.scoreDetails != null && _match!.scoreDetails!.isNotEmpty) ...[
                SubTitle(
                  iconName: 'target',
                  title: l10n.matchDetailScoreBreakdown,
                ),
                const SizedBox(height: 16),
                MatchScoreSection(match: _match!),
              ],

      ],
    );
  }

  /// Build personal matches content based on user's Pro status and connection status
  Widget _buildPersonalMatchesContent() {
    // Show personal matches if user is Pro OR if they're already connected
    return MatchTagsSection(tagGroups: _match!.personalTagGroups);
  }

  /// Shows the match avatar in fullscreen view
  Future<void> _viewMatchAvatar(BuildContext context) async {
    await AvatarFullscreenViewer.show(
      context: context,
      avatarId: _match?.profile.avatarID,
      showBorder: false,
      preserveAspectRatio: true,
    );
  }

  /// Handles reaching out to a connection
  Future<void> _handleReachOut(BuildContext context) async {
    if (_match == null) return;

    final result = await Navigator.push<Stage?>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchReachOutView(match: _match!),
      ),
    );

    // If a new stage was returned, update the local match object
    if (result != null && mounted) {
      setState(() {
        _match = _match!.copyWith(stage: result);
      });
      // Notify parent to update matches list
      widget.onStageUpdated?.call(result);
    }
  }

  /// Handles tapping on a stage button
  Future<void> _handleStageTap(BuildContext context) async {
    if (_match == null) return;

    final result = await Navigator.push<Stage>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchStagesView(match: _match!),
      ),
    );

    // If a new stage was selected, update the local match object
    if (result != null && mounted) {
      setState(() {
        _match = _match!.copyWith(stage: result);
      });
      // Notify parent to update matches list
      widget.onStageUpdated?.call(result);
    }
  }
}