import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/utils/url_helper.dart';

import '../../l10n/app_localizations.dart';
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
import '../../widgets/common/form_info_box.dart';
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
import 'match_reasons_view.dart';

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
        final l10n = AppLocalizations.of(context)!;
        setState(() => _error = l10n.matchDetailErrorLoad);
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
    if (_match?.isConnected == true) {
      options.add(
        MenuOptionBuilder.create(
          context: context,
          label: l10n.matchDetailMenuRemove,
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
    if (_match?.isConnected == true) {
      actions.add(_MatchAction.remove);
    }

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
    final matchType = _match!.isConnected ? l10n.matchDetailTypeIntroduction : l10n.matchDetailTypeMatch;

    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.matchDetailRemoveTitle(matchType),
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
        successMessage: _match!.isConnected ? l10n.matchDetailRemoveSuccessIntroduction : l10n.matchDetailRemoveSuccessMatch,
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
    final l10n = AppLocalizations.of(context)!;
    // Check if we should hide the bottom section due to connection limit
    final currentProfile = ProfileService.shared.currentProfile;
    final isPro = currentProfile?.isPro ?? false;
    final connectionsLimitReached = currentProfile?.connectionsLimitReached ?? false;
    final shouldHideBottomSection = AppConfig.showPro && !isPro && connectionsLimitReached;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(_match == null
          ? l10n.matchDetailLoading
          : _match!.isConnected
            ? l10n.matchDetailTitleIntroduction
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
              profile: _match!.profile,
              avatarSize: 105.0,
              isEditable: false,
              isConnection: _match!.isConnected,
              shouldBlur: (ProfileService.shared.currentProfile?.isPro ?? false) || _match!.isConnected,
              onAvatarTap: _match!.profile.avatarID != null
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
              onLinkedInTap: _match!.isConnected && _match!.profile.linkedInURL != null
                  ? () => UrlHelper.openLinkedIn(context, _match!.profile.linkedInURL!)
                  : null,
              onEmailTap: _match!.isConnected && _match!.profile.contactEmail != null
                  ? () => UrlHelper.composeEmail(
                      context,
                      _match!.profile.contactEmail!,
                      subject: 'We are connected on Venyu!',
                    )
                  : null,
              onWebsiteTap: _match!.isConnected && _match!.profile.websiteURL != null
                  ? () => UrlHelper.openWebsite(context, _match!.profile.websiteURL!)
                  : null,
            ),

            const SizedBox(height: 16),

            // Preview mode indicator if match is in preview
            if (_match!.isPreview == true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SubTitle(
                  iconName: 'eye',
                  title: l10n.matchDetailFirstCallTitle,
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
                  title: l10n.matchDetailMatchingCards(_match!.nrOfPrompts, _match!.nrOfPrompts == 1 ? l10n.matchDetailCard : l10n.matchDetailCards),
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
                  title: l10n.matchDetailLimitTitle,
                  subtitle: l10n.matchDetailLimitMessage,
                  buttonText: l10n.matchDetailLimitButton,
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

              // Match reasons section (only for connected status)
              if (_match!.status == MatchStatus.connected &&
                  _match!.motivation != null &&
                  _match!.motivation!.isNotEmpty) ...[
                SubTitle(
                  iconName: 'bulb',
                  title: l10n.matchDetailWhyMatch(_match!.profile.firstName),
                ),
                const SizedBox(height: 16),
                MatchReasonsView(match: _match!),
                const SizedBox(height: 16),
              ],

              // Interested button info section (only for matched status)
              if (_match!.status == MatchStatus.matched) ...[
                FormInfoBox(
                  content: l10n.matchDetailInterestedInfoMessage(_match!.profile.firstName),
                ),
              ],
            ],
            
      ],
    );
  }

  /// Build personal matches content based on user's Pro status and connection status
  Widget _buildPersonalMatchesContent() {
    final l10n = AppLocalizations.of(context)!;
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
        title: l10n.matchDetailUnlockTitle,
        subtitle: l10n.matchDetailUnlockMessage(_match!.profile.firstName),
        buttonText: l10n.matchDetailUnlockButton,
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
      avatarId: _match?.profile.avatarID,
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