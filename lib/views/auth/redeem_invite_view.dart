import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../base/base_code_entry_view.dart';
import '../../services/supabase_managers/profile_manager.dart';
import 'onboard_view.dart';

/// Redeem invite code view for new users after authentication.
///
/// This view extends BaseCodeEntryView to provide invite code redemption
/// functionality before starting the onboarding process.
class RedeemInviteView extends StatelessWidget {
  const RedeemInviteView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _RedeemInviteViewImpl(
      title: l10n.redeemInviteTitle,
      subtitle: l10n.redeemInviteSubtitle,
      buttonLabel: l10n.redeemInviteContinue,
      placeholder: l10n.redeemInvitePlaceholder,
    );
  }
}

class _RedeemInviteViewImpl extends BaseCodeEntryView {
  const _RedeemInviteViewImpl({
    required super.title,
    required super.subtitle,
    required super.buttonLabel,
    required super.placeholder,
  });

  @override
  State<_RedeemInviteViewImpl> createState() => _RedeemInviteViewState();
}

class _RedeemInviteViewState extends BaseCodeEntryViewState<_RedeemInviteViewImpl> {
  @override
  String get logContext => 'RedeemInviteView';

  @override
  Future<void> handleCodeSubmission(String code) async {
    // Call ProfileManager to redeem the invite code
    await ProfileManager.shared.redeemInviteCode(code);
  }

  @override
  void handleSuccess() {
    // Navigate to OnboardView on successful redemption
    Navigator.of(context).pushReplacement(
      platformPageRoute(
        context: context,
        builder: (context) => const OnboardView(),
      ),
    );
  }
}