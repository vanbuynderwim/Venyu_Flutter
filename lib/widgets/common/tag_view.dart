import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// TagView - Flutter equivalent van Swift TagView
class TagView extends StatelessWidget {
  final String id;
  final String label;
  final String? icon;
  final String? emoji;
  final Color? color;
  final TextStyle? fontSize;
  final double iconSize;
  final Color? backgroundColor;

  const TagView({
    super.key,
    required this.id,
    required this.label,
    this.icon,
    this.emoji,
    this.color,
    this.fontSize,
    this.iconSize = 14,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primair7Pearl,
        borderRadius: BorderRadius.circular(100), // Capsule shape
        border: Border.all(
          color: AppColors.secundair6Rocket,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon/Emoji
          if (icon != null || emoji != null) ...[
            OptionIconView(
              icon: icon,
              emoji: emoji,
              size: iconSize,
              color: color ?? AppColors.primair4Lilac,
            ),
            const SizedBox(width: 4),
          ],
          
          // Label
          Text(
            label,
            style: (fontSize ?? AppTextStyles.footnote).copyWith(
              color: AppColors.secundair2Offblack,
            ),
          ),
        ],
      ),
    );
  }
}

/// OptionIconView - Flutter equivalent van Swift OptionIconView
class OptionIconView extends StatelessWidget {
  final String? icon;
  final String? emoji;
  final double size;
  final Color color;
  final String placeholder;
  final double opacity;
  final bool useTemplateMode;

  const OptionIconView({
    super.key,
    this.icon,
    this.emoji,
    required this.size,
    required this.color,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
    this.useTemplateMode = true,
  });

  @override
  Widget build(BuildContext context) {
    // Emoji heeft prioriteit
    if (emoji != null) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            emoji!,
            style: TextStyle(fontSize: size * 0.7),
          ),
        ),
      );
    }
    
    // Icon fallback
    if (icon != null) {
      return RemoteIconImage(
        iconName: icon!,
        size: size,
        color: color,
        placeholder: placeholder,
        opacity: opacity,
        useTemplateMode: useTemplateMode,
      );
    }
    
    // Geen icon en geen emoji
    return const SizedBox.shrink();
  }
}

/// RemoteIconImage - Laadt remote icons met fallback naar lokale assets
class RemoteIconImage extends StatefulWidget {
  final String iconName;
  final double size;
  final Color color;
  final String placeholder;
  final double opacity;
  final bool useTemplateMode;

  const RemoteIconImage({
    super.key,
    required this.iconName,
    required this.size,
    required this.color,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
    this.useTemplateMode = true,
  });

  @override
  State<RemoteIconImage> createState() => _RemoteIconImageState();
}

class _RemoteIconImageState extends State<RemoteIconImage> {
  String? _iconUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIconUrl();
  }

  void _loadIconUrl() {
    // Simuleer remote icon URL generatie
    // In je echte app zou je hier Supabase gebruiken
    final url = _getRemoteIconUrl(widget.iconName);
    setState(() {
      _iconUrl = url;
      _isLoading = false;
    });
  }

  String? _getRemoteIconUrl(String iconName) {
    // Placeholder voor Supabase storage URL
    // return supabase.storage.from('icons').getPublicUrl('$iconName.png');
    
    // Voor demo: gebruik een placeholder service
    return 'https://via.placeholder.com/64/007AFF/FFFFFF?text=${iconName.substring(0, 1).toUpperCase()}';
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
        color: widget.useTemplateMode ? widget.color : null,
        colorBlendMode: widget.useTemplateMode ? BlendMode.srcIn : null,
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
          color: widget.useTemplateMode ? widget.color : null,
          colorBlendMode: widget.useTemplateMode ? BlendMode.srcIn : null,
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