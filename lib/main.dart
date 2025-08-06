import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'models/test_models.dart';
import 'services/index.dart';
import 'views/index.dart';

void main() async {
  await bugsnag.start(apiKey: '4dce9ee1ef30e5a80aa57cc4413ef460');
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
  
  runApp(const VenyuApp());
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionManager.shared,
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
    return Consumer<SessionManager>(
      builder: (context, sessionManager, child) {
        debugPrint('🔄 AuthFlow: Current state = ${sessionManager.authState}');
        
        switch (sessionManager.authState) {
          case AuthenticationState.loading:
            return PlatformScaffold(
              body: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            );
            
          case AuthenticationState.unauthenticated:
            return const LoginView();
            
          case AuthenticationState.authenticated:
            return const OnboardView();
            
          case AuthenticationState.registered:
            return const MainView();
            
          case AuthenticationState.error:
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

