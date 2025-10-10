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
  /// **'Venyu matches you with other entrepreneurs based on your shared goals, needs, and who you know. Answer 3 daily cards to help us find great matches for you.'**
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
