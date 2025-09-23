import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/enums/login_button_type.dart';
import '../../widgets/buttons/login_button.dart';
import '../../services/auth_service.dart';
import '../../widgets/index.dart';
import '../../widgets/common/radar_background.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// LoginView - Initial authentication screen
///
/// Displays the Venyu branding with radar background and
/// authentication options for LinkedIn and Apple sign-in.
class LoginView extends StatefulWidget {
  final bool hasInviteCode;

  const LoginView({
    super.key,
    this.hasInviteCode = false,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ErrorHandlingMixin {
  // _isSigningIn removed - using mixin's isProcessing

  /// Performs Apple sign in using AuthService
  Future<void> _signInWithApple() async {
    final authService = context.read<AuthService>();
    
    await executeWithLoading(
      operation: () async {
        AppLogger.auth('Starting Apple sign-in via AuthService', context: 'LoginView');
        await authService.signInWithApple();
        AppLogger.auth('Apple sign-in initiated via AuthService', context: 'LoginView');
      },
      showSuccessToast: false, // Navigation handled by AuthFlow
      showErrorToast: false,   // Error handled by AuthService
      useProcessingState: true,
    );
  }
  
  Future<void> _signInWithGoogle() async {
    final authService = context.read<AuthService>();
    
    await executeWithLoading(
      operation: () async {
        AppLogger.auth('Starting Google sign-in', context: 'LoginView');
        await authService.signInWithGoogle();
        AppLogger.auth('Google sign-in initiated successfully', context: 'LoginView');
      },
      showSuccessToast: false,
      showErrorToast: false,
      useProcessingState: true,
    );
  }
  
  Future<void> _signInWithLinkedIn() async {
    final authService = context.read<AuthService>();
    
    await executeWithLoading(
      operation: () async {
        AppLogger.auth('Starting LinkedIn sign-in via AuthService', context: 'LoginView');
        await authService.signInWithLinkedIn();
        AppLogger.auth('LinkedIn sign-in initiated via AuthService', context: 'LoginView');
      },
      showSuccessToast: false,
      showErrorToast: false, 
      useProcessingState: true,
    );
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
                      width: 180,
                      height: 180,
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
                      onPressed: isProcessing ? null : _signInWithLinkedIn,
                    ),
                    const SizedBox(height: 8),
                    
                    // Google sign-in
                    LoginButton(
                      type: LoginButtonType.google,
                      onPressed: isProcessing ? null : _signInWithGoogle,
                    ),
                    const SizedBox(height: 8),
                    
                    // Apple sign-in
                    LoginButton(
                      type: LoginButtonType.apple,
                      onPressed: isProcessing ? null : _signInWithApple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Error message from AuthService
                Consumer<AuthService>(
                  builder: (context, authService, _) {
                    if (authService.authState == AuthenticationState.error && 
                        authService.lastError != null) {
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
                          authService.lastError!,
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
          if (isProcessing)
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