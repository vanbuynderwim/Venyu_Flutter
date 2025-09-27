import 'package:flutter/material.dart';

import '../../../widgets/common/loading_state_widget.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/invite.dart';
import '../../invites/invite_item_view.dart';

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

  const InvitesSection({
    super.key,
    this.inviteCodes,
    this.inviteCodesLoading = false,
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

    // Invite codes found - show list of invite items
    return Column(
      children: List.generate(widget.inviteCodes!.length, (index) {
        final invite = widget.inviteCodes![index];
        return InviteItemView(
          invite: invite,
          onTap: () {
            AppLogger.info('Tapped on invite code: ${invite.code}', context: 'InvitesSection');
            // TODO: Add invite detail/share functionality
          },
        );
      }),
    );
  }
}