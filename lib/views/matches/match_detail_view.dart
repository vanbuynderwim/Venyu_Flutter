import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/utils/url_helper.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../services/profile_service.dart';
import '../../core/providers/app_providers.dart';
import '../../widgets/common/upgrade_prompt_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/avatar_fullscreen_viewer.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/menus/menu_option_builder.dart';
import '../subscription/paywall_view.dart';
import '../profile/profile_header.dart';
import 'match_detail/match_actions_section.dart';
import 'match_detail/match_connections_section.dart';
import 'match_detail/match_prompts_section.dart';
import '../../widgets/common/sub_title.dart';
import 'match_detail/match_tags_section.dart';
import 'match_detail/match_venues_section.dart';
import 'match_detail/match_preview_indicator.dart';

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

  const MatchDetailView({
    super.key,
    required this.matchId,
    this.onMatchRemoved,
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
        setState(() => _error = 'Failed to load match details');
      },
    );

    if (match != null) {
      setState(() => _match = match);
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
    final List<PopupMenuOption> options = [];

    // Report option (always available)
    options.add(
      MenuOptionBuilder.create(
        context: context,
        label: 'Report',
        iconName: 'report',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
        isDestructive: true,
      ),
    );

    // Remove option (only for connections)
    if (_match?.isConnected == true) {
      options.add(
        MenuOptionBuilder.create(
          context: context,
          label: 'Remove',
          iconName: 'delete',
          onTap: (_) {},  // Dummy onTap, handled by DialogUtils
          isDestructive: true,
        ),
      );
    }

    // Block option (always available)
    options.add(
      MenuOptionBuilder.create(
        context: context,
        label: 'Block',
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
    if (_match?.isConnected == true) {
      actions.add(_MatchAction.remove);
    }

    // Block option (always available)
    actions.add(_MatchAction.block);

    return actions;
  }

  /// Handles reporting a match
  Future<void> _handleReportMatch() async {
    AppLogger.debug('Report match tapped for match: ${widget.matchId}', context: 'MatchDetailView');

    await executeWithLoading(
      operation: () async {
        await _matchingManager.reportProfile(_match!.profile_1.id);
        AppLogger.success('Profile reported successfully for match: ${widget.matchId}', context: 'MatchDetailView');
      },
      showSuccessToast: true,
      successMessage: 'Profile reported successfully',
      showErrorToast: true,
    );
  }

  /// Handles blocking a match
  Future<void> _handleBlockMatch() async {
    AppLogger.debug('Block match tapped for match: ${widget.matchId}', context: 'MatchDetailView');

    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Block User?',
      message: 'Blocking this user will remove the match and prevent future matching. This action cannot be undone.',
      confirmText: 'Block',
      isDestructive: true,
    );

    if (confirmed) {
      await executeWithLoading(
        operation: () async {
          await _matchingManager.blockProfile(_match!.profile_1.id);
          AppLogger.success('Profile blocked successfully for match: ${widget.matchId}', context: 'MatchDetailView');

          // Call the callback to notify parent that match was removed
          widget.onMatchRemoved?.call();

          // Go back to previous screen
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        showSuccessToast: true,
        successMessage: 'User blocked successfully',
        showErrorToast: true,
      );
    }
  }

  /// Handles removing a match
  Future<void> _handleRemoveMatch() async {
    AppLogger.debug('Remove match tapped for match: ${widget.matchId}', context: 'MatchDetailView');
    final matchType = _match!.isConnected ? 'introduction' : 'match';

    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Remove $matchType?',
      message: 'Are you sure you want to remove this $matchType? This action cannot be undone.',
      confirmText: 'Remove',
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
        successMessage: '${matchType.substring(0, 1).toUpperCase()}${matchType.substring(1)} removed successfully',
        showErrorToast: true,
      );
    }
  }

  /// Build the bottom section - either action buttons or upgrade prompt
  Widget _buildBottomSection() {
   
    // Show regular action buttons if user is Pro or hasn't reached limit
    return MatchActionsSection(
      match: _match!,
      onMatchRemoved: widget.onMatchRemoved,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if we should hide the bottom section due to connection limit
    final currentProfile = ProfileService.shared.currentProfile;
    final isPro = currentProfile?.isPro ?? false;
    final connectionsLimitReached = currentProfile?.connectionsLimitReached ?? false;
    final shouldHideBottomSection = AppConfig.showPro && !isPro && connectionsLimitReached;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_match == null
          ? 'Loading...'
          : _match!.isConnected
            ? 'Introduction'
            : 'Match'),
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
      usePadding: true,
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMatchDetail,
              child: _buildContent(),
            ),
          ),
          // Fixed bottom action buttons only if not connected, no response, and limit not reached
          if (_match != null && !_match!.isConnected && _match!.response == null && !shouldHideBottomSection)
            _buildBottomSection(),
        ],
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
              onPressed: _loadMatchDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_match == null) {
      return const Center(
        child: Text('Match not found'),
      );
    }

    // Check if connection limit is reached for non-Pro users
    final currentProfile = ProfileService.shared.currentProfile;
    final isPro = currentProfile?.isPro ?? false;
    final connectionsLimitReached = currentProfile?.connectionsLimitReached ?? false;
    final shouldShowLimitedView = AppConfig.showPro && !isPro && connectionsLimitReached && !_match!.isConnected && _match!.response == null;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8.0),
      children: [
            // Profile Header
            ProfileHeader(
              profile: _match!.profile_1,
              avatarSize: 80.0,
              isEditable: false,
              isConnection: _match!.isConnected,
              shouldBlur: (ProfileService.shared.currentProfile?.isPro ?? false) || _match!.isConnected,
              onAvatarTap: _match!.profile_1.avatarID != null
                  ? () {
                      final isPro = ProfileService.shared.currentProfile?.isPro ?? false;
                      final isConnection = _match!.isConnected;
                      if (!AppConfig.showPro || isPro || isConnection) {
                        _viewMatchAvatar(context);
                      } else {
                        _showPaywallForAvatar(context);
                      }
                    }
                  : null,
              onLinkedInTap: _match!.isConnected && _match!.profile_1.linkedInURL != null
                  ? () => UrlHelper.openLinkedIn(context, _match!.profile_1.linkedInURL!)
                  : null,
              onEmailTap: _match!.isConnected && _match!.profile_1.contactEmail != null
                  ? () => UrlHelper.composeEmail(
                      context, 
                      _match!.profile_1.contactEmail!,
                      subject: 'We are connected on Venyu!',
                    )
                  : null,
              onWebsiteTap: _match!.isConnected && _match!.profile_1.websiteURL != null
                  ? () => UrlHelper.openWebsite(context, _match!.profile_1.websiteURL!)
                  : null,
            ),

            const SizedBox(height: 16),

            // Preview mode indicator if match is in preview
            if (_match!.isPreview == true) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: SubTitle(
                  iconName: 'eye',
                  title: 'First Call active',
                ),
              ),
              const SizedBox(height: 16),
              MatchPreviewIndicator(match: _match!),
              const SizedBox(height: 16),
            ],

            // Matching Cards Section
            if (_match!.nrOfPrompts > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SubTitle(
                  iconName: 'card',
                  title: '${_match!.nrOfPrompts} matching ${_match!.nrOfPrompts == 1 ? "card" : "cards"}',
                ),
              ),

              const SizedBox(height: 16),
              
              MatchPromptsSection(
                match: _match!,
                currentProfile: context.profileService.currentProfile!,
                shouldBlur: (ProfileService.shared.currentProfile?.isPro ?? false) || _match!.isConnected,
              ),
              const SizedBox(height: 16),
            ],
            
            // If connection limit is reached, show upgrade prompt instead of other sections
            if (shouldShowLimitedView) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: UpgradePromptWidget(
                  title: 'Monthly limit reached',
                  subtitle: 'You\'ve reached your limit of 3 intros per month. Upgrade to Venyu Pro for unlimited introductions.',
                  buttonText: 'Upgrade to Pro',
                  onSubscriptionCompleted: () {
                    // Refresh the view to update Pro status
                    setState(() {
                      final currentProfile = ProfileService.shared.currentProfile;
                      final isPro = currentProfile?.isPro ?? false;
                      AppLogger.debug('Subscription completed - isPro status: $isPro', context: 'MatchDetailView');
                    });
                  },
                ),
              ),
            ] else ...[
              // Show all other sections only if limit is not reached
              
              // Shared Connections Section
              if (_match!.nrOfConnections > 0) ...[
                SubTitle(
                  iconName: 'handshake',
                  title: '${_match!.nrOfConnections} shared ${_match!.nrOfConnections == 1 ? "introduction" : "introductions"}',
                ),
                const SizedBox(height: 16),
                MatchConnectionsSection(match: _match!),
                const SizedBox(height: 16),
              ],

              // Shared Venues Section
              if (_match!.nrOfVenues > 0) ...[
                SubTitle(
                  iconName: 'venue',
                  title: '${_match!.nrOfVenues} shared ${_match!.nrOfVenues == 1 ? "venue" : "venues"}',
                ),
                const SizedBox(height: 8),
                MatchVenuesSection(match: _match!),
                const SizedBox(height: 16),
              ],
              
              // Company matches section
              if (_match!.nrOfCompanyTags > 0) ...[
                SubTitle(
                  iconName: 'company',
                  title: '${_match!.nrOfCompanyTags} mutual company ${_match!.nrOfCompanyTags == 1 ? "fact" : "facts"}',
                ),
                const SizedBox(height: 16),
                MatchTagsSection(tagGroups: _match!.companyTagGroups),
                const SizedBox(height: 16),
              ],
              
              // Personal matches section
              if (_match!.nrOfPersonalTags > 0) ...[
                SubTitle(
                  iconName: 'match',
                  title: '${_match!.nrOfPersonalTags} mutual personal ${_match!.nrOfPersonalTags == 1 ? "interest" : "interests"}',
                ),
                const SizedBox(height: 16),
                _buildPersonalMatchesContent(),
               const SizedBox(height: 16),
              ],
              
              // Match reasons section (only for matched status)
              //if (_match!.status == MatchStatus.matched && 
              //    _match!.reason != null && 
              //    _match!.reason!.isNotEmpty) ...[
              //  MatchReasonsView(match: _match!)
              //],
            ],
            
      ],
    );
  }

  /// Build personal matches content based on user's Pro status and connection status
  Widget _buildPersonalMatchesContent() {
    final currentProfile = ProfileService.shared.currentProfile;
    final isPro = currentProfile?.isPro ?? false;
    final isConnection = _match!.isConnected;
    
    // Show personal matches if user is Pro OR if they're already connected
    if (!AppConfig.showPro || isPro || isConnection) {
      // Show actual personal matches for Pro users or connections
      return MatchTagsSection(tagGroups: _match!.personalTagGroups);
    } else {
      // Show upgrade prompt for free users who aren't connected
      return UpgradePromptWidget(
        title: 'Unlock mutual interests',
        subtitle: 'See what you share on a personal level with ${_match!.profile_1.firstName}',
        buttonText: 'Upgrade now',
        onSubscriptionCompleted: () {
          // Refresh the view to show personal matches
          setState(() {
            final currentProfile = ProfileService.shared.currentProfile;
            final isPro = currentProfile?.isPro ?? false;
            AppLogger.debug('Subscription completed - isPro status: $isPro', context: 'MatchDetailView');
          });
        },
      );
    }
  }

  /// Shows the match avatar in fullscreen view
  Future<void> _viewMatchAvatar(BuildContext context) async {
    await AvatarFullscreenViewer.show(
      context: context,
      avatarId: _match?.profile_1.avatarID,
      showBorder: false,
      preserveAspectRatio: true,
    );
  }
  
  /// Shows the paywall when non-Pro user tries to view avatar
  void _showPaywallForAvatar(BuildContext context) async {
    final result = await showPlatformModalSheet<bool>(
      context: context,
      material: MaterialModalSheetData(
        useRootNavigator: false,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: true,
      ),
      builder: (sheetContext) => const PaywallView(),
    );
    
    // If subscription was completed, refresh the view
    if (result == true) {
      setState(() {
        // This will trigger a rebuild and check isPro status again
        final currentProfile = ProfileService.shared.currentProfile;
        final isPro = currentProfile?.isPro ?? false;
        AppLogger.debug('Subscription completed from avatar tap - isPro status: $isPro', context: 'MatchDetailView');
      });
    }
  }
}