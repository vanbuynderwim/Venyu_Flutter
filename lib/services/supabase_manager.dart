
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/utils/app_logger.dart';
import 'supabase_managers/base_supabase_manager.dart';
// AuthenticationManager import removed - SessionManager uses it directly
// ProfileManager import removed - SessionManager handles profile avatar deletion directly
// ContentManager import removed - views use it directly
// MatchingManager import removed - views use it directly
// MediaManager import removed - SessionManager uses it directly

/// Centralized manager for all Supabase database operations and authentication.
/// 
/// This coordinating class provides a unified interface to all Supabase functionality
/// by delegating operations to specialized domain managers. This replaces the original
/// monolithic SupabaseManager with a clean separation of concerns.
/// 
/// Domain managers:
/// - [AuthenticationManager] - OAuth authentication (Apple, LinkedIn, Google)
/// - [ProfileManager] - User profile management and settings
/// - [ContentManager] - Cards, prompts, and tag operations
/// - [MatchingManager] - Match and notification handling
/// - [MediaManager] - Image upload and storage operations
/// 
/// Features:
/// - Singleton pattern with dependency injection support
/// - Consistent error handling across all domains
/// - Automatic initialization of underlying managers
/// - Backward compatibility with existing API
/// 
/// Example usage:
/// ```dart
/// // Initialize the manager
/// await SupabaseManager.shared.initialize();
/// 
/// // Authenticate with Apple
/// final response = await SupabaseManager.shared.signInWithApple();
/// 
/// // Fetch user profile
/// final profile = await SupabaseManager.shared.fetchUserProfile();
/// 
/// // Update profile information
/// await SupabaseManager.shared.updateProfileName(updateRequest);
/// ```
class SupabaseManager {
  static SupabaseManager? _instance;
  
  /// The global singleton instance of [SupabaseManager].
  /// 
  /// Provides convenient access to Supabase functionality throughout the app.
  /// Equivalent to the iOS `shared` property pattern.
  static SupabaseManager get shared {
    _instance ??= SupabaseManager._internal();
    return _instance!;
  }
  
  /// Factory constructor supporting dependency injection.
  /// 
  /// Returns the singleton instance by default, but allows for custom
  /// instances during testing or when specific configurations are needed.
  factory SupabaseManager() => shared;
  
  /// Private constructor for singleton pattern.
  /// 
  /// Prevents external instantiation and ensures only one instance exists.
  SupabaseManager._internal();

  // Domain managers - lazy initialization
  // AuthenticationManager removed - SessionManager uses it directly
  // ProfileManager removed - views use it directly
  // ContentManager removed - views use it directly
  // MatchingManager removed - views use it directly
  // MediaManager removed - SessionManager uses it directly

  // Access to authentication operations removed - SessionManager uses AuthenticationManager directly

  // Access to matching operations removed - views use MatchingManager directly

  // Access to media operations removed - SessionManager uses MediaManager directly

  /// Direct access to the underlying [SupabaseClient] instance.
  /// 
  /// Provides low-level access to Supabase functionality when needed.
  /// Most operations should use the higher-level methods provided by this class.
  SupabaseClient get client {
    if (!BaseSupabaseManager.initialized) {
      throw Exception('SupabaseManager must be initialized before use. Call SupabaseManager.shared.initialize() first.');
    }
    return BaseSupabaseManager.getClient();
  }

  /// Whether the SupabaseManager has been properly initialized.
  /// 
  /// Returns true if [initialize] has been called successfully.
  /// All other methods require initialization to be completed first.
  bool get isInitialized => BaseSupabaseManager.initialized;

  /// Get the current user from Supabase auth.
  User? get currentUser => BaseSupabaseManager.getClient().auth.currentUser;

  /// Get the current session from Supabase auth.
  Session? get currentSession => BaseSupabaseManager.getClient().auth.currentSession;

  /// Initialize Supabase with schema configuration.
  /// 
  /// This method handles the complete Supabase setup including schema configuration.
  /// Must be called before using any Supabase functionality.
  Future<void> initialize() async {
    AppLogger.info('Initializing SupabaseManager with domain managers', context: 'SupabaseManager');
    await BaseSupabaseManager.initialize();
    AppLogger.success('SupabaseManager initialization completed', context: 'SupabaseManager');
  }
}