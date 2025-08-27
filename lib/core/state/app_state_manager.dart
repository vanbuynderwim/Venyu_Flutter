import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/app_logger.dart';
import '../../services/auth_service.dart' as auth_svc;
import '../../services/profile_service.dart';
import 'app_state_notifier.dart';

/// Global app state manager that coordinates between services and state notifiers.
/// 
/// This class provides a single source of truth for app state while maintaining
/// fine-grained control over rebuilds through separate state notifiers.
class AppStateManager {
  static AppStateManager? _instance;
  
  /// The global singleton instance.
  static AppStateManager get shared {
    _instance ??= AppStateManager._internal();
    return _instance!;
  }
  
  /// Private constructor.
  AppStateManager._internal() {
    _initialize();
  }
  
  // MARK: - Private Properties
  
  late final auth_svc.AuthService _authService;
  late final ProfileService _profileService;
  
  late final AuthStateNotifier _authStateNotifier;
  late final ProfileStateNotifier _profileStateNotifier;
  
  StreamSubscription? _authSubscription;
  StreamSubscription? _profileSubscription;
  bool _disposed = false;
  
  // MARK: - Public Getters
  
  /// Auth state notifier for selective listening.
  AuthStateNotifier get authStateNotifier => _authStateNotifier;
  
  /// Profile state notifier for selective listening.
  ProfileStateNotifier get profileStateNotifier => _profileStateNotifier;
  
  /// Whether this manager has been disposed.
  bool get disposed => _disposed;
  
  // MARK: - Initialization
  
  void _initialize() {
    if (_disposed) return;
    
    AppLogger.info('AppStateManager initializing...', context: 'AppStateManager');
    
    // Initialize services
    _authService = auth_svc.AuthService.shared;
    _profileService = ProfileService.shared;
    
    // Initialize state notifiers
    _authStateNotifier = AuthStateNotifier();
    _profileStateNotifier = ProfileStateNotifier();
    
    // Setup listeners
    _setupAuthListener();
    _setupProfileListener();
    
    // Sync initial states
    _syncAuthState();
    _syncProfileState();
    
    AppLogger.success('AppStateManager initialized', context: 'AppStateManager');
  }
  
  void _setupAuthListener() {
    _authSubscription?.cancel();
    _authSubscription = null;
    
    _authService.addListener(_onAuthServiceChanged);
  }
  
  void _setupProfileListener() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    
    _profileService.addListener(_onProfileServiceChanged);
  }
  
  void _onAuthServiceChanged() {
    if (_disposed) return;
    _syncAuthState();
  }
  
  void _onProfileServiceChanged() {
    if (_disposed) return;
    _syncProfileState();
  }
  
  void _syncAuthState() {
    if (_disposed) return;
    
    final newState = AuthStateData(
      authState: _convertAuthState(_authService.authState),
      session: _authService.currentSession,
      lastError: _authService.lastError,
    );
    
    _authStateNotifier.updateState(newState);
  }
  
  void _syncProfileState() {
    if (_disposed) return;
    
    final newState = ProfileStateData(
      profile: _profileService.currentProfile,
      isLoading: _profileService.isLoading,
    );
    
    _profileStateNotifier.updateState(newState);
  }
  
  /// Convert AuthService AuthenticationState to local AuthenticationState.
  AuthenticationState _convertAuthState(dynamic serviceAuthState) {
    // Handle the case where we're converting from services/auth_service.dart
    final stateString = serviceAuthState.toString();
    
    if (stateString.contains('loading')) return AuthenticationState.loading;
    if (stateString.contains('unauthenticated')) return AuthenticationState.unauthenticated;
    if (stateString.contains('authenticated')) return AuthenticationState.authenticated;
    if (stateString.contains('registered')) return AuthenticationState.registered;
    if (stateString.contains('error')) return AuthenticationState.error;
    
    // Default fallback
    return AuthenticationState.loading;
  }
  
  // MARK: - Public Methods
  
  /// Force sync all states from services.
  void syncStates() {
    if (_disposed) {
      AppLogger.warning('Cannot sync states - AppStateManager disposed', context: 'AppStateManager');
      return;
    }
    
    AppLogger.debug('Forcing state sync', context: 'AppStateManager');
    _syncAuthState();
    _syncProfileState();
  }
  
  /// Get combined app state for navigation decisions.
  AuthenticationState get combinedAppState {
    if (_disposed) return AuthenticationState.error;
    
    final authState = _authStateNotifier.state.authState;
    final profileState = _profileStateNotifier.state;
    
    // If auth is not authenticated, return that state
    if (authState == AuthenticationState.unauthenticated ||
        authState == AuthenticationState.loading ||
        authState == AuthenticationState.error) {
      return authState;
    }
    
    // If authenticated, check profile registration
    if (authState == AuthenticationState.authenticated) {
      if (profileState.isRegistered) {
        return AuthenticationState.registered;
      } else {
        return AuthenticationState.authenticated;
      }
    }
    
    return authState;
  }
  
  // MARK: - Cleanup
  
  /// Dispose this manager and clean up resources.
  void dispose() {
    if (_disposed) return;
    
    AppLogger.info('AppStateManager disposing', context: 'AppStateManager');
    
    _disposed = true;
    
    // Remove listeners
    _authService.removeListener(_onAuthServiceChanged);
    _profileService.removeListener(_onProfileServiceChanged);
    
    // Cancel subscriptions
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    
    // Dispose state notifiers
    _authStateNotifier.dispose();
    _profileStateNotifier.dispose();
    
    AppLogger.success('AppStateManager disposed', context: 'AppStateManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!._disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}

/// Extension for easy access to state notifiers from context.
extension AppStateManagerContext on BuildContext {
  /// Get auth state notifier.
  AuthStateNotifier get authStateNotifier => AppStateManager.shared.authStateNotifier;
  
  /// Get profile state notifier.
  ProfileStateNotifier get profileStateNotifier => AppStateManager.shared.profileStateNotifier;
  
  /// Get combined app state.
  AuthenticationState get combinedAppState => AppStateManager.shared.combinedAppState;
}