import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';

/// Waitlist finish view - confirmation screen after joining waitlist
///
/// This view displays a success message after the user has joined the waitlist.
/// It confirms that they've been added and will be notified when spots open up.
class WaitlistFinishView extends StatelessWidget {
  const WaitlistFinishView({super.key});

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false, // Prevent going back to submission
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.me, // Success green color
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Success icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.me.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.me,
                          size: 48,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Success title
                      Text(
                        l10n.waitlistFinishTitle,
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
                        l10n.waitlistFinishDescription,
                        style: AppTextStyles.body.copyWith(
                          color: venyuTheme.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),


                      const Spacer(flex: 3),

                      // Done button
                      ActionButton(
                        label: l10n.waitlistFinishButton,
                        onInvertedBackground: true,
                        onPressed: () {
                          // Navigate back to invite screening (root)
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),

                      const SizedBox(height: 16),
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
