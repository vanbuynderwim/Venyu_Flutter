import 'package:flutter/material.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';

/// InteractionTag - Static tag that looks like InteractionButton but without button functionality
///
/// This component displays an interaction type as a visual tag with:
/// - Background color of the interaction type
/// - Icon and label
/// - Same styling as InteractionButton but no tap functionality
class InteractionTag extends StatelessWidget {
  final InteractionType interactionType;
  final double? width;
  final double? height;
  final bool compact;

  /// Optional custom label to override the default buttonTitle.
  /// Used for match-specific labels like "<firstName> is this".
  final String? customLabel;

  const InteractionTag({
    super.key,
    required this.interactionType,
    this.width,
    this.height,
    this.compact = false,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: width,
      height: height ?? (compact ? 32 : 40),
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Label
            Flexible(
              child: Text(
                customLabel ?? interactionType.buttonTitle(context),
                style: (compact ? AppTextStyles.footnote : AppTextStyles.callout).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}