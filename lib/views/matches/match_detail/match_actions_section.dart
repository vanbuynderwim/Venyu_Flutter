import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/utils/app_logger.dart';
import '../../../mixins/error_handling_mixin.dart';
import '../../../models/enums/action_button_type.dart';
import '../../../models/enums/match_response.dart';
import '../../../models/match.dart';
import '../../../services/supabase_managers/matching_manager.dart';
import '../../../services/notification_service.dart';
import '../../../widgets/buttons/action_button.dart';
import '../../../widgets/common/sub_title.dart';

/// MatchActionsSection - Action buttons for match interactions
///
/// This widget displays the skip/interested buttons for non-connected matches
/// and handles the match response logic including confirmations.
///
/// Features:
/// - Skip match with confirmation dialog
/// - Connect/interested action
/// - Loading states for both actions
/// - Consistent error handling via ErrorHandlingMixin
class MatchActionsSection extends StatefulWidget {
  final Match match;
  final VoidCallback? onMatchRemoved;

  const MatchActionsSection({
    super.key,
    required this.match,
    this.onMatchRemoved,
  });

  @override
  State<MatchActionsSection> createState() => _MatchActionsSectionState();
}

class _MatchActionsSectionState extends State<MatchActionsSection> 
    with ErrorHandlingMixin {
  
  // Services
  late final MatchingManager _matchingManager;
  NotificationService? _notificationService;

  // State
  bool _isProcessingSkip = false;
  bool _isProcessingInterested = false;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    _notificationService = NotificationService.shared;
  }

  /// Show skip match confirmation alert
  Future<void> _showSkipAlert() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.matchActionsSkipDialogTitle,
      message: l10n.matchActionsSkipDialogMessage,
      confirmText: l10n.actionSkip,
    );

    if (confirmed) {
      await _handleSkipMatch();
    }
  }

  /// Handle skip match action
  Future<void> _handleSkipMatch() async {
    setState(() => _isProcessingSkip = true);

    await executeWithLoading(
      operation: () async {
        await _matchingManager.insertMatchResponse(widget.match.id, MatchResponse.notInterested);
      },
      successMessage: null,  // No toast - we navigate immediately
      errorMessage: AppLocalizations.of(context)!.matchActionsSkipError,
      showSuccessToast: false,
      onSuccess: () {
        // Update badges after match response
        _fetchBadges();
        // Notify parent that match was removed
        widget.onMatchRemoved?.call();
        // Then navigate back to matches list
        Navigator.of(context).pop();
        AppLogger.success('Match skipped successfully', context: 'MatchActionsSection');
      },
    );

    setState(() => _isProcessingSkip = false);
  }

  /// Handle connect match action
  Future<void> _handleConnectMatch() async {
    setState(() => _isProcessingInterested = true);

    await executeWithLoading(
      operation: () async {
        await _matchingManager.insertMatchResponse(widget.match.id, MatchResponse.interested);
      },
      successMessage: null,  // No toast - we navigate immediately
      errorMessage: AppLocalizations.of(context)!.matchActionsConnectError,
      showSuccessToast: false,
      onSuccess: () {
        // Update badges after match response
        _fetchBadges();
        // Notify parent that match was removed
        widget.onMatchRemoved?.call();
        // Then navigate back to matches list
        Navigator.of(context).pop();
        AppLogger.success('Connection request sent successfully', context: 'MatchActionsSection');
      },
    );

    setState(() => _isProcessingInterested = false);
  }

  /// Fetch badge counts to update tab bar
  Future<void> _fetchBadges() async {
    try {
      _notificationService ??= NotificationService.shared;
      await _notificationService!.fetchBadges();
    } catch (error) {
      AppLogger.error('Failed to fetch badges after match response', error: error, context: 'MatchActionsSection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: context.venyuTheme.cardBackground,
        border: Border(
          top: BorderSide(
            color: context.venyuTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Internal padding for content
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtitle with handshake icon

              const SizedBox(height: 16),

              SubTitle(
                iconName: 'handshake',
                title: l10n.matchDetailInterestedInfoMessage(widget.match.profile.firstName),
              ),
              const SizedBox(height: 16),

              // Action buttons row
              Row(
                children: [
                  // Skip button (1/3 width)
                  Expanded(
                    flex: 1,
                    child: ActionButton(
                      label: l10n.actionSkip,
                      onPressed: _isProcessingInterested ? null : _showSkipAlert,
                      type: ActionButtonType.secondary,
                      isLoading: _isProcessingSkip,
                      isDisabled: _isProcessingInterested,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Interested button (2/3 width)
                  Expanded(
                    flex: 2,
                    child: ActionButton(
                      label: l10n.actionInterested,
                      onPressed: _isProcessingSkip ? null : _handleConnectMatch,
                      type: ActionButtonType.primary,
                      isLoading: _isProcessingInterested,
                      isDisabled: _isProcessingSkip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}