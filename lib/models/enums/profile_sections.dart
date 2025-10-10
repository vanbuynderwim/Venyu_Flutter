import 'package:flutter/material.dart';
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
/// Text(ProfileSections.personal.title); // "Personal"
/// 
/// // Access section description
/// final description = ProfileSections.reviews.description;
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
  venues,

  /// User's invites and invitations.
  invites,

  /// User's reviews and feedback from others (admin only).
  reviews;

  @override
  String get id => name;

  /// Returns the display title for this profile section.
  @override
  String title(BuildContext context) {
    switch (this) {
      case ProfileSections.personal:
        return 'Personal';
      case ProfileSections.company:
        return 'Company';
      case ProfileSections.venues:
        return 'Venues';
      case ProfileSections.invites:
        return 'Invites';
      case ProfileSections.reviews:
        return 'Reviews';
    }
  }

  /// Returns a brief description of this profile section's content.
  @override
  String description(BuildContext context) {
    switch (this) {
      case ProfileSections.personal:
        return 'Personal information';
      case ProfileSections.company:
        return 'Company information';
      case ProfileSections.venues:
        return 'Events and organizations';
      case ProfileSections.invites:
        return 'Invites and invitations';
      case ProfileSections.reviews:
        return 'User reviews and feedback';
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
      case ProfileSections.invites:
        return 'ticket';
      case ProfileSections.reviews:
        return 'verified';
    }
  }
}