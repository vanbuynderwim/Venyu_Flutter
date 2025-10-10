import 'package:flutter/material.dart';

import '../../widgets/buttons/option_button.dart';
import '../../l10n/app_localizations.dart';
import '../models.dart';

/// Enumeration of benefits shown during onboarding for various features.
///
/// This enum implements OptionType to be used with OptionButton widgets
/// and displays the advantages of enabling certain features like location
/// services, notifications, etc. during the onboarding process.
enum OnboardingBenefit implements OptionType {
  // Location benefits
  nearbyMatches(icon: 'coffee'),
  distanceAwareness(icon: 'map'),
  betterMatching(icon: 'network'),

  // Notification benefits
  matchNotifications(icon: 'match'),
  connectionNotifications(icon: 'handshake'),
  dailyReminders(icon: 'card'),
  focusedReach(icon: 'target'),
  discreetPreview(icon: 'eye'),
  unlimitedIntroductions(icon: 'handshake'),
  unlockFullProfiles(icon: 'profile'),
  viewsAndImpressions(icon: 'grow'),
  dailyCardsBoost(icon: 'card'),
  aiPoweredMatches(icon: 'ai');

  @override
  final String? icon;

  const OnboardingBenefit({
    required this.icon,
  });

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case OnboardingBenefit.nearbyMatches:
        return l10n.benefitNearbyMatchesTitle;
      case OnboardingBenefit.distanceAwareness:
        return l10n.benefitDistanceAwarenessTitle;
      case OnboardingBenefit.betterMatching:
        return l10n.benefitBetterMatchingTitle;
      case OnboardingBenefit.matchNotifications:
        return l10n.benefitMatchNotificationsTitle;
      case OnboardingBenefit.connectionNotifications:
        return l10n.benefitConnectionNotificationsTitle;
      case OnboardingBenefit.dailyReminders:
        return l10n.benefitDailyRemindersTitle;
      case OnboardingBenefit.focusedReach:
        return l10n.benefitFocusedReachTitle;
      case OnboardingBenefit.discreetPreview:
        return l10n.benefitDiscreetPreviewTitle;
      case OnboardingBenefit.unlimitedIntroductions:
        return l10n.benefitUnlimitedIntroductionsTitle;
      case OnboardingBenefit.unlockFullProfiles:
        return l10n.benefitUnlockFullProfilesTitle;
      case OnboardingBenefit.viewsAndImpressions:
        return l10n.benefitViewsAndImpressionsTitle;
      case OnboardingBenefit.dailyCardsBoost:
        return l10n.benefitDailyCardsBoostTitle;
      case OnboardingBenefit.aiPoweredMatches:
        return l10n.benefitAiPoweredMatchesTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case OnboardingBenefit.nearbyMatches:
        return l10n.benefitNearbyMatchesDescription;
      case OnboardingBenefit.distanceAwareness:
        return l10n.benefitDistanceAwarenessDescription;
      case OnboardingBenefit.betterMatching:
        return l10n.benefitBetterMatchingDescription;
      case OnboardingBenefit.matchNotifications:
        return l10n.benefitMatchNotificationsDescription;
      case OnboardingBenefit.connectionNotifications:
        return l10n.benefitConnectionNotificationsDescription;
      case OnboardingBenefit.dailyReminders:
        return l10n.benefitDailyRemindersDescription;
      case OnboardingBenefit.focusedReach:
        return l10n.benefitFocusedReachDescription;
      case OnboardingBenefit.discreetPreview:
        return l10n.benefitDiscreetPreviewDescription;
      case OnboardingBenefit.unlimitedIntroductions:
        return l10n.benefitUnlimitedIntroductionsDescription;
      case OnboardingBenefit.unlockFullProfiles:
        return l10n.benefitUnlockFullProfilesDescription;
      case OnboardingBenefit.viewsAndImpressions:
        return l10n.benefitViewsAndImpressionsDescription;
      case OnboardingBenefit.dailyCardsBoost:
        return l10n.benefitDailyCardsBoostDescription;
      case OnboardingBenefit.aiPoweredMatches:
        return l10n.benefitAiPoweredMatchesDescription;
    }
  }

  @override
  String get id => name;
  
  @override
  Color get color => Colors.blue; // Default color, not used for onboarding
  
  @override
  String? get emoji => null;
  
  @override
  int get badge => 0;
  
  @override
  List<Tag>? get list => null;
}