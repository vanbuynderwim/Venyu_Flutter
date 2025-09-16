import '../enums/match_status.dart';

/// Server list types for paginated requests
enum ServerListType {
  notifications('get_notifications'),
  pendingUserReviews('get_pending_user_reviews'),
  pendingSystemReviews('get_pending_system_reviews'),
  matches('get_matches'),
  profilePrompts('get_profile_prompts');

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
        return 'Waiting for your first match!';
      case ServerListType.profilePrompts:
        return 'Ready to get matched?';
    }
  }

  String get emptyStateDescription {
    switch (this) {
      case ServerListType.notifications:
        return 'When something happens that you should know about, we\'ll update you here';
      case ServerListType.pendingUserReviews:
      case ServerListType.pendingSystemReviews:
        return 'When cards are submitted for review, they will appear here';
      case ServerListType.matches:
        return 'Venyu is already on the lookout for great matches. As soon as we find the right fit, it will show up here and may lead to an introduction.';
      case ServerListType.profilePrompts:
        return 'Cards open the door to meaningful introductions. Add yours and match with the right people.';
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
        return 'match_regular';
      case ServerListType.profilePrompts:
        return 'nocards';
    }
  }
}

/// Paginated request model equivalent to Swift PaginatedRequest
class PaginatedRequest {
  static const int numberOfNotifications = 20;
  static const int numberOfPrompts = 20;
  static const int numberOfMatches = 20;

  final int limit;
  final String? cursorId;
  final DateTime? cursorTime;
  final MatchStatus? cursorStatus;
  final bool? cursorExpired;
  final ServerListType list;

  const PaginatedRequest({
    this.limit = numberOfMatches,
    this.cursorId,
    this.cursorTime,
    this.cursorStatus,
    this.cursorExpired,
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

    if (cursorExpired != null) {
      json['cursor_expired'] = cursorExpired;
    }

    return json;
  }

  @override
  String toString() {
    return 'PaginatedRequest(limit: $limit, cursorId: $cursorId, cursorTime: $cursorTime, cursorStatus: $cursorStatus, cursorExpired: $cursorExpired, list: $list)';
  }
}