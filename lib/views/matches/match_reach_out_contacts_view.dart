import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/contact.dart';
import '../../models/match.dart';
import '../../models/stage.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../base/base_form_view.dart';
import '../profile/edit_contact_setting_view.dart';
import 'match_reach_out_preview_view.dart';

/// A form screen for selecting additional contact information to share.
///
/// This widget provides:
/// - List of contact settings that can be shared
///
/// Contact settings with values can be multi-selected.
/// Contact settings without values navigate to edit screen.
class MatchReachOutContactsView extends BaseFormView {
  final Match match;
  final String message;

  const MatchReachOutContactsView({
    super.key,
    required this.match,
    required this.message,
  });

  @override
  BaseFormViewState<BaseFormView> createState() =>
      _MatchReachOutContactsViewState();
}

class _MatchReachOutContactsViewState
    extends BaseFormViewState<MatchReachOutContactsView> {
  List<Contact>? _contacts;
  bool _contactsLoading = true;
  final Set<String> _selectedContactIds = {};

  @override
  String getFormTitle() => AppLocalizations.of(context)!.matchReachOutTitle;

  @override
  void initializeForm() {
    super.initializeForm();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _contactsLoading = true);

    try {
      final contacts = await ProfileManager.shared.getProfileContactSettings();
      if (mounted) {
        setState(() {
          _contacts = contacts;
          _contactsLoading = false;
          // Pre-select all contacts that have a value
          for (final contact in contacts) {
            if (contact.hasValue) {
              _selectedContactIds.add(contact.id);
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _contactsLoading = false);
      }
    }
  }

  @override
  String getSuccessMessage() => '';

  @override
  String getErrorMessage() => '';

  @override
  bool get canSave => true; // Always allow to proceed (contacts are optional)

  @override
  Future<void> performSave() async {
    // Navigate to preview page instead of saving
    await _navigateToPreview();
  }

  @override
  void navigateAfterSave() {
    // Don't navigate - we handle navigation in _navigateToPreview
  }

  Future<void> _navigateToPreview() async {
    // Get selected contacts
    final selectedContacts =
        _contacts?.where((c) => _selectedContactIds.contains(c.id)).toList() ??
            [];

    final result = await Navigator.push<Stage?>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => MatchReachOutPreviewView(
          match: widget.match,
          message: widget.message,
          selectedContacts: selectedContacts,
        ),
      ),
    );

    // If message was sent successfully, pop back through the chain with the new stage
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  bool get useScrollView => true;

  @override
  Widget buildSaveButton({String? label, VoidCallback? onPressed}) {
    final l10n = AppLocalizations.of(context)!;
    return super.buildSaveButton(label: l10n.actionNext);
  }

  void _toggleContactSelection(String contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
      } else {
        _selectedContactIds.add(contactId);
      }
    });
  }

  Future<void> _navigateToEditContact(Contact contact) async {
    final result = await Navigator.push<bool>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditContactSettingView(contact: contact),
      ),
    );

    // Reload contacts if edit was successful
    if (result == true) {
      await _loadContacts();
    }
  }

  @override
  Widget buildFormContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_contactsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: LoadingStateWidget(),
      );
    }

    if (_contacts == null || _contacts!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        SubTitle(
          iconName: 'link',
          title: l10n.matchReachOutContactsSubtitle,
        ),

        const SizedBox(height: 16),

        // Contact options
        ..._contacts!.map((contact) => _buildContactOption(contact)),
      ],
    );
  }

  Widget _buildContactOption(Contact contact) {
    final hasValue = contact.hasValue;
    final isSelected = _selectedContactIds.contains(contact.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: OptionButton(
        option: contact,
        isSelected: isSelected,
        isMultiSelect: hasValue,
        isSelectable: hasValue,
        isCheckmarkVisible: hasValue,
        isChevronVisible: !hasValue,
        isButton: true,
        withDescription: true,
        useBorderSelection: true,
        showTagMotivation: true,
        useGradient: !hasValue,
        onSelect: () {
          if (hasValue) {
            _toggleContactSelection(contact.id);
          } else {
            _navigateToEditContact(contact);
          }
        },
      ),
    );
  }
}
