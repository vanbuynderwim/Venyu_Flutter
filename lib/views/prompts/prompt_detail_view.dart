import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
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
import '../../models/match.dart';
import '../matches/match_detail_view.dart';
import '../matches/match_item_view.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/prompt_status.dart';
import '../../models/enums/prompt_setting.dart';
import '../../models/enums/interaction_type.dart';
import '../../widgets/common/status_badge_view.dart';
import '../../widgets/common/community_guidelines_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../venues/venue_item_view.dart';
import '../venues/venue_detail_view.dart';
import 'prompt_edit_view.dart';
import '../../services/notification_service.dart';
import '../../services/profile_service.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/enums/action_button_type.dart';

/// PromptDetailView - Shows a prompt with its associated matches
///
/// This view displays:
/// - The prompt at the top (using PromptItem)
/// - List of matches associated with this prompt (for looking_for_this type)
/// - Navigation to match details when tapping a match
class PromptDetailView extends StatefulWidget {
  final String promptId;
  final InteractionType? interactionType;
  final Function(Prompt)? onPromptUpdated;

  const PromptDetailView({
    super.key,
    required this.promptId,
    this.interactionType,
    this.onPromptUpdated,
  });

  @override
  State<PromptDetailView> createState() => _PromptDetailViewState();
}

class _PromptDetailViewState extends State<PromptDetailView> with ErrorHandlingMixin {
  late final ContentManager _contentManager;
  NotificationService? _notificationService;

  Prompt? _prompt;
  String? _error;
  bool _isProcessingApprove = false;
  bool _isProcessingReject = false;
  bool _isProcessingDelete = false;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _notificationService = NotificationService.shared;
    _loadPromptData();
  }


  Future<void> _loadPromptData() async {
    if (!mounted) return;
    setState(() => _error = null);

    await executeWithLoading(
      operation: () async {
        Prompt? prompt;

        // Use different API based on interaction type
        //if (widget.interactionType == InteractionType.thisIsMe) {
          // Fetch offer (this_is_me prompt) via content_manager
        //  prompt = await _contentManager.fetchOffer(widget.promptId);
        //  AppLogger.debug('Offer loaded', context: 'PromptDetailView');
        //} else {
          // Fetch prompt (looking_for_this) via content_manager - includes matches
          prompt = await _contentManager.fetchPrompt(widget.promptId);
          AppLogger.debug('Prompt loaded with ${prompt?.matches?.length ?? 0} matches', context: 'PromptDetailView');
        //}

        if (prompt != null && mounted) {
          setState(() => _prompt = prompt);
        } else if (mounted) {
          setState(() => _error = AppLocalizations.of(context)!.promptDetailErrorMessage);
        }
      },
      showErrorToast: false,
      onError: (error) {
        AppLogger.error('Error loading prompt data: $error', context: 'PromptDetailView');
        if (mounted) {
          setState(() => _error = AppLocalizations.of(context)!.promptDetailErrorDataMessage);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentProfile = ProfileService.shared.currentProfile;
    final showAdminButtons = _prompt?.status == PromptStatus.pendingReview &&
                             (currentProfile?.isSuperAdmin ?? false);
    final showDeleteButton = _prompt != null &&
                             _prompt!.fromAuthor == true &&
                             ((_prompt!.status == PromptStatus.pendingReview ||
                               _prompt!.status == PromptStatus.rejected) ||
                              _prompt!.interactionType == InteractionType.thisIsMe);

    // Show pause/play button in app bar for approved looking_for_this prompts
    final showPauseButton = _prompt != null &&
                            _prompt!.displayStatus == PromptStatus.approved;

    return AppScaffold(
        appBar: PlatformAppBar(
          title: Text(l10n.promptDetailTitle),
        trailingActions: [
          if (showPauseButton)
            IconButton(
              icon: _prompt!.isPaused == true
                  ? context.themedIcon('play', size: 24, selected: true, overrideColor: context.venyuTheme.primary)
                  : context.themedIcon('pause', size: 24, selected: true, overrideColor: context.venyuTheme.error),
              color: _prompt!.isPaused == true
                  ? context.venyuTheme.primary
                  : context.venyuTheme.error,
              onPressed: _handleToggleMatching,
            ),
        ],
      ),
      usePadding: false,
      useSafeArea: true,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
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
                  shouldShowStatus: _prompt!.displayStatus == PromptStatus.approved,
                ),
              ),

              // Status section - only show if user is the author and status is not approved
              if (_prompt!.fromAuthor == true && _prompt!.displayStatus != PromptStatus.approved) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SubTitle(
                    iconName: 'report',
                    title: l10n.promptDetailStatusTitle,
                  ),
                ),
                const SizedBox(height: 16),

                // Status info section
                _buildStatusInfoSection(),
              ],

              // Venue section - show if prompt has a venue
              if (_prompt!.venue != null) ...[

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitle(
                        iconName: 'venue',
                        title: l10n.promptDetailPublishedInTitle,
                      ),
                      const SizedBox(height: 8),
                      VenueItemView(
                        venue: _prompt!.venue!,
                        onTap: () => _navigateToVenueDetail(_prompt!.venue!.id),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],

            // Matches content
            _buildMatchesContent(),
                ],
              ),
            ),
          ),

          // Admin review buttons - only show for super admins when status is pending_review
          if (showAdminButtons) _buildAdminButtons(),

          // Delete button - only show for rejected or pending_review prompts by the author
          if (showDeleteButton) _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildMatchesContent() {
    final l10n = AppLocalizations.of(context)!;
    final matches = _prompt?.matches ?? [];

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
              child: Text(l10n.promptDetailRetryButton),
            ),
          ],
        ),
      );
    }

    // Show matches content
    if (matches.isEmpty) {
      // Only show empty state for approved looking_for_this prompts
      // this_is_me prompts (offers) don't have matches
      if (_prompt?.displayStatus == PromptStatus.approved) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: EmptyStateWidget(
            message: l10n.promptDetailEmptyMatchesTitle,
            description: l10n.promptDetailEmptyMatchesDescription,
            iconName: 'nomatches',
            height: 200,
          ),
        );
      } else {
        // For non-approved prompts or this_is_me prompts, don't show matches section at all
        return const SizedBox.shrink();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Introductions title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SubTitle(
            iconName: 'match',
            title: l10n.promptDetailMatchesTitle(matches.length),
          ),
        ),
        const SizedBox(height: 8),

        // Matches list
        ...matches.map((match) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: MatchItemView(
            match: match,
            onMatchSelected: (selectedMatch) => _navigateToMatchDetail(selectedMatch),
          ),
        )),
      ],
    );
  }

  void _navigateToMatchDetail(Match match) {
    AppLogger.ui('Navigating to match detail from prompt: ${match.id}', context: 'PromptDetailView');

    // Decrease badge count if match wasn't viewed yet
    if (match.isViewed != true) {
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
              status.statusInfo(context),
              style: AppTextStyles.subheadline.copyWith(
                color: context.venyuTheme.primaryText,
              ),
            ),

            // Show community guidelines for rejected status
            if (status == PromptStatus.rejected) ...[
              const SizedBox(height: 16),

              ActionButton(
                label: AppLocalizations.of(context)!.promptDetailEditButton,
                icon: context.themedIcon('edit'),
                onPressed: () => _editPrompt(),
                isCompact: false,
              ),

               const SizedBox(height: 16),

              const CommunityGuidelinesWidget(
                showTitle: true,
              ),
            ],

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


  /// Handle matching toggle (pause/resume)
  void _handleToggleMatching() async {
    final l10n = AppLocalizations.of(context)!;
    final isPaused = _prompt!.isPaused == true;

    // If currently active (user wants to pause), show confirmation dialog
    if (!isPaused) {
      final confirmed = await DialogUtils.showConfirmationDialog(
        context: context,
        title: l10n.promptDetailPauseMatchingTitle,
        message: l10n.promptDetailPauseMatchingMessageGeneric,
        confirmText: l10n.promptDetailPauseMatchingConfirm,
        cancelText: l10n.promptDetailPauseMatchingCancel,
      );

      if (!confirmed) {
        return; // User cancelled
      }
    }

    AppLogger.debug('${isPaused ? "Resuming" : "Pausing"} matching for prompt: ${_prompt!.promptID}', context: 'PromptDetailView');

    await executeWithLoading(
      operation: () async {
        if (isPaused) {
          // Resume: delete paused setting
          await _contentManager.deletePromptSetting(_prompt!.promptID, PromptSetting.paused);
        } else {
          // Pause: insert paused setting
          await _contentManager.insertPromptSetting(_prompt!.promptID, PromptSetting.paused);
        }

        // Reload prompt data to get updated state
        await _loadPromptData();

        AppLogger.success('Matching ${isPaused ? "resumed" : "paused"} successfully', context: 'PromptDetailView');
        
        // Notify parent to update prompt in the list
        if (_prompt != null) {
          widget.onPromptUpdated?.call(_prompt!);
        }
      },
      showSuccessToast: true,
      successMessage: l10n.promptDetailMatchSettingUpdatedMessage,
      showErrorToast: true,
    );
  }

  /// Build admin review buttons
  Widget _buildAdminButtons() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SafeArea(
        child: Row(
          children: [
            // Reject button
            Expanded(
              child: ActionButton(
                label: l10n.promptDetailRejectButton,
                onPressed: _isProcessingApprove ? null : _handleReject,
                type: ActionButtonType.destructive,
                isLoading: _isProcessingReject,
                isDisabled: _isProcessingApprove,
              ),
            ),
            const SizedBox(width: 8),
            // Approve button
            Expanded(
              child: ActionButton(
                label: l10n.promptDetailApproveButton,
                onPressed: _isProcessingReject ? null : _handleApprove,
                type: ActionButtonType.primary,
                isLoading: _isProcessingApprove,
                isDisabled: _isProcessingReject,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle approve action
  Future<void> _handleApprove() async {
    if (_prompt == null || _isProcessingApprove || _isProcessingReject) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isProcessingApprove = true);

    await executeWithLoading(
      operation: () async {
        await _contentManager.updatePromptStatusBatch(
          [_prompt!.promptID],
          PromptStatus.pendingTranslation,
        );

        AppLogger.success('Prompt approved', context: 'PromptDetailView');

        // Navigate back after approval
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      showSuccessToast: true,
      successMessage: l10n.promptDetailApprovedMessage,
      showErrorToast: true,
      onError: (_) {
        setState(() => _isProcessingApprove = false);
      },
    );
  }

  /// Handle reject action
  Future<void> _handleReject() async {
    if (_prompt == null || _isProcessingApprove || _isProcessingReject) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isProcessingReject = true);

    await executeWithLoading(
      operation: () async {
        await _contentManager.updatePromptStatusBatch(
          [_prompt!.promptID],
          PromptStatus.rejected,
        );

        AppLogger.success('Prompt rejected', context: 'PromptDetailView');

        // Navigate back after rejection
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      showSuccessToast: true,
      successMessage: l10n.promptDetailRejectedMessage,
      showErrorToast: true,
      onError: (_) {
        setState(() => _isProcessingReject = false);
      },
    );
  }

  /// Build delete button
  Widget _buildDeleteButton() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SafeArea(
        child: ActionButton(
          label: l10n.promptDetailDeleteButton,
          onPressed: _isProcessingDelete ? null : _handleDelete,
          type: ActionButtonType.destructive,
          isLoading: _isProcessingDelete,
        ),
      ),
    );
  }

  /// Handle delete action
  Future<void> _handleDelete() async {
    if (_prompt == null || _isProcessingDelete) return;

    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.promptDetailDeleteConfirmTitle,
      message: l10n.promptDetailDeleteConfirmMessage,
      confirmText: l10n.promptDetailDeleteConfirmButton,
      cancelText: l10n.promptDetailDeleteCancelButton,
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessingDelete = true);

    await executeWithLoading(
      operation: () async {
        await _contentManager.deletePrompt(_prompt!.promptID);

        AppLogger.success('Prompt deleted', context: 'PromptDetailView');

        // Navigate back after deletion
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate deletion
        }
      },
      showSuccessToast: true,
      successMessage: l10n.promptDetailDeletedMessage,
      showErrorToast: true,
      errorMessage: l10n.promptDetailDeleteErrorMessage,
      onError: (_) {
        setState(() => _isProcessingDelete = false);
      },
    );
  }
}