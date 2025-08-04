import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../services/supabase_manager.dart';

/// A reusable avatar widget that displays user profile images.
/// 
/// This widget handles:
/// - Loading avatar images from remote storage using avatar ID
/// - Displaying a placeholder when no avatar is available
/// - Theme-aware coloring for the placeholder
/// - Configurable sizing with default 80x80
/// - Automatic image caching and error handling
/// 
/// Example usage:
/// ```dart
/// // With avatar ID
/// AvatarView(
///   avatarId: profile.avatar,
///   size: 100,
/// )
/// 
/// // Without avatar ID (shows placeholder)
/// AvatarView(
///   avatarId: null,
/// )
/// ```
class AvatarView extends StatefulWidget {
  /// The UUID of the avatar image in Supabase storage.
  /// If null, displays the placeholder image.
  final String? avatarId;
  
  /// The size of the avatar (width and height).
  /// Defaults to 80.
  final double size;
  
  /// Whether to show a border around the avatar.
  /// Defaults to true.
  final bool showBorder;
  
  /// Whether to preserve the original aspect ratio of the image.
  /// When true, doesn't resize the cached image, preserving quality and ratio.
  /// Defaults to false for backward compatibility.
  final bool preserveAspectRatio;
  
  const AvatarView({
    super.key,
    this.avatarId,
    this.size = 80,
    this.showBorder = true,
    this.preserveAspectRatio = false,
  });

  @override
  State<AvatarView> createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  Future<String?>? _imageFuture;
  String? _currentAvatarId;

  @override
  void initState() {
    super.initState();
    _initializeImageFuture();
  }

  @override
  void didUpdateWidget(AvatarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reinitialize if the avatarId actually changed
    if (oldWidget.avatarId != widget.avatarId) {
      _initializeImageFuture();
    }
  }

  void _initializeImageFuture() {
    _currentAvatarId = widget.avatarId;
    // Cache the future to prevent rebuilds from triggering new network calls
    if (widget.avatarId != null && widget.avatarId!.isNotEmpty) {
      _imageFuture = SupabaseManager.shared.getRemoteImage(
        id: widget.avatarId!,
        height: widget.size.toInt(),
      );
    } else {
      // Initialize with a completed future when no avatar ID
      _imageFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    // Always use consistent sizing with internal border
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Main content (slightly smaller to account for border)
          Positioned.fill(
            child: widget.avatarId == null || widget.avatarId!.isEmpty
                ? _buildPlaceholder(context, venyuTheme)
                : _buildRemoteAvatar(context),
          ),
          // Border overlay (only if showBorder is true)
          if (widget.showBorder)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: venyuTheme.secondaryText.withValues(alpha: 0.2),
                    width: AppModifiers.thinBorder,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildPlaceholder(BuildContext context, VenyuTheme venyuTheme) {
    // Use secondary color in light mode, primary text color (white) in dark mode
    final placeholderColor = Theme.of(context).brightness == Brightness.light
        ? venyuTheme.secondaryText
        : venyuTheme.primaryText;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: venyuTheme.secondaryButtonBackground,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/visuals/noavatar.png',
          width: widget.size,
          height: widget.size,
          color: placeholderColor,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  
  Widget _buildRemoteAvatar(BuildContext context) {
    return FutureBuilder<String?>(
      future: _imageFuture!,
    builder: (context, snapshot) {
      final venyuTheme = context.venyuTheme;
      
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(            
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: venyuTheme.secondaryButtonBackground,
          ),
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }
      
      final imageUrl = snapshot.data;
      
      if (imageUrl == null || imageUrl.isEmpty) {
        return _buildPlaceholder(context, venyuTheme);
      }
      
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: venyuTheme.secondaryButtonBackground,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover, // Gebruik BoxFit.cover
            alignment: Alignment.center,
            placeholder: (context, url) => Container(
              color: venyuTheme.secondaryButtonBackground,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            errorWidget: (context, url, error) => _buildPlaceholder(context, venyuTheme),
            fadeInDuration: const Duration(milliseconds: 250),
            // Only set cache dimensions if not preserving aspect ratio
            memCacheWidth: widget.preserveAspectRatio ? null : (widget.size * 2).toInt(),
            memCacheHeight: widget.preserveAspectRatio ? null : (widget.size * 2).toInt(),
          ),
        ),
      );
    },
  );
}
}