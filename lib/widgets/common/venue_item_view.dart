import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/venyu_theme.dart';
import 'avatar_view.dart';
import 'tag_view.dart';

/// VenueItemView - Component for displaying venues with avatar and information
/// 
/// Based on RoleView but adapted for Venue objects instead of Profile objects.
/// Shows venue avatar, name, and baseline (tagline).
class VenueItemView extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onTap;

  const VenueItemView({
    super.key,
    required this.venue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use AppLayoutStyles.interactiveCard for consistent styling
    return AppLayoutStyles.interactiveCard(
      context: context,
      onTap: onTap,
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container 1: Avatar (top-aligned)
          _buildAvatar(context),
          
          const SizedBox(width: 12),
          
          // Container 2: Name, baseline, and type (top-aligned, expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue name
                Text(
                  venue.name,
                  style: AppTextStyles.headline.copyWith(
                    color: context.venyuTheme.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 2),
                
                // Baseline (tagline)
                Text(
                  venue.baseline,
                  style: AppTextStyles.subheadline.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Venue type tag
                TagView(
                  id: venue.type.id,
                  label: venue.type.displayName,
                  icon: venue.type.icon,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Container 3: Chevron (center-aligned vertically)
          Align(
            alignment: Alignment.center,
            child: _buildChevronIcon(context),
          ),
        ],
      ),
    );
  }

  /// Build the avatar widget
  Widget _buildAvatar(BuildContext context) {
    return AvatarView(
      avatarId: venue.avatarId,
      size: 60,
    );
  }

  /// Build chevron icon with safe fallback
  Widget _buildChevronIcon(BuildContext context) {
    return context.themedIcon(
      'chevron',
      selected: false,
      size: 18,
    );
  }
}