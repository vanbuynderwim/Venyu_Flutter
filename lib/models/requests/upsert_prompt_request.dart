import '../enums/interaction_type.dart';

/// Request model for upserting (insert or update) a prompt.
/// 
/// This request is used to create new prompts or update existing ones
/// through the Supabase RPC function 'upsert_prompt'.
class UpsertPromptRequest {
  /// The unique identifier of the prompt.
  /// Null for new prompts, populated for updates.
  final String? promptID;
  
  /// The type of interaction for this prompt.
  final InteractionType interactionType;
  
  /// The content/label of the prompt.
  final String label;

  const UpsertPromptRequest({
    this.promptID,
    required this.interactionType,
    required this.label,
  });

  Map<String, dynamic> toJson() => {
    'prompt_id': promptID,
    'interaction_type': interactionType.toJson(),
    'label': label,
  };
}