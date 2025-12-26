import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/section_type.dart';

/// Defines the different sections available in user profile views.
///
/// Each section represents a distinct area of user-generated content
/// that can be displayed in profile interfaces. Implements [SectionType]
/// to provide consistent section behavior across the app.
///
/// Example usage:
/// ```dart
/// // Display section title
/// Text(ProfileSections.personal.title(context)); // "Personal" (localized)
///
/// // Access section description
/// final description = ProfileSections.reviews.description(context);
///
/// // Get section icon
/// Icon(ProfileSections.company.icon);
/// ```
enum ProfileSections implements SectionType {
  /// User's personal information.
  personal,

  /// User's company information.
  company,

  /// User's venues and organizations.
  venues;

  @override
  String get id => name;

  /// Returns the display title for this profile section.
  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ProfileSections.personal:
        return l10n.profileSectionPersonalTitle;
      case ProfileSections.company:
        return l10n.profileSectionCompanyTitle;
      case ProfileSections.venues:
        return l10n.profileSectionVenuesTitle;
    }
  }

  /// Returns a brief description of this profile section's content.
  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ProfileSections.personal:
        return l10n.profileSectionPersonalDescription;
      case ProfileSections.company:
        return l10n.profileSectionCompanyDescription;
      case ProfileSections.venues:
        return l10n.profileSectionVenuesDescription;
    }
  }

  /// Returns the icon identifier for this profile section.
  @override
  String get icon {
    switch (this) {
      case ProfileSections.personal:
        return 'profile';
      case ProfileSections.company:
        return 'company';
      case ProfileSections.venues:
        return 'venue';
    }
  }
}