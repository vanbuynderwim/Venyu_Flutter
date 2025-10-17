import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/profile_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../main_view.dart';

/// Final view shown after completing the onboarding tutorial and first real prompts
///
/// This view congratulates the user on completing their account setup and
/// answering their first 3 cards. Explains that's all for today and provides
/// a "Got it" button that refreshes the profile and navigates to MainView.
class RegistrationFinishView extends StatefulWidget {
  const RegistrationFinishView({super.key});

  @override
  State<RegistrationFinishView> createState() => _RegistrationFinishViewState();
}

class _RegistrationFinishViewState extends State<RegistrationFinishView> {
  bool _isLoading = false;

  Future<void> _handleGotIt() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Refresh profile now that onboarding is complete
      AppLogger.debug('Refreshing profile after completing onboarding', context: 'RegistrationFinishView');
      final profileService = ProfileService.shared;
      await profileService.refreshProfile();
      AppLogger.success('Profile refreshed - user is now fully registered', context: 'RegistrationFinishView');

      if (!mounted) return;

      // Navigate to main view (registration complete)
      Navigator.of(context).pushAndRemoveUntil(
        platformPageRoute(
          context: context,
          builder: (_) => const MainView(),
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (error) {
      AppLogger.error('Failed to refresh profile', error: error, context: 'RegistrationFinishView');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Even on error, navigate to MainView - user can retry operations there
        Navigator.of(context).pushAndRemoveUntil(
          platformPageRoute(
            context: context,
            builder: (_) => const MainView(),
          ),
          (route) => false,
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
                        l10n.registrationFinishTitle,
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        l10n.registrationFinishDescription,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Start exploring button
                      ActionButton(
                        label: l10n.registrationFinishButton,
                        width: 240,
                        onPressed: _isLoading ? null : _handleGotIt,
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
