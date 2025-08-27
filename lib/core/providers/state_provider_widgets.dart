import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state_manager.dart';
import '../state/app_state_notifier.dart';

/// Enhanced provider widget that provides granular state notifiers.
/// 
/// This widget initializes the AppStateManager and provides access to
/// fine-grained state notifiers for optimal rebuild performance.
class StateProviderWidget extends StatefulWidget {
  final Widget child;
  
  const StateProviderWidget({
    super.key,
    required this.child,
  });

  @override
  State<StateProviderWidget> createState() => _StateProviderWidgetState();
}

class _StateProviderWidgetState extends State<StateProviderWidget> {
  late AppStateManager _appStateManager;
  
  @override
  void initState() {
    super.initState();
    _appStateManager = AppStateManager.shared;
  }
  
  @override
  void dispose() {
    // Don't dispose the singleton here - let the app manage its lifecycle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the state notifiers for granular listening
        ChangeNotifierProvider<AuthStateNotifier>.value(
          value: _appStateManager.authStateNotifier,
        ),
        ChangeNotifierProvider<ProfileStateNotifier>.value(
          value: _appStateManager.profileStateNotifier,
        ),
      ],
      child: widget.child,
    );
  }
}

/// Consumer widget for auth state changes only.
class AuthStateConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, AuthStateData authState, Widget? child) builder;
  final Widget? child;

  const AuthStateConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStateNotifier>(
      builder: (context, notifier, child) => builder(context, notifier.state, child),
      child: child,
    );
  }
}

/// Consumer widget for profile state changes only.
class ProfileStateConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, ProfileStateData profileState, Widget? child) builder;
  final Widget? child;

  const ProfileStateConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileStateNotifier>(
      builder: (context, notifier, child) => builder(context, notifier.state, child),
      child: child,
    );
  }
}

/// Consumer widget for combined auth and profile state.
class AuthProfileStateConsumer extends StatelessWidget {
  final Widget Function(
    BuildContext context, 
    AuthStateData authState, 
    ProfileStateData profileState, 
    Widget? child
  ) builder;
  final Widget? child;

  const AuthProfileStateConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthStateNotifier, ProfileStateNotifier>(
      builder: (context, authNotifier, profileNotifier, child) => 
        builder(context, authNotifier.state, profileNotifier.state, child),
      child: child,
    );
  }
}

/// Selector widgets for even more fine-grained control.

/// Selector for specific auth state properties.
class AuthStateSelector<T> extends StatelessWidget {
  final T Function(AuthStateData authState) selector;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  const AuthStateSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AuthStateNotifier, T>(
      selector: (context, notifier) => selector(notifier.state),
      builder: builder,
      child: child,
    );
  }
}

/// Selector for specific profile state properties.
class ProfileStateSelector<T> extends StatelessWidget {
  final T Function(ProfileStateData profileState) selector;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  const ProfileStateSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileStateNotifier, T>(
      selector: (context, notifier) => selector(notifier.state),
      builder: builder,
      child: child,
    );
  }
}

/// Convenience extension for accessing state notifiers from context.
extension StateNotifierContext on BuildContext {
  /// Read auth state notifier without listening.
  AuthStateNotifier get authStateNotifier => read<AuthStateNotifier>();
  
  /// Read profile state notifier without listening.
  ProfileStateNotifier get profileStateNotifier => read<ProfileStateNotifier>();
  
  /// Watch auth state notifier for changes.
  AuthStateNotifier get watchAuthStateNotifier => watch<AuthStateNotifier>();
  
  /// Watch profile state notifier for changes.
  ProfileStateNotifier get watchProfileStateNotifier => watch<ProfileStateNotifier>();
  
  /// Get current auth state without listening.
  AuthStateData get authState => authStateNotifier.state;
  
  /// Get current profile state without listening.
  ProfileStateData get profileState => profileStateNotifier.state;
}