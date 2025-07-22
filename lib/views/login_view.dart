import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../services/index.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Background radar image
          Positioned.fill(
            child: Image.asset(
              'assets/images/visuals/radar.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Spacer to center content
                  const Spacer(flex: 2),
                  // Logo and branding
                  Column(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Center(
                          child: Image.asset(
                            'assets/images/visuals/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // App name
                      Text(
                        AppStrings.appName.toLowerCase(),
                        style: AppTextStyles.appTitle.copyWith(
                          fontSize: 46,
                          color: AppColors.primair4Lilac,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Tagline
                      Text(
                        AppStrings.appTagline,
                        style: AppTextStyles.appSubtitle.copyWith(
                          fontSize: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Sign-in buttons
                  Column(
                    children: [
                      // LinkedIn sign-in - Custom button with LinkedIn logo
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSigningIn ? null : _signInWithLinkedIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A66C2), // LinkedIn blue
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF0A66C2).withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // LinkedIn logo
                              Image.asset(
                                'assets/images/visuals/linkedInLogo.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Sign in with LinkedIn',
                                style: AppTextStyles.callout.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Apple sign-in - Native button
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: SignInWithAppleButton(
                          onPressed: _isSigningIn ? null : _signInWithApple,
                          text: 'Sign in with Apple',
                          height: 56,
                          style: SignInWithAppleButtonStyle.black,
                          borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
                        ),
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
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
                          ),
                          child: Text(
                            sessionManager.lastError!,
                            style: AppTextStyles.callout.copyWith(
                              color: AppColors.error,
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
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Loading overlay
          if (_isSigningIn)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}