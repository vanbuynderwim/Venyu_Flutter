import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/enums/interaction_type.dart';
import '../../models/prompt.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import 'prompt_entry_view.dart';

/// Prompt finish view - final confirmation screen
///
/// This view displays a success message after the prompt has been submitted.
/// It confirms that the card has been sent for review.
class PromptFinishView extends StatelessWidget {
  final InteractionType interactionType;
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;
  final bool isRegistrationFlow;

  const PromptFinishView({
    super.key,
    required this.interactionType,
    this.isFromPrompts = false,
    this.onCloseModal,
    this.isRegistrationFlow = false,
  });

  /// Navigate to PromptEntryView with tutorial prompts for registration flow
  void _navigateToPromptEntry(BuildContext context, AppLocalizations l10n) {
    // Create 4 dummy tutorial prompts - one for each main interaction type
    final dummyPrompts = [
      Prompt(
        promptID: 'tutorial_1',
        label: l10n.registrationCompleteTutorialPrompt1,
        interactionType: InteractionType.lookingForThis,
        matchInteractionType: InteractionType.thisIsMe,
      ),
      Prompt(
        promptID: 'tutorial_2',
        label: l10n.registrationCompleteTutorialPrompt2,
        interactionType: InteractionType.lookingForThis,
        matchInteractionType: InteractionType.lookingForThis,
      ),
      Prompt(
        promptID: 'tutorial_3',
        label: l10n.registrationCompleteTutorialPrompt3,
        interactionType: InteractionType.lookingForThis,
        matchInteractionType: InteractionType.knowSomeone,
      ),
      Prompt(
        promptID: 'tutorial_4',
        label: l10n.registrationCompleteTutorialPrompt4,
        interactionType: InteractionType.lookingForThis,
        matchInteractionType: InteractionType.notRelevant,
      ),
    ];

    // Navigate to PromptEntryView (replaces all previous screens in the stack)
    Navigator.of(context).pushAndRemoveUntil(
      platformPageRoute(
        context: context,
        builder: (context) => PromptEntryView(
          prompts: dummyPrompts,
          isFirstTimeUser: true,
        ),
      ),
      (route) => route.isFirst, // Keep only the first route (MainView or similar)
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return PopScope(
      canPop: false, // Prevent going back to submission
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              interactionType.color,
              venyuTheme.adaptiveBackground,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Radar background overlay
            const RadarBackgroundOverlay(),

            // Main content
            PlatformScaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 48 - 64, // Account for padding and button
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    const Spacer(flex: 2),

                                    // Success icon
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: interactionType.color.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: interactionType.color,
                                        size: 48,
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Success title
                                    Text(
                                      interactionType == InteractionType.thisIsMe 
                                          ? l10n.promptFinishSavedTitle
                                          : l10n.promptFinishTitle,
                                      style: TextStyle(
                                        color: venyuTheme.darkText,
                                        fontSize: 36,
                                        fontFamily: AppFonts.graphie,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 16),

                                    // Explanation text
                                    Text(
                                      interactionType == InteractionType.thisIsMe 
                                          ? l10n.promptFinishSavedDescription
                                          : l10n.promptFinishDescription,
                                      style: AppTextStyles.body.copyWith(
                                        color: venyuTheme.darkText,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 24),

                                    // Review info - only show for looking_for_this prompts
                                    if (interactionType == InteractionType.lookingForThis) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                                        child: Text(
                                          l10n.promptFinishReviewInfo,
                                          style: AppTextStyles.footnote.copyWith(
                                            color: venyuTheme.darkText,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],

                                    const Spacer(flex: 3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Done button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ActionButton(
                            label: l10n.promptFinishDoneButton,
                            onInvertedBackground: true,
                            onPressed: () {
                              // Close all prompt views and return to main screen
                              if (isRegistrationFlow) {
                                // For registration flow, navigate to PromptEntryView with tutorial prompts
                                _navigateToPromptEntry(context, l10n);
                              } else if (onCloseModal != null) {
                                // Use the callback to close the entire modal
                                onCloseModal!();
                              } else {
                                // Pop all screens in the modal and return true to trigger refresh
                                // Navigation stack: [PromptEditView, PromptPreviewView, PromptFinishView]
                                // We need to pop all 3 screens and return true to the modal sheet
                                Navigator.of(context).pop(); // Pop PromptFinishView
                                Navigator.of(context).pop(); // Pop PromptPreviewView
                                Navigator.of(context).pop(true); // Pop PromptEditView with result true
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}