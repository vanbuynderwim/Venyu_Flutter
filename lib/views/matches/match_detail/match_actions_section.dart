import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../mixins/error_handling_mixin.dart';
import '../../../models/enums/action_button_type.dart';
import '../../../models/enums/match_response.dart';
import '../../../models/match.dart';
import '../../../services/supabase_managers/matching_manager.dart';
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
  
  // State
  bool _isProcessingSkip = false;
  bool _isProcessingInterested = false;

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
  }

  /// Show skip match confirmation alert
  Future<void> _showSkipAlert() async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Skip this match?',
      message: 'This match will be removed from your matches.',
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
        // Notify parent that match was removed
        widget.onMatchRemoved?.call();
        // Then navigate back to matches list
        Navigator.of(context).pop();
        debugPrint('Match skipped');
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
        // Notify parent that match was removed
        widget.onMatchRemoved?.call();
        // Then navigate back to matches list
        Navigator.of(context).pop();
        debugPrint('Connection request sent!');
      },
    );
    
    setState(() => _isProcessingInterested = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: SafeArea(
        child: Row(
          children: [
            // Skip button
            Expanded(
              child: _isProcessingSkip 
                ? ActionButton(
                    label: '',
                    onPressed: null,
                    type: ActionButtonType.secondary,
                    isDisabled: true,
                    icon: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ActionButton(
                    label: AppStrings.skip,
                    onPressed: _isProcessingInterested ? null : _showSkipAlert,
                    type: ActionButtonType.secondary,
                    isDisabled: _isProcessingInterested,
                  ),
            ),
            
            const SizedBox(width: 16),
            
            // Interested button
            Expanded(
              child: _isProcessingInterested
                ? ActionButton(
                    label: '',
                    onPressed: null,
                    type: ActionButtonType.primary,
                    isDisabled: true,
                    icon: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ActionButton(
                    label: AppStrings.interested,
                    onPressed: _isProcessingSkip ? null : _handleConnectMatch,
                    type: ActionButtonType.primary,
                    isDisabled: _isProcessingSkip,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}