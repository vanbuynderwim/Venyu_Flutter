import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../mixins/error_handling_mixin.dart';
import '../../../models/profile.dart';
import '../../../services/avatar_upload_service.dart';
import '../../../services/profile_service.dart';
import '../../../widgets/common/avatar_view.dart';
import '../../../widgets/common/avatar_fullscreen_viewer.dart';
import '../../../widgets/menus/menu_option_builder.dart';

/// Enum for avatar actions in the menu
enum AvatarAction {
  camera,
  gallery,
  view,
  remove,
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
  final bool? shouldBlur;

  const ProfileAvatarSection({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.avatarSize = 100.0,
    this.onAvatarTap,
    this.onAvatarChanged,
    this.shouldBlur,
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
    
    // If this is an editable profile (own profile), use Consumer for live updates
    // Otherwise, just use the provided profile directly
    if (widget.isEditable) {
      return Consumer<ProfileService>(
        builder: (context, profileService, child) {
          // For editable profiles, use live data from ProfileService
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
            shouldBlur: widget.shouldBlur ?? false,
          );
          
          return _buildAvatarWidget(context, venyuTheme, avatarContent, currentProfile);
        },
      );
    } else {
      // For non-editable profiles (viewing other profiles), use the provided profile directly
      final currentProfile = widget.profile;
      _currentProfile = currentProfile;

      final avatarContent = AvatarView(
        avatarId: currentProfile.avatarID,
        size: widget.avatarSize,
        shouldBlur: widget.shouldBlur ?? false,
      );

      return _buildAvatarWidget(context, venyuTheme, avatarContent, currentProfile);
    }
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
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: venyuTheme.secondaryButtonBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: venyuTheme.borderColor,
                        width: AppModifiers.extraThinBorder,
                      ),
                    ),
                    child: Center(
                      child: context.themedIcon('edit', size: 20),
                    ),
                  ),
                ),
            ],
          )
        : avatarContent;

    // Make avatar tappable for editing if editable
    if (widget.isEditable) {
      return GestureDetector(
        onTap: () => _showAvatarMenu(context, currentProfile),
        child: avatarWidget,
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

  /// Shows the avatar menu using centralized DialogUtils component
  Future<void> _showAvatarMenu(BuildContext context, Profile currentProfile) async {
    final menuOptions = _buildAvatarMenuOptions(context, currentProfile);
    final actions = _buildAvatarActions(currentProfile);

    // Show the menu using centralized DialogUtils
    final selectedAction = await DialogUtils.showMenuModalSheet<AvatarAction>(
      context: context,
      menuOptions: menuOptions,
      actions: actions,
    );

    // Sheet is now closed - perform the action
    if (!context.mounted) return;

    if (selectedAction != null) {
      await _handleAvatarAction(context, selectedAction);
    }
  }

  /// Builds the avatar menu options for DialogUtils
  List<PopupMenuOption> _buildAvatarMenuOptions(BuildContext context, Profile currentProfile) {
    final l10n = AppLocalizations.of(context)!;
    final hasAvatar = currentProfile.avatarID != null && currentProfile.avatarID != _forceNoAvatar;

    final options = <PopupMenuOption>[
      // Camera option (always available)
      MenuOptionBuilder.create(
        context: context,
        label: l10n.profileAvatarMenuCamera,
        iconName: 'camera',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
      ),

      // Gallery option (always available)
      MenuOptionBuilder.create(
        context: context,
        label: l10n.profileAvatarMenuGallery,
        iconName: 'image',
        onTap: (_) {},  // Dummy onTap, handled by DialogUtils
      ),
    ];

    // View option (only if avatar exists)
    if (hasAvatar) {
      options.add(
        MenuOptionBuilder.create(
          context: context,
          label: l10n.profileAvatarMenuView,
          iconName: 'eye',
          onTap: (_) {},  // Dummy onTap, handled by DialogUtils
        ),
      );

      // Remove option (only if avatar exists)
      options.add(
        MenuOptionBuilder.create(
          context: context,
          label: l10n.profileAvatarMenuRemove,
          iconName: 'delete',
          onTap: (_) {},  // Dummy onTap, handled by DialogUtils
          isDestructive: true,
        ),
      );
    }

    return options;
  }

  /// Builds the corresponding actions list for DialogUtils
  List<AvatarAction> _buildAvatarActions(Profile currentProfile) {
    final hasAvatar = currentProfile.avatarID != null && currentProfile.avatarID != _forceNoAvatar;

    final actions = <AvatarAction>[
      AvatarAction.camera,
      AvatarAction.gallery,
    ];

    if (hasAvatar) {
      actions.add(AvatarAction.view);
      actions.add(AvatarAction.remove);
    }

    return actions;
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
      }
    } catch (error) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showErrorDialog(context, l10n.profileAvatarErrorAction(error.toString()));
      }
    }
  }

  /// Select and upload photo from camera
  Future<void> _selectFromCamera(BuildContext context) async {
    await AvatarUploadService.pickFromCameraAndUpload(
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
    // Note: Error handling is done by AvatarUploadService via toast
    // No need to show additional error dialog here
  }

  /// Select and upload photo from gallery
  Future<void> _selectFromGallery(BuildContext context) async {
    await AvatarUploadService.pickFromGalleryAndUpload(
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
    // Note: Error handling is done by AvatarUploadService via toast
    // No need to show additional error dialog here
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
    final l10n = AppLocalizations.of(context)!;

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
        _showErrorDialog(context, l10n.profileAvatarErrorRemove);
      }
    }
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(l10n.profileAvatarErrorTitle),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.profileAvatarErrorButton),
          ),
        ],
      ),
    );
  }
}

