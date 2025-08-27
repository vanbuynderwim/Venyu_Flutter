import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/app_logger.dart';
import '../models/models.dart';
import 'supabase_manager.dart';
import 'supabase_managers/authentication_manager.dart';
import 'supabase_managers/media_manager.dart';
import 'supabase_managers/profile_manager.dart';
import 'tag_group_service.dart';

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
    AppLogger.debug('SessionManager.shared accessed - instance ${_instance.hashCode}', context: 'SessionManager');
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
    // Initialize managers
    _authenticationManager = AuthenticationManager.shared;
    _mediaManager = MediaManager.shared;
    _profileManager = ProfileManager.shared;
    // Initialize immediately since SupabaseManager should be ready when SessionManager is created
    _initialize();
  }
  
  // MARK: - Private Properties
  
  final SupabaseManager _supabaseManager;
  late final AuthenticationManager _authenticationManager;
  late final MediaManager _mediaManager;
  late final ProfileManager _profileManager;
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
    AppLogger.info('SessionManager initializing...', context: 'SessionManager');
    
    // Ensure SupabaseManager is initialized before proceeding
    if (!_supabaseManager.isInitialized) {
      AppLogger.warning('SupabaseManager not yet initialized, SessionManager will wait', context: 'SessionManager');
      // In a real scenario, this should be handled by proper initialization order in main.dart
      return;
    }
    
    // Set initial session from Supabase
    _currentSession = _supabaseManager.currentSession;
    
    // Listen to Supabase auth state changes (equivalent to iOS setupAuthStateChange)
    _setupAuthStateListener();
    
    // Perform initial session check
    _performInitialSessionCheck();
    
    AppLogger.success('SessionManager initialized', context: 'SessionManager');
  }
  
  /// Setup auth state listener - equivalent to iOS setupAuthStateChange
  void _setupAuthStateListener() {
    AppLogger.debug('Setting up auth state listener', context: 'SessionManager');
    
    _authStateSubscription = _supabaseManager.client.auth.onAuthStateChange.listen(
      (AuthState authState) async {
        AppLogger.debug('Auth state changed: ${authState.event}', context: 'SessionManager');
        
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
            // Handle password recovery if needed
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            // Handle MFA challenge verification - treat as sign in success
            await _handleSignedIn(authState.session);
            break;
          default:
            break;
        }
      },
      onError: (error) {
        AppLogger.error('Auth state listener error: $error', context: 'SessionManager');
        _handleAuthError(error);
      },
    );
  }
  
  /// Perform initial session check - equivalent to iOS checkAuthState
  void _performInitialSessionCheck() async {
    AppLogger.debug('Performing initial session check', context: 'SessionManager');
    
    try {
      final session = _supabaseManager.currentSession;
      
      if (session != null) {
        AppLogger.info('Existing session found, fetching profile', context: 'SessionManager');
        await _handleExistingSession(session);
      } else {
        AppLogger.info('No existing session found', context: 'SessionManager');
        _updateAuthState(AuthenticationState.unauthenticated);
      }
    } catch (error) {
      AppLogger.error('Initial session check error: $error', context: 'SessionManager');
      _handleAuthError(error);
    }
  }
  
  // MARK: - Authentication Event Handlers
  
  /// Handle initial session - equivalent to iOS initial session handling
  Future<void> _handleInitialSession(Session? session) async {
    AppLogger.info('Handling initial session', context: 'SessionManager');
    
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
      
      AppLogger.info('Fetching user profile for session', context: 'SessionManager');
      await _fetchUserProfile();
      
      // Initialize TagGroup cache for registration wizard
      _initializeTagGroups();
      
      // Determine authentication state based on profile
      _updateAuthState(_determineAuthenticationState());
      
    } catch (error) {
      AppLogger.error('Error handling existing session: $error', context: 'SessionManager');
      _handleAuthError(error);
    }
  }
  
  /// Handle successful sign in - equivalent to iOS sign in handling
  Future<void> _handleSignedIn(Session? session) async {
    AppLogger.success('User signed in (event)', context: 'SessionManager');
    
    if (session == null) {
      AppLogger.warning('Signed in event but no session - using current session', context: 'SessionManager');
      session = _supabaseManager.currentSession;
    }
    
    if (session == null) {
      AppLogger.error('No session available after sign in', context: 'SessionManager');
      _handleAuthError('No session available after sign in');
      return;
    }

    _currentSession = session;

    try {
      // Fetch user profile after successful sign in
      AppLogger.debug('Fetching profile after sign in...', context: 'SessionManager');
      await _fetchUserProfile();
      
      // Initialize TagGroup cache for registration wizard
      _initializeTagGroups();
      
      // Determine state based on profile completion
      final newState = _determineAuthenticationState();
      AppLogger.info('After sign in, determined state: $newState', context: 'SessionManager');
      _updateAuthState(newState);
      
      AppLogger.success('Sign in process completed successfully', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('Error after sign in: $error', context: 'SessionManager');
      // Don't sign out - let user at least get to onboarding
      _updateAuthState(AuthenticationState.authenticated);
    }
  }
  
  /// Handle sign out - equivalent to iOS sign out handling
  Future<void> _handleSignedOut() async {
    AppLogger.info('User signed out - performing complete reset', context: 'SessionManager');
    
    // Perform complete reset to initial state
    await _performCompleteReset();
    
    AppLogger.success('Sign out cleanup completed - back to initial state', context: 'SessionManager');
  }
  
  /// Perform complete reset of SessionManager to initial state
  /// 
  /// This method resets all internal properties to their initial values,
  /// exactly as they would be when SessionManager is first created.
  Future<void> _performCompleteReset() async {
    AppLogger.debug('Performing complete SessionManager reset', context: 'SessionManager');
    
    // Clear all authentication-related data
    _currentSession = null;
    _currentProfile = null;
    _lastError = null;
    
    // Reset authentication state to initial loading state briefly, then unauthenticated
    _authState = AuthenticationState.loading;
    
    // Clear Bugsnag user context
    // Temporarily disabled for debugging
    // try {
    //   await bugsnag.setUser(id: null, email: null, name: null);
    //   debugPrint('✅ Bugsnag user context cleared');
    // } catch (error) {
    //   debugPrint('⚠️ Failed to clear Bugsnag user context: $error');
    // }
    
    // Set to unauthenticated state and notify listeners
    _updateAuthState(AuthenticationState.unauthenticated);
    
    AppLogger.success('Complete reset finished', context: 'SessionManager');
    AppLogger.info('Post-reset state:', context: 'SessionManager');
    AppLogger.info('  - authState: $_authState', context: 'SessionManager');
    AppLogger.info('  - currentSession: $_currentSession', context: 'SessionManager');
    AppLogger.info('  - currentProfile: $_currentProfile', context: 'SessionManager');
    AppLogger.info('  - lastError: $_lastError', context: 'SessionManager');
  }
  
  /// Initialize TagGroup cache for registration wizard.
  /// 
  /// This method loads all tag groups in the background after successful authentication.
  /// It does not block the authentication flow if it fails.
  void _initializeTagGroups() {
    TagGroupService.shared.loadTagGroups().then((tagGroups) {
      AppLogger.success('TagGroups cache initialized with ${tagGroups.length} groups', context: 'SessionManager');
    }).catchError((error) {
      AppLogger.warning('Failed to initialize TagGroups cache: $error', context: 'SessionManager');
      // Don't throw - this is a background optimization
    });
  }
  
  /// Handle token refresh - equivalent to iOS token refresh handling
  Future<void> _handleTokenRefreshed(Session? session) async {
    AppLogger.debug('Token refreshed', context: 'SessionManager');
    
    if (session != null) {
      _currentSession = session;
      // No need to change auth state - just update session
      notifyListeners();
    }
  }
  
  /// Handle user updated - equivalent to iOS user update handling
  Future<void> _handleUserUpdated(Session? session) async {
    AppLogger.info('User updated', context: 'SessionManager');
    
    if (session != null) {
      _currentSession = session;
      
      try {
        // Refetch profile to get updated information
        await _fetchUserProfile();
        _updateAuthState(_determineAuthenticationState());
      } catch (error) {
        AppLogger.error('Error updating user profile: $error', context: 'SessionManager');
      }
    }
  }
  
  
  // MARK: - Profile Management Methods

  /// Refresh the current user profile from the database
  /// 
  /// This method refetches the profile and updates the authentication state.
  /// Useful when profile data has been updated externally (like after registration completion).
  Future<void> refreshProfile() async {
    try {
      AppLogger.debug('Refreshing profile...', context: 'SessionManager');
      
      if (_currentSession == null) {
        AppLogger.warning('No session available for profile refresh', context: 'SessionManager');
        return;
      }
      
      await _fetchUserProfile();
      
      // Update auth state after profile refresh
      final newState = _determineAuthenticationState();
      AppLogger.info('After profile refresh, determined state: $newState', context: 'SessionManager');
      _updateAuthState(newState);
      
      AppLogger.success('Profile refreshed successfully', context: 'SessionManager');
    } catch (error) {
      AppLogger.error('Error refreshing profile: $error', context: 'SessionManager');
      rethrow;
    }
  }
  
  /// Fetch user profile from database - equivalent to iOS fetchCurrentProfile
  /// 
  /// This method exactly matches the iOS fetchCurrentProfile implementation:
  /// 1. Calls SupabaseManager.fetchUserProfile() (which uses RPC call)
  /// 2. Updates currentProfile and authentication state
  /// 3. Handles errors by signing out (matching iOS behavior)
  Future<void> _fetchUserProfile() async {
    try {
      AppLogger.info('SessionManager: Fetching current profile', context: 'SessionManager');
      
      // Use ProfileManager.fetchUserProfile() - exact equivalent of iOS call
      final fetchedProfile = await _profileManager.fetchUserProfile();
      
      // Update current profile and authentication state - equivalent to iOS MainActor.run
      _currentProfile = fetchedProfile;
      
      // Update authentication state based on profile completion
      final newAuthState = _determineAuthenticationState();
      AppLogger.debug('About to update auth state to: $newAuthState', context: 'SessionManager');
      _updateAuthState(newAuthState);
      
      AppLogger.success('fetchCurrentProfile successful', context: 'SessionManager');
      AppLogger.info('Profile loaded: ${_currentProfile?.displayName} (${_currentProfile?.contactEmail})', context: 'SessionManager');
      
      // Set user context in Bugsnag for error tracking
      // Temporarily disabled for debugging
      // if (_currentProfile != null && currentUser != null) {
      //   await bugsnag.setUser(
      //     id: currentUser!.id,
      //     email: _currentProfile!.contactEmail,
      //     name: _currentProfile!.displayName,
      //   );
      //   debugPrint('✅ Bugsnag user context set');
      // }
      
    } catch (error) {
      AppLogger.error('Failed to fetch profile: $error', context: 'SessionManager');
      
      // Don't sign out automatically - laat de user minstens naar onboarding gaan
      AppLogger.warning('Profile fetch failed, but keeping session active for recovery', context: 'SessionManager');
      
      rethrow;
    }
  }
  
  /// Determine authentication state based on session and profile
  AuthenticationState _determineAuthenticationState() {
    AppLogger.debug('Determining auth state:', context: 'SessionManager');
    AppLogger.debug('  - Session: ${_currentSession != null}', context: 'SessionManager');
    AppLogger.debug('  - Profile: ${_currentProfile != null}', context: 'SessionManager');
    AppLogger.debug('  - RegisteredAt: ${_currentProfile?.registeredAt}', context: 'SessionManager');
    
    if (_currentSession == null) {
      AppLogger.debug('  → Unauthenticated (no session)', context: 'SessionManager');
      return AuthenticationState.unauthenticated;
    }
    
    if (_currentProfile == null) {
      AppLogger.debug('  → Authenticated (session but no profile)', context: 'SessionManager');
      return AuthenticationState.authenticated;
    }
    
    // Check if profile is actually complete (has essential registration data)
    if (!_isProfileComplete(_currentProfile!)) {
      AppLogger.debug('  → Authenticated (session but incomplete profile)', context: 'SessionManager');
      return AuthenticationState.authenticated;
    }
    
    AppLogger.debug('  → Registered (session + complete profile)', context: 'SessionManager');
    return AuthenticationState.registered;
  }
  
  /// Check if a profile is complete enough to be considered "registered"
  /// 
  /// A complete profile should have:
  /// - Basic info (firstName, contactEmail) 
  /// - registeredAt timestamp (indicates completed onboarding)
  bool _isProfileComplete(Profile profile) {
    final hasBasicInfo = profile.firstName.isNotEmpty && 
                        profile.contactEmail != null && profile.contactEmail!.isNotEmpty;
    final hasCompletedOnboarding = profile.registeredAt != null;
    
    AppLogger.debug('Profile completeness check:', context: 'SessionManager');
    AppLogger.debug('    - firstName: "${profile.firstName}" (${profile.firstName.isNotEmpty ? "✓" : "✗"})', context: 'SessionManager');
    AppLogger.debug('    - contactEmail: "${profile.contactEmail}" (${profile.contactEmail != null && profile.contactEmail!.isNotEmpty ? "✓" : "✗"})', context: 'SessionManager');
    AppLogger.debug('    - registeredAt: ${profile.registeredAt} (${hasCompletedOnboarding ? "✓" : "✗"})', context: 'SessionManager');
    AppLogger.debug('    - Has basic info: $hasBasicInfo', context: 'SessionManager');
    AppLogger.debug('    - Has completed onboarding: $hasCompletedOnboarding', context: 'SessionManager');
    AppLogger.debug('    - Overall complete: ${hasBasicInfo && hasCompletedOnboarding}', context: 'SessionManager');
    
    return hasBasicInfo && hasCompletedOnboarding;
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
      AppLogger.info('SessionManager: Starting Apple sign in', context: 'SessionManager');
      _clearError();
      
      await _authenticationManager.signInWithApple();
      
      // Auth state will be updated via the auth state listener
      AppLogger.success('SessionManager: Apple sign in initiated', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('SessionManager: Apple sign in error: $error', context: 'SessionManager');
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
      AppLogger.info('SessionManager: Starting LinkedIn sign in', context: 'SessionManager');
      _clearError();
      
      await _authenticationManager.signInWithLinkedIn();
      
      // Auth state will be updated via the auth state listener
      AppLogger.success('SessionManager: LinkedIn sign in initiated', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('SessionManager: LinkedIn sign in error: $error', context: 'SessionManager');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Initiates Google OAuth authentication flow.
  /// 
  /// This method:
  /// 1. Clears any previous errors
  /// 2. Delegates to [SupabaseManager.signInWithGoogle]
  /// 3. Updates authentication state via the auth state listener
  /// 
  /// Note: Google authentication uses native sign-in flow.
  /// Throws authentication exceptions if the sign in process fails.
  Future<void> signInWithGoogle() async {
    try {
      AppLogger.info('SessionManager: Starting Google sign in', context: 'SessionManager');
      _clearError();
      
      await _authenticationManager.signInWithGoogle();
      
      // Auth state will be updated via the auth state listener
      AppLogger.success('SessionManager: Google sign in completed', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('SessionManager: Google sign in error: $error', context: 'SessionManager');
      _handleAuthError(error);
      rethrow;
    }
  }
  
  /// Updates the current profile with new data.
  /// 
  /// This method should be called after successfully updating profile data
  /// to keep the SessionManager in sync with the database.
  void updateCurrentProfile(Profile updatedProfile) {
    AppLogger.debug('SessionManager: Updating current profile', context: 'SessionManager');
    _currentProfile = updatedProfile;
    
    // Notify listeners about the profile update
    notifyListeners();
    
    AppLogger.success('Profile updated: ${_currentProfile?.displayName}', context: 'SessionManager');
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
    List<TagGroup>? taggroups,
  }) {
    if (_currentProfile == null) {
      AppLogger.warning('SessionManager: Cannot update profile fields - no current profile', context: 'SessionManager');
      return;
    }

    AppLogger.debug('SessionManager: Updating profile fields', context: 'SessionManager');
    
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
      taggroups: taggroups,
    );
    
    // Notify listeners about the profile update
    notifyListeners();
    
    AppLogger.success('Profile fields updated: ${_currentProfile?.displayName}', context: 'SessionManager');
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
      AppLogger.info('SessionManager: Starting sign out', context: 'SessionManager');
      _clearError();
      
      await _authenticationManager.signOut();
      
      // Auth state will be updated via the auth state listener
      AppLogger.success('SessionManager: Sign out completed', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('SessionManager: Sign out error: $error', context: 'SessionManager');
      _handleAuthError(error);
      rethrow;
    }
  }

  
  // MARK: - Error Handling Methods
  
  /// Handle authentication error - equivalent to iOS error handling
  void _handleAuthError(dynamic error) {
    _lastError = _formatErrorMessage(error);
    _updateAuthState(AuthenticationState.error);
    
    AppLogger.error('SessionManager error: $_lastError', context: 'SessionManager');
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
      
      AppLogger.info('Auth state changed: $oldState → $newState', context: 'SessionManager');
      
      // Notify all listeners (equivalent to iOS @Observable updates)
      notifyListeners();
      
      AppLogger.debug('notifyListeners() called - UI should update now', context: 'SessionManager');
    } else {
      AppLogger.warning('Auth state update ignored - already in state: $newState', context: 'SessionManager');
    }
  }
  
  // MARK: - Cleanup Methods
  
  /// Dispose resources - Flutter lifecycle method
  @override
  void dispose() {
    AppLogger.info('SessionManager disposing', context: 'SessionManager');
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

  // MARK: - Avatar Management Methods

  /// Uploads and sets a new user profile avatar.
  /// 
  /// This method coordinates between SupabaseManager and local profile updates.
  /// SessionManager handles the orchestration while SupabaseManager does the heavy lifting.
  Future<void> uploadUserProfileAvatar(Uint8List imageData) async {
    try {
      AppLogger.info('SessionManager: Starting avatar upload', context: 'SessionManager');
      
      // Delete old avatar if exists
      if (_currentProfile?.avatarID != null) {
        await _mediaManager.deleteUserProfileAvatar(
          avatarID: _currentProfile!.avatarID!,
        );
      }
      
      // Upload new avatar and get the new avatar ID
      final newAvatarID = await _mediaManager.uploadUserProfileAvatar(imageData);
      
      // Update local profile
      updateCurrentProfileFields(avatarID: newAvatarID);
      
      AppLogger.success('SessionManager: Avatar upload completed successfully', context: 'SessionManager');
      
    } catch (error) {
      AppLogger.error('SessionManager: Failed to upload avatar: $error', context: 'SessionManager');
      rethrow;
    }
  }

  /// Deletes the user's current profile avatar.
  /// 
  /// This method coordinates between SupabaseManager and local profile updates.
  Future<void> deleteProfileAvatar({bool isFullDelete = true}) async {
    final avatarID = _currentProfile?.avatarID;
    if (avatarID == null) {
      AppLogger.warning('No avatar to delete', context: 'SessionManager');
      return;
    }
    
    try {
      AppLogger.info('SessionManager: Deleting avatar: $avatarID', context: 'SessionManager');
      
      // Delete avatar via MediaManager
      await _mediaManager.deleteUserProfileAvatar(
        avatarID: avatarID,
      );
      
      if (isFullDelete) {
        // Update local profile
        updateCurrentProfileFields(avatarID: null);
        AppLogger.success('SessionManager: Avatar deleted completely', context: 'SessionManager');
      }
      
    } catch (error) {
      AppLogger.error('SessionManager: Failed to delete avatar: $error', context: 'SessionManager');
      
      if (isFullDelete) {
        rethrow;
      }
      // For non-full deletes, we continue with the upload process
    }
  }
}