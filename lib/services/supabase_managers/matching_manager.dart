
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
/// - Match removal, blocking, and reporting
///
/// Features:
/// - Paginated match fetching
/// - Detailed match information with prompts and connections
/// - Match response recording
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

      // Call the get_match RPC function
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

  /// Insert a match stage
  ///
  /// This method inserts a connection stage for a match.
  /// If the stage already exists for this match, it will be ignored.
  ///
  /// [matchId] The UUID of the match
  /// [connectionStageId] The UUID of the connection stage to insert
  Future<void> insertMatchStage({
    required String matchId,
    required String connectionStageId,
  }) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Inserting match stage for match: $matchId', context: 'MatchingManager');

      final payload = {
        'match_id': matchId,
        'connection_stage_id': connectionStageId,
      };

      await client.rpc('insert_match_stage', params: {'payload': payload});

      AppLogger.success('Match stage inserted successfully', context: 'MatchingManager');
    });
  }

  /// Send a contact request to a match
  ///
  /// This method sends a contact request with selected contact settings and an optional message.
  /// It updates the match stage to 'reached_out'.
  ///
  /// [matchId] The UUID of the match to send the contact request to
  /// [contactSettingIds] List of contact setting UUIDs to share
  /// [content] Optional message content to include with the request
  Future<void> sendContactRequest({
    required String matchId,
    required List<String> contactSettingIds,
    String? content,
  }) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Sending contact request for match: $matchId', context: 'MatchingManager');

      final payload = {
        'match_id': matchId,
        'contact_setting_ids': contactSettingIds,
        'content': content,
      };

      await client.rpc('send_contact_request', params: {'payload': payload});

      AppLogger.success('Contact request sent successfully', context: 'MatchingManager');
    });
  }

  /// Get all connection stages for a match
  ///
  /// This method retrieves all available connection stages with their selection status
  /// for the specified match.
  ///
  /// [matchId] The UUID of the match to get stages for
  /// Returns a list of [Stage] objects with the `selected` property indicating
  /// the current stage of the match
  Future<List<Stage>> getMatchConnectionStages(String matchId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching connection stages for match: $matchId', context: 'MatchingManager');

      final result = await client.rpc(
        'get_match_connection_stages',
        params: {'p_match_id': matchId},
      );

      AppLogger.success('Connection stages RPC call successful', context: 'MatchingManager');

      final stages = (result as List).map((json) => Stage.fromJson(json)).toList();
      AppLogger.debug('Fetched ${stages.length} connection stages', context: 'MatchingManager');

      return stages;
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