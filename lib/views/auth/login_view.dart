import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/url_helper.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../models/enums/login_button_type.dart';
import '../../widgets/buttons/login_button.dart';
import '../../services/auth_service.dart';
import '../../services/toast_service.dart';
import '../../services/supabase_managers/base_supabase_manager.dart';
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
  AuthenticationState? _previousAuthState;
  String? _lastUsedProvider;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes to show error toasts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = context.read<AuthService>();
      _previousAuthState = authService.authState;
    });

    // Load last used auth provider
    _loadLastUsedProvider();
  }

  /// Load the last used authentication provider from secure storage
  Future<void> _loadLastUsedProvider() async {
    try {
      final provider = await BaseSupabaseManager.getStoredUserInfo();
      print('🔍 LoginView: Retrieved provider info: $provider');
      if (mounted) {
        setState(() {
          _lastUsedProvider = provider['auth_provider'];
        });
        print('🔍 LoginView: _lastUsedProvider set to: $_lastUsedProvider');
        AppLogger.info(
          'Last used auth provider: $_lastUsedProvider',
          context: 'LoginView',
        );
      }
    } catch (e) {
      print('❌ LoginView: Failed to load provider - $e');
      AppLogger.warning(
        'Failed to load last used provider',
        error: e,
        context: 'LoginView',
      );
    }
  }

  void _handleSuccessfulAuth(AuthenticationState authState) {
    // If user successfully authenticated, pop this view to return to AuthFlow
    if (authState == AuthenticationState.authenticated ||
        authState == AuthenticationState.registered ||
        authState == AuthenticationState.redeemed) {

      AppLogger.auth('Authentication successful (state: $authState), closing LoginView', context: 'LoginView');

      // Use addPostFrameCallback to ensure the UI update is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

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
    final l10n = AppLocalizations.of(context)!;

    try {
      // Set up retry callback to notify user when retrying after reauth failure
      // This keeps the UI disabled (via isProcessing) while showing a helpful message
      authService.authenticationManager.notifyRetryingGoogleSignIn = () {
        if (mounted) {
          ToastService.info(
            context: context,
            message: l10n.authGoogleRetryingMessage,
          );
        }
      };

      await executeWithLoading(
        operation: () async {
          AppLogger.auth('Starting Google sign-in', context: 'LoginView');
          await authService.signInWithGoogle();
          AppLogger.auth('Google sign-in initiated successfully', context: 'LoginView');
        },
        showSuccessToast: false,
        showErrorToast: false,
        useProcessingState: true, // This disables all login buttons during the entire flow
      );
    } finally {
      // Always clear callback, even if sign-in fails
      // This ensures the disabled state is properly reset
      if (mounted) {
        authService.authenticationManager.notifyRetryingGoogleSignIn = null;
      }
    }
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

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Check if authentication was successful and close this view
        _handleSuccessfulAuth(authService.authState);

        // Show error toast when auth state changes to error
        if (authService.authState == AuthenticationState.error &&
            _previousAuthState != AuthenticationState.error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ToastService.error(
                context: context,
                message: AppLocalizations.of(context)!.errorAuthenticationFailed,
              );
            }
          });
        }
        _previousAuthState = authService.authState;

        return AppScaffold(
      usePadding: false,
      useSafeArea: false,
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),
          
          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Spacer to center content
                          const Spacer(flex: 3),

                          // Logo and branding
                          Column(
                            children: [
                              SizedBox(
                                width: 140,
                                height: 140,
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
                                AppLocalizations.of(context)!.appName.toLowerCase(),
                                style: AppTextStyles.appTitle.copyWith(
                                  fontSize: 60,
                                  color: venyuTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Tagline
                              Text(
                                AppLocalizations.of(context)!.appTagline,
                                style: AppTextStyles.appSubtitle.copyWith(
                                  color: venyuTheme.secondaryText,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(flex: 1),

                          // Sign-in buttons
                          // Order: Apple first on iOS, Google first on Android
                          Column(
                            children: [
                              // LinkedIn sign-in (temporarily disabled)
                              //LoginButton(
                              //  type: LoginButtonType.linkedIn,
                              //  onPressed: isProcessing ? null : _signInWithLinkedIn,
                              //),
                              //const SizedBox(height: 8),

                              // Platform-specific order
                              if (Platform.isIOS) ...[
                                // Apple sign-in first on iOS
                                Builder(
                                  builder: (context) {
                                    final isLastUsed = _lastUsedProvider == 'apple';
                                    print('🔍 Apple button: _lastUsedProvider=$_lastUsedProvider, isLastUsed=$isLastUsed');
                                    return LoginButton(
                                      type: LoginButtonType.apple,
                                      onPressed: isProcessing ? null : _signInWithApple,
                                      isLastUsed: isLastUsed,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Google sign-in second on iOS
                                Builder(
                                  builder: (context) {
                                    final isLastUsed = _lastUsedProvider == 'google';
                                    print('🔍 Google button: _lastUsedProvider=$_lastUsedProvider, isLastUsed=$isLastUsed');
                                    return LoginButton(
                                      type: LoginButtonType.google,
                                      onPressed: isProcessing ? null : _signInWithGoogle,
                                      isLastUsed: isLastUsed,
                                    );
                                  },
                                ),
                              ] else ...[
                                // Google sign-in first on Android
                                Builder(
                                  builder: (context) {
                                    final isLastUsed = _lastUsedProvider == 'google';
                                    print('🔍 Google button: _lastUsedProvider=$_lastUsedProvider, isLastUsed=$isLastUsed');
                                    return LoginButton(
                                      type: LoginButtonType.google,
                                      onPressed: isProcessing ? null : _signInWithGoogle,
                                      isLastUsed: isLastUsed,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Apple sign-in second on Android
                                Builder(
                                  builder: (context) {
                                    final isLastUsed = _lastUsedProvider == 'apple';
                                    print('🔍 Apple button: _lastUsedProvider=$_lastUsedProvider, isLastUsed=$isLastUsed');
                                    return LoginButton(
                                      type: LoginButtonType.apple,
                                      onPressed: isProcessing ? null : _signInWithApple,
                                      isLastUsed: isLastUsed,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),

                          const Spacer(flex: 1),

                          // Legal text - clickable
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: GestureDetector(
                              onTap: () {
                                UrlHelper.openWebsite(
                                  context,
                                  'https://app.getvenyu.com/functions/v1/terms',
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.loginLegalText,
                                style: AppTextStyles.footnote.copyWith(
                                  color: venyuTheme.secondaryText,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Loading overlay
          if (isProcessing)
            Container(
              color: context.venyuTheme.pageBackground.withValues(alpha: 0.5),
              child: Center(
                child: PlatformCircularProgressIndicator(
                  material: (_, _) => MaterialProgressIndicatorData(
                    valueColor: AlwaysStoppedAnimation<Color>(context.venyuTheme.primaryText),
                  ),
                  cupertino: (_, _) => CupertinoProgressIndicatorData(
                    color: context.venyuTheme.primaryText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
      },
    );
  }
}