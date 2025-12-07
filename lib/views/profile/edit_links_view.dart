import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/contact.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import 'edit_contact_setting_view.dart';

/// EditLinksView - View for managing contact/social links
///
/// This view displays all available contact settings (links) and allows
/// the user to edit them. It was previously shown as a section in profile_view
/// but is now a separate view accessible from edit_account_view.
class EditLinksView extends StatefulWidget {
  const EditLinksView({super.key});

  @override
  State<EditLinksView> createState() => _EditLinksViewState();
}

class _EditLinksViewState extends State<EditLinksView> with ErrorHandlingMixin {
  late final ProfileManager _profileManager;

  List<Contact>? _contacts;
  bool _contactsLoading = true;

  @override
  void initState() {
    super.initState();
    _profileManager = ProfileManager.shared;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.accountSettingsLinksTitle),
      ),
      useSafeArea: true,
      body: RefreshIndicator(
        onRefresh: () => _loadContacts(forceRefresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // Privacy info message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: WarningBoxWidget(text: l10n.profileContactPrivacyMessage),
            ),

            // Contact options
            _buildContactsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    final l10n = AppLocalizations.of(context)!;

    if (_contactsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: LoadingStateWidget(),
      );
    }

    final List<Widget> children = [];

    // Contact options from Supabase
    if (_contacts != null && _contacts!.isNotEmpty) {
      for (final contact in _contacts!) {
        // Check if contact has no value set
        final hasNoValue = !contact.hasValue;

        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: OptionButton(
              option: contact,
              isSelected: false,
              isMultiSelect: false,
              isSelectable: false,
              isCheckmarkVisible: false,
              isChevronVisible: true,
              isButton: true,
              withDescription: true,
              showTagMotivation: true,
              useGradient: hasNoValue,
              onSelect: () => _handleContactTap(contact),
            ),
          ),
        );
      }
    } else if (!_contactsLoading && (_contacts?.isEmpty ?? false)) {
      // Show message if no contacts are available
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            l10n.contactSectionEmptyContacts,
            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(children: children);
  }

  /// Loads contact settings
  Future<void> _loadContacts({bool forceRefresh = false}) async {
    // Always reload if forceRefresh is true, or if we don't have data yet
    if (!forceRefresh && _contacts != null) return;

    if (!mounted) return;
    setState(() => _contactsLoading = true);

    await executeSilently(
      operation: () async {
        final contacts = await _profileManager.getProfileContactSettings();
        AppLogger.success('Loaded ${contacts.length} contact settings', context: 'EditLinksView');
        safeSetState(() {
          _contacts = contacts;
          _contactsLoading = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading contact settings', error: error, context: 'EditLinksView');
        safeSetState(() {
          _contacts = [];
          _contactsLoading = false;
        });
      },
    );
  }

  /// Handles contact setting tap
  void _handleContactTap(Contact contact) async {
    AppLogger.ui('Tapped on contact: ${contact.label}', context: 'EditLinksView');

    final result = await Navigator.push<bool>(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => EditContactSettingView(contact: contact),
      ),
    );

    if (result == true) {
      _loadContacts(forceRefresh: true);
    }
  }
}
