import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

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

  /// Step 4: Collect user's city
  city,

  /// Step 5: Collect user's company name and website
  company,

  /// Step 6: Select user roles (using EditTagGroupView)
  roles,

  /// Step 7: Select sectors (using EditTagGroupView)
  sectors,

  /// Step 8: Set meeting preferences (using EditTagGroupView)
  meetingPreferences,

  /// Step 9: Set networking goals (using EditTagGroupView)
  networkingGoals,

  /// Step 10: Upload user's profile avatar
  avatar,

  /// Step 11: Configure notification preferences
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
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case RegistrationStep.name:
        return l10n.registrationStepNameTitle;
      case RegistrationStep.email:
        return l10n.registrationStepEmailTitle;
      case RegistrationStep.location:
        return l10n.registrationStepLocationTitle;
      case RegistrationStep.city:
        return l10n.registrationStepCityTitle;
      case RegistrationStep.company:
        return l10n.registrationStepCompanyTitle;
      case RegistrationStep.roles:
        return l10n.registrationStepRolesTitle;
      case RegistrationStep.sectors:
        return l10n.registrationStepSectorsTitle;
      case RegistrationStep.meetingPreferences:
        return l10n.registrationStepMeetingPreferencesTitle;
      case RegistrationStep.networkingGoals:
        return l10n.registrationStepNetworkingGoalsTitle;
      case RegistrationStep.avatar:
        return l10n.registrationStepAvatarTitle;
      case RegistrationStep.notifications:
        return l10n.registrationStepNotificationsTitle;
      case RegistrationStep.complete:
        return l10n.registrationStepCompleteTitle;
    }
  }
}