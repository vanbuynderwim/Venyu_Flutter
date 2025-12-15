import 'profile.dart';
import 'prompt.dart';
import 'tag_group.dart';
import 'venue.dart';
import 'score_detail.dart';
import 'stage.dart';
import 'enums/match_status.dart';
import 'enums/match_response.dart';

class Match {
  final String id;
  final Profile profile;
  final MatchStatus status;
  final double? score;
  final List<String>? motivation;
  final MatchResponse? response;
  final DateTime? updatedAt;
  final Prompt? prompt;
  final List<Prompt>? prompts;
  final List<Match>? connections;
  final List<TagGroup>? tagGroups;
  final List<Venue>? venues;
  final int? unreadCount;
  final bool? isPreview;
  final bool? isViewed;
  final List<ScoreDetail>? scoreDetails;
  final Stage? stage;

  const Match({
    required this.id,
    required this.profile,
    required this.status,
    this.score,
    this.motivation,
    this.response,
    this.updatedAt,
    this.prompt,
    this.prompts,
    this.connections,
    this.tagGroups,
    this.venues,
    this.unreadCount,
    this.isPreview,
    this.isViewed,
    this.scoreDetails,
    this.stage,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      profile: Profile.fromJson(json['profile']),
      status: MatchStatus.fromJson(json['status']),
      score: json['score']?.toDouble(),
      motivation: json['motivation'] != null
          ? (json['motivation'] as List).map((item) => item as String).toList()
          : null,
      response: json['response'] != null ? MatchResponse.fromJson(json['response']) : null,
      updatedAt: json['updated_at'] != null && json['updated_at'] is String
          ? DateTime.parse(json['updated_at']) : null,
      prompt: json['prompt'] != null ? Prompt.fromJson(json['prompt']) : null,
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
      scoreDetails: (json['score_detail'] ?? json['score_details']) != null
          ? ((json['score_detail'] ?? json['score_details']) as List).map((detail) => ScoreDetail.fromJson(detail)).toList()
          : null,
      stage: json['stage'] != null ? Stage.fromJson(json['stage']) : null,
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
      'prompt': prompt?.toJson(),
      'prompts': prompts?.map((p) => p.toJson()).toList(),
      'connections': connections?.map((conn) => conn.toJson()).toList(),
      'taggroups': tagGroups?.map((group) => group.toJson()).toList(),
      'venues': venues?.map((venue) => venue.toJson()).toList(),
      'unread_count': unreadCount,
      'is_preview': isPreview,
      'is_viewed': isViewed,
      'score_details': scoreDetails?.map((detail) => detail.toJson()).toList(),
      'stage': stage?.toJson(),
    };
  }

  // Helper methods
  //bool get isMatched => status == MatchStatus.matched;
  //bool get isConnected => status == MatchStatus.connected;
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
    List<String>? motivation,
    MatchResponse? response,
    DateTime? updatedAt,
    Prompt? prompt,
    List<Prompt>? prompts,
    List<Match>? connections,
    List<TagGroup>? tagGroups,
    List<Venue>? venues,
    int? unreadCount,
    bool? isPreview,
    bool? isViewed,
    List<ScoreDetail>? scoreDetails,
    Stage? stage,
  }) {
    return Match(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      status: status ?? this.status,
      score: score ?? this.score,
      motivation: motivation ?? this.motivation,
      response: response ?? this.response,
      updatedAt: updatedAt ?? this.updatedAt,
      prompt: prompt ?? this.prompt,
      prompts: prompts ?? this.prompts,
      connections: connections ?? this.connections,
      tagGroups: tagGroups ?? this.tagGroups,
      venues: venues ?? this.venues,
      unreadCount: unreadCount ?? this.unreadCount,
      isPreview: isPreview ?? this.isPreview,
      isViewed: isViewed ?? this.isViewed,
      scoreDetails: scoreDetails ?? this.scoreDetails,
      stage: stage ?? this.stage,
    );
  }
}