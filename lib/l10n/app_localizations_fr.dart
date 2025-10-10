// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardTitle => 'Welcome to Venyu';

  @override
  String get onboardDescription =>
      'Venyu matches you with other entrepreneurs based on your shared goals, needs, and who you know. Answer 3 daily cards to help us find great matches for you.';

  @override
  String get onboardStartTutorial =>
      'Before we set up your profile, let\'s show you how Venyu works with a quick tutorial.';

  @override
  String get onboardButtonStart => 'Start';

  @override
  String get tutorialStep1Title => 'Answer 3 daily cards';

  @override
  String get tutorialStep1Description =>
      'Each day, you answer three cards from other entrepreneurs. It takes less than a minute and helps us find great matches for you.';

  @override
  String get tutorialStep2Title => 'Get matched';

  @override
  String get tutorialStep2Description =>
      'Our matching agent connects you with entrepreneurs who share your goals and needs. Each match will be relevant and worthwhile.';

  @override
  String get tutorialStep3Title => 'Show your interest';

  @override
  String get tutorialStep3Description =>
      'When a match catches your eye, say you\'re interested. It\'s your way of telling us you\'d like to be introduced to that person.';

  @override
  String get tutorialStep4Title => 'Get introduced';

  @override
  String get tutorialStep4Description =>
      'If there\'s mutual interest, we\'ll send an introduction email so you can start the conversation naturally.';

  @override
  String get tutorialStep5Title => 'You got it!';

  @override
  String get tutorialStep5Description =>
      'Now let\'s set up your profile and join the community.';

  @override
  String get tutorialButtonPrevious => 'Previous';

  @override
  String get tutorialButtonNext => 'Next';

  @override
  String get registrationCompleteTitle => 'Your profile is ready! 🎉';

  @override
  String get registrationCompleteDescription =>
      'Thanks for setting up your profile. Now let\'s see how answering 3 cards each day helps you get matched with the right people.';

  @override
  String get registrationCompleteButton => 'Continue';

  @override
  String get promptEntryTitleFirstTime => 'Let\'s try it out!';

  @override
  String get promptEntryDescriptionFirstTime =>
      'Here are 3 example cards to help you understand how it works. Don\'t worry, these are just for practice.';

  @override
  String get promptEntryButtonFirstTime => 'Start tutorial';

  @override
  String dailyPromptsHintSelect(String buttonTitle) {
    return 'Select \"$buttonTitle\" 👇';
  }

  @override
  String get dailyPromptsHintConfirm => 'Select \"Next\" to confirm';

  @override
  String get dailyPromptsButtonNext => 'Next';

  @override
  String get tutorialFinishedTitle => 'You\'re all set! 🎉';

  @override
  String get tutorialFinishedDescription =>
      'You\'ve completed the quick tour. Now you\'re ready to start answering your first 3 real cards to get matched with other entrepreneurs.';

  @override
  String get tutorialFinishedButton => 'Let\'s go!';

  @override
  String get registrationFinishTitle => 'That\'s it! 🎉';

  @override
  String get registrationFinishDescription =>
      'Your account is all set up and you\'ve answered your first 3 cards. Come back tomorrow to answer more cards and discover new matches.';

  @override
  String get registrationFinishButton => 'Start exploring!';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get buttonNext => 'Next';

  @override
  String get buttonPrevious => 'Previous';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonGotIt => 'Got it';

  @override
  String get errorNoCardsAvailable =>
      'No cards available at the moment. Check back later!';

  @override
  String get errorFailedToLoadCards =>
      'Failed to load cards. Please try again.';

  @override
  String get errorFailedToRefreshProfile =>
      'Failed to refresh profile. Please try again.';

  @override
  String get interactionTypeThisIsMeButton => 'I can help';

  @override
  String get interactionTypeLookingForThisButton => 'I need this';

  @override
  String get interactionTypeKnowSomeoneButton => 'I can refer';

  @override
  String get interactionTypeNotRelevantButton => 'I can\'t help';

  @override
  String get interactionTypeThisIsMeSelection => 'I can help';

  @override
  String get interactionTypeLookingForThisSelection => 'I need help';

  @override
  String get interactionTypeKnowSomeoneSelection => 'I can connect';

  @override
  String get interactionTypeNotRelevantSelection => 'Skip';

  @override
  String get interactionTypeThisIsMeSubtitle =>
      'Share your skills or experience';

  @override
  String get interactionTypeLookingForThisSubtitle =>
      'Ask for advice or support';

  @override
  String get interactionTypeKnowSomeoneSubtitle =>
      'Introduce people who can help';

  @override
  String get interactionTypeNotRelevantSubtitle => 'Pass on this one';

  @override
  String get interactionTypeThisIsMeHint =>
      'What skill or expertise can you offer?';

  @override
  String get interactionTypeLookingForThisHint =>
      'What specific help do you need?';

  @override
  String get interactionTypeKnowSomeoneHint =>
      'Who can you connect for this need?';

  @override
  String get interactionTypeNotRelevantHint => 'What would you like to share?';

  @override
  String get registrationStepNameTitle => 'Personal Information';

  @override
  String get registrationStepEmailTitle => 'Email Verification';

  @override
  String get registrationStepLocationTitle => 'Location';

  @override
  String get registrationStepCityTitle => 'City';

  @override
  String get registrationStepCompanyTitle => 'Company Information';

  @override
  String get registrationStepRolesTitle => 'Your Roles';

  @override
  String get registrationStepSectorsTitle => 'Your Sectors';

  @override
  String get registrationStepMeetingPreferencesTitle => 'Meeting Preferences';

  @override
  String get registrationStepNetworkingGoalsTitle => 'Networking Goals';

  @override
  String get registrationStepAvatarTitle => 'Profile Picture';

  @override
  String get registrationStepNotificationsTitle => 'Notifications';

  @override
  String get registrationStepCompleteTitle => 'Welcome to Venyu!';

  @override
  String get benefitNearbyMatchesTitle => 'Meet entrepreneurs nearby';

  @override
  String get benefitNearbyMatchesDescription => 'Discover people close to you';

  @override
  String get benefitDistanceAwarenessTitle => 'See who is within reach';

  @override
  String get benefitDistanceAwarenessDescription =>
      'Know the distance to matches';

  @override
  String get benefitBetterMatchingTitle => 'Grow your network locally';

  @override
  String get benefitBetterMatchingDescription =>
      'Get better results with local focus';

  @override
  String get benefitMatchNotificationsTitle => 'New match alerts';

  @override
  String get benefitMatchNotificationsDescription =>
      'Get alerted as soon as a new match appears';

  @override
  String get benefitConnectionNotificationsTitle => 'Never miss an intro';

  @override
  String get benefitConnectionNotificationsDescription =>
      'Know right away when you receive a new introduction';

  @override
  String get benefitDailyRemindersTitle => 'Stay in the game';

  @override
  String get benefitDailyRemindersDescription =>
      'Get reminded every day to make the net work';

  @override
  String get benefitFocusedReachTitle => 'Smart targeting';

  @override
  String get benefitFocusedReachDescription =>
      'Publish your questions to the right audience';

  @override
  String get benefitDiscreetPreviewTitle => 'First call';

  @override
  String get benefitDiscreetPreviewDescription =>
      'On your cards, you get the first call. Matches are only shown to others if you\'re interested.';

  @override
  String get benefitUnlimitedIntroductionsTitle => 'Infinite intros';

  @override
  String get benefitUnlimitedIntroductionsDescription =>
      'Keep growing your network with unlimited introductions and never miss an opportunity';

  @override
  String get benefitUnlockFullProfilesTitle => 'Full profiles';

  @override
  String get benefitUnlockFullProfilesDescription =>
      'Discover who\'s behind the match by seeing their avatar and checking mutual interests';

  @override
  String get benefitViewsAndImpressionsTitle => 'Views and impressions';

  @override
  String get benefitViewsAndImpressionsDescription =>
      'Understand your reach with simple stats';

  @override
  String get benefitDailyCardsBoostTitle => 'More daily cards';

  @override
  String get benefitDailyCardsBoostDescription =>
      'More cards to grow your network faster.';

  @override
  String get benefitAiPoweredMatchesTitle => 'AI-powered matches (later)';

  @override
  String get benefitAiPoweredMatchesDescription =>
      'Receive smart suggestions based on your profile.';

  @override
  String get editCompanyInfoNameTitle => 'Name & website';

  @override
  String get editCompanyInfoNameDescription => 'The name of your company';

  @override
  String get editPersonalInfoNameTitle => 'Name';

  @override
  String get editPersonalInfoNameDescription => 'Your name and LinkedIn URL.';

  @override
  String get editPersonalInfoBioTitle => 'Bio';

  @override
  String get editPersonalInfoBioDescription => 'A short intro about yourself.';

  @override
  String get editPersonalInfoLocationTitle => 'City';

  @override
  String get editPersonalInfoLocationDescription => 'The city you live in.';

  @override
  String get editPersonalInfoEmailTitle => 'Email';

  @override
  String get editPersonalInfoEmailDescription => 'Your contact email address.';

  @override
  String get profileEditAccountTitle => 'Account';

  @override
  String get profileEditAccountDescription => 'Manage your account';

  @override
  String get reviewTypeUserTitle => 'User generated';

  @override
  String get reviewTypeUserDescription => 'Cards submitted by users';

  @override
  String get reviewTypeSystemTitle => 'AI generated';

  @override
  String get reviewTypeSystemDescription => 'Daily generated cards by AI';

  @override
  String get appName => 'Venyu';

  @override
  String get appTagline => 'make the net work';

  @override
  String get navMatches => 'Intros';

  @override
  String get navCards => 'Cards';

  @override
  String get navNotifications => 'Updates';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionNext => 'Next';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionInterested => 'Interested';

  @override
  String get successSaved => 'Saved successfully';

  @override
  String get dialogRemoveAvatarTitle => 'Remove Avatar';

  @override
  String get dialogRemoveAvatarMessage =>
      'Are you sure you want to remove your avatar?';

  @override
  String get dialogRemoveButton => 'Remove';

  @override
  String get dialogOkButton => 'OK';

  @override
  String get dialogErrorTitle => 'Error';

  @override
  String get dialogLoadingMessage => 'Loading...';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address';

  @override
  String get validationUrlInvalid =>
      'Please enter a valid URL (starting with http:// or https://)';

  @override
  String get validationLinkedInUrlInvalid =>
      'Please enter a valid LinkedIn profile URL\n(e.g., https://www.linkedin.com/in/yourname)';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String get validationFieldRequiredDefault => 'This field is required';

  @override
  String validationMinLength(String fieldName, int minLength) {
    return '$fieldName must be at least $minLength characters long';
  }

  @override
  String validationMaxLength(String fieldName, int maxLength) {
    return '$fieldName cannot exceed $maxLength characters';
  }

  @override
  String get validationOtpRequired => 'Verification code is required';

  @override
  String get validationOtpLength => 'Verification code must be 6 digits';

  @override
  String get validationOtpNumeric =>
      'Verification code must contain only numbers';

  @override
  String get imageSourceCameraTitle => 'Camera';

  @override
  String get imageSourceCameraDescription => 'Take a new photo';

  @override
  String get imageSourcePhotoLibraryTitle => 'Photo Library';

  @override
  String get imageSourcePhotoLibraryDescription => 'Choose from library';

  @override
  String get pagesProfileEditTitle => 'Profile Edit';

  @override
  String get pagesProfileEditDescription => 'Edit profile information';

  @override
  String get pagesLocationTitle => 'Location';

  @override
  String get pagesLocationDescription => 'Location settings';

  @override
  String get promptSectionCardTitle => 'Status';

  @override
  String get promptSectionCardDescription => 'View your card details';

  @override
  String get promptSectionStatsTitle => 'Stats';

  @override
  String get promptSectionStatsDescription => 'Performance and analytics';

  @override
  String get promptSectionIntroTitle => 'Intros';

  @override
  String get promptSectionIntroDescription => 'Matches and introductions';

  @override
  String get promptStatusDraftDisplay => 'Draft';

  @override
  String get promptStatusDraftInfo =>
      'Your card is saved as a draft. Complete and submit it to start getting matches.';

  @override
  String get promptStatusPendingReviewDisplay => 'Pending Review';

  @override
  String get promptStatusPendingReviewInfo =>
      'Your card is being reviewed by our team. This usually takes 12-24 hours to check if the content follows community guidelines.';

  @override
  String get promptStatusPendingTranslationDisplay => 'Pending Translation';

  @override
  String get promptStatusPendingTranslationInfo =>
      'Your card is being translated to other languages.';

  @override
  String get promptStatusApprovedDisplay => 'Approved';

  @override
  String get promptStatusApprovedInfo =>
      'Your card has been approved and is live. You can receive matches.';

  @override
  String get promptStatusRejectedDisplay => 'Rejected';

  @override
  String get promptStatusRejectedInfo =>
      'Your card was rejected for not following community guidelines. Please edit and resubmit.';

  @override
  String get promptStatusArchivedDisplay => 'Archived';

  @override
  String get promptStatusArchivedInfo =>
      'Your card has been archived and is no longer visible to other users.';

  @override
  String get venueTypeEventDisplayName => 'Event';

  @override
  String get venueTypeEventDescription =>
      'Temporary venue for events, conferences, or meetups';

  @override
  String get venueTypeOrganisationDisplayName => 'Community';

  @override
  String get venueTypeOrganisationDescription =>
      'Permanent venue for companies or organizations';
}
