import 'profile.dart';
import 'prompt.dart';
import 'tag_group.dart';
import 'enums/match_status.dart';
import 'enums/match_response.dart';

class Match {
  final String id;
  final Profile profile;
  final MatchStatus status;
  final double? score;
  final String? reason;
  final MatchResponse? response;
  final DateTime? updatedAt;
  final List<Prompt>? prompts;
  final List<Match>? connections;
  final List<TagGroup>? tagGroups;
  final int? unreadCount;

  const Match({
    required this.id,
    required this.profile,
    required this.status,
    this.score,
    this.reason,
    this.response,
    this.updatedAt,
    this.prompts,
    this.connections,
    this.tagGroups,
    this.unreadCount,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      profile: Profile.fromJson(json['profile']),
      status: MatchStatus.fromJson(json['status']),
      score: json['score']?.toDouble(),
      reason: json['reason'] as String?,
      response: json['response'] != null ? MatchResponse.fromJson(json['response']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      prompts: json['prompts'] != null
          ? (json['prompts'] as List).map((prompt) => Prompt.fromJson(prompt)).toList()
          : null,
      connections: json['connections'] != null
          ? (json['connections'] as List).map((conn) => Match.fromJson(conn)).toList()
          : null,
      tagGroups: json['taggroups'] != null
          ? (json['taggroups'] as List).map((group) => TagGroup.fromJson(group)).toList()
          : null,
      unreadCount: json['unread_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile.toJson(),
      'status': status.toJson(),
      'score': score,
      'reason': reason,
      'response': response?.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
      'prompts': prompts?.map((prompt) => prompt.toJson()).toList(),
      'connections': connections?.map((conn) => conn.toJson()).toList(),
      'taggroups': tagGroups?.map((group) => group.toJson()).toList(),
      'unread_count': unreadCount,
    };
  }

  // Helper methods
  bool get isMatched => status == MatchStatus.matched;
  bool get isConnected => status == MatchStatus.connected;
  bool get hasUnreadMessages => unreadCount != null && unreadCount! > 0;
  
  int get sharedTagsCount {
    if (tagGroups == null) return 0;
    return tagGroups!.fold(0, (sum, group) => sum + group.selectedCount);
  }
}