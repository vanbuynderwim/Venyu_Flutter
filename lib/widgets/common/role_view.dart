import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../models/match.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import 'avatar_view.dart';

/// RoleView - Component voor het weergeven van profielen met avatar en bedrijfsinformatie
class RoleView extends StatelessWidget {
  final Profile profile;
  final double avatarSize;
  final bool showChevron;
  final bool buttonDisabled;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool shouldBlur;
  final bool showNotificationDot;
  final Match? match;

  const RoleView({
    super.key,
    required this.profile,
    this.avatarSize = 40,
    this.showChevron = false,
    this.buttonDisabled = false,
    this.onTap,
    this.padding,
    this.shouldBlur = false,
    this.showNotificationDot = false,
    this.match,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          // Avatar
          _buildAvatar(context),
          const SizedBox(width: 12),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  profile.fullName,
                  style: AppTextStyles.headline.copyWith(
                    color: context.venyuTheme.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Role (company name)
                if (profile.role.isNotEmpty)
                  Text(
                    profile.role,
                    style: AppTextStyles.subheadline.copyWith(
                      color: context.venyuTheme.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                // Distance if available
                if (profile.formattedDistance != null)
                  Row(
                    children: [
                      context.themedIcon(
                        'location',
                        size: 14,
                        overrideColor: context.venyuTheme.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.formattedDistance!,
                        style: AppTextStyles.footnote.copyWith(
                          color: context.venyuTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                
                // Bio if available
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  Text(
                    profile.bio!,
                    style: AppTextStyles.footnote.copyWith(
                      color: context.venyuTheme.disabledText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // Notification dot and chevron
          if (showNotificationDot && !buttonDisabled) ...[
            _buildNotificationDot(context),
            const SizedBox(width: 6),
          ],
          if (showChevron && !buttonDisabled)
            _buildChevronIcon(context),
        ],
      ),
    );

    // If disabled or no onTap, return plain container
    if (buttonDisabled || onTap == null) {
      return content;
    }

    // Otherwise, make it tappable
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: context.venyuTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
        child: content,
      ),
    );
  }

  /// Bouw de avatar widget met optionele preview indicator
  Widget _buildAvatar(BuildContext context) {
    final avatar = AvatarView(
      avatarId: profile.avatarID,
      size: avatarSize,
      shouldBlur: shouldBlur,
    );

    // If no match provided or preview is false, just return avatar
    if (match == null || match!.isPreview != true) {
      return avatar;
    }

    // Add preview indicator overlay when isPreview is true
    return Stack(
      children: [
        avatar,
        // Small indicator in bottom right
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: context.venyuTheme.cardBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.venyuTheme.borderColor,
                width: AppModifiers.extraThinBorder,
              ),
            ),
            child: Center(
              child: context.themedIcon(
                'eye',
                size: 20,
                selected: false,
                overrideColor: context.venyuTheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build notification dot for unread/unconnected items
  Widget _buildNotificationDot(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: context.venyuTheme.primary,
        shape: BoxShape.circle,
      ),
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