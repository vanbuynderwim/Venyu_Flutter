
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../core/utils/device_info.dart';
import '../../models/models.dart';
import '../../models/device.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

/// ProfileManager - Handles user profile operations
/// 
/// This manager is responsible for:
/// - Fetching and updating user profiles
/// - Managing profile settings (name, bio, location, company)
/// - Email verification and OTP handling
/// - Profile registration completion
/// - Device token management
/// 
/// Features:
/// - Profile data enhancement with stored OAuth data
/// - Email OTP verification workflow
/// - Location updates with coordinates
/// - Company information management
class ProfileManager extends BaseSupabaseManager with DisposableManagerMixin {
  static ProfileManager? _instance;

  /// The singleton instance of [ProfileManager].
  static ProfileManager get shared {
    _instance ??= ProfileManager._internal();
    return _instance!;
  }

  /// Private constructor for singleton pattern.
  ProfileManager._internal();

  /// Background location listener subscription
  StreamSubscription<LocationData>? _backgroundLocationSubscription;

  /// Fetch the current user's profile with enhanced data
  /// 
  /// This method fetches the user profile from Supabase and enhances it
  /// with stored OAuth data from secure storage.
  Future<Profile> fetchUserProfile() async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching user profile', context: 'ProfileManager');
      
      // Create payload with device information - exact equivalent of iOS UpdateCountryAndLanguageRequest
      final payload = {
        'country_code': await DeviceInfo.detectCountry(),
        'language_code': DeviceInfo.detectLanguage(),
        'app_version': await DeviceInfo.detectAppVersion(),
      };
      
      AppLogger.debug('Profile fetch payload: $payload', context: 'ProfileManager');
      
      // Call the get_my_profile RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc('get_my_profile', params: {'payload': payload})
          .select()
          .single();
      
      AppLogger.success('Profile RPC call successful', context: 'ProfileManager');
      //AppLogger.debug('Profile data received: ${result.toString()}', context: 'ProfileManager');
      
      // Create profile from response
      final profile = Profile.fromJson(result);
      AppLogger.debug('Profile parsed: ${profile.displayName} (${profile.contactEmail}) is_pro: ${profile.isPro}', context: 'ProfileManager');
      
      // Enhance with stored OAuth data
      final enhancedProfile = await _enhanceProfileWithStoredData(profile);
      
      AppLogger.info('Profile enhanced with stored data', context: 'ProfileManager');
      return enhancedProfile;
    });
  }

  /// Enhance profile with stored OAuth data from secure storage
  ///
  /// This method fills in MISSING profile fields with cached OAuth data.
  /// It does NOT override existing database values - database is the source of truth.
  Future<Profile> _enhanceProfileWithStoredData(Profile profile) async {
    try {
      final storedData = await BaseSupabaseManager.getStoredUserInfo();

      // Only use stored OAuth data to fill in empty fields, never override database values
      return profile.copyWith(
        firstName: profile.firstName.isNotEmpty ? profile.firstName : storedData['firstName'],
        lastName: profile.lastName?.isNotEmpty == true ? profile.lastName : storedData['lastName'],
        contactEmail: profile.contactEmail?.isNotEmpty == true ? profile.contactEmail : storedData['email'],
        linkedInURL: profile.linkedInURL?.isNotEmpty == true ? profile.linkedInURL : storedData['linkedInProfileUrl'],
      );
    } catch (error) {
      AppLogger.warning('Failed to enhance profile with stored data: $error', context: 'ProfileManager');
      // Return original profile if enhancement fails
      return profile;
    }
  }

  /// Update RevenueCat app user ID for the current user
  Future<void> updateRevenueCatAppUserId(String rcAppUserId) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating RevenueCat app user ID', context: 'ProfileManager');
      
      await client
          .rpc('update_profile_rc_app_id', params: {
            'p_rc_app_user_id': rcAppUserId,
          });
      
      AppLogger.success('RevenueCat app user ID updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's email address from OAuth provider
  ///
  /// This method is called after OAuth sign-in (Apple/Google) to save
  /// the email address obtained from the authentication provider.
  /// The email is automatically marked as verified since it comes from OAuth.
  Future<void> updateProfileEmail(String email) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile email from OAuth', context: 'ProfileManager');

      await client.rpc('update_profile_email', params: {
        'p_email': email,
      });

      AppLogger.success('Profile email updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's name
  Future<void> updateProfileName(String firstName, String lastName) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile name', context: 'ProfileManager');

      final payload = {
        'first_name': firstName,
        'last_name': lastName,
      };

      await client.rpc('update_profile_name_only', params: {'payload': payload});

      AppLogger.success('Profile name updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's company name
  Future<void> updateCompanyName(String companyName) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating company name', context: 'ProfileManager');

      final payload = {
        'company_name': companyName,
      };

      await client.rpc('update_company_name', params: {'payload': payload});

      AppLogger.success('Company name updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's city
  Future<void> updateProfileCity(String city) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile city', context: 'ProfileManager');

      await client.rpc('update_profile_city', params: {
        'p_city': city,
      });

      AppLogger.success('Profile city updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's bio
  Future<void> updateProfileBio(String bio) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile bio', context: 'ProfileManager');
      
      await client.rpc('update_profile_bio', params: {
        'p_bio': bio,
      });
      
      AppLogger.success('Profile bio updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's match radius
  Future<void> updateProfileRadius(int radius) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile radius to $radius km', context: 'ProfileManager');

      await client.rpc('update_profile_radius', params: {
        'p_radius': radius,
      });

      AppLogger.success('Profile radius updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's location
  Future<void> updateProfileLocation({
    double? latitude,
    double? longitude,
  }) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile location', context: 'ProfileManager');

      await client.rpc('update_profile_location', params: {
        'latitude': latitude,
        'longitude': longitude,
      });

      AppLogger.success('Profile location updated successfully', context: 'ProfileManager');
    });
  }

  /// Start background location listener that persists across views
  ///
  /// This method starts a background listener that continues to run even after
  /// the location permission view is closed. The location will be automatically
  /// saved when GPS gets a fix.
  ///
  /// The listener will automatically stop after:
  /// - First valid location is received and saved
  /// - 60 seconds timeout
  /// - Manual cancellation via stopBackgroundLocationListener()
  void startBackgroundLocationListener(Location location) {
    // Cancel any existing subscription first
    _backgroundLocationSubscription?.cancel();

    AppLogger.debug('Starting persistent background location listener...', context: 'ProfileManager');

    _backgroundLocationSubscription = location.onLocationChanged.listen(
      (LocationData locationData) {
        // Check if we got valid coordinates
        if (locationData.latitude != null &&
            locationData.longitude != null &&
            locationData.latitude != 0.0 &&
            locationData.longitude != 0.0) {

          final accuracy = locationData.accuracy ?? 0.0;
          AppLogger.success(
            'Background location obtained: ${locationData.latitude}, ${locationData.longitude} (accuracy: ${accuracy}m)',
            context: 'ProfileManager',
          );

          // Save location to database
          updateProfileLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ).then((_) {
            AppLogger.success('Background location saved to database', context: 'ProfileManager');
          }).catchError((error) {
            AppLogger.error('Failed to save background location: $error', context: 'ProfileManager');
          });

          // Cancel subscription after first valid location
          _backgroundLocationSubscription?.cancel();
          _backgroundLocationSubscription = null;
        }
      },
      onError: (error) {
        AppLogger.warning('Background location listener error: $error', context: 'ProfileManager');
      },
    );

    // Set a timeout to cancel the subscription if no location after 60 seconds
    Future.delayed(const Duration(seconds: 60), () {
      if (_backgroundLocationSubscription != null) {
        AppLogger.debug('Background location listener timeout - cancelling', context: 'ProfileManager');
        _backgroundLocationSubscription?.cancel();
        _backgroundLocationSubscription = null;
      }
    });
  }

  /// Manually stop the background location listener
  void stopBackgroundLocationListener() {
    if (_backgroundLocationSubscription != null) {
      AppLogger.debug('Manually stopping background location listener', context: 'ProfileManager');
      _backgroundLocationSubscription?.cancel();
      _backgroundLocationSubscription = null;
    }
  }

  /// Update location at app start - gets cached location quickly without waiting for GPS
  ///
  /// This method is called automatically when the user opens the app.
  /// It tries to get the last known location and update the profile.
  /// If no cached location is available, it starts a background listener.
  Future<void> refreshLocationAtStartup() async {
    try {
      final location = Location();

      // Check if we have location permission
      // Note: We don't request permission here - that's done during onboarding
      // in edit_location_view where we first explain the benefits to the user
      final hasPermission = await location.hasPermission();
      if (hasPermission != PermissionStatus.granted &&
          hasPermission != PermissionStatus.grantedLimited) {
        AppLogger.debug('No location permission, skipping startup location refresh', context: 'ProfileManager');
        return;
      }

      // Check if location service is enabled
      final serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        AppLogger.debug('Location service disabled, skipping startup location refresh', context: 'ProfileManager');
        return;
      }

      AppLogger.debug('Attempting to get cached location at startup...', context: 'ProfileManager');

      // Configure settings for reduced accuracy (battery friendly)
      await location.changeSettings(
        accuracy: LocationAccuracy.reduced,
        interval: 1000,
        distanceFilter: 0,
      );

      // Try to get cached/last-known location quickly (2 second timeout)
      try {
        final locationData = await location.getLocation().timeout(const Duration(seconds: 2));

        if (locationData.latitude != null &&
            locationData.longitude != null &&
            locationData.latitude != 0.0 &&
            locationData.longitude != 0.0) {

          AppLogger.success(
            'Cached location obtained at startup: ${locationData.latitude}, ${locationData.longitude}',
            context: 'ProfileManager',
          );

          // Update profile with cached location
          await updateProfileLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          );

          return; // Success - no need for background listener
        }
      } catch (e) {
        AppLogger.debug('No cached location available: $e', context: 'ProfileManager');
      }

      // No cached location - start background listener for fresh GPS fix
      // This will save automatically when GPS gets a fix (can take 10-30 seconds)
      AppLogger.debug('Starting background listener for fresh location at startup...', context: 'ProfileManager');
      startBackgroundLocationListener(location);

    } catch (error) {
      AppLogger.warning('Error during startup location refresh: $error', context: 'ProfileManager');
      // Don't throw - this is a background operation that shouldn't block app startup
    }
  }

  /// Complete the user registration process
  Future<void> completeRegistration() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Completing registration', context: 'ProfileManager');

      await client.rpc('complete_registration');

      AppLogger.success('Registration completed successfully', context: 'ProfileManager');
    });
  }

  /// Check app version from server
  Future<AppVersion?> checkVersion() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Checking app version', context: 'ProfileManager');

      final deviceOS = DeviceInfo.getDeviceOS();

      final response = await client.rpc('get_version', params: {
        'p_device_os': deviceOS,
      });

      if (response == null || response.isEmpty) {
        AppLogger.warning('No version data returned from server', context: 'ProfileManager');
        return null;
      }

      // Response is a list with one item
      final versionData = response[0] as Map<String, dynamic>;
      final appVersion = AppVersion.fromJson(versionData);

      AppLogger.success('App version checked: ${appVersion.toString()}', context: 'ProfileManager');
      return appVersion;
    });
  }

  /// Send OTP to contact email
  Future<void> sendContactEmailOTP(String email) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Sending contact email OTP', context: 'ProfileManager');
      
      await client.rpc('send_mail_otp', params: {
        'p_email': email,
      });
      
      AppLogger.success('Contact email OTP sent successfully', context: 'ProfileManager');
    });
  }

  /// Verify email OTP
  Future<void> verifyEmailOTP(String email, String code, bool subscribed) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.auth('Verifying email OTP', context: 'ProfileManager');
      
      final payload = {
        'email': email,
        'code': code,
        'subscribed': subscribed,
      };
      
      await client.rpc('verify_mail_otp', params: {'payload': payload});
      
      AppLogger.success('Email OTP verified successfully', context: 'ProfileManager');
    });
  }

  /// Update profile avatar ID
  Future<void> updateProfileAvatar({required String? avatarID}) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile avatar to: $avatarID', context: 'ProfileManager');
      
      final result = await client.rpc('update_profile_avatar', params: {
        'p_avatar_id': avatarID,
      });
      
      AppLogger.debug('Database update result: $result', context: 'ProfileManager');
      AppLogger.success('Profile avatar updated successfully', context: 'ProfileManager');
    });
  }

  /// Insert device token for push notifications
  Future<void> insertDeviceToken(Device device) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Inserting device token', context: 'ProfileManager');
      
      await client.rpc('handle_device_token', params: {
        'payload': device.toJson(),
      });
      
      AppLogger.success('Device token inserted successfully', context: 'ProfileManager');
    });
  }

  /// Export user data
  Future<void> exportData() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Exporting user data', context: 'ProfileManager');
      
      await client.rpc('export_data');
      
      AppLogger.success('User data export initiated', context: 'ProfileManager');
    });
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Deleting user account', context: 'ProfileManager');

      await client.rpc('delete_profile');

      AppLogger.success('User account deletion initiated', context: 'ProfileManager');
    });
  }

  /// Get current user's invite codes
  ///
  /// Fetches all invite codes belonging to the authenticated user,
  /// including their redemption and sending status.
  Future<List<Invite>> getMyInviteCodes() async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching user invite codes', context: 'ProfileManager');

      try {
        final response = await client.rpc('get_my_invite_codes');

        if (response == null) {
          AppLogger.info('No invite codes found', context: 'ProfileManager');
          return <Invite>[];
        }

        final List<dynamic> data = response as List<dynamic>;
        final invites = data.map((json) => Invite.fromJson(json as Map<String, dynamic>)).toList();

        AppLogger.success('Fetched ${invites.length} invite codes', context: 'ProfileManager');
        return invites;
      } catch (error) {
        AppLogger.error('Failed to fetch invite codes', error: error, context: 'ProfileManager');
        rethrow;
      }
    });
  }

  /// Mark an invite code as sent
  ///
  /// Updates the sent_at timestamp for a specific invite code.
  /// Only works for codes owned by the current authenticated user.
  ///
  /// Parameters:
  /// - [codeId]: The UUID of the invite code to mark as sent
  ///
  /// Throws:
  /// - Exception if the code doesn't exist or isn't owned by the user
  /// - Exception if the code is already sent or redeemed
  Future<void> markInviteCodeAsSent(String codeId) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Marking invite code as sent: $codeId', context: 'ProfileManager');

      try {
        // Call the mark_invite_code_as_sent RPC function
        await client.rpc(
          'mark_invite_code_as_sent',
          params: {'p_code_id': codeId},
        );

        AppLogger.success('Successfully marked invite code as sent', context: 'ProfileManager');
      } catch (error) {
        AppLogger.error('Failed to mark invite code as sent', error: error, context: 'ProfileManager');
      }
    });
  }

  /// Issue new invite codes for the current user
  ///
  /// Generates the specified number of new invite codes that expire in 1 year.
  /// Only works for the authenticated user.
  ///
  /// Parameters:
  /// - [count]: Number of invite codes to generate (1-100, default: 1)
  ///
  /// Throws:
  /// - Exception if count is not between 1 and 100
  /// - Exception if user is not authenticated
  Future<void> issueProfileInviteCodes({int count = 1}) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Issuing $count invite codes', context: 'ProfileManager');

      try {
        // Call the issue_profile_invite_code RPC function
        await client.rpc(
          'issue_profile_invite_code',
          params: {'p_count': count},
        );

        AppLogger.success('Successfully issued $count invite codes', context: 'ProfileManager');
      } catch (error) {
        AppLogger.error('Failed to issue invite codes', error: error, context: 'ProfileManager');
        
      }
    });
  }

  /// Redeem an invite code
  ///
  /// This method validates and redeems an 8-character invite code.
  /// The code can be for venues, organizations, or other purposes.
  /// If it's a venue code, the user will automatically join that venue.
  ///
  /// Throws:
  /// - Exception if code is invalid, expired, or already used
  /// - Exception if code format is incorrect (not 8 characters)
  Future<void> redeemInviteCode(String code, BuildContext context) async {
    checkNotDisposed('ProfileManager');
    // Get l10n before async gap to avoid BuildContext issues
    final l10n = AppLocalizations.of(context)!;

    return executeAuthenticatedRequest(() async {
      AppLogger.info('Attempting to redeem invite code: ${code.substring(0, 3)}***', context: 'ProfileManager');

      try {
        // Call the redeem_invite_code RPC function
        await client.rpc(
          'redeem_invite_code',
          params: {'p_code': code.toUpperCase()},
        );

        AppLogger.success('Successfully redeemed invite code', context: 'ProfileManager');
      } catch (error) {
        AppLogger.error('Failed to redeem invite code', error: error, context: 'ProfileManager');

        // Parse the error message to provide user-friendly feedback
        final errorMessage = error.toString();

        if (errorMessage.contains('Invalid or expired code')) {
          throw Exception(l10n.inviteCodeErrorInvalidOrExpired);
        } else if (errorMessage.contains('Code is required')) {
          throw Exception(l10n.inviteCodeErrorRequired);
        } else if (errorMessage.contains('exactly 8 characters')) {
          throw Exception(l10n.inviteCodeErrorLength);
        }

        // Re-throw the original error if we can't provide a better message
        rethrow;
      }
    });
  }

  /// Upsert profile contact information
  ///
  /// Updates or inserts a contact setting value for the current user's profile.
  /// If the value is null or empty, the contact information will be deleted.
  ///
  /// [contactSettingId] The UUID of the contact setting to update
  /// [value] The value to set (null or empty string will delete the entry)
  Future<void> upsertProfileContactInformation({
    required String contactSettingId,
    String? value,
  }) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Upserting profile contact information: $contactSettingId', context: 'ProfileManager');

      final payload = {
        'contact_setting_id': contactSettingId,
        'value': value,
      };

      await client.rpc('upsert_profile_contact_information', params: {'payload': payload});

      AppLogger.success('Profile contact information upserted successfully', context: 'ProfileManager');
    });
  }

  /// Get profile contact settings
  ///
  /// Fetches all available contact settings for the current user's profile.
  /// Returns a list of Contact objects with id, label, description, icon, and optional value.
  Future<List<Contact>> getProfileContactSettings() async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching profile contact settings', context: 'ProfileManager');

      try {
        final response = await client.rpc('get_profile_contact_settings');

        if (response == null) {
          AppLogger.info('No contact settings found', context: 'ProfileManager');
          return <Contact>[];
        }

        final List<dynamic> data = response as List<dynamic>;
        final contacts = data.map((json) => Contact.fromJson(json as Map<String, dynamic>)).toList();

        AppLogger.success('Fetched ${contacts.length} contact settings', context: 'ProfileManager');
        return contacts;
      } catch (error) {
        AppLogger.error('Failed to fetch contact settings', error: error, context: 'ProfileManager');
        rethrow;
      }
    });
  }

  /// Update a profile setting (boolean value)
  ///
  /// This method calls the update_profile_setting RPC function which handles
  /// various boolean settings like newsletter_subscribed, auto_introduction, etc.
  ///
  /// [setting] The setting key to update (e.g., 'newsletter_subscribed', 'auto_introduction')
  /// [value] The boolean value to set
  Future<void> updateProfileSetting(String setting, bool value) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile setting: $setting = $value', context: 'ProfileManager');

      final payload = {
        'setting': setting,
        'value': value,
      };

      await client.rpc('update_profile_setting', params: {'payload': payload});

      AppLogger.success('Profile setting updated successfully: $setting', context: 'ProfileManager');
    });
  }

  /// Get user's offers (prompts with interaction type 'this_is_me')
  ///
  /// Fetches the current user's offers with pagination support.
  /// These are prompts where the user indicated "This is me".
  ///
  /// Parameters:
  /// - [limit]: Maximum number of results to return (default: 20)
  /// - [cursorTime]: Cursor timestamp for pagination (optional)
  /// - [cursorId]: Cursor ID for pagination (optional)
  ///
  /// Returns a list of [Prompt] objects representing the user's offers.
  Future<List<Prompt>> getMyOffers({
    int limit = 20,
    DateTime? cursorTime,
    String? cursorId,
  }) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching my offers', context: 'ProfileManager');

      final payload = <String, dynamic>{
        'limit': limit,
      };

      // Add cursor parameters if provided
      if (cursorTime != null) {
        payload['cursor_time'] = cursorTime.toIso8601String();
      }
      if (cursorId != null) {
        payload['cursor_id'] = cursorId;
      }

      try {
        final response = await client.rpc('get_my_offers', params: {'payload': payload});

        if (response == null) {
          AppLogger.info('No offers found', context: 'ProfileManager');
          return <Prompt>[];
        }

        final List<dynamic> data = response as List<dynamic>;
        final offers = data.map((json) => Prompt.fromJson(json as Map<String, dynamic>)).toList();

        AppLogger.success('Fetched ${offers.length} offers', context: 'ProfileManager');
        return offers;
      } catch (error) {
        AppLogger.error('Failed to fetch offers', error: error, context: 'ProfileManager');
        rethrow;
      }
    });
  }

  /// Subscribe to email newsletter
  ///
  /// This method calls the email_optin RPC function which:
  /// - Sets newsletter_subscribed to true in the profile
  /// - Sends subscription data to the newsletter edge function
  ///
  /// [email] The email address to subscribe
  Future<void> emailOptin(String email) async {
    checkNotDisposed('ProfileManager');
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Subscribing email to newsletter', context: 'ProfileManager');

      final payload = {
        'email': email,
      };

      await client.rpc('email_optin', params: {'payload': payload});

      AppLogger.success('Email subscribed to newsletter successfully', context: 'ProfileManager');
    });
  }

  /// Dispose this manager and clean up resources.
  void dispose() {
    disposeResources('ProfileManager');
  }
  
  /// Static method to dispose the singleton instance.
  static void disposeSingleton() {
    if (_instance != null && !_instance!.disposed) {
      _instance!.dispose();
      _instance = null;
    }
  }
}