import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../../core/utils/app_logger.dart';

/// Base class for all Supabase domain managers.
/// 
/// Provides shared functionality including client access, initialization,
/// error handling, and common utilities. All domain-specific managers
/// should extend this base class to access Supabase functionality.
/// 
/// Features:
/// - Singleton-based SupabaseClient access
/// - Consistent error handling and tracking
/// - Secure storage operations
/// - Request execution wrapper
/// - Debugging and logging utilities
abstract class BaseSupabaseManager {
  static SupabaseClient? _client;
  static bool _isInitialized = false;
  static const _storage = FlutterSecureStorage();

  /// Direct access to the underlying [SupabaseClient] instance.
  /// 
  /// Provides low-level access to Supabase functionality when needed.
  /// Throws an exception if the manager has not been initialized.
  SupabaseClient get client {
    if (!_isInitialized || _client == null) {
      throw Exception('SupabaseManager must be initialized before use. Call SupabaseManager.shared.initialize() first.');
    }
    return _client!;
  }

  /// Static access to the underlying [SupabaseClient] instance.
  static SupabaseClient getClient() {
    if (!_isInitialized || _client == null) {
      throw Exception('SupabaseManager must be initialized before use. Call SupabaseManager.shared.initialize() first.');
    }
    return _client!;
  }

  /// Access to secure storage for user data.
  FlutterSecureStorage get storage => _storage;

  /// Whether the SupabaseManager has been properly initialized.
  bool get isInitialized => _isInitialized;

  /// Static check for initialization status.
  static bool get initialized => _isInitialized;

  /// Initialize Supabase with schema configuration.
  /// 
  /// This method handles the complete Supabase setup including schema configuration.
  /// Must be called before using any Supabase functionality.
  static Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.warning('BaseSupabaseManager already initialized, skipping', context: 'BaseSupabaseManager');
      return;
    }
    
    try {
      // Initialize Supabase with secure configuration and schema
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        postgrestOptions: const PostgrestClientOptions(
          schema: 'venyu_api_v1',
        ),
        debug: kDebugMode, // Enable debug logging in development
      );
      
      // Set the client reference
      _client = Supabase.instance.client;
      _isInitialized = true;
      
      AppLogger.success('BaseSupabaseManager initialized with schema: venyu_api_v1', context: 'BaseSupabaseManager');
      AppLogger.info('URL: ${AppConfig.supabaseUrl}', context: 'BaseSupabaseManager');
      
    } catch (error, stackTrace) {
      AppLogger.error('Failed to initialize Supabase', error: error, context: 'BaseSupabaseManager');
      _trackError('Supabase Initialization Failed', error, stackTrace);
      rethrow;
    }
  }

  /// Execute a request without authentication requirements.
  ///
  /// This method provides consistent error handling for anonymous/public
  /// Supabase requests that don't require authentication.
  Future<T> executeAnonymousRequest<T>(Future<T> Function() request) async {
    if (!_isInitialized) {
      throw Exception('SupabaseManager must be initialized before making requests');
    }

    try {
      final result = await request();
      return result;
    } on PostgrestException catch (postgrestError) {
      AppLogger.database('Database error: ${postgrestError.message}', context: 'BaseSupabaseManager');
      AppLogger.database('Details: ${postgrestError.details}', context: 'BaseSupabaseManager');
      AppLogger.database('Hint: ${postgrestError.hint}', context: 'BaseSupabaseManager');
      AppLogger.database('Code: ${postgrestError.code}', context: 'BaseSupabaseManager');

      // Track database errors with full context
      _trackError('Database Error', postgrestError, StackTrace.current, {
        'details': postgrestError.details,
        'hint': postgrestError.hint,
        'code': postgrestError.code,
      });
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected error in anonymous request', error: error, context: 'BaseSupabaseManager');

      // Track any other unexpected errors
      _trackError('Unexpected Anonymous Request Error', error, stackTrace);
      rethrow;
    }
  }

  /// Execute a request with proper authentication and error handling.
  ///
  /// This method provides consistent error handling and authentication
  /// for all Supabase requests across all domain managers.
  Future<T> executeAuthenticatedRequest<T>(Future<T> Function() request) async {
    if (!_isInitialized) {
      throw Exception('SupabaseManager must be initialized before making requests');
    }

    try {
      final result = await request();
      return result;
    } on AuthException catch (authError) {
      AppLogger.auth('Authentication error: ${authError.message}', context: 'BaseSupabaseManager');
      
      // Track authentication errors for debugging
      _trackError('Authentication Error', authError, StackTrace.current);
      rethrow;
    } on PostgrestException catch (postgrestError) {
      AppLogger.database('Database error: ${postgrestError.message}', context: 'BaseSupabaseManager');
      AppLogger.database('Details: ${postgrestError.details}', context: 'BaseSupabaseManager');
      AppLogger.database('Hint: ${postgrestError.hint}', context: 'BaseSupabaseManager');
      AppLogger.database('Code: ${postgrestError.code}', context: 'BaseSupabaseManager');
      
      // Track database errors with full context
      _trackError('Database Error', postgrestError, StackTrace.current, {
        'details': postgrestError.details,
        'hint': postgrestError.hint,
        'code': postgrestError.code,
      });
      rethrow;
    } on StorageException catch (storageError) {
      AppLogger.storage('Storage error: ${storageError.message}', context: 'BaseSupabaseManager');
      AppLogger.storage('Status Code: ${storageError.statusCode}', context: 'BaseSupabaseManager');
      
      // Track storage errors
      _trackError('Storage Error', storageError, StackTrace.current, {
        'statusCode': storageError.statusCode,
      });
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error('Unexpected error in authenticated request', error: error, context: 'BaseSupabaseManager');
      
      // Track any other unexpected errors
      _trackError('Unexpected Request Error', error, stackTrace);
      rethrow;
    }
  }

  /// Track errors to Bugsnag for monitoring and debugging.
  /// 
  /// Provides consistent error tracking across all domain managers.
  static void _trackError(String context, dynamic error, StackTrace stackTrace, [Map<String, dynamic>? metadata]) {
    if (kDebugMode) {
      AppLogger.debug('Error tracked: $context - $error', context: 'BaseSupabaseManager');
    }
    
    // In production, this should use an actual Bugsnag instance
    // For now, we'll just log the error details
    try {
      final enrichedMetadata = <String, dynamic>{
        'context': context,
        'error_type': error.runtimeType.toString(),
        if (metadata != null) ...metadata,
      };
      
      AppLogger.debug('Error metadata: $enrichedMetadata', context: 'BaseSupabaseManager');
  
      
    } catch (trackingError) {
      AppLogger.warning('Failed to track error: $trackingError', context: 'BaseSupabaseManager');
      // Don't rethrow - error tracking failures shouldn't break the app
    }
  }

  /// Clear all stored user data from secure storage.
  /// 
  /// Used during sign out operations across all domain managers.
  static Future<void> clearStoredUserData() async {
    try {
      AppLogger.info('Clearing stored user data...', context: 'BaseSupabaseManager');
      
      final keys = [
        'firstName',
        'lastName',
        'email',
        'linkedInProfileUrl',
        'avatarUrl',
        'appleUserIdentifier',
        'linkedInUserIdentifier',
        'googleUserIdentifier',
      ];
      
      for (final key in keys) {
        await _storage.delete(key: key);
      }
      
      AppLogger.success('Stored user data cleared', context: 'BaseSupabaseManager');
    } catch (error) {
      AppLogger.error('Failed to clear stored user data', error: error, context: 'BaseSupabaseManager');
      // Don't rethrow - cleanup failures shouldn't break sign out
    }
  }

  /// Get stored user information from secure storage.
  ///
  /// Returns a map of all stored user data for profile enhancement.
  static Future<Map<String, String?>> getStoredUserInfo() async {
    try {
      AppLogger.storage('Retrieving stored user info...', context: 'BaseSupabaseManager');

      final userInfo = <String, String?>{
        'firstName': await _storage.read(key: 'firstName'),
        'lastName': await _storage.read(key: 'lastName'),
        'email': await _storage.read(key: 'email'),
        'linkedInProfileUrl': await _storage.read(key: 'linkedInProfileUrl'),
        'avatarUrl': await _storage.read(key: 'avatarUrl'),
        'appleUserIdentifier': await _storage.read(key: 'appleUserIdentifier'),
        'linkedInUserIdentifier': await _storage.read(key: 'linkedInUserIdentifier'),
        'googleUserIdentifier': await _storage.read(key: 'googleUserIdentifier'),
        'auth_provider': await _storage.read(key: 'auth_provider'),
      };

      AppLogger.success('Retrieved stored user info', context: 'BaseSupabaseManager');
      return userInfo;
    } catch (error, stackTrace) {
      AppLogger.error('Failed to retrieve stored user info', error: error, context: 'BaseSupabaseManager');
      _trackError('Failed to retrieve stored user info', error, stackTrace);
      
      // Return empty map on error rather than crashing
      return <String, String?>{};
    }
  }
}