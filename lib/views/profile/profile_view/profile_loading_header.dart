import 'package:flutter/material.dart';

import '../../../core/theme/app_modifiers.dart';
import '../../../core/theme/venyu_theme.dart';

/// ProfileLoadingHeader - Loading placeholder for profile header
/// 
/// This widget displays a loading placeholder while the profile data
/// is being fetched, showing skeleton UI elements that match the 
/// actual profile header layout.
/// 
/// Features:
/// - Circular avatar placeholder
/// - Name and role text placeholders
/// - Card-style container with theme-aware colors
/// - Proper spacing and alignment matching real header
class ProfileLoadingHeader extends StatelessWidget {
  const ProfileLoadingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: AppModifiers.cardContentPadding,
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: venyuTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name placeholder
                Container(
                  height: 20,
                  width: 150,
                  color: venyuTheme.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 8),
                // Role placeholder
                Container(
                  height: 16,
                  width: 100,
                  color: venyuTheme.primary.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}