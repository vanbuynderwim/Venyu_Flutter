import 'enums/interaction_type.dart';

/// PromptInteraction - Represents a user's interaction with a prompt
///
/// Contains information about how a user has interacted with a specific prompt,
/// including the interaction type, timestamp, and whether matching is still enabled.
class PromptInteraction {
  final int id;
  final InteractionType interactionType;
  final DateTime timestamp;
  final bool matchingEnabled;

  const PromptInteraction({
    required this.id,
    required this.interactionType,
    required this.timestamp,
    required this.matchingEnabled,
  });

  factory PromptInteraction.fromJson(Map<String, dynamic> json) {
    return PromptInteraction(
      id: (json['id'] as num).toInt(),
      interactionType: InteractionType.fromJson(json['interaction_type']),
      timestamp: DateTime.parse(json['timestamp']),
      matchingEnabled: json['matching_enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interaction_type': interactionType.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'matching_enabled': matchingEnabled,
    };
  }

  PromptInteraction copyWith({
    int? id,
    InteractionType? interactionType,
    DateTime? timestamp,
    bool? matchingEnabled,
  }) {
    return PromptInteraction(
      id: id ?? this.id,
      interactionType: interactionType ?? this.interactionType,
      timestamp: timestamp ?? this.timestamp,
      matchingEnabled: matchingEnabled ?? this.matchingEnabled,
    );
  }
}
