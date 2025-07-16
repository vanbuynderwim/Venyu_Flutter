enum NotificationType {
  cardSubmitted('card_submitted'),
  cardApproved('card_approved'),
  cardRejected('card_rejected'),
  matched('matched'),
  connected('connected');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere((e) => e.value == value);
  }
}