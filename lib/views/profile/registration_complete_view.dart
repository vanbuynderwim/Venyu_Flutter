import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../services/tutorial_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../../models/enums/interaction_type.dart';
import '../prompts/prompt_edit_view.dart';

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

  Future<void> _navigateToPromptEdit() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      // Complete registration on server (but don't refresh profile yet to avoid MainView prompts check)
      AppLogger.debug('Completing registration', context: 'RegistrationCompleteView');
      final profileManager = ProfileManager.shared;
      await profileManager.completeRegistration();

      // Mark tutorial as shown so new users don't see the returning user tutorial
      await TutorialService.shared.markTutorialShown();

      AppLogger.success('Registration completed successfully', context: 'RegistrationCompleteView');
      AppLogger.debug('Profile refresh will happen after tutorial', context: 'RegistrationCompleteView');

      if (!mounted) return;

      // Navigate to PromptEditView with thisIsMe interaction type for creating the user's offer
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => const PromptEditView(
            initialInteractionType: InteractionType.thisIsMe,
            isNewPrompt: true,
            isRegistrationFlow: true,
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
                    onPressed: _isCompleting ? null : _navigateToPromptEdit,
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