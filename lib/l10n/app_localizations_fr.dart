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
}
