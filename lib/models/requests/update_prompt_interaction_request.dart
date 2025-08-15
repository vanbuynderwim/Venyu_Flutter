import '../enums/interaction_type.dart';

/// Request model for updating prompt interactions.
/// 
/// This model represents the data sent to the backend when a user
/// interacts with a prompt (e.g., selecting "I can help", "I need this", etc.)
class UpdatePromptInteractionRequest {
  final int promptFeedID;
  final String promptID; // UUID as String in Flutter
  final InteractionType interactionType;

  UpdatePromptInteractionRequest({
    required this.promptFeedID,
    required this.promptID,
    required this.interactionType,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'prompt_feed_id': promptFeedID,
      'prompt_id': promptID,
      'interaction_type': interactionType.toJson(),
    };
  }
}