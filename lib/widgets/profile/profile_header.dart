import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/profile.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/session_manager.dart';
import '../common/avatar_view.dart';
import '../common/tag_view.dart';
import '../buttons/action_button.dart';
import '../../views/profile/edit_bio_view.dart';

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
              style: ActionButtonType.secondary,
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
                style: ActionButtonType.secondary,
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
                style: ActionButtonType.secondary,
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
              context.themedIcon('close'),
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
          await _pickImage(context, ImageSource.camera);
          break;
        case AvatarAction.gallery:
          await _pickImage(context, ImageSource.gallery);
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

  /// Picks an image from camera or gallery and uploads it
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 100,
    );
    
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      
      // Show upload state immediately after photo selection
      setState(() {
        _isUploading = true;
      });
      
      try {
        await SessionManager.shared.uploadUserProfileAvatar(imageBytes);
        
        // Upload successful - clear upload state
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      } catch (error) {
        // Upload failed - clear upload state
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
        rethrow; // Let error handling in _handleAvatarAction catch this
      }
    }
  }

  /// Shows the current avatar in full screen
  Future<void> _viewAvatar(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allow transparent background
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black, // Fully black background
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Avatar size = screen width minus 16pt on each side (32pt total)
                  final availableWidth = constraints.maxWidth - 32.0;
                  final availableHeight = constraints.maxHeight - 80.0; // Space for close button
                  
                  // Use the smaller dimension to ensure perfect circle
                  final avatarSize = availableWidth < availableHeight ? availableWidth : availableHeight;
                  
                  return Stack(
                    children: [
                      // Tap to dismiss
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      // Centered avatar
                      Center(
                        child: AvatarView(
                          avatarId: widget.profile.avatarID,
                          size: avatarSize,
                          showBorder: false, // No border for full-screen view
                          preserveAspectRatio: true, // Preserve original image quality and ratio
                        ),
                      ),
                      // Close button
                      Positioned(
                        top: 20,
                        right: 20,
                        child: PlatformIconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 30),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Removes the current avatar after confirmation
  Future<void> _removeAvatar(BuildContext context) async {
    final confirmed = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Remove Avatar'),
        content: const Text('Are you sure you want to remove your avatar?'),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: true,
            ),
            material: (_, __) => MaterialDialogActionData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          PlatformDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // Remember the current avatar ID before deletion
      final currentAvatarID = widget.profile.avatarID;
      
      // Show removing state and mark this avatar as removed
      setState(() {
        _isRemoving = true;
        _forceNoAvatar = currentAvatarID; // Never show this avatar ID again
      });
      
      try {
        await SessionManager.shared.deleteProfileAvatar();
        
        // Clear removing state - keep _forceNoAvatar to prevent showing cached image
        if (mounted) {
          setState(() {
            _isRemoving = false;
          });
          debugPrint('🗑️ Avatar removed, new avatarID: ${widget.profile.avatarID}');
        }
      } catch (error) {
        // Clear removing state on error and reset force no avatar
        if (mounted) {
          setState(() {
            _isRemoving = false;
            _forceNoAvatar = null; // Reset on error so avatar can show again
          });
        }
        rethrow;
      }
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