enum ProfileSections {
  cards,
  reviews,
  venues;

  // Helper methods
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

  String get icon {
    switch (this) {
      case ProfileSections.cards:
        return 'card';
      case ProfileSections.reviews:
        return 'review';
      case ProfileSections.venues:
        return 'venue';
    }
  }
}