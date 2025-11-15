import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/environment.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

/// AuthenticationManager - Handles all OAuth authentication operations
/// 
/// This manager is responsible for:
/// - Apple Sign In with secure nonce generation
/// - LinkedIn OAuth flow with deep link handling  
/// - Google Sign In with proper token handling
/// - User data extraction and secure storage
/// - Sign out operations
/// 
/// Features:
/// - Platform-specific OAuth implementations
/// - Secure user data storage via FlutterSecureStorage
/// - Consistent error handling and logging
/// - Deep link callback processing for OAuth flows
class AuthenticationManager extends BaseSupabaseManager with DisposableManagerMixin {
  static AuthenticationManager? _instance;

  /// The singleton instance of [AuthenticationManager].
  static AuthenticationManager get shared {
    _instance ??= AuthenticationManager._internal();
    return _instance!;
  }

  /// Private constructor for singleton pattern.
  AuthenticationManager._internal();

  /// Callback to notify UI when retrying Google sign-in after reauth failure
  /// This helps prevent user confusion during the 2-second retry delay
  Function()? notifyRetryingGoogleSignIn;

  // MARK: - LinkedIn Authentication

  /// Performs LinkedIn sign in - equivalent to iOS signInWithlinkedIn
  /// 
  /// This method follows the same pattern as the iOS implementation:
  /// 1. Initiate OAuth flow with LinkedIn OpenID Connect
  /// 2. Handle deep link redirect via custom URL scheme
  /// 3. Extract LinkedIn user identity data
  /// 4. Store user information securely
  /// 5. Return session for further processing
  Future<AuthResponse> signInWithLinkedIn() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Starting LinkedIn sign-in process', context: 'AuthenticationManager');

      try {
        // Step 1: Start OAuth flow with LinkedIn OIDC (equivalent to iOS implementation)
        final bool launched = await client.auth.signInWithOAuth(
          OAuthProvider.linkedinOidc,
          // Using custom scheme with external browser - upgraded SDK should persist flow_state
          authScreenLaunchMode: LaunchMode.inAppWebView,
          scopes: 'openid profile email', // Same scopes as iOS
        );

        if (launched) {
          AppLogger.success('LinkedIn OAuth browser launched successfully', context: 'AuthenticationManager');
        } else {
          AppLogger.error('Failed to launch LinkedIn OAuth browser', context: 'AuthenticationManager');
          throw const AuthException('Failed to launch LinkedIn OAuth browser');
        }

        // For OAuth flows, we need to return a placeholder response
        // The actual authentication completion will happen via deep link callback
        return AuthResponse(
          user: null,
          session: null,
        );
      } catch (e) {
        AppLogger.error('LinkedIn OAuth error: $e', context: 'AuthenticationManager');
        rethrow;
      }
    });
  }
  
  /// Process LinkedIn authentication callback - equivalent to iOS identity processing
  /// 
  /// This method handles the deep link callback and extracts user data,
  /// matching the iOS implementation's identity processing logic.
  Future<void> processLinkedInCallback() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Processing LinkedIn callback', context: 'AuthenticationManager');
      
      final user = client.auth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found after LinkedIn callback');
      }
      
      // Step 2: Find LinkedIn identity (equivalent to iOS identity extraction)
      final linkedInIdentity = user.userMetadata;
      if (linkedInIdentity == null || linkedInIdentity.isEmpty) {
        throw const AuthException('No LinkedIn identity found in user metadata');
      }
      
      AppLogger.info('LinkedIn identity found, extracting user data', context: 'AuthenticationManager');
      
      // Step 3: Extract and store LinkedIn user data (equivalent to iOS toLinkedInUser())
      await _extractAndStoreLinkedInUserData(linkedInIdentity);
      
      AppLogger.success('LinkedIn authentication and data storage completed', context: 'AuthenticationManager');
    });
  }
  
  /// Extract LinkedIn user data - equivalent to iOS toLinkedInUser() extension
  /// 
  /// This method replicates the iOS data extraction logic with the same
  /// field mapping and secure storage approach.
  Future<void> _extractAndStoreLinkedInUserData(Map<String, dynamic> identityData) async {
    try {
      AppLogger.debug('Extracting LinkedIn user data', context: 'AuthenticationManager');
      
      // Extract LinkedIn user information (same fields as iOS)
      final firstName = identityData['given_name'] as String?;
      final lastName = identityData['family_name'] as String?;
      final email = identityData['email'] as String?;
      final pictureUrl = identityData['picture'] as String?;
      final locale = identityData['locale'] as String?;
      final emailVerified = identityData['email_verified'] as bool?;
      
      AppLogger.debug('LinkedIn data extracted:', context: 'AuthenticationManager');
      AppLogger.debug('  - First Name: ${firstName ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Last Name: ${lastName ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Email: ${email ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Picture URL: ${pictureUrl ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Locale: ${locale ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Email Verified: ${emailVerified ?? false}', context: 'AuthenticationManager');
      
      // Store user information securely (equivalent to iOS Keychain storage)
      if (firstName != null && firstName.isNotEmpty) {
        await storage.write(key: 'firstName', value: firstName);
        AppLogger.storage('Stored LinkedIn first name securely', context: 'AuthenticationManager');
      }
      
      if (lastName != null && lastName.isNotEmpty) {
        await storage.write(key: 'lastName', value: lastName);
        AppLogger.storage('Stored LinkedIn last name securely', context: 'AuthenticationManager');
      }
      
      if (email != null && email.isNotEmpty) {
        await storage.write(key: 'email', value: email);
        AppLogger.storage('Stored LinkedIn email securely', context: 'AuthenticationManager');
      }
      
      // Store LinkedIn-specific data
      if (pictureUrl != null && pictureUrl.isNotEmpty) {
        await storage.write(key: 'avatarUrl', value: pictureUrl);
        AppLogger.storage('Stored LinkedIn avatar URL securely', context: 'AuthenticationManager');
      }
      
      if (locale != null && locale.isNotEmpty) {
        await storage.write(key: 'locale', value: locale);
        AppLogger.storage('Stored LinkedIn locale securely', context: 'AuthenticationManager');
      }
      
      // Store LinkedIn user identifier for future reference
      final linkedInUserId = identityData['sub'] as String?;
      if (linkedInUserId != null && linkedInUserId.isNotEmpty) {
        await storage.write(key: 'linkedInUserIdentifier', value: linkedInUserId);
        AppLogger.storage('Stored LinkedIn user identifier securely', context: 'AuthenticationManager');
      }
      
      // Store provider information
      await storage.write(key: 'auth_provider', value: 'linkedin');
      AppLogger.storage('Stored authentication provider securely', context: 'AuthenticationManager');
      
    } catch (error) {
      AppLogger.warning('Failed to store LinkedIn user data: $error', context: 'AuthenticationManager');
      // Continue with authentication even if storage fails
    }
  }

  // MARK: - Apple Authentication
  
  /// Performs Apple sign in
  ///
  /// Uses platform-specific implementation:
  /// - iOS: Native sign-in using sign_in_with_apple package
  /// - Android: Web-based OAuth flow using Supabase signInWithOAuth
  Future<AuthResponse> signInWithApple() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Starting Apple sign-in process', context: 'AuthenticationManager');

      if (Platform.isIOS || Platform.isMacOS) {
        // Native Apple sign-in for iOS/macOS
        return _signInWithAppleNative();
      } else {
        // Web-based OAuth flow for Android and other platforms
        return _signInWithAppleOAuth();
      }
    });
  }

  /// Native Apple sign-in for iOS/macOS using sign_in_with_apple package
  Future<AuthResponse> _signInWithAppleNative() async {
    AppLogger.auth('Using native Apple sign-in', context: 'AuthenticationManager');

    // Step 1: Generate secure nonce
    final rawNonce = client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    AppLogger.auth('Nonce generated for Apple sign-in', context: 'AuthenticationManager');

    // Step 2: Get Apple ID credential with nonce
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    AppLogger.info('Apple credential obtained', context: 'AuthenticationManager');
    AppLogger.debug('User ID: ${credential.userIdentifier}', context: 'AuthenticationManager');
    AppLogger.debug('Email: ${credential.email ?? 'Not provided'}', context: 'AuthenticationManager');
    AppLogger.debug('Given Name: ${credential.givenName ?? 'Not provided'}', context: 'AuthenticationManager');
    AppLogger.debug('Family Name: ${credential.familyName ?? 'Not provided'}', context: 'AuthenticationManager');

    // Step 3: Store user information securely
    await _storeAppleUserInfo(credential);

    // Step 4: Validate ID token
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Could not find ID Token from generated credential.');
    }

    // Step 5: Sign in with Supabase using Apple ID token
    AppLogger.info('Signing in with Supabase', context: 'AuthenticationManager');
    final response = await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    AppLogger.success('Supabase Apple sign-in successful', context: 'AuthenticationManager');
    AppLogger.debug('User: ${response.user?.email ?? 'No email'}', context: 'AuthenticationManager');
    AppLogger.debug('Session: ${response.session != null ? 'Active' : 'None'}', context: 'AuthenticationManager');

    return response;
  }

  /// Web-based Apple OAuth sign-in for Android and other non-Apple platforms
  Future<AuthResponse> _signInWithAppleOAuth() async {
    AppLogger.auth('Using web-based Apple OAuth sign-in', context: 'AuthenticationManager');

    // Step 1: Start OAuth flow with Apple
    await client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'com.getvenyu.app://callback', // Deep link to bring user back to app
      authScreenLaunchMode: LaunchMode.externalApplication, // Launch in external browser
    );

    AppLogger.success('Apple OAuth initiated successfully', context: 'AuthenticationManager');

    // For OAuth flows, we need to return a placeholder response
    // The actual authentication completion will happen via deep link callback
    return AuthResponse(
      user: null,
      session: null,
    );
  }

  /// Process Apple authentication callback - handles OAuth callback from deep link
  ///
  /// This method handles the deep link callback and extracts user data.
  /// Only needed for OAuth flow (Android), not for native iOS flow.
  Future<void> processAppleCallback() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Processing Apple OAuth callback', context: 'AuthenticationManager');

      final user = client.auth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found after Apple callback');
      }

      // Extract Apple identity from user metadata
      final appleIdentity = user.userMetadata;
      if (appleIdentity == null || appleIdentity.isEmpty) {
        throw const AuthException('No Apple identity found in user metadata');
      }

      AppLogger.info('Apple identity found, extracting user data', context: 'AuthenticationManager');

      // Extract and store Apple user data
      await _extractAndStoreAppleUserData(appleIdentity);

      AppLogger.success('Apple authentication and data storage completed', context: 'AuthenticationManager');
    });
  }

  /// Extract Apple user data from OAuth identity
  Future<void> _extractAndStoreAppleUserData(Map<String, dynamic> identityData) async {
    try {
      AppLogger.debug('Extracting Apple user data from OAuth', context: 'AuthenticationManager');

      // Extract Apple user information
      final email = identityData['email'] as String?;
      final firstName = identityData['given_name'] as String?;
      final lastName = identityData['family_name'] as String?;

      AppLogger.debug('Apple OAuth data extracted:', context: 'AuthenticationManager');
      AppLogger.debug('  - Email: ${email ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - First Name: ${firstName ?? 'Not provided'}', context: 'AuthenticationManager');
      AppLogger.debug('  - Last Name: ${lastName ?? 'Not provided'}', context: 'AuthenticationManager');

      // Store user information securely
      if (firstName != null && firstName.isNotEmpty) {
        await storage.write(key: 'firstName', value: firstName);
        AppLogger.storage('Stored Apple first name securely', context: 'AuthenticationManager');
      }

      if (lastName != null && lastName.isNotEmpty) {
        await storage.write(key: 'lastName', value: lastName);
        AppLogger.storage('Stored Apple last name securely', context: 'AuthenticationManager');
      }

      if (email != null && email.isNotEmpty) {
        await storage.write(key: 'email', value: email);
        AppLogger.storage('Stored Apple email securely', context: 'AuthenticationManager');
      }

      // Store Apple user identifier
      final appleUserId = identityData['sub'] as String?;
      if (appleUserId != null && appleUserId.isNotEmpty) {
        await storage.write(key: 'appleUserIdentifier', value: appleUserId);
        AppLogger.storage('Stored Apple user identifier securely', context: 'AuthenticationManager');
      }

      // Store provider information
      await storage.write(key: 'auth_provider', value: 'apple');
      AppLogger.storage('Stored authentication provider securely', context: 'AuthenticationManager');

    } catch (error) {
      AppLogger.warning('Failed to store Apple user data: $error', context: 'AuthenticationManager');
      // Continue with authentication even if storage fails
    }
  }
  
  /// Store Apple user information securely - equivalent to iOS Keychain storage
  Future<void> _storeAppleUserInfo(AuthorizationCredentialAppleID credential) async {
    try {
      AppLogger.storage('Storing Apple user data securely', context: 'AuthenticationManager');
      
      // Store full name if provided (only available on first sign-in)
      if (credential.givenName != null && credential.givenName!.isNotEmpty) {
        await storage.write(key: 'firstName', value: credential.givenName!);
        AppLogger.storage('Stored Apple first name securely', context: 'AuthenticationManager');
      }
      
      if (credential.familyName != null && credential.familyName!.isNotEmpty) {
        await storage.write(key: 'lastName', value: credential.familyName!);
        AppLogger.storage('Stored Apple last name securely', context: 'AuthenticationManager');
      }
      
      // Store email if provided
      if (credential.email != null && credential.email!.isNotEmpty) {
        await storage.write(key: 'email', value: credential.email!);
        AppLogger.storage('Stored Apple email securely', context: 'AuthenticationManager');
      }
      
      // Store Apple user identifier for future reference
      await storage.write(
        key: 'appleUserIdentifier',
        value: credential.userIdentifier,
      );
      AppLogger.storage('Stored Apple user ID securely', context: 'AuthenticationManager');
      
      // Store provider information
      await storage.write(key: 'auth_provider', value: 'apple');
      AppLogger.storage('Stored authentication provider securely', context: 'AuthenticationManager');
      
    } catch (error) {
      AppLogger.warning('Failed to store Apple user info: $error', context: 'AuthenticationManager');
      // Continue with authentication even if storage fails
    }
  }

  // MARK: - Google Authentication
  
  /// Performs Google sign in - equivalent to iOS Google OAuth implementation
  ///
  /// This method follows the native Google Sign-In flow:
  /// 1. Initialize GoogleSignIn singleton with client IDs
  /// 2. Authenticate user and get Google account
  /// 3. Get ID token from authentication
  /// 4. Get access token from authorization client
  /// 5. Store user information securely
  /// 6. Sign in with Supabase using ID token and access token
  /// 7. Return session for further processing
  Future<AuthResponse> signInWithGoogle() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Starting Google sign-in process', context: 'AuthenticationManager');

      // Step 1: Initialize GoogleSignIn singleton with proper configuration
      await GoogleSignIn.instance.initialize(
        clientId: EnvironmentConfig.googleIosClientId,
        serverClientId: EnvironmentConfig.googleWebClientId,
      );

      AppLogger.info('GoogleSignIn configured', context: 'AuthenticationManager');
      AppLogger.debug('Client ID: ${EnvironmentConfig.googleIosClientId}', context: 'AuthenticationManager');
      AppLogger.debug('Server Client ID: ${EnvironmentConfig.googleWebClientId}', context: 'AuthenticationManager');

      // Step 2: Initiate Google sign-in flow using authenticate() method
      // This is the correct method for google_sign_in v7 with Credential Manager
      // scopeHint allows combined authentication+authorization in one step
      late GoogleSignInAccount googleUser;

      try {
        googleUser = await GoogleSignIn.instance.authenticate(
          scopeHint: ['email', 'profile'],
        );
        AppLogger.info('Google user authenticated: ${googleUser.email}', context: 'AuthenticationManager');
      } on GoogleSignInException catch (e) {
        // User canceled the sign-in by clicking back or outside the popup
        // This is not an error - just silently return without authentication
        if (e.code == GoogleSignInExceptionCode.canceled &&
            !e.toString().contains('[16]')) {
          AppLogger.info('Google sign-in canceled by user', context: 'AuthenticationManager');
          rethrow; // Let AuthService handle the cancellation gracefully
        }

        // Handle Android Credential Manager reauth error for newly added accounts
        // This is a known bug in google_sign_in v7 SDK in combination with Android's
        // Credential Manager (Google Identity Services). When a user adds a new account
        // for the first time, the account configuration is not fully synchronized yet.
        // The SDK tries to reauthenticate immediately, but the token exchange fails
        // because the account doesn't have a valid "reauth" session yet.
        if (e.code == GoogleSignInExceptionCode.canceled &&
            e.toString().contains('[16]') &&
            e.toString().toLowerCase().contains('reauth')) {

          AppLogger.warning('Retrying Google sign-in after reauth failure...', context: 'AuthenticationManager');

          // Notify user that we're retrying (helps prevent confusion during the 2-second wait)
          notifyRetryingGoogleSignIn?.call();

          // Wait for the account to fully sync with Credential Manager
          await Future.delayed(const Duration(seconds: 2));

          // Force rebuild the GoogleSignIn instance to clear any cached state
          // This prevents caching issues in the Credential Manager token
          await GoogleSignIn.instance.signOut();
          await GoogleSignIn.instance.disconnect();
          await GoogleSignIn.instance.initialize(
            clientId: EnvironmentConfig.googleIosClientId,
            serverClientId: EnvironmentConfig.googleWebClientId,
          );

          // Retry authentication
          googleUser = await GoogleSignIn.instance.authenticate(
            scopeHint: ['email', 'profile'],
          );
          AppLogger.success(
            'Google user authenticated after retry: ${googleUser.email}',
            context: 'AuthenticationManager',
          );
        } else {
          // Other authentication errors
          AppLogger.error('Google sign-in error: $e', context: 'AuthenticationManager');
          rethrow;
        }
      }

      // Step 3: Get Google ID token from authentication property
      // In v7, only idToken is available here
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        AppLogger.error('Missing Google ID token', context: 'AuthenticationManager');
        throw const AuthException('Missing Google ID token');
      }

      // Step 4: Get access token via authorization client
      // In v7, accessToken must be obtained via authorizationClient
      final GoogleSignInClientAuthorization? clientAuth =
          await googleUser.authorizationClient.authorizationForScopes(['email', 'profile']);

      if (clientAuth == null) {
        AppLogger.error('Failed to obtain Google access token', context: 'AuthenticationManager');
        throw const AuthException('Failed to obtain Google access token');
      }

      final String accessToken = clientAuth.accessToken;

      AppLogger.success('Google tokens obtained', context: 'AuthenticationManager');

      // Step 5: Store Google user information before Supabase sign-in
      await _storeGoogleUserInfo(googleUser);

      // Step 6: Sign in with Supabase using Google tokens
      AppLogger.info('Signing in with Supabase using Google tokens', context: 'AuthenticationManager');
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      AppLogger.success('Supabase Google sign-in successful', context: 'AuthenticationManager');
      AppLogger.debug('User: ${response.user?.email ?? 'No email'}', context: 'AuthenticationManager');
      AppLogger.debug('Session: ${response.session != null ? 'Active' : 'None'}', context: 'AuthenticationManager');
      
      return response;
    });
  }
  
  /// Store Google user information securely - equivalent to iOS Keychain storage
  Future<void> _storeGoogleUserInfo(GoogleSignInAccount googleUser) async {
    try {
      AppLogger.debug('Extracting Google user data', context: 'AuthenticationManager');
      
      // Extract name information (Google provides displayName, not separate first/last names)
      final displayName = googleUser.displayName ?? '';
      final nameParts = displayName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      AppLogger.debug('Google data extracted:', context: 'AuthenticationManager');
      AppLogger.debug('  - Display Name: $displayName', context: 'AuthenticationManager');
      AppLogger.debug('  - First Name: $firstName', context: 'AuthenticationManager');
      AppLogger.debug('  - Last Name: $lastName', context: 'AuthenticationManager');
      AppLogger.debug('  - Email: ${googleUser.email}', context: 'AuthenticationManager');
      AppLogger.debug('  - Photo URL: ${googleUser.photoUrl ?? 'Not provided'}', context: 'AuthenticationManager');
      
      // Store user information securely
      if (firstName.isNotEmpty) {
        await storage.write(key: 'firstName', value: firstName);
        AppLogger.storage('Stored Google first name securely', context: 'AuthenticationManager');
      }
      
      if (lastName.isNotEmpty) {
        await storage.write(key: 'lastName', value: lastName);
        AppLogger.storage('Stored Google last name securely', context: 'AuthenticationManager');
      }
      
      await storage.write(key: 'email', value: googleUser.email);
      AppLogger.storage('Stored Google email securely', context: 'AuthenticationManager');
      
      // Store Google-specific data
      if (googleUser.photoUrl != null && googleUser.photoUrl!.isNotEmpty) {
        await storage.write(key: 'avatarUrl', value: googleUser.photoUrl!);
        AppLogger.storage('Stored Google avatar URL securely', context: 'AuthenticationManager');
      }
      
      // Store Google user identifier for future reference
      await storage.write(key: 'googleUserIdentifier', value: googleUser.id);
      AppLogger.storage('Stored Google user identifier securely', context: 'AuthenticationManager');
      
      // Store provider information
      await storage.write(key: 'auth_provider', value: 'google');
      AppLogger.storage('Stored authentication provider securely', context: 'AuthenticationManager');
      
    } catch (error) {
      AppLogger.warning('Failed to store Google user info: $error', context: 'AuthenticationManager');
      // Continue with authentication even if storage fails
    }
  }

  // MARK: - Sign Out

  /// Sign out from Supabase and clear all stored user data
  /// 
  /// This method performs a complete sign-out including:
  /// - Supabase session termination
  /// - Secure storage cleanup
  /// - Google sign-in cleanup (if applicable)
  Future<void> signOut() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Starting sign-out process', context: 'AuthenticationManager');
      
      try {
        // Step 1: Sign out from Supabase
        await client.auth.signOut();
        AppLogger.success('Supabase sign-out successful', context: 'AuthenticationManager');
      } catch (supabaseError) {
        AppLogger.warning('Supabase sign-out error (continuing): $supabaseError', context: 'AuthenticationManager');
        // Continue with cleanup even if Supabase sign-out fails
      }
      
      try {
        // Step 2: Clear stored user data
        await BaseSupabaseManager.clearStoredUserData();
        AppLogger.success('Stored user data cleared', context: 'AuthenticationManager');
      } catch (storageError) {
        AppLogger.warning('Storage cleanup error (continuing): $storageError', context: 'AuthenticationManager');
        // Continue even if storage cleanup fails
      }
      
      try {
        // Step 3: Sign out from Google (if applicable)
        // Initialize GoogleSignIn first (required in v7)
        await GoogleSignIn.instance.initialize(
          clientId: EnvironmentConfig.googleIosClientId,
          serverClientId: EnvironmentConfig.googleWebClientId,
        );

        // Check if user is currently signed in and sign out
        await GoogleSignIn.instance.signOut();
        AppLogger.success('Google sign-out successful', context: 'AuthenticationManager');
      } catch (googleError) {
        AppLogger.warning('Google sign-out error (continuing): $googleError', context: 'AuthenticationManager');
        // Continue even if Google sign-out fails
      }
      
      AppLogger.success('Sign-out process completed', context: 'AuthenticationManager');
    });
  }
  
  /// Dispose this manager and clean up resources.
  void dispose() {
    disposeResources('AuthenticationManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!.disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}