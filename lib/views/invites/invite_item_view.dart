import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/invite.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// InviteItemView - Component for displaying invite codes with status and information
///
/// Shows invite code, status (Available/Sent/Redeemed), and allows interaction.
/// Based on VenueItemView pattern but adapted for Invite objects.
class InviteItemView extends StatelessWidget {
  final Invite invite;
  final VoidCallback? onTap;
  final Function(Invite)? onMenuTap; // Callback with invite object

  const InviteItemView({
    super.key,
    required this.invite,
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Different card types based on status
    if (!invite.isRedeemed && !invite.isSent) {
      // Available - interactive card
      return AppLayoutStyles.interactiveCard(
        context: context,
        onTap: () => onMenuTap?.call(invite),
        child: Padding(
          padding: AppModifiers.cardContentPadding,
          child: _buildContent(context),
        ),
      );
    } else if (invite.isSent) {
      // Sent - regular card decoration
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Padding(
          padding: AppModifiers.cardContentPadding,
          child: _buildContent(context),
        ),
      );
    } else {
      // Redeemed - card decoration with gray background
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: AppLayoutStyles.cardDecoration(context).copyWith(
          color: venyuTheme.secondaryText.withValues(alpha: 0.08),
        ),
        child: Padding(
          padding: AppModifiers.cardContentPadding,
          child: _buildContent(context),
        ),
      );
    }
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
              // Invite code with conditional styling - selectable only for available codes
              (!invite.isRedeemed && !invite.isSent)
                  ? SelectableText(
                      invite.code,
                      style: AppTextStyles.headline.copyWith(
                        color: _getCodeColor(context),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        decoration: invite.isRedeemed ? TextDecoration.lineThrough : null,
                        decorationStyle: invite.isRedeemed ? TextDecorationStyle.wavy : null,
                        decorationColor: _getCodeColor(context),
                        
                      ),
                    )
                  : Text(
                      invite.code,
                      style: AppTextStyles.headline.copyWith(
                        color: _getCodeColor(context),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        decoration: invite.isRedeemed ? TextDecoration.lineThrough : null,
                        decorationStyle: invite.isRedeemed ? TextDecorationStyle.wavy : null,
                        decorationColor: _getCodeColor(context),
                      ),
                    ),

            ],
          ),
        ),

        // Three dots icon - only show for truly available codes (not sent, not redeemed)
        if (!invite.isRedeemed && !invite.isSent) ...[
          const SizedBox(width: 8),
          Icon(
            CupertinoIcons.ellipsis,
            size: 18,
            color: venyuTheme.primaryText,
          ),
        ],
      ],
    );
  }


  /// Get color for the invite code text based on status
  Color _getCodeColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    if (invite.isRedeemed) {
      return venyuTheme.secondaryText.withValues(alpha: 0.3); // Very light gray for redeemed (30%)
    } else if (invite.isSent) {
      return venyuTheme.secondaryText.withValues(alpha: 0.6); // Darker gray for sent (60%)
    } else {
      return venyuTheme.primaryText; // Normal color for available
    }
  }

}