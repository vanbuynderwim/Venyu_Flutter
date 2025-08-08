import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'models/test_models.dart';
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
    debugPrint('Warning: Could not load .env.local file: $e');
    debugPrint('Using fallback configuration');
  }
  
  // Validate configuration before proceeding
  try {
    if (!AppConfig.validateConfiguration()) {
      throw Exception('Invalid app configuration');
    }
  } catch (e) {
    debugPrint('Configuration error: $e');
    debugPrint('Please ensure environment variables are properly set in .env.local');
    return;
  }
  
  // Test models
  TestModels.runTests();
  
  // Initialize Supabase through SupabaseManager - better separation of concerns
  try {
    await SupabaseManager.shared.initialize();
  } catch (e) {
    debugPrint('❌ Failed to initialize SupabaseManager: $e');
    debugPrint('Cannot continue without Supabase connection');
    return;
  }
  
  // Initialize Firebase and NotificationService (non-blocking)
  NotificationService.shared.initialize().catchError((error) {
    debugPrint('⚠️ NotificationService initialization failed: $error');
    debugPrint('App will continue without push notifications');
  });
  
  runApp(const VenyuApp());
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ VenyuApp.build() - Creating ChangeNotifierProvider with SessionManager.shared');
    
    return ChangeNotifierProvider(
      create: (_) {
        final sessionManager = SessionManager.shared;
        debugPrint('🔗 ChangeNotifierProvider: Created with SessionManager instance ${sessionManager.hashCode}');
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
    debugPrint('🏗️ AuthFlow.build() called');
    
    return Consumer<SessionManager>(
      builder: (context, sessionManager, child) {
        debugPrint('🔄 AuthFlow Consumer: Current state = ${sessionManager.authState}');
        debugPrint('🔄 AuthFlow Consumer: isAuthenticated = ${sessionManager.isAuthenticated}');
        debugPrint('🔄 AuthFlow Consumer: isRegistered = ${sessionManager.isRegistered}');
        debugPrint('🔄 AuthFlow Consumer: hasProfile = ${sessionManager.currentProfile != null}');
        debugPrint('🔄 AuthFlow Consumer: SessionManager instance = ${sessionManager.hashCode}');
        
        switch (sessionManager.authState) {
          case AuthenticationState.loading:
            debugPrint('📱 Showing loading screen');
            return PlatformScaffold(
              body: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            );
            
          case AuthenticationState.unauthenticated:
            debugPrint('📱 Showing login view');
            return const LoginView();
            
          case AuthenticationState.authenticated:
            debugPrint('📱 Showing onboard view');
            return const OnboardView();
            
          case AuthenticationState.registered:
            debugPrint('📱 Showing main view');
            return const MainView();
            
          case AuthenticationState.error:
            debugPrint('📱 Showing error screen');
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
                      style: Theme.of(context).textTheme.headlineSmall,
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

