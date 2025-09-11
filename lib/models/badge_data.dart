/// Badge data model for tab bar notification counts
class BadgeData {
  final int unreadNotifications;
  final int userReviewsCount;
  final int systemReviewsCount;
  final int matchesCount;

  const BadgeData({
    required this.unreadNotifications,
    required this.userReviewsCount,
    required this.systemReviewsCount,
    required this.matchesCount,
  });

  /// Create BadgeData from JSON response
  factory BadgeData.fromJson(Map<String, dynamic> json) {
    return BadgeData(
      unreadNotifications: json['unread_notifications'] as int? ?? 0,
      userReviewsCount: json['user_reviews_count'] as int? ?? 0,
      systemReviewsCount: json['system_reviews_count'] as int? ?? 0,
      matchesCount: json['matches_count'] as int? ?? 0,
    );
  }

  /// Get total reviews count for profile badge
  int get totalReviews => userReviewsCount + systemReviewsCount;

  /// Check if any badges should be shown
  bool get hasAnyBadges => 
      unreadNotifications > 0 || 
      matchesCount > 0 || 
      totalReviews > 0;
}