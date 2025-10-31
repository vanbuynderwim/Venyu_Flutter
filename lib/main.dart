import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'l10n/app_localizations.dart';
import 'core/config/app_config.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';
import 'services/supabase_manager.dart';
import 'services/notification_service.dart';
import 'services/revenuecat_service.dart';
import 'views/index.dart';
import 'views/auth/invite_screening_view.dart';
import 'views/auth/redeem_invite_view.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // Critical: Preserve splash screen immediately to prevent white screen
  // This must be the FIRST thing after ensureInitialized()
  // Use SentryWidgetsFlutterBinding for proper Sentry integration
  WidgetsBinding widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure transparent system UI for edge-to-edge display (Android 15+ compatibility)
  // This prevents Flutter from calling deprecated APIs like setStatusBarColor
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize date formatting for all supported locales
  try {
    await initializeDateFormatting();
    // Explicitly initialize nl_BE locale
    await initializeDateFormatting('nl_BE');
    AppLogger.info('Date formatting initialized for all locales including nl_BE', context: 'main');
  } catch (e) {
    AppLogger.warning('Date formatting initialization failed', error: e, context: 'main');
  }
  
  // Load environment variables from .env file
  // In CI/CD, this file is generated with environment-specific values
  try {
    await dotenv.load(fileName: '.env');
    AppLogger.info('Loaded environment from .env', context: 'main');
  } catch (e) {
    AppLogger.warning('Could not load .env file', error: e, context: 'main');
    AppLogger.info('Using fallback configuration', context: 'main');
  }
  
  // Validate configuration before proceeding
  try {
    if (!AppConfig.validateConfiguration()) {
      throw Exception('Invalid app configuration');
    }
  } catch (e) {
    AppLogger.error('Configuration error', error: e, context: 'main');
    AppLogger.error('Please ensure environment variables are properly set in .env.local', context: 'main');
    return;
  }
  
  // Initialize Supabase through SupabaseManager - better separation of concerns
  try {
    await SupabaseManager.shared.initialize();
  } catch (e) {
    AppLogger.error('Failed to initialize SupabaseManager', error: e, context: 'main');
    AppLogger.error('Cannot continue without Supabase connection', context: 'main');
    return;
  }
  
  
  // Initialize Firebase and NotificationService (non-blocking)
  NotificationService.shared.initialize().catchError((error) {
    AppLogger.warning('NotificationService initialization failed', error: error, context: 'main');
    AppLogger.info('App will continue without push notifications', context: 'main');
  });
  
  // Initialize RevenueCat (only if Pro features are enabled)
  if (AppConfig.showPro) {
    try {
      await _initializeRevenueCat();
    } catch (e) {
      AppLogger.warning('RevenueCat initialization failed', error: e, context: 'main');
      AppLogger.info('App will continue without subscription features', context: 'main');
    }
  } else {
    AppLogger.info('RevenueCat initialization skipped - Pro features disabled in config', context: 'main');
  }
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://551ad30b7555c2fdc9f9a65e56ce1a07@o4510182183534592.ingest.de.sentry.io/4510182184976464';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      // Disable debug logs to reduce console noise during development
      options.debug = false;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: const VenyuApp())),
  );
}

/// Initialize RevenueCat using the dedicated service
Future<void> _initializeRevenueCat() async {
  try {
    await RevenueCatService().initialize();
  } catch (e) {
    AppLogger.warning('RevenueCat initialization failed', error: e, context: 'main');
    AppLogger.info('App will continue without subscription features', context: 'main');
  }
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.ui('VenyuApp.build() - Creating AppProviders with focused services', context: 'VenyuApp');
    
    return AppProviders(
      child: PlatformApp(
        title: 'Venyu',
        // Global localization settings
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('nl'),
        ],
        material: (_, _) => MaterialAppData(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system, // Follow system dark mode setting
        ),
        cupertino: (context, platform) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          return CupertinoAppData(
            theme: brightness == Brightness.dark 
                ? AppTheme.cupertinoDarkTheme 
                : AppTheme.cupertinoLightTheme,
          );
        },
        home: const AuthFlow(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// AuthFlow - Manages the navigation flow based on authentication state
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _splashRemoved = false;

  /// Determines the overall app state by combining auth and profile services.
  AuthenticationState _determineAppState(AuthService authService, ProfileService profileService) {
    // Start with auth state
    final authState = authService.authState;
    
    // If auth is not authenticated, return that state
    if (authState == AuthenticationState.unauthenticated ||
        authState == AuthenticationState.loading ||
        authState == AuthenticationState.error) {
      return authState;
    }
    
    // If authenticated, check profile registration status
    if (authState == AuthenticationState.authenticated) {
      // If we don't have a profile yet, stay in loading to prevent flash
      if (profileService.currentProfile == null) {
        return AuthenticationState.loading;
      }

      // Check if profile is registered
      if (profileService.isRegistered) {
        return AuthenticationState.registered;
      } else if (profileService.currentProfile?.redeemedAt != null) {
        // User has redeemed an invite code but hasn't completed registration
        return AuthenticationState.redeemed;
      } else {
        // User is authenticated but hasn't redeemed an invite code yet
        return AuthenticationState.authenticated;
      }
    }
    
    // If already registered, return that state
    if (authState == AuthenticationState.registered) {
      return AuthenticationState.registered;
    }
    
    // Default case
    return authState;
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.ui('AuthFlow.build() called', context: 'AuthFlow');
    
    return AuthProfileConsumer(
      builder: (context, authService, profileService, child) {
        AppLogger.ui('AuthFlow Consumer: Current state = ${authService.authState}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: isAuthenticated = ${authService.isAuthenticated}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: isRegistered = ${profileService.isRegistered}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: isRedeemed = ${profileService.isRedeemed}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: hasProfile = ${profileService.currentProfile != null}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: AuthService instance = ${authService.hashCode}', context: 'AuthFlow');
        
        // Determine the overall app state by combining auth and profile services
        final appState = _determineAppState(authService, profileService);
        
        // Remove splash screen once we have a definitive state AND UI is ready
        // Following flutter_native_splash best practices
        if (!_splashRemoved && appState != AuthenticationState.loading) {
          // Schedule removal after current frame is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Small delay to ensure UI is stable before transition
            Future.delayed(const Duration(milliseconds: 150), () {
              if (!_splashRemoved && mounted) {
                // Use recommended removal method
                FlutterNativeSplash.remove();
                _splashRemoved = true;
                AppLogger.info('Splash screen removed - app fully initialized', context: 'AuthFlow');
              }
            });
          });
        }
        
        switch (appState) {
          case AuthenticationState.loading:
            AppLogger.ui('Showing loading screen', context: 'AuthFlow');
            return PlatformScaffold(
              body: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            );
            
          case AuthenticationState.unauthenticated:
            AppLogger.ui('Showing invite screening view', context: 'AuthFlow');
            return const InviteScreeningView();
            
          case AuthenticationState.registered:
            AppLogger.ui('Showing main view', context: 'AuthFlow');
            return const MainView();

          case AuthenticationState.authenticated:
            AppLogger.ui('Showing redeem invite view', context: 'AuthFlow');
            return const RedeemInviteView();

          case AuthenticationState.redeemed:
            AppLogger.ui('Showing onboard view', context: 'AuthFlow');
            return const OnboardView();

          case AuthenticationState.error:
            AppLogger.ui('Showing error screen', context: 'AuthFlow');
            return PlatformScaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCupertino(context) ? CupertinoIcons.exclamationmark_circle : Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Authentication Error',
                      style: AppTextStyles.title2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authService.lastError ?? 'Unknown error occurred',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    PlatformElevatedButton(
                      onPressed: () {
                        // Return to login to retry
                        Navigator.pushAndRemoveUntil(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (_) => const LoginView(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}

