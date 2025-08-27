import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'services/index.dart';
import 'services/notification_service.dart';
import 'views/index.dart';

void main() async {
  // Temporarily disable Bugsnag for debugging
  // await bugsnag.start(apiKey: '4dce9ee1ef30e5a80aa57cc4413ef460');
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: '.env.local');
  } catch (e) {
    AppLogger.warning('Could not load .env.local file', error: e, context: 'main');
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
  
  runApp(const VenyuApp());
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.ui('VenyuApp.build() - Creating ChangeNotifierProvider with SessionManager.shared', context: 'VenyuApp');
    
    return ChangeNotifierProvider(
      create: (_) {
        final sessionManager = SessionManager.shared;
        AppLogger.ui('ChangeNotifierProvider: Created with SessionManager instance ${sessionManager.hashCode}', context: 'VenyuApp');
        return sessionManager;
      },
      child: PlatformApp(
        title: 'Venyu',
        // Global localization settings
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('nl', 'NL'),
        ],
        material: (_, __) => MaterialAppData(
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
  


  @override
  Widget build(BuildContext context) {
    AppLogger.ui('AuthFlow.build() called', context: 'AuthFlow');
    
    return Consumer<SessionManager>(
      builder: (context, sessionManager, child) {
        AppLogger.ui('AuthFlow Consumer: Current state = ${sessionManager.authState}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: isAuthenticated = ${sessionManager.isAuthenticated}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: isRegistered = ${sessionManager.isRegistered}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: hasProfile = ${sessionManager.currentProfile != null}', context: 'AuthFlow');
        AppLogger.ui('AuthFlow Consumer: SessionManager instance = ${sessionManager.hashCode}', context: 'AuthFlow');
        
        switch (sessionManager.authState) {
          case AuthenticationState.loading:
            AppLogger.ui('Showing loading screen', context: 'AuthFlow');
            return PlatformScaffold(
              body: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            );
            
          case AuthenticationState.unauthenticated:
            AppLogger.ui('Showing login view', context: 'AuthFlow');
            return const LoginView();
            
          case AuthenticationState.authenticated:
            AppLogger.ui('Showing onboard view', context: 'AuthFlow');
            return const OnboardView();
            
          case AuthenticationState.registered:
            AppLogger.ui('Showing main view', context: 'AuthFlow');
            return const MainView();
            
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
                      sessionManager.lastError ?? 'Unknown error occurred',
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

