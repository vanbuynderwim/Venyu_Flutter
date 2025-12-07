import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/interaction_type.dart';

/// Reusable widget for displaying an interaction type's icon and selection title
///
/// This widget displays the interaction type icon alongside the selection title text,
/// with configurable sizes and styling for use across different views.
///
/// Example usage:
/// ```dart
/// SelectionTitleWithIcon(
///   interactionType: InteractionType.thisIsMe,
///   size: 18,
/// )
/// ```
class SelectionTitleWithIcon extends StatelessWidget {
  final InteractionType interactionType;
  final double size;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color? color;

  const SelectionTitleWithIcon({
    super.key,
    required this.interactionType,
    this.size = 18,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.start,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? context.venyuTheme.primaryText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        // Selection title
        Flexible(
          child: Text(
            interactionType.selectionTitle(context),
            style: TextStyle(
              color: textColor,
              fontSize: size,
              fontWeight: fontWeight,
              fontFamily: AppFonts.graphie,
            ),
            textAlign: textAlign,
          ),
        ),
      ],
    );
  }
}
