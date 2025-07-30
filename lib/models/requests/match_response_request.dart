import '../enums/match_response.dart';

/// Request model for inserting match responses.
/// 
/// This model represents the payload sent to the Supabase RPC function
/// `insert_match_response` when a user responds to a match (interested/not interested).
/// 
/// Example usage:
/// ```dart
/// final request = MatchResponseRequest(
///   matchId: match.id,
///   response: MatchResponse.interested,
/// );
/// 
/// await supabaseManager.insertMatchResponse(request);
/// ```
class MatchResponseRequest {
  /// The unique identifier of the match to respond to.
  final String matchId;
  
  /// The user's response to the match.
  final MatchResponse response;

  /// Creates a [MatchResponseRequest] with the specified match ID and response.
  const MatchResponseRequest({
    required this.matchId,
    required this.response,
  });

  /// Converts this request to a JSON map for API submission.
  /// 
  /// Uses the field names expected by the Supabase RPC function:
  /// - `match_id`: The match identifier
  /// - `response`: The response value
  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'response': response.toJson(),
    };
  }

  /// Creates a [MatchResponseRequest] from a JSON map.
  factory MatchResponseRequest.fromJson(Map<String, dynamic> json) {
    return MatchResponseRequest(
      matchId: json['match_id'] as String,
      response: MatchResponse.fromJson(json['response'] as String),
    );
  }

  @override
  String toString() {
    return 'MatchResponseRequest(matchId: $matchId, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchResponseRequest &&
        other.matchId == matchId &&
        other.response == response;
  }

  @override
  int get hashCode => matchId.hashCode ^ response.hashCode;
}