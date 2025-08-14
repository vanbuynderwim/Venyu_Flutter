import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// A reusable character counter overlay that can be positioned over text fields.
///
/// This widget provides a semi-transparent badge showing current character count
/// vs the maximum limit, typically positioned in the bottom-right corner of a text field.
///
/// Example usage:
/// ```dart
/// Stack(
///   children: [
///     TextField(controller: _controller),
///     CharacterCounterOverlay(
///       currentLength: _controller.text.length,
///       maxLength: 200,
///     ),
///   ],
/// )
/// ```
class CharacterCounterOverlay extends StatelessWidget {
  /// Current length of the text
  final int currentLength;
  
  /// Maximum allowed length
  final int maxLength;
  
  /// Position from the bottom (default: 8px)
  final double bottom;
  
  /// Position from the right (default: 12px)  
  final double right;
  
  /// Position from the left (optional, overrides right if provided)
  final double? left;
  
  /// Position from the top (optional, overrides bottom if provided)
  final double? top;
  
  /// Horizontal padding inside the counter badge (default: 8px)
  final double horizontalPadding;
  
  /// Vertical padding inside the counter badge (default: 4px)
  final double verticalPadding;
  
  /// Border radius of the counter badge (default: 12px)
  final double borderRadius;
  
  /// Background opacity (default: 0.9)
  final double backgroundOpacity;
  
  /// Custom text style (optional, uses AppTextStyles.caption1 by default)
  final TextStyle? textStyle;

  const CharacterCounterOverlay({
    super.key,
    required this.currentLength,
    required this.maxLength,
    this.bottom = 0,
    this.right = 0,
    this.left,
    this.top,
    this.horizontalPadding = 8,
    this.verticalPadding = 4,
    this.borderRadius = 12,
    this.backgroundOpacity = 0.9,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    // Determine if we're near or over the limit for color coding
    final isNearLimit = currentLength > (maxLength * 0.9);
    final isOverLimit = currentLength > maxLength;
    
    Color textColor = venyuTheme.secondaryText;
    if (isOverLimit) {
      textColor = venyuTheme.error;
    } else if (isNearLimit) {
      textColor = venyuTheme.warning;
    }
    
    return Positioned(
      bottom: top != null ? null : bottom,
      top: top,
      right: left != null ? null : right,
      left: left,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: venyuTheme.cardBackground.withValues(alpha: backgroundOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          '$currentLength/$maxLength',
          style: textStyle?.copyWith(color: textColor) ?? 
                 AppTextStyles.caption1.copyWith(color: textColor),
        ),
      ),
    );
  }
}