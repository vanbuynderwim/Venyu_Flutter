// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardTitle => 'Welcome to Venyu';

  @override
  String get onboardDescription =>
      'You\'re now part of a community built on real introductions!\n\nLet\'s start with a quick tour before setting up your profile.';

  @override
  String get onboardStartTutorial =>
      'Before we set up your profile, let\'s show you how Venyu works with a quick tutorial.';

  @override
  String get onboardButtonStart => 'Start';

  @override
  String get tutorialStep1Title => 'Prompts';

  @override
  String get tutorialStep1Description =>
      'Every day, you can answer 3 prompts. It takes less than a minute and helps us find the right matches for you.';

  @override
  String get tutorialStep2Title => 'Matches';

  @override
  String get tutorialStep2Description =>
      'Once we’ve found the right match, we’ll let you know so you can decide if you’d like an introduction.';

  @override
  String get tutorialStep3Title => 'Introductions';

  @override
  String get tutorialStep3Description =>
      'When the interest is mutual, we\'ll make the introduction via email so you can connect directly.';

  @override
  String get tutorialStep4Title => 'You\'re all set!';

  @override
  String get tutorialStep4Description =>
      'Let’s complete your profile and start finding the right matches.';

  @override
  String get tutorialButtonPrevious => 'Previous';

  @override
  String get tutorialButtonNext => 'Next';

  @override
  String get registrationCompleteTitle => 'Your profile is ready! 🎉';

  @override
  String get registrationCompleteDescription =>
      'Thanks for setting up your profile. Now let\'s see how answering 3 prompts each day helps us finding the right match for you.';

  @override
  String get registrationCompleteButton => 'Continue';

  @override
  String get promptEntryTitleFirstTime => 'Let\'s try it out!';

  @override
  String get promptEntryDescriptionFirstTime =>
      'Here are 3 example prompts to help you understand how it works. Don\'t worry, these are just for practice.';

  @override
  String get promptEntryButtonFirstTime => 'Start tutorial';

  @override
  String dailyPromptsHintSelect(String buttonTitle) {
    return 'Select \"$buttonTitle\"';
  }

  @override
  String get dailyPromptsHintConfirm => 'Select \"Next\"';

  @override
  String get dailyPromptsButtonNext => 'Next';

  @override
  String get dailyPromptsReportSuccess => 'Prompt reported successfully';

  @override
  String get dailyPromptsReportError => 'Failed to report prompt';

  @override
  String get dailyPromptsNoPromptsAvailable => 'No prompts available';

  @override
  String get dailyPromptsExampleTag => 'Example prompt';

  @override
  String get dailyPromptsReferralCodeSent =>
      'Check your email for an invite code to share with your referral';

  @override
  String get tutorialFinishedTitle => 'You\'re all set! 🎉';

  @override
  String get tutorialFinishedDescription =>
      'You\'ve completed the quick tour. Now you\'re ready to start answering your first 3 real prompts to get matched with other entrepreneurs.';

  @override
  String get tutorialFinishedButton => 'Let\'s go!';

  @override
  String get registrationFinishTitle => 'That\'s it! 🎉';

  @override
  String get registrationFinishDescription =>
      'Your account is all set up and you\'ve answered your first 3 prompts. Come back tomorrow to answer more prompts and discover new matches.';

  @override
  String get registrationFinishButton => 'Done!';

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
      'No Prompts available at the moment. Check back later!';

  @override
  String get errorFailedToLoadCards =>
      'Failed to load prompts. Please try again.';

  @override
  String get errorFailedToRefreshProfile =>
      'Failed to refresh profile. Please try again.';

  @override
  String get errorNoInternetConnection =>
      'No internet connection. Please check your connection and try again.';

  @override
  String get errorAuthenticationFailed => 'Sign in failed. Please try again.';

  @override
  String get interactionTypeThisIsMeButton => 'I can help';

  @override
  String get interactionTypeLookingForThisButton => 'I need this';

  @override
  String get interactionTypeKnowSomeoneButton => 'I can refer';

  @override
  String get interactionTypeNotRelevantButton => 'Not for me';

  @override
  String get interactionTypeThisIsMeSelection => 'I can help';

  @override
  String get interactionTypeLookingForThisSelection => 'I’m looking for advice';

  @override
  String get interactionTypeKnowSomeoneSelection => 'I can connect';

  @override
  String get interactionTypeNotRelevantSelection => 'Skip';

  @override
  String get interactionTypeThisIsMeSubtitle => 'Share how you can add value';

  @override
  String get interactionTypeLookingForThisSubtitle =>
      'Ask for the expertise or advice you need';

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
      'What specific expertise or advice do you need?';

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
  String get registrationStepLocationTitle => 'Share location';

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
      'On your prompts, you get the first call. Matches are only shown to others if you\'re interested.';

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
  String get benefitDailyCardsBoostTitle => 'More daily prompts';

  @override
  String get benefitDailyCardsBoostDescription =>
      'More prompts to grow your network faster.';

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
  String get editPersonalInfoNameDescription => 'Your name and LinkedIn URL';

  @override
  String get editPersonalInfoBioTitle => 'Bio';

  @override
  String get editPersonalInfoBioDescription => 'A short intro about yourself';

  @override
  String get editPersonalInfoLocationTitle => 'City';

  @override
  String get editPersonalInfoLocationDescription => 'The city you live in';

  @override
  String get editPersonalInfoEmailTitle => 'Email';

  @override
  String get editPersonalInfoEmailDescription => 'Your contact email address';

  @override
  String get profileEditAccountTitle => 'Account';

  @override
  String get profileEditAccountDescription => 'Manage your account';

  @override
  String get reviewTypeUserTitle => 'User generated';

  @override
  String get reviewTypeUserDescription => 'Prompts submitted by users';

  @override
  String get reviewTypeSystemTitle => 'AI generated';

  @override
  String get reviewTypeSystemDescription => 'Daily generated prompts by AI';

  @override
  String get appName => 'Venyu';

  @override
  String get appTagline => 'make the net work';

  @override
  String get navMatches => 'Matches';

  @override
  String get navCards => 'Prompts';

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
  String get actionSkip => 'Not now';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionInterested => 'Introduce me';

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
  String get promptSectionCardDescription => 'View your prompt details';

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
      'Your prompt is saved as a draft. Complete and submit it to start getting matches.';

  @override
  String get promptStatusPendingReviewDisplay => 'Pending Review';

  @override
  String get promptStatusPendingReviewInfo =>
      'Your prompt is being reviewed by our team. This usually takes 12-24 hours to check if the content follows community guidelines.';

  @override
  String get promptStatusPendingTranslationDisplay => 'Pending Translation';

  @override
  String get promptStatusPendingTranslationInfo =>
      'Your prompt is being translated to other languages.';

  @override
  String get promptStatusApprovedDisplay => 'Approved';

  @override
  String get promptStatusApprovedInfo =>
      'Your prompt has been approved and is live. You can receive matches.';

  @override
  String get promptStatusRejectedDisplay => 'Rejected';

  @override
  String get promptStatusRejectedInfo =>
      'Your prompt was rejected for not following community guidelines. Please edit and resubmit.';

  @override
  String get promptStatusArchivedDisplay => 'Archived';

  @override
  String get promptStatusArchivedInfo =>
      'Your prompt has been archived and is no longer visible to other users.';

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

  @override
  String get emptyStateNotificationsTitle => 'All caught up!';

  @override
  String get emptyStateNotificationsDescription =>
      'When something happens that you should know about, we\'ll update you here';

  @override
  String get emptyStateReviewsTitle => 'All caught up!';

  @override
  String get emptyStateReviewsDescription =>
      'When prompts are submitted for review, they will appear here';

  @override
  String get emptyStateMatchesTitle => 'Waiting for your first match!';

  @override
  String get emptyStateMatchesDescription =>
      'Once you have a match, it will appear here. Write a new prompt to get matched faster.';

  @override
  String get emptyStatePromptsTitle => 'Ready to get matched?';

  @override
  String get emptyStatePromptsDescription =>
      'Prompts help us find the right matches that lead to real introductions. Write yours to get started.';

  @override
  String get authGoogleRetryingMessage => 'Please wait...';

  @override
  String get redeemInviteTitle => 'Enter your invite code';

  @override
  String get redeemInviteSubtitle =>
      'Please enter the 8-character invite code you received to continue.';

  @override
  String get redeemInviteContinue => 'Continue';

  @override
  String get redeemInvitePlaceholder => 'Enter invite code';

  @override
  String get waitlistFinishTitle => 'You\'re on the list!';

  @override
  String get waitlistFinishDescription =>
      'Thanks for joining the Venyu waitlist. We\'ll notify you as soon as new spots open up.';

  @override
  String get waitlistFinishButton => 'Done';

  @override
  String get waitlistTitle => 'Join the waitlist';

  @override
  String get waitlistDescription =>
      'Venyu is invite-only. Join the waitlist and get invited when new spots are open.';

  @override
  String get waitlistNameHint => 'Your full name';

  @override
  String get waitlistCompanyHint => 'Your company name';

  @override
  String get waitlistRoleHint => 'Your role / title';

  @override
  String get waitlistEmailHint => 'Your email address';

  @override
  String get waitlistButton => 'Join waitlist';

  @override
  String get waitlistErrorDuplicate => 'This email is already on the waitlist';

  @override
  String get waitlistErrorFailed =>
      'Failed to join waitlist. Please try again.';

  @override
  String get waitlistSuccessMessage =>
      'You\'ve been added to the waitlist! We\'ll notify you when we\'re ready.';

  @override
  String get inviteScreeningTitle => 'Welcome to venyu 🤝';

  @override
  String get inviteScreeningDescription =>
      'The invite-only community for entrepreneurs where the right matches lead to real introductions.';

  @override
  String get inviteScreeningHasCode => 'I have an invite code';

  @override
  String get inviteScreeningNoCode => 'I don\'t have an invite code';

  @override
  String onboardWelcome(String name) {
    return 'Welcome $name 👋';
  }

  @override
  String get onboardStart => 'Start';

  @override
  String get loginLegalText =>
      'By signing in, you agree to our Terms of Service and Privacy Policy';

  @override
  String get joinVenueTitle => 'Join venue';

  @override
  String get joinVenueSubtitle => 'Enter the 8-character invite code to join.';

  @override
  String get joinVenueButton => 'Join';

  @override
  String get joinVenuePlaceholder => 'Enter venue code';

  @override
  String get matchDetailLoading => 'Loading...';

  @override
  String get matchDetailTitleIntroduction => 'Introduction';

  @override
  String get matchDetailTitleMatch => 'Match';

  @override
  String get matchDetailMenuReport => 'Report';

  @override
  String get matchDetailMenuRemove => 'Remove';

  @override
  String get matchDetailMenuBlock => 'Block';

  @override
  String get matchDetailReportSuccess => 'Profile reported successfully';

  @override
  String get matchDetailBlockTitle => 'Block User?';

  @override
  String get matchDetailBlockMessage =>
      'Blocking this user will remove the match and prevent future matching. This action cannot be undone.';

  @override
  String get matchDetailBlockButton => 'Block';

  @override
  String get matchDetailBlockSuccess => 'User blocked successfully';

  @override
  String matchDetailRemoveTitle(String type) {
    return 'Remove $type?';
  }

  @override
  String matchDetailRemoveMessage(String type) {
    return 'Are you sure you want to remove this $type? This action cannot be undone.';
  }

  @override
  String get matchDetailRemoveButton => 'Remove';

  @override
  String get matchDetailRemoveSuccessIntroduction =>
      'Introduction removed successfully';

  @override
  String get matchDetailRemoveSuccessMatch => 'Match removed successfully';

  @override
  String get matchDetailTypeIntroduction => 'introduction';

  @override
  String get matchDetailTypeMatch => 'match';

  @override
  String get matchDetailErrorLoad => 'Failed to load match details';

  @override
  String get matchDetailRetry => 'Retry';

  @override
  String get matchDetailNotFound => 'Match not found';

  @override
  String get matchDetailLimitTitle => 'Monthly limit reached';

  @override
  String get matchDetailLimitMessage =>
      'You\'ve reached your limit of 3 intros per month. Upgrade to Venyu Pro for unlimited introductions.';

  @override
  String get matchDetailLimitButton => 'Upgrade to Pro';

  @override
  String get matchDetailFirstCallTitle => 'First Call active';

  @override
  String matchDetailMatchingCards(int count, String cards) {
    return '$count matched $cards';
  }

  @override
  String get matchDetailCard => 'prompt';

  @override
  String get matchDetailCards => 'prompts';

  @override
  String matchDetailSharedIntros(int count, String intros) {
    return '$count shared $intros';
  }

  @override
  String get matchDetailIntroduction => 'introduction';

  @override
  String get matchDetailIntroductions => 'introductions';

  @override
  String matchDetailSharedVenues(int count, String venues) {
    return '$count shared $venues';
  }

  @override
  String get matchDetailVenue => 'venue';

  @override
  String get matchDetailVenues => 'venues';

  @override
  String matchDetailCompanyFacts(int count, String areas) {
    return 'Professional: $count shared $areas';
  }

  @override
  String matchDetailPersonalInterests(int count, String areas) {
    return 'Personal: $count shared $areas';
  }

  @override
  String get matchDetailArea => 'area';

  @override
  String get matchDetailAreas => 'areas';

  @override
  String matchDetailWhyMatch(String name) {
    return 'Why you and $name match';
  }

  @override
  String get matchDetailUnlockTitle => 'Unlock mutual interests';

  @override
  String matchDetailUnlockMessage(String name) {
    return 'See what you share on a personal level with $name';
  }

  @override
  String get matchDetailUnlockButton => 'Upgrade now';

  @override
  String matchDetailInterestedInfoMessage(String name) {
    return 'Would you like an introduction to $name?';
  }

  @override
  String get matchDetailEmailSubject => 'We are connected on Venyu!';

  @override
  String get matchOverviewYou => 'You';

  @override
  String get profileAvatarMenuCamera => 'Camera';

  @override
  String get profileAvatarMenuGallery => 'Gallery';

  @override
  String get profileAvatarMenuView => 'View';

  @override
  String get profileAvatarMenuRemove => 'Remove';

  @override
  String profileAvatarErrorAction(String error) {
    return 'Avatar action failed: $error';
  }

  @override
  String get profileAvatarErrorUpload =>
      'Failed to upload photo. Please try again.';

  @override
  String get profileAvatarErrorRemove =>
      'Failed to remove photo. Please try again.';

  @override
  String get profileAvatarErrorTitle => 'Error';

  @override
  String get profileAvatarErrorButton => 'OK';

  @override
  String get profileInfoAddCompanyInfo => 'Add company info';

  @override
  String get venuesErrorLoading => 'Error loading venues';

  @override
  String get venuesRetry => 'Retry';

  @override
  String get venuesEmptyTitle => 'Your venues will appear here';

  @override
  String get venuesEmptyDescription =>
      'Got an invite code? Redeem it to join that venue and start getting real introductions in the community.';

  @override
  String get venuesEmptyAction => 'Join a venue';

  @override
  String invitesAvailableDescription(int count, String codes) {
    return 'You have $count invite $codes ready to share. Each one unlocks Venyu for a new entrepreneur';
  }

  @override
  String get invitesCode => 'code';

  @override
  String get invitesCodes => 'codes';

  @override
  String get invitesAllSharedDescription =>
      'All your invite codes have been shared. Thank you for helping grow the Venyu community.';

  @override
  String get invitesGenerateMore => 'Generate more codes';

  @override
  String get invitesEmptyTitle => 'No invite codes yet';

  @override
  String get invitesEmptyDescription =>
      'Your invite codes will appear here. You can share them with friends to invite them to Venyu.';

  @override
  String get invitesEmptyAction => 'Generate codes';

  @override
  String get invitesSubtitleAvailable => 'Available codes';

  @override
  String get invitesSubtitleShared => 'Shared codes';

  @override
  String get invitesSubtitleRedeemed => 'Redeemed codes';

  @override
  String get invitesMenuShare => 'Share';

  @override
  String get invitesMenuCopy => 'Copy';

  @override
  String get invitesMenuMarkShared => 'Mark as shared';

  @override
  String get invitesShareSubject => 'Your personal Venyu invite';

  @override
  String invitesShareText(String code) {
    return 'Join me on Venyu! \n\nThe invite-only community for entrepreneurs where the right matches lead to real introduction.\n\nDownload the app at 👉 www.getvenyu.com\n\n🔑 Your invite code: \n\n$code';
  }

  @override
  String get invitesCopiedToast => 'Invite code copied to clipboard';

  @override
  String get invitesMarkedSentToast => 'Invite code marked as sent';

  @override
  String get invitesMarkedSentError => 'Failed to mark invite as sent';

  @override
  String get invitesGenerateDialogTitle => 'Generate more codes';

  @override
  String get invitesGenerateDialogMessage =>
      'Generate 5 new invite codes? These will expire in 1 year.';

  @override
  String get invitesGenerateDialogConfirm => 'Generate';

  @override
  String get invitesGenerateDialogCancel => 'Cancel';

  @override
  String get invitesGenerateSuccessToast =>
      '5 new invite codes generated successfully';

  @override
  String get invitesGenerateErrorToast => 'Failed to generate invite codes';

  @override
  String get companySectionEmptyTagGroups => 'No company tag groups available';

  @override
  String get personalSectionEmptyTagGroups =>
      'No personal tag groups available';

  @override
  String get profileSectionPersonalTitle => 'Personal';

  @override
  String get profileSectionPersonalDescription => 'Personal information';

  @override
  String get profileSectionCompanyTitle => 'Professional';

  @override
  String get profileSectionCompanyDescription => 'Professional information';

  @override
  String get profileSectionVenuesTitle => 'Venues';

  @override
  String get profileSectionVenuesDescription => 'Events and organizations';

  @override
  String get profileSectionInvitesTitle => 'Codes';

  @override
  String get profileSectionInvitesDescription => 'Invites and invitations';

  @override
  String get profileSectionReviewsTitle => 'Reviews';

  @override
  String get profileSectionReviewsDescription => 'User reviews and feedback';

  @override
  String get editAccountTitle => 'Account settings';

  @override
  String get editAccountDataExportTitle => 'Data Export';

  @override
  String get editAccountDataExportDescription =>
      'You can request a copy of all your personal data. This includes your profile information, prompts, matches, and activity history. The export will be sent to your registered email address.';

  @override
  String get editAccountExportDataButton => 'Export all your data';

  @override
  String get editAccountDeleteTitle => 'Delete Account';

  @override
  String get editAccountDeleteDescription =>
      'Deleting your account is permanent. All your data, including your profile, prompts and matches will be removed.';

  @override
  String get editAccountDeleteButton => 'Delete account';

  @override
  String get editAccountLogoutButton => 'Logout';

  @override
  String get editAccountExportDialogTitle => 'Export data';

  @override
  String get editAccountExportDialogMessage =>
      'You will receive a data export link in your email as soon as your data is ready.';

  @override
  String get editAccountExportDialogCancel => 'Cancel';

  @override
  String get editAccountExportDialogConfirm => 'Export';

  @override
  String get editAccountExportSuccessMessage =>
      'An email will be sent once the export is ready';

  @override
  String get editAccountExportErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get editAccountDeleteDialogTitle => 'Delete account';

  @override
  String get editAccountDeleteDialogMessage =>
      'Your account and all its data will be permanently deleted immediately. This action cannot be undone. Are you sure you want to continue?';

  @override
  String get editAccountDeleteDialogCancel => 'Cancel';

  @override
  String get editAccountDeleteDialogConfirm => 'Delete';

  @override
  String get editAccountDeleteErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get editAccountLogoutDialogTitle => 'Logout';

  @override
  String get editAccountLogoutDialogMessage =>
      'Are you sure you want to logout?';

  @override
  String get editAccountLogoutDialogCancel => 'Cancel';

  @override
  String get editAccountLogoutDialogConfirm => 'Logout';

  @override
  String get editAccountLogoutErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get editTagGroupSavingButton => 'Saving...';

  @override
  String get editTagGroupNextButton => 'Next';

  @override
  String get editTagGroupSaveButton => 'Save';

  @override
  String get editTagGroupLoadErrorTitle => 'Failed to load tags';

  @override
  String get editTagGroupRetryButton => 'Retry';

  @override
  String get editTagGroupNoTagsMessage => 'No tags available';

  @override
  String get editTagGroupSaveErrorTitle => 'Error';

  @override
  String editTagGroupSaveErrorMessage(String error) {
    return 'Failed to save changes: $error';
  }

  @override
  String get editTagGroupErrorDialogOk => 'OK';

  @override
  String get editNotificationsTitle => 'Notifications';

  @override
  String get editNotificationsSavedMessage => 'Notifications saved';

  @override
  String get editNotificationsSaveErrorMessage =>
      'Failed to save notifications';

  @override
  String get editNotificationsEnableTitle => 'Enable notifications to ...';

  @override
  String get editNotificationsNotNowButton => 'Not now';

  @override
  String get editNotificationsEnableButton => 'Enable';

  @override
  String get editNotificationsPermissionDialogTitle =>
      'Notification Permission Required';

  @override
  String get editNotificationsPermissionDialogMessage =>
      'Notification permission has been denied. Please enable it in your device settings to receive updates.';

  @override
  String get editNotificationsPermissionDialogNotNow => 'Not now';

  @override
  String get editNotificationsPermissionDialogOpenSettings => 'Open Settings';

  @override
  String get editNotificationsLaterMessage =>
      'You can enable notifications later in settings';

  @override
  String get editNotificationsEnableErrorMessage =>
      'Failed to enable notifications. You can try again in settings.';

  @override
  String get editLocationTitle => 'Location';

  @override
  String get editLocationSavedMessage => 'Location saved';

  @override
  String get editLocationSaveErrorMessage => 'Failed to save location';

  @override
  String get editLocationEnableTitle => 'Enable location to';

  @override
  String get editLocationNotNowButton => 'Not now';

  @override
  String get editLocationEnableButton => 'Enable';

  @override
  String get editLocationServicesDisabledMessage =>
      'Location services are disabled. Please enable them in settings.';

  @override
  String get editLocationPermissionDeniedMessage =>
      'Location permission denied. You can enable it later in settings.';

  @override
  String get editLocationPermissionDialogTitle =>
      'Location Permission Required';

  @override
  String get editLocationPermissionDialogMessage =>
      'Location permission has been permanently denied. Please enable it in your device settings to use this feature.';

  @override
  String get editLocationPermissionDialogNotNow => 'Not now';

  @override
  String get editLocationPermissionDialogOpenSettings => 'Open Settings';

  @override
  String get editLocationCoordinatesErrorMessage =>
      'Could not get location coordinates';

  @override
  String get editLocationEnableErrorMessage =>
      'Failed to enable location. Please try again.';

  @override
  String get editLocationUnavailableMessage =>
      'Could not retrieve your location. You can add it later in settings.';

  @override
  String get editLocationApproximateInfo =>
      'Using approximate location. Enable \'Precise Location\' in settings for better matching.';

  @override
  String get editNameTitle => 'You';

  @override
  String get editNameSuccessMessage => 'Changes successfully saved';

  @override
  String get editNameErrorMessage => 'Failed to update, please try again';

  @override
  String get editNameLinkedInFormatError => 'LinkedIn URL format is invalid';

  @override
  String get editNameLinkedInMismatchDialogTitle =>
      'We couldn\'t find your name in your LinkedIn URL';

  @override
  String get editNameLinkedInMismatchDialogMessage =>
      'Your LinkedIn URL doesn\'t seem to contain your first and last name. You can continue or double-check your URL.';

  @override
  String get editNameLinkedInMismatchDialogCheckUrl => 'Check URL';

  @override
  String get editNameLinkedInMismatchDialogContinue => 'Continue anyway';

  @override
  String get editNameFirstNameLabel => 'FIRST NAME';

  @override
  String get editNameFirstNameHint => 'First name';

  @override
  String get editNameLastNameLabel => 'LAST NAME';

  @override
  String get editNameLastNameHint => 'Last name';

  @override
  String get editNameLinkedInLabel => 'LINKEDIN URL';

  @override
  String get editNameLinkedInHint => 'linkedin.com/in/your-name';

  @override
  String get editNameLinkedInInfoMessage =>
      'We\'ll only share your LinkedIn profile in the introduction email once there\'s mutual interest. It\'s never shared when you first get matched.';

  @override
  String get editNameLinkedInMobileTip =>
      'On the LinkedIn mobile app: Go to your profile → tap the three dots (•••) → select \'Share profile\' → tap \'Copy link\'';

  @override
  String get editEmailTitle => 'Email address';

  @override
  String get editEmailSendCodeButton => 'Send verification code';

  @override
  String get editEmailAddressLabel => 'EMAIL ADDRESS';

  @override
  String editEmailCodeSentMessage(String email) {
    return 'A verification code has been sent to $email. Please also check the spam folder.';
  }

  @override
  String get editEmailSuccessMessage => 'Contact email address updated';

  @override
  String get editEmailSendCodeErrorMessage =>
      'Failed to send confirmation code, please try again';

  @override
  String get editEmailVerifyCodeErrorMessage =>
      'Failed to verify code, please try again';

  @override
  String get editEmailVerifyCodeButton => 'Verify code';

  @override
  String get editEmailAddressHint => 'A valid email address';

  @override
  String get editEmailInfoMessage =>
      'We\'ll only use this email for app notifications like new matches, introductions and important updates';

  @override
  String get editEmailNewsletterLabel => 'SUBSCRIBE FOR VENYU UPDATES';

  @override
  String get editEmailVerificationCodeLabel => 'Verification code';

  @override
  String get editEmailVerificationCodeHint => 'Enter 6-digit code';

  @override
  String get editEmailOtpInfoMessage =>
      'Please check your spam folder if you don\'t see the verification code.';

  @override
  String get editCityTitle => 'City';

  @override
  String get editCitySavedMessage => 'City saved';

  @override
  String get editCityErrorMessage => 'Failed to update city, please try again';

  @override
  String get editCityCityLabel => 'CITY';

  @override
  String get editCityCityHint => 'City';

  @override
  String get editCityInfoMessage =>
      'Your city is only shared with people you get introduced to, not with matches. This helps facilitate better in-person meetups once a connection is established.';

  @override
  String get editCompanyNameTitle => 'Company name';

  @override
  String get editCompanyNameSuccessMessage => 'Company info changes saved';

  @override
  String get editCompanyNameErrorMessage =>
      'Failed to update company info, please try again';

  @override
  String get editCompanyNameCompanyLabel => 'COMPANY NAME';

  @override
  String get editCompanyNameCompanyHint => 'Company name';

  @override
  String get editCompanyNameWebsiteLabel => 'WEBSITE';

  @override
  String get editCompanyNameWebsiteHint => 'Website';

  @override
  String get editCompanyNameInfoMessage =>
      'Your company name and website are only shared with people you get introduced to, not with matches. They help make introductions more meaningful and relevant.';

  @override
  String get editAvatarTitle => 'Profile Picture';

  @override
  String get editAvatarSuccessMessage => 'Profile picture saved';

  @override
  String get editAvatarErrorMessage => 'Failed to save profile picture';

  @override
  String get editAvatarRemoveButton => 'Remove';

  @override
  String get editAvatarAddTitle => 'Add a profile picture';

  @override
  String get editAvatarInfoMessage =>
      'Your photo is often your first impression. Choose a clear, friendly headshot that feels like you. It will appear blurred in matches, but visible once you\'re introduced.';

  @override
  String get editAvatarCameraButton => 'Camera';

  @override
  String get editAvatarGalleryButton => 'Gallery';

  @override
  String get editAvatarNextButton => 'Next';

  @override
  String get editBioTitle => 'About you';

  @override
  String get editBioSuccessMessage => 'Profile bio saved';

  @override
  String get editBioErrorMessage =>
      'Failed to update profile bio, please try again';

  @override
  String get editBioInfoMessage =>
      'Your bio is visible to everyone you match with. Keep in mind: if you don\'t want certain personal details to be known before an introduction (such as your company name, LinkedIn profile, or other identifying information), please leave those out.\n\nUse this space to highlight your experience, interests, and what you\'re open to, without sharing sensitive details you\'d rather keep private until after an introduction is made.';

  @override
  String get editBioPlaceholder => 'Write your bio here...';

  @override
  String get promptCardCreatedLabel => 'Created';

  @override
  String get promptCardReviewedLabel => 'Reviewed';

  @override
  String get promptCardStatusLabel => 'Status';

  @override
  String get promptCardUpgradeTitle => 'Extend your prompt visibility';

  @override
  String get promptCardUpgradeSubtitle =>
      'Upgrade to Venyu Pro to keep your prompt online for 10 days instead of 3.';

  @override
  String get promptCardUpgradeButton => 'Upgrade to Pro';

  @override
  String get promptIntroErrorMessage => 'Failed to load matches';

  @override
  String get promptIntroRetryButton => 'Retry';

  @override
  String get promptIntroEmptyTitle => 'No matches yet';

  @override
  String get promptIntroEmptyDescription =>
      'When people match with your prompt, their profiles will appear here.';

  @override
  String get promptStatsTitle => 'Stats coming soon';

  @override
  String get promptStatsDescription =>
      'Track your prompt\'s performance, views, and engagement metrics.';

  @override
  String interactionTypeSelectionTitleFromPrompts(String name) {
    return 'Thank you$name';
  }

  @override
  String get interactionTypeSelectionTitleDefault => 'Make the net work';

  @override
  String get interactionTypeSelectionSubtitleFromPrompts =>
      'Now, let\'s make the net work for you';

  @override
  String get interactionTypeSelectionSubtitleDefault => 'Write your own prompt';

  @override
  String get interactionTypeSelectionDisclaimerText =>
      'All prompts are subject to review before going live';

  @override
  String get interactionTypeSelectionShowGuidelines =>
      'Show community guidelines';

  @override
  String get interactionTypeSelectionHideGuidelines =>
      'Hide community guidelines';

  @override
  String get interactionTypeSelectionNotNowButton => 'Not now';

  @override
  String get promptDetailTitle => 'Prompt detail';

  @override
  String get promptDetailStatusTitle => 'Status';

  @override
  String get promptDetailHowYouMatchTitle => 'How you match';

  @override
  String get promptDetailHowYouMatchDescription =>
      'Pause a matching option to temporarily stop receiving matches. Resume to start matching again.';

  @override
  String get promptDetailFirstCallTitle => 'First Call';

  @override
  String get promptDetailPublishedInTitle => 'Published in';

  @override
  String get promptDetailMatchesTitle => 'Matches';

  @override
  String get promptDetailErrorMessage => 'Failed to load prompt';

  @override
  String get promptDetailErrorDataMessage => 'Failed to load prompt data';

  @override
  String get promptDetailRetryButton => 'Retry';

  @override
  String get promptDetailEmptyMatchesTitle => 'No matches yet';

  @override
  String get promptDetailEmptyMatchesDescription =>
      'When people match with your prompt, their profiles will appear here.';

  @override
  String get promptDetailEditButton => 'Edit prompt';

  @override
  String get promptDetailPreviewUpdatedMessage => 'Preview setting updated';

  @override
  String get promptDetailMatchSettingUpdatedMessage => 'Match setting updated';

  @override
  String get promptDetailPauseMatchingTitle => 'Pause matching?';

  @override
  String promptDetailPauseMatchingMessage(String interactionType) {
    return 'You will no longer receive matches for \"$interactionType\" on this prompt. You can resume matching anytime.';
  }

  @override
  String get promptDetailPauseMatchingConfirm => 'Pause';

  @override
  String get promptDetailPauseMatchingCancel => 'Cancel';

  @override
  String get promptDetailRejectButton => 'Reject';

  @override
  String get promptDetailApproveButton => 'Approve';

  @override
  String get promptDetailApprovedMessage => 'Prompt approved';

  @override
  String get promptDetailRejectedMessage => 'Prompt rejected';

  @override
  String get promptDetailDeleteButton => 'Delete prompt';

  @override
  String get promptDetailDeleteConfirmTitle => 'Delete prompt?';

  @override
  String get promptDetailDeleteConfirmMessage =>
      'This will permanently delete your prompt. This action cannot be undone.';

  @override
  String get promptDetailDeleteConfirmButton => 'Delete';

  @override
  String get promptDetailDeleteCancelButton => 'Cancel';

  @override
  String get promptDetailDeletedMessage => 'Prompt deleted';

  @override
  String get promptDetailDeleteErrorMessage => 'Failed to delete prompt';

  @override
  String get promptEditNextButton => 'Next';

  @override
  String promptEntryGreeting(String firstName) {
    return 'Hi$firstName 👋';
  }

  @override
  String promptEntryFirstTimeDescription(int count) {
    return 'The next $count prompts are practice examples to help you learn how to answer them.';
  }

  @override
  String promptEntryDailyDescription(int count) {
    return 'Your daily $count prompts are waiting for you';
  }

  @override
  String get promptEntryButton => 'Show me';

  @override
  String get promptFinishTitle => 'Prompt submitted!';

  @override
  String get promptFinishDescription =>
      'Your prompt has been successfully submitted and is being reviewed. We\'ll notify you once it\'s live.';

  @override
  String get promptFinishReviewInfo =>
      'Reviews typically take less than 24 hours';

  @override
  String get promptFinishDoneButton => 'Done';

  @override
  String get promptPreviewTitle => 'Preview';

  @override
  String get promptPreviewNextButton => 'Next';

  @override
  String get promptPreviewSubmitButton => 'Submit';

  @override
  String get promptPreviewErrorUpdate => 'Failed to update prompt';

  @override
  String get promptPreviewErrorSubmit => 'Failed to submit prompt';

  @override
  String get promptSelectVenueTitle => 'Select audience';

  @override
  String get promptSelectVenueSubtitle => 'Where would you like to publish?';

  @override
  String get promptSelectVenuePublicTitle => 'Publish publicly';

  @override
  String get promptSelectVenuePublicDescription => 'Visible to all users';

  @override
  String get promptSelectVenueOrTitle => 'Or select a specific venue';

  @override
  String get promptSelectVenueNextButton => 'Next';

  @override
  String get promptSelectVenueSubmitButton => 'Submit';

  @override
  String get promptSelectVenueErrorSubmit => 'Failed to submit prompt';

  @override
  String get promptSettingsTitle => 'Settings';

  @override
  String get promptSettingsSubmitButton => 'Submit';

  @override
  String get promptSettingsErrorSubmit => 'Failed to submit prompt';

  @override
  String get promptsViewTitle => 'Pprompts';

  @override
  String get promptsViewEmptyActionButton => 'New prompt';

  @override
  String get promptsViewAnswerPromptsButton => 'Unanswered prompts';

  @override
  String get promptsViewAllAnsweredMessage => 'All prompts answered for today';

  @override
  String get promptsViewMyPromptsTitle => 'My prompts';

  @override
  String get venueCodeFieldPlaceholder => 'Invite code';

  @override
  String get venueDetailTitle => 'Venue details';

  @override
  String get venueDetailErrorLoading => 'Failed to load venue details';

  @override
  String get venueDetailRetryButton => 'Retry';

  @override
  String get venueDetailNotFound => 'Venue not found';

  @override
  String get venueDetailMemberSingular => 'Member';

  @override
  String get venueDetailMembersPlural => 'Members';

  @override
  String get venueDetailCardSingular => 'Prompt';

  @override
  String get venueDetailCardsPlural => 'Prompts';

  @override
  String get venueDetailMatchSingular => 'Match';

  @override
  String get venueDetailMatchesPlural => 'Matches';

  @override
  String get venueDetailIntroductionSingular => 'Introduction';

  @override
  String get venueDetailIntroductionsPlural => 'Introductions';

  @override
  String get venueDetailMatchesAndIntrosTitle => 'Matches';

  @override
  String get venueDetailEmptyMatchesTitle => 'No matches yet';

  @override
  String get venueDetailEmptyMatchesDescription =>
      'When members match through this venue, their profiles will appear here.';

  @override
  String get venueDetailOpenForMatchmaking => 'Open for matchmaking';

  @override
  String venueDetailOpenFrom(String startDate) {
    return 'Open for matchmaking from $startDate';
  }

  @override
  String venueDetailOpenUntil(String endDate) {
    return 'Open for matchmaking until $endDate';
  }

  @override
  String venueDetailOpenFromUntil(String startDate, String endDate) {
    return 'Open for matchmaking from $startDate until $endDate';
  }

  @override
  String venueProfilesViewTitle(String venueName) {
    return '$venueName Members';
  }

  @override
  String get venueProfilesViewEmptyTitle => 'No members found';

  @override
  String get venueProfilesViewEmptyDescription =>
      'This venue doesn\'t have any members yet.';

  @override
  String venuePromptsViewTitle(String venueName) {
    return '$venueName prompts';
  }

  @override
  String get venuePromptsViewEmptyTitle => 'No prompts found';

  @override
  String get venuePromptsViewEmptyDescription =>
      'This venue doesn\'t have any prompts yet.';

  @override
  String get communityGuidelinesTitle => 'Guidelines';

  @override
  String get communityGuidelinesAllowed =>
      'networking, sharing knowledge or resources, asking for help, reach out for genuine connections';

  @override
  String get communityGuidelinesProhibited =>
      'political posts, scams, spam, misleading, offensive or explicit content, advertising or sales pitches';

  @override
  String get errorStateDefaultTitle => 'Something went wrong';

  @override
  String get errorStateRetryButton => 'Retry';

  @override
  String get firstCallSettingsTitle => 'First Call';

  @override
  String get firstCallSettingsDescription =>
      'You see matches first, others only find out when you show interest. Screen potential introductions discreetly before revealing the match.';

  @override
  String get firstCallSettingsEnableLabel => 'Enable';

  @override
  String get firstCallSettingsUpgradeSubtitle =>
      'Unlock First Call and see the matches first.';

  @override
  String get firstCallSettingsUpgradeButton => 'Upgrade to Pro';

  @override
  String get firstCallSettingsVenueInfo =>
      'Available when publishing to a venue';

  @override
  String get promptInteractionPauseButton => 'Pause';

  @override
  String get promptInteractionResumeButton => 'Resume';

  @override
  String get paywallTitle => 'Join Venyu Pro';

  @override
  String get paywallSubtitle => 'Make the net work. Better 💪';

  @override
  String get paywallButtonNotNow => 'Not now';

  @override
  String get paywallButtonSubscribe => 'Subscribe';

  @override
  String get paywallButtonContinue => 'Continue';

  @override
  String get paywallButtonSubscribeContinue => 'Subscribe & Continue';

  @override
  String get paywallButtonContinueToVenyu => 'Continue to Venyu';

  @override
  String get paywallButtonRestorePurchases => 'Restore Purchases';

  @override
  String paywallDailyCost(String currency, String price) {
    return '$currency$price per day';
  }

  @override
  String paywallDiscountBadge(int percentage) {
    return '$percentage% OFF';
  }

  @override
  String get paywallErrorLoadOptions => 'Failed to load subscription options';

  @override
  String get paywallSuccessActivated => 'Subscription activated successfully!';

  @override
  String get paywallErrorPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get paywallSuccessRestored => 'Purchases restored successfully!';

  @override
  String get paywallInfoNoSubscriptions => 'No active subscriptions found';

  @override
  String get paywallErrorRestoreFailed => 'Failed to restore purchases';

  @override
  String get matchesViewTitle => 'Matches';

  @override
  String get matchesViewEmptyActionButton => 'New prompt';

  @override
  String get profileViewTitle => 'Profile';

  @override
  String get profileViewFabJoinVenue => 'Join a venue';

  @override
  String get profileHeaderBioPlaceholder => 'Write something about yourself...';

  @override
  String get getMatchedButtonLabel => 'Get matched';

  @override
  String get reviewPendingPromptsErrorUpdate => 'Failed to update prompts';

  @override
  String get reviewPendingPromptsErrorUpdateAll =>
      'Failed to update all prompts';

  @override
  String reviewPendingPromptsRejectSelected(int count) {
    return 'Reject $count';
  }

  @override
  String reviewPendingPromptsApproveSelected(int count) {
    return 'Approve $count';
  }

  @override
  String get reviewPendingPromptsRejectAll => 'Reject all';

  @override
  String get reviewPendingPromptsApproveAll => 'Approve all';

  @override
  String get matchSectionNoSharedConnections => 'No shared connections';

  @override
  String get matchSectionNoSharedTags => 'No shared tags';

  @override
  String get matchSectionNoSharedVenues => 'No shared venues';

  @override
  String get matchSectionUnknownTagGroup => 'Unknown';

  @override
  String get matchActionsSkipDialogTitle => 'Skip this match?';

  @override
  String get matchActionsSkipDialogMessage =>
      'This match will be removed from your matches. The other person will not receive any notification and won\'t know you skipped them.';

  @override
  String get matchActionsSkipError => 'Failed to skip match';

  @override
  String get matchActionsConnectError => 'Failed to connect';

  @override
  String get matchFinishTitle => 'Great!';

  @override
  String get matchFinishDescription => 'Your request has been submitted.';

  @override
  String matchFinishInfoMessage(String firstName) {
    return 'Now it’s waiting for $firstName. If $firstName also requests an introduction, you’ll both receive an email to get in touch.';
  }

  @override
  String get matchFinishDoneButton => 'Done';

  @override
  String get registrationCompleteError =>
      'Failed to complete registration. Please try again.';

  @override
  String get registrationCompleteTutorialPrompt1 =>
      'Looking to connect with entrepreneurs growing beyond Belgium.';

  @override
  String get registrationCompleteTutorialPrompt2 =>
      'Looking for someone who\'s raised investment before.';

  @override
  String get registrationCompleteTutorialPrompt3 =>
      'A friend is launching a coworking space. I\'d like to introduce her to others who\'ve done it.';

  @override
  String get registrationCompleteTutorialPrompt4 =>
      'Looking for an expert in animal nutrition for a new pet food concept.';

  @override
  String get avatarUploadError => 'Failed to upload photo. Please try again.';

  @override
  String get avatarRemoveError => 'Failed to remove photo. Please try again.';

  @override
  String get versionCheckUpdateAvailable =>
      'A new version of Venyu is available. Update now for the latest features!';

  @override
  String get baseListViewLoading => 'Loading...';

  @override
  String get baseListViewErrorTitle => 'Failed to load data';

  @override
  String get baseFormViewErrorUpdate => 'Failed to update, please try again';

  @override
  String get errorPrefix => 'Error:';

  @override
  String reviewPendingPromptsAppBarTitle(String type) {
    return 'Pending $type';
  }

  @override
  String get inviteCodeErrorInvalidOrExpired =>
      'This code is invalid or has expired. Please check your code and try again.';

  @override
  String get inviteCodeErrorRequired => 'Please enter an invite code.';

  @override
  String get inviteCodeErrorLength =>
      'The code must be exactly 8 characters long.';

  @override
  String get venueErrorNotMember =>
      'You are not a member of this venue or it does not exist.';

  @override
  String get venueErrorCodeInvalidOrExpired =>
      'This code is invalid or has expired. Please request a new code.';

  @override
  String get venueErrorAlreadyMember =>
      'You are already a member of this venue.';

  @override
  String get venueErrorCodeRequired => 'Please enter a venue code.';

  @override
  String get venueErrorCodeLength =>
      'The code must be exactly 8 characters long.';

  @override
  String get venueErrorAdminRequired =>
      'You need admin privileges to view venue members.';

  @override
  String get venueErrorIdRequired => 'Venue ID is required.';

  @override
  String get venueErrorAdminRequiredPrompts =>
      'You need admin privileges to view venue prompts.';

  @override
  String get venueErrorPermissionDenied =>
      'You don\'t have permission to view matches for this venue.';

  @override
  String get optionButtonCompleteProfile => 'Complete profile';
}
