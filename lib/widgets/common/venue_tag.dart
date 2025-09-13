import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import 'avatar_view.dart';

/// VenueTag - Displays venue information as a visual tag
/// 
/// This component displays venue information with:
/// - Venue avatar using AvatarView
/// - Venue name
/// - Same height as InteractionTag for consistent alignment
/// - Theme-aware background styling
/// 
/// Example usage:
/// ```dart
/// VenueTag(
///   venue: myVenue,
///   compact: true,
/// )
/// ```
class VenueTag extends StatelessWidget {
  final Venue venue;
  final double? width;
  final double? height;
  final bool compact;

  const VenueTag({
    super.key,
    required this.venue,
    this.width,
    this.height,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.venyuTheme;
    
    return Container(
      width: width,
      height: height ?? (compact ? 32 : 40),
      decoration: BoxDecoration(
        color: theme.tagBackground,
        borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
        border: Border.all(
          color: theme.tagBackground,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: compact ? 4.0 : 6.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Venue avatar
            AvatarView(
              avatarId: venue.avatarId,
              size: compact ? 16 : 20,
              showBorder: false,
            ),

            const SizedBox(width: 6),

            // Venue name
            Flexible(
              child: Text(
                venue.name,
                style: (compact ? AppTextStyles.caption1 : AppTextStyles.callout).copyWith(
                  color: theme.primaryText,
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