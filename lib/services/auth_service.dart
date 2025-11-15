import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import 'supabase_managers/authentication_manager.dart';
import 'supabase_managers/base_supabase_manager.dart';
import 'supabase_managers/profile_manager.dart';
import 'revenuecat_service.dart';

/// Represents the current authentication state of the user.
enum AuthenticationState {
  /// Initial state while checking for existing sessions.
  loading,

  /// No valid authentication session exists.
  unauthenticated,

  /// User is authenticated but profile setup is incomplete.
  authenticated,

  /// User is authenticated and has redeemed an invite code but hasn't completed registration.
  redeemed,

  /// User is authenticated and has completed profile registration.
  registered,

  /// An authentication error has occurred.
  error
}

/// Focused authentication service handling auth state and sessions.
/// 
/// This service replaces part of SessionManager's responsibilities,
/// focusing only on authentication flow and session management.
/// It uses proper disposal patterns and selective listening.
class AuthService extends ChangeNotifier {
  static AuthService? _instance;
  
  /// The global singleton instance with proper disposal tracking.
  static AuthService get shared {
    _instance ??= AuthService._internal();
    return _instance!;
  }
  
  /// Factory constructor supporting dependency injection.
  factory AuthService({AuthenticationManager? authManager}) {
    if (authManager != null) {
      return AuthService._internal(authManager: authManager);
    }
    return shared;
  }
  
  /// Private constructor with proper initialization.
  AuthService._internal({AuthenticationManager? authManager}) 
      : _authManager = authManager ?? AuthenticationManager.shared {
    _initialize();
  }
  
  // MARK: - Private Properties
  
  final AuthenticationManager _authManager;
  StreamSubscription<AuthState>? _authStateSubscription;
  
  // MARK: - Observable Properties
  
  AuthenticationState _authState = AuthenticationState.loading;
  Session? _currentSession;
  String? _lastError;
  bool _disposed = false;
  
  // MARK: - Public Getters
  
  /// The current authentication state.
  AuthenticationState get authState => _authState;
  
  /// The current Supabase authentication session.
  Session? get currentSession => _currentSession;
  
  /// Whether the user has a valid authentication session.
  bool get isAuthenticated => _currentSession != null;
  
  /// Whether the authentication state is currently being determined.
  bool get isLoading => _authState == AuthenticationState.loading;
  
  /// The most recent authentication error message, if any.
  String? get lastError => _lastError;
  
  /// The current Supabase user object.
  User? get currentUser => BaseSupabaseManager.getClient().auth.currentUser;
  
  /// Whether this service has been disposed.
  bool get disposed => _disposed;

  /// Access to the underlying AuthenticationManager for advanced operations
  AuthenticationManager get authenticationManager => _authManager;

  // MARK: - Initialization
  
  void _initialize() {
    if (_disposed) return;
    
    AppLogger.info('AuthService initializing...', context: 'AuthService');
    
    // Set initial session
    _currentSession = BaseSupabaseManager.getClient().auth.currentSession;
    
    // Setup auth state listener
    _setupAuthStateListener();
    
    // Perform initial check
    _performInitialCheck();
    
    AppLogger.success('AuthService initialized', context: 'AuthService');
  }
  
  void _setupAuthStateListener() {
    if (_disposed) return;
    
    _authStateSubscription?.cancel();
    _authStateSubscription = BaseSupabaseManager.getClient().auth.onAuthStateChange.listen(
      (AuthState authState) async {
        if (_disposed) return;

        // DETAILED DEBUG LOGGING FOR LINKEDIN OAUTH ISSUE
        AppLogger.debug('🔔 Auth event: ${authState.event}', context: 'AuthService');
        AppLogger.debug('   Session exists: ${authState.session != null}', context: 'AuthService');
        if (authState.session != null) {
          AppLogger.debug('   User ID: ${authState.session!.user.id}', context: 'AuthService');
          AppLogger.debug('   User email: ${authState.session!.user.email}', context: 'AuthService');
          AppLogger.debug('   Access token length: ${authState.session!.accessToken.length}', context: 'AuthService');
        }

        switch (authState.event) {
          case AuthChangeEvent.initialSession:
            await _handleInitialSession(authState.session);
            break;
          case AuthChangeEvent.signedIn:
            await _handleSignedIn(authState.session);
            break;
          case AuthChangeEvent.userUpdated:
            await _handleUserUpdated(authState.session);
            break;
          case AuthChangeEvent.tokenRefreshed:
            await _handleTokenRefreshed(authState.session);
            break;
          case AuthChangeEvent.signedOut:
            await _handleSignedOut();
            break;
          case AuthChangeEvent.passwordRecovery:
            // Handle if needed
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            await _handleSignedIn(authState.session);
            break;
          default:
            break;
        }
      },
      onError: (error) {
        if (_disposed) return;
        AppLogger.error('Auth state listener error: $error', context: 'AuthService');
        _handleAuthError(error);
      },
    );
  }
  
  void _performInitialCheck() async {
    if (_disposed) return;
    
    AppLogger.debug('Performing initial session check', context: 'AuthService');
    
    try {
      final session = BaseSupabaseManager.getClient().auth.currentSession;
      
      if (session != null) {
        AppLogger.info('Existing session found', context: 'AuthService');
        await _handleExistingSession(session);
      } else {
        AppLogger.info('No existing session found', context: 'AuthService');
        _updateAuthState(AuthenticationState.unauthenticated);
      }
    } catch (error) {
      AppLogger.error('Initial session check error: $error', context: 'AuthService');
      _handleAuthError(error);
    }
  }
  
  // MARK: - Event Handlers
  
  Future<void> _handleInitialSession(Session? session) async {
    if (_disposed) return;
    
    AppLogger.info('Handling initial session', context: 'AuthService');
    
    if (session != null) {
      await _handleExistingSession(session);
    } else {
      _updateAuthState(AuthenticationState.unauthenticated);
    }
  }
  
  Future<void> _handleExistingSession(Session session) async {
    if (_disposed) return;
    
    try {
      _currentSession = session;
      
      // Link RevenueCat user ID with existing Supabase user ID
      await _linkRevenueCatUser(session.user.id);
      
      // Just set to authenticated - let ProfileService handle profile logic
      _updateAuthState(AuthenticationState.authenticated);
      
    } catch (error) {
      AppLogger.error('Error handling existing session: $error', context: 'AuthService');
      _handleAuthError(error);
    }
  }
  
  Future<void> _handleSignedIn(Session? session) async {
    if (_disposed) return;
    
    AppLogger.success('User signed in', context: 'AuthService');
    
    session ??= BaseSupabaseManager.getClient().auth.currentSession;
    
    if (session == null) {
      AppLogger.error('No session available after sign in', context: 'AuthService');
      _handleAuthError('No session available after sign in');
      return;
    }

    _currentSession = session;
    
    // Link RevenueCat user ID with Supabase user ID
    await _linkRevenueCatUser(session.user.id);
    
    _updateAuthState(AuthenticationState.authenticated);
    
    AppLogger.success('Sign in process completed successfully', context: 'AuthService');
  }
  
  Future<void> _handleSignedOut() async {
    if (_disposed) return;
    
    AppLogger.info('User signed out - performing reset', context: 'AuthService');
    
    // Log out RevenueCat user
    await _logOutRevenueCatUser();
    
    _currentSession = null;
    _lastError = null;
    _updateAuthState(AuthenticationState.unauthenticated);
    
    AppLogger.success('Sign out cleanup completed', context: 'AuthService');
  }
  
  Future<void> _handleTokenRefreshed(Session? session) async {
    if (_disposed) return;
    
    AppLogger.debug('Token refreshed', context: 'AuthService');
    
    if (session != null) {
      _currentSession = session;
      // No need to change auth state - just update session
      if (!_disposed) notifyListeners();
    }
  }
  
  Future<void> _handleUserUpdated(Session? session) async {
    if (_disposed) return;
    
    AppLogger.info('User updated', context: 'AuthService');
    
    if (session != null) {
      _currentSession = session;
      if (!_disposed) notifyListeners();
    }
  }
  
  // MARK: - Public Authentication Methods
  
  /// Initiates Apple Sign In authentication flow.
  Future<void> signInWithApple() async {
    if (_disposed) throw StateError('AuthService has been disposed');
    
    try {
      AppLogger.info('Starting Apple sign in', context: 'AuthService');
      _clearError();
      
      await _authManager.signInWithApple();
      
      AppLogger.success('Apple sign in initiated', context: 'AuthService');
      
    } catch (error) {
      AppLogger.error('Apple sign in error: $error', context: 'AuthService');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Initiates LinkedIn OAuth authentication flow.
  Future<void> signInWithLinkedIn() async {
    if (_disposed) throw StateError('AuthService has been disposed');
    
    try {
      AppLogger.info('Starting LinkedIn sign in', context: 'AuthService');
      _clearError();
      
      await _authManager.signInWithLinkedIn();
      
      AppLogger.success('LinkedIn sign in initiated', context: 'AuthService');
      
    } catch (error) {
      AppLogger.error('LinkedIn sign in error: $error', context: 'AuthService');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Initiates Google OAuth authentication flow.
  Future<void> signInWithGoogle() async {
    if (_disposed) throw StateError('AuthService has been disposed');

    try {
      AppLogger.info('Starting Google sign in', context: 'AuthService');
      _clearError();

      await _authManager.signInWithGoogle();

      AppLogger.success('Google sign in completed', context: 'AuthService');

    } on AuthException catch (e) {
      // Handle Google Play Services not available error
      // This is expected on emulators and devices without Google Play Services
      if (e.message.contains('Google Sign In is not available')) {
        AppLogger.warning(
          'Google Play Services not available: ${e.message}',
          context: 'AuthService',
        );
        // Don't log to Sentry as critical - this is expected behavior
        // Just rethrow so UI can handle it
        rethrow;
      }

      // Other auth errors
      AppLogger.error('Auth error during Google sign in: $e', context: 'AuthService');
      _handleAuthError(e);
      rethrow;
    } on GoogleSignInException catch (e) {
      // User canceled the sign-in - this is not an error, just log it
      if (e.code == GoogleSignInExceptionCode.canceled) {
        AppLogger.info('Google sign in canceled by user', context: 'AuthService');
        // Don't change auth state or show error - user can try again
        return;
      }

      // Other Google sign-in errors are real errors
      AppLogger.error('Google sign in error: $e', context: 'AuthService');
      _handleAuthError(e);
      rethrow;
    } catch (error) {
      AppLogger.error('Google sign in error: $error', context: 'AuthService');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Signs out the current user and clears session data.
  Future<void> signOut() async {
    if (_disposed) throw StateError('AuthService has been disposed');
    
    try {
      AppLogger.info('Starting sign out', context: 'AuthService');
      _clearError();
      
      await _authManager.signOut();
      
      AppLogger.success('Sign out completed', context: 'AuthService');
      
    } catch (error) {
      AppLogger.error('Sign out error: $error', context: 'AuthService');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Manually update the authentication state.
  /// Used by ProfileService to indicate registration completion.
  void updateAuthState(AuthenticationState newState) {
    if (_disposed) return;
    _updateAuthState(newState);
  }
  
  // MARK: - RevenueCat Integration
  
  /// Link RevenueCat user ID with Supabase user ID
  Future<void> _linkRevenueCatUser(String supabaseUserId) async {
    // Only link RevenueCat if Pro features are enabled
    if (!AppConfig.showPro) {
      AppLogger.info('🚫 RevenueCat linking skipped - Pro features disabled in config', context: 'AuthService');
      return;
    }

    try {
      AppLogger.info('🔗 Linking RevenueCat user with Supabase ID: $supabaseUserId', context: 'AuthService');
      AppLogger.info('🔗 Current user email: ${currentUser?.email ?? 'NO EMAIL'}', context: 'AuthService');
      AppLogger.info('🔗 Current user metadata: ${currentUser?.userMetadata ?? 'NO METADATA'}', context: 'AuthService');

      await RevenueCatService().setUserId(supabaseUserId);

      AppLogger.success('✅ RevenueCat user linked successfully with ID: $supabaseUserId', context: 'AuthService');

      // Update the database with the RevenueCat user ID
      await _updateRevenueCatUserIdInDatabase(supabaseUserId);

    } catch (error) {
      AppLogger.warning('❌ Failed to link RevenueCat user: $error', context: 'AuthService');
      // Don't throw - this shouldn't block authentication
    }
  }
  
  /// Update RevenueCat user ID in database using ProfileManager
  Future<void> _updateRevenueCatUserIdInDatabase(String supabaseUserId) async {
    // Only update database if Pro features are enabled
    if (!AppConfig.showPro) {
      return;
    }

    try {
      AppLogger.info('📝 Updating RevenueCat user ID in database via ProfileManager', context: 'AuthService');

      final profileManager = ProfileManager.shared;
      await profileManager.updateRevenueCatAppUserId(supabaseUserId);

      AppLogger.success('✅ Database updated with RevenueCat user ID via ProfileManager', context: 'AuthService');
    } catch (error) {
      AppLogger.warning('❌ Failed to update RevenueCat user ID in database: $error', context: 'AuthService');
      // Don't throw - this shouldn't block authentication
    }
  }
  
  /// Log out RevenueCat user
  Future<void> _logOutRevenueCatUser() async {
    // Only log out RevenueCat if Pro features are enabled
    if (!AppConfig.showPro) {
      AppLogger.info('🚫 RevenueCat logout skipped - Pro features disabled in config', context: 'AuthService');
      return;
    }

    try {
      AppLogger.info('Logging out RevenueCat user', context: 'AuthService');
      await RevenueCatService().logOut();
      AppLogger.success('RevenueCat user logged out successfully', context: 'AuthService');
    } catch (error) {
      AppLogger.warning('Failed to log out RevenueCat user: $error', context: 'AuthService');
      // Don't throw - this shouldn't block sign out
    }
  }
  
  // MARK: - Error Handling
  
  void _handleAuthError(dynamic error) {
    if (_disposed) return;
    
    _lastError = _formatErrorMessage(error);
    _updateAuthState(AuthenticationState.error);
    
    AppLogger.error('AuthService error: $_lastError', context: 'AuthService');
  }
  
  String _formatErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return error.toString();
    }
  }
  
  void _clearError() {
    if (_disposed) return;
    _lastError = null;
  }
  
  // MARK: - State Management
  
  void _updateAuthState(AuthenticationState newState) {
    if (_disposed) return;
    
    if (_authState != newState) {
      final oldState = _authState;
      _authState = newState;
      
      AppLogger.info('Auth state changed: $oldState → $newState', context: 'AuthService');
      
      notifyListeners();
      
      AppLogger.debug('notifyListeners() called', context: 'AuthService');
    }
  }
  
  // MARK: - Cleanup
  
  /// Dispose resources with proper cleanup.
  @override
  void dispose() {
    if (_disposed) return;
    
    AppLogger.info('AuthService disposing', context: 'AuthService');
    
    _disposed = true;
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
    
    super.dispose();
  }
  
  /// Static method to dispose the singleton instance.
  /// Call this when the app is shutting down.
  static void disposeSingleton() {
    if (_instance != null && !_instance!._disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}