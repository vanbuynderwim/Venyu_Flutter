import 'package:flutter/material.dart';

import '../../../models/enums/profile_sections.dart';
import '../../../models/profile.dart';
import '../../../models/badge_data.dart';
import '../../../widgets/buttons/section_button.dart';

/// ProfileSectionButtonBar - Section toggle buttons for profile view
/// 
/// This widget displays the section toggle buttons that allow switching
/// between Personal, Company, and Reviews (admin only) sections.
/// 
/// Features:
/// - Dynamic section availability based on user permissions
/// - Section selection state management
/// - Callback handling for section changes
/// - Admin-only reviews section
class ProfileSectionButtonBar extends StatelessWidget {
  final Profile? profile;
  final ProfileSections selectedSection;
  final Function(ProfileSections) onSectionSelected;
  final BadgeData? badgeData;

  const ProfileSectionButtonBar({
    super.key,
    required this.profile,
    required this.selectedSection,
    required this.onSectionSelected,
    this.badgeData,
  });

  @override
  Widget build(BuildContext context) {
    final availableSections = <ProfileSections>[
      ProfileSections.personal,
      ProfileSections.company,
      ProfileSections.venues,
      ProfileSections.invites,
      // Only show reviews for super admins
      if (profile?.isSuperAdmin == true) ProfileSections.reviews,
    ];

    // Create badge counts map
    final badgeCounts = <String, int>{};
    if (badgeData != null) {
      if (badgeData!.invitesCount > 0) {
        badgeCounts[ProfileSections.invites.id] = badgeData!.invitesCount;
      }
      if (badgeData!.totalReviews > 0) {
        badgeCounts[ProfileSections.reviews.id] = badgeData!.totalReviews;
      }
    }

    return SectionButtonBar<ProfileSections>(
      sections: availableSections,
      selectedSection: selectedSection,
      onSectionSelected: onSectionSelected,
      badgeCounts: badgeCounts.isNotEmpty ? badgeCounts : null,
    );
  }
}