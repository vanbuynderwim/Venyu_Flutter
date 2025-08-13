import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/profile.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/avatar_upload_service.dart';
import '../../services/session_manager.dart';
import '../../widgets/common/avatar_view.dart';
import '../../widgets/common/avatar_fullscreen_viewer.dart';
import '../../widgets/common/tag_view.dart';
import '../../widgets/buttons/action_button.dart';
import 'edit_bio_view.dart';

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
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool _isUploading = false;
  bool _isRemoving = false;
  String? _forceNoAvatar; // Force showing no avatar for specific ID

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

                  Text(
                    widget.profile.fullName,
                    style: AppTextStyles.headline.copyWith(
                      color: venyuTheme.primaryText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Role (computed property from profile)
                  Text(
                    widget.profile.role.isNotEmpty 
                        ? widget.profile.role
                        : 'Add company info',
                    style: AppTextStyles.subheadline.copyWith(
                      color: venyuTheme.primaryText,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Sectors/Tags
                  _buildSectorsView(context, venyuTheme),
                  
                  // Distance (only for other profiles)
                  if (!widget.isEditable && widget.profile.formattedDistance != null) ...[
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
                          widget.profile.formattedDistance!,
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
        if (!widget.isEditable && widget.isConnection) ...[
          const SizedBox(height: 16),
          _buildActionButtons(context, venyuTheme),
        ],
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, VenyuTheme venyuTheme) {
    // Always use regular avatar - no local preview
    // Use key to force rebuild when avatar changes
    // During removal or if we've marked this avatar ID as removed, show null
    final shouldShowAvatar = !_isRemoving && 
                            widget.profile.avatarID != null && 
                            widget.profile.avatarID != _forceNoAvatar;
    
    final avatarContent = AvatarView(
      key: ValueKey(shouldShowAvatar ? widget.profile.avatarID : 'no_avatar_${DateTime.now().millisecondsSinceEpoch}'),
      avatarId: shouldShowAvatar ? widget.profile.avatarID : null,
      size: widget.avatarSize,
    );

    final avatarWidget = widget.isEditable
        ? Stack(
            children: [
              avatarContent,
              // Upload or remove spinner overlay
              if (_isUploading || _isRemoving)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              // Edit icon overlay for own profile (hide during upload/remove)
              if (!_isUploading && !_isRemoving)
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
        : avatarContent;

    // Make avatar tappable for editing if editable
    if (widget.isEditable) {
      return _AvatarMenuWrapper(
        avatar: avatarWidget,
        options: _buildAvatarMenuOptions(context),
      );
    }

    // Make avatar tappable if callback provided (for non-editable profiles)
    if (widget.onAvatarTap != null) {
      return GestureDetector(
        onTap: widget.onAvatarTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildSectorsView(BuildContext context, VenyuTheme venyuTheme) {
    // Check if profile has sectors
    if (widget.profile.sectors.isNotEmpty) {
      // Sort sectors by title like in Swift
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
    } else if (widget.isEditable) {
      // No sectors - show placeholder only if editable
      return GestureDetector(
        onTap: widget.onSectorsEditTap ?? () {
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
              type: ActionButtonType.secondary,
              onPressed: widget.onLinkedInTap ?? () {
                debugPrint('LinkedIn tap - ${widget.profile.linkedInURL}');
              },
            ),
          ),
        ),
        
        // Email button (only if contact email is available)
        if (widget.profile.contactEmail != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionButton(
                icon: context.themedIcon('email'),
                isIconOnly: true,
                type: ActionButtonType.secondary,
                onPressed: widget.onEmailTap ?? () {
                  debugPrint('Email tap - ${widget.profile.contactEmail}');
                },
              ),
            ),
          ),
        
        // Website button (only if website URL is available)
        if (widget.profile.websiteURL != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ActionButton(
                icon: context.themedIcon('link'),
                isIconOnly: true,
                type: ActionButtonType.secondary,
                onPressed: widget.onWebsiteTap ?? () {
                  debugPrint('Website tap - ${widget.profile.websiteURL}');
                },
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the avatar menu options for PlatformPopupMenu
  List<PopupMenuOption> _buildAvatarMenuOptions(BuildContext context) {
    final hasAvatar = widget.profile.avatarID != null;
    final venyuTheme = context.venyuTheme;
    
    final options = <PopupMenuOption>[
      // Camera option (always available)
      PopupMenuOption(
        label: 'Camera',
        onTap: (_) => _handleAvatarAction(context, AvatarAction.camera),
        cupertino: (_, __) => CupertinoPopupMenuOptionData(
          child: Row(
            children: [
              context.themedIcon('camera'),
              const SizedBox(width: 12),
              const Text('Camera'),
            ],
          ),
        ),
        material: (_, __) => MaterialPopupMenuOptionData(
          child: Row(
            children: [
              context.themedIcon('camera'),
              const SizedBox(width: 12),
              const Text('Camera'),
            ],
          ),
        ),
      ),
      
      // Gallery option (always available)
      PopupMenuOption(
        label: 'Gallery',
        onTap: (_) => _handleAvatarAction(context, AvatarAction.gallery),
        cupertino: (_, __) => CupertinoPopupMenuOptionData(
          child: Row(
            children: [
              context.themedIcon('image'),
              const SizedBox(width: 12),
              const Text('Gallery'),
            ],
          ),
        ),
        material: (_, __) => MaterialPopupMenuOptionData(
          child: Row(
            children: [
              context.themedIcon('image'),
              const SizedBox(width: 12),
              const Text('Gallery'),
            ],
          ),
        ),
      ),
    ];
    
    // View option (only if avatar exists)
    if (hasAvatar) {
      options.add(
        PopupMenuOption(
          label: 'View',
          onTap: (_) => _handleAvatarAction(context, AvatarAction.view),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
            child: Row(
              children: [
                context.themedIcon('eye'),
                const SizedBox(width: 12),
                const Text('View'),
              ],
            ),
          ),
          material: (_, __) => MaterialPopupMenuOptionData(
            child: Row(
              children: [
                context.themedIcon('eye'),
                const SizedBox(width: 12),
                const Text('View'),
              ],
            ),
          ),
        ),
      );
      
      // Remove option (only if avatar exists)
      options.add(
        PopupMenuOption(
          label: 'Remove',
          onTap: (_) => _handleAvatarAction(context, AvatarAction.remove),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
            isDestructiveAction: true,
            child: Row(
              children: [
                context.themedIcon('delete'),
                const SizedBox(width: 12),
                Text(
                  'Remove',
                  style: TextStyle(color: venyuTheme.error),
                ),
              ],
            ),
          ),
          material: (_, __) => MaterialPopupMenuOptionData(
            child: Row(
              children: [
                context.themedIcon('delete'),
                const SizedBox(width: 12),
                Text(
                  'Remove',
                  style: TextStyle(color: venyuTheme.error),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Cancel option (always available, typically shown last)
    options.add(
      PopupMenuOption(
        label: 'Cancel',
        onTap: (_) => _handleAvatarAction(context, AvatarAction.cancel),
        cupertino: (_, __) => CupertinoPopupMenuOptionData(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        material: (_, __) => MaterialPopupMenuOptionData(
          child: Row(
            children: [
              const Icon(Icons.close, size: 24),
              const SizedBox(width: 12),
              Text(
                'Cancel',
                style: TextStyle(color: venyuTheme.secondaryText),
              ),
            ],
          ),
        ),
      ),
    );
    
    return options;
  }

  /// Handles avatar menu actions
  Future<void> _handleAvatarAction(BuildContext context, AvatarAction action) async {
    try {
      switch (action) {
        case AvatarAction.camera:
          await AvatarUploadService.pickFromCameraAndUpload(
            context: context,
            onUploadStart: () {
              setState(() {
                _isUploading = true;
              });
            },
            onUploadComplete: () {
              if (mounted) {
                setState(() {
                  _isUploading = false;
                });
              }
            },
          );
          break;
        case AvatarAction.gallery:
          await AvatarUploadService.pickFromGalleryAndUpload(
            context: context,
            onUploadStart: () {
              setState(() {
                _isUploading = true;
              });
            },
            onUploadComplete: () {
              if (mounted) {
                setState(() {
                  _isUploading = false;
                });
              }
            },
          );
          break;
        case AvatarAction.view:
          await _viewAvatar(context);
          break;
        case AvatarAction.remove:
          await _removeAvatar(context);
          break;
        case AvatarAction.cancel:
          // Do nothing - just close the menu
          break;
      }
    } catch (error) {
      if (context.mounted) {
        _showErrorDialog(context, 'Avatar action failed: $error');
      }
    }
  }

  /// Shows the current avatar in full screen
  Future<void> _viewAvatar(BuildContext context) async {
    await AvatarFullscreenViewer.show(
      context: context,
      avatarId: widget.profile.avatarID,
      showBorder: false,
      preserveAspectRatio: true,
    );
  }

  /// Removes the current avatar after confirmation
  Future<void> _removeAvatar(BuildContext context) async {
    // Remember the current avatar ID before deletion
    final currentAvatarID = widget.profile.avatarID;
    
    final success = await AvatarUploadService.removeAvatar(
      context: context,
      onRemoveStart: () {
        setState(() {
          _isRemoving = true;
          _forceNoAvatar = currentAvatarID; // Never show this avatar ID again
        });
      },
      onRemoveComplete: () {
        if (mounted) {
          setState(() {
            _isRemoving = false;
          });
          debugPrint('🗑️ Avatar removed, new avatarID: ${widget.profile.avatarID}');
        }
      },
    );
    
    // If removal failed, reset the force no avatar state
    if (!success && mounted) {
      setState(() {
        _forceNoAvatar = null; // Reset on failure so avatar can show again
      });
    }
  }

  /// Shows an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

enum AvatarAction {
  camera,
  gallery,
  view,
  remove,
  cancel,
}

/// Custom wrapper widget to use avatar as the icon for PlatformPopupMenu
class _AvatarMenuWrapper extends StatelessWidget {
  final Widget avatar;
  final List<PopupMenuOption> options;

  const _AvatarMenuWrapper({
    required this.avatar,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenu(
      icon: avatar,
      options: options,
    );
  }
}