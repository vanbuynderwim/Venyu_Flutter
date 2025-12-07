import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/app_providers.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import 'tutorial_view.dart';

/// Welcome back screen for returning users after app update
///
/// Shows a welcome message explaining that the rules have changed
/// and offers to walk them through the tutorial again.
class ReturningUserTutorialView extends StatelessWidget {
  /// Callback to close the modal when tutorial is complete
  final VoidCallback? onCloseModal;

  const ReturningUserTutorialView({
    super.key,
    this.onCloseModal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;
    final profileService = context.profileService;
    final currentProfile = profileService.currentProfile;
    final firstName = currentProfile?.firstName ?? '';

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),

          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: [
                  const Spacer(),

                  // Welcome text section
                  Column(
                    children: [
                      Text(
                        l10n.returningUserTutorialWelcome(firstName),
                        style: AppTextStyles.title2.copyWith(
                          color: theme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        l10n.returningUserTutorialDescription,
                        style: AppTextStyles.callout.copyWith(
                          color: theme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // "Show me" button
                  ActionButton(
                    label: l10n.returningUserTutorialButton,
                    width: 120,
                    onPressed: () {
                      Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (context) => TutorialView(
                            isReturningUser: true,
                            onCloseModal: onCloseModal,
                          ),
                        ),
                      );
                    },
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
