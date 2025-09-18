import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';

/// Prompt finish view - final confirmation screen
///
/// This view displays a success message after the prompt has been submitted.
/// It confirms that the card has been sent for review.
class PromptFinishView extends StatelessWidget {
  final bool isFromPrompts;
  final VoidCallback? onCloseModal;

  const PromptFinishView({
    super.key,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

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
              appBar: PlatformAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false, // Hide back button
                title: Text(
                  'Success',
                  style: TextStyle(
                    color: venyuTheme.darkText,
                  ),
                ),
              ),
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
                        'Card submitted!',
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
                        'Your card has been successfully submitted and is being reviewed. We\'ll notify you once it\'s live.',
                        style: AppTextStyles.body.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Review info box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: venyuTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
                          border: Border.all(
                            color: venyuTheme.borderColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: venyuTheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Reviews typically take less than 24 hours',
                                style: AppTextStyles.caption1.copyWith(
                                  color: venyuTheme.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Done button
                      ActionButton(
                        label: 'Done',
                        onInvertedBackground: true,
                        onPressed: () {
                          // Close all prompt views and return to main screen
                          if (isFromPrompts && onCloseModal != null) {
                            // If from prompts flow, use the callback
                            onCloseModal!();
                          } else {
                            // Navigate back to root
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
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