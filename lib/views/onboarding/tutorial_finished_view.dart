import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../services/tutorial_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../main_view.dart';

/// View shown after completing the tutorial dummy prompts
///
/// This view congratulates the user on completing the quick tour and explains
/// that they're now ready to answer real cards.
class TutorialFinishedView extends StatefulWidget {
  const TutorialFinishedView({super.key});

  @override
  State<TutorialFinishedView> createState() => _TutorialFinishedViewState();
}

class _TutorialFinishedViewState extends State<TutorialFinishedView> {
  bool _isLoading = false;

  Future<void> _handleLetsGo() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Complete registration on server
      AppLogger.debug('Completing registration', context: 'TutorialFinishedView');
      final profileManager = ProfileManager.shared;
      await profileManager.completeRegistration();

      // Mark tutorial as shown so new users don't see the returning user tutorial
      await TutorialService.shared.markTutorialShown();

      AppLogger.success('Registration completed successfully', context: 'TutorialFinishedView');

      // Refresh profile before navigating to MainView
      AppLogger.debug('Refreshing profile', context: 'TutorialFinishedView');
      final profileService = ProfileService.shared;
      await profileService.refreshProfile();

      AppLogger.success('Profile refreshed, navigating to MainView', context: 'TutorialFinishedView');

      if (!mounted) return;

      // Navigate to MainView and remove all previous routes (complete onboarding)
      Navigator.of(context).pushAndRemoveUntil(
        platformPageRoute(
          context: context,
          builder: (_) => const MainView(),
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (error) {
      AppLogger.error('Failed to complete registration', error: error, context: 'TutorialFinishedView');

      if (mounted) {
        setState(() {
          _isLoading = false;
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
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Full-screen radar background image
            const RadarBackground(),

            // Content overlay
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Main content
                      Text(
                        l10n.tutorialFinishedTitle,
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        l10n.tutorialFinishedDescription,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Start button
                      ActionButton(
                        label: l10n.tutorialFinishedButton,
                        width: 120,
                        onPressed: _isLoading ? null : _handleLetsGo,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
