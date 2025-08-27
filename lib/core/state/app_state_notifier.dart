import 'package:flutter/foundation.dart';

import '../../core/utils/app_logger.dart';

/// Base class for state notifiers with granular change detection.
/// 
/// This provides a lightweight StateNotifier-like pattern using ChangeNotifier
/// that allows for selective rebuilds based on specific state changes.
abstract class AppStateNotifier<T> extends ChangeNotifier {
  T _state;
  bool _disposed = false;
  
  AppStateNotifier(this._state);
  
  /// The current state value.
  T get state => _state;
  
  /// Whether this notifier has been disposed.
  bool get disposed => _disposed;
  
  /// Updates the state and optionally notifies listeners.
  /// 
  /// Only notifies if the new state is different from the current state.
  /// Returns true if the state was actually changed.
  bool updateState(T newState, {bool force = false}) {
    if (_disposed) {
      AppLogger.warning('Attempted to update disposed state notifier', 
        context: runtimeType.toString());
      return false;
    }
    
    if (!force && _state == newState) {
      return false; // No change, don't notify
    }
    
    final oldState = _state;
    _state = newState;
    
    AppLogger.debug('State updated: $oldState → $newState', 
      context: runtimeType.toString());
    
    notifyListeners();
    return true;
  }
  
  /// Updates state using a function that receives the current state.
  bool updateStateWith(T Function(T currentState) updater, {bool force = false}) {
    final newState = updater(_state);
    return updateState(newState, force: force);
  }
  
  @override
  void dispose() {
    if (_disposed) return;
    
    AppLogger.info('${runtimeType.toString()} disposing', 
      context: runtimeType.toString());
    
    _disposed = true;
    super.dispose();
  }
}

/// State notifier for authentication state with selective change detection.
class AuthStateNotifier extends AppStateNotifier<AuthStateData> {
  AuthStateNotifier() : super(AuthStateData.initial());
  
  /// Update only the authentication state.
  void updateAuthState(AuthenticationState newAuthState) {
    updateStateWith((current) => current.copyWith(authState: newAuthState));
  }
  
  /// Update only the session.
  void updateSession(dynamic newSession) {
    updateStateWith((current) => current.copyWith(session: newSession));
  }
  
  /// Update only the error state.
  void updateError(String? newError) {
    updateStateWith((current) => current.copyWith(lastError: newError));
  }
  
  /// Clear error state.
  void clearError() {
    if (state.lastError != null) {
      updateError(null);
    }
  }
  
  /// Reset to initial state.
  void reset() {
    updateState(AuthStateData.initial(), force: true);
  }
}

/// State notifier for profile data with selective change detection.
class ProfileStateNotifier extends AppStateNotifier<ProfileStateData> {
  ProfileStateNotifier() : super(ProfileStateData.initial());
  
  /// Update only the profile data.
  void updateProfile(dynamic newProfile) {
    updateStateWith((current) => current.copyWith(profile: newProfile));
  }
  
  /// Update only the loading state.
  void updateLoading(bool isLoading) {
    updateStateWith((current) => current.copyWith(isLoading: isLoading));
  }
  
  /// Clear profile data.
  void clearProfile() {
    if (state.profile != null) {
      updateProfile(null);
    }
  }
  
  /// Reset to initial state.
  void reset() {
    updateState(ProfileStateData.initial(), force: true);
  }
}

/// Authentication state enum (reused from existing services).
enum AuthenticationState {
  loading,
  unauthenticated,
  authenticated,
  registered,
  error
}

/// Immutable data class for authentication state.
class AuthStateData {
  final AuthenticationState authState;
  final dynamic session;
  final String? lastError;
  
  const AuthStateData({
    required this.authState,
    this.session,
    this.lastError,
  });
  
  factory AuthStateData.initial() => const AuthStateData(
    authState: AuthenticationState.loading,
  );
  
  /// Creates a copy with updated fields.
  AuthStateData copyWith({
    AuthenticationState? authState,
    dynamic session,
    String? lastError,
  }) {
    return AuthStateData(
      authState: authState ?? this.authState,
      session: session ?? this.session,
      lastError: lastError ?? this.lastError,
    );
  }
  
  /// Computed properties for convenience.
  bool get isAuthenticated => session != null;
  bool get isLoading => authState == AuthenticationState.loading;
  bool get hasError => lastError != null;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthStateData &&
          runtimeType == other.runtimeType &&
          authState == other.authState &&
          session == other.session &&
          lastError == other.lastError;

  @override
  int get hashCode => Object.hash(authState, session, lastError);
  
  @override
  String toString() => 'AuthStateData(authState: $authState, isAuthenticated: $isAuthenticated, hasError: $hasError)';
}

/// Immutable data class for profile state.
class ProfileStateData {
  final dynamic profile;
  final bool isLoading;
  
  const ProfileStateData({
    this.profile,
    required this.isLoading,
  });
  
  factory ProfileStateData.initial() => const ProfileStateData(
    isLoading: false,
  );
  
  /// Creates a copy with updated fields.
  ProfileStateData copyWith({
    dynamic profile,
    bool? isLoading,
  }) {
    return ProfileStateData(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  /// Computed properties for convenience.
  bool get hasProfile => profile != null;
  bool get isRegistered => profile?.registeredAt != null;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileStateData &&
          runtimeType == other.runtimeType &&
          profile == other.profile &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(profile, isLoading);
  
  @override
  String toString() => 'ProfileStateData(hasProfile: $hasProfile, isRegistered: $isRegistered, isLoading: $isLoading)';
}