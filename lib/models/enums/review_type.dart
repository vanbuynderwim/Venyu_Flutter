enum ReviewType {
  user('user'),
  system('system');

  const ReviewType(this.value);
  
  final String value;

  static ReviewType fromJson(String value) {
    return ReviewType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReviewType.user,
    );
  }

  String toJson() => value;

  // Helper methods
  String get title {
    switch (this) {
      case ReviewType.user:
        return 'User Review';
      case ReviewType.system:
        return 'System Review';
    }
  }

  String get description {
    switch (this) {
      case ReviewType.user:
        return 'Review by community member';
      case ReviewType.system:
        return 'Automated system review';
    }
  }
}