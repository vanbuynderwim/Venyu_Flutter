
import '../../core/utils/device_info.dart';
import '../../models/models.dart';
import '../../models/device.dart';
import '../../core/utils/app_logger.dart';
import '../../core/constants/app_keys.dart';
import 'base_supabase_manager.dart';

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
class ProfileManager extends BaseSupabaseManager {
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
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching user profile', context: 'ProfileManager');
      
      // Create payload with device information - exact equivalent of iOS UpdateCountryAndLanguageRequest
      final payload = {
        AppKeys.countryCodeField: DeviceInfo.detectCountry(),
        AppKeys.languageCode: DeviceInfo.detectLanguage(),
        AppKeys.appVersionField: await DeviceInfo.detectAppVersion(),
      };
      
      AppLogger.debug('Profile fetch payload: $payload', context: 'ProfileManager');
      
      // Call the get_my_profile RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc(AppKeys.getMyProfileRpc, params: {AppKeys.payloadKey: payload})
          .select()
          .single();
      
      AppLogger.success('Profile RPC call successful', context: 'ProfileManager');
      AppLogger.debug('Profile data received: ${result.toString()}', context: 'ProfileManager');
      
      // Create profile from response
      final profile = Profile.fromJson(result);
      AppLogger.debug('Profile parsed: ${profile.displayName} (${profile.contactEmail})', context: 'ProfileManager');
      
      // Enhance with stored OAuth data
      final enhancedProfile = await _enhanceProfileWithStoredData(profile);
      
      AppLogger.info('Profile enhanced with stored data', context: 'ProfileManager');
      return enhancedProfile;
    });
  }

  /// Enhance profile with stored OAuth data from secure storage
  Future<Profile> _enhanceProfileWithStoredData(Profile profile) async {
    try {
      final storedData = await BaseSupabaseManager.getStoredUserInfo();
      
      // Create enhanced profile with stored OAuth data
      return profile.copyWith(
        firstName: storedData['firstName'] ?? profile.firstName,
        lastName: storedData['lastName'] ?? profile.lastName,
        contactEmail: storedData[AppKeys.emailField] ?? profile.contactEmail,
        linkedInURL: storedData['linkedInProfileUrl'] ?? profile.linkedInURL,
      );
    } catch (error) {
      AppLogger.warning('Failed to enhance profile with stored data: $error', context: 'ProfileManager');
      // Return original profile if enhancement fails
      return profile;
    }
  }

  /// Update user's name
  Future<void> updateProfileName(String firstName, String lastName, String linkedInURL, bool linkedInURLValid) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile name', context: 'ProfileManager');
      
      final payload = {
        AppKeys.firstNameField: firstName,
        AppKeys.lastNameField: lastName,
        AppKeys.linkedinUrlField: linkedInURL,
        'linkedin_url_valid': linkedInURLValid,
      };
      
      await client.rpc(AppKeys.updateProfileNameRpc, params: {AppKeys.payloadKey: payload});
      
      AppLogger.success('Profile name updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's company information
  Future<void> updateCompanyInfo(String companyName, String websiteURL) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating company information', context: 'ProfileManager');
      
      final payload = {
        AppKeys.companyNameField: companyName,
        AppKeys.websiteUrlField: websiteURL,
      };
      
      await client.rpc(AppKeys.updateCompanyInfoRpc, params: {AppKeys.payloadKey: payload});
      
      AppLogger.success('Company information updated successfully', context: 'ProfileManager');
    });
  }

  /// Update user's bio
  Future<void> updateProfileBio(String bio) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile bio', context: 'ProfileManager');
      
      await client.rpc(AppKeys.updateProfileBioRpc, params: {
        AppKeys.bioField: bio,
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
      
      await client.rpc(AppKeys.completeRegistrationRpc);
      
      AppLogger.success('Registration completed successfully', context: 'ProfileManager');
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
      
      await client.rpc(AppKeys.verifyMailOtpRpc, params: {AppKeys.payloadKey: payload});
      
      AppLogger.success('Email OTP verified successfully', context: 'ProfileManager');
    });
  }

  /// Update profile avatar ID
  Future<void> updateProfileAvatar({required String? avatarID}) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating profile avatar', context: 'ProfileManager');
      
      await client.rpc('update_profile_avatar', params: {
        'avatar_id': avatarID,
      });
      
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
}