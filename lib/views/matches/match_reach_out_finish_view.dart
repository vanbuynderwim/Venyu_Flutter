import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/contact.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';

/// Reach out finish view - confirmation screen after sending a message
///
/// This view displays a success message after the user has sent a reach out message.
/// It shows the full message content including contact info and PS.
class MatchReachOutFinishView extends StatelessWidget {
  final String message;
  final List<Contact> selectedContacts;

  const MatchReachOutFinishView({
    super.key,
    required this.message,
    required this.selectedContacts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return PopScope(
      canPop: false, // Don't allow going back to preview
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),

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
                              l10n.matchReachOutFinishTitle,
                              style: TextStyle(
                                color: venyuTheme.darkText,
                                fontSize: 36,
                                fontFamily: AppFonts.graphie,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // Message preview card
                            _buildMessageCard(context),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // Done button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ActionButton(
                        label: l10n.matchReachOutFinishDoneButton,
                        onInvertedBackground: true,
                        onPressed: () {
                          // Pop back to match detail (pop twice: finish -> preview -> reach out -> detail)
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return Container(
      decoration: AppLayoutStyles.cardDecoration(context),
      padding: AppModifiers.cardContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message text (includes greeting, message body, and signature)
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: venyuTheme.primaryText,
            ),
          ),

          // Contact information section
          if (selectedContacts.isNotEmpty) ...[
            const SizedBox(height: 16),

            // Divider (3 dashes)
            Text(
              '---',
              style: AppTextStyles.body.copyWith(
                color: venyuTheme.secondaryText,
              ),
            ),

            const SizedBox(height: 16),

            // Contact information list
            ...selectedContacts.map(
              (contact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${contact.label}: ${contact.value}',
                  style: AppTextStyles.body.copyWith(
                    color: venyuTheme.primaryText,
                  ),
                ),
              ),
            ),
          ],

          // PS message
          const SizedBox(height: 16),
          Text(
            l10n.matchReachOutPreviewPS,
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.secondaryText,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
