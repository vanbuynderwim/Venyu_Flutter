import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// No description provided for @onboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Venyu'**
  String get onboardTitle;

  /// No description provided for @onboardDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'re now part of a community built on real introductions.\n\nLet\'s start with a quick tour before setting up your profile.'**
  String get onboardDescription;

  /// No description provided for @onboardStartTutorial.
  ///
  /// In en, this message translates to:
  /// **'Before we set up your profile, let\'s show you how Venyu works with a quick tutorial.'**
  String get onboardStartTutorial;

  /// No description provided for @onboardButtonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardButtonStart;

  /// No description provided for @tutorialStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Answer 3 daily cards'**
  String get tutorialStep1Title;

  /// No description provided for @tutorialStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Each day, you answer three cards from other entrepreneurs. It takes less than a minute and helps us find great matches for you.'**
  String get tutorialStep1Description;

  /// No description provided for @tutorialStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Get matched'**
  String get tutorialStep2Title;

  /// No description provided for @tutorialStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Our matching agent connects you with entrepreneurs who share your goals and needs. Each match will be relevant and worthwhile.'**
  String get tutorialStep2Description;

  /// No description provided for @tutorialStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Show your interest'**
  String get tutorialStep3Title;

  /// No description provided for @tutorialStep3Description.
  ///
  /// In en, this message translates to:
  /// **'When a match catches your eye, say you\'re interested. It\'s your way of telling us you\'d like to be introduced to that person.'**
  String get tutorialStep3Description;

  /// No description provided for @tutorialStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Get introduced'**
  String get tutorialStep4Title;

  /// No description provided for @tutorialStep4Description.
  ///
  /// In en, this message translates to:
  /// **'If there\'s mutual interest, we\'ll send an introduction email so you can start the conversation naturally.'**
  String get tutorialStep4Description;

  /// No description provided for @tutorialStep5Title.
  ///
  /// In en, this message translates to:
  /// **'You got it!'**
  String get tutorialStep5Title;

  /// No description provided for @tutorialStep5Description.
  ///
  /// In en, this message translates to:
  /// **'Now let\'s set up your profile and join the community.'**
  String get tutorialStep5Description;

  /// No description provided for @tutorialButtonPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tutorialButtonPrevious;

  /// No description provided for @tutorialButtonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialButtonNext;

  /// No description provided for @registrationCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is ready! 🎉'**
  String get registrationCompleteTitle;

  /// No description provided for @registrationCompleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Thanks for setting up your profile. Now let\'s see how answering 3 cards each day helps you get matched with the right people.'**
  String get registrationCompleteDescription;

  /// No description provided for @registrationCompleteButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get registrationCompleteButton;

  /// No description provided for @promptEntryTitleFirstTime.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try it out!'**
  String get promptEntryTitleFirstTime;

  /// No description provided for @promptEntryDescriptionFirstTime.
  ///
  /// In en, this message translates to:
  /// **'Here are 3 example cards to help you understand how it works. Don\'t worry, these are just for practice.'**
  String get promptEntryDescriptionFirstTime;

  /// No description provided for @promptEntryButtonFirstTime.
  ///
  /// In en, this message translates to:
  /// **'Start tutorial'**
  String get promptEntryButtonFirstTime;

  /// No description provided for @dailyPromptsHintSelect.
  ///
  /// In en, this message translates to:
  /// **'Select \"{buttonTitle}\" 👇'**
  String dailyPromptsHintSelect(String buttonTitle);

  /// No description provided for @dailyPromptsHintConfirm.
  ///
  /// In en, this message translates to:
  /// **'Select \"Next\" to confirm'**
  String get dailyPromptsHintConfirm;

  /// No description provided for @dailyPromptsButtonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get dailyPromptsButtonNext;

  /// No description provided for @tutorialFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set! 🎉'**
  String get tutorialFinishedTitle;

  /// No description provided for @tutorialFinishedDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed the quick tour. Now you\'re ready to start answering your first 3 real cards to get matched with other entrepreneurs.'**
  String get tutorialFinishedDescription;

  /// No description provided for @tutorialFinishedButton.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get tutorialFinishedButton;

  /// No description provided for @registrationFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s it! 🎉'**
  String get registrationFinishTitle;

  /// No description provided for @registrationFinishDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account is all set up and you\'ve answered your first 3 cards. Come back tomorrow to answer more cards and discover new matches.'**
  String get registrationFinishDescription;

  /// No description provided for @registrationFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Start exploring!'**
  String get registrationFinishButton;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @buttonPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get buttonPrevious;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// No description provided for @buttonGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get buttonGotIt;

  /// No description provided for @errorNoCardsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cards available at the moment. Check back later!'**
  String get errorNoCardsAvailable;

  /// No description provided for @errorFailedToLoadCards.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cards. Please try again.'**
  String get errorFailedToLoadCards;

  /// No description provided for @errorFailedToRefreshProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh profile. Please try again.'**
  String get errorFailedToRefreshProfile;

  /// No description provided for @interactionTypeThisIsMeButton.
  ///
  /// In en, this message translates to:
  /// **'I can help'**
  String get interactionTypeThisIsMeButton;

  /// No description provided for @interactionTypeLookingForThisButton.
  ///
  /// In en, this message translates to:
  /// **'I need this'**
  String get interactionTypeLookingForThisButton;

  /// No description provided for @interactionTypeKnowSomeoneButton.
  ///
  /// In en, this message translates to:
  /// **'I can refer'**
  String get interactionTypeKnowSomeoneButton;

  /// No description provided for @interactionTypeNotRelevantButton.
  ///
  /// In en, this message translates to:
  /// **'I can\'t help'**
  String get interactionTypeNotRelevantButton;

  /// No description provided for @interactionTypeThisIsMeSelection.
  ///
  /// In en, this message translates to:
  /// **'I can help'**
  String get interactionTypeThisIsMeSelection;

  /// No description provided for @interactionTypeLookingForThisSelection.
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get interactionTypeLookingForThisSelection;

  /// No description provided for @interactionTypeKnowSomeoneSelection.
  ///
  /// In en, this message translates to:
  /// **'I can connect'**
  String get interactionTypeKnowSomeoneSelection;

  /// No description provided for @interactionTypeNotRelevantSelection.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get interactionTypeNotRelevantSelection;

  /// No description provided for @interactionTypeThisIsMeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your skills or experience'**
  String get interactionTypeThisIsMeSubtitle;

  /// No description provided for @interactionTypeLookingForThisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for advice or support'**
  String get interactionTypeLookingForThisSubtitle;

  /// No description provided for @interactionTypeKnowSomeoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Introduce people who can help'**
  String get interactionTypeKnowSomeoneSubtitle;

  /// No description provided for @interactionTypeNotRelevantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pass on this one'**
  String get interactionTypeNotRelevantSubtitle;

  /// No description provided for @interactionTypeThisIsMeHint.
  ///
  /// In en, this message translates to:
  /// **'What skill or expertise can you offer?'**
  String get interactionTypeThisIsMeHint;

  /// No description provided for @interactionTypeLookingForThisHint.
  ///
  /// In en, this message translates to:
  /// **'What specific help do you need?'**
  String get interactionTypeLookingForThisHint;

  /// No description provided for @interactionTypeKnowSomeoneHint.
  ///
  /// In en, this message translates to:
  /// **'Who can you connect for this need?'**
  String get interactionTypeKnowSomeoneHint;

  /// No description provided for @interactionTypeNotRelevantHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to share?'**
  String get interactionTypeNotRelevantHint;

  /// No description provided for @registrationStepNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get registrationStepNameTitle;

  /// No description provided for @registrationStepEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get registrationStepEmailTitle;

  /// No description provided for @registrationStepLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get registrationStepLocationTitle;

  /// No description provided for @registrationStepCityTitle.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get registrationStepCityTitle;

  /// No description provided for @registrationStepCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get registrationStepCompanyTitle;

  /// No description provided for @registrationStepRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Roles'**
  String get registrationStepRolesTitle;

  /// No description provided for @registrationStepSectorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Sectors'**
  String get registrationStepSectorsTitle;

  /// No description provided for @registrationStepMeetingPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Meeting Preferences'**
  String get registrationStepMeetingPreferencesTitle;

  /// No description provided for @registrationStepNetworkingGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Networking Goals'**
  String get registrationStepNetworkingGoalsTitle;

  /// No description provided for @registrationStepAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get registrationStepAvatarTitle;

  /// No description provided for @registrationStepNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get registrationStepNotificationsTitle;

  /// No description provided for @registrationStepCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Venyu!'**
  String get registrationStepCompleteTitle;

  /// No description provided for @benefitNearbyMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet entrepreneurs nearby'**
  String get benefitNearbyMatchesTitle;

  /// No description provided for @benefitNearbyMatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover people close to you'**
  String get benefitNearbyMatchesDescription;

  /// No description provided for @benefitDistanceAwarenessTitle.
  ///
  /// In en, this message translates to:
  /// **'See who is within reach'**
  String get benefitDistanceAwarenessTitle;

  /// No description provided for @benefitDistanceAwarenessDescription.
  ///
  /// In en, this message translates to:
  /// **'Know the distance to matches'**
  String get benefitDistanceAwarenessDescription;

  /// No description provided for @benefitBetterMatchingTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow your network locally'**
  String get benefitBetterMatchingTitle;

  /// No description provided for @benefitBetterMatchingDescription.
  ///
  /// In en, this message translates to:
  /// **'Get better results with local focus'**
  String get benefitBetterMatchingDescription;

  /// No description provided for @benefitMatchNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'New match alerts'**
  String get benefitMatchNotificationsTitle;

  /// No description provided for @benefitMatchNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get alerted as soon as a new match appears'**
  String get benefitMatchNotificationsDescription;

  /// No description provided for @benefitConnectionNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss an intro'**
  String get benefitConnectionNotificationsTitle;

  /// No description provided for @benefitConnectionNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Know right away when you receive a new introduction'**
  String get benefitConnectionNotificationsDescription;

  /// No description provided for @benefitDailyRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in the game'**
  String get benefitDailyRemindersTitle;

  /// No description provided for @benefitDailyRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get reminded every day to make the net work'**
  String get benefitDailyRemindersDescription;

  /// No description provided for @benefitFocusedReachTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart targeting'**
  String get benefitFocusedReachTitle;

  /// No description provided for @benefitFocusedReachDescription.
  ///
  /// In en, this message translates to:
  /// **'Publish your questions to the right audience'**
  String get benefitFocusedReachDescription;

  /// No description provided for @benefitDiscreetPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'First call'**
  String get benefitDiscreetPreviewTitle;

  /// No description provided for @benefitDiscreetPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'On your cards, you get the first call. Matches are only shown to others if you\'re interested.'**
  String get benefitDiscreetPreviewDescription;

  /// No description provided for @benefitUnlimitedIntroductionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Infinite intros'**
  String get benefitUnlimitedIntroductionsTitle;

  /// No description provided for @benefitUnlimitedIntroductionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep growing your network with unlimited introductions and never miss an opportunity'**
  String get benefitUnlimitedIntroductionsDescription;

  /// No description provided for @benefitUnlockFullProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Full profiles'**
  String get benefitUnlockFullProfilesTitle;

  /// No description provided for @benefitUnlockFullProfilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover who\'s behind the match by seeing their avatar and checking mutual interests'**
  String get benefitUnlockFullProfilesDescription;

  /// No description provided for @benefitViewsAndImpressionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Views and impressions'**
  String get benefitViewsAndImpressionsTitle;

  /// No description provided for @benefitViewsAndImpressionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Understand your reach with simple stats'**
  String get benefitViewsAndImpressionsDescription;

  /// No description provided for @benefitDailyCardsBoostTitle.
  ///
  /// In en, this message translates to:
  /// **'More daily cards'**
  String get benefitDailyCardsBoostTitle;

  /// No description provided for @benefitDailyCardsBoostDescription.
  ///
  /// In en, this message translates to:
  /// **'More cards to grow your network faster.'**
  String get benefitDailyCardsBoostDescription;

  /// No description provided for @benefitAiPoweredMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered matches (later)'**
  String get benefitAiPoweredMatchesTitle;

  /// No description provided for @benefitAiPoweredMatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive smart suggestions based on your profile.'**
  String get benefitAiPoweredMatchesDescription;

  /// No description provided for @editCompanyInfoNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Name & website'**
  String get editCompanyInfoNameTitle;

  /// No description provided for @editCompanyInfoNameDescription.
  ///
  /// In en, this message translates to:
  /// **'The name of your company'**
  String get editCompanyInfoNameDescription;

  /// No description provided for @editPersonalInfoNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editPersonalInfoNameTitle;

  /// No description provided for @editPersonalInfoNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Your name and LinkedIn URL.'**
  String get editPersonalInfoNameDescription;

  /// No description provided for @editPersonalInfoBioTitle.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editPersonalInfoBioTitle;

  /// No description provided for @editPersonalInfoBioDescription.
  ///
  /// In en, this message translates to:
  /// **'A short intro about yourself.'**
  String get editPersonalInfoBioDescription;

  /// No description provided for @editPersonalInfoLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get editPersonalInfoLocationTitle;

  /// No description provided for @editPersonalInfoLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'The city you live in.'**
  String get editPersonalInfoLocationDescription;

  /// No description provided for @editPersonalInfoEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editPersonalInfoEmailTitle;

  /// No description provided for @editPersonalInfoEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Your contact email address.'**
  String get editPersonalInfoEmailDescription;

  /// No description provided for @profileEditAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileEditAccountTitle;

  /// No description provided for @profileEditAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get profileEditAccountDescription;

  /// No description provided for @reviewTypeUserTitle.
  ///
  /// In en, this message translates to:
  /// **'User generated'**
  String get reviewTypeUserTitle;

  /// No description provided for @reviewTypeUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Cards submitted by users'**
  String get reviewTypeUserDescription;

  /// No description provided for @reviewTypeSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'AI generated'**
  String get reviewTypeSystemTitle;

  /// No description provided for @reviewTypeSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily generated cards by AI'**
  String get reviewTypeSystemDescription;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Venyu'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'make the net work'**
  String get appTagline;

  /// No description provided for @navMatches.
  ///
  /// In en, this message translates to:
  /// **'Intros'**
  String get navMatches;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get navNotifications;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionInterested.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get actionInterested;

  /// No description provided for @successSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get successSaved;

  /// No description provided for @dialogRemoveAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Avatar'**
  String get dialogRemoveAvatarTitle;

  /// No description provided for @dialogRemoveAvatarMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove your avatar?'**
  String get dialogRemoveAvatarMessage;

  /// No description provided for @dialogRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get dialogRemoveButton;

  /// No description provided for @dialogOkButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOkButton;

  /// No description provided for @dialogErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dialogErrorTitle;

  /// No description provided for @dialogLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get dialogLoadingMessage;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (starting with http:// or https://)'**
  String get validationUrlInvalid;

  /// No description provided for @validationLinkedInUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid LinkedIn profile URL\n(e.g., https://www.linkedin.com/in/yourname)'**
  String get validationLinkedInUrlInvalid;

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String validationFieldRequired(String fieldName);

  /// No description provided for @validationFieldRequiredDefault.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationFieldRequiredDefault;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be at least {minLength} characters long'**
  String validationMinLength(String fieldName, int minLength);

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} cannot exceed {maxLength} characters'**
  String validationMaxLength(String fieldName, int maxLength);

  /// No description provided for @validationOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get validationOtpRequired;

  /// No description provided for @validationOtpLength.
  ///
  /// In en, this message translates to:
  /// **'Verification code must be 6 digits'**
  String get validationOtpLength;

  /// No description provided for @validationOtpNumeric.
  ///
  /// In en, this message translates to:
  /// **'Verification code must contain only numbers'**
  String get validationOtpNumeric;

  /// No description provided for @imageSourceCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get imageSourceCameraTitle;

  /// No description provided for @imageSourceCameraDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a new photo'**
  String get imageSourceCameraDescription;

  /// No description provided for @imageSourcePhotoLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get imageSourcePhotoLibraryTitle;

  /// No description provided for @imageSourcePhotoLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get imageSourcePhotoLibraryDescription;

  /// No description provided for @pagesProfileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Edit'**
  String get pagesProfileEditTitle;

  /// No description provided for @pagesProfileEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit profile information'**
  String get pagesProfileEditDescription;

  /// No description provided for @pagesLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get pagesLocationTitle;

  /// No description provided for @pagesLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'Location settings'**
  String get pagesLocationDescription;

  /// No description provided for @promptSectionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get promptSectionCardTitle;

  /// No description provided for @promptSectionCardDescription.
  ///
  /// In en, this message translates to:
  /// **'View your card details'**
  String get promptSectionCardDescription;

  /// No description provided for @promptSectionStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get promptSectionStatsTitle;

  /// No description provided for @promptSectionStatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Performance and analytics'**
  String get promptSectionStatsDescription;

  /// No description provided for @promptSectionIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Intros'**
  String get promptSectionIntroTitle;

  /// No description provided for @promptSectionIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Matches and introductions'**
  String get promptSectionIntroDescription;

  /// No description provided for @promptStatusDraftDisplay.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get promptStatusDraftDisplay;

  /// No description provided for @promptStatusDraftInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card is saved as a draft. Complete and submit it to start getting matches.'**
  String get promptStatusDraftInfo;

  /// No description provided for @promptStatusPendingReviewDisplay.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get promptStatusPendingReviewDisplay;

  /// No description provided for @promptStatusPendingReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card is being reviewed by our team. This usually takes 12-24 hours to check if the content follows community guidelines.'**
  String get promptStatusPendingReviewInfo;

  /// No description provided for @promptStatusPendingTranslationDisplay.
  ///
  /// In en, this message translates to:
  /// **'Pending Translation'**
  String get promptStatusPendingTranslationDisplay;

  /// No description provided for @promptStatusPendingTranslationInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card is being translated to other languages.'**
  String get promptStatusPendingTranslationInfo;

  /// No description provided for @promptStatusApprovedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get promptStatusApprovedDisplay;

  /// No description provided for @promptStatusApprovedInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card has been approved and is live. You can receive matches.'**
  String get promptStatusApprovedInfo;

  /// No description provided for @promptStatusRejectedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get promptStatusRejectedDisplay;

  /// No description provided for @promptStatusRejectedInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card was rejected for not following community guidelines. Please edit and resubmit.'**
  String get promptStatusRejectedInfo;

  /// No description provided for @promptStatusArchivedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get promptStatusArchivedDisplay;

  /// No description provided for @promptStatusArchivedInfo.
  ///
  /// In en, this message translates to:
  /// **'Your card has been archived and is no longer visible to other users.'**
  String get promptStatusArchivedInfo;

  /// No description provided for @venueTypeEventDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get venueTypeEventDisplayName;

  /// No description provided for @venueTypeEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporary venue for events, conferences, or meetups'**
  String get venueTypeEventDescription;

  /// No description provided for @venueTypeOrganisationDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get venueTypeOrganisationDisplayName;

  /// No description provided for @venueTypeOrganisationDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanent venue for companies or organizations'**
  String get venueTypeOrganisationDescription;

  /// No description provided for @emptyStateNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get emptyStateNotificationsTitle;

  /// No description provided for @emptyStateNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'When something happens that you should know about, we\'ll update you here'**
  String get emptyStateNotificationsDescription;

  /// No description provided for @emptyStateReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get emptyStateReviewsTitle;

  /// No description provided for @emptyStateReviewsDescription.
  ///
  /// In en, this message translates to:
  /// **'When cards are submitted for review, they will appear here'**
  String get emptyStateReviewsDescription;

  /// No description provided for @emptyStateMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your first match!'**
  String get emptyStateMatchesTitle;

  /// No description provided for @emptyStateMatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Venyu is already on the lookout for great matches. As soon as we find the right fit, it will show up here and may lead to an introduction.'**
  String get emptyStateMatchesDescription;

  /// No description provided for @emptyStatePromptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to get matched?'**
  String get emptyStatePromptsTitle;

  /// No description provided for @emptyStatePromptsDescription.
  ///
  /// In en, this message translates to:
  /// **'Cards open the door to meaningful introductions. Add yours and match with the right people.'**
  String get emptyStatePromptsDescription;

  /// No description provided for @redeemInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your invite code'**
  String get redeemInviteTitle;

  /// No description provided for @redeemInviteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 8-character invite code you received to continue.'**
  String get redeemInviteSubtitle;

  /// No description provided for @redeemInviteContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get redeemInviteContinue;

  /// No description provided for @redeemInvitePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter invite code'**
  String get redeemInvitePlaceholder;

  /// No description provided for @waitlistFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the list!'**
  String get waitlistFinishTitle;

  /// No description provided for @waitlistFinishDescription.
  ///
  /// In en, this message translates to:
  /// **'Thanks for joining the Venyu waitlist. We\'ll notify you as soon as new spots open up.'**
  String get waitlistFinishDescription;

  /// No description provided for @waitlistFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get waitlistFinishButton;

  /// No description provided for @waitlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Join the waitlist'**
  String get waitlistTitle;

  /// No description provided for @waitlistDescription.
  ///
  /// In en, this message translates to:
  /// **'Venyu is invite-only. Join the waitlist and get invited when new spots are open.'**
  String get waitlistDescription;

  /// No description provided for @waitlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get waitlistNameHint;

  /// No description provided for @waitlistCompanyHint.
  ///
  /// In en, this message translates to:
  /// **'Your company name'**
  String get waitlistCompanyHint;

  /// No description provided for @waitlistRoleHint.
  ///
  /// In en, this message translates to:
  /// **'Your role / title'**
  String get waitlistRoleHint;

  /// No description provided for @waitlistEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get waitlistEmailHint;

  /// No description provided for @waitlistButton.
  ///
  /// In en, this message translates to:
  /// **'Join waitlist'**
  String get waitlistButton;

  /// No description provided for @waitlistErrorDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This email is already on the waitlist'**
  String get waitlistErrorDuplicate;

  /// No description provided for @waitlistErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to join waitlist. Please try again.'**
  String get waitlistErrorFailed;

  /// No description provided for @waitlistSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been added to the waitlist! We\'ll notify you when we\'re ready.'**
  String get waitlistSuccessMessage;

  /// No description provided for @inviteScreeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to venyu 🤝'**
  String get inviteScreeningTitle;

  /// No description provided for @inviteScreeningDescription.
  ///
  /// In en, this message translates to:
  /// **'The invite-only match-making community for entrepreneurs. Real introductions. One minute a day.'**
  String get inviteScreeningDescription;

  /// No description provided for @inviteScreeningHasCode.
  ///
  /// In en, this message translates to:
  /// **'I have an invite code'**
  String get inviteScreeningHasCode;

  /// No description provided for @inviteScreeningNoCode.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have an invite code'**
  String get inviteScreeningNoCode;

  /// No description provided for @onboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome {name} 👋'**
  String onboardWelcome(String name);

  /// No description provided for @onboardStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardStart;

  /// No description provided for @loginLegalText.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get loginLegalText;

  /// No description provided for @joinVenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Join venue'**
  String get joinVenueTitle;

  /// No description provided for @joinVenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 8-character invite code to join.'**
  String get joinVenueSubtitle;

  /// No description provided for @joinVenueButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinVenueButton;

  /// No description provided for @joinVenuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter venue code'**
  String get joinVenuePlaceholder;

  /// No description provided for @matchDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get matchDetailLoading;

  /// No description provided for @matchDetailTitleIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get matchDetailTitleIntroduction;

  /// No description provided for @matchDetailTitleMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchDetailTitleMatch;

  /// No description provided for @matchDetailMenuReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get matchDetailMenuReport;

  /// No description provided for @matchDetailMenuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get matchDetailMenuRemove;

  /// No description provided for @matchDetailMenuBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get matchDetailMenuBlock;

  /// No description provided for @matchDetailReportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile reported successfully'**
  String get matchDetailReportSuccess;

  /// No description provided for @matchDetailBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block User?'**
  String get matchDetailBlockTitle;

  /// No description provided for @matchDetailBlockMessage.
  ///
  /// In en, this message translates to:
  /// **'Blocking this user will remove the match and prevent future matching. This action cannot be undone.'**
  String get matchDetailBlockMessage;

  /// No description provided for @matchDetailBlockButton.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get matchDetailBlockButton;

  /// No description provided for @matchDetailBlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'User blocked successfully'**
  String get matchDetailBlockSuccess;

  /// No description provided for @matchDetailRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {type}?'**
  String matchDetailRemoveTitle(String type);

  /// No description provided for @matchDetailRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this {type}? This action cannot be undone.'**
  String matchDetailRemoveMessage(String type);

  /// No description provided for @matchDetailRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get matchDetailRemoveButton;

  /// No description provided for @matchDetailRemoveSuccessIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction removed successfully'**
  String get matchDetailRemoveSuccessIntroduction;

  /// No description provided for @matchDetailRemoveSuccessMatch.
  ///
  /// In en, this message translates to:
  /// **'Match removed successfully'**
  String get matchDetailRemoveSuccessMatch;

  /// No description provided for @matchDetailTypeIntroduction.
  ///
  /// In en, this message translates to:
  /// **'introduction'**
  String get matchDetailTypeIntroduction;

  /// No description provided for @matchDetailTypeMatch.
  ///
  /// In en, this message translates to:
  /// **'match'**
  String get matchDetailTypeMatch;

  /// No description provided for @matchDetailErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load match details'**
  String get matchDetailErrorLoad;

  /// No description provided for @matchDetailRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get matchDetailRetry;

  /// No description provided for @matchDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Match not found'**
  String get matchDetailNotFound;

  /// No description provided for @matchDetailLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit reached'**
  String get matchDetailLimitTitle;

  /// No description provided for @matchDetailLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your limit of 3 intros per month. Upgrade to Venyu Pro for unlimited introductions.'**
  String get matchDetailLimitMessage;

  /// No description provided for @matchDetailLimitButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get matchDetailLimitButton;

  /// No description provided for @matchDetailFirstCallTitle.
  ///
  /// In en, this message translates to:
  /// **'First Call active'**
  String get matchDetailFirstCallTitle;

  /// No description provided for @matchDetailMatchingCards.
  ///
  /// In en, this message translates to:
  /// **'{count} matching {cards}'**
  String matchDetailMatchingCards(int count, String cards);

  /// No description provided for @matchDetailCard.
  ///
  /// In en, this message translates to:
  /// **'card'**
  String get matchDetailCard;

  /// No description provided for @matchDetailCards.
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get matchDetailCards;

  /// No description provided for @matchDetailSharedIntros.
  ///
  /// In en, this message translates to:
  /// **'{count} shared {intros}'**
  String matchDetailSharedIntros(int count, String intros);

  /// No description provided for @matchDetailIntroduction.
  ///
  /// In en, this message translates to:
  /// **'introduction'**
  String get matchDetailIntroduction;

  /// No description provided for @matchDetailIntroductions.
  ///
  /// In en, this message translates to:
  /// **'introductions'**
  String get matchDetailIntroductions;

  /// No description provided for @matchDetailSharedVenues.
  ///
  /// In en, this message translates to:
  /// **'{count} shared {venues}'**
  String matchDetailSharedVenues(int count, String venues);

  /// No description provided for @matchDetailVenue.
  ///
  /// In en, this message translates to:
  /// **'venue'**
  String get matchDetailVenue;

  /// No description provided for @matchDetailVenues.
  ///
  /// In en, this message translates to:
  /// **'venues'**
  String get matchDetailVenues;

  /// No description provided for @matchDetailCompanyFacts.
  ///
  /// In en, this message translates to:
  /// **'{count} mutual company {facts}'**
  String matchDetailCompanyFacts(int count, String facts);

  /// No description provided for @matchDetailFact.
  ///
  /// In en, this message translates to:
  /// **'fact'**
  String get matchDetailFact;

  /// No description provided for @matchDetailFacts.
  ///
  /// In en, this message translates to:
  /// **'facts'**
  String get matchDetailFacts;

  /// No description provided for @matchDetailPersonalInterests.
  ///
  /// In en, this message translates to:
  /// **'{count} mutual personal {interests}'**
  String matchDetailPersonalInterests(int count, String interests);

  /// No description provided for @matchDetailInterest.
  ///
  /// In en, this message translates to:
  /// **'interest'**
  String get matchDetailInterest;

  /// No description provided for @matchDetailInterests.
  ///
  /// In en, this message translates to:
  /// **'interests'**
  String get matchDetailInterests;

  /// No description provided for @matchDetailWhyMatch.
  ///
  /// In en, this message translates to:
  /// **'Why you and {name} match'**
  String matchDetailWhyMatch(String name);

  /// No description provided for @matchDetailUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock mutual interests'**
  String get matchDetailUnlockTitle;

  /// No description provided for @matchDetailUnlockMessage.
  ///
  /// In en, this message translates to:
  /// **'See what you share on a personal level with {name}'**
  String matchDetailUnlockMessage(String name);

  /// No description provided for @matchDetailUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get matchDetailUnlockButton;

  /// No description provided for @matchOverviewYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get matchOverviewYou;

  /// No description provided for @profileAvatarMenuCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profileAvatarMenuCamera;

  /// No description provided for @profileAvatarMenuGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profileAvatarMenuGallery;

  /// No description provided for @profileAvatarMenuView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get profileAvatarMenuView;

  /// No description provided for @profileAvatarMenuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get profileAvatarMenuRemove;

  /// No description provided for @profileAvatarErrorAction.
  ///
  /// In en, this message translates to:
  /// **'Avatar action failed: {error}'**
  String profileAvatarErrorAction(String error);

  /// No description provided for @profileAvatarErrorUpload.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo. Please try again.'**
  String get profileAvatarErrorUpload;

  /// No description provided for @profileAvatarErrorRemove.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove photo. Please try again.'**
  String get profileAvatarErrorRemove;

  /// No description provided for @profileAvatarErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get profileAvatarErrorTitle;

  /// No description provided for @profileAvatarErrorButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get profileAvatarErrorButton;

  /// No description provided for @profileInfoAddCompanyInfo.
  ///
  /// In en, this message translates to:
  /// **'Add company info'**
  String get profileInfoAddCompanyInfo;

  /// No description provided for @venuesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading venues'**
  String get venuesErrorLoading;

  /// No description provided for @venuesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get venuesRetry;

  /// No description provided for @venuesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your venues will appear here'**
  String get venuesEmptyTitle;

  /// No description provided for @venuesEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Got an invite code? Redeem it to join that venue and start getting introductions in the community.'**
  String get venuesEmptyDescription;

  /// No description provided for @venuesEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Join a venue'**
  String get venuesEmptyAction;

  /// No description provided for @invitesAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'You have {count} invite {codes} ready to share. Each one unlocks Venyu for a new entrepreneur'**
  String invitesAvailableDescription(int count, String codes);

  /// No description provided for @invitesCode.
  ///
  /// In en, this message translates to:
  /// **'code'**
  String get invitesCode;

  /// No description provided for @invitesCodes.
  ///
  /// In en, this message translates to:
  /// **'codes'**
  String get invitesCodes;

  /// No description provided for @invitesAllSharedDescription.
  ///
  /// In en, this message translates to:
  /// **'All your invite codes have been shared. Thank you for helping grow the Venyu community.'**
  String get invitesAllSharedDescription;

  /// No description provided for @invitesGenerateMore.
  ///
  /// In en, this message translates to:
  /// **'Generate more codes'**
  String get invitesGenerateMore;

  /// No description provided for @invitesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No invite codes yet'**
  String get invitesEmptyTitle;

  /// No description provided for @invitesEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your invite codes will appear here. You can share them with friends to invite them to Venyu.'**
  String get invitesEmptyDescription;

  /// No description provided for @invitesEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Generate codes'**
  String get invitesEmptyAction;

  /// No description provided for @invitesSubtitleAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available codes'**
  String get invitesSubtitleAvailable;

  /// No description provided for @invitesSubtitleShared.
  ///
  /// In en, this message translates to:
  /// **'Shared codes'**
  String get invitesSubtitleShared;

  /// No description provided for @invitesSubtitleRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed codes'**
  String get invitesSubtitleRedeemed;

  /// No description provided for @invitesMenuShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get invitesMenuShare;

  /// No description provided for @invitesMenuCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get invitesMenuCopy;

  /// No description provided for @invitesMenuMarkShared.
  ///
  /// In en, this message translates to:
  /// **'Mark as shared'**
  String get invitesMenuMarkShared;

  /// No description provided for @invitesShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Your personal Venyu invite'**
  String get invitesShareSubject;

  /// No description provided for @invitesShareText.
  ///
  /// In en, this message translates to:
  /// **'Join me on Venyu ! \n  \nThe invite-only network for entrepreneurs, built on real introductions\n\nDownload the app at 👉 www.getvenyu.com\n\n🔑 Your invite code: \n\n{code}'**
  String invitesShareText(String code);

  /// No description provided for @invitesCopiedToast.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied to clipboard'**
  String get invitesCopiedToast;

  /// No description provided for @invitesMarkedSentToast.
  ///
  /// In en, this message translates to:
  /// **'Invite code marked as sent'**
  String get invitesMarkedSentToast;

  /// No description provided for @invitesMarkedSentError.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark invite as sent'**
  String get invitesMarkedSentError;

  /// No description provided for @invitesGenerateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate more codes'**
  String get invitesGenerateDialogTitle;

  /// No description provided for @invitesGenerateDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Generate 5 new invite codes? These will expire in 1 year.'**
  String get invitesGenerateDialogMessage;

  /// No description provided for @invitesGenerateDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get invitesGenerateDialogConfirm;

  /// No description provided for @invitesGenerateDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get invitesGenerateDialogCancel;

  /// No description provided for @invitesGenerateSuccessToast.
  ///
  /// In en, this message translates to:
  /// **'5 new invite codes generated successfully'**
  String get invitesGenerateSuccessToast;

  /// No description provided for @invitesGenerateErrorToast.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invite codes'**
  String get invitesGenerateErrorToast;

  /// No description provided for @companySectionEmptyTagGroups.
  ///
  /// In en, this message translates to:
  /// **'No company tag groups available'**
  String get companySectionEmptyTagGroups;

  /// No description provided for @personalSectionEmptyTagGroups.
  ///
  /// In en, this message translates to:
  /// **'No personal tag groups available'**
  String get personalSectionEmptyTagGroups;

  /// No description provided for @editAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get editAccountTitle;

  /// No description provided for @editAccountDataExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get editAccountDataExportTitle;

  /// No description provided for @editAccountDataExportDescription.
  ///
  /// In en, this message translates to:
  /// **'You can request a copy of all your personal data. This includes your profile information, cards, matches, and activity history. The export will be sent to your registered email address.'**
  String get editAccountDataExportDescription;

  /// No description provided for @editAccountExportDataButton.
  ///
  /// In en, this message translates to:
  /// **'Export all your data'**
  String get editAccountExportDataButton;

  /// No description provided for @editAccountDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get editAccountDeleteTitle;

  /// No description provided for @editAccountDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account is permanent. All your data, including your profile, cards and matches will be removed.'**
  String get editAccountDeleteDescription;

  /// No description provided for @editAccountDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get editAccountDeleteButton;

  /// No description provided for @editAccountLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get editAccountLogoutButton;

  /// No description provided for @editAccountExportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get editAccountExportDialogTitle;

  /// No description provided for @editAccountExportDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You will receive a data export link in your email as soon as your data is ready.'**
  String get editAccountExportDialogMessage;

  /// No description provided for @editAccountExportDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editAccountExportDialogCancel;

  /// No description provided for @editAccountExportDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get editAccountExportDialogConfirm;

  /// No description provided for @editAccountExportSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'An email will be sent once the export is ready'**
  String get editAccountExportSuccessMessage;

  /// No description provided for @editAccountExportErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get editAccountExportErrorMessage;

  /// No description provided for @editAccountDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get editAccountDeleteDialogTitle;

  /// No description provided for @editAccountDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account and all its data will be permanently deleted immediately. This action cannot be undone. Are you sure you want to continue?'**
  String get editAccountDeleteDialogMessage;

  /// No description provided for @editAccountDeleteDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editAccountDeleteDialogCancel;

  /// No description provided for @editAccountDeleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get editAccountDeleteDialogConfirm;

  /// No description provided for @editAccountDeleteErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get editAccountDeleteErrorMessage;

  /// No description provided for @editAccountLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get editAccountLogoutDialogTitle;

  /// No description provided for @editAccountLogoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get editAccountLogoutDialogMessage;

  /// No description provided for @editAccountLogoutDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editAccountLogoutDialogCancel;

  /// No description provided for @editAccountLogoutDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get editAccountLogoutDialogConfirm;

  /// No description provided for @editAccountLogoutErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get editAccountLogoutErrorMessage;

  /// No description provided for @editTagGroupSavingButton.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get editTagGroupSavingButton;

  /// No description provided for @editTagGroupNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get editTagGroupNextButton;

  /// No description provided for @editTagGroupSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editTagGroupSaveButton;

  /// No description provided for @editTagGroupLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags'**
  String get editTagGroupLoadErrorTitle;

  /// No description provided for @editTagGroupRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get editTagGroupRetryButton;

  /// No description provided for @editTagGroupNoTagsMessage.
  ///
  /// In en, this message translates to:
  /// **'No tags available'**
  String get editTagGroupNoTagsMessage;

  /// No description provided for @editTagGroupSaveErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get editTagGroupSaveErrorTitle;

  /// No description provided for @editTagGroupSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes: {error}'**
  String editTagGroupSaveErrorMessage(String error);

  /// No description provided for @editTagGroupErrorDialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get editTagGroupErrorDialogOk;

  /// No description provided for @editNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get editNotificationsTitle;

  /// No description provided for @editNotificationsSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications saved'**
  String get editNotificationsSavedMessage;

  /// No description provided for @editNotificationsSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save notifications'**
  String get editNotificationsSaveErrorMessage;

  /// No description provided for @editNotificationsEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to ...'**
  String get editNotificationsEnableTitle;

  /// No description provided for @editNotificationsNotNowButton.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get editNotificationsNotNowButton;

  /// No description provided for @editNotificationsEnableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get editNotificationsEnableButton;

  /// No description provided for @editNotificationsPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Required'**
  String get editNotificationsPermissionDialogTitle;

  /// No description provided for @editNotificationsPermissionDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Notification permission has been denied. Please enable it in your device settings to receive updates.'**
  String get editNotificationsPermissionDialogMessage;

  /// No description provided for @editNotificationsPermissionDialogNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get editNotificationsPermissionDialogNotNow;

  /// No description provided for @editNotificationsPermissionDialogOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get editNotificationsPermissionDialogOpenSettings;

  /// No description provided for @editNotificationsLaterMessage.
  ///
  /// In en, this message translates to:
  /// **'You can enable notifications later in settings'**
  String get editNotificationsLaterMessage;

  /// No description provided for @editNotificationsEnableErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable notifications. You can try again in settings.'**
  String get editNotificationsEnableErrorMessage;

  /// No description provided for @editLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editLocationTitle;

  /// No description provided for @editLocationSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Location saved'**
  String get editLocationSavedMessage;

  /// No description provided for @editLocationSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save location'**
  String get editLocationSaveErrorMessage;

  /// No description provided for @editLocationEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable location to'**
  String get editLocationEnableTitle;

  /// No description provided for @editLocationNotNowButton.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get editLocationNotNowButton;

  /// No description provided for @editLocationEnableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get editLocationEnableButton;

  /// No description provided for @editLocationServicesDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them in settings.'**
  String get editLocationServicesDisabledMessage;

  /// No description provided for @editLocationPermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. You can enable it later in settings.'**
  String get editLocationPermissionDeniedMessage;

  /// No description provided for @editLocationPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get editLocationPermissionDialogTitle;

  /// No description provided for @editLocationPermissionDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission has been permanently denied. Please enable it in your device settings to use this feature.'**
  String get editLocationPermissionDialogMessage;

  /// No description provided for @editLocationPermissionDialogNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get editLocationPermissionDialogNotNow;

  /// No description provided for @editLocationPermissionDialogOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get editLocationPermissionDialogOpenSettings;

  /// No description provided for @editLocationCoordinatesErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not get location coordinates'**
  String get editLocationCoordinatesErrorMessage;

  /// No description provided for @editLocationEnableErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable location. Please try again.'**
  String get editLocationEnableErrorMessage;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get editNameTitle;

  /// No description provided for @editNameSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Changes successfully saved'**
  String get editNameSuccessMessage;

  /// No description provided for @editNameErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update, please try again'**
  String get editNameErrorMessage;

  /// No description provided for @editNameLinkedInFormatError.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn URL format is invalid'**
  String get editNameLinkedInFormatError;

  /// No description provided for @editNameLinkedInMismatchDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your name in your LinkedIn URL'**
  String get editNameLinkedInMismatchDialogTitle;

  /// No description provided for @editNameLinkedInMismatchDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Your LinkedIn URL doesn\'t seem to contain your first and last name. You can continue or double-check your URL.'**
  String get editNameLinkedInMismatchDialogMessage;

  /// No description provided for @editNameLinkedInMismatchDialogCheckUrl.
  ///
  /// In en, this message translates to:
  /// **'Check URL'**
  String get editNameLinkedInMismatchDialogCheckUrl;

  /// No description provided for @editNameLinkedInMismatchDialogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get editNameLinkedInMismatchDialogContinue;

  /// No description provided for @editNameFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'FIRST NAME'**
  String get editNameFirstNameLabel;

  /// No description provided for @editNameFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get editNameFirstNameHint;

  /// No description provided for @editNameLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'LAST NAME'**
  String get editNameLastNameLabel;

  /// No description provided for @editNameLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get editNameLastNameHint;

  /// No description provided for @editNameLinkedInLabel.
  ///
  /// In en, this message translates to:
  /// **'LINKEDIN URL'**
  String get editNameLinkedInLabel;

  /// No description provided for @editNameLinkedInHint.
  ///
  /// In en, this message translates to:
  /// **'linkedin.com/in/your-name'**
  String get editNameLinkedInHint;

  /// No description provided for @editNameLinkedInInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll only share your LinkedIn profile in the introduction email once there\'s mutual interest. It\'s never shared when you first get matched.'**
  String get editNameLinkedInInfoMessage;

  /// No description provided for @editEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get editEmailTitle;

  /// No description provided for @editEmailSendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get editEmailSendCodeButton;

  /// No description provided for @editEmailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get editEmailAddressLabel;

  /// No description provided for @editEmailCodeSentMessage.
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to {email}'**
  String editEmailCodeSentMessage(String email);

  /// No description provided for @editEmailSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Contact email address updated'**
  String get editEmailSuccessMessage;

  /// No description provided for @editEmailSendCodeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send confirmation code, please try again'**
  String get editEmailSendCodeErrorMessage;

  /// No description provided for @editEmailVerifyCodeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify code, please try again'**
  String get editEmailVerifyCodeErrorMessage;

  /// No description provided for @editEmailVerifyCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get editEmailVerifyCodeButton;

  /// No description provided for @editEmailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'A valid email address'**
  String get editEmailAddressHint;

  /// No description provided for @editEmailInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll only use this email for app notifications like new matches, introductions and important updates'**
  String get editEmailInfoMessage;

  /// No description provided for @editEmailNewsletterLabel.
  ///
  /// In en, this message translates to:
  /// **'SUBSCRIBE FOR VENYU UPDATES'**
  String get editEmailNewsletterLabel;

  /// No description provided for @editEmailVerificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get editEmailVerificationCodeLabel;

  /// No description provided for @editEmailVerificationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get editEmailVerificationCodeHint;

  /// No description provided for @editCityTitle.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get editCityTitle;

  /// No description provided for @editCitySavedMessage.
  ///
  /// In en, this message translates to:
  /// **'City saved'**
  String get editCitySavedMessage;

  /// No description provided for @editCityErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update city, please try again'**
  String get editCityErrorMessage;

  /// No description provided for @editCityCityLabel.
  ///
  /// In en, this message translates to:
  /// **'CITY'**
  String get editCityCityLabel;

  /// No description provided for @editCityCityHint.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get editCityCityHint;

  /// No description provided for @editCityInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Your city is only shared with people you get introduced to, not with matches. This helps facilitate better in-person meetups once a connection is established.'**
  String get editCityInfoMessage;

  /// No description provided for @editCompanyNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get editCompanyNameTitle;

  /// No description provided for @editCompanyNameSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Company info changes saved'**
  String get editCompanyNameSuccessMessage;

  /// No description provided for @editCompanyNameErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update company info, please try again'**
  String get editCompanyNameErrorMessage;

  /// No description provided for @editCompanyNameCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'COMPANY NAME'**
  String get editCompanyNameCompanyLabel;

  /// No description provided for @editCompanyNameCompanyHint.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get editCompanyNameCompanyHint;

  /// No description provided for @editCompanyNameWebsiteLabel.
  ///
  /// In en, this message translates to:
  /// **'WEBSITE'**
  String get editCompanyNameWebsiteLabel;

  /// No description provided for @editCompanyNameWebsiteHint.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get editCompanyNameWebsiteHint;

  /// No description provided for @editCompanyNameInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Your company name and website are only shared with people you get introduced to, not with matches. They help make introductions more meaningful and relevant.'**
  String get editCompanyNameInfoMessage;

  /// No description provided for @editAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get editAvatarTitle;

  /// No description provided for @editAvatarSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile picture saved'**
  String get editAvatarSuccessMessage;

  /// No description provided for @editAvatarErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile picture'**
  String get editAvatarErrorMessage;

  /// No description provided for @editAvatarRemoveButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get editAvatarRemoveButton;

  /// No description provided for @editAvatarAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a profile picture'**
  String get editAvatarAddTitle;

  /// No description provided for @editAvatarInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Your photo is often your first impression. Choose a clear, friendly headshot that feels like you. It will appear blurred in matches, but visible once you\'re introduced.'**
  String get editAvatarInfoMessage;

  /// No description provided for @editAvatarCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get editAvatarCameraButton;

  /// No description provided for @editAvatarGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get editAvatarGalleryButton;

  /// No description provided for @editAvatarNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get editAvatarNextButton;

  /// No description provided for @editBioTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get editBioTitle;

  /// No description provided for @editBioSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile bio saved'**
  String get editBioSuccessMessage;

  /// No description provided for @editBioErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile bio, please try again'**
  String get editBioErrorMessage;

  /// No description provided for @editBioInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Your bio is visible to everyone you match with. Keep in mind: if you don\'t want certain personal details to be known before an introduction (such as your company name, LinkedIn profile, or other identifying information), please leave those out.\n\nUse this space to highlight your experience, interests, and what you\'re open to, without sharing sensitive details you\'d rather keep private until after an introduction is made.'**
  String get editBioInfoMessage;

  /// No description provided for @editBioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write your bio here...'**
  String get editBioPlaceholder;

  /// No description provided for @promptCardCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get promptCardCreatedLabel;

  /// No description provided for @promptCardReviewedLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get promptCardReviewedLabel;

  /// No description provided for @promptCardStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get promptCardStatusLabel;

  /// No description provided for @promptCardUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Extend your card visibility'**
  String get promptCardUpgradeTitle;

  /// No description provided for @promptCardUpgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Venyu Pro to keep your card online for 10 days instead of 3.'**
  String get promptCardUpgradeSubtitle;

  /// No description provided for @promptCardUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get promptCardUpgradeButton;

  /// No description provided for @promptIntroErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load matches'**
  String get promptIntroErrorMessage;

  /// No description provided for @promptIntroRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get promptIntroRetryButton;

  /// No description provided for @promptIntroEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get promptIntroEmptyTitle;

  /// No description provided for @promptIntroEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'When people match with your card, their profiles will appear here.'**
  String get promptIntroEmptyDescription;

  /// No description provided for @interactionTypeSelectionTitleFromPrompts.
  ///
  /// In en, this message translates to:
  /// **'Thank you{name}'**
  String interactionTypeSelectionTitleFromPrompts(String name);

  /// No description provided for @interactionTypeSelectionTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Make the net work'**
  String get interactionTypeSelectionTitleDefault;

  /// No description provided for @interactionTypeSelectionSubtitleFromPrompts.
  ///
  /// In en, this message translates to:
  /// **'Now, let\'s make the net work for you'**
  String get interactionTypeSelectionSubtitleFromPrompts;

  /// No description provided for @interactionTypeSelectionSubtitleDefault.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get interactionTypeSelectionSubtitleDefault;

  /// No description provided for @interactionTypeSelectionDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'All cards are subject to review before going live'**
  String get interactionTypeSelectionDisclaimerText;

  /// No description provided for @interactionTypeSelectionShowGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Show community guidelines'**
  String get interactionTypeSelectionShowGuidelines;

  /// No description provided for @interactionTypeSelectionHideGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Hide community guidelines'**
  String get interactionTypeSelectionHideGuidelines;

  /// No description provided for @interactionTypeSelectionNotNowButton.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get interactionTypeSelectionNotNowButton;

  /// No description provided for @promptDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Card detail'**
  String get promptDetailTitle;

  /// No description provided for @promptDetailStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get promptDetailStatusTitle;

  /// No description provided for @promptDetailHowYouMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'How you match'**
  String get promptDetailHowYouMatchTitle;

  /// No description provided for @promptDetailHowYouMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Pause a matching option to temporarily stop receiving matches. Resume to start matching again.'**
  String get promptDetailHowYouMatchDescription;

  /// No description provided for @promptDetailFirstCallTitle.
  ///
  /// In en, this message translates to:
  /// **'First Call'**
  String get promptDetailFirstCallTitle;

  /// No description provided for @promptDetailPublishedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Published in'**
  String get promptDetailPublishedInTitle;

  /// No description provided for @promptDetailMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Matches & Introductions'**
  String get promptDetailMatchesTitle;

  /// No description provided for @promptDetailErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load prompt'**
  String get promptDetailErrorMessage;

  /// No description provided for @promptDetailErrorDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load prompt data'**
  String get promptDetailErrorDataMessage;

  /// No description provided for @promptDetailRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get promptDetailRetryButton;

  /// No description provided for @promptDetailEmptyMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get promptDetailEmptyMatchesTitle;

  /// No description provided for @promptDetailEmptyMatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'When people match with your card, their profiles will appear here.'**
  String get promptDetailEmptyMatchesDescription;

  /// No description provided for @promptDetailEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get promptDetailEditButton;

  /// No description provided for @promptDetailPreviewUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Preview setting updated'**
  String get promptDetailPreviewUpdatedMessage;

  /// No description provided for @promptDetailMatchSettingUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Match setting updated'**
  String get promptDetailMatchSettingUpdatedMessage;

  /// No description provided for @promptDetailPauseMatchingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause matching?'**
  String get promptDetailPauseMatchingTitle;

  /// No description provided for @promptDetailPauseMatchingMessage.
  ///
  /// In en, this message translates to:
  /// **'You will no longer receive matches for \"{interactionType}\" on this card. You can resume matching anytime.'**
  String promptDetailPauseMatchingMessage(String interactionType);

  /// No description provided for @promptDetailPauseMatchingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get promptDetailPauseMatchingConfirm;

  /// No description provided for @promptDetailPauseMatchingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get promptDetailPauseMatchingCancel;

  /// No description provided for @promptDetailRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get promptDetailRejectButton;

  /// No description provided for @promptDetailApproveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get promptDetailApproveButton;

  /// No description provided for @promptDetailApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Card approved'**
  String get promptDetailApprovedMessage;

  /// No description provided for @promptDetailRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Card rejected'**
  String get promptDetailRejectedMessage;

  /// No description provided for @promptEditNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get promptEditNextButton;

  /// No description provided for @promptEntryGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi{firstName} 👋'**
  String promptEntryGreeting(String firstName);

  /// No description provided for @promptEntryFirstTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'The next {count} cards are practice examples to help you learn how to answer them.'**
  String promptEntryFirstTimeDescription(int count);

  /// No description provided for @promptEntryDailyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your daily {count} cards are waiting for you.'**
  String promptEntryDailyDescription(int count);

  /// No description provided for @promptEntryButton.
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get promptEntryButton;

  /// No description provided for @promptFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Card submitted!'**
  String get promptFinishTitle;

  /// No description provided for @promptFinishDescription.
  ///
  /// In en, this message translates to:
  /// **'Your card has been successfully submitted and is being reviewed. We\'ll notify you once it\'s live.'**
  String get promptFinishDescription;

  /// No description provided for @promptFinishReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Reviews typically take less than 24 hours'**
  String get promptFinishReviewInfo;

  /// No description provided for @promptFinishDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get promptFinishDoneButton;

  /// No description provided for @promptPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get promptPreviewTitle;

  /// No description provided for @promptPreviewNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get promptPreviewNextButton;

  /// No description provided for @promptPreviewSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get promptPreviewSubmitButton;

  /// No description provided for @promptPreviewErrorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update prompt'**
  String get promptPreviewErrorUpdate;

  /// No description provided for @promptPreviewErrorSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit prompt'**
  String get promptPreviewErrorSubmit;

  /// No description provided for @promptSelectVenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Select audience'**
  String get promptSelectVenueTitle;

  /// No description provided for @promptSelectVenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where would you like to publish?'**
  String get promptSelectVenueSubtitle;

  /// No description provided for @promptSelectVenuePublicTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish publicly'**
  String get promptSelectVenuePublicTitle;

  /// No description provided for @promptSelectVenuePublicDescription.
  ///
  /// In en, this message translates to:
  /// **'Visible to all users'**
  String get promptSelectVenuePublicDescription;

  /// No description provided for @promptSelectVenueOrTitle.
  ///
  /// In en, this message translates to:
  /// **'Or select a specific venue'**
  String get promptSelectVenueOrTitle;

  /// No description provided for @promptSelectVenueNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get promptSelectVenueNextButton;

  /// No description provided for @promptSelectVenueSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get promptSelectVenueSubmitButton;

  /// No description provided for @promptSelectVenueErrorSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit prompt'**
  String get promptSelectVenueErrorSubmit;

  /// No description provided for @promptSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get promptSettingsTitle;

  /// No description provided for @promptSettingsSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get promptSettingsSubmitButton;

  /// No description provided for @promptSettingsErrorSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit prompt'**
  String get promptSettingsErrorSubmit;

  /// No description provided for @promptsViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cards'**
  String get promptsViewTitle;

  /// No description provided for @promptsViewEmptyActionButton.
  ///
  /// In en, this message translates to:
  /// **'Get matched'**
  String get promptsViewEmptyActionButton;

  /// No description provided for @venueCodeFieldPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get venueCodeFieldPlaceholder;

  /// No description provided for @venueDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Venue details'**
  String get venueDetailTitle;

  /// No description provided for @venueDetailErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load venue details'**
  String get venueDetailErrorLoading;

  /// No description provided for @venueDetailRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get venueDetailRetryButton;

  /// No description provided for @venueDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Venue not found'**
  String get venueDetailNotFound;

  /// No description provided for @venueDetailMemberSingular.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get venueDetailMemberSingular;

  /// No description provided for @venueDetailMembersPlural.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get venueDetailMembersPlural;

  /// No description provided for @venueDetailCardSingular.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get venueDetailCardSingular;

  /// No description provided for @venueDetailCardsPlural.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get venueDetailCardsPlural;

  /// No description provided for @venueDetailMatchSingular.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get venueDetailMatchSingular;

  /// No description provided for @venueDetailMatchesPlural.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get venueDetailMatchesPlural;

  /// No description provided for @venueDetailIntroductionSingular.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get venueDetailIntroductionSingular;

  /// No description provided for @venueDetailIntroductionsPlural.
  ///
  /// In en, this message translates to:
  /// **'Introductions'**
  String get venueDetailIntroductionsPlural;

  /// No description provided for @venueDetailMatchesAndIntrosTitle.
  ///
  /// In en, this message translates to:
  /// **'Matches & Introductions'**
  String get venueDetailMatchesAndIntrosTitle;

  /// No description provided for @venueDetailEmptyMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get venueDetailEmptyMatchesTitle;

  /// No description provided for @venueDetailEmptyMatchesDescription.
  ///
  /// In en, this message translates to:
  /// **'When members match through this venue, their profiles will appear here.'**
  String get venueDetailEmptyMatchesDescription;

  /// No description provided for @venueDetailOpenForMatchmaking.
  ///
  /// In en, this message translates to:
  /// **'Open for matchmaking'**
  String get venueDetailOpenForMatchmaking;

  /// No description provided for @venueDetailOpenFrom.
  ///
  /// In en, this message translates to:
  /// **'Open for matchmaking from {startDate}'**
  String venueDetailOpenFrom(String startDate);

  /// No description provided for @venueDetailOpenUntil.
  ///
  /// In en, this message translates to:
  /// **'Open for matchmaking until {endDate}'**
  String venueDetailOpenUntil(String endDate);

  /// No description provided for @venueDetailOpenFromUntil.
  ///
  /// In en, this message translates to:
  /// **'Open for matchmaking from {startDate} until {endDate}'**
  String venueDetailOpenFromUntil(String startDate, String endDate);

  /// No description provided for @venueProfilesViewTitle.
  ///
  /// In en, this message translates to:
  /// **'{venueName} Members'**
  String venueProfilesViewTitle(String venueName);

  /// No description provided for @venueProfilesViewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get venueProfilesViewEmptyTitle;

  /// No description provided for @venueProfilesViewEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This venue doesn\'t have any members yet.'**
  String get venueProfilesViewEmptyDescription;

  /// No description provided for @venuePromptsViewTitle.
  ///
  /// In en, this message translates to:
  /// **'{venueName} Cards'**
  String venuePromptsViewTitle(String venueName);

  /// No description provided for @venuePromptsViewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get venuePromptsViewEmptyTitle;

  /// No description provided for @venuePromptsViewEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This venue doesn\'t have any cards yet.'**
  String get venuePromptsViewEmptyDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
