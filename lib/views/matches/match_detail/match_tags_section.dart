import 'package:flutter/material.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/app_layout_styles.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../widgets/common/tag_view.dart';

/// MatchTagsSection - Displays shared tags section
/// 
/// This widget shows shared tags between the current user and the match,
/// grouped by tag groups (e.g., roles, sectors, meeting preferences).
/// 
/// Features:
/// - Grouped tag display with labels
/// - Wrapped layout for tags
/// - Empty state when no tags are shared
/// - Support for both company and personal tag groups
class MatchTagsSection extends StatelessWidget {
  final List<dynamic> tagGroups;

  const MatchTagsSection({
    super.key,
    required this.tagGroups,
  });

  @override
  Widget build(BuildContext context) {
    if (tagGroups.isEmpty) {
      return Container(
        padding: AppModifiers.cardContentPadding,
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Text(
          'No shared tags',
          style: AppTextStyles.body.copyWith(
            color: context.venyuTheme.secondaryText,
          ),
        ),
      );
    }

    return Container(
      padding: AppModifiers.cardContentPadding,
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tagGroups.asMap().entries.map((entry) {
          final index = entry.key;
          final tagGroup = entry.value;
          final isLast = index == tagGroups.length - 1;
          
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TagGroup label
                Text(
                  tagGroup.label ?? 'Unknown',
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                // Tags
                if (tagGroup.tags != null && tagGroup.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tagGroup.tags!.map<Widget>((tag) {
                      return TagView(
                        id: tag.id,
                        label: tag.title,
                        icon: tag.icon,
                        emoji: tag.emoji,
                        backgroundColor: tagGroup.color,
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}