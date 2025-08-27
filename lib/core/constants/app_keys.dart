/// App Keys - Storage keys and identifiers used throughout the app
/// 
/// This class contains key constants for storage buckets, SharedPreferences,
/// and other identifiers to prevent typos and ensure consistency.
/// 
/// Only includes keys that are actually used in the codebase.
class AppKeys {
  AppKeys._();

  // MARK: - Storage Bucket Names (Actively Used)
  
  /// Supabase storage bucket for user avatar images
  static const String avatarsBucket = 'avatars';

  // MARK: - Device & System Keys
  
  /// Language code identifier for device locale
  static const String languageCode = 'language_code';

  // MARK: - Database Field Keys (Frequently Used)
  
  /// Profile field names used in RPC calls and forms
  static const String firstNameField = 'first_name';
  static const String lastNameField = 'last_name';
  static const String companyNameField = 'company_name';
  static const String linkedinUrlField = 'linkedin_url';
  static const String websiteUrlField = 'website_url';
  static const String emailField = 'email';
  static const String bioField = 'p_bio';
  
  /// Location and system fields
  static const String countryCodeField = 'country_code';
  static const String appVersionField = 'app_version';
  
  /// Common RPC function names
  static const String getMyProfileRpc = 'get_my_profile';
  static const String updateProfileNameRpc = 'update_profile_name';
  static const String updateCompanyInfoRpc = 'update_company_info';
  static const String updateProfileBioRpc = 'update_profile_bio';
  static const String completeRegistrationRpc = 'complete_registration';
  static const String verifyMailOtpRpc = 'verify_mail_otp';
  
  /// Common payload key
  static const String payloadKey = 'payload';

  // MARK: - Future Implementation Keys
  // Uncomment and implement when needed:
  
  // /// SharedPreferences keys
  // static const String userProfile = 'user_profile';
  // static const String appSettings = 'app_settings';
  // static const String onboardingCompleted = 'onboarding_completed';
  // static const String darkModeEnabled = 'dark_mode_enabled';
  // static const String pushNotificationToken = 'push_notification_token';
  
  // /// Additional storage buckets
  // static const String documentsBucket = 'documents';
  // static const String imagesBucket = 'images';
  
  // /// Widget test keys (when implementing tests)
  // static const String loginButton = 'login_button';
  // static const String profileAvatar = 'profile_avatar';
  // static const String navigationBar = 'navigation_bar';
  
  // /// Analytics event names (when implementing analytics)
  // static const String userSignedIn = 'user_signed_in';
  // static const String profileUpdated = 'profile_updated';
  // static const String matchCreated = 'match_created';
  
  // /// Push notification types (when implementing push notifications)
  // static const String newMatch = 'new_match';
  // static const String newMessage = 'new_message';
  // static const String profileViewed = 'profile_viewed';
}