import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';
import '../../../models/profile.dart';

/// ProfileInfoSection - Displays profile name, role, and distance
/// 
/// This widget shows the core profile information:
/// - Full name (first + last name)
/// - Role/company information (computed from profile)
/// - Distance (for non-editable profiles)
/// 
/// Features:
/// - Responsive text styling based on theme
/// - Conditional distance display for other profiles
/// - Support for placeholder text when no company info
class ProfileInfoSection extends StatelessWidget {
  final Profile profile;
  final bool isEditable;

  const ProfileInfoSection({
    super.key,
    required this.profile,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
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
              : 'Add company info',
          style: AppTextStyles.subheadline.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),
        
        // Distance (only for other profiles)
        if (!isEditable && profile.formattedDistance != null) ...[
          const SizedBox(height: 6),
          Text(
            profile.formattedDistance!,
            style: AppTextStyles.caption1.copyWith(
              color: venyuTheme.secondaryText,
            ),
          ),
        ],
      ],
    );
  }
}