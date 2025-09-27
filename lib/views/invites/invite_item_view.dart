import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/invite.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/common/tag_view.dart';

/// InviteItemView - Component for displaying invite codes with status and information
///
/// Shows invite code, status (Available/Sent/Redeemed), and allows interaction.
/// Based on VenueItemView pattern but adapted for Invite objects.
class InviteItemView extends StatelessWidget {
  final Invite invite;
  final VoidCallback? onTap;

  const InviteItemView({
    super.key,
    required this.invite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Different card types based on status
    if (!invite.isRedeemed && !invite.isSent) {
      // Available - interactive card
      return AppLayoutStyles.interactiveCard(
        context: context,
        onTap: onTap,
        child: Padding(
          padding: AppModifiers.cardContentPadding,
          child: _buildContent(context),
        ),
      );
    } else if (invite.isSent) {
      // Sent - regular card without gray background
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Padding(
          padding: AppModifiers.cardContentPadding,
          child: _buildContent(context),
        ),
      );
    } else {
      // Redeemed - regular card with gray overlay
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Stack(
          children: [
            // Gray overlay only for redeemed
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: venyuTheme.secondaryText.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
                ),
              ),
            ),
            // Content
            Padding(
              padding: AppModifiers.cardContentPadding,
              child: _buildContent(context),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Row(
      children: [
        // Ticket icon with conditional color
        _buildTicketIcon(context),

        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invite code with conditional styling
              Text(
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

              const SizedBox(height: 4),

              // Status tag with transparent background for sent/redeemed
              TagView(
                id: 'status',
                label: invite.statusDescription,
                fontSize: AppTextStyles.caption1,
                backgroundColor: (!invite.isRedeemed && !invite.isSent)
                    ? venyuTheme.primary.withValues(alpha: 0.08)  // Normal background for available
                    : _getStatusColor(context).withValues(alpha: 0.05),  // Transparent for sent/redeemed
                textColor: _getStatusColor(context),
              ),
            ],
          ),
        ),

        // Three dots menu button - only show for truly available codes (not sent, not redeemed)
        if (!invite.isRedeemed && !invite.isSent) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: Show menu with options
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: venyuTheme.cardBackground.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: venyuTheme.borderColor,
                  width: AppModifiers.extraThinBorder,
                ),
              ),
              child: Icon(
                CupertinoIcons.ellipsis,
                size: 18,
                color: venyuTheme.primaryText,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build ticket icon with conditional color
  Widget _buildTicketIcon(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    // Use same color as the code text for consistency
    Color iconColor;
    if (invite.isRedeemed) {
      iconColor = venyuTheme.secondaryText.withValues(alpha: 0.3);
    } else if (invite.isSent) {
      iconColor = venyuTheme.secondaryText.withValues(alpha: 0.6);
    } else {
      // For available codes, use default theming
      return context.themedIcon('ticket', size: 24, overrideColor: venyuTheme.primary);
    }

    // For sent/redeemed, use themed icon with override color
    return context.themedIcon('ticket', size: 24, overrideColor: iconColor);
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

  /// Get color for the status tag based on invite status
  Color _getStatusColor(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    if (invite.isRedeemed) {
      return venyuTheme.secondaryText.withValues(alpha: 0.3); // Match code color for redeemed
    } else if (invite.isSent) {
      return venyuTheme.secondaryText.withValues(alpha: 0.8); // Slightly darker than code for sent
    } else {
      return venyuTheme.secondaryText; // Primary color for available
    }
  }
}