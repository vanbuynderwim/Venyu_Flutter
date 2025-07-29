import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';
import '../core/utils/device_info.dart';
import '../models/models.dart';
import '../models/requests/update_name_request.dart';

/// Centralized manager for all Supabase database operations and authentication.
/// 
/// This singleton class provides a comprehensive interface to Supabase functionality
/// including authentication (Apple, LinkedIn), profile management, and database operations.
/// Designed as a direct equivalent to the iOS SupabaseManager with identical API patterns.
/// 
/// Key features:
/// - OAuth authentication with Apple and LinkedIn
/// - Secure user data storage and retrieval
/// - Profile and tag group management
/// - Error handling and logging
/// - Singleton pattern with dependency injection support
/// 
/// Example usage:
/// ```dart
/// // Initialize the manager
/// await SupabaseManager.shared.initialize();
/// 
/// // Authenticate with Apple
/// final response = await SupabaseManager.shared.signInWithApple();
/// 
/// // Fetch user profile
/// final profile = await SupabaseManager.shared.fetchUserProfile();
/// 
/// // Update profile information
/// await SupabaseManager.shared.updateProfileName(updateRequest);
/// ```
/// 
/// See also:
/// * [SessionManager] for authentication state management
class SupabaseManager {
  static SupabaseManager? _instance;
  
  /// The global singleton instance of [SupabaseManager].
  /// 
  /// Provides convenient access to Supabase functionality throughout the app.
  /// Equivalent to the iOS `shared` property pattern.
  static SupabaseManager get shared {
    _instance ??= SupabaseManager._internal();
    return _instance!;
  }
  
  /// Factory constructor supporting dependency injection.
  /// 
  /// Returns the singleton instance by default, but allows for custom
  /// instances during testing or when specific configurations are needed.
  factory SupabaseManager() => shared;
  
  /// Private constructor for singleton pattern.
  /// 
  /// Prevents external instantiation and ensures only one instance exists.
  SupabaseManager._internal();
  
  late final SupabaseClient _client;
  static const _storage = FlutterSecureStorage();
  bool _isInitialized = false;
  
  /// Direct access to the underlying [SupabaseClient] instance.
  /// 
  /// Provides low-level access to Supabase functionality when needed.
  /// Most operations should use the higher-level methods provided by this class.
  SupabaseClient get client => _client;
  
  /// Whether the SupabaseManager has been properly initialized.
  /// 
  /// Returns true if [initialize] has been called successfully.
  /// All other methods require initialization to be completed first.
  bool get isInitialized => _isInitialized;
  
  /// Initialize Supabase with schema configuration - equivalent to iOS SupabaseClient initialization
  /// 
  /// This method handles the complete Supabase setup including schema configuration.
  /// Must be called before using any Supabase functionality.
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ SupabaseManager already initialized, skipping');
      return;
    }
    
    debugPrint('🚀 Initializing Supabase with schema configuration...');
    
    try {
      // Initialize Supabase with secure configuration and schema - exact equivalent of iOS implementation
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        postgrestOptions: const PostgrestClientOptions(
          schema: 'venyu_api_v1', // Same schema as iOS: .init(schema: "venyu_api_v1")
        ),
      );
      
      // Set the client reference
      _client = Supabase.instance.client;
      _isInitialized = true;
      
      debugPrint('✅ SupabaseManager initialized with schema: venyu_api_v1');
      debugPrint('🔗 URL: ${AppConfig.supabaseUrl}');
      
    } catch (error) {
      debugPrint('❌ Failed to initialize Supabase: $error');
      rethrow;
    }
  }
  
  // MARK: - Authentication Methods
  
  /// Performs LinkedIn sign in - equivalent to iOS signInWithlinkedIn
  /// 
  /// This method follows the same pattern as the iOS implementation:
  /// 1. Initiate OAuth flow with LinkedIn OpenID Connect
  /// 2. Handle deep link redirect via custom URL scheme
  /// 3. Extract LinkedIn user identity data
  /// 4. Store user information securely
  /// 5. Return session for further processing
  Future<AuthResponse> signInWithLinkedIn() async {
    try {
      debugPrint('💼 Starting LinkedIn sign-in process');
      
      // Step 1: Start OAuth flow with LinkedIn OIDC (equivalent to iOS implementation)
      await _executeAuthenticatedRequest(() async {
        return await _client.auth.signInWithOAuth(
          OAuthProvider.linkedinOidc,
          redirectTo: 'com.getvenyu.app://callback', // Same redirect as iOS
          authScreenLaunchMode: LaunchMode.externalApplication, // Launch in external browser
          scopes: 'openid profile email', // Same scopes as iOS
        );
      });
      
      debugPrint('🔗 LinkedIn OAuth initiated successfully');
      
      // For OAuth flows, we need to return a placeholder response
      // The actual authentication completion will happen via deep link callback
      return AuthResponse(
        user: null,
        session: null,
      );
      
    } catch (error) {
      debugPrint('❌ LinkedIn sign-in error: $error');
      _trackError('LinkedIn Sign-In Failed', error);
      rethrow;
    }
  }
  
  /// Process LinkedIn authentication callback - equivalent to iOS identity processing
  /// 
  /// This method handles the deep link callback and extracts user data,
  /// matching the iOS implementation's identity processing logic.
  Future<void> processLinkedInCallback() async {
    try {
      debugPrint('📥 Processing LinkedIn callback');
      
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException('No authenticated user found after LinkedIn callback');
      }
      
      // Step 2: Find LinkedIn identity (equivalent to iOS identity extraction)
      final linkedInIdentity = user.userMetadata;
      if (linkedInIdentity == null || linkedInIdentity.isEmpty) {
        throw const AuthException('No LinkedIn identity found in user metadata');
      }
      
      debugPrint('👤 LinkedIn identity found, extracting user data');
      
      // Step 3: Extract and store LinkedIn user data (equivalent to iOS toLinkedInUser())
      await _extractAndStoreLinkedInUserData(linkedInIdentity);
      
      debugPrint('✅ LinkedIn authentication and data storage completed');
      
    } catch (error) {
      debugPrint('❌ LinkedIn callback processing error: $error');
      _trackError('LinkedIn Callback Processing Failed', error);
      rethrow;
    }
  }
  
  /// Extract LinkedIn user data - equivalent to iOS toLinkedInUser() extension
  /// 
  /// This method replicates the iOS data extraction logic with the same
  /// field mapping and secure storage approach.
  Future<void> _extractAndStoreLinkedInUserData(Map<String, dynamic> identityData) async {
    try {
      debugPrint('🔍 Extracting LinkedIn user data');
      
      // Extract LinkedIn user information (same fields as iOS)
      final firstName = identityData['given_name'] as String?;
      final lastName = identityData['family_name'] as String?;
      final email = identityData['email'] as String?;
      final pictureUrl = identityData['picture'] as String?;
      final locale = identityData['locale'] as String?;
      final emailVerified = identityData['email_verified'] as bool?;
      
      debugPrint('📊 LinkedIn data extracted:');
      debugPrint('  - First Name: ${firstName ?? 'Not provided'}');
      debugPrint('  - Last Name: ${lastName ?? 'Not provided'}');
      debugPrint('  - Email: ${email ?? 'Not provided'}');
      debugPrint('  - Picture URL: ${pictureUrl ?? 'Not provided'}');
      debugPrint('  - Locale: ${locale ?? 'Not provided'}');
      debugPrint('  - Email Verified: ${emailVerified ?? false}');
      
      // Store user information securely (equivalent to iOS Keychain storage)
      if (firstName != null && firstName.isNotEmpty) {
        await _storage.write(key: 'firstname', value: firstName);
        debugPrint('💾 Stored LinkedIn first name securely');
      }
      
      if (lastName != null && lastName.isNotEmpty) {
        await _storage.write(key: 'lastname', value: lastName);
        debugPrint('💾 Stored LinkedIn last name securely');
      }
      
      if (email != null && email.isNotEmpty) {
        await _storage.write(key: 'email', value: email);
        debugPrint('💾 Stored LinkedIn email securely');
      }
      
      // Store LinkedIn-specific data
      if (pictureUrl != null && pictureUrl.isNotEmpty) {
        await _storage.write(key: 'avatar_url', value: pictureUrl);
        debugPrint('💾 Stored LinkedIn avatar URL securely');
      }
      
      if (locale != null && locale.isNotEmpty) {
        await _storage.write(key: 'locale', value: locale);
        debugPrint('💾 Stored LinkedIn locale securely');
      }
      
      // Store provider information
      await _storage.write(key: 'auth_provider', value: 'linkedin');
      debugPrint('💾 Stored authentication provider securely');
      
    } catch (error) {
      debugPrint('⚠️ Failed to store LinkedIn user data: $error');
      // Continue with authentication even if storage fails
    }
  }
  
  /// Performs Apple sign in - equivalent to iOS signinWithApple
  /// 
  /// This method follows the same pattern as the iOS implementation:
  /// 1. Generate secure nonce
  /// 2. Get Apple ID credential with nonce
  /// 3. Store user information securely
  /// 4. Sign in with Supabase using ID token
  /// 5. Return session for further processing
  Future<AuthResponse> signInWithApple() async {
    try {
      debugPrint('🍎 Starting Apple sign-in process');
      
      // Step 1: Generate secure nonce (equivalent to iOS implementation)
      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      
      debugPrint('🔐 Nonce generated for Apple sign-in');
      
      // Step 2: Get Apple ID credential with nonce
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      
      debugPrint('📱 Apple credential obtained');
      debugPrint('User ID: ${credential.userIdentifier}');
      debugPrint('Email: ${credential.email ?? 'Not provided'}');
      debugPrint('Given Name: ${credential.givenName ?? 'Not provided'}');
      debugPrint('Family Name: ${credential.familyName ?? 'Not provided'}');
      
      // Step 3: Store user information securely (equivalent to iOS Keychain storage)
      await _storeAppleUserInfo(credential);
      
      // Step 4: Validate ID token
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('Could not find ID Token from generated credential.');
      }
      
      // Step 5: Sign in with Supabase using Apple ID token
      debugPrint('🚀 Signing in with Supabase');
      final response = await _executeAuthenticatedRequest(() async {
        return await _client.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      });
      
      debugPrint('✅ Supabase Apple sign-in successful');
      debugPrint('User: ${response.user?.email ?? 'No email'}');
      debugPrint('Session: ${response.session != null ? 'Active' : 'None'}');
      
      return response;
      
    } catch (error) {
      debugPrint('❌ Apple sign-in error: $error');
      
      // Error tracking equivalent to iOS Bugsnag integration
      _trackError('Apple Sign-In Failed', error);
      
      rethrow;
    }
  }
  
  // MARK: - Private Helper Methods
  
  /// Store Apple user information securely - equivalent to iOS Keychain storage
  Future<void> _storeAppleUserInfo(AuthorizationCredentialAppleID credential) async {
    try {
      // Store first name if available
      if (credential.givenName != null && credential.givenName!.isNotEmpty) {
        await _storage.write(
          key: 'firstname',
          value: credential.givenName!,
        );
        debugPrint('💾 Stored first name securely');
      }
      
      // Store last name if available
      if (credential.familyName != null && credential.familyName!.isNotEmpty) {
        await _storage.write(
          key: 'lastname', 
          value: credential.familyName!,
        );
        debugPrint('💾 Stored last name securely');
      }
      
      // Store email if available
      if (credential.email != null && credential.email!.isNotEmpty) {
        await _storage.write(
          key: 'email',
          value: credential.email!,
        );
        debugPrint('💾 Stored email securely');
      }
      
      // Store user identifier
      await _storage.write(
        key: 'apple_user_id',
        value: credential.userIdentifier,
      );
      debugPrint('💾 Stored Apple user ID securely');
      
    } catch (error) {
      debugPrint('⚠️ Failed to store Apple user info: $error');
      // Continue with authentication even if storage fails
    }
  }
  
  /// Centralized error handling wrapper - equivalent to iOS executeAuthenticatedRequest
  /// 
  /// This method wraps all authenticated requests with consistent error handling,
  /// logging, and error tracking - matching the iOS implementation pattern.
  Future<T> _executeAuthenticatedRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on AuthException catch (error) {
      debugPrint('🔐 Authentication error: ${error.message}');
      _trackError('Authentication Error', error);
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint('🗄️ Database error: ${error.message}');
      _trackError('Database Error', error);
      rethrow;
    } catch (error) {
      debugPrint('💥 Unexpected error: $error');
      _trackError('Unexpected Error', error);
      rethrow;
    }
  }
  
  /// Error tracking method - equivalent to iOS Bugsnag integration
  /// 
  /// In production, this should integrate with crash reporting services
  /// like Firebase Crashlytics, Sentry, or Bugsnag.
  void _trackError(String context, dynamic error) {
    if (kDebugMode) {
      debugPrint('🐛 Error tracked: $context - $error');
    }
    
    // TODO: Integrate with crash reporting service
    // Examples:
    // FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    // Sentry.captureException(error, stackTrace: stack);
  }
  
  // MARK: - Utility Methods (to be expanded)
  
  /// Retrieves user information stored in secure local storage.
  /// 
  /// Returns a map containing:
  /// - 'firstname': User's first name
  /// - 'lastname': User's last name  
  /// - 'email': User's email address
  /// - 'apple_user_id': Apple user identifier (if signed in with Apple)
  /// 
  /// Values will be null if not previously stored or if retrieval fails.
  Future<Map<String, String?>> getStoredUserInfo() async {
    try {
      return {
        'firstname': await _storage.read(key: 'firstname'),
        'lastname': await _storage.read(key: 'lastname'),
        'email': await _storage.read(key: 'email'),
        'apple_user_id': await _storage.read(key: 'apple_user_id'),
      };
    } catch (error) {
      debugPrint('⚠️ Failed to read stored user info: $error');
      return {};
    }
  }
  
  // MARK: - Profile Management Methods
  
  /// Fetch user profile from database - equivalent to iOS fetchUserProfile()
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Creates payload with device information (country, language, app version)
  /// 2. Calls the get_my_profile RPC function with the payload
  /// 3. Returns the Profile object from the response
  Future<Profile> fetchUserProfile() async {
    debugPrint('📥 Fetching user profile via RPC call');
    
    // Create payload with device information - exact equivalent of iOS UpdateCountryAndLanguageRequest
    final payload = UpdateCountryAndLanguageRequest(
      countryCode: DeviceInfo.detectCountry(),
      languageCode: DeviceInfo.detectLanguage(),
      appVersion: await DeviceInfo.detectAppVersion(),
    );
    
    debugPrint('🔍 Profile fetch payload: $payload');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_my_profile RPC function - exact equivalent of iOS implementation
      // The schema is already configured globally in main.dart (venyu_api_v1)
      final result = await _client
          .rpc('get_my_profile', params: {'payload': payload.toJson()})
          .select()
          .single();
      
      debugPrint('✅ Profile RPC call successful');
      debugPrint('📋 Profile data received: ${result.toString()}');
      
      // Convert response to Profile object
      final profile = Profile.fromJson(result);
      debugPrint('👤 Profile parsed: ${profile.displayName} (${profile.contactEmail})');
      
      return profile;
    });
  }
  
  /// Signs out the current user and clears all stored data.
  /// 
  /// This method:
  /// 1. Signs out from Supabase authentication
  /// 2. Clears all secure storage data
  /// 3. Resets the authentication state
  /// 
  /// Should be called when the user explicitly signs out or when
  /// authentication errors require a fresh start.
  Future<void> signOut() async {
    try {
      debugPrint('👋 Starting sign out process');
      
      await _executeAuthenticatedRequest(() async {
        await _client.auth.signOut();
      });
      
      // Clear stored user information
      await _storage.deleteAll();
      
      debugPrint('✅ Sign out successful');
    } catch (error) {
      debugPrint('❌ Sign out error: $error');
      _trackError('Sign Out Failed', error);
      rethrow;
    }
  }
  
  /// Whether a user is currently authenticated.
  /// 
  /// Returns true if there's an active Supabase session with a valid user.
  bool get isAuthenticated => _client.auth.currentUser != null;
  
  /// The currently authenticated user, if any.
  /// 
  /// Returns null if no user is signed in or if the session has expired.
  User? get currentUser => _client.auth.currentUser;
  
  /// The current authentication session, if any.
  /// 
  /// Contains access tokens and session metadata. Returns null if not authenticated.
  Session? get currentSession => _client.auth.currentSession;
  
  // MARK: - TagGroup Management Methods
  
  /// Fetch tag groups by category type - equivalent to iOS fetchTagGroups(type:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the get_taggroups RPC function with category type parameter
  /// 2. Returns a list of TagGroup objects from the response
  Future<List<TagGroup>> fetchTagGroups(CategoryType type) async {
    debugPrint('📥 Fetching tag groups for category: ${type.name}');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_taggroups RPC function - exact equivalent of iOS implementation
      // The schema is already configured globally in main.dart (venyu_api_v1)
      final result = await _client
          .rpc('get_taggroups', params: {'p_category_type': type.name})
          .select();
      
      debugPrint('✅ TagGroups RPC call successful');
      debugPrint('📋 TagGroups data received: ${result.length} groups');
      
      // Convert response to list of TagGroup objects
      final tagGroups = (result as List)
          .map((json) => TagGroup.fromJson(json))
          .toList();
      
      debugPrint('🏷️ TagGroups parsed: ${tagGroups.length} groups');
      
      return tagGroups;
    });
  }
  
  /// Get icon URL from Supabase storage - equivalent to iOS getIcon(icon:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Constructs filename with .png extension
  /// 2. Gets public URL from icons storage bucket
  /// 3. Returns the URL or null if failed
  String? getIcon(String icon) {
    try {
      final fileName = '$icon.png';
      
      final url = _client.storage
          .from(RemoteImagePath.icons.value)
          .getPublicUrl(fileName);
      
      debugPrint('📷 Generated icon URL for $icon: $url');
      return url;
      
    } catch (error) {
      debugPrint('❌ Failed to get icon URL for $icon: $error');
      _trackError('Icon URL Generation Failed', error);
      return null;
    }
  }
  
  /// Fetch single tag group by code - equivalent to iOS fetchTagGroup(taggroup:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the get_taggroup RPC function with code parameter
  /// 2. Returns a single TagGroup with updated tags
  Future<TagGroup> fetchTagGroup(TagGroup tagGroup) async {
    debugPrint('📥 Fetching tag group: ${tagGroup.code}');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_taggroup RPC function with code parameter
      final result = await _client
          .rpc('get_taggroup', params: {'p_code': tagGroup.code})
          .select()
          .single();
      
      debugPrint('✅ TagGroup RPC call successful');
      debugPrint('📋 TagGroup data received: ${result.toString()}');
      
      // Convert response to TagGroup object
      final updatedTagGroup = TagGroup.fromJson(result);
      debugPrint('🏷️ TagGroup parsed: ${updatedTagGroup.label} with ${updatedTagGroup.tags?.length ?? 0} tags');
      
      return updatedTagGroup;
    });
  }
  
  /// Upsert multiple profile tags - equivalent to iOS upsertProfileTags(code:tags:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Creates payload with code and array of tag IDs
  /// 2. Calls the upsert_profile_tags RPC function
  Future<void> upsertProfileTags(String code, List<Tag> tags) async {
    debugPrint('📤 Upserting profile tags for code: $code with ${tags.length} tags');
    
    final payload = {
      'code': code,
      'value_ids': tags.map((tag) => tag.id).toList(),
    };
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('upsert_profile_tags', params: {'payload': payload});
      
      debugPrint('✅ Profile tags upserted successfully');
      debugPrint('📋 Upserted ${tags.length} tags for code: $code');
    });
  }
  
  /// Upsert single profile tag - equivalent to iOS upsertProfileTag(code:tag:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Creates payload with code and single tag ID
  /// 2. Calls the upsert_profile_tag RPC function
  Future<void> upsertProfileTag(String code, Tag tag) async {
    debugPrint('📤 Upserting profile tag for code: $code with tag: ${tag.label}');
    
    final payload = {
      'code': code,
      'value_id': tag.id,
    };
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('upsert_profile_tag', params: {'payload': payload});
      
      debugPrint('✅ Profile tag upserted successfully');
      debugPrint('📋 Upserted tag: ${tag.label} for code: $code');
    });
  }

  /// Update profile name and LinkedIn URL - equivalent to iOS updateProfileName(updateNameRequest:)
  /// 
  /// This method updates the user's profile with new name and LinkedIn information:
  /// 1. Creates payload from UpdateNameRequest
  /// 2. Calls the update_profile_name RPC function
  Future<void> updateProfileName(UpdateNameRequest updateNameRequest) async {
    debugPrint('📤 Updating profile name: ${updateNameRequest.firstName} ${updateNameRequest.lastName}');
    debugPrint('📤 LinkedIn URL: ${updateNameRequest.linkedInURL}');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('update_profile_name', params: {'payload': updateNameRequest.toJson()});
      
      debugPrint('✅ Profile name updated successfully');
      debugPrint('📋 Updated: ${updateNameRequest.firstName} ${updateNameRequest.lastName}');
    });
  }

  /// Update company information - equivalent to iOS updateCompanyInfo(updateCompanyRequest:)
  /// 
  /// This method updates the user's company name and website URL:
  /// 1. Creates payload from UpdateCompanyRequest
  /// 2. Calls the update_company_info RPC function
  Future<void> updateCompanyInfo(UpdateCompanyRequest updateCompanyRequest) async {
    debugPrint('📤 Updating company info: ${updateCompanyRequest.companyName}');
    debugPrint('📤 Website URL: ${updateCompanyRequest.websiteURL}');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('update_company_info', params: {'payload': updateCompanyRequest.toJson()});
      
      debugPrint('✅ Company info updated successfully');
      debugPrint('📋 Updated: ${updateCompanyRequest.companyName} - ${updateCompanyRequest.websiteURL}');
    });
  }

  /// Update profile bio - equivalent to iOS updateProfileBio(bio:)
  /// 
  /// This method updates the user's profile bio:
  /// 1. Calls the update_profile_bio RPC function with bio parameter
  Future<void> updateProfileBio(String bio) async {
    debugPrint('📤 Updating profile bio (${bio.length} chars)');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('update_profile_bio', params: {'p_bio': bio});
      
      debugPrint('✅ Profile bio updated successfully');
    });
  }

  /// Fetch user's profile cards - equivalent to iOS fetchCards()
  /// 
  /// This method retrieves the current user's prompt cards:
  /// 1. Calls the get_profile_cards RPC function
  /// 2. Returns list of Prompt objects
  Future<List<Prompt>> fetchCards() async {
    debugPrint('📥 Fetching user profile cards');
    
    return await _executeAuthenticatedRequest(() async {
      final List<dynamic> data = await _client.rpc('get_profile_cards');
      final cards = data.map((json) => Prompt.fromJson(json as Map<String, dynamic>)).toList();
      
      debugPrint('✅ Fetched ${cards.length} profile cards');
      return cards;
    });
  }
}