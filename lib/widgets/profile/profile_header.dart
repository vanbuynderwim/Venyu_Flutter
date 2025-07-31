import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/profile.dart';
import '../../models/enums/action_button_type.dart';
import '../common/avatar_view.dart';
import '../common/tag_view.dart';
import '../buttons/action_button.dart';
import '../../views/profile/edit_bio_view.dart';

/// Reusable profile header widget used in both ProfileView and MatchDetailView
/// 
/// Displays avatar, role, sectors, and bio with optional edit functionality.
/// Supports both editable mode (for own profile) and read-only mode (for matches).
class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final bool isEditable;
  final bool isConnection;
  final double avatarSize;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLinkedInTap;
  final VoidCallback? onEmailTap;
  final VoidCallback? onWebsiteTap;
  final VoidCallback? onBioEdited;

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
    this.onBioEdited,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar and Role row
        Row(
          children: [
            // Avatar with optional edit overlay
            _buildAvatar(context, venyuTheme),
            
            const SizedBox(width: 16),
            
            // Role and sectors
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role (computed property from profile)
                  Text(
                    profile.role.isNotEmpty 
                        ? profile.role
                        : 'Add company info',
                    style: AppTextStyles.subheadline.copyWith(
                      color: venyuTheme.primaryText,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Sectors/Tags
                  _buildSectorsView(context, venyuTheme),
                  
                  // Distance (only for other profiles)
                  if (!isEditable && profile.formattedDistance != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        context.themedIcon(
                          'location',
                          selected: false,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.formattedDistance!,
                          style: AppTextStyles.footnote.copyWith(
                            color: venyuTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Bio section
        _buildBioSection(context, venyuTheme),
        
        // Action buttons (LinkedIn, Email, Website) for connections
        if (!isEditable && isConnection) ...[
          const SizedBox(height: 16),
          _buildActionButtons(context, venyuTheme),
        ],
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, VenyuTheme venyuTheme) {
    final avatar = AvatarView(
      avatarId: profile.avatarID,
      size: avatarSize,
    );

    final avatarWidget = isEditable
        ? Stack(
            children: [
              avatar,
              // Edit icon overlay for own profile
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: venyuTheme.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: venyuTheme.borderColor,
                      width: AppModifiers.extraThinBorder,
                    ),
                  ),
                  child: Center(
                    child: context.themedIcon('edit', size: 14),
                  ),
                ),
              ),
            ],
          )
        : avatar;

    // Make avatar tappable if callback provided
    if (onAvatarTap != null) {
      return GestureDetector(
        onTap: onAvatarTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildSectorsView(BuildContext context, VenyuTheme venyuTheme) {
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
        onTap: () {
          // TODO: Navigate to sectors edit
          debugPrint('Navigate to sectors edit');
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

  Widget _buildBioSection(BuildContext context, VenyuTheme venyuTheme) {
    final hasBio = profile.bio?.isNotEmpty == true;

    // For non-editable profiles without bio, show nothing
    if (!isEditable && !hasBio) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            hasBio 
                ? profile.bio! 
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
        if (isEditable) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const EditBioView(),
                ),
              );
              
              // Notify parent if bio was updated
              if (result == true && onBioEdited != null) {
                onBioEdited!();
              }
            },
            child: context.themedIcon('edit'),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, VenyuTheme venyuTheme) {
    return Row(
      children: [
        // LinkedIn button (always shown for connections)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ActionButton(
              icon: context.themedIcon('linkedin'),
              isIconOnly: true,
              style: ActionButtonType.secondary,
              onPressed: onLinkedInTap ?? () {
                debugPrint('LinkedIn tap - ${profile.linkedInURL}');
              },
            ),
          ),
        ),
        
        // Email button (only if contact email is available)
        if (profile.contactEmail != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionButton(
                icon: context.themedIcon('email'),
                isIconOnly: true,
                style: ActionButtonType.secondary,
                onPressed: onEmailTap ?? () {
                  debugPrint('Email tap - ${profile.contactEmail}');
                },
              ),
            ),
          ),
        
        // Website button (only if website URL is available)
        if (profile.websiteURL != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ActionButton(
                icon: context.themedIcon('link'),
                isIconOnly: true,
                style: ActionButtonType.secondary,
                onPressed: onWebsiteTap ?? () {
                  debugPrint('Website tap - ${profile.websiteURL}');
                },
              ),
            ),
          ),
      ],
    );
  }
}