import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../mixins/error_handling_mixin.dart';
import '../../../models/profile.dart';
import '../../../services/avatar_upload_service.dart';
import '../../../services/profile_service.dart';
import '../../../widgets/common/avatar_view.dart';
import '../../../widgets/common/avatar_fullscreen_viewer.dart';

/// Enum for avatar actions in the menu
enum AvatarAction {
  camera,
  gallery,
  view,
  remove,
  cancel,
}

/// ProfileAvatarSection - Handles avatar display, upload, and removal
/// 
/// This widget manages the avatar display for profiles with support for:
/// - Avatar viewing in fullscreen
/// - Photo selection and upload (for editable profiles)
/// - Avatar removal with confirmation
/// - Loading states during upload/removal
/// - Edit overlay for owned profiles
/// 
/// Features:
/// - ErrorHandlingMixin for consistent error handling
/// - Platform-aware popup menu for avatar actions
/// - Loading overlays during operations
/// - Proper state management for upload/removal
class ProfileAvatarSection extends StatefulWidget {
  final Profile profile;
  final bool isEditable;
  final double avatarSize;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onAvatarChanged; // Callback when avatar changes

  const ProfileAvatarSection({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.avatarSize = 100.0,
    this.onAvatarTap,
    this.onAvatarChanged,
  });

  @override
  State<ProfileAvatarSection> createState() => _ProfileAvatarSectionState();
}

class _ProfileAvatarSectionState extends State<ProfileAvatarSection> 
    with ErrorHandlingMixin {
  
  bool _isUploading = false;
  bool _isRemoving = false;
  String? _forceNoAvatar; // Force showing no avatar for specific ID
  Profile? _currentProfile; // Cache current profile for event handlers

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        // Use live profile data from ProfileService instead of widget parameter
        final currentProfile = profileService.currentProfile ?? widget.profile;
        _currentProfile = currentProfile; // Cache for event handlers
        
        // Always use regular avatar - no local preview
        // Use key to force rebuild when avatar changes
        // During removal or if we've marked this avatar ID as removed, show null
        final shouldShowAvatar = !_isRemoving && 
                                currentProfile.avatarID != null && 
                                currentProfile.avatarID != _forceNoAvatar;
        
        final avatarContent = AvatarView(
          key: ValueKey(shouldShowAvatar ? currentProfile.avatarID : 'no_avatar_${DateTime.now().millisecondsSinceEpoch}'),
          avatarId: shouldShowAvatar ? currentProfile.avatarID : null,
          size: widget.avatarSize,
        );
        
        return _buildAvatarWidget(context, venyuTheme, avatarContent, currentProfile);
      },
    );
  }
  
  Widget _buildAvatarWidget(BuildContext context, VenyuTheme venyuTheme, Widget avatarContent, Profile currentProfile) {

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
        options: _buildAvatarMenuOptions(context, currentProfile),
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

  /// Builds the avatar menu options for PlatformPopupMenu
  List<PopupMenuOption> _buildAvatarMenuOptions(BuildContext context, Profile currentProfile) {
    final hasAvatar = currentProfile.avatarID != null && currentProfile.avatarID != _forceNoAvatar;
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
          await _selectFromCamera(context);
          break;
        case AvatarAction.gallery:
          await _selectFromGallery(context);
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

  /// Select and upload photo from camera
  Future<void> _selectFromCamera(BuildContext context) async {
    final success = await AvatarUploadService.pickFromCameraAndUpload(
      context: context,
      onUploadStart: () {
        if (mounted) setState(() => _isUploading = true);
      },
      onUploadComplete: () {
        if (mounted) {
          // Clear any forced no avatar state
          _forceNoAvatar = null;
          // Notify parent of avatar change
          widget.onAvatarChanged?.call();
          setState(() => _isUploading = false);
        }
      },
    );

    // Show error if upload failed (but not if cancelled)
    if (!success && mounted && context.mounted) {
      _showErrorDialog(context, 'Failed to upload photo. Please try again.');
    }
  }

  /// Select and upload photo from gallery
  Future<void> _selectFromGallery(BuildContext context) async {
    final success = await AvatarUploadService.pickFromGalleryAndUpload(
      context: context,
      onUploadStart: () {
        if (mounted) setState(() => _isUploading = true);
      },
      onUploadComplete: () {
        if (mounted) {
          // Clear any forced no avatar state
          _forceNoAvatar = null;
          // Notify parent of avatar change
          widget.onAvatarChanged?.call();
          setState(() => _isUploading = false);
        }
      },
    );

    // Show error if upload failed (but not if cancelled)
    if (!success && mounted && context.mounted) {
      _showErrorDialog(context, 'Failed to upload photo. Please try again.');
    }
  }

  /// View avatar in fullscreen
  Future<void> _viewAvatar(BuildContext context) async {
    await AvatarFullscreenViewer.show(
      context: context,
      avatarId: _currentProfile?.avatarID ?? widget.profile.avatarID,
      showBorder: false,
      preserveAspectRatio: true,
    );
  }

  /// Remove avatar with confirmation
  Future<void> _removeAvatar(BuildContext context) async {
    // Remember the current avatar ID before deletion
    final currentAvatarID = _currentProfile?.avatarID ?? widget.profile.avatarID;
    
    final success = await AvatarUploadService.removeAvatar(
      context: context,
      onRemoveStart: () {
        if (mounted) {
          setState(() {
            _isRemoving = true;
            _forceNoAvatar = currentAvatarID; // Never show this avatar ID again
          });
        }
      },
      onRemoveComplete: () {
        if (mounted) {
          // Notify parent of avatar change
          widget.onAvatarChanged?.call();
          setState(() => _isRemoving = false);
        }
      },
    );
    
    // If removal failed, reset the force no avatar state
    if (!success && mounted) {
      setState(() {
        _forceNoAvatar = null; // Reset on failure so avatar can show again
      });
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to remove photo. Please try again.');
      }
    }
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
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