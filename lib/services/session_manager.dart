import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import 'supabase_manager.dart';

/// Represents the current authentication state of the user.
/// 
/// These states mirror the iOS app's authentication flow and help
/// determine which UI screens should be presented to the user.
enum AuthenticationState {
  /// Initial state while checking for existing sessions.
  loading,
  
  /// No valid authentication session exists.
  unauthenticated,
  
  /// User is authenticated but profile setup is incomplete.
  authenticated,
  
  /// User is authenticated and has completed profile registration.
  registered,
  
  /// An authentication error has occurred.
  error
}

/// Centralized manager for authentication state and user session lifecycle.
/// 
/// This class manages the complete authentication flow including sign in/out,
/// session persistence, profile loading, and state notifications. It serves as
/// the single source of truth for authentication status throughout the app.
/// 
/// The manager automatically:
/// - Listens to Supabase authentication state changes
/// - Loads user profiles after successful authentication
/// - Handles token refresh and session validation
/// - Provides reactive updates via [ChangeNotifier]
/// 
/// Example usage:
/// ```dart
/// // Listen to authentication state
/// SessionManager.shared.addListener(() {
///   final state = SessionManager.shared.authState;
///   if (state == AuthenticationState.registered) {
///     navigateToMainApp();
///   }
/// });
/// 
/// // Sign in with Apple
/// await SessionManager.shared.signInWithApple();
/// 
/// // Check current state
/// if (SessionManager.shared.isAuthenticated) {
///   final profile = SessionManager.shared.currentProfile;
/// }
/// ```
/// 
/// See also:
/// * [SupabaseManager] for low-level authentication operations
/// * [AuthenticationState] for available states
class SessionManager extends ChangeNotifier {
  static SessionManager? _instance;
  
  /// The global singleton instance of [SessionManager].
  /// 
  /// Provides convenient access to session management throughout the app.
  static SessionManager get shared {
    _instance ??= SessionManager._internal();
    return _instance!;
  }
  
  /// Factory constructor supporting dependency injection.
  /// 
  /// Useful for testing or when custom [SupabaseManager] instances are needed.
  factory SessionManager({SupabaseManager? supabaseManager}) {
    if (supabaseManager != null) {
      return SessionManager._internal(supabaseManager: supabaseManager);
    }
    return shared;
  }
  
  /// Private constructor for singleton pattern.
  /// 
  /// Initializes the manager and sets up authentication state listening.
  SessionManager._internal({SupabaseManager? supabaseManager}) 
      : _supabaseManager = supabaseManager ?? SupabaseManager.shared {
    // Initialize immediately since SupabaseManager should be ready when SessionManager is created
    _initialize();
  }
  
  // MARK: - Private Properties
  
  final SupabaseManager _supabaseManager;
  late final StreamSubscription _authStateSubscription;
  
  // MARK: - Observable Properties (equivalent to iOS @Observable/@Published)
  
  AuthenticationState _authState = AuthenticationState.loading;
  Profile? _currentProfile;
  Session? _currentSession;
  String? _lastError;
  
  // MARK: - Public Getters (equivalent to iOS computed properties)
  
  /// The current authentication state.
  /// 
  /// Reflects the user's authentication and registration status.
  /// Listen to this manager for state change notifications.
  AuthenticationState get authState => _authState;
  
  /// The current user's profile data, if available.
  /// 
  /// Returns null if the user is not authenticated or if profile loading failed.
  Profile? get currentProfile => _currentProfile;
  
  /// The current Supabase authentication session.
  /// 
  /// Contains access tokens and session metadata. Null if not authenticated.
  Session? get currentSession => _currentSession;
  
  /// Whether the user has a valid authentication session.
  /// 
  /// Returns true if [currentSession] is not null.
  bool get isAuthenticated => _currentSession != null;
  
  /// Whether the user has completed the registration process.
  /// 
  /// Returns true if the user's profile has a [registeredAt] timestamp.
  bool get isRegistered => _currentProfile?.registeredAt != null;
  
  /// Whether the authentication state is currently being determined.
  /// 
  /// Returns true during initial session checks and state transitions.
  bool get isLoading => _authState == AuthenticationState.loading;
  
  /// The most recent authentication error message, if any.
  /// 
  /// Cleared when new authentication attempts are made.
  String? get lastError => _lastError;
  
  /// The current Supabase user object.
  /// 
  /// Convenience getter that delegates to [SupabaseManager.currentUser].
  User? get currentUser => _supabaseManager.currentUser;
  
  // MARK: - Initialization Methods
  
  /// Initialize SessionManager - equivalent to iOS init and setup
  void _initialize() {
    debugPrint('🎯 SessionManager initializing...');
    
    // Ensure SupabaseManager is initialized before proceeding
    if (!_supabaseManager.isInitialized) {
      debugPrint('⚠️ SupabaseManager not yet initialized, SessionManager will wait');
      // In a real scenario, this should be handled by proper initialization order in main.dart
      return;
    }
    
    // Set initial session from Supabase
    _currentSession = _supabaseManager.currentSession;
    
    // Listen to Supabase auth state changes (equivalent to iOS setupAuthStateChange)
    _setupAuthStateListener();
    
    // Perform initial session check
    _performInitialSessionCheck();
    
    debugPrint('✅ SessionManager initialized');
  }
  
  /// Setup auth state listener - equivalent to iOS setupAuthStateChange
  void _setupAuthStateListener() {
    debugPrint('👂 Setting up auth state listener');
    
    _authStateSubscription = _supabaseManager.client.auth.onAuthStateChange.listen(
      (AuthState authState) async {
        debugPrint('🔄 Auth state changed: ${authState.event}');
        
        switch (authState.event) {
          case AuthChangeEvent.initialSession:
            await _handleInitialSession(authState.session);
            break;
          case AuthChangeEvent.signedIn:
            await _handleSignedIn(authState.session);
            break;
          case AuthChangeEvent.signedOut:
            await _handleSignedOut();
            break;
          case AuthChangeEvent.tokenRefreshed:
            await _handleTokenRefreshed(authState.session);
            break;
          case AuthChangeEvent.userUpdated:
            await _handleUserUpdated(authState.session);
            break;
          case AuthChangeEvent.passwordRecovery:
            // Handle password recovery if needed
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            // Handle MFA challenge verification - treat as sign in success
            await _handleSignedIn(authState.session);
            break;
          default:
            // Handle any other auth events (including deprecated ones)
            debugPrint('🔄 Unhandled auth event: ${authState.event}');
            break;
        }
      },
      onError: (error) {
        debugPrint('❌ Auth state listener error: $error');
        _handleAuthError(error);
      },
    );
  }
  
  /// Perform initial session check - equivalent to iOS checkAuthState
  void _performInitialSessionCheck() async {
    debugPrint('🔍 Performing initial session check');
    
    try {
      final session = _supabaseManager.currentSession;
      
      if (session != null) {
        debugPrint('📋 Existing session found, fetching profile');
        await _handleExistingSession(session);
      } else {
        debugPrint('🚫 No existing session found');
        _updateAuthState(AuthenticationState.unauthenticated);
      }
    } catch (error) {
      debugPrint('❌ Initial session check error: $error');
      _handleAuthError(error);
    }
  }
  
  // MARK: - Authentication Event Handlers
  
  /// Handle initial session - equivalent to iOS initial session handling
  Future<void> _handleInitialSession(Session? session) async {
    debugPrint('🎬 Handling initial session');
    
    if (session != null) {
      await _handleExistingSession(session);
    } else {
      _updateAuthState(AuthenticationState.unauthenticated);
    }
  }
  
  /// Handle existing session - fetch profile and determine state
  Future<void> _handleExistingSession(Session session) async {
    try {
      _currentSession = session;
      
      debugPrint('👤 Fetching user profile for session');
      await _fetchUserProfile();
      
      // Determine authentication state based on profile
      _updateAuthState(_determineAuthenticationState());
      
    } catch (error) {
      debugPrint('❌ Error handling existing session: $error');
      _handleAuthError(error);
    }
  }
  
  /// Handle successful sign in - equivalent to iOS sign in handling
  Future<void> _handleSignedIn(Session? session) async {
    debugPrint('✅ User signed in successfully');
    
    if (session == null) {
      debugPrint('⚠️ Sign in successful but no session provided');
      _handleAuthError('No session provided after sign in');
      return;
    }
    
    _currentSession = session;
    
    try {
      // Fetch user profile after successful sign in
      await _fetchUserProfile();
      
      // Determine state based on profile completion
      _updateAuthState(_determineAuthenticationState());
      
      debugPrint('🎉 Sign in process completed successfully');
      
    } catch (error) {
      debugPrint('❌ Error after sign in: $error');
      
      // Even if profile fetch fails, user is still authenticated
      _updateAuthState(AuthenticationState.authenticated);
    }
  }
  
  /// Handle sign out - equivalent to iOS sign out handling
  Future<void> _handleSignedOut() async {
    debugPrint('👋 User signed out');
    
    // Clear session and profile data
    _currentSession = null;
    _currentProfile = null;
    _lastError = null;
    
    // Update state
    _updateAuthState(AuthenticationState.unauthenticated);
    
    debugPrint('✅ Sign out cleanup completed');
  }
  
  /// Handle token refresh - equivalent to iOS token refresh handling
  Future<void> _handleTokenRefreshed(Session? session) async {
    debugPrint('🔄 Token refreshed');
    
    if (session != null) {
      _currentSession = session;
      // No need to change auth state - just update session
      notifyListeners();
    }
  }
  
  /// Handle user updated - equivalent to iOS user update handling
  Future<void> _handleUserUpdated(Session? session) async {
    debugPrint('👤 User updated');
    
    if (session != null) {
      _currentSession = session;
      
      try {
        // Refetch profile to get updated information
        await _fetchUserProfile();
        _updateAuthState(_determineAuthenticationState());
      } catch (error) {
        debugPrint('❌ Error updating user profile: $error');
      }
    }
  }
  
  // MARK: - Profile Management Methods
  
  /// Fetch user profile from database - equivalent to iOS fetchCurrentProfile
  /// 
  /// This method exactly matches the iOS fetchCurrentProfile implementation:
  /// 1. Calls SupabaseManager.fetchUserProfile() (which uses RPC call)
  /// 2. Updates currentProfile and authentication state
  /// 3. Handles errors by signing out (matching iOS behavior)
  Future<void> _fetchUserProfile() async {
    try {
      debugPrint('📥 SessionManager: Fetching current profile');
      
      // Use SupabaseManager.fetchUserProfile() - exact equivalent of iOS call
      final fetchedProfile = await _supabaseManager.fetchUserProfile();
      
      // Update current profile and authentication state - equivalent to iOS MainActor.run
      _currentProfile = fetchedProfile;
      
      // Update authentication state based on profile completion
      _updateAuthState(_determineAuthenticationState());
      
      debugPrint('✅ fetchCurrentProfile successful');
      debugPrint('👤 Profile loaded: ${_currentProfile?.displayName} (${_currentProfile?.contactEmail})');
      
      // TODO: Add Bugsnag user identification when error tracking is implemented
      // Bugsnag.setUser(_currentUser.id.uuidString, withEmail: _currentProfile.email, andName: _currentProfile.fullName)
      
    } catch (error) {
      debugPrint('❌ Failed to fetch profile: $error');
      
      // TODO: Add Bugsnag error tracking when implemented
      // Bugsnag.notifyError(error);
      
      try {
        debugPrint('🚪 Signing out due to profile fetch failure');
        await _supabaseManager.signOut();
        debugPrint('✅ Sign out completed after profile fetch failure');
      } catch (signOutError) {
        debugPrint('❌ Failed to logout profile: $signOutError');
      }
      
      // Clear authentication state - equivalent to iOS behavior
      _currentProfile = null;
      _currentSession = null;
      
      rethrow;
    }
  }
  
  /// Determine authentication state based on session and profile
  AuthenticationState _determineAuthenticationState() {
    debugPrint('🔍 Determining auth state:');
    debugPrint('  - Session: ${_currentSession != null}');
    debugPrint('  - Profile: ${_currentProfile != null}');
    debugPrint('  - RegisteredAt: ${_currentProfile?.registeredAt}');
    
    if (_currentSession == null) {
      debugPrint('  → Unauthenticated (no session)');
      return AuthenticationState.unauthenticated;
    }
    
    if (_currentProfile == null || _currentProfile!.registeredAt == null) {
      debugPrint('  → Authenticated (session but no complete profile)');
      return AuthenticationState.authenticated;
    }
    
    debugPrint('  → Registered (session + complete profile)');
    return AuthenticationState.registered;
  }
  
  // MARK: - Public Authentication Methods
  
  /// Initiates Apple Sign In authentication flow.
  /// 
  /// This method:
  /// 1. Clears any previous errors
  /// 2. Delegates to [SupabaseManager.signInWithApple]
  /// 3. Updates authentication state via the auth state listener
  /// 
  /// Throws authentication exceptions if the sign in process fails.
  Future<void> signInWithApple() async {
    try {
      debugPrint('🍎 SessionManager: Starting Apple sign in');
      _clearError();
      
      await _supabaseManager.signInWithApple();
      
      // Auth state will be updated via the auth state listener
      debugPrint('✅ SessionManager: Apple sign in initiated');
      
    } catch (error) {
      debugPrint('❌ SessionManager: Apple sign in error: $error');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Initiates LinkedIn OAuth authentication flow.
  /// 
  /// This method:
  /// 1. Clears any previous errors
  /// 2. Delegates to [SupabaseManager.signInWithLinkedIn]
  /// 3. Updates authentication state via the auth state listener
  /// 
  /// Note: LinkedIn authentication completes via deep link callback.
  /// Throws authentication exceptions if the sign in process fails.
  Future<void> signInWithLinkedIn() async {
    try {
      debugPrint('💼 SessionManager: Starting LinkedIn sign in');
      _clearError();
      
      await _supabaseManager.signInWithLinkedIn();
      
      // Auth state will be updated via the auth state listener
      debugPrint('✅ SessionManager: LinkedIn sign in initiated');
      
    } catch (error) {
      debugPrint('❌ SessionManager: LinkedIn sign in error: $error');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Updates the current profile with new data.
  /// 
  /// This method should be called after successfully updating profile data
  /// to keep the SessionManager in sync with the database.
  void updateCurrentProfile(Profile updatedProfile) {
    debugPrint('🔄 SessionManager: Updating current profile');
    _currentProfile = updatedProfile;
    
    // Notify listeners about the profile update
    notifyListeners();
    
    debugPrint('✅ Profile updated: ${_currentProfile?.displayName}');
  }

  /// Updates specific fields of the current profile without fetching from database.
  /// 
  /// This is more efficient than fetching the entire profile when you only
  /// need to update specific fields after a successful API call.
  void updateCurrentProfileFields({
    String? firstName,
    String? lastName,
    String? companyName,
    String? bio,
    String? linkedInURL,
    String? websiteURL,
    String? contactEmail,
    bool? showEmail,
    String? avatarID,
    DateTime? timestamp,
    DateTime? registeredAt,
    double? distance,
    bool? isSuperAdmin,
    bool? newsletterSubscribed,
    String? publicKey,
  }) {
    if (_currentProfile == null) {
      debugPrint('⚠️ SessionManager: Cannot update profile fields - no current profile');
      return;
    }

    debugPrint('🔄 SessionManager: Updating profile fields');
    
    _currentProfile = _currentProfile!.copyWith(
      firstName: firstName,
      lastName: lastName,
      companyName: companyName,
      bio: bio,
      linkedInURL: linkedInURL,
      websiteURL: websiteURL,
      contactEmail: contactEmail,
      showEmail: showEmail,
      avatarID: avatarID,
      timestamp: timestamp,
      registeredAt: registeredAt,
      distance: distance,
      isSuperAdmin: isSuperAdmin,
      newsletterSubscribed: newsletterSubscribed,
      publicKey: publicKey,
    );
    
    // Notify listeners about the profile update
    notifyListeners();
    
    debugPrint('✅ Profile fields updated: ${_currentProfile?.displayName}');
  }

  /// Signs out the current user and clears all session data.
  /// 
  /// This method:
  /// 1. Clears any previous errors
  /// 2. Delegates to [SupabaseManager.signOut]
  /// 3. Updates authentication state via the auth state listener
  /// 
  /// Throws exceptions if the sign out process fails.
  Future<void> signOut() async {
    try {
      debugPrint('👋 SessionManager: Starting sign out');
      _clearError();
      
      await _supabaseManager.signOut();
      
      // Auth state will be updated via the auth state listener
      debugPrint('✅ SessionManager: Sign out completed');
      
    } catch (error) {
      debugPrint('❌ SessionManager: Sign out error: $error');
      _handleAuthError(error);
      rethrow;
    }
  }

  
  // MARK: - Error Handling Methods
  
  /// Handle authentication error - equivalent to iOS error handling
  void _handleAuthError(dynamic error) {
    _lastError = _formatErrorMessage(error);
    _updateAuthState(AuthenticationState.error);
    
    debugPrint('🐛 SessionManager error: $_lastError');
  }
  
  /// Format error message for user display
  String _formatErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return error.toString();
    }
  }
  
  /// Clear last error - equivalent to iOS error clearing
  void _clearError() {
    _lastError = null;
  }
  
  // MARK: - State Management Methods
  
  /// Update authentication state and notify listeners
  void _updateAuthState(AuthenticationState newState) {
    if (_authState != newState) {
      final oldState = _authState;
      _authState = newState;
      
      debugPrint('📊 Auth state changed: $oldState → $newState');
      
      // Notify all listeners (equivalent to iOS @Observable updates)
      notifyListeners();
    }
  }
  
  // MARK: - Cleanup Methods
  
  /// Dispose resources - Flutter lifecycle method
  @override
  void dispose() {
    debugPrint('🧹 SessionManager disposing');
    _authStateSubscription.cancel();
    super.dispose();
  }
  
  // MARK: - Debug Methods
  
  /// Returns comprehensive debug information about the current state.
  /// 
  /// Useful for troubleshooting authentication issues and state management.
  /// Contains authentication state, user information, and error details.
  Map<String, dynamic> get debugInfo => {
    'authState': _authState.toString(),
    'isAuthenticated': isAuthenticated,
    'isRegistered': isRegistered,
    'isLoading': isLoading,
    'hasProfile': _currentProfile != null,
    'hasSession': _currentSession != null,
    'userId': currentUser?.id,
    'userEmail': currentUser?.email,
    'profileName': _currentProfile?.displayName,
    'lastError': _lastError,
  };
}