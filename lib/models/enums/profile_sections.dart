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
/// Text(ProfileSections.cards.title); // "Cards"
/// 
/// // Access section description
/// final description = ProfileSections.reviews.description;
/// 
/// // Get section icon
/// Icon(ProfileSections.venues.icon);
/// ```
enum ProfileSections implements SectionType {
  /// User's cards and prompt responses.
  cards,
  
  /// User's reviews and feedback from others.
  reviews,
  
  /// Venues the user has visited or interacted with.
  venues;

  @override
  String get id => name;

  /// Returns the display title for this profile section.
  @override
  String get title {
    switch (this) {
      case ProfileSections.cards:
        return 'Cards';
      case ProfileSections.reviews:
        return 'Reviews';
      case ProfileSections.venues:
        return 'Venues';
    }
  }

  /// Returns a brief description of this profile section's content.
  @override
  String get description {
    switch (this) {
      case ProfileSections.cards:
        return 'User cards and prompts';
      case ProfileSections.reviews:
        return 'User reviews and feedback';
      case ProfileSections.venues:
        return 'Visited venues';
    }
  }

  /// Returns the icon identifier for this profile section.
  @override
  String get icon {
    switch (this) {
      case ProfileSections.cards:
        return 'card';
      case ProfileSections.reviews:
        return 'verified';
      case ProfileSections.venues:
        return 'venue';
    }
  }
}