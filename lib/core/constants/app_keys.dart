/// App Keys - Storage keys and identifiers used throughout the app
/// 
/// This class is reserved for key constants that are truly shared across
/// multiple services and don't have better homes in domain-specific enums.
/// 
/// Currently empty - all previous constants have been moved to more
/// appropriate locations (RemoteImagePath enum, etc.) or were unused.
class AppKeys {
  AppKeys._();

  // MARK: - Future Implementation
  // Add constants here only when:
  // 1. Used in 2+ different services/managers
  // 2. No better domain-specific enum exists
  // 3. Actually implemented, not premature
  
  // Example future keys:
  // static const String userProfileKey = 'user_profile';     // SharedPreferences
  // static const String onboardingCompleted = 'onboarding_completed'; // SharedPreferences
}