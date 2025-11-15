import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// Reusable widget for displaying community guidelines
///
/// This widget shows the community guidelines that define
/// what content is allowed and prohibited on the platform.
/// The title can be optionally hidden with showTitle parameter.
class CommunityGuidelinesWidget extends StatelessWidget {
  /// Custom padding around the widget
  final EdgeInsets? padding;
  /// Whether to show the "Community guidelines" title
  final bool showTitle;

  const CommunityGuidelinesWidget({
    super.key,
    this.padding,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title - conditionally shown and centered
          if (showTitle) ...[
            Center(
              child: Text(
                l10n.communityGuidelinesTitle,
                style: AppTextStyles.caption1.copyWith(
                  color: context.venyuTheme.darkText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
          ],

          Container(
            padding: const EdgeInsets.all(16),
            //decoration: AppLayoutStyles.cardDecoration(context, withBackground: false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Allowed content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅  ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Text(
                        l10n.communityGuidelinesAllowed,
                        style: AppTextStyles.footnote.copyWith(
                          color: context.venyuTheme.darkText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Prohibited content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '❌  ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Text(
                        l10n.communityGuidelinesProhibited,
                        style: AppTextStyles.footnote.copyWith(
                          color: context.venyuTheme.darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}