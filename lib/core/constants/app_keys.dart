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