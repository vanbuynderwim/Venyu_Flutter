import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../models/enums/login_button_type.dart';
import '../../widgets/buttons/login_button.dart';
import '../../services/index.dart';
import '../../widgets/index.dart';
import '../../widgets/common/radar_background.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// LoginView - Initial authentication screen
/// 
/// Displays the Venyu branding with radar background and
/// authentication options for LinkedIn and Apple sign-in.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSigningIn = false;

  /// Performs Apple sign in using SessionManager - mirrors iOS implementation
  Future<void> _signInWithApple() async {
    final sessionManager = context.read<SessionManager>();
    
    setState(() {
      _isSigningIn = true;
    });

    try {
      debugPrint('🍎 Starting Apple sign-in via SessionManager');
      
      // Use SessionManager for authentication - equivalent to iOS approach
      await sessionManager.signInWithApple();
      
      debugPrint('✅ Apple sign-in initiated via SessionManager');
      // Navigation will be handled automatically by AuthFlow via SessionManager state
      
    } catch (error) {
      debugPrint('❌ Apple sign-in error: $error');
      // Error handling is now managed by SessionManager
      // UI will react to SessionManager.authState changes
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
  
  Future<void> _signInWithGoogle() async {
    final sessionManager = context.read<SessionManager>();
    
    setState(() {
      _isSigningIn = true;
    });

    try {
      debugPrint('📱 Starting Google sign-in');
      
      await sessionManager.signInWithGoogle();
      
      debugPrint('✅ Google sign-in initiated successfully');
      
    } catch (error) {
      debugPrint('❌ Google sign-in error: $error');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
  
  Future<void> _signInWithLinkedIn() async {
    final sessionManager = context.read<SessionManager>();
    
    setState(() {
      _isSigningIn = true;
    });

    try {
      debugPrint('💼 Starting LinkedIn sign-in via SessionManager');
      
      // Use SessionManager for LinkedIn authentication - equivalent to iOS approach
      await sessionManager.signInWithLinkedIn();
      
      debugPrint('✅ LinkedIn sign-in initiated via SessionManager');
      // Navigation will be handled automatically by AuthFlow via SessionManager state
      
    } catch (error) {
      debugPrint('❌ LinkedIn sign-in error: $error');
      // Error handling is now managed by SessionManager
      // UI will react to SessionManager.authState changes
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return AppScaffold(
      usePadding: false,
      useSafeArea: false,
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Spacer to center content
                const Spacer(flex: 3),
                // Logo and branding
                Column(
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Center(
                        child: Image.asset(
                          'assets/images/visuals/logo.png',
                          color: venyuTheme.primary,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // App name
                    Text(
                      AppStrings.appName.toLowerCase(),
                      style: AppTextStyles.appTitle.copyWith(
                        fontSize: 60,
                        color: venyuTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Tagline
                    Text(
                      AppStrings.appTagline,
                      style: AppTextStyles.appSubtitle.copyWith(
                        fontSize: 20,
                        color: venyuTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(flex: 1),
                
                // Sign-in buttons
                Column(
                  children: [
                    // LinkedIn sign-in
                    LoginButton(
                      type: LoginButtonType.linkedIn,
                      onPressed: _isSigningIn ? null : _signInWithLinkedIn,
                    ),
                    const SizedBox(height: 8),
                    
                    // Google sign-in
                    LoginButton(
                      type: LoginButtonType.google,
                      onPressed: _isSigningIn ? null : _signInWithGoogle,
                    ),
                    const SizedBox(height: 8),
                    
                    // Apple sign-in
                    LoginButton(
                      type: LoginButtonType.apple,
                      onPressed: _isSigningIn ? null : _signInWithApple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Error message from SessionManager
                Consumer<SessionManager>(
                  builder: (context, sessionManager, _) {
                    if (sessionManager.authState == AuthenticationState.error && 
                        sessionManager.lastError != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: venyuTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
                        ),
                        child: Text(
                          sessionManager.lastError!,
                          style: AppTextStyles.callout.copyWith(
                            color: venyuTheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const Spacer(flex: 1),
                
                // Legal text
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'By signing in, you agree to our Terms of Service and Privacy Policy',
                    style: AppTextStyles.footnote.copyWith(
                      color: venyuTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Loading overlay
          if (_isSigningIn)
            Container(
              color: context.venyuTheme.pageBackground.withValues(alpha: 0.5),
              child: Center(
                child: PlatformCircularProgressIndicator(
                  material: (_, __) => MaterialProgressIndicatorData(
                    valueColor: AlwaysStoppedAnimation<Color>(context.venyuTheme.primaryText),
                  ),
                  cupertino: (_, __) => CupertinoProgressIndicatorData(
                    color: context.venyuTheme.primaryText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}