import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/menus/menu_option_builder.dart';
import '../../core/utils/app_logger.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/dialog_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/invite.dart';
import '../../services/toast_service.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../invites/invite_item_view.dart';

/// Enum for invite menu actions
enum _InviteAction { share, copy, markSent }

/// InviteCodesView - Standalone view for managing invite codes
///
/// This view displays and manages the user's invite codes including:
/// - Available invites
/// - Sent invitations
/// - Redeemed codes
///
/// Features:
/// - Loading states and empty states
/// - Invite management functionality (share, copy, mark as sent)
/// - Generate new codes
class InviteCodesView extends StatefulWidget {
  const InviteCodesView({super.key});

  @override
  State<InviteCodesView> createState() => _InviteCodesViewState();
}

class _InviteCodesViewState extends State<InviteCodesView> {
  List<Invite>? _inviteCodes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInviteCodes();
  }

  Future<void> _loadInviteCodes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final codes = await ProfileManager.shared.getMyInviteCodes();

      if (mounted) {
        setState(() {
          _inviteCodes = codes;
          _isLoading = false;
        });
      }
    } catch (error) {
      AppLogger.error('Failed to load invite codes', error: error, context: 'InviteCodesView');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.accountSettingsInviteCodesTitle),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadInviteCodes,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const LoadingStateWidget();
    }

    if (_inviteCodes == null || _inviteCodes!.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: l10n.invitesEmptyTitle,
          description: l10n.invitesEmptyDescription,
          iconName: 'notickets',
          actionText: l10n.invitesEmptyAction,
          actionButtonIcon: context.themedIcon('plus'),
          onAction: () => _generateMoreCodes(context),
        ),
      );
    }

    // Group invites by status to check if there are available codes
    final availableInvites = _inviteCodes!.where((invite) => !invite.isSent && !invite.isRedeemed).toList();
    final hasAvailableCodes = availableInvites.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning box when there are available codes
        if (hasAvailableCodes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: WarningBoxWidget(
              text: l10n.invitesAvailableDescription(
                availableInvites.length,
                availableInvites.length == 1 ? l10n.invitesCode : l10n.invitesCodes,
              ),
            ),
          ),

        // Container with action button when no available codes
        if (!hasAvailableCodes)
          Container(
            decoration: AppLayoutStyles.cardDecoration(context),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description text
                Text(
                  l10n.invitesAllSharedDescription,
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                // Generate more codes button
                ActionButton(
                  label: l10n.invitesGenerateMore,
                  icon: context.themedIcon('plus'),
                  onPressed: () => _generateMoreCodes(context),
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
    final invites = _inviteCodes!;

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
        onTap: (_) {},
      ),
      MenuOptionBuilder.create(
        context: context,
        label: l10n.invitesMenuCopy,
        iconName: 'copy',
        onTap: (_) {},
      ),
      MenuOptionBuilder.create(
        context: context,
        label: l10n.invitesMenuMarkShared,
        iconName: 'email',
        onTap: (_) {},
      ),
    ];

    final selectedAction = await DialogUtils.showMenuModalSheet<_InviteAction>(
      context: context,
      menuOptions: menuOptions,
      actions: [
        _InviteAction.share,
        _InviteAction.copy,
        _InviteAction.markSent,
      ],
    );

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
        break;
    }
  }

  /// Share invite functionality
  Future<void> _shareInvite(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.info('Share invite code: ${invite.code}', context: 'InviteCodesView');

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
        sharePositionOrigin: origin,
      ),
    );
  }

  /// Copy invite functionality
  Future<void> _copyInvite(BuildContext context, Invite invite) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: invite.code));
    AppLogger.info('Copied invite code to clipboard: ${invite.code}', context: 'InviteCodesView');

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
    AppLogger.info('Mark as sent: ${invite.code}', context: 'InviteCodesView');

    try {
      final profileService = context.read<ProfileService>();
      await profileService.markInviteCodeAsSent(invite.id);

      // Update local state
      if (mounted) {
        setState(() {
          final index = _inviteCodes?.indexWhere((i) => i.id == invite.id);
          if (index != null && index >= 0) {
            _inviteCodes![index] = _inviteCodes![index].copyWith(isSent: true);
          }
        });
      }

      if (context.mounted) {
        ToastService.success(
          context: context,
          message: l10n.invitesMarkedSentToast,
        );
      }
    } catch (error) {
      AppLogger.error('Failed to mark invite as sent', error: error, context: 'InviteCodesView');

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
    AppLogger.info('Generate more codes button tapped', context: 'InviteCodesView');

    try {
      final profileService = context.read<ProfileService>();

      final confirmed = await DialogUtils.showConfirmationDialog(
        context: context,
        title: l10n.invitesGenerateDialogTitle,
        message: l10n.invitesGenerateDialogMessage,
        confirmText: l10n.invitesGenerateDialogConfirm,
        cancelText: l10n.invitesGenerateDialogCancel,
        isDestructive: false,
      );

      if (!confirmed || !context.mounted) return;

      await profileService.issueProfileInviteCodes(count: 5);

      // Refresh the list
      await _loadInviteCodes();

      if (context.mounted) {
        ToastService.success(
          context: context,
          message: l10n.invitesGenerateSuccessToast,
        );
      }
    } catch (error) {
      AppLogger.error('Failed to generate invite codes', error: error, context: 'InviteCodesView');

      if (context.mounted) {
        ToastService.error(
          context: context,
          message: l10n.invitesGenerateErrorToast,
        );
      }
    }
  }
}
