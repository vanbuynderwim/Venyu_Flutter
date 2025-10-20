
import 'package:flutter/material.dart';

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
        'country_code': DeviceInfo.detectCountry(),
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

  /// Update user's name
  Future<void> updateProfileName(String firstName, String lastName, String linkedInURL, bool linkedInURLValid) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile name', context: 'ProfileManager');
      
      final payload = {
        'first_name': firstName,
        'last_name': lastName,
        'linkedin_url': linkedInURL,
        'linkedin_url_valid': linkedInURLValid,
      };
      
      await client.rpc('update_profile_name', params: {'payload': payload});
      
      AppLogger.success('Profile name updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's company information
  Future<void> updateCompanyInfo(String companyName, String websiteURL) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating company information', context: 'ProfileManager');

      final payload = {
        'company_name': companyName,
        'website_url': websiteURL,
      };

      await client.rpc('update_company_info', params: {'payload': payload});

      AppLogger.success('Company information updated successfully', context: 'ProfileManager');
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