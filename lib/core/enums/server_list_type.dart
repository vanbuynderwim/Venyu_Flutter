enum ServerListType {
  matches('matches'),
  notifications('notifications'),
  userReviews('user_reviews'),
  systemReviews('system_reviews');

  const ServerListType(this.value);
  final String value;

  static ServerListType fromString(String value) {
    return ServerListType.values.firstWhere((e) => e.value == value);
  }
}