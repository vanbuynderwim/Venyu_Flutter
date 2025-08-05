/// Registration wizard step enumeration.
/// 
/// Defines the sequential steps in the user onboarding/registration process.
/// Each step corresponds to a specific form view that collects user information.
/// 
/// The order of these enum values determines the flow sequence.
enum RegistrationStep {
  /// Step 1: Collect user's first name, last name, and LinkedIn URL
  name,
  
  /// Step 2: Collect and verify user's email address with OTP
  email,
  
  /// Step 3: Collect user's location/country information
  location,
  
  /// Step 4: Collect user's company name and website
  company,
  
  /// Step 5: Select user roles (using EditTagGroupView)
  roles,
  
  /// Step 6: Select sectors (using EditTagGroupView)
  sectors,
  
  /// Step 7: Set meeting preferences (using EditTagGroupView)
  meetingPreferences,
  
  /// Step 8: Set networking goals (using EditTagGroupView)
  networkingGoals,
  
  /// Step 9: Upload user's profile avatar
  avatar,
  
  /// Step 10: Configure notification preferences  
  notifications,
  
  /// Final step: Show completion screen
  complete;

  /// Get the next step in the registration process.
  /// 
  /// Returns null if this is the last step (complete).
  RegistrationStep? get nextStep {
    final currentIndex = RegistrationStep.values.indexOf(this);
    if (currentIndex < RegistrationStep.values.length - 1) {
      return RegistrationStep.values[currentIndex + 1];
    }
    return null; // No next step after complete
  }

  /// Get the previous step in the registration process.
  /// 
  /// Returns null if this is the first step (name).
  RegistrationStep? get previousStep {
    final currentIndex = RegistrationStep.values.indexOf(this);
    if (currentIndex > 0) {
      return RegistrationStep.values[currentIndex - 1];
    }
    return null; // No previous step before name
  }

  /// Get the step number (1-based) for progress display.
  int get stepNumber => RegistrationStep.values.indexOf(this) + 1;

  /// Get the total number of steps in the registration process.
  static int get totalSteps => RegistrationStep.values.length;

  /// Get user-friendly title for this step.
  String get title {
    switch (this) {
      case RegistrationStep.name:
        return 'Personal Information';
      case RegistrationStep.email:
        return 'Email Verification';
      case RegistrationStep.location:
        return 'Location';
      case RegistrationStep.company:
        return 'Company Information';
      case RegistrationStep.roles:
        return 'Your Roles';
      case RegistrationStep.sectors:
        return 'Your Sectors';
      case RegistrationStep.meetingPreferences:
        return 'Meeting Preferences';
      case RegistrationStep.networkingGoals:
        return 'Networking Goals';
      case RegistrationStep.avatar:
        return 'Profile Picture';
      case RegistrationStep.notifications:
        return 'Notifications';
      case RegistrationStep.complete:
        return 'Welcome to Venyu!';
    }
  }
}