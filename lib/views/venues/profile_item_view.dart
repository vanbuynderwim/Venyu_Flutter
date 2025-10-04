import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/common/avatar_view.dart';

/// ProfileItemView - Flutter equivalent of Swift ProfileItemView
/// 
/// Displays a profile item with profile information in a card layout.
/// Similar to MatchItemView but designed for venue member listings.
/// Uses RoleView with avatar, name, and company information in a tappable card format.
/// 
/// Features:
/// - Tactile feedback with pressed state highlighting
/// - Same interaction feel as MatchItemView and other interactive cards
/// - Visual opacity changes during press
/// - Optimized for venue member display
/// 
/// Example usage:
/// ```dart
/// ProfileItemView(
///   profile: myProfile,
///   onProfileSelected: (profile) => handleProfileSelection(profile),
/// )
/// ```
class ProfileItemView extends StatefulWidget {
  /// The profile data to display
  final Profile profile;
  
  /// Callback when the profile is selected/tapped
  final Function(Profile)? onProfileSelected;

  const ProfileItemView({
    super.key,
    required this.profile,
    this.onProfileSelected,
  });

  @override
  State<ProfileItemView> createState() => _ProfileItemViewState();
}

class _ProfileItemViewState extends State<ProfileItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppLayoutStyles.cardDecoration(context),
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom profile layout with sectors between company and other info
            _buildProfileLayout(),
          ],
        ),
      ),
    );
  }

  /// Builds custom profile layout with sectors positioned under company
  Widget _buildProfileLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        AvatarView(
          avatarId: widget.profile.avatarID,
          size: 60,
          shouldBlur: false,
        ),
        const SizedBox(width: 12),
        
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                widget.profile.fullName,
                style: AppTextStyles.headline.copyWith(
                  color: context.venyuTheme.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Role (company name)
              if (widget.profile.role.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  widget.profile.role,
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Sectors section right after company
                if (widget.profile.sectors.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildSectorsSection(),
                ],
              ],
              
              // Distance if available
              if (widget.profile.formattedDistance != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.venyuTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.profile.formattedDistance!,
                      style: AppTextStyles.footnote.copyWith(
                        color: context.venyuTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Bio if available
              if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  widget.profile.bio!,
                  style: AppTextStyles.footnote.copyWith(
                    color: context.venyuTheme.disabledText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the sectors section with read-only tags
  Widget _buildSectorsSection() {
    // Sort sectors by title like in ProfileTagsSection
    final sortedSectors = List.from(widget.profile.sectors);
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
  }
}