import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/sub_title.dart';
import '../../../widgets/buttons/action_button.dart';
import '../../../widgets/menus/menu_option_builder.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_layout_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/invite.dart';
import '../../../services/toast_service.dart';
import '../../../services/profile_service.dart';
import '../../invites/invite_item_view.dart';

/// Enum for invite menu actions
enum _InviteAction { share, copy, markSent, none }

/// InvitesSection - Invites and invitations section
///
/// This widget displays the user's invites and invitations including:
/// - Available invites
/// - Sent invitations
/// - Invite history
///
/// Features:
/// - Loading states and empty states
/// - Invite management functionality
/// - Invitation tracking
class InvitesSection extends StatefulWidget {
  final List<Invite>? inviteCodes;
  final bool inviteCodesLoading;
  final Function(String codeId)? onInviteMarkedAsSent;

  const InvitesSection({
    super.key,
    this.inviteCodes,
    this.inviteCodesLoading = false,
    this.onInviteMarkedAsSent,
  });

  @override
  State<InvitesSection> createState() => _InvitesSectionState();
}

class _InvitesSectionState extends State<InvitesSection> {
  @override
  Widget build(BuildContext context) {
    AppLogger.debug('Building invites section. InviteCodes: ${widget.inviteCodes?.length ?? 'null'}, Loading: ${widget.inviteCodesLoading}', context: 'InvitesSection');

    if (widget.inviteCodesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LoadingStateWidget(),
      );
    }

    if (widget.inviteCodes == null || widget.inviteCodes!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: EmptyStateWidget(
            message: 'No invite codes yet',
            description: 'Your invite codes will appear here. You can share them with friends to invite them to Venyu.',
            iconName: 'ticket',
            actionText: null, // No action button for now
          ),
        ),
      );
    }

    // Invite codes found - show header card and list of invite items
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card with title, description and action button
          Container(
            decoration: AppLayoutStyles.cardDecoration(context),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title and description
                Text(
                  'Share these codes with friends to invite them to Venyu. Each code can only be used once.',
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.primaryText,
                  ),
                ),

                const SizedBox(height: 16),

                // Generate more codes button
                ActionButton(
                  label: 'Generate More Codes',
                  icon: context.themedIcon('plus'),
                  onPressed: () {
                    AppLogger.info('Generate more codes button tapped', context: 'InvitesSection');
                    // TODO: Add generate more codes functionality
                  },
                  isCompact: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Invite codes list with subtitles
          ..._buildInviteListWithSubtitles(),
        ],
      );
  }

  /// Builds the invite list with appropriate subtitles for different statuses
  List<Widget> _buildInviteListWithSubtitles() {
    final widgets = <Widget>[];
    final invites = widget.inviteCodes!;

    // Group invites by status: available, sent, redeemed
    final availableInvites = invites.where((invite) => !invite.isSent && !invite.isRedeemed).toList();
    final sentInvites = invites.where((invite) => invite.isSent && !invite.isRedeemed).toList();
    final redeemedInvites = invites.where((invite) => invite.isRedeemed).toList();

    // Add available invites with subtitle
    if (availableInvites.isNotEmpty) {
      widgets.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'ticket',
          title: 'Available',
        ),
      ));

      for (final invite in availableInvites) {
        widgets.add(InviteItemView(
          invite: invite,
          onMenuTap: (invite) => _showInviteMenu(context, invite),
        ));
      }
    }

    // Add sent invites with subtitle
    if (sentInvites.isNotEmpty) {
      widgets.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'email',
          title: 'Sent (pending)',
        ),
      ));

      for (final invite in sentInvites) {
        widgets.add(InviteItemView(
          invite: invite,
          onTap: () {
            AppLogger.info('Tapped on invite code: ${invite.code}', context: 'InvitesSection');
            // TODO: Add invite detail/share functionality
          },
        ));
      }
    }

    // Add redeemed invites with subtitle
    if (redeemedInvites.isNotEmpty) {
      widgets.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'checkbox',
          title: 'Redeemed',
        ),
      ));

      for (final invite in redeemedInvites) {
        widgets.add(InviteItemView(
          invite: invite,
          onTap: () {
            AppLogger.info('Tapped on invite code: ${invite.code}', context: 'InvitesSection');
            // TODO: Add invite detail/share functionality
          },
        ));
      }
    }

    return widgets;
  }

  /// Shows the invite menu using PlatformPopupMenu with MenuOptionBuilder
  Future<void> _showInviteMenu(BuildContext context, Invite invite) async {
    final menuOptions = [
      MenuOptionBuilder.create(
        context: context,
        label: 'Share invite code',
        iconName: 'share',
        onTap: (_) {},  // Dummy onTap, we'll handle it differently
      ),
      MenuOptionBuilder.create(
        context: context,
        label: 'Copy',
        iconName: 'copy',
        onTap: (_) {},  // Dummy onTap
      ),
      MenuOptionBuilder.create(
        context: context,
        label: 'Mark as sent',
        iconName: 'email',
        onTap: (_) {},  // Dummy onTap
      ),
    ];

    // Show the menu as a modal and wait for the selected action
    final selectedAction = await showPlatformModalSheet<_InviteAction>(
      context: context,
      builder: (sheetContext) => PlatformWidget(
        cupertino: (_, __) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, _InviteAction.share),
              child: menuOptions[0].cupertino?.call(context, PlatformTarget.iOS).child ?? Container(),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, _InviteAction.copy),
              child: menuOptions[1].cupertino?.call(context, PlatformTarget.iOS).child ?? Container(),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, _InviteAction.markSent),
              child: menuOptions[2].cupertino?.call(context, PlatformTarget.iOS).child ?? Container(),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(sheetContext, _InviteAction.none),
            child: const Text('Cancel'),
          ),
        ),
        material: (_, __) => Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.pop(sheetContext, _InviteAction.share),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: menuOptions[0].material?.call(context, PlatformTarget.android).child ?? Container(),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(sheetContext, _InviteAction.copy),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: menuOptions[1].material?.call(context, PlatformTarget.android).child ?? Container(),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(sheetContext, _InviteAction.markSent),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: menuOptions[2].material?.call(context, PlatformTarget.android).child ?? Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Sheet is now closed - perform the action
    if (!context.mounted) return;

    switch (selectedAction) {
      case _InviteAction.share:
        await _shareInvite(context, invite);
        break;
      case _InviteAction.copy:
        await _copyInvite(context, invite);
        break;
      case _InviteAction.markSent:
        await _markAsSent(context, invite);
        break;
      case _InviteAction.none:
      case null:
        // User cancelled or tapped outside
        break;
    }
  }

  /// Share invite functionality
  Future<void> _shareInvite(BuildContext context, Invite invite) async {
    AppLogger.info('Share invite code: ${invite.code}', context: 'InvitesSection');

    // Voor iPad: gebruik het centrum van het scherm als anchor point
    final screenSize = MediaQuery.of(context).size;
    final origin = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: 1,
      height: 1,
    );

    await Share.share(
      'Join me on Venyu! Use my invite code: ${invite.code}',
      subject: 'Your personal Venyu invite',
      sharePositionOrigin: origin, // belangrijk voor iPad
    );
  }

  /// Copy invite functionality
  Future<void> _copyInvite(BuildContext context, Invite invite) async {
    await Clipboard.setData(ClipboardData(text: invite.code));
    AppLogger.info('Copied invite code to clipboard: ${invite.code}', context: 'InvitesSection');

    if (context.mounted) {
      ToastService.success(
        context: context,
        message: 'Invite code copied to clipboard',
      );
    }
  }

  /// Mark as sent functionality
  Future<void> _markAsSent(BuildContext context, Invite invite) async {
    AppLogger.info('Mark as sent: ${invite.code}', context: 'InvitesSection');

    try {
      final profileService = context.read<ProfileService>();
      await profileService.markInviteCodeAsSent(invite.id);

      // Notify parent to update local state
      widget.onInviteMarkedAsSent?.call(invite.id);

      if (context.mounted) {
        ToastService.success(
          context: context,
          message: 'Invite code marked as sent',
        );
      }
    } catch (error) {
      AppLogger.error('Failed to mark invite as sent', error: error, context: 'InvitesSection');

      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to mark invite as sent',
        );
      }
    }
  }
}