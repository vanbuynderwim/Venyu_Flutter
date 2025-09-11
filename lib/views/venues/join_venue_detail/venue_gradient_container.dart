import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/venyu_theme.dart';

/// VenueGradientContainer - Gradient background container for join venue view
/// 
/// This widget provides a primary color gradient background for the join venue view.
/// 
/// Features:
/// - Primary color gradient from top to bottom
/// - Theme-aware dark/light mode support
/// - Consistent gradient positioning from top to bottom
/// - Transparent scaffold background support
class VenueGradientContainer extends StatelessWidget {
  final Widget child;

  const VenueGradientContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final venyuTheme = context.venyuTheme;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            venyuTheme.primary,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
            isDark ? AppColors.secundair3Slategray : AppColors.primair7Pearl,
          ],
        ),
      ),
      child: child,
    );
  }
}