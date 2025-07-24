import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final Color color;
  final String placeholder;
  final double opacity;

  const RemoteIconImage({
    super.key,
    required this.iconName,
    required this.size,
    required this.color,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
  });

  @override
  State<RemoteIconImage> createState() => _RemoteIconImageState();
}

class _RemoteIconImageState extends State<RemoteIconImage> {
  final SupabaseManager _supabaseManager = SupabaseManager.shared;
  String? _iconUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIconUrl();
  }

  void _loadIconUrl() {
    // Use Supabase storage to get icon URL
    final url = _supabaseManager.getIcon(widget.iconName);
    setState(() {
      _iconUrl = url;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildPlaceholder();
    }

    // Probeer eerst lokale asset
    return _buildLocalIcon();
  }

  Widget _buildLocalIcon() {
    final localIconPath = 'assets/images/icons/${widget.iconName}_outlined.png';
    
    return Opacity(
      opacity: widget.opacity,
      child: Image.asset(
        localIconPath,
        width: widget.size,
        height: widget.size,
        color: widget.color,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stackTrace) {
          // Fallback naar remote image
          return _buildRemoteIcon();
        },
      ),
    );
  }

  Widget _buildRemoteIcon() {
    if (_iconUrl != null) {
      return Opacity(
        opacity: widget.opacity,
        child: CachedNetworkImage(
          imageUrl: _iconUrl!,
          width: widget.size,
          height: widget.size,
          color: widget.color,
          colorBlendMode: BlendMode.srcIn,
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
    return Opacity(
      opacity: widget.opacity,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.2),
        ),
        child: Icon(
          Icons.tag,
          size: widget.size * 0.6,
          color: widget.color.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}