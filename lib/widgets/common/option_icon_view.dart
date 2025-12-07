import 'package:flutter/material.dart';
import '../../core/theme/venyu_theme.dart';
import 'remote_icon_image.dart';

/// OptionIconView - Flutter equivalent van Swift OptionIconView
/// 
/// Handles icon loading with the following priority:
/// 1. Emoji (if provided)
/// 2. Local assets (if isLocal = true)
/// 3. Remote icons via RemoteIconImage (if isLocal = false)
class OptionIconView extends StatelessWidget {
  final String? icon;
  final String? emoji;
  final double size;
  final Color color;
  final String placeholder;
  final double opacity;
  final bool isLocal;
  final bool selected;

  const OptionIconView({
    super.key,
    this.icon,
    this.emoji,
    required this.size,
    required this.color,
    this.placeholder = 'hashtag',
    this.opacity = 1.0,
    this.isLocal = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Emoji heeft prioriteit
    if (emoji != null) {
      return SizedBox(
        width: size * 1.2, // Give extra width to prevent right clipping
        height: size * 1.2, // Give extra height to prevent bottom clipping
        child: Center(
          child: Text(
            emoji!,
            style: TextStyle(
              fontSize: size * 0.9, // Slightly smaller font to fit within expanded bounds
              height: 1.0, // Tighter line height to prevent clipping
              leadingDistribution: TextLeadingDistribution.even, // Better emoji vertical centering
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    // Icon fallback
    if (icon != null) {
      if (isLocal) {
        return _buildLocalIcon(context);
      } else {
        // It's a remote icon name - use RemoteIconImage
        return RemoteIconImage(
          iconName: icon!,
          size: size,
          placeholder: placeholder,
          opacity: opacity,
          color: color,
        );
      }
    }
    
    // Geen icon en geen emoji
    return const SizedBox.shrink();
  }

  Widget _buildLocalIcon(BuildContext context) {
    // Use VenyuTheme helper for consistent icon theming
    final iconPath = context.getIconPath(icon!, selected: selected);

    return Opacity(
      opacity: opacity,
      child: Image.asset(
        iconPath,
        color: color,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to remote icon
          return RemoteIconImage(
            iconName: icon!,
            size: size,
            placeholder: placeholder,
            opacity: opacity,
            color: color,
          );
        },
      ),
    );
  }
}