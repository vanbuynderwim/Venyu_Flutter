import 'profile.dart';
import 'enums/prompt_status.dart';
import 'enums/interaction_type.dart';

class Prompt {
  final int? feedID;
  final String promptID;
  final String label;
  final PromptStatus? status;
  final DateTime? createdAt;
  final int? impressionCount;
  final InteractionType? interactionType;
  final InteractionType? matchInteractionType;
  final Profile? profile;

  const Prompt({
    this.feedID,
    required this.promptID,
    required this.label,
    this.status,
    this.createdAt,
    this.impressionCount,
    this.interactionType,
    this.matchInteractionType,
    this.profile,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      feedID: json['feed_id'] as int?,
      promptID: json['prompt_id'] as String,
      label: json['label'] as String,
      status: json['status'] != null ? PromptStatus.fromJson(json['status']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      impressionCount: json['impression_count'] as int?,
      interactionType: json['interaction_type'] != null 
          ? InteractionType.fromJson(json['interaction_type']) 
          : null,
      matchInteractionType: json['match_interaction_type'] != null 
          ? InteractionType.fromJson(json['match_interaction_type']) 
          : null,
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed_id': feedID,
      'prompt_id': promptID,
      'label': label,
      'status': status?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'impression_count': impressionCount,
      'interaction_type': interactionType?.toJson(),
      'match_interaction_type': matchInteractionType?.toJson(),
      'profile': profile?.toJson(),
    };
  }

  // Helper methods
  bool get isApproved => status == PromptStatus.approved;
  bool get isPending => status == PromptStatus.pendingReview;
  bool get isRejected => status == PromptStatus.rejected;
}