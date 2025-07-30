import '../enums/match_status.dart';

/// Server list types for paginated requests
enum ServerListType {
  notifications('get_notifications'),
  pendingUserReviews('get_pending_user_reviews'), 
  pendingSystemReviews('get_pending_system_reviews'),
  matches('get_matches');

  const ServerListType(this.value);
  final String value;

  String get emptyStateTitle {
    switch (this) {
      case ServerListType.notifications:
        return 'All caught up!';
      case ServerListType.pendingUserReviews:
      case ServerListType.pendingSystemReviews:
        return 'All caught up!';
      case ServerListType.matches:
        return 'All caught up!';
    }
  }

  String get emptyStateDescription {
    switch (this) {
      case ServerListType.notifications:
        return 'When something happens that you should know about, we\'ll brief you here';
      case ServerListType.pendingUserReviews:
      case ServerListType.pendingSystemReviews:
        return 'When cards are submitted for review, they will appear here';
      case ServerListType.matches:
        return 'All your matches will appear here';
    }
  }

  String get emptyStateIcon {
    switch (this) {
      case ServerListType.notifications:
        return 'notification_regular';
      case ServerListType.pendingUserReviews:
      case ServerListType.pendingSystemReviews:
        return 'home_regular';
      case ServerListType.matches:
        return 'couple_regular';
    }
  }
}

/// Paginated request model equivalent to Swift PaginatedRequest
class PaginatedRequest {
  static const int numberOfNotifications = 20;
  static const int numberOfCards = 20;
  static const int numberOfMatches = 20;

  final int limit;
  final String? cursorId;
  final DateTime? cursorTime;
  final MatchStatus? cursorStatus;
  final ServerListType list;

  const PaginatedRequest({
    this.limit = numberOfMatches,
    this.cursorId,
    this.cursorTime,
    this.cursorStatus,
    required this.list,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'limit': limit,
    };

    if (cursorId != null) {
      json['cursor_id'] = cursorId;
    }

    if (cursorTime != null) {
      // Format cursorTime using ISO8601 with fractional seconds
      json['cursor_time'] = cursorTime!.toUtc().toIso8601String();
    }

    if (cursorStatus != null) {
      json['cursor_status'] = cursorStatus!.value;
    }

    return json;
  }

  @override
  String toString() {
    return 'PaginatedRequest(limit: $limit, cursorId: $cursorId, cursorTime: $cursorTime, cursorStatus: $cursorStatus, list: $list)';
  }
}