import 'package:flutter/material.dart';

import '../../../core/theme/venyu_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/profile.dart';
import '../../../models/enums/action_button_type.dart';
import '../../../widgets/buttons/action_button.dart';

/// ProfileActionsSection - Displays connection action buttons
/// 
/// This widget shows action buttons for connected profiles:
/// - LinkedIn button (always shown for connections)
/// - Email button (only if contact email is available)
/// - Website button (only if website URL is available)
/// 
/// Features:
/// - Responsive button layout with proper spacing
/// - Conditional display based on available profile data
/// - Icon-only action buttons with secondary styling
/// - Tap callbacks for external integrations
class ProfileActionsSection extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onLinkedInTap;
  final VoidCallback? onEmailTap;
  final VoidCallback? onWebsiteTap;

  const ProfileActionsSection({
    super.key,
    required this.profile,
    this.onLinkedInTap,
    this.onEmailTap,
    this.onWebsiteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LinkedIn button (always shown for connections)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ActionButton(
              icon: context.themedIcon('linkedin'),
              isIconOnly: true,
              type: ActionButtonType.secondary,
              onPressed: onLinkedInTap ?? () {
                AppLogger.debug('LinkedIn button tapped', context: 'ProfileActionsSection');
              },
            ),
          ),
        ),
        
        // Email button (only if contact email is available)
        if (profile.contactEmail != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionButton(
                icon: context.themedIcon('email'),
                isIconOnly: true,
                type: ActionButtonType.secondary,
                onPressed: onEmailTap ?? () {
                  AppLogger.debug('Email button tapped', context: 'ProfileActionsSection');
                },
              ),
            ),
          ),
        
        // Website button (only if website URL is available)
        if (profile.websiteURL != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ActionButton(
                icon: context.themedIcon('link'),
                isIconOnly: true,
                type: ActionButtonType.secondary,
                onPressed: onWebsiteTap ?? () {
                  AppLogger.debug('Website button tapped', context: 'ProfileActionsSection');
                },
              ),
            ),
          ),
      ],
    );
  }
}