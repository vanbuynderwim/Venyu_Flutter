import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/venyu_theme.dart';
import '../../services/supabase_manager.dart';

/// RemoteIconImage - Laadt remote icons met fallback naar lokale assets
/// 
/// Loading strategy:
/// 1. First tries to load local asset at 'assets/images/icons/{iconName}_outlined.png'
/// 2. Falls back to remote icon from Supabase storage
/// 3. Shows placeholder if both fail
class RemoteIconImage extends StatefulWidget {
  final String iconName;
  final double size;
  final String placeholder;
  final double opacity;

  const RemoteIconImage({
    super.key,
    required this.iconName,
    required this.size,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
  });

  @override
  State<RemoteIconImage> createState() => _RemoteIconImageState();
}

class _RemoteIconImageState extends State<RemoteIconImage> {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;

  String _getIconUrl(BuildContext context) {
    // Use Supabase storage to get icon URL
    return _supabaseManager.getIcon(widget.iconName) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Probeer eerst lokale asset
    return _buildLocalIcon();
  }

  Widget _buildLocalIcon() {
    // Use VenyuTheme helper for consistent icon theming
    final localIconPath = context.getIconPath(widget.iconName);
    final venyuTheme = context.venyuTheme;
    
    return Opacity(
      opacity: widget.opacity,
      child: Image.asset(
        localIconPath,
        width: widget.size,
        height: widget.size,
        color: venyuTheme.primary,
        errorBuilder: (context, error, stackTrace) {
          // Fallback naar remote image
          return _buildRemoteIcon();
        },
      ),
    );
  }

  Widget _buildRemoteIcon() {
    final iconUrl = _getIconUrl(context);
    final venyuTheme = context.venyuTheme;
    
    if (iconUrl.isNotEmpty) {
      return Opacity(
        opacity: widget.opacity,
        child: CachedNetworkImage(
          imageUrl: iconUrl,
          width: widget.size,
          height: widget.size,
          color: venyuTheme.primary,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
          fadeInDuration: const Duration(milliseconds: 250),
          memCacheWidth: (widget.size * 2).toInt(),
          memCacheHeight: (widget.size * 2).toInt(),
        ),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    final venyuTheme = context.venyuTheme;
    
    return Opacity(
      opacity: widget.opacity,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.tag,
          size: widget.size * 0.6,
          color: venyuTheme.primary,
        ),
      ),
    );
  }
}