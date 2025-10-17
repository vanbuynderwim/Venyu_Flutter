import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../../models/enums/registration_step.dart';
import '../profile/edit_name_view.dart';

/// View shown after completing the tutorial introduction
///
/// This view shows the "You got it!" message and explains that the user
/// is now ready to set up their profile and join the community.
class TutorialDoneView extends StatelessWidget {
  const TutorialDoneView({super.key});

  void _navigateToRegistration(BuildContext context) {
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => const EditNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.name,
        ),
      ),
    );
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
                        l10n.tutorialStep5Title,
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        l10n.tutorialStep5Description,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Start button
                      ActionButton(
                        label: l10n.tutorialButtonNext,
                        width: 120,
                        onPressed: () => _navigateToRegistration(context),
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
