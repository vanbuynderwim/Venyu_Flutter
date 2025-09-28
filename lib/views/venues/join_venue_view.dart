import 'package:flutter/material.dart';

import '../base/base_code_entry_view.dart';
import '../../services/supabase_managers/venue_manager.dart';

/// Join venue view for entering venue invite codes.
///
/// This view extends BaseCodeEntryView to provide venue joining functionality.
class JoinVenueView extends BaseCodeEntryView {
  const JoinVenueView({super.key})
    : super(
        title: 'Join venue',
        subtitle: 'Enter the 8-character invite code to join.',
        buttonLabel: 'Join',
        showCloseButton: true,
      );

  @override
  State<JoinVenueView> createState() => _JoinVenueViewState();
}

class _JoinVenueViewState extends BaseCodeEntryViewState<JoinVenueView> {
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