import '../../models/venue.dart';
import '../../models/profile.dart';
import '../../models/prompt.dart';
import '../../models/match.dart';
import '../../models/requests/paginated_request.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

/// VenueManager - Handles venue operations and membership management
/// 
/// This manager is responsible for:
/// - Joining venues using invite codes
/// - Fetching venue information
/// - Managing venue memberships
/// - Handling venue-related operations
/// 
/// Features:
/// - Secure venue joining with validation
/// - Venue membership management
/// - Venue profile operations
/// - Code redemption tracking
class VenueManager extends BaseSupabaseManager with DisposableManagerMixin {
  static VenueManager? _instance;
  
  /// The singleton instance of [VenueManager].
  static VenueManager get shared {
    _instance ??= VenueManager._internal();
    return _instance!;
  }
  
  /// Private constructor for singleton pattern.
  VenueManager._internal();

  /// Fetch all active venues the current user is a member of.
  /// 
  /// Returns a list of [Venue] objects for all active memberships where:
  /// - User is an active member
  /// - Venue is active
  /// - Venue has started (starts_at <= now)
  /// - Venue has not expired (expires_at > now or null)
  /// 
  /// The list is sorted alphabetically by venue name.
  Future<List<Venue>> fetchVenues() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching user venues', context: 'VenueManager');
      
      try {
        // Call the get_venues RPC function
        final result = await client
            .rpc('get_venues')
            .select();
        
        AppLogger.success('Venues fetched successfully', context: 'VenueManager');
        
        // Convert response to list of Venue objects
        final venues = (result as List)
            .map((json) => Venue.fromJson(json))
            .toList();
        
        AppLogger.info('User is member of ${venues.length} active venues', context: 'VenueManager');
        
        return venues;
      } catch (error) {
        AppLogger.error('Failed to fetch venues', error: error, context: 'VenueManager');
        
        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();
        
        if (errorMessage.contains('no rows')) {
          // Return empty list if no venues found
          AppLogger.info('No active venues found for user', context: 'VenueManager');
          return [];
        }
        
        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Fetch detailed venue information by ID.
  /// 
  /// Returns a [Venue] object with complete venue information including
  /// member count and prompt count. User must be an active member of the venue
  /// to fetch its details.
  /// 
  /// Throws an exception if:
  /// - The venue doesn't exist
  /// - The user is not an active member of the venue
  Future<Venue> fetchVenue(String venueId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching venue details for ID: $venueId', context: 'VenueManager');
      
      try {
        // Call the get_venue RPC function
        final result = await client
            .rpc('get_venue', params: {'p_venue_id': venueId})
            .select()
            .single();
        
        AppLogger.success('Venue details fetched successfully', context: 'VenueManager');
        
        // Convert response to Venue object
        final venue = Venue.fromJson(result);
        AppLogger.info('Venue loaded: ${venue.name} (${venue.profileCount ?? 0} members, ${venue.promptCount ?? 0} prompts)', 
                      context: 'VenueManager');
        
        return venue;
      } catch (error) {
        AppLogger.error('Failed to fetch venue details', error: error, context: 'VenueManager');
        
        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();
        
        if (errorMessage.contains('single') || errorMessage.contains('no rows')) {
          throw Exception('You are not a member of this venue or it does not exist.');
        }
        
        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Join a venue using an 8-character invite code.
  /// 
  /// This method validates the code and adds the user to the venue if valid.
  /// Returns the venue ID if successful, which can be used to navigate to the venue.
  /// 
  /// The function handles:
  /// - Code validation (8 characters, not expired, not used)
  /// - Duplicate membership checks
  /// - Reactivation of inactive memberships
  /// - Code redemption tracking
  /// 
  /// Throws:
  /// - Exception if code is invalid, expired, or already used
  /// - Exception if user is already an active member
  Future<String> joinVenue(String code) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Attempting to join venue with code: ${code.substring(0, 3)}***', context: 'VenueManager');
      
      try {
        // Call the join_venue RPC function
        final result = await client.rpc(
          'join_venue',
          params: {'p_code': code.toUpperCase()},
        );

        // result is direct de UUID string
        final venueId = result as String;
        
        AppLogger.success('Successfully joined venue', context: 'VenueManager');
              
        AppLogger.info('Joined venue with ID: $venueId', context: 'VenueManager');
        
        return venueId;
      } catch (error) {
        AppLogger.error('Failed to join venue', error: error, context: 'VenueManager');
        
        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();
        
        if (errorMessage.contains('Invalid or expired code')) {
          throw Exception('This code is invalid or has expired. Please request a new code.');
        } else if (errorMessage.contains('already an active member')) {
          throw Exception('You are already a member of this venue.');
        } else if (errorMessage.contains('Code is required')) {
          throw Exception('Please enter a venue code.');
        } else if (errorMessage.contains('exactly 8 characters')) {
          throw Exception('The code must be exactly 8 characters long.');
        }
        
        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Fetch profiles (members) of a venue with pagination.
  /// 
  /// This method is only available to venue admins and returns a paginated list
  /// of venue members. The response includes profile information with tag groups.
  /// 
  /// Returns a list of [Profile] objects for active venue members sorted by join date.
  /// 
  /// Parameters:
  /// - [venueId]: The ID of the venue to fetch members for
  /// - [request]: Paginated request parameters including limit and cursor info
  /// 
  /// Throws an exception if:
  /// - User is not an admin of the venue
  /// - The venue doesn't exist
  /// - Invalid request parameters
  Future<List<Profile>> fetchVenueProfiles(String venueId, PaginatedRequest request) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching venue profiles for venue: $venueId', context: 'VenueManager');
      
      try {
        // Build payload for the RPC function
        final payload = <String, dynamic>{
          'venue_id': venueId,
          'limit': request.limit,
        };
        
        // Add cursor parameters if provided
        if (request.cursorTime != null) {
          payload['cursor_time'] = request.cursorTime!.toIso8601String();
        }
        if (request.cursorId != null) {
          payload['cursor_id'] = request.cursorId;
        }
        
        // Call the get_venue_profiles RPC function
        final result = await client
            .rpc('get_venue_profiles', params: {'payload': payload})
            .select();
        
        AppLogger.success('Venue profiles fetched successfully', context: 'VenueManager');
        
        // Convert response to list of Profile objects
        final profiles = (result as List)
            .map((json) => Profile.fromJson(json))
            .toList();
        
        AppLogger.info('Fetched ${profiles.length} venue profiles', context: 'VenueManager');
        
        return profiles;
      } catch (error) {
        AppLogger.error('Failed to fetch venue profiles', error: error, context: 'VenueManager');
        
        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();
        
        if (errorMessage.contains('Only venue admins can view venue profiles')) {
          throw Exception('You need admin privileges to view venue members.');
        } else if (errorMessage.contains('venue_id is required')) {
          throw Exception('Venue ID is required.');
        }
        
        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Fetch paginated prompts for a specific venue (admin only).
  /// 
  /// This method retrieves all approved prompts for a venue with pagination support.
  /// Only venue admins can access this information.
  /// 
  /// Parameters:
  /// - [venueId]: The UUID of the venue to fetch prompts for
  /// - [request]: Pagination parameters including limit, cursor time, and cursor ID
  /// 
  /// Returns a list of [Prompt] objects ordered by creation date (most recent first).
  /// 
  /// Throws an exception if:
  /// - User is not an admin of the venue
  /// - The venue doesn't exist
  /// - Invalid request parameters
  Future<List<Prompt>> fetchVenuePrompts(String venueId, PaginatedRequest request) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching venue prompts for venue: $venueId', context: 'VenueManager');
      
      try {
        // Build payload for the RPC function
        final payload = <String, dynamic>{
          'venue_id': venueId,
          'limit': request.limit,
        };
        
        // Add cursor parameters if provided
        if (request.cursorTime != null) {
          payload['cursor_time'] = request.cursorTime!.toIso8601String();
        }
        if (request.cursorId != null) {
          payload['cursor_id'] = request.cursorId;
        }
        
        // Call the get_venue_prompts RPC function
        final result = await client
            .rpc('get_venue_prompts', params: {'payload': payload})
            .select();
        
        AppLogger.success('Venue prompts fetched successfully', context: 'VenueManager');
        
        // Convert response to list of Prompt objects
        final prompts = (result as List)
            .map((json) => Prompt.fromJson(json))
            .toList();
        
        AppLogger.info('Fetched ${prompts.length} venue prompts', context: 'VenueManager');
        
        return prompts;
      } catch (error) {
        AppLogger.error('Failed to fetch venue prompts', error: error, context: 'VenueManager');
        
        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();
        
        if (errorMessage.contains('Only venue admins can view venue prompts')) {
          throw Exception('You need admin privileges to view venue prompts.');
        } else if (errorMessage.contains('venue_id is required')) {
          throw Exception('Venue ID is required.');
        }
        
        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Fetch matches for a specific venue (non-paginated).
  ///
  /// This method retrieves all matches for members of a specific venue.
  /// Returns a list of matches with profile information, score, status, and metadata.
  ///
  /// Parameters:
  /// - [venueId]: The UUID of the venue to fetch matches for
  ///
  /// Returns a list of [Match] objects ordered by update time (most recent first).
  ///
  /// Throws an exception if:
  /// - The venue doesn't exist
  /// - User doesn't have permission to view venue matches
  /// - Invalid venue ID
  Future<List<Match>> fetchVenueMatches(String venueId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching venue matches for venue: $venueId', context: 'VenueManager');

      try {
        // Call the get_venue_matches RPC function
        final result = await client
            .rpc('get_venue_matches', params: {'p_venue_id': venueId})
            .select();

        AppLogger.success('Venue matches fetched successfully', context: 'VenueManager');

        // Convert response to list of Match objects
        final matches = (result as List)
            .map((json) => Match.fromJson(json))
            .toList();

        AppLogger.info('Fetched ${matches.length} venue matches', context: 'VenueManager');

        return matches;
      } catch (error) {
        AppLogger.error('Failed to fetch venue matches', error: error, context: 'VenueManager');

        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();

        if (errorMessage.contains('venue_id is required')) {
          throw Exception('Venue ID is required.');
        } else if (errorMessage.contains('permission')) {
          throw Exception('You don\'t have permission to view matches for this venue.');
        }

        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Dispose this manager and clean up resources.
  void dispose() {
    disposeResources('VenueManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!.disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}