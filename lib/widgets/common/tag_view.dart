import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import 'option_icon_view.dart';

/// A compact visual representation of a tag with optional icon or emoji.
/// 
/// This widget displays tags in a pill-shaped container with consistent styling
/// throughout the app. Tags can include icons, emojis, and custom colors for
/// visual categorization and improved user experience.
/// 
/// The widget automatically handles:
/// - Theme-aware styling and colors
/// - Icon and emoji rendering via [OptionIconView]
/// - Responsive sizing and layout
/// - Accessibility considerations
/// 
/// Example usage:
/// ```dart
/// // Basic text tag
/// TagView(
///   id: 'tag_1',
///   label: 'Flutter Developer',
/// )
/// 
/// // Tag with icon
/// TagView(
///   id: 'tag_2', 
///   label: 'Design',
///   icon: 'palette',
///   color: Colors.blue,
/// )
/// 
/// // Tag with emoji
/// TagView(
///   id: 'tag_3',
///   label: 'Coffee Lover',
///   emoji: '☕',
/// )
/// ```
class TagView extends StatelessWidget {
  /// Unique identifier for this tag.
  final String id;
  
  /// The text label displayed in the tag.
  final String label;
  
  /// Optional icon name to display alongside the label.
  final String? icon;
  
  /// Optional emoji to display alongside the label.
  final String? emoji;
  
  /// Optional custom color for the icon/emoji. Uses theme color if not specified.
  final Color? color;
  
  /// Optional custom text style for the label. Uses theme default if not specified.
  final TextStyle? fontSize;
  
  /// Size of the icon or emoji. Defaults to 16.
  final double iconSize;
  
  /// Optional custom background color. Uses theme default if not specified.
  final Color? backgroundColor;

  /// Creates a [TagView] widget.
  /// 
  /// [id] and [label] are required. Provide either [icon] or [emoji] for visual enhancement.
  const TagView({
    super.key,
    required this.id,
    required this.label,
    this.icon,
    this.emoji,
    this.color,
    this.fontSize,
    this.iconSize = 16,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: AppLayoutStyles.tagDecoration(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon/Emoji
          if (icon != null || emoji != null) ...[
            OptionIconView(
              icon: icon,
              emoji: emoji,
              size: iconSize,
              color: color ?? context.venyuTheme.primary,
              isLocal: false, // TagView meestal gebruikt voor remote icons van tags
            ),
            const SizedBox(width: 4),
          ],
          
          // Label
          Text(
            label,
            style: (fontSize ?? AppTextStyles.footnote).copyWith(
              color: venyuTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}