import 'package:flutter/material.dart';

import '../../../core/utils/app_logger.dart';
import '../../../models/enums/edit_personal_info_type.dart';
import '../../../models/tag_group.dart';
import '../../../widgets/buttons/option_button.dart';
import '../../../widgets/common/loading_state_widget.dart';

/// PersonalInfoSection - Personal information and tag groups section
/// 
/// This widget displays the personal information section including:
/// - Fixed personal info options (name, bio, email)
/// - Dynamic personal tag groups from Supabase
/// - Loading states and empty states
/// 
/// Features:
/// - Loading state with custom message
/// - Empty state handling for no tag groups
/// - Tap handling for both fixed and dynamic options
/// - Option button styling with colors and chevrons
class PersonalInfoSection extends StatelessWidget {
  final List<TagGroup>? personalTagGroups;
  final bool personalTagGroupsLoading;
  final Function(EditPersonalInfoType) onPersonalInfoTap;
  final Function(TagGroup) onTagGroupTap;

  const PersonalInfoSection({
    super.key,
    required this.personalTagGroups,
    required this.personalTagGroupsLoading,
    required this.onPersonalInfoTap,
    required this.onTagGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('Building personal section. TagGroups: ${personalTagGroups?.length ?? 'null'}, Loading: $personalTagGroupsLoading', context: 'PersonalInfoSection');
    
    if (personalTagGroupsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: LoadingStateWidget(),
      );
    }

    final List<Widget> children = [];
    
    // Fixed section - EditPersonalInfoType options
    for (final editPersonalInfoType in EditPersonalInfoType.values) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: OptionButton(
            option: editPersonalInfoType,
            isSelected: false,
            isMultiSelect: false,
            isSelectable: false,
            isCheckmarkVisible: false,
            isChevronVisible: true,
            isButton: true,
            withDescription: true,
            onSelect: () {
              onPersonalInfoTap(editPersonalInfoType);
            },
          ),
        ),
      );
    }
    
    // Dynamic section - TagGroup options from Supabase
    if (personalTagGroups != null && personalTagGroups!.isNotEmpty) {
      for (final tagGroup in personalTagGroups!) {
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
                onTagGroupTap(tagGroup);
              },
            ),
          ),
        );
      }
    } else if (!personalTagGroupsLoading && (personalTagGroups?.isEmpty ?? false)) {
      // Show message if no tag groups are available
      children.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'No personal tag groups available',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }
    
    return Column(children: children);
  }
}