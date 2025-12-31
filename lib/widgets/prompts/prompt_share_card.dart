import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../models/prompt_share.dart';
import '../buttons/action_button.dart';
import '../common/sub_title.dart';

/// A card widget for displaying prompt share functionality.
///
/// Can be displayed in two modes:
/// - Normal mode: Full card with title, description, optional URL, and share button
/// - Compact mode: Description, URL with icon-only share button (for daily prompts view)
class PromptShareCard extends StatefulWidget {
  /// The prompt share object (optional, shows URL if available)
  final PromptShare? share;

  /// Async callback to create a share if one doesn't exist yet
  /// Should return the created PromptShare or null if creation failed
  final Future<PromptShare?> Function()? onCreateShare;

  /// The prompt label (used for generating share text)
  final String promptLabel;

  /// Whether to display in compact mode (for daily prompts view)
  final bool compact;

  const PromptShareCard({
    super.key,
    this.share,
    this.onCreateShare,
    required this.promptLabel,
    this.compact = false,
  });

  @override
  State<PromptShareCard> createState() => _PromptShareCardState();
}

class _PromptShareCardState extends State<PromptShareCard> {
  bool _isLoading = false;

  /// Opens the system share sheet with the prompt share link
  /// Creates a share first if one doesn't exist
  Future<void> _openShareSheet() async {
    PromptShare? shareToUse = widget.share;

    // If no share exists, create one first
    if (shareToUse == null) {
      if (widget.onCreateShare == null) return;

      setState(() => _isLoading = true);

      try {
        shareToUse = await widget.onCreateShare!();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }

      if (shareToUse == null) return;
    }

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    AppLogger.info('Sharing link: ${shareToUse.slug}', context: 'PromptShareCard');

    final screenSize = MediaQuery.of(context).size;
    final origin = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: 1,
      height: 1,
    );

    final url = 'https://share.getvenyu.com/${shareToUse.slug}';
    final question = '${l10n.interactionTypeLookingForThisSelection} ${widget.promptLabel}';
    final text = l10n.sharesShareText(question, url);

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: l10n.sharesShareSubject,
        sharePositionOrigin: origin,
      ),
    );
  }

  bool get _isLoadingState => _isLoading;

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return Container(
      decoration: AppLayoutStyles.cardDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          SubTitle(
            title: l10n.sharesSectionTitle,
          ),
          const SizedBox(height: 16),
          // Description text
          Text(
            l10n.sharesSectionDescription,
            style: AppTextStyles.subheadline.copyWith(
              color: venyuTheme.secondaryText,
            ),
          ),
          // URL if share exists
          if (widget.share != null) ...[
            const SizedBox(height: 12),
            Text(
              'share.getvenyu.com/${widget.share!.slug}',
              style: AppTextStyles.caption1.copyWith(
                color: venyuTheme.secondaryText,
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Share link button
          ActionButton(
            label: l10n.sharesShareLinkButton,
            icon: context.themedIcon('share'),
            onPressed: _isLoadingState ? null : _openShareSheet,
            isLoading: _isLoadingState,
            isCompact: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;

    return GestureDetector(
      onTap: _isLoadingState ? null : _openShareSheet,
      child: Container(
        decoration: AppLayoutStyles.cardDecoration(context),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Description text
            Expanded(
              child: Text(
                l10n.sharesSectionDescription,
                style: AppTextStyles.subheadline2.copyWith(
                  color: venyuTheme.primaryText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Share icon or loading indicator
            if (_isLoadingState)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: venyuTheme.primary,
                ),
              )
            else
              context.themedIcon('share', selected: false, overrideColor: venyuTheme.primary),
          ],
        ),
      ),
    );
  }
}
