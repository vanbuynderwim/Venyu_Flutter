enum NotificationType {
  cardSubmitted('card_submitted'),
  cardApproved('card_approved'),
  cardRejected('card_rejected'),
  matched('matched'),
  connected('connected');

  const NotificationType(this.value);
  
  final String value;

  static NotificationType fromJson(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.cardSubmitted,
    );
  }

  String toJson() => value;

  /// Returns the icon name for this notification type
  String get icon {
    switch (this) {
      case NotificationType.cardSubmitted:
        return 'card';
      case NotificationType.cardApproved:
        return 'like'; // Use existing like icon for approved
      case NotificationType.cardRejected:
        return 'dislike'; // Use existing dislike icon for rejected
      case NotificationType.matched:
        return 'match';
      case NotificationType.connected:
        return 'handshake';
    }
  }
}