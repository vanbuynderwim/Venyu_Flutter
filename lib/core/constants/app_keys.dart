/// App Keys - Storage keys and identifiers used throughout the app
/// 
/// This class contains all key constants for SharedPreferences,
/// database keys, and other identifiers to prevent typos and
/// ensure consistency.
class AppKeys {
  AppKeys._();

  /// SharedPreferences keys
  static const String userToken = 'user_token';
  static const String userProfile = 'user_profile';
  static const String appSettings = 'app_settings';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
  static const String pushNotificationToken = 'push_notification_token';
  static const String biometricEnabled = 'biometric_enabled';
  static const String darkModeEnabled = 'dark_mode_enabled';
  static const String languageCode = 'language_code';

  /// Database table names
  static const String profilesTable = 'profiles';
  static const String promptsTable = 'prompts';
  static const String matchesTable = 'matches';
  static const String connectionsTable = 'connections';
  static const String tagsTable = 'tags';
  static const String messagesTable = 'messages';

  /// Storage bucket names
  static const String avatarsBucket = 'avatars';
  static const String documentsBucket = 'documents';
  static const String imagesBucket = 'images';
  static const String videosBucket = 'videos';

  /// API endpoints
  static const String authEndpoint = '/auth';
  static const String profileEndpoint = '/profile';
  static const String matchesEndpoint = '/matches';
  static const String messagesEndpoint = '/messages';
  static const String notificationsEndpoint = '/notifications';

  /// Form field keys
  static const String firstNameField = 'firstName';
  static const String lastNameField = 'lastName';
  static const String emailField = 'email';
  static const String phoneField = 'phone';
  static const String companyField = 'company';
  static const String jobTitleField = 'jobTitle';
  static const String bioField = 'bio';
  static const String locationField = 'location';

  /// Navigation route names
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String matchesRoute = '/matches';
  static const String settingsRoute = '/settings';
  static const String authRoute = '/auth';
  static const String onboardingRoute = '/onboarding';

  /// Widget test keys
  static const String loginButton = 'login_button';
  static const String signupButton = 'signup_button';
  static const String profileAvatar = 'profile_avatar';
  static const String navigationBar = 'navigation_bar';
  static const String searchField = 'search_field';

  /// Analytics event names
  static const String userSignedIn = 'user_signed_in';
  static const String userSignedUp = 'user_signed_up';
  static const String profileUpdated = 'profile_updated';
  static const String matchCreated = 'match_created';
  static const String messagesSent = 'message_sent';
  static const String settingsChanged = 'settings_changed';

  /// Push notification types
  static const String newMatch = 'new_match';
  static const String newMessage = 'new_message';
  static const String profileViewed = 'profile_viewed';
  static const String systemUpdate = 'system_update';
}