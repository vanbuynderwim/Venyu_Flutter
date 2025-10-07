import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
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
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Skip this match?',
      message: 'This match will be removed from your matches. The other person will not receive any notification and won\'t know you skipped them.',
      confirmText: AppStrings.skip,
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
      errorMessage: 'Failed to skip match',
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
      errorMessage: 'Failed to connect',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            // Skip button (1/3 width)
            Expanded(
              flex: 1,
              child: ActionButton(
                label: AppStrings.skip,
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
                label: AppStrings.interested,
                icon: context.themedIcon('like'),
                onPressed: _isProcessingSkip ? null : _handleConnectMatch,
                type: ActionButtonType.primary,
                isLoading: _isProcessingInterested,
                isDisabled: _isProcessingSkip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}