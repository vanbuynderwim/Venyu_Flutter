import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
          _buildAvatar(),
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
                
                // Company name
                if (profile.companyName != null && profile.companyName!.isNotEmpty)
                  Text(
                    profile.companyName!,
                    style: AppTextStyles.subheadline.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                // Bio if available
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  Text(
                    profile.bio!,
                    style: AppTextStyles.footnote.copyWith(
                      color: AppColors.textLight,
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
              color: AppColors.textLight,
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
        highlightColor: AppColors.primair6Periwinkel.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        child: content,
      ),
    );
  }

  /// Bouw de avatar widget
  Widget _buildAvatar() {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primair6Periwinkel,
        border: Border.all(
          color: AppColors.secundair6Rocket,
          width: 1,
        ),
      ),
      child: profile.avatarID != null && profile.avatarID!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                'https://venyu-avatars.s3.amazonaws.com/${profile.avatarID}.jpg',
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildAvatarFallback();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildAvatarFallback();
                },
              ),
            )
          : _buildAvatarFallback(),
    );
  }

  /// Bouw de avatar fallback met initialen
  Widget _buildAvatarFallback() {
    final initials = _getInitials();
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primair4Lilac,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.headline.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: avatarSize * 0.4, // Dynamische font size gebaseerd op avatar size
          ),
        ),
      ),
    );
  }

  /// Krijg de initialen van het profiel
  String _getInitials() {
    final firstName = profile.firstName.isNotEmpty ? profile.firstName[0] : '';
    final lastName = profile.lastName != null && profile.lastName!.isNotEmpty ? profile.lastName![0] : '';
    
    if (firstName.isEmpty && lastName.isEmpty) {
      return '?';
    }
    
    return '$firstName$lastName'.toUpperCase();
  }
}