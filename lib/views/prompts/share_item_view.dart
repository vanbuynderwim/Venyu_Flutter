import 'package:flutter/cupertino.dart';
import '../../models/prompt_share.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// ShareItemView - Component for displaying prompt share links
///
/// Shows the shareable URL (share.getvenyu.com/slug) and allows interaction.
/// Based on InviteItemView pattern but adapted for PromptShare objects.
class ShareItemView extends StatelessWidget {
  final PromptShare share;
  final VoidCallback? onTap;
  final Function(PromptShare)? onMenuTap;

  const ShareItemView({
    super.key,
    required this.share,
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayoutStyles.interactiveCard(
      context: context,
      onTap: () => onMenuTap?.call(share),
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Row(
      children: [
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Share URL
              Text(
                'share.getvenyu.com/${share.slug}',
                style: AppTextStyles.headline.copyWith(
                  color: venyuTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Stats row
              Text(
                _buildStatsText(),
                style: AppTextStyles.caption1.copyWith(
                  color: venyuTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),

        // Three dots icon
        const SizedBox(width: 8),
        Icon(
          CupertinoIcons.ellipsis,
          size: 18,
          color: venyuTheme.primaryText,
        ),
      ],
    );
  }

  /// Build the stats text showing view count and codes info
  String _buildStatsText() {
    final parts = <String>[];

    // View count
    if (share.viewCount != null && share.viewCount! > 0) {
      parts.add('${share.viewCount} ${share.viewCount == 1 ? 'view' : 'views'}');
    }

    // Codes stats
    final codesIssued = share.codesIssued ?? 0;
    final codesRedeemed = share.codesRedeemed ?? 0;
    final maxCodes = share.maxCodes;

    if (maxCodes != null) {
      parts.add('$codesRedeemed/$codesIssued codes used');
    } else if (codesIssued > 0) {
      parts.add('$codesRedeemed/$codesIssued codes used');
    }

    return parts.isNotEmpty ? parts.join(' • ') : '';
  }
}
