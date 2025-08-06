import 'dart:convert';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../core/config/app_config.dart';
import '../core/utils/device_info.dart';
import '../models/models.dart';
import '../models/requests/update_name_request.dart';
import '../models/requests/update_prompt_status_requests.dart';
import '../models/requests/verify_otp_request.dart';

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
      
    } catch (error, stackTrace) {
      debugPrint('❌ Failed to initialize Supabase: $error');
      _trackError('Supabase Initialization Failed', error, stackTrace);
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
      
    } catch (error, stackTrace) {
      debugPrint('❌ LinkedIn sign-in error: $error');
      _trackError('LinkedIn Sign-In Failed', error, stackTrace);
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
      
    } catch (error, stackTrace) {
      debugPrint('❌ LinkedIn callback processing error: $error');
      _trackError('LinkedIn Callback Processing Failed', error, stackTrace);
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
      
    } catch (error, stackTrace) {
      debugPrint('⚠️ Failed to store LinkedIn user data: $error');
      _trackError('LinkedIn Data Storage Failed', error, stackTrace);
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
      
    } catch (error, stackTrace) {
      debugPrint('❌ Apple sign-in error: $error');
      
      // Error tracking equivalent to iOS Bugsnag integration
      _trackError('Apple Sign-In Failed', error, stackTrace);
      
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
      
    } catch (error, stackTrace) {
      debugPrint('⚠️ Failed to store Apple user info: $error');
      _trackError('Apple Data Storage Failed', error, stackTrace);
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
    } on AuthException catch (error, stackTrace) {
      debugPrint('🔐 Authentication error: ${error.message}');
      _trackError('Authentication Error', error, stackTrace);
      rethrow;
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('🗄️ Database error: ${error.message}');
      _trackError('Database Error', error, stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('💥 Unexpected error: $error');
      _trackError('Unexpected Error', error, stackTrace);
      rethrow;
    }
  }
  
  /// Error tracking method with Bugsnag integration
  /// 
  /// This method tracks all server-side errors to Bugsnag for monitoring
  /// and debugging purposes, matching the iOS implementation.
  void _trackError(String context, dynamic error, [StackTrace? stackTrace]) async {
    if (kDebugMode) {
      debugPrint('🐛 Error tracked: $context - $error');
    }
    
    // Track error with Bugsnag
    try {
      await bugsnag.notify(error, stackTrace);
      debugPrint('✅ Error sent to Bugsnag: $context');
    } catch (bugsnagError) {
      debugPrint('⚠️ Failed to send error to Bugsnag: $bugsnagError');
    }
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
    } catch (error, stackTrace) {
      debugPrint('⚠️ Failed to read stored user info: $error');
      _trackError('Read User Info Failed', error, stackTrace);
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
    } catch (error, stackTrace) {
      debugPrint('❌ Sign out error: $error');
      _trackError('Sign Out Failed', error, stackTrace);
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

  /// Fetch all available tag groups from the database.
  /// 
  /// This method retrieves all tag groups regardless of category type.
  /// Equivalent to iOS fetchAllTagGroups() method.
  /// Should be called once at app startup to cache all available tag groups.
  /// 
  /// Returns a list of all [TagGroup] objects available in the system.
  /// 
  /// Throws [Exception] if the request fails or user is not authenticated.
  Future<List<TagGroup>> fetchAllTagGroups() async {
    debugPrint('📥 Fetching all tag groups from database');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_all_taggroups RPC function
      final result = await _client
          .rpc('get_all_taggroups')
          .select();
      
      debugPrint('✅ All TagGroups RPC call successful');
      debugPrint('📋 All TagGroups data received: ${result.length} groups');
      
      // Convert response to list of TagGroup objects
      final tagGroups = (result as List)
          .map((json) => TagGroup.fromJson(json))
          .toList();
      
      debugPrint('🏷️ All TagGroups parsed: ${tagGroups.length} groups');
      
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
      
    } catch (error, stackTrace) {
      debugPrint('❌ Failed to get icon URL for $icon: $error');
      _trackError('Icon URL Generation Failed', error, stackTrace);
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

  /// Update profile location - equivalent to iOS updateProfileLocation(latitude:longitude:)
  /// 
  /// This method updates the user's location coordinates:
  /// 1. Only proceeds if both latitude and longitude are provided
  /// 2. Calls the update_profile_location RPC function with coordinates
  Future<void> updateProfileLocation({double? latitude, double? longitude}) async {
    if (latitude != null && longitude != null) {
      debugPrint('📤 Updating profile location: lat=$latitude, lon=$longitude');
      
      return await _executeAuthenticatedRequest(() async {
        await _client
            .rpc('update_profile_location', params: {
              'latitude': latitude,
              'longitude': longitude,
            });
        
        debugPrint('✅ Profile location updated successfully');
      });
    } else {
      debugPrint('⚠️ Profile location not updated - missing coordinates');
    }
  }

  /// Complete user registration - equivalent to iOS completeRegistration()
  /// 
  /// This method marks the user's registration as complete:
  /// 1. Calls the complete_registration RPC function
  /// 2. Updates the user's registered_at timestamp
  Future<void> completeRegistration() async {
    debugPrint('📤 Completing user registration');
    
    return await _executeAuthenticatedRequest(() async {
      await _client.rpc('complete_registration');
      
      debugPrint('✅ Registration completed successfully');
    });
  }

  /// Send OTP verification code to email address - equivalent to iOS sendContactEmailOTP(email:)
  /// 
  /// This method sends a 6-digit OTP code to the specified email address:
  /// 1. Calls the send_mail_otp RPC function with email parameter
  Future<void> sendContactEmailOTP(String email) async {
    debugPrint('📤 Sending email OTP to: $email');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('send_mail_otp', params: {'p_email': email});
      
      debugPrint('✅ Email OTP sent successfully to: $email');
    });
  }

  /// Verify email OTP code and update contact email - equivalent to iOS verifyEmailOTP(request:)
  /// 
  /// This method verifies the OTP code and updates the user's contact email:
  /// 1. Creates payload from VerifyOTPRequest
  /// 2. Calls the verify_mail_otp RPC function
  Future<void> verifyEmailOTP(VerifyOTPRequest request) async {
    debugPrint('📤 Verifying email OTP for: ${request.email}');
    debugPrint('📤 Newsletter subscription: ${request.subscribed}');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('verify_mail_otp', params: {'payload': request.toJson()});
      
      debugPrint('✅ Email OTP verified and contact email updated successfully');
      debugPrint('📋 Email: ${request.email}, Subscribed: ${request.subscribed}');
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

  /// Get remote image URL with transformations - equivalent to iOS getRemoteImage(ID:height:location:)
  /// 
  /// This method generates a public URL for an image with transformations:
  /// 1. Constructs filename from UUID with .jpg extension
  /// 2. Gets public URL from specified storage bucket with transform options
  /// 3. Returns the URL or null if failed
  Future<String?> getRemoteImage({
    required String id,
    required int height,
    RemoteImagePath location = RemoteImagePath.avatars,
  }) async {
    try {
      final fileName = '${id.toUpperCase()}.jpg';
          
      final url = _client.storage
          .from(location.value)
          .getPublicUrl(
            fileName,
            transform: TransformOptions(
              height: height * 3,
              width: height * 3,          // expliciet vierkant maken
              resize: ResizeMode.cover, 
              quality: 100,
            ),
          );

      debugPrint('📷 Generated remote image URL: $url');
      
      return url;
      
    } catch (error, stackTrace) {
      _trackError('Remote Image URL Generation Failed', error, stackTrace);
      return null;
    }
  }

  // MARK: - Match Management Methods

  /// Fetch matches with pagination - equivalent to iOS fetchMatches(paginatedRequest:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the get_matches RPC function with paginated request payload
  /// 2. Returns a list of Match objects from the response
  Future<List<Match>> fetchMatches(PaginatedRequest paginatedRequest) async {
    debugPrint('📥 Fetching matches with pagination: $paginatedRequest');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_matches RPC function - exact equivalent of iOS implementation
      final result = await _client
          .rpc('get_matches', params: {'payload': paginatedRequest.toJson()})
          .select();
      
      debugPrint('✅ Matches RPC call successful');
      debugPrint('📋 Matches data received: ${result.length} matches');
      
      // Convert response to list of Match objects
      final matches = (result as List)
          .map((json) => Match.fromJson(json))
          .toList();
      
      debugPrint('🤝 Matches parsed: ${matches.length} matches');
      
      return matches;
    });
  }

  /// Fetch notifications with pagination - equivalent to iOS fetchNotifications(paginatedRequest:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the get_notifications RPC function with paginated request payload
  /// 2. Returns a list of Notification objects from the response
  Future<List<Notification>> fetchNotifications(PaginatedRequest paginatedRequest) async {
    debugPrint('📥 Fetching notifications with pagination: $paginatedRequest');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_notifications RPC function - exact equivalent of iOS implementation
      final result = await _client
          .rpc('get_notifications', params: {'payload': paginatedRequest.toJson()})
          .select();
      
      debugPrint('✅ Notifications RPC call successful');
      debugPrint('📋 Notifications data received: ${result.length} notifications');
      
      // Convert response to list of Notification objects
      final notifications = (result as List)
          .map((json) => Notification.fromJson(json))
          .toList();
      
      debugPrint('🔔 Notifications parsed: ${notifications.length} notifications');
      
      return notifications;
    });
  }

  /// Fetch pending reviews with pagination - equivalent to iOS fetchPendingReviews(paginatedRequest:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the appropriate RPC function (get_pending_user_reviews or get_pending_system_reviews)
  /// 2. Returns a list of Prompt objects from the response
  Future<List<Prompt>> fetchPendingReviews(PaginatedRequest paginatedRequest) async {
    debugPrint('📥 Fetching pending reviews with pagination: $paginatedRequest');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the appropriate RPC function based on the list type
      final result = await _client
          .rpc(paginatedRequest.list.value, params: {'payload': paginatedRequest.toJson()})
          .select();
      
      debugPrint('✅ Pending reviews RPC call successful');
      debugPrint('📋 Pending reviews raw result: $result');
      
      // Handle empty result
      if (result.isEmpty) {
        debugPrint('⚠️ RPC returned empty list');
        return <Prompt>[];
      }
      
      final resultList = result as List<dynamic>;
      debugPrint('📋 Pending reviews data received: ${resultList.length} prompts');
      
      // Parse the data as List<Prompt>
      final prompts = resultList
          .map((promptData) => Prompt.fromJson(promptData as Map<String, dynamic>))
          .toList();
      
      debugPrint('🃏 Prompts parsed: ${prompts.length} prompts');
      
      return prompts;
    });
  }

  /// Update prompt status for multiple prompts - batch operation
  /// 
  /// This method matches the iOS updatePromptStatusBatch implementation
  Future<void> updatePromptStatusBatch(List<String> promptIds, PromptStatus status) async {
    debugPrint('📝 Updating prompt status batch: ${promptIds.length} prompts to ${status.value}');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the update_prompt_statuses_batch RPC function with payload wrapper
      final request = UpdatePromptStatusBatch(
        promptIds: promptIds,
        status: status,
      );
      
      await _client.rpc('update_prompt_statuses_batch', params: {
        'payload': request.toJson(),
      });
      
      debugPrint('✅ Prompt status batch update successful');
    });
  }

  /// Update prompt status by review type - update all prompts of a review type
  /// 
  /// This method matches the iOS updatePromptStatusByReviewType implementation
  Future<void> updatePromptStatusByReviewType(ReviewType reviewType, PromptStatus status) async {
    debugPrint('📝 Updating all prompts of review type ${reviewType.value} to ${status.value}');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the update_all_prompts_by_review_type RPC function with payload wrapper
      final request = UpdatePromptStatusByReviewType(
        reviewType: reviewType,
        status: status,
      );
      
      await _client.rpc('update_all_prompts_by_review_type', params: {
        'payload': request.toJson(),
      });
      
      debugPrint('✅ Prompt status by review type update successful');
    });
  }

  /// Fetch match detail - equivalent to iOS fetchMatchDetail(matchId:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the get_match RPC function with match ID
  /// 2. Returns a single Match object with full details
  Future<Match> fetchMatchDetail(String matchId) async {
    debugPrint('📥 Fetching match detail for ID: $matchId');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the get_match RPC function - exact equivalent of iOS implementation
      final result = await _client
          .rpc('get_match', params: {'p_match_id': matchId})
          .select()
          .single();
      
      debugPrint('✅ Match detail RPC call successful');
      debugPrint('📋 Match detail data received');
      
      // Convert response to Match object
      final match = Match.fromJson(result);
      debugPrint('🤝 Match detail parsed: ${match.profile.fullName}');
      
      return match;
    });
  }

  /// Insert match response - equivalent to iOS insertMatchResponse(request:)
  /// 
  /// This method exactly matches the iOS implementation:
  /// 1. Calls the insert_match_response RPC function with match response payload
  /// 2. Records the user's response (interested/not_interested) to a match
  Future<void> insertMatchResponse(MatchResponseRequest request) async {
    debugPrint('📤 Inserting match response: ${request.matchId} -> ${request.response}');
    
    return await _executeAuthenticatedRequest(() async {
      // Call the insert_match_response RPC function - exact equivalent of iOS implementation
      await _client
          .rpc('insert_match_response', params: {'payload': request.toJson()});
      
      debugPrint('✅ Match response inserted successfully');
      debugPrint('📋 Response: ${request.response.value} for match: ${request.matchId}');
    });
  }

  // MARK: - Avatar Management Methods

  /// Uploads an image to the specified storage bucket.
  /// 
  /// This method exactly matches the iOS uploadImage implementation:
  /// 1. Generates filename using imageID + .jpg extension
  /// 2. Uploads image data to the specified bucket
  /// 3. Sets content type to image/jpeg
  Future<void> uploadImage({
    required Uint8List imageData,
    required String imageID,
    required RemoteImagePath bucket,
  }) async {
    final fileName = '$imageID.jpg';
    
    debugPrint('📤 Uploading image: $fileName to bucket: ${bucket.value}');
    
    try {
      await _client.storage
          .from(bucket.value)
          .uploadBinary(
            fileName,
            imageData,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
      
      debugPrint('✅ Image uploaded successfully: $fileName');
      
    } catch (error, stackTrace) {
      debugPrint('❌ Failed to upload image: $error');
      _trackError('Image Upload Failed', error, stackTrace);
      rethrow;
    }
  }

  /// Updates the user's profile avatar ID in the database.
  /// 
  /// This method exactly matches the iOS updateProfileAvatar implementation:
  /// 1. Calls the update_profile_avatar RPC function
  /// 2. Updates the avatar_id field for the current user
  Future<void> updateProfileAvatar({required String? avatarID}) async {
    debugPrint('📤 Updating profile avatar: $avatarID');
    
    return await _executeAuthenticatedRequest(() async {
      await _client
          .rpc('update_profile_avatar', params: {'p_avatar_id': avatarID});
      
      debugPrint('✅ Profile avatar updated successfully');
    });
  }

  /// Deletes a file from the storage bucket.
  /// 
  /// This method exactly matches the iOS deleteFileFromStorage implementation:
  /// 1. Generates filename using fileID + .jpg extension (uppercase)
  /// 2. Deletes the file from the specified bucket
  Future<void> deleteFileFromStorage({
    required String fileID,
    required RemoteImagePath bucket,
  }) async {
    final fileName = '${fileID.toUpperCase()}.jpg';
    
    debugPrint('🗑️ Deleting file: $fileName from bucket: ${bucket.value}');
    
    try {
      await _client.storage
          .from(bucket.value)
          .remove([fileName]);
      
      debugPrint('✅ File deleted successfully: $fileName');
      
    } catch (error, stackTrace) {
      debugPrint('❌ Failed to delete file: $error');
      _trackError('File Delete Failed', error, stackTrace);
      rethrow;
    }
  }

  /// Uploads and updates user profile avatar (high-level method).
  /// 
  /// This method exactly matches the iOS uploadUserProfileAvatar implementation:
  /// 1. Deletes old avatar if exists (without full delete)
  /// 2. Generates new UUID for avatar
  /// 3. Uploads image data to avatars bucket
  /// 4. Updates profile avatar ID in database
  /// 5. Returns the new avatar ID for local profile update
  Future<String> uploadUserProfileAvatar(Uint8List imageData) async {
    try {
      debugPrint('📤 SupabaseManager: Starting avatar upload');
      
      // Delete old avatar if exists (get current profile first)
      // Note: We don't have direct access to SessionManager here,
      // so this will be handled by the calling code
      
      // Generate new avatar ID
      final avatarID = _generateUUID();
      
      // Upload image to storage
      await uploadImage(
        imageData: imageData,
        imageID: avatarID,
        bucket: RemoteImagePath.avatars,
      );
      
      // Update profile avatar ID in database
      await updateProfileAvatar(avatarID: avatarID);
      
      debugPrint('✅ Avatar upload completed successfully: $avatarID');
      return avatarID;
      
    } catch (error, stackTrace) {
      debugPrint('❌ SupabaseManager: Failed to upload avatar: $error');
      _trackError('Avatar Upload Failed', error, stackTrace);
      rethrow;
    }
  }

  /// Deletes user profile avatar (high-level method).
  /// 
  /// This method exactly matches the iOS deleteProfileAvatar implementation:
  /// 1. Deletes avatar file from storage
  /// 2. If full delete, updates profile avatar ID to null in database
  Future<void> deleteUserProfileAvatar({
    required String avatarID,
    bool isFullDelete = true,
  }) async {
    try {
      debugPrint('🗑️ SupabaseManager: Deleting avatar: $avatarID');
      
      // Delete file from storage
      await deleteFileFromStorage(
        fileID: avatarID,
        bucket: RemoteImagePath.avatars,
      );
      
      if (isFullDelete) {
        // Update profile avatar ID to null in database
        await updateProfileAvatar(avatarID: null);
        debugPrint('✅ Avatar deleted completely');
      } else {
        debugPrint('✅ Avatar file deleted (keeping reference for replacement)');
      }
      
    } catch (error, stackTrace) {
      debugPrint('❌ SupabaseManager: Failed to delete avatar: $error');
      _trackError('Avatar Delete Failed', error, stackTrace);
      
      if (isFullDelete) {
        rethrow;
      }
      // For non-full deletes, we continue with the upload process
    }
  }

  /// Generates a UUID string for avatar IDs.
  /// 
  /// Helper method to generate unique identifiers for avatars.
  /// Equivalent to Swift's UUID().
  String _generateUUID() {
    const uuid = Uuid();
    return uuid.v4().toUpperCase();
  }
}