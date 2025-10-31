import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/profile.dart';

/// ProfileInfoSection - Displays profile name, role, distance, and city
///
/// This widget shows the core profile information:
/// - Full name (first + last name)
/// - Role/company information (computed from profile)
/// - Distance (for non-editable profiles)
/// - City (for connections or own profile)
///
/// Features:
/// - Responsive text styling based on theme
/// - Conditional distance display for other profiles
/// - Conditional city display based on showCity flag
/// - Support for placeholder text when no company info
class ProfileInfoSection extends StatelessWidget {
  final Profile profile;
  final bool isEditable;
  final bool showCity;

  const ProfileInfoSection({
    super.key,
    required this.profile,
    this.isEditable = false,
    this.showCity = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        Text(
          profile.fullName,
          style: AppTextStyles.headline.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),

        const SizedBox(height: 6),

        // Role (computed property from profile)
        Text(
          profile.role.isNotEmpty
              ? profile.role
              : l10n.profileInfoAddCompanyInfo,
          style: AppTextStyles.subheadline.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),

        // Distance and City
        if (!isEditable && profile.formattedDistance != null || showCity && profile.city != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              // Distance
              if (!isEditable && profile.formattedDistance != null) ...[
                context.themedIcon('location', size: 14, overrideColor: context.venyuTheme.secondaryText),
                const SizedBox(width: 4),
                Text(
                  profile.formattedDistance!,
                  style: AppTextStyles.caption1.copyWith(
                    color: venyuTheme.secondaryText,
                  ),
                ),
              ],

              // Spacing between distance and city
              if (!isEditable && profile.formattedDistance != null && showCity && profile.city != null)
                const SizedBox(width: 12),

              // City
              if (showCity && profile.city != null) ...[
                context.themedIcon('map', size: 14),
                const SizedBox(width: 4),
                Text(
                  profile.city!,
                  style: AppTextStyles.caption1.copyWith(
                    color: venyuTheme.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}