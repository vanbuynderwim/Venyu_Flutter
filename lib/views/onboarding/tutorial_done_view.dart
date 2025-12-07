import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../../models/enums/registration_step.dart';
import '../../services/tutorial_service.dart';
import '../profile/edit_name_view.dart';

/// View shown after completing the tutorial introduction
///
/// This view shows the "You got it!" message and explains that the user
/// is now ready to set up their profile and join the community.
/// For returning users, it shows a different message and closes the modal.
class TutorialDoneView extends StatelessWidget {
  /// Whether this is a returning user seeing the tutorial again after an update
  final bool isReturningUser;

  /// Callback to close the modal when tutorial is complete (for returning users)
  final VoidCallback? onCloseModal;

  const TutorialDoneView({
    super.key,
    this.isReturningUser = false,
    this.onCloseModal,
  });

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

  Future<void> _handleReturningUserClose(BuildContext context) async {
    // Mark the tutorial as shown so it won't appear again
    await TutorialService.shared.markTutorialShown();

    // Close the modal
    if (onCloseModal != null) {
      onCloseModal!();
    } else if (context.mounted) {
      // Fallback: pop to first route
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    // Use different text and action for returning users
    final title = l10n.tutorialDoneTitle; // Same title for both
    final description = isReturningUser
        ? l10n.returningUserTutorialDoneDescription
        : l10n.tutorialDoneDescription;
    final buttonLabel = isReturningUser
        ? l10n.returningUserTutorialDoneButton
        : l10n.tutorialButtonNext;

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
                        title,
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        description,
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Action button - different behavior for returning users
                      ActionButton(
                        label: buttonLabel,
                        width: 120,
                        onPressed: isReturningUser
                            ? () => _handleReturningUserClose(context)
                            : () => _navigateToRegistration(context),
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
