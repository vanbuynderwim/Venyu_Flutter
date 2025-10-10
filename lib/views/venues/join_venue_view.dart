import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../base/base_code_entry_view.dart';
import '../../services/supabase_managers/venue_manager.dart';

/// Join venue view for entering venue invite codes.
///
/// This view extends BaseCodeEntryView to provide venue joining functionality.
class JoinVenueView extends StatelessWidget {
  const JoinVenueView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _JoinVenueViewImpl(
      title: l10n.joinVenueTitle,
      subtitle: l10n.joinVenueSubtitle,
      buttonLabel: l10n.joinVenueButton,
      placeholder: l10n.joinVenuePlaceholder,
    );
  }
}

class _JoinVenueViewImpl extends BaseCodeEntryView {
  const _JoinVenueViewImpl({
    required super.title,
    required super.subtitle,
    required super.buttonLabel,
    required super.placeholder,
  }) : super(showCloseButton: true);

  @override
  State<_JoinVenueViewImpl> createState() => _JoinVenueViewState();
}

class _JoinVenueViewState extends BaseCodeEntryViewState<_JoinVenueViewImpl> {
  @override
  String get logContext => 'JoinVenueView';

  @override
  Future<void> handleCodeSubmission(String code) async {
    // Call VenueManager to join the venue
    await VenueManager.shared.joinVenue(code);
  }

  @override
  void handleSuccess() {
    // Close modal with success result
    // The true value signals that venues should be refreshed
    Navigator.of(context).pop(true);
  }
}