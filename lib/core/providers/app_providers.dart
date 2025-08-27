import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/profile_service.dart';

/// Centralized provider configuration that prevents app-wide rebuilds.
/// 
/// This approach replaces the single SessionManager provider with multiple
/// focused providers that only rebuild widgets that actually need updates.
/// Uses MultiProvider to create a provider tree with proper scoping.
class AppProviders extends StatelessWidget {
  final Widget child;
  
  const AppProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth state provider - only rebuilds when auth state changes
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService.shared,
          lazy: false, // Initialize immediately
        ),
        
        // Profile data provider - only rebuilds when profile data changes
        ChangeNotifierProvider<ProfileService>(
          create: (_) => ProfileService.shared,
          lazy: false, // Initialize immediately  
        ),
      ],
      child: child,
    );
  }
}

/// Extension on BuildContext for easy access to services.
extension AppProvidersContext on BuildContext {
  /// Get AuthService from context.
  AuthService get authService => read<AuthService>();
  
  /// Get ProfileService from context.
  ProfileService get profileService => read<ProfileService>();
  
  /// Watch AuthService for reactive updates.
  AuthService get watchAuthService => watch<AuthService>();
  
  /// Watch ProfileService for reactive updates.
  ProfileService get watchProfileService => watch<ProfileService>();
}

/// Selective consumer widgets for fine-grained rebuilds.

/// Widget that only rebuilds when authentication state changes.
class AuthConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, AuthService authService, Widget? child) builder;
  final Widget? child;

  const AuthConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: builder,
      child: child,
    );
  }
}

/// Widget that only rebuilds when profile data changes.
class ProfileConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, ProfileService profileService, Widget? child) builder;
  final Widget? child;

  const ProfileConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: builder,
      child: child,
    );
  }
}

/// Widget that rebuilds when either auth or profile state changes.
/// Use sparingly - prefer specific consumers when possible.
class AuthProfileConsumer extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    AuthService authService,
    ProfileService profileService,
    Widget? child,
  ) builder;
  final Widget? child;

  const AuthProfileConsumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, ProfileService>(
      builder: builder,
      child: child,
    );
  }
}

/// Selector widgets for even more fine-grained control.

/// Widget that only rebuilds when authentication state changes.
class AuthStateSelector<T> extends StatelessWidget {
  final T Function(AuthService authService) selector;
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
    return Selector<AuthService, T>(
      selector: (context, authService) => selector(authService),
      builder: builder,
      child: child,
    );
  }
}

/// Widget that only rebuilds when specific profile data changes.
class ProfileSelector<T> extends StatelessWidget {
  final T Function(ProfileService profileService) selector;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  const ProfileSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileService, T>(
      selector: (context, profileService) => selector(profileService),
      builder: builder,
      child: child,
    );
  }
}