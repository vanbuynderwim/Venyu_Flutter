import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'supabase_managers/media_manager.dart';
import 'supabase_managers/profile_manager.dart';
import 'tag_group_service.dart';
import 'revenuecat_service.dart';
import 'notification_service.dart';

/// Focused profile service handling user profile management.
/// 
/// This service replaces part of SessionManager's responsibilities,
/// focusing only on profile data and registration state.
/// It listens selectively to auth state changes and manages profile data.
class ProfileService extends ChangeNotifier {
  static ProfileService? _instance;
  
  /// The global singleton instance with proper disposal tracking.
  static ProfileService get shared {
    _instance ??= ProfileService._internal();
    return _instance!;
  }
  
  /// Factory constructor supporting dependency injection.
  factory ProfileService({
    ProfileManager? profileManager,
    MediaManager? mediaManager,
    AuthService? authService,
  }) {
    if (profileManager != null || mediaManager != null || authService != null) {
      return ProfileService._internal(
        profileManager: profileManager,
        mediaManager: mediaManager,
        authService: authService,
      );
    }
    return shared;
  }
  
  /// Private constructor with proper initialization.
  ProfileService._internal({
    ProfileManager? profileManager,
    MediaManager? mediaManager,
    AuthService? authService,
  }) : _profileManager = profileManager ?? ProfileManager.shared,
       _mediaManager = mediaManager ?? MediaManager.shared,
       _authService = authService ?? AuthService.shared {
    _initialize();
  }
  
  // MARK: - Private Properties
  
  final ProfileManager _profileManager;
  final MediaManager _mediaManager;
  final AuthService _authService;
  
  // MARK: - Observable Properties
  
  Profile? _currentProfile;
  bool _isLoading = false;
  bool _disposed = false;
  
  // MARK: - Public Getters
  
  /// The current user's profile data, if available.
  Profile? get currentProfile => _currentProfile;
  
  /// Whether the user has completed the registration process.
  bool get isRegistered => _currentProfile?.registeredAt != null;

  /// Whether the user has redeemed an invite code.
  bool get isRedeemed => _currentProfile?.redeemedAt != null;
  
  /// Whether a profile operation is currently in progress.
  bool get isLoading => _isLoading;
  
  /// Whether this service has been disposed.
  bool get disposed => _disposed;
  
  // MARK: - Initialization
  
  void _initialize() {
    if (_disposed) return;
    
    AppLogger.info('ProfileService initializing...', context: 'ProfileService');
    
    // Listen to auth state changes selectively
    _authService.addListener(_onAuthStateChanged);
    
    // If already authenticated, fetch profile
    if (_authService.isAuthenticated) {
      _fetchProfileIfNeeded();
    }
    
    AppLogger.success('ProfileService initialized', context: 'ProfileService');
  }
  
  void _onAuthStateChanged() {
    if (_disposed) return;
    
    final authState = _authService.authState;
    AppLogger.debug('Auth state changed to: $authState', context: 'ProfileService');
    
    switch (authState) {
      case AuthenticationState.authenticated:
        _fetchProfileIfNeeded();
        break;
      case AuthenticationState.unauthenticated:
      case AuthenticationState.error:
        _clearProfile();
        break;
      default:
        break;
    }
  }
  
  void _fetchProfileIfNeeded() {
    if (_disposed || _isLoading) return;

    // Fetch profile in background
    _fetchUserProfile().then((_) {
      // Update auth service about registration state
      if (_currentProfile?.registeredAt != null) {
        _authService.updateAuthState(AuthenticationState.registered);
      }

      // Initialize TagGroup cache after profile is loaded
      _initializeTagGroups();

      // Register pending notification token if exists
      NotificationService.shared.registerPendingToken();

      // Refresh location at startup (cached or background)
      // This happens silently in the background and doesn't block the UI
      _profileManager.refreshLocationAtStartup();
    }).catchError((error) {
      AppLogger.error('Failed to fetch profile: $error', context: 'ProfileService');
    });
  }
  
  // MARK: - Profile Management
  
  /// Fetch user profile from database.
  Future<void> _fetchUserProfile() async {
    if (_disposed) return;
    
    _setLoading(true);
    
    try {
      AppLogger.info('Fetching user profile', context: 'ProfileService');
      
      final fetchedProfile = await _profileManager.fetchUserProfile();
      
      if (!_disposed) {
        _currentProfile = fetchedProfile;

        // Set Sentry user context
        if (_currentProfile?.id != null) {
          Sentry.configureScope((scope) {
            scope.setUser(SentryUser(id: _currentProfile!.id));
          });
          AppLogger.debug('Sentry user context set with profile_id: ${_currentProfile!.id}', context: 'ProfileService');
        }

        notifyListeners();

        AppLogger.success('Profile loaded: ${_currentProfile?.displayName}', context: 'ProfileService');
      }
      
    } catch (error) {
      AppLogger.error('Failed to fetch profile: $error', context: 'ProfileService');
      rethrow;
    } finally {
      if (!_disposed) {
        _setLoading(false);
      }
    }
  }
  
  /// Refresh the current user profile from the database.
  Future<void> refreshProfile() async {
    if (_disposed) throw StateError('ProfileService has been disposed');
    
    try {
      AppLogger.debug('Refreshing profile...', context: 'ProfileService');
      
      if (!_authService.isAuthenticated) {
        AppLogger.warning('No session available for profile refresh', context: 'ProfileService');
        return;
      }
      
      await _fetchUserProfile();
      
      // Check RevenueCat for subscription status as fallback
      // This handles cases where webhook hasn't updated database yet
      if (AppConfig.showPro && _currentProfile != null && !(_currentProfile!.isPro)) {
        AppLogger.debug('Checking RevenueCat for subscription status...', context: 'ProfileService');
        
        try {
          final revenueCatService = RevenueCatService();
          final customerInfo = await revenueCatService.getCustomerInfo();
          
          if (revenueCatService.hasActiveSubscription(customerInfo)) {
            AppLogger.info('RevenueCat shows active subscription, updating profile isPro status', context: 'ProfileService');
            
            // Update local profile with Pro status
            _currentProfile = _currentProfile!.copyWith(isPro: true);
            notifyListeners();
            
            AppLogger.info('Profile isPro status updated locally from RevenueCat', context: 'ProfileService');
          } else {
            AppLogger.debug('No active subscription found in RevenueCat', context: 'ProfileService');
          }
        } catch (rcError) {
          AppLogger.warning('Failed to check RevenueCat subscription status: $rcError', context: 'ProfileService');
          // Continue anyway - database value will be used
        }
      }
      
      // Update auth service about registration state
      if (_currentProfile?.registeredAt != null) {
        _authService.updateAuthState(AuthenticationState.registered);
      }
      
      AppLogger.success('Profile refreshed successfully', context: 'ProfileService');
    } catch (error) {
      AppLogger.error('Error refreshing profile: $error', context: 'ProfileService');
      rethrow;
    }
  }
  
  /// Updates the current profile with new data.
  void updateCurrentProfile(Profile updatedProfile) {
    if (_disposed) return;
    
    AppLogger.debug('Updating current profile', context: 'ProfileService');
    _currentProfile = updatedProfile;
    
    notifyListeners();
    
    // Update auth service about registration state
    if (_currentProfile?.registeredAt != null) {
      _authService.updateAuthState(AuthenticationState.registered);
    }
    
    AppLogger.success('Profile updated: ${_currentProfile?.displayName}', context: 'ProfileService');
  }

  /// Updates specific fields of the current profile.
  void updateCurrentProfileFields({
    String? firstName,
    String? lastName,
    String? companyName,
    String? city,
    String? bio,
    String? linkedInURL,
    String? websiteURL,
    String? contactEmail,
    bool? showEmail,
    String? avatarID,
    DateTime? timestamp,
    DateTime? registeredAt,
    DateTime? redeemedAt,
    double? distance,
    bool? isSuperAdmin,
    bool? newsletterSubscribed,
    String? publicKey,
    String? languageCode,
    List<TagGroup>? taggroups,
    bool? autoIntroduction,
    int? matchRadius,
  }) {
    if (_disposed) return;

    if (_currentProfile == null) {
      AppLogger.warning('Cannot update profile fields - no current profile', context: 'ProfileService');
      return;
    }

    AppLogger.debug('Updating profile fields', context: 'ProfileService');

    _currentProfile = _currentProfile!.copyWith(
      firstName: firstName,
      lastName: lastName,
      companyName: companyName,
      city: city,
      bio: bio,
      linkedInURL: linkedInURL,
      websiteURL: websiteURL,
      contactEmail: contactEmail,
      showEmail: showEmail,
      avatarID: avatarID,
      timestamp: timestamp,
      registeredAt: registeredAt,
      redeemedAt: redeemedAt,
      distance: distance,
      isSuperAdmin: isSuperAdmin,
      newsletterSubscribed: newsletterSubscribed,
      publicKey: publicKey,
      languageCode: languageCode,
      taggroups: taggroups,
      autoIntroduction: autoIntroduction,
      matchRadius: matchRadius,
    );
    
    notifyListeners();
    
    // Update auth service about registration state
    if (registeredAt != null) {
      _authService.updateAuthState(AuthenticationState.registered);
    }
    
    AppLogger.success('Profile fields updated: ${_currentProfile?.displayName}', context: 'ProfileService');
  }
  
  /// Check if a profile is complete enough to be considered "registered"
  /// 
  /// A complete profile should have:
  /// - Basic info (firstName, contactEmail) 
  /// - registeredAt timestamp (indicates completed onboarding)
  bool isProfileComplete(Profile? profile) {
    if (profile == null) return false;
    
    final hasBasicInfo = profile.firstName.isNotEmpty && 
                        profile.contactEmail != null && profile.contactEmail!.isNotEmpty;
    final hasCompletedOnboarding = profile.registeredAt != null;
    
    AppLogger.debug('Profile completeness check:', context: 'ProfileService');
    AppLogger.debug('    - firstName: "${profile.firstName}" (${profile.firstName.isNotEmpty ? "✓" : "✗"})', context: 'ProfileService');
    AppLogger.debug('    - contactEmail: "${profile.contactEmail}" (${profile.contactEmail != null && profile.contactEmail!.isNotEmpty ? "✓" : "✗"})', context: 'ProfileService');
    AppLogger.debug('    - registeredAt: ${profile.registeredAt} (${hasCompletedOnboarding ? "✓" : "✗"})', context: 'ProfileService');
    AppLogger.debug('    - Has basic info: $hasBasicInfo', context: 'ProfileService');
    AppLogger.debug('    - Has completed onboarding: $hasCompletedOnboarding', context: 'ProfileService');
    AppLogger.debug('    - Overall complete: ${hasBasicInfo && hasCompletedOnboarding}', context: 'ProfileService');
    
    return hasBasicInfo && hasCompletedOnboarding;
  }
  
  /// Clear the current profile data (public method for SessionManager)
  void clearProfile() {
    _clearProfile();
  }
  
  void _clearProfile() {
    if (_disposed) return;

    if (_currentProfile != null) {
      AppLogger.debug('Clearing profile data', context: 'ProfileService');
      _currentProfile = null;

      // Clear Sentry user context
      Sentry.configureScope((scope) {
        scope.setUser(null);
      });
      AppLogger.debug('Sentry user context cleared', context: 'ProfileService');

      notifyListeners();
    }
  }
  
  // MARK: - Avatar Management
  
  /// Uploads and sets a new user profile avatar.
  Future<void> uploadUserProfileAvatar(Uint8List imageData) async {
    if (_disposed) throw StateError('ProfileService has been disposed');
    
    try {
      AppLogger.info('Starting avatar upload', context: 'ProfileService');
      
      // Delete old avatar if exists
      if (_currentProfile?.avatarID != null) {
        await _mediaManager.deleteUserProfileAvatar(
          avatarID: _currentProfile!.avatarID!,
        );
      }
      
      // Upload new avatar and get the new avatar ID
      final newAvatarID = await _mediaManager.uploadUserProfileAvatar(imageData);
      
      // Update database profile record
      await _profileManager.updateProfileAvatar(avatarID: newAvatarID);
      
      // Update local profile
      updateCurrentProfileFields(avatarID: newAvatarID);
      
      AppLogger.success('Avatar upload completed successfully', context: 'ProfileService');
      
    } catch (error) {
      AppLogger.error('Failed to upload avatar: $error', context: 'ProfileService');
      rethrow;
    }
  }

  /// Deletes the user's current profile avatar.
  Future<void> deleteProfileAvatar({bool isFullDelete = true}) async {
    if (_disposed) throw StateError('ProfileService has been disposed');
    
    final avatarID = _currentProfile?.avatarID;
    if (avatarID == null) {
      AppLogger.warning('No avatar to delete', context: 'ProfileService');
      return;
    }
    
    try {
      AppLogger.info('Deleting avatar: $avatarID', context: 'ProfileService');
      
      // Delete avatar via MediaManager
      await _mediaManager.deleteUserProfileAvatar(
        avatarID: avatarID,
      );
      
      if (isFullDelete) {
        // Update database profile record
        await _profileManager.updateProfileAvatar(avatarID: null);
        
        // Update local profile
        updateCurrentProfileFields(avatarID: null);
        AppLogger.success('Avatar deleted completely', context: 'ProfileService');
      }
      
    } catch (error) {
      AppLogger.error('Failed to delete avatar: $error', context: 'ProfileService');
      
      if (isFullDelete) {
        rethrow;
      }
    }
  }
  
  // MARK: - Invite Code Management

  /// Mark an invite code as sent
  Future<void> markInviteCodeAsSent(String codeId) async {
    if (_disposed) throw StateError('ProfileService has been disposed');

    try {
      AppLogger.info('Marking invite code as sent: $codeId', context: 'ProfileService');

      await _profileManager.markInviteCodeAsSent(codeId);

      AppLogger.success('Invite code marked as sent', context: 'ProfileService');
    } catch (error) {
      AppLogger.error('Failed to mark invite code as sent', error: error, context: 'ProfileService');
      rethrow;
    }
  }

  /// Issue new invite codes for the current user
  Future<void> issueProfileInviteCodes({int count = 1}) async {
    if (_disposed) throw StateError('ProfileService has been disposed');

    try {
      AppLogger.info('Issuing $count invite codes', context: 'ProfileService');

      await _profileManager.issueProfileInviteCodes(count: count);

      AppLogger.success('Successfully issued $count invite codes', context: 'ProfileService');
    } catch (error) {
      AppLogger.error('Failed to issue invite codes', error: error, context: 'ProfileService');
      rethrow;
    }
  }

  // MARK: - Helper Methods

  void _setLoading(bool loading) {
    if (_disposed) return;
    
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  
  /// Initialize TagGroup cache for registration wizard.
  void _initializeTagGroups() {
    if (_disposed) return;
    
    TagGroupService.shared.loadTagGroups().then((tagGroups) {
      AppLogger.success('TagGroups cache initialized with ${tagGroups.length} groups', context: 'ProfileService');
    }).catchError((error) {
      AppLogger.warning('Failed to initialize TagGroups cache: $error', context: 'ProfileService');
    });
  }
  
  // MARK: - Cleanup
  
  /// Dispose resources with proper cleanup.
  @override
  void dispose() {
    if (_disposed) return;
    
    AppLogger.info('ProfileService disposing', context: 'ProfileService');
    
    _disposed = true;
    _authService.removeListener(_onAuthStateChanged);
    
    super.dispose();
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!._disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}