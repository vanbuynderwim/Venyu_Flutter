class Badge {
  final int unreadNotifications;
  final int? userReviewsCount;
  final int? systemReviewsCount;
  final int? matchesCount;

  const Badge({
    required this.unreadNotifications,
    this.userReviewsCount,
    this.systemReviewsCount,
    this.matchesCount,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      unreadNotifications: json['unread_notifications'] as int,
      userReviewsCount: json['user_reviews_count'] as int?,
      systemReviewsCount: json['system_reviews_count'] as int?,
      matchesCount: json['matches_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unread_notifications': unreadNotifications,
      'user_reviews_count': userReviewsCount,
      'system_reviews_count': systemReviewsCount,
      'matches_count': matchesCount,
    };
  }

  // Helper methods
  bool get hasUnreadNotifications => unreadNotifications > 0;
  bool get hasUserReviews => userReviewsCount != null && userReviewsCount! > 0;
  bool get hasSystemReviews => systemReviewsCount != null && systemReviewsCount! > 0;
  bool get hasMatches => matchesCount != null && matchesCount! > 0;
}