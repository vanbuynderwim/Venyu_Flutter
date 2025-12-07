import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/enums/action_button_type.dart';
import '../../../models/enums/toast_type.dart';
import '../../../models/match.dart';
import '../../../models/stage.dart';
import '../../../services/supabase_managers/matching_manager.dart';
import '../../../services/toast_service.dart';
import '../../../widgets/buttons/action_button.dart';
import '../../../widgets/scaffolds/app_scaffold.dart';
import '../../../widgets/buttons/option_button.dart';

/// MatchStagesView - View for selecting a connection stage for a match
///
/// This view displays all available connection stages and allows the user
/// to select one. The selected stage is saved via insertMatchStage.
class MatchStagesView extends StatefulWidget {
  final Match match;

  const MatchStagesView({
    super.key,
    required this.match,
  });

  @override
  State<MatchStagesView> createState() => _MatchStagesViewState();
}

class _MatchStagesViewState extends State<MatchStagesView> {
  final MatchingManager _matchingManager = MatchingManager.shared;
  List<Stage>? _stages;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  // Track selected stage
  Stage? _selectedStage;

  @override
  void initState() {
    super.initState();
    _initializeView();
  }

  Future<void> _initializeView() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch all connection stages for this match
      final stages = await _matchingManager.getMatchConnectionStages(widget.match.id);

      // Find the currently selected stage, or default to first stage
      final selectedStage = stages.where((stage) => stage.selected).firstOrNull
          ?? (stages.isNotEmpty ? stages.first : null);

      setState(() {
        _stages = stages;
        _selectedStage = selectedStage;
        _isLoading = false;
      });
    } catch (error) {
      AppLogger.error('Error fetching connection stages: $error', context: 'MatchStagesView');
      if (mounted) {
        setState(() {
          _error = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.matchStagesTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              children: _buildContent(),
            ),
          ),
          if (!_isLoading && _stages != null)
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: ActionButton(
                label: _isSaving
                    ? l10n.matchStagesSavingButton
                    : l10n.matchStagesSaveButton,
                onPressed: _isSaving || _selectedStage == null ? null : _saveChanges,
                type: ActionButtonType.primary,
                isDisabled: _isSaving || _selectedStage == null,
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> content = [];

    if (_isLoading) {
      content.add(
        SizedBox(
          height: 200,
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      );
      return content;
    }

    if (_error != null) {
      content.add(
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.venyuTheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.matchStagesLoadErrorTitle,
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTextStyles.body.secondary(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PlatformElevatedButton(
                  onPressed: _initializeView,
                  child: Text(l10n.matchStagesRetryButton),
                ),
              ],
            ),
          ),
        ),
      );
      return content;
    }

    if (_stages == null || _stages!.isEmpty) {
      content.add(
        SizedBox(
          height: 200,
          child: Center(
            child: Text(l10n.matchStagesNoStagesMessage),
          ),
        ),
      );
      return content;
    }

    // Add description text
    content.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          l10n.matchStagesDescription,
          style: AppTextStyles.body.secondary(context),
        ),
      ),
    );

    // Add stages as OptionButtons (single select)
    for (final stage in _stages!) {
      final isSelected = _selectedStage?.id == stage.id;

      content.add(
        OptionButton(
          option: stage,
          isSelected: isSelected,
          isMultiSelect: false,
          isSelectable: true,
          isCheckmarkVisible: true,
          isChevronVisible: false,
          withDescription: true,
          useBorderSelection: true,
          onSelect: () {
            _handleStageTap(stage);
          },
        ),
      );
    }

    return content;
  }

  void _handleStageTap(Stage stage) {
    final isCurrentlySelected = _selectedStage?.id == stage.id;

    // Provide haptic feedback only when SELECTING (not deselecting)
    if (!isCurrentlySelected) {
      HapticFeedback.selectionClick();
    }

    setState(() {
      // Single-select mode: select the tapped stage
      if (!isCurrentlySelected) {
        _selectedStage = stage;
      }
      // If already selected, ignore tap (don't allow deselecting)
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving || _selectedStage == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Insert the selected stage
      await _matchingManager.insertMatchStage(
        matchId: widget.match.id,
        connectionStageId: _selectedStage!.id,
      );

      AppLogger.success('Match stage saved successfully', context: 'MatchStagesView');

      // Return the selected stage to update locally in match_detail_view
      if (mounted) {
        Navigator.of(context).pop(_selectedStage);
      }
    } catch (error) {
      AppLogger.error('Error saving match stage: $error', context: 'MatchStagesView');

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.show(
          context: context,
          message: l10n.matchStagesSaveErrorTitle,
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
