import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/prompt.dart';
import '../../models/prompt_share.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/interaction_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/prompts/prompt_display_widget.dart';
import '../../widgets/prompts/prompt_share_card.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/toast_service.dart';
import 'interaction_type_selection_view.dart';
import '../onboarding/tutorial_finished_view.dart';

/// DailyPromptsView - Fullscreen modal for displaying daily prompts to users
/// 
/// This view shows available prompts to users on app startup when prompts are available.
/// Features:
/// - Fullscreen modal design
/// - Displays first prompt prominently
/// - Interactive buttons for user response
/// - Gradient background with theming support
class DailyPromptsView extends StatefulWidget {
  final List<Prompt> prompts;
  final VoidCallback? onCloseModal;
  final bool isFirstTimeUser;

  const DailyPromptsView({
    super.key,
    required this.prompts,
    this.onCloseModal,
    this.isFirstTimeUser = false,
  });

  @override
  State<DailyPromptsView> createState() => _DailyPromptsViewState();
}

class _DailyPromptsViewState extends State<DailyPromptsView> with ErrorHandlingMixin {
  InteractionType? _selectedInteractionType;
  int _currentPromptIndex = 0;
  List<InteractionType?> _promptInteractions = [];
  bool _isPromptReported = false;

  // Share state
  PromptShare? _promptShare;

  // Services
  late final ContentManager _contentManager;

  Prompt get _currentPrompt => widget.prompts[_currentPromptIndex];

  /// Get the top gradient color based on selected interaction type, fallback to prompt's interaction type
  Color get _topGradientColor {
    return _selectedInteractionType?.color ?? _currentPrompt.interactionType?.color ?? context.venyuTheme.gradientPrimary;
  }


  void _handleInteractionPressed(InteractionType interactionType) {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    setState(() {
      _selectedInteractionType = interactionType;
      _promptInteractions[_currentPromptIndex] = interactionType;
      // Reset share when changing interaction type
      if (interactionType != InteractionType.knowSomeone) {
        _promptShare = null;
      }
    });

    AppLogger.ui('User selected interaction: ${interactionType.value} for prompt: ${_currentPrompt.label}', context: 'PromptsView');
  }

  /// Create a prompt share and return it
  Future<PromptShare?> _createPromptShare() async {
    try {
      final share = await _contentManager.createPromptShare(_currentPrompt.promptID);
      AppLogger.success('Created share with slug: ${share.slug}', context: 'DailyPromptsView');

      if (mounted) {
        setState(() {
          _promptShare = share;
        });
      }

      return share;
    } catch (error) {
      AppLogger.error('Failed to create share', error: error, context: 'DailyPromptsView');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.error(
          context: context,
          message: l10n.sharesCreateError,
        );
      }
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    // Initialize interactions list with null values
    _promptInteractions = List.filled(widget.prompts.length, null);
  }

  Future<void> _handleNext() async {
    if (_selectedInteractionType == null || isProcessing) return;

    // For first time users, just play feedback and move to next prompt
    if (widget.isFirstTimeUser) {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);

      // Check if there are more prompts
      if (_currentPromptIndex < widget.prompts.length - 1) {
        // Move to next prompt and reset interaction selection
        setState(() {
          _currentPromptIndex++;
          _selectedInteractionType = null;
          _isPromptReported = false;
          _promptShare = null;
        });
      } else {
        // Last prompt - navigate to TutorialFinishedView
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (_) => const TutorialFinishedView(),
          ),
        );
      }
      return;
    }

    // Normal flow with server operation
    await executeWithLoading(
      operation: () async {
        HapticFeedback.heavyImpact();

        SystemSound.play(SystemSoundType.click);

        final promptFeedID = _currentPrompt.feedID ?? 0;
        final promptID = _currentPrompt.promptID;
        final interactionType = _selectedInteractionType!;

        AppLogger.network('Request payload: {prompt_feed_id: $promptFeedID, prompt_id: $promptID, interaction_type: ${interactionType.toJson()}}', context: 'PromptsView');

        await _contentManager.insertPromptInteraction(promptFeedID, promptID, interactionType);
        AppLogger.success('Interaction submitted: ${_selectedInteractionType!.value} for prompt: ${_currentPrompt.label}', context: 'PromptsView');
      },
      showSuccessToast: false,
      showErrorToast: false, // Handle navigation in callbacks
      useProcessingState: true,
      onSuccess: () async {
        
        // Check if there are more prompts
        if (_currentPromptIndex < widget.prompts.length - 1) {
          // Move to next prompt and reset interaction selection
          setState(() {
            _currentPromptIndex++;
            _selectedInteractionType = null;
            _isPromptReported = false; // Reset report state for new prompt
            _promptShare = null;
          });
        } else {
          // Last prompt completed - notify all listeners immediately
          // This ensures badges/buttons are removed even if user doesn't create a new prompt
          AppLogger.debug('All daily prompts answered, notifying listeners', context: 'DailyPromptsView');
          _contentManager.notifyAvailablePromptsUpdate([]);

          // Mark daily prompts as completed on server
          // This runs in background without blocking navigation
          _contentManager.markDailyPromptsCompleted().catchError((error) {
            AppLogger.warning('Failed to mark daily prompts as completed: $error', context: 'DailyPromptsView');
            // Silent failure - don't show error to user
          });

          // Navigate to InteractionTypeSelectionView to create a new prompt
          final result = await Navigator.of(context).push<bool>(
            platformPageRoute(
              context: context,
              builder: (_) => InteractionTypeSelectionView(
                isFromPrompts: true,
                onCloseModal: widget.onCloseModal,
              ),
            ),
          );

          // If prompt was successfully created, close the modal
          if (result == true && widget.onCloseModal != null) {
            widget.onCloseModal!();
          }
        }
      },
      onError: (error) {
        AppLogger.error('Error submitting interaction', error: error, context: 'PromptsView');
        // Close modal on error
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.prompts.length, (index) {
        final isCompleted = _promptInteractions[index] != null;
        final isCurrent = index == _currentPromptIndex;
        
        Color fillColor;
        Color? borderColor;
        double borderWidth = 0;
        
        if (isCompleted) {
          // Completed: Use the selected interaction type color
          fillColor = _promptInteractions[index]!.color;
        } else if (isCurrent && _selectedInteractionType != null) {
          // Current with selection: Use current selection color
          fillColor = _selectedInteractionType!.color;
        } else {
          // Not completed: White with light gray border
          fillColor = Colors.white;
          borderColor = AppColors.secundair4Quicksilver;
          borderWidth = 1.0;
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: borderWidth)
                : null,
          ),
        );
      }),
    );
  }

  /// Handle report button tap
  Future<void> _handleReportPrompt() async {
    if (_isPromptReported) return; // Already reported

    await executeWithLoading(
      operation: () async {
        await _contentManager.reportPrompt(_currentPrompt.promptID);

        setState(() {
          _isPromptReported = true;
        });
      },
      showSuccessToast: true,
      successMessage: AppLocalizations.of(context)!.dailyPromptsReportSuccess,
      showErrorToast: true,
      errorMessage: AppLocalizations.of(context)!.dailyPromptsReportError,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Early return if no prompts available
    if (widget.prompts.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.dailyPromptsNoPromptsAvailable),
        ),
      );
    }

    return PopScope(
      canPop: _currentPromptIndex == 0 || _selectedInteractionType != null,
      child: Container(
        decoration: BoxDecoration(
          color: _topGradientColor,
        ),
        child: Stack(
          children: [
            // Radar background overlay
            const RadarBackgroundOverlay(),
            // Main content
            PlatformScaffold(
              backgroundColor: Colors.transparent,
              appBar: PlatformAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                trailingActions: widget.isFirstTimeUser ? [] : [
                  GestureDetector(
                    onTap: _handleReportPrompt,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: context.themedIcon('report', size: 18, selected: _isPromptReported),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                bottom: false, // Allow keyboard to overlay the bottom safe area
                child: Column(
                children: [
                  // Prompt content - takes all available space
                  Expanded(
                    child: PromptDisplayWidget(
                      promptLabel: _currentPrompt.label,
                      venue: _currentPrompt.venue,
                      isFirstTimeUser: widget.isFirstTimeUser,
                      interactionType: _selectedInteractionType ?? _currentPrompt.interactionType,
                      showSelectionTitle: true,
                    ),
                  ),

                  // Progress indicator dots
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildProgressIndicator(),
                  ),

                  const SizedBox(height: AppModifiers.largeSpacing),

                  // Interaction buttons - fixed at bottom (base_form_view pattern)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: InteractionButtonRow(
                      onInteractionPressed: _handleInteractionPressed,
                      selectedInteractionType: _selectedInteractionType,
                      isUpdating: isProcessing,
                      spacing: AppModifiers.smallSpacing,
                      enabledInteractionType: widget.isFirstTimeUser ? _currentPrompt.matchInteractionType : null,
                      promptInteractionType: _currentPrompt.interactionType,
                    ),
                  ),

                  // Share card for know_someone interaction
                  if (_selectedInteractionType == InteractionType.knowSomeone) ...[
                    const SizedBox(height: AppModifiers.smallSpacing),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: PromptShareCard(
                        share: _promptShare,
                        onCreateShare: _createPromptShare,
                        promptLabel: _currentPrompt.label,
                        compact: true,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppModifiers.smallSpacing),

                  // Next button - enabled when interaction is selected, wrapped in light theme
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActionButton(
                        label: AppLocalizations.of(context)!.dailyPromptsButtonNext,
                        onPressed: (_selectedInteractionType != null && !isProcessing) ? _handleNext : null,
                        isLoading: isProcessing,
                        onInvertedBackground: true,
                      ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}