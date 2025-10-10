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

  const InteractionTag({
    super.key,
    required this.interactionType,
    this.width,
    this.height,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: width,
      height: height ?? (compact ? 32 : 40),
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: compact ? 4.0 : 6.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Image.asset(
              interactionType.assetPath,
              width: compact ? 16 : 20,
              height: compact ? 16 : 20,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  interactionType.fallbackIcon,
                  size: compact ? 16 : 20,
                  color: Colors.white,
                );
              },
            ),

            const SizedBox(width: 6),

            // Label
            Flexible(
              child: Text(
                interactionType.buttonTitle(context),
                style: (compact ? AppTextStyles.caption1 : AppTextStyles.callout).copyWith(
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