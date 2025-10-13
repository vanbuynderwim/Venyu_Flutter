import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../../models/enums/interaction_type.dart';
import '../../models/prompt.dart';
import '../prompts/prompt_entry_view.dart';

/// Final view in the registration wizard that completes the user's profile
/// 
/// This view congratulates the user on completing their profile and provides
/// an "Enter Venyu" button that calls completeRegistration() and transitions
/// to the main app experience.
class RegistrationCompleteView extends StatefulWidget {
  const RegistrationCompleteView({super.key});

  @override
  State<RegistrationCompleteView> createState() => _RegistrationCompleteViewState();
}

class _RegistrationCompleteViewState extends State<RegistrationCompleteView> {
  bool _isCompleting = false;

  Future<void> _navigateToPromptEntry() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      // Complete registration on server (but don't refresh profile yet to avoid MainView prompts check)
      AppLogger.debug('Completing registration', context: 'RegistrationCompleteView');
      final profileManager = ProfileManager.shared;
      await profileManager.completeRegistration();

      AppLogger.success('Registration completed successfully', context: 'RegistrationCompleteView');
      AppLogger.debug('Profile refresh will happen after tutorial', context: 'RegistrationCompleteView');

      if (!mounted) return;

      // Get localized strings before creating prompts
      final l10n = AppLocalizations.of(context)!;

      // Create 4 dummy tutorial prompts - one for each main interaction type
      final dummyPrompts = [
        Prompt(
          promptID: 'tutorial_1',
          label: l10n.registrationCompleteTutorialPrompt1,
          interactionType: InteractionType.thisIsMe,
        ),
        Prompt(
          promptID: 'tutorial_2',
          label: l10n.registrationCompleteTutorialPrompt2,
          interactionType: InteractionType.lookingForThis,
        ),
        Prompt(
          promptID: 'tutorial_3',
          label: l10n.registrationCompleteTutorialPrompt3,
          interactionType: InteractionType.knowSomeone,
        ),
        Prompt(
          promptID: 'tutorial_4',
          label: l10n.registrationCompleteTutorialPrompt4,
          interactionType: InteractionType.notRelevant,
        ),
      ];

      // Navigate to prompt entry
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => PromptEntryView(
            prompts: dummyPrompts,
            isFirstTimeUser: true,
          ),
        ),
      );
    } catch (error) {
      AppLogger.error('Failed to complete registration', error: error, context: 'RegistrationCompleteView');

      if (mounted) {
        setState(() {
          _isCompleting = false;
        });

        ToastService.error(
          context: context,
          message: AppLocalizations.of(context)!.registrationCompleteError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),

          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // Main content
                  Column(
                    children: [
                      Text(
                        l10n.registrationCompleteTitle,
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        l10n.registrationCompleteDescription,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Continue button
                  ActionButton(
                    label: l10n.registrationCompleteButton,
                    width: 120,
                    onPressed: _isCompleting ? null : _navigateToPromptEntry,
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}