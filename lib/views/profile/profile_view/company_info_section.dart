import 'package:flutter/material.dart';

import '../../../core/utils/app_logger.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/tag_group.dart';
import '../../../widgets/buttons/option_button.dart';
import '../../../widgets/common/loading_state_widget.dart';

/// CompanyInfoSection - Company tag groups section
///
/// This widget displays the company tag groups section including:
/// - Dynamic company tag groups from Supabase
/// - Loading states and empty states
///
/// Features:
/// - Loading state with custom message
/// - Empty state handling for no tag groups
/// - Tap handling for tag groups
/// - Option button styling with colors and chevrons
class CompanyInfoSection extends StatelessWidget {
  final List<TagGroup>? companyTagGroups;
  final bool companyTagGroupsLoading;
  final Function(TagGroup) onCompanyTagGroupTap;

  const CompanyInfoSection({
    super.key,
    required this.companyTagGroups,
    required this.companyTagGroupsLoading,
    required this.onCompanyTagGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.debug('Building company section. TagGroups: ${companyTagGroups?.length ?? 'null'}, Loading: $companyTagGroupsLoading', context: 'CompanyInfoSection');
    
    if (companyTagGroupsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LoadingStateWidget(),
      );
    }

    final List<Widget> children = [];

    // TagGroup options from Supabase
    if (companyTagGroups != null && companyTagGroups!.isNotEmpty) {
      for (final tagGroup in companyTagGroups!) {
        // Check if tag group has empty or null tag list
        final hasNoTags = tagGroup.list == null || tagGroup.list!.isEmpty;

        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: OptionButton(
              option: tagGroup,
              isSelected: false,
              isMultiSelect: false,
              isSelectable: false,
              isCheckmarkVisible: false,
              isChevronVisible: true,
              isButton: true,
              withDescription: true,
              iconColor: tagGroup.color,
              showTagMotivation: true,
              useGradient: hasNoTags,
              onSelect: () {
                onCompanyTagGroupTap(tagGroup);
              },
            ),
          ),
        );
      }
    } else if (!companyTagGroupsLoading && (companyTagGroups?.isEmpty ?? false)) {
      // Show message if no tag groups are available
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            l10n.companySectionEmptyTagGroups,
            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }
    
    return Column(children: children);
  }
}