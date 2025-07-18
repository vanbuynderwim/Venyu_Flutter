import '../../widgets/common/section_type.dart';

enum ProfileSections implements SectionType {
  cards,
  reviews,
  venues;

  @override
  String get id => name;

  // Helper methods
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