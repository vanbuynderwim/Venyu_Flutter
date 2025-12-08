import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/profile.dart';
import '../../models/stage.dart';
import '../../models/enums/action_button_type.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/buttons/option_button.dart';
import 'edit_bio_view.dart';
import 'profile_header/profile_avatar_section.dart';
import 'profile_header/profile_info_section.dart';
import 'profile_header/profile_tags_section.dart';

/// Reusable profile header widget used in both ProfileView and MatchDetailView
///
/// Displays avatar, role, sectors, and bio with optional edit functionality.
/// Supports both editable mode (for own profile) and read-only mode (for matches).
class ProfileHeader extends StatefulWidget {
  final Profile profile;
  final bool isEditable;
  final double avatarSize;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onSectorsEditTap;
  final VoidCallback? onReachOutTap;
  final VoidCallback? onStageTap;
  final double? matchingScore;
  final Stage? stage;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.avatarSize = 105.0,
    this.onAvatarTap,
    this.onSectorsEditTap,
    this.onReachOutTap,
    this.onStageTap,

    this.matchingScore,
    this.stage,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar and Info row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with optional matching score below it
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar with optional edit overlay
                ProfileAvatarSection(
                  profile: widget.profile,
                  isEditable: widget.isEditable,
                  avatarSize: widget.avatarSize,
                  onAvatarTap: widget.onAvatarTap,
                  onAvatarChanged: () {
                    // Refresh parent widget when avatar changes
                    setState(() {});
                  },
                ),

                // Matching score if available
                
              ],
            ),

            const SizedBox(width: 16),
            
            // Profile info and tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name, role, distance, and city
                  ProfileInfoSection(
                    profile: widget.profile,
                    isEditable: widget.isEditable,
                    showCity: true,
                    matchingScore: widget.matchingScore,
                  ),
                  
                  // Sectors/Tags
                  
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),

        ProfileTagsSection(
                    profile: widget.profile,
                    isEditable: widget.isEditable,
                    onSectorsEditTap: widget.onSectorsEditTap,
                  ),

        const SizedBox(height: 16),
        // Bio section
        _buildBioSection(context, venyuTheme),
        
        // Reach out button or stage button for connections
        if (!widget.isEditable) ...[
          // Only add spacing if there's a bio
          if (widget.profile.bio?.isNotEmpty == true)
            const SizedBox(height: 16),
          if (widget.stage == null) ...[
            ActionButton(
              label: AppLocalizations.of(context)!.profileHeaderReachOutButton,
              icon: context.themedIcon('edit'),
              type: ActionButtonType.primary,
              onPressed: widget.onReachOutTap,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: widget.onStageTap,
              child: Text(
                AppLocalizations.of(context)!.profileHeaderAlreadyConnectedButton,
                style: AppTextStyles.subheadline.copyWith(
                  color: venyuTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ] else
            OptionButton(
              option: widget.stage!,
              isSelected: false,
              isSelectable: false,
              isCheckmarkVisible: false,
              isChevronVisible: true,
              isButton: true,
              withDescription: true,
              onSelect: widget.onStageTap,
            ),
        ],
      ],
    );
  }



  Widget _buildBioSection(BuildContext context, VenyuTheme venyuTheme) {
    final hasBio = widget.profile.bio?.isNotEmpty == true;

    // For non-editable profiles without bio, show nothing
    if (!widget.isEditable && !hasBio) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            hasBio
                ? widget.profile.bio!
                : AppLocalizations.of(context)!.profileHeaderBioPlaceholder,
            style: AppTextStyles.subheadline.copyWith(
              color: hasBio
                  ? venyuTheme.primaryText
                  : venyuTheme.secondaryText,
              fontStyle: hasBio
                  ? FontStyle.normal
                  : FontStyle.italic,
            ),
          ),
        ),
        if (widget.isEditable) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await Navigator.push<bool>(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const EditBioView(),
                ),
              );

              // No need to manually notify parent - ProfileView automatically updates
              // when SessionManager.currentProfile changes via listener
            },
            child: context.themedIcon('edit'),
          ),
        ],
      ],
    );
  }






}


