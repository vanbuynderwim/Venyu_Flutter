enum PagesType {
  profileEdit,
  location;

  // Helper methods
  String get title {
    switch (this) {
      case PagesType.profileEdit:
        return 'Profile Edit';
      case PagesType.location:
        return 'Location';
    }
  }

  String get description {
    switch (this) {
      case PagesType.profileEdit:
        return 'Edit profile information';
      case PagesType.location:
        return 'Location settings';
    }
  }
}