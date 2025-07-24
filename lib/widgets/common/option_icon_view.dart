import 'package:flutter/material.dart';
import 'remote_icon_image.dart';

/// OptionIconView - Flutter equivalent van Swift OptionIconView
/// 
/// Handles icon loading with the following priority:
/// 1. Emoji (if provided)
/// 2. Local assets (if icon path contains 'assets/')
/// 3. Remote icons via RemoteIconImage
class OptionIconView extends StatelessWidget {
  final String? icon;
  final String? emoji;
  final double size;
  final Color color;
  final String placeholder;
  final double opacity;

  const OptionIconView({
    super.key,
    this.icon,
    this.emoji,
    required this.size,
    required this.color,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Emoji heeft prioriteit
    if (emoji != null) {
      return SizedBox(
        width: size,
        height: size,
        child: Text(
          emoji!,
          style: TextStyle(
            fontSize: size * 0.8, // Slightly smaller to match text baseline better
            height: 1.0, // Control line height for better alignment
          ),
        ),
      );
    }
    
    // Icon fallback
    if (icon != null) {
      // Check if it's a local asset path (contains 'assets/')
      if (icon!.contains('assets/')) {
        return _buildLocalIcon();
      } else {
        // It's a remote icon name - use RemoteIconImage
        return RemoteIconImage(
          iconName: icon!,
          size: size,
          color: color,
          placeholder: placeholder,
          opacity: opacity,
        );
      }
    }
    
    // Geen icon en geen emoji
    return const SizedBox.shrink();
  }

  Widget _buildLocalIcon() {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        icon!,
        width: size,
        height: size,
        color: color,
        colorBlendMode: BlendMode.srcIn,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to remote if local fails
          return RemoteIconImage(
            iconName: icon!,
            size: size,
            color: color,
            placeholder: placeholder,
            opacity: opacity,
          );
        },
      ),
    );
  }
}