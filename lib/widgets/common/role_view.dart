import 'package:flutter/material.dart';
import '../../models/profile.dart';
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

  const RoleView({
    super.key,
    required this.profile,
    this.avatarSize = 40,
    this.showChevron = false,
    this.buttonDisabled = false,
    this.onTap,
    this.padding,
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
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Role (company name)
                if (profile.role.isNotEmpty)
                  Text(
                    profile.role,
                    style: AppTextStyles.subheadline.copyWith(
                      color: context.venyuTheme.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                // Distance if available
                if (profile.formattedDistance != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: context.venyuTheme.secondaryText,
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
          
          // Chevron
          if (showChevron && !buttonDisabled)
            Icon(
              Icons.chevron_right,
              color: context.venyuTheme.disabledText,
              size: 20,
            ),
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

  /// Bouw de avatar widget
  Widget _buildAvatar(BuildContext context) {
    return AvatarView(
      avatarId: profile.avatarID,
      size: avatarSize,
    );
  }

}