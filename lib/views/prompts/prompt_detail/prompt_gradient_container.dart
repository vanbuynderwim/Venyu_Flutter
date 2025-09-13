import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/enums/interaction_type.dart';

/// PromptGradientContainer - Gradient background container for prompt detail view
///
/// This widget provides the gradient background that changes based on the
/// selected interaction type, creating a dynamic visual experience.
///
/// Features:
/// - Dynamic gradient colors based on interaction type
/// - Theme-aware dark/light mode support
/// - Consistent gradient positioning from top to bottom
/// - Transparent scaffold background support
class PromptGradientContainer extends StatelessWidget {
  final InteractionType interactionType;
  final Widget child;

  const PromptGradientContainer({
    super.key,
    required this.interactionType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            interactionType.color,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
          ],
        ),
      ),
      child: child,
    );
  }
}