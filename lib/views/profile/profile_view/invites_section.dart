import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../core/utils/dialog_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/invite.dart';
import '../../../services/toast_service.dart';
import '../../../services/profile_service.dart';
import '../../invites/invite_item_view.dart';

/// Enum for invite menu actions
enum _InviteAction { share, copy, markSent }

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
  final VoidCallback? onRefreshRequested;

  const InvitesSection({
    super.key,
    this.inviteCodes,
    this.inviteCodesLoading = false,
    this.onInviteMarkedAsSent,
    this.onRefreshRequested,
  });

  @override
  State<InvitesSection> createState() => _InvitesSectionState();
}

class _InvitesSectionState extends State<InvitesSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            message: l10n.invitesEmptyTitle,
            description: l10n.invitesEmptyDescription,
            iconName: 'notickets',
            actionText: l10n.invitesEmptyAction,
            actionButtonIcon: context.themedIcon('plus'),
            onAction: () => _generateMoreCodes(context),
          ),
        ),
      );
    }

    // Group invites by status to check if there are available codes
    final availableInvites = widget.inviteCodes!.where((invite) => !invite.isSent && !invite.isRedeemed).toList();
    final hasAvailableCodes = availableInvites.isNotEmpty;

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
                // Section title and description - different based on availability
                Text(
                  hasAvailableCodes
                    ? l10n.invitesAvailableDescription(availableInvites.length, availableInvites.length == 1 ? l10n.invitesCode : l10n.invitesCodes)
                    : l10n.invitesAllSharedDescription,
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.primaryText,
                  ),
                ),

                // Only show button if no available codes
                if (!hasAvailableCodes) ...[
                  const SizedBox(height: 16),
                  // Generate more codes button
                  ActionButton(
                    label: l10n.invitesGenerateMore,
                    icon: context.themedIcon('plus'),
                    onPressed: () => _generateMoreCodes(context),
                    isCompact: false,
                  ),
                ],
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
      final l10n = AppLocalizations.of(context)!;
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'ticket',
          title: l10n.invitesSubtitleAvailable,
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
      final l10n = AppLocalizations.of(context)!;
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'email',
          title: l10n.invitesSubtitleShared,
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
      final l10n = AppLocalizations.of(context)!;
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: SubTitle(
          iconName: 'checkbox',
          title: l10n.invitesSubtitleRedeemed,
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

  /// Shows the invite menu using centralized DialogUtils component
  Future<void> _showInviteMenu(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    final menuOptions = [
      MenuOptionBuilder.create(
        context: context,
        label: l10n.invitesMenuShare,
        iconName: 'share',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
      ),
      MenuOptionBuilder.create(
        context: context,
        label: l10n.invitesMenuCopy,
        iconName: 'copy',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
      ),
      MenuOptionBuilder.create(
        context: context,
        label: l10n.invitesMenuMarkShared,
        iconName: 'email',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
      ),
    ];

    // Show the menu using centralized DialogUtils
    final selectedAction = await DialogUtils.showMenuModalSheet<_InviteAction>(
      context: context,
      menuOptions: menuOptions,
      actions: [
        _InviteAction.share,
        _InviteAction.copy,
        _InviteAction.markSent,
      ],
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
      case null:
        // User cancelled or tapped outside
        break;
    }
  }

  /// Share invite functionality
  Future<void> _shareInvite(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.info('Share invite code: ${invite.code}', context: 'InvitesSection');

    // Voor iPad: gebruik het centrum van het scherm als anchor point
    final screenSize = MediaQuery.of(context).size;
    final origin = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: 1,
      height: 1,
    );

    final text = l10n.invitesShareText(invite.code);

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: l10n.invitesShareSubject,
        sharePositionOrigin: origin, // belangrijk voor iPad
      ),
    );
  }

  /// Copy invite functionality
  Future<void> _copyInvite(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: invite.code));
    AppLogger.info('Copied invite code to clipboard: ${invite.code}', context: 'InvitesSection');

    if (context.mounted) {
      ToastService.success(
        context: context,
        message: l10n.invitesCopiedToast,
      );
    }
  }

  /// Mark as sent functionality
  Future<void> _markAsSent(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.info('Mark as sent: ${invite.code}', context: 'InvitesSection');

    try {
      final profileService = context.read<ProfileService>();
      await profileService.markInviteCodeAsSent(invite.id);

      // Notify parent to update local state
      widget.onInviteMarkedAsSent?.call(invite.id);

      if (context.mounted) {
        ToastService.success(
          context: context,
          message: l10n.invitesMarkedSentToast,
        );
      }
    } catch (error) {
      AppLogger.error('Failed to mark invite as sent', error: error, context: 'InvitesSection');

      if (context.mounted) {
        ToastService.error(
          context: context,
          message: l10n.invitesMarkedSentError,
        );
      }
    }
  }

  /// Generate more invite codes functionality
  Future<void> _generateMoreCodes(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.info('Generate more codes button tapped', context: 'InvitesSection');

    try {
      final profileService = context.read<ProfileService>();

      // Show confirmation dialog first
      final confirmed = await DialogUtils.showConfirmationDialog(
        context: context,
        title: l10n.invitesGenerateDialogTitle,
        message: l10n.invitesGenerateDialogMessage,
        confirmText: l10n.invitesGenerateDialogConfirm,
        cancelText: l10n.invitesGenerateDialogCancel,
        isDestructive: false,
      );

      if (!confirmed || !context.mounted) return;

      // Generate 5 new invite codes
      await profileService.issueProfileInviteCodes(count: 5);

      // Trigger refresh of invite codes
      widget.onRefreshRequested?.call();

      if (context.mounted) {
        ToastService.success(
          context: context,
          message: l10n.invitesGenerateSuccessToast,
        );
      }
    } catch (error) {
      AppLogger.error('Failed to generate invite codes', error: error, context: 'InvitesSection');

      if (context.mounted) {
        ToastService.error(
          context: context,
          message: l10n.invitesGenerateErrorToast,
        );
      }
    }
  }
}