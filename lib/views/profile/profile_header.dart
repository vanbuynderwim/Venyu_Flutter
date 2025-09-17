import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/profile.dart';
import 'edit_bio_view.dart';
import 'profile_header/profile_avatar_section.dart';
import 'profile_header/profile_info_section.dart';
import 'profile_header/profile_tags_section.dart';
import 'profile_header/profile_actions_section.dart';

/// Reusable profile header widget used in both ProfileView and MatchDetailView
/// 
/// Displays avatar, role, sectors, and bio with optional edit functionality.
/// Supports both editable mode (for own profile) and read-only mode (for matches).
class ProfileHeader extends StatefulWidget {
  final Profile profile;
  final bool isEditable;
  final bool isConnection;
  final double avatarSize;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLinkedInTap;
  final VoidCallback? onEmailTap;
  final VoidCallback? onWebsiteTap;
  final VoidCallback? onSectorsEditTap;
  final bool? isPro;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.isConnection = false,
    this.avatarSize = 100.0,
    this.onAvatarTap,
    this.onLinkedInTap,
    this.onEmailTap,
    this.onWebsiteTap,
    this.onSectorsEditTap,
    this.isPro,
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
            // Avatar with optional edit overlay
            ProfileAvatarSection(
              profile: widget.profile,
              isEditable: widget.isEditable,
              avatarSize: widget.avatarSize,
              onAvatarTap: widget.onAvatarTap,
              isPro: widget.isPro,
              onAvatarChanged: () {
                // Refresh parent widget when avatar changes
                setState(() {});
              },
            ),
            
            const SizedBox(width: 16),
            
            // Profile info and tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name, role, and distance
                  ProfileInfoSection(
                    profile: widget.profile,
                    isEditable: widget.isEditable,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Sectors/Tags
                  ProfileTagsSection(
                    profile: widget.profile,
                    isEditable: widget.isEditable,
                    onSectorsEditTap: widget.onSectorsEditTap,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Bio section
        _buildBioSection(context, venyuTheme),
        
        // Action buttons (LinkedIn, Email, Website) for connections
        if (!widget.isEditable && widget.isConnection) ...[
          const SizedBox(height: 16),
          ProfileActionsSection(
            profile: widget.profile,
            onLinkedInTap: widget.onLinkedInTap,
            onEmailTap: widget.onEmailTap,
            onWebsiteTap: widget.onWebsiteTap,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            hasBio 
                ? widget.profile.bio! 
                : 'Write something about yourself...',
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


