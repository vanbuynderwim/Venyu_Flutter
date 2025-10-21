import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/info_box_widget.dart';

/// Match finish view - confirmation screen after expressing interest
///
/// This view displays a success message after the user has indicated interest in a match.
/// It explains that an introduction will be sent when both parties are interested.
class MatchFinishView extends StatelessWidget {
  final String otherProfileFirstName;

  const MatchFinishView({
    super.key,
    required this.otherProfileFirstName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return PopScope(
      canPop: true, // Allow going back
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.me, // Blue "looking for this" color
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
                                      l10n.matchFinishTitle,
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
                                      l10n.matchFinishDescription,
                                      style: AppTextStyles.body.copyWith(
                                        color: venyuTheme.darkText,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 24),

                                    // Info box with next steps
                                    InfoBoxWidget(
                                      text: l10n.matchFinishInfoMessage(otherProfileFirstName),
                                    ),

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
                            label: l10n.matchFinishDoneButton,
                            onInvertedBackground: true,
                            onPressed: () {
                              // Pop back to matches list
                              Navigator.of(context).pop();
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
