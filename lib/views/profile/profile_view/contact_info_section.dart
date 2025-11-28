import 'package:flutter/material.dart';

import '../../../core/utils/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/contact.dart';
import '../../../widgets/buttons/option_button.dart';
import '../../../widgets/common/loading_state_widget.dart';

/// ContactInfoSection - Contact settings section
///
/// This widget displays the contact settings section including:
/// - Dynamic contact settings from Supabase
/// - Loading states and empty states
///
/// Features:
/// - Loading state with custom message
/// - Empty state handling for no contacts
/// - Tap handling for contacts
/// - Option button styling with icons and chevrons
/// - Shows "Complete profile" motivation tag when value is not set
/// - Shows value as tag when value is set
class ContactInfoSection extends StatelessWidget {
  final List<Contact>? contacts;
  final bool contactsLoading;
  final Function(Contact) onContactTap;

  const ContactInfoSection({
    super.key,
    required this.contacts,
    required this.contactsLoading,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Building contact section. Contacts: ${contacts?.length ?? 'null'}, Loading: $contactsLoading', context: 'ContactInfoSection');

    if (contactsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: LoadingStateWidget(),
      );
    }

    final List<Widget> children = [];

    // Contact options from Supabase
    if (contacts != null && contacts!.isNotEmpty) {
      for (final contact in contacts!) {
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
              onSelect: () {
                onContactTap(contact);
              },
            ),
          ),
        );
      }
    } else if (!contactsLoading && (contacts?.isEmpty ?? false)) {
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
}
