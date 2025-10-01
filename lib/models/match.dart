import 'profile.dart';
import 'prompt.dart';
import 'tag_group.dart';
import 'venue.dart';
import 'enums/match_status.dart';
import 'enums/match_response.dart';

class Match {
  final String id;
  final Profile profile;
  final MatchStatus status;
  final double? score;
  final String? motivation;
  final MatchResponse? response;
  final DateTime? updatedAt;
  final List<Prompt>? prompts;
  final List<Match>? connections;
  final List<TagGroup>? tagGroups;
  final List<Venue>? venues;
  final int? unreadCount;
  final bool? isPreview;
  final bool? isViewed;

  const Match({
    required this.id,
    required this.profile,
    required this.status,
    this.score,
    this.motivation,
    this.response,
    this.updatedAt,
    this.prompts,
    this.connections,
    this.tagGroups,
    this.venues,
    this.unreadCount,
    this.isPreview,
    this.isViewed,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      profile: Profile.fromJson(json['profile']),
      status: MatchStatus.fromJson(json['status']),
      score: json['score']?.toDouble(),
      motivation: json['motivation'] as String?,
      response: json['response'] != null ? MatchResponse.fromJson(json['response']) : null,
      updatedAt: json['updated_at'] != null && json['updated_at'] is String 
          ? DateTime.parse(json['updated_at']) : null,
      prompts: json['prompts'] != null
          ? (json['prompts'] as List).map((prompt) => Prompt.fromJson(prompt)).toList()
          : null,
      connections: json['connections'] != null
          ? (json['connections'] as List).map((conn) => Match.fromJson(conn)).toList()
          : null,
      tagGroups: json['taggroups'] != null
          ? (json['taggroups'] as List).map((group) => TagGroup.fromJson(group)).toList()
          : null,
      venues: json['venues'] != null
          ? (json['venues'] as List).map((venue) => Venue.fromJson(venue)).toList()
          : null,
      unreadCount: json['unread_count'] as int?,
      isPreview: json['is_preview'] as bool?,
      isViewed: json['is_viewed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile.toJson(),
      'status': status.toJson(),
      'score': score,
      'motivation': motivation,
      'response': response?.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
      'prompts': prompts?.map((prompt) => prompt.toJson()).toList(),
      'connections': connections?.map((conn) => conn.toJson()).toList(),
      'taggroups': tagGroups?.map((group) => group.toJson()).toList(),
      'venues': venues?.map((venue) => venue.toJson()).toList(),
      'unread_count': unreadCount,
      'is_preview': isPreview,
      'is_viewed': isViewed,
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
  
  // Computed properties matching iOS implementation
  int get nrOfPrompts => prompts?.length ?? 0;
  int get nrOfConnections => connections?.length ?? 0;
  int get nrOfTagGroups => tagGroups?.length ?? 0;
  int get nrOfVenues => venues?.length ?? 0;
  
  int get nrOfTags {
    if (tagGroups == null) return 0;
    return tagGroups!.fold(0, (total, tagGroup) {
      return total + (tagGroup.tags?.length ?? 0);
    });
  }
  
  List<TagGroup> get companyTagGroups {
    if (tagGroups == null) return [];
    return tagGroups!.where((group) => group.type?.value == 'company').toList();
  }
  
  List<TagGroup> get personalTagGroups {
    if (tagGroups == null) return [];
    return tagGroups!.where((group) => group.type?.value == 'personal').toList();
  }
  
  int get nrOfCompanyTags {
    return companyTagGroups.fold(0, (total, tagGroup) {
      return total + (tagGroup.tags?.length ?? 0);
    });
  }
  
  int get nrOfPersonalTags {
    return personalTagGroups.fold(0, (total, tagGroup) {
      return total + (tagGroup.tags?.length ?? 0);
    });
  }

  Match copyWith({
    String? id,
    Profile? profile,
    MatchStatus? status,
    double? score,
    String? motivation,
    MatchResponse? response,
    DateTime? updatedAt,
    List<Prompt>? prompts,
    List<Match>? connections,
    List<TagGroup>? tagGroups,
    List<Venue>? venues,
    int? unreadCount,
    bool? isPreview,
    bool? isViewed,
  }) {
    return Match(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      status: status ?? this.status,
      score: score ?? this.score,
      motivation: motivation ?? this.motivation,
      response: response ?? this.response,
      updatedAt: updatedAt ?? this.updatedAt,
      prompts: prompts ?? this.prompts,
      connections: connections ?? this.connections,
      tagGroups: tagGroups ?? this.tagGroups,
      venues: venues ?? this.venues,
      unreadCount: unreadCount ?? this.unreadCount,
      isPreview: isPreview ?? this.isPreview,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}