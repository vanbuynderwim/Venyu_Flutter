import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/profile.dart';
import '../../../widgets/common/tag_view.dart';

/// ProfileTagsSection - Displays profile sectors/tags
/// 
/// This widget shows the sectors associated with a profile:
/// - Sorted sectors display for existing sectors
/// - Add sectors placeholder for editable profiles without sectors
/// - Empty state for non-editable profiles without sectors
/// 
/// Features:
/// - Alphabetical sorting of sectors like iOS implementation
/// - Wrap layout for responsive tag display
/// - Conditional display based on editability
/// - Tap handling for sector editing
class ProfileTagsSection extends StatelessWidget {
  final Profile profile;
  final bool isEditable;
  final VoidCallback? onSectorsEditTap;

  const ProfileTagsSection({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.onSectorsEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    // Check if profile has sectors
    if (profile.sectors.isNotEmpty) {
      // Sort sectors by title like in Swift
      final sortedSectors = List.from(profile.sectors);
      sortedSectors.sort((a, b) => a.title.compareTo(b.title));
      
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: sortedSectors.map<Widget>((sector) {
          return TagView(
            id: sector.id,
            label: sector.title,
            icon: sector.icon,
          );
        }).toList(),
      );
    } else if (isEditable) {
      // No sectors - show placeholder only if editable
      return GestureDetector(
        onTap: onSectorsEditTap ?? () {
          AppLogger.debug('Navigate to sectors edit requested', context: 'ProfileTagsSection');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: venyuTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Add sectors',
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.primary,
            ),
          ),
        ),
      );
    } else {
      // For non-editable profiles without sectors, show nothing
      return const SizedBox.shrink();
    }
  }
}