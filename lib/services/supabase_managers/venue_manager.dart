import '../../models/venue.dart';
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