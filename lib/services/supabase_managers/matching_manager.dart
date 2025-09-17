
import '../../models/models.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

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
class MatchingManager extends BaseSupabaseManager with DisposableManagerMixin {
  static MatchingManager? _instance;
  
  /// The singleton instance of [MatchingManager].
  static MatchingManager get shared {
    _instance ??= MatchingManager._internal();
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
      AppLogger.success('Match detail parsed: ${match.profile_1.fullName}', context: 'MatchingManager');
      
      return match;
    });
  }

  /// Fetch matches for a specific prompt
  Future<List<Match>> fetchPromptMatches(String promptId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching prompt matches for: $promptId', context: 'MatchingManager');
      
      final result = await client.rpc('get_prompt_matches', params: {'p_prompt_id': promptId});
      
      AppLogger.success('Prompt matches RPC call successful', context: 'MatchingManager');
      AppLogger.debug('Prompt matches data received', context: 'MatchingManager');
      
      // Convert response to List<Match>
      final matches = (result as List).map((item) => Match.fromJson(item)).toList();
      AppLogger.success('Fetched ${matches.length} matches for prompt', context: 'MatchingManager');
      
      return matches;
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

  /// Remove a match
  Future<void> removeMatch(String matchId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Removing match with ID: $matchId', context: 'MatchingManager');

      // Call the remove_match RPC function
      await client.rpc('remove_match', params: {'p_match_id': matchId});

      AppLogger.success('Match removed successfully', context: 'MatchingManager');
    });
  }

  /// Block a profile
  Future<void> blockProfile(String profileId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Blocking profile with ID: $profileId', context: 'MatchingManager');

      // Call the block_profile RPC function
      await client.rpc('block_profile', params: {'p_profile_id': profileId});

      AppLogger.success('Profile blocked successfully', context: 'MatchingManager');
    });
  }

  /// Report a profile
  Future<void> reportProfile(String profileId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Reporting profile with ID: $profileId', context: 'MatchingManager');

      // Call the report_profile RPC function
      await client.rpc('report_profile', params: {'p_profile_id': profileId});

      AppLogger.success('Profile reported successfully', context: 'MatchingManager');
    });
  }
  
  /// Dispose this manager and clean up resources.
  void dispose() {
    disposeResources('MatchingManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!.disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}