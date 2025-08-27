
import '../../models/models.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';

/// MatchingManager - Handles matching and connection operations
/// 
/// This manager is responsible for:
/// - Match fetching with pagination
/// - Match detail retrieval
/// - Match response handling (like/skip)
/// - Notification management
/// 
/// Features:
/// - Paginated match fetching
/// - Detailed match information with prompts and connections
/// - Match response recording
/// - Push notification management
class MatchingManager extends BaseSupabaseManager {
  static MatchingManager? _instance;
  
  /// The singleton instance of [MatchingManager].
  static MatchingManager get shared {
    _instance ??= MatchingManager._internal();
    AppLogger.debug('MatchingManager.shared accessed - instance ${_instance.hashCode}', context: 'MatchingManager');
    return _instance!;
  }
  
  /// Private constructor for singleton pattern.
  MatchingManager._internal();

  /// Fetch matches with pagination
  Future<List<Match>> fetchMatches(PaginatedRequest paginatedRequest) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching matches with pagination: $paginatedRequest', context: 'MatchingManager');
      
      // Call the get_matches RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc('get_matches', params: {'payload': paginatedRequest.toJson()})
          .select();
      
      AppLogger.success('Matches RPC call successful', context: 'MatchingManager');
      AppLogger.debug('Matches data received: ${result.length} matches', context: 'MatchingManager');
      
      // Convert response to list of Match objects
      final matches = (result as List)
          .map((json) => Match.fromJson(json))
          .toList();
      
      AppLogger.success('Matches parsed: ${matches.length} matches', context: 'MatchingManager');
      return matches;
    });
  }

  /// Fetch detailed match information
  Future<Match> fetchMatchDetail(String matchId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching match detail for ID: $matchId', context: 'MatchingManager');
      
      // Call the get_match RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc('get_match', params: {'p_match_id': matchId})
          .select()
          .single();
      
      AppLogger.success('Match detail RPC call successful', context: 'MatchingManager');
      AppLogger.debug('Match detail data received', context: 'MatchingManager');
      
      // Convert response to Match object
      final match = Match.fromJson(result);
      AppLogger.success('Match detail parsed: ${match.profile.fullName}', context: 'MatchingManager');
      
      return match;
    });
  }

  /// Insert match response (like/skip)
  Future<void> insertMatchResponse(String matchId, MatchResponse response) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Inserting match response', context: 'MatchingManager');
      
      final payload = {
        'match_id': matchId,
        'response': response.toJson(),
      };
      
      await client.rpc('insert_match_response', params: {'payload': payload});
      
      AppLogger.success('Match response inserted successfully', context: 'MatchingManager');
    });
  }

  /// Fetch notifications with pagination
  Future<List<Notification>> fetchNotifications(PaginatedRequest paginatedRequest) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching notifications with pagination: $paginatedRequest', context: 'MatchingManager');
      
      // Call the get_notifications RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc('get_notifications', params: {'payload': paginatedRequest.toJson()})
          .select();
      
      AppLogger.success('Notifications RPC call successful', context: 'MatchingManager');
      AppLogger.debug('Notifications data received: ${result.length} notifications', context: 'MatchingManager');
      
      // Convert response to list of Notification objects
      final notifications = (result as List)
          .map((json) => Notification.fromJson(json))
          .toList();
      
      AppLogger.success('Notifications parsed: ${notifications.length} notifications', context: 'MatchingManager');
      return notifications;
    });
  }
}