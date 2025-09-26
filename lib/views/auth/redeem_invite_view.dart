import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../base/base_code_entry_view.dart';
import '../../services/supabase_managers/profile_manager.dart';
import 'onboard_view.dart';

/// Redeem invite code view for new users after authentication.
///
/// This view extends BaseCodeEntryView to provide invite code redemption
/// functionality before starting the onboarding process.
class RedeemInviteView extends BaseCodeEntryView {
  const RedeemInviteView({super.key})
    : super(
        title: 'Enter your invite code',
        subtitle: 'Please enter the 8-character invite code you received to continue.',
        buttonLabel: 'Continue',
      );

  @override
  State<RedeemInviteView> createState() => _RedeemInviteViewState();
}

class _RedeemInviteViewState extends BaseCodeEntryViewState<RedeemInviteView> {
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