import 'profile.dart';
import 'venue.dart';
import 'enums/prompt_status.dart';
import 'enums/interaction_type.dart';

class Prompt {
  final int? feedID;
  final String promptID;
  final String label;
  final PromptStatus? status;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final bool? expired;
  final int? impressionCount;
  final InteractionType? interactionType;
  final InteractionType? matchInteractionType;
  final Profile? profile;
  final Venue? venue;
  
  /// Number of matches associated with this prompt (optional).
  /// This is populated when fetching detailed prompt information.
  final int? matchCount;
  
  /// Number of connections associated with this prompt (optional).
  /// This is populated when fetching detailed prompt information.
  final int? connectionCount;

  const Prompt({
    this.feedID,
    required this.promptID,
    required this.label,
    this.status,
    this.createdAt,
    this.expiresAt,
    this.expired,
    this.impressionCount,
    this.interactionType,
    this.matchInteractionType,
    this.profile,
    this.venue,
    this.matchCount,
    this.connectionCount,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      feedID: json['feed_id'] as int?,
      promptID: json['prompt_id'] as String,
      label: json['label'] as String,
      status: json['status'] != null ? PromptStatus.fromJson(json['status']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      expired: json['expired'] as bool?,
      impressionCount: json['impression_count'] as int?,
      interactionType: json['interaction_type'] != null 
          ? InteractionType.fromJson(json['interaction_type']) 
          : null,
      matchInteractionType: json['match_interaction_type'] != null 
          ? InteractionType.fromJson(json['match_interaction_type']) 
          : null,
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      matchCount: json['match_count'] != null 
          ? (json['match_count'] as num).toInt() 
          : null,
      connectionCount: json['connection_count'] != null 
          ? (json['connection_count'] as num).toInt() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed_id': feedID,
      'prompt_id': promptID,
      'label': label,
      'status': status?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'expired': expired,
      'impression_count': impressionCount,
      'interaction_type': interactionType?.toJson(),
      'match_interaction_type': matchInteractionType?.toJson(),
      'profile': profile?.toJson(),
      'venue': venue?.toJson(),
      if (matchCount != null) 'match_count': matchCount,
      if (connectionCount != null) 'connection_count': connectionCount,
    };
  }

  // Helper methods
  bool get isApproved => status == PromptStatus.approved;
  bool get isPending => status == PromptStatus.pendingReview;
  bool get isRejected => status == PromptStatus.rejected;
  bool get isExpired => expired ?? false;
  
  /// A prompt is online only when it's approved AND not expired
  bool get isOnline => isApproved && !isExpired;
  
  /// A prompt is offline in all other cases (not approved OR expired)
  bool get isOffline => !isOnline;
  
  /// Get the display status for the UI - shows online/offline for approved prompts
  PromptStatus get displayStatus {
    if (status == PromptStatus.approved) {
      return isOnline ? PromptStatus.online : PromptStatus.offline;
    }
    return status ?? PromptStatus.draft;
  }
}