// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get onboardTitle => 'Welkom bij Venyu';

  @override
  String get onboardDescription =>
      'Je maakt nu deel uit van een community gebouwd op echte introducties!\n\nLaten we beginnen met een korte rondleiding voordat we je profiel instellen.';

  @override
  String get onboardStartTutorial =>
      'Voordat we je profiel aanmaken, laten we je tonen hoe Venyu werkt met een korte tutorial.';

  @override
  String get onboardButtonStart => 'Start';

  @override
  String get tutorialStep1Title => 'Prompts';

  @override
  String get tutorialStep1Description =>
      'Elke dag kan je 3 prompts beantwoorden. Het duurt nog geen minuut en helpt ons om de juiste matches te vinden.';

  @override
  String get tutorialStep2Title => 'Matches';

  @override
  String get tutorialStep2Description =>
      'Zodra we de juiste match hebben gevonden, laten we het je weten zodat jij kunt kiezen of je een introductie wil.';

  @override
  String get tutorialStep3Title => 'Introducties';

  @override
  String get tutorialStep3Description =>
      'Is de interesse wederzijds, dan maken we de introductie via e-mail en kan je rechtstreeks kennismaken.';

  @override
  String get tutorialStep4Title => 'Je bent er klaar voor!';

  @override
  String get tutorialStep4Description =>
      'Laten we je profiel aanvullen en beginnen met het vinden van de juiste matches.';

  @override
  String get tutorialButtonPrevious => 'Vorige';

  @override
  String get tutorialButtonNext => 'Volgende';

  @override
  String get registrationCompleteTitle => 'Je profiel is klaar! 🎉';

  @override
  String get registrationCompleteDescription =>
      'Bedankt voor het opstellen van je profiel. Laten we nu kijken hoe het beantwoorden van 3 prompts per dag ons helpt om de juiste match te vinden voor jou.';

  @override
  String get registrationCompleteButton => 'Doorgaan';

  @override
  String get promptEntryTitleFirstTime => 'Laten we het uitproberen!';

  @override
  String get promptEntryDescriptionFirstTime =>
      'Hier zijn 3 voorbeeldprompts om je te helpen begrijpen hoe het werkt. Dit is nog niet voor echt!';

  @override
  String get promptEntryButtonFirstTime => 'Start tutorial';

  @override
  String dailyPromptsHintSelect(String buttonTitle) {
    return 'Selecteer \"$buttonTitle\"';
  }

  @override
  String get dailyPromptsHintConfirm => 'Selecteer \"Volgende\"';

  @override
  String get dailyPromptsButtonNext => 'Volgende';

  @override
  String get dailyPromptsReportSuccess => 'Prompt succesvol gerapporteerd';

  @override
  String get dailyPromptsReportError => 'Rapporteren mislukt';

  @override
  String get dailyPromptsNoPromptsAvailable => 'Geen prompts beschikbaar';

  @override
  String get dailyPromptsExampleTag => 'Voorbeeld prompt';

  @override
  String get dailyPromptsReferralCodeSent =>
      'Check je mail voor een uitnodigingscode om te delen met de persoon die je kent';

  @override
  String get tutorialFinishedTitle => 'Je bent helemaal klaar! 🎉';

  @override
  String get tutorialFinishedDescription =>
      'Je hebt de korte rondleiding afgerond. Nu ben je klaar om je eerste 3 echte prompts te beantwoorden en gematcht te worden met andere ondernemers.';

  @override
  String get tutorialFinishedButton => 'Oké!';

  @override
  String get registrationFinishTitle => 'That\'s it! 🎉';

  @override
  String get registrationFinishDescription =>
      'Je account is helemaal ingesteld en je hebt je eerste 3 prompts beantwoord. Kom morgen terug om meer prompts te beantwoorden en nieuwe matches te ontdekken.';

  @override
  String get registrationFinishButton => 'Klaar!';

  @override
  String get buttonContinue => 'Doorgaan';

  @override
  String get buttonNext => 'Volgende';

  @override
  String get buttonPrevious => 'Vorige';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonGotIt => 'Begrepen';

  @override
  String get errorNoCardsAvailable =>
      'Momenteel geen prompts beschikbaar. Kom later terug!';

  @override
  String get errorFailedToLoadCards =>
      'Prompts laden mislukt. Probeer het opnieuw.';

  @override
  String get errorFailedToRefreshProfile =>
      'Profiel vernieuwen mislukt. Probeer het opnieuw.';

  @override
  String get errorNoInternetConnection =>
      'Geen internetverbinding. Controleer je verbinding en probeer opnieuw.';

  @override
  String get errorAuthenticationFailed =>
      'Aanmelden mislukt. Probeer het opnieuw.';

  @override
  String get interactionTypeThisIsMeButton => 'Dit ben ik';

  @override
  String get interactionTypeLookingForThisButton => 'Die zoek ik';

  @override
  String get interactionTypeKnowSomeoneButton => 'Die ken ik';

  @override
  String get interactionTypeNotRelevantButton => 'Niet voor mij';

  @override
  String get interactionTypeThisIsMeButtonToo => 'Dit ben ik ook';

  @override
  String get interactionTypeLookingForThisButtonToo => 'Die zoek ik ook';

  @override
  String get interactionTypeKnowSomeoneButtonToo => 'Die ken ik ook';

  @override
  String get interactionTypeNotRelevantButtonToo => 'Niet voor mij';

  @override
  String get interactionTypeLookingForThisSelection => 'Ik zoek iemand';

  @override
  String get interactionTypeLookingForThisHint =>
      'met ervaring in ...\ndie kan helpen met ...\nmet toegang tot ...\ndie mee kan sparren over ...\ndie een introductie kan maken naar ...\ndie advies kan geven over ...\nmet expertise in ...\n...';

  @override
  String get interactionTypeThisIsMeHint =>
      'die kan helpen met ...\nmet ervaring in ...\ndie kan introduceren bij ...\ndie kan meedenken over ...\ndie advies kan geven over ...\nmet expertise in ...\ndie connecties heeft in ...\n...';

  @override
  String get interactionTypeThisIsMeSelection => 'Ik ben iemand';

  @override
  String get interactionTypeLookingForThisSubtitle =>
      'die advies, ervaring of netwerk kan bieden';

  @override
  String get interactionTypeThisIsMeSubtitle =>
      'die kan helpen met advies, ervaring of netwerk';

  @override
  String get interactionTypeKnowSomeoneSelection => 'Ik kan verbinden';

  @override
  String get interactionTypeKnowSomeoneSubtitle =>
      'Stel mensen voor die kunnen helpen';

  @override
  String get interactionTypeKnowSomeoneHint => 'Wie kun je aanraden?';

  @override
  String get interactionTypeNotRelevantSelection => 'Overslaan';

  @override
  String get interactionTypeNotRelevantSubtitle => 'Deze sla ik over';

  @override
  String get interactionTypeNotRelevantHint => 'Wat wil je delen?';

  @override
  String get registrationStepNameTitle => 'Persoonlijke informatie';

  @override
  String get registrationStepEmailTitle => 'E-mailverificatie';

  @override
  String get registrationStepLocationTitle => 'Locatie delen';

  @override
  String get registrationStepCityTitle => 'Stad';

  @override
  String get registrationStepCompanyTitle => 'Bedrijfsinformatie';

  @override
  String get registrationStepRolesTitle => 'Je rollen';

  @override
  String get registrationStepSectorsTitle => 'Je sectoren';

  @override
  String get registrationStepMeetingPreferencesTitle => 'Ontmoetingsvoorkeuren';

  @override
  String get registrationStepNetworkingGoalsTitle => 'Netwerkdoelen';

  @override
  String get registrationStepAvatarTitle => 'Profielfoto';

  @override
  String get registrationStepNotificationsTitle => 'Activeer meldingen';

  @override
  String get registrationStepCompleteTitle => 'Welkom bij Venyu!';

  @override
  String get benefitNearbyMatchesTitle => 'Ontmoet ondernemers in de buurt';

  @override
  String get benefitNearbyMatchesDescription => 'Ontdek mensen dicht bij jou';

  @override
  String get benefitDistanceAwarenessTitle => 'Zie wie binnen bereik is';

  @override
  String get benefitDistanceAwarenessDescription =>
      'Weet de afstand tot matches';

  @override
  String get benefitBetterMatchingTitle => 'Groei je netwerk lokaal';

  @override
  String get benefitBetterMatchingDescription =>
      'Krijg betere resultaten met lokale focus';

  @override
  String get benefitMatchNotificationsTitle => 'Nieuwe match meldingen';

  @override
  String get benefitMatchNotificationsDescription =>
      'Word gewaarschuwd zodra een nieuwe match verschijnt';

  @override
  String get benefitConnectionNotificationsTitle => 'Mis geen introductie';

  @override
  String get benefitConnectionNotificationsDescription =>
      'Weet meteen wanneer je een nieuwe introductie ontvangt';

  @override
  String get benefitDailyRemindersTitle => 'Blijf actief';

  @override
  String get benefitDailyRemindersDescription =>
      'Word elke dag herinnerd je netwerk uit te breiden';

  @override
  String get benefitFocusedReachTitle => 'Slimme targeting';

  @override
  String get benefitFocusedReachDescription =>
      'Publiceer je vragen naar het juiste publiek';

  @override
  String get benefitDiscreetPreviewTitle => 'First call';

  @override
  String get benefitDiscreetPreviewDescription =>
      'Op je prompts krijg jij de first call. Matches worden pas aan anderen getoond als jij interesse toont.';

  @override
  String get benefitUnlimitedIntroductionsTitle => 'Oneindige introductions';

  @override
  String get benefitUnlimitedIntroductionsDescription =>
      'Blijf je netwerk uitbreiden met onbeperkte introducties en mis nooit een kans';

  @override
  String get benefitUnlockFullProfilesTitle => 'Volledige profielen';

  @override
  String get benefitUnlockFullProfilesDescription =>
      'Ontdek wie achter de match zit door hun avatar te zien en wederzijdse interesses te bekijken';

  @override
  String get benefitViewsAndImpressionsTitle => 'Weergaven en vertoningen';

  @override
  String get benefitViewsAndImpressionsDescription =>
      'Begrijp je bereik met eenvoudige statistieken';

  @override
  String get benefitDailyCardsBoostTitle => 'Meer dagelijkse prompts';

  @override
  String get benefitDailyCardsBoostDescription =>
      'Meer prompts om je netwerk sneller te laten groeien.';

  @override
  String get benefitAiPoweredMatchesTitle => 'AI-gedreven matches (later)';

  @override
  String get benefitAiPoweredMatchesDescription =>
      'Ontvang slimme suggesties op basis van je profiel.';

  @override
  String get editCompanyInfoNameTitle => 'Naam & website';

  @override
  String get editCompanyInfoNameDescription => 'De naam van je bedrijf';

  @override
  String get editPersonalInfoNameTitle => 'Naam';

  @override
  String get editPersonalInfoNameDescription => 'Je naam en LinkedIn URL';

  @override
  String get editPersonalInfoBioTitle => 'Bio';

  @override
  String get editPersonalInfoBioDescription =>
      'Een korte introductie over jezelf';

  @override
  String get editPersonalInfoLocationTitle => 'Stad';

  @override
  String get editPersonalInfoLocationDescription => 'De stad waarin je woont';

  @override
  String get editPersonalInfoEmailTitle => 'E-mail';

  @override
  String get editPersonalInfoEmailDescription => 'Je contact e-mailadres';

  @override
  String get profileEditAccountTitle => 'Account';

  @override
  String get profileEditAccountDescription => 'Beheer je account';

  @override
  String get reviewTypeUserTitle => 'Door gebruiker aangemaakt';

  @override
  String get reviewTypeUserDescription => 'Prompts ingediend door gebruikers';

  @override
  String get reviewTypeSystemTitle => 'AI gegenereerd';

  @override
  String get reviewTypeSystemDescription =>
      'Dagelijks gegenereerde prompts door AI';

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
  String get navProfile => 'Profiel';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionEdit => 'Bewerken';

  @override
  String get actionNext => 'Volgende';

  @override
  String get actionSkip => 'Niet nu';

  @override
  String get buttonSkip => 'Overslaan';

  @override
  String get actionConfirm => 'Bevestigen';

  @override
  String get actionInterested => 'Stel me voor';

  @override
  String get successSaved => 'Succesvol opgeslagen';

  @override
  String get dialogRemoveAvatarTitle => 'Avatar verwijderen';

  @override
  String get dialogRemoveAvatarMessage =>
      'Weet je zeker dat je je avatar wilt verwijderen?';

  @override
  String get dialogRemoveButton => 'Verwijderen';

  @override
  String get dialogOkButton => 'OK';

  @override
  String get dialogErrorTitle => 'Fout';

  @override
  String get dialogLoadingMessage => 'Laden...';

  @override
  String get validationEmailRequired => 'E-mail is verplicht';

  @override
  String get validationEmailInvalid => 'Voer een geldig e-mailadres in';

  @override
  String get validationUrlInvalid =>
      'Voer een geldige URL in (beginnend met http:// of https://)';

  @override
  String get validationLinkedInUrlInvalid =>
      'Voer een geldige LinkedIn profiel URL in\n(bijv. https://www.linkedin.com/in/jouwnaam)';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName is verplicht';
  }

  @override
  String get validationFieldRequiredDefault => 'Dit veld is verplicht';

  @override
  String validationMinLength(String fieldName, int minLength) {
    return '$fieldName moet minimaal $minLength karakters lang zijn';
  }

  @override
  String validationMaxLength(String fieldName, int maxLength) {
    return '$fieldName mag maximaal $maxLength karakters bevatten';
  }

  @override
  String get validationOtpRequired => 'Verificatiecode is verplicht';

  @override
  String get validationOtpLength => 'Verificatiecode moet 6 cijfers zijn';

  @override
  String get validationOtpNumeric =>
      'Verificatiecode mag alleen nummers bevatten';

  @override
  String get imageSourceCameraTitle => 'Camera';

  @override
  String get imageSourceCameraDescription => 'Neem een nieuwe foto';

  @override
  String get imageSourcePhotoLibraryTitle => 'Fotobibliotheek';

  @override
  String get imageSourcePhotoLibraryDescription => 'Kies uit bibliotheek';

  @override
  String get pagesProfileEditTitle => 'Profiel bewerken';

  @override
  String get pagesProfileEditDescription => 'Bewerk profielinformatie';

  @override
  String get pagesLocationTitle => 'Locatie';

  @override
  String get pagesLocationDescription => 'Locatie-instellingen';

  @override
  String get promptSectionCardTitle => 'Status';

  @override
  String get promptSectionCardDescription => 'Bekijk je prompt details';

  @override
  String get promptSectionStatsTitle => 'Statistieken';

  @override
  String get promptSectionStatsDescription => 'Prestaties en analyses';

  @override
  String get promptSectionIntroTitle => 'Introductions';

  @override
  String get promptSectionIntroDescription => 'Matches en introducties';

  @override
  String get promptStatusDraftDisplay => 'Concept';

  @override
  String get promptStatusDraftInfo =>
      'Je prompt is opgeslagen als concept. Maak het af en dien het in om matches te ontvangen.';

  @override
  String get promptStatusPendingReviewDisplay =>
      'In afwachting van beoordeling';

  @override
  String get promptStatusPendingReviewInfo =>
      'Je prompt wordt beoordeeld door ons team. Dit duurt meestal 12-24 uur om te controleren of de inhoud voldoet aan de community richtlijnen.';

  @override
  String get promptStatusPendingTranslationDisplay => 'Wordt vertaald';

  @override
  String get promptStatusPendingTranslationInfo =>
      'Je prompt wordt vertaald naar andere talen.';

  @override
  String get promptStatusApprovedDisplay => 'Goedgekeurd';

  @override
  String get promptStatusApprovedInfo =>
      'Je prompt is goedgekeurd en staat live. Je kunt matches ontvangen.';

  @override
  String get promptStatusRejectedDisplay => 'Afgewezen';

  @override
  String get promptStatusRejectedInfo =>
      'Je prompt werd afgewezen omdat het niet voldoet aan de community richtlijnen. Pas het aan en dien het opnieuw in.';

  @override
  String get promptStatusArchivedDisplay => 'Gearchiveerd';

  @override
  String get promptStatusArchivedInfo =>
      'Je prompt is gearchiveerd en niet meer zichtbaar voor andere gebruikers.';

  @override
  String get venueTypeEventDisplayName => 'Evenement';

  @override
  String get venueTypeEventDescription =>
      'Tijdelijke venue voor evenementen, conferenties of meetups';

  @override
  String get venueTypeOrganisationDisplayName => 'Gemeenschap';

  @override
  String get venueTypeOrganisationDescription =>
      'Permanente venue voor bedrijven of organisaties';

  @override
  String get emptyStateNotificationsTitle => 'Helemaal up-to-date';

  @override
  String get emptyStateNotificationsDescription =>
      'Als er iets gebeurt waar je van moet weten, laten we het je hier weten';

  @override
  String get emptyStateReviewsTitle => 'Helemaal up-to-date';

  @override
  String get emptyStateReviewsDescription =>
      'Wanneer prompts ter beoordeling worden ingediend, verschijnen ze hier';

  @override
  String get emptyStateMatchesTitle => 'Wachten op je eerste match!';

  @override
  String get emptyStateMatchesDescription =>
      'Zodra je een match hebt, verschijnt deze hier. Schrijf een nieuwe prompt om sneller gematcht te worden.';

  @override
  String get emptyStatePromptsTitle => 'Klaar om gematcht te worden?';

  @override
  String get emptyStatePromptsDescription =>
      'Prompts helpen ons de juiste matches te vinden die leiden tot echte introducties. Schrijf er zelf één om te beginnen.';

  @override
  String get authGoogleRetryingMessage => 'Even geduld...';

  @override
  String get redeemInviteTitle => 'Voer je uitnodigingscode in';

  @override
  String get redeemInviteSubtitle =>
      'Voer de 8-karakters uitnodigingscode in die je hebt ontvangen om door te gaan.';

  @override
  String get redeemInviteContinue => 'Doorgaan';

  @override
  String get redeemInvitePlaceholder => 'Voer uitnodigingscode in';

  @override
  String get waitlistFinishTitle => 'Je staat op de lijst!';

  @override
  String get waitlistFinishDescription =>
      'Bedankt voor je aanmelding op de Venyu wachtlijst. We laten je weten zodra er nieuwe plaatsen beschikbaar zijn.';

  @override
  String get waitlistFinishButton => 'Klaar';

  @override
  String get waitlistTitle => 'Meld je aan voor de wachtlijst';

  @override
  String get waitlistDescription =>
      'Venyu is alleen op uitnodiging. Meld je aan voor de wachtlijst en ontvang een uitnodiging wanneer er nieuwe plaatsen beschikbaar zijn.';

  @override
  String get waitlistNameHint => 'Je volledige naam';

  @override
  String get waitlistCompanyHint => 'Je bedrijfsnaam';

  @override
  String get waitlistRoleHint => 'Je functie / titel';

  @override
  String get waitlistEmailHint => 'Je e-mailadres';

  @override
  String get waitlistButton => 'Aanmelden voor wachtlijst';

  @override
  String get waitlistErrorDuplicate =>
      'Dit e-mailadres staat al op de wachtlijst';

  @override
  String get waitlistErrorFailed =>
      'Aanmelden voor wachtlijst mislukt. Probeer het opnieuw.';

  @override
  String get waitlistSuccessMessage =>
      'Je bent toegevoegd aan de wachtlijst! We laten je weten wanneer we klaar zijn.';

  @override
  String get inviteScreeningTitle => 'Welkom bij venyu 🤝';

  @override
  String get inviteScreeningDescription =>
      'De invite-only community voor ondernemers waar de juiste matches leiden tot echte introducties.';

  @override
  String get inviteScreeningHasCode => 'Ik heb een uitnodigingscode';

  @override
  String get inviteScreeningNoCode => 'Ik heb geen uitnodigingscode';

  @override
  String onboardWelcome(String name) {
    return 'Welkom $name 👋';
  }

  @override
  String get onboardStart => 'Start';

  @override
  String get loginLegalText =>
      'Door in te loggen ga je akkoord met onze Servicevoorwaarden en Privacybeleid';

  @override
  String get joinVenueTitle => 'Venue toevoegen';

  @override
  String get joinVenueSubtitle =>
      'Voer de 8-karakters uitnodigingscode in om deel te nemen.';

  @override
  String get joinVenueButton => 'Deelnemen';

  @override
  String get joinVenuePlaceholder => 'Voer venue code in';

  @override
  String get matchDetailLoading => 'Laden...';

  @override
  String get matchDetailTitleIntroduction => 'Introductie';

  @override
  String get matchDetailTitleMatch => 'Match';

  @override
  String get matchDetailMenuReport => 'Rapporteren';

  @override
  String get matchDetailMenuRemove => 'Verwijderen';

  @override
  String get matchDetailMenuBlock => 'Blokkeren';

  @override
  String get matchDetailReportSuccess => 'Profiel succesvol gerapporteerd';

  @override
  String get matchDetailBlockTitle => 'Gebruiker blokkeren?';

  @override
  String get matchDetailBlockMessage =>
      'Deze gebruiker blokkeren verwijdert de match en voorkomt toekomstige matches. Deze actie kan niet ongedaan gemaakt worden.';

  @override
  String get matchDetailBlockButton => 'Blokkeren';

  @override
  String get matchDetailBlockSuccess => 'Gebruiker succesvol geblokkeerd';

  @override
  String get matchDetailRemoveTitle => 'Introductie verwijderen?';

  @override
  String matchDetailRemoveMessage(String type) {
    return 'Weet je zeker dat je deze $type wilt verwijderen? Deze actie kan niet ongedaan gemaakt worden.';
  }

  @override
  String get matchDetailRemoveButton => 'Verwijderen';

  @override
  String get matchDetailRemoveSuccessIntroduction =>
      'Introductie succesvol verwijderd';

  @override
  String get matchDetailRemoveSuccessMatch => 'Match succesvol verwijderd';

  @override
  String get matchDetailTypeIntroduction => 'introductie';

  @override
  String get matchDetailTypeMatch => 'match';

  @override
  String get matchDetailErrorLoad => 'Match details laden mislukt';

  @override
  String get matchDetailRetry => 'Opnieuw proberen';

  @override
  String get matchDetailNotFound => 'Match niet gevonden';

  @override
  String get matchDetailLimitTitle => 'Maandelijkse limiet bereikt';

  @override
  String get matchDetailLimitMessage =>
      'Je hebt je limiet van 3 introducties per maand bereikt. Upgrade naar Venyu Pro voor onbeperkte introducties.';

  @override
  String get matchDetailLimitButton => 'Upgrade naar Pro';

  @override
  String get matchDetailFirstCallTitle => 'First Call actief';

  @override
  String matchDetailMatchingCards(int count, String cards) {
    return '$count gedeelde $cards';
  }

  @override
  String get matchDetailCard => 'prompt';

  @override
  String get matchDetailCards => 'prompts';

  @override
  String matchDetailSharedIntros(int count, String intros) {
    return '$count gedeelde $intros';
  }

  @override
  String get matchDetailIntroduction => 'introductie';

  @override
  String get matchDetailIntroductions => 'introductions';

  @override
  String matchDetailSharedVenues(int count, String venues) {
    return '$count gedeelde $venues';
  }

  @override
  String get matchDetailVenue => 'venue';

  @override
  String get matchDetailVenues => 'venues';

  @override
  String matchDetailCompanyFacts(int count, String areas) {
    return 'Professioneel: $count $areas';
  }

  @override
  String matchDetailPersonalInterests(int count, String areas) {
    return 'Persoonlijk: $count $areas';
  }

  @override
  String get matchDetailArea => 'raakvlak';

  @override
  String get matchDetailAreas => 'raakvlakken';

  @override
  String matchDetailWhyMatch(String name) {
    return 'Waarom jij en $name matchen';
  }

  @override
  String get matchDetailScoreBreakdown => 'Matching score';

  @override
  String get matchDetailUnlockTitle => 'Ontgrendel wederzijdse interesses';

  @override
  String matchDetailUnlockMessage(String name) {
    return 'Zie wat je op persoonlijk niveau met $name deelt';
  }

  @override
  String get matchDetailUnlockButton => 'Nu upgraden';

  @override
  String matchDetailInterestedInfoMessage(String name) {
    return 'Wil je een introductie met $name?';
  }

  @override
  String get matchDetailEmailSubject => 'We zijn verbonden op Venyu!';

  @override
  String get matchOverviewYou => 'Jij';

  @override
  String get profileAvatarMenuCamera => 'Camera';

  @override
  String get profileAvatarMenuGallery => 'Galerij';

  @override
  String get profileAvatarMenuView => 'Bekijken';

  @override
  String get profileAvatarMenuRemove => 'Verwijderen';

  @override
  String profileAvatarErrorAction(String error) {
    return 'Avatar actie mislukt: $error';
  }

  @override
  String get profileAvatarErrorUpload =>
      'Foto uploaden mislukt. Probeer het opnieuw.';

  @override
  String get profileAvatarErrorRemove =>
      'Foto verwijderen mislukt. Probeer het opnieuw.';

  @override
  String get profileAvatarErrorTitle => 'Fout';

  @override
  String get profileAvatarErrorButton => 'OK';

  @override
  String get profileAvatarCameraPermissionDenied =>
      'Cameratoegang is uitgeschakeld. Schakel dit in via de instellingen van je apparaat om foto\'s te maken.';

  @override
  String get profileAvatarGalleryPermissionDenied =>
      'Toegang tot fotobibliotheek is uitgeschakeld. Schakel dit in via de instellingen van je apparaat om foto\'s te selecteren.';

  @override
  String get profileInfoAddCompanyInfo => 'Bedrijfsinfo toevoegen';

  @override
  String get venuesErrorLoading => 'Fout bij laden van venues';

  @override
  String get venuesRetry => 'Opnieuw proberen';

  @override
  String get venuesEmptyTitle => 'Je venues verschijnen hier';

  @override
  String get venuesEmptyDescription =>
      'Heb je een uitnodigingscode? Verzilver deze om deel te nemen aan die venue en echte introducties te krijgen in de community.';

  @override
  String get venuesEmptyAction => 'Venue toevoegen';

  @override
  String invitesAvailableDescription(int count, String codes) {
    return 'Je hebt $count uitnodigings$codes klaar om te delen. Elk van hen ontgrendelt Venyu voor een nieuwe ondernemer';
  }

  @override
  String get invitesCode => 'code';

  @override
  String get invitesCodes => 'codes';

  @override
  String get invitesAllSharedDescription =>
      'Al je uitnodigingscodes zijn gedeeld. Bedankt voor het helpen groeien van de Venyu community!';

  @override
  String get invitesGenerateMore => 'Meer codes genereren';

  @override
  String get invitesEmptyTitle => 'Nog geen uitnodigingscodes';

  @override
  String get invitesEmptyDescription =>
      'Je uitnodigingscodes verschijnen hier. Je kunt ze delen met vrienden om hen uit te nodigen voor Venyu.';

  @override
  String get invitesEmptyAction => 'Codes genereren';

  @override
  String get invitesSubtitleAvailable => 'Beschikbare codes';

  @override
  String get invitesSubtitleShared => 'Gedeelde codes';

  @override
  String get invitesSubtitleRedeemed => 'Verzilverde codes';

  @override
  String get invitesMenuShare => 'Delen';

  @override
  String get invitesMenuCopy => 'Kopiëren';

  @override
  String get invitesMenuMarkShared => 'Markeren als gedeeld';

  @override
  String get invitesShareSubject => 'Je persoonlijke Venyu uitnodiging';

  @override
  String invitesShareText(String code) {
    return 'Join me on Venyu!\n\nDe invite-only community voor ondernemers waar de juiste matches leiden tot echte introducties.\n\nDownload de app op 👉 www.getvenyu.com\n\n🔑 Jouw uitnodigingscode:\n\n$code';
  }

  @override
  String get invitesCopiedToast => 'Uitnodigingscode gekopieerd naar klembord';

  @override
  String get invitesMarkedSentToast =>
      'Uitnodigingscode gemarkeerd als verzonden';

  @override
  String get invitesMarkedSentError => 'Markeren als verzonden mislukt';

  @override
  String get invitesGenerateDialogTitle => 'Meer codes genereren';

  @override
  String get invitesGenerateDialogMessage =>
      '5 nieuwe uitnodigingscodes genereren? Deze verlopen over 1 jaar.';

  @override
  String get invitesGenerateDialogConfirm => 'Genereren';

  @override
  String get invitesGenerateDialogCancel => 'Annuleren';

  @override
  String get invitesGenerateSuccessToast =>
      '5 nieuwe uitnodigingscodes succesvol gegenereerd';

  @override
  String get invitesGenerateErrorToast =>
      'Genereren van uitnodigingscodes mislukt';

  @override
  String get companySectionEmptyTagGroups =>
      'Geen bedrijfs tag groepen beschikbaar';

  @override
  String get personalSectionEmptyTagGroups =>
      'Geen persoonlijke tag groepen beschikbaar';

  @override
  String get profileSectionPersonalTitle => 'Persoonlijk';

  @override
  String get profileSectionPersonalDescription => 'Persoonlijke informatie';

  @override
  String get profileSectionCompanyTitle => 'Professioneel';

  @override
  String get profileSectionCompanyDescription => 'Professionele informatie';

  @override
  String get profileSectionVenuesTitle => 'Venues';

  @override
  String get profileSectionVenuesDescription => 'Evenementen en organisaties';

  @override
  String get profileSectionInvitesTitle => 'Codes';

  @override
  String get profileSectionInvitesDescription => 'Uitnodigingen en codes';

  @override
  String get profileSectionReviewsTitle => 'Reviews';

  @override
  String get profileSectionReviewsDescription =>
      'Gebruikersbeoordelingen en feedback';

  @override
  String get editAccountTitle => 'Accountinstellingen';

  @override
  String get editAccountDataExportTitle => 'Data Export';

  @override
  String get editAccountDataExportDescription =>
      'Je kunt een kopie van al je persoonlijke gegevens aanvragen. Dit omvat je profielinformatie, prompts, matches en activiteitengeschiedenis. De export wordt naar je geregistreerde e-mailadres gestuurd.';

  @override
  String get editAccountExportDataButton => 'Exporteer al je gegevens';

  @override
  String get editAccountDeleteTitle => 'Account verwijderen';

  @override
  String get editAccountDeleteDescription =>
      'Het verwijderen van je account is definitief. Al je gegevens, inclusief je profiel, prompts en matches worden verwijderd.';

  @override
  String get editAccountDeleteButton => 'Account verwijderen';

  @override
  String get editAccountLogoutButton => 'Uitloggen';

  @override
  String get editAccountExportDialogTitle => 'Gegevens exporteren';

  @override
  String get editAccountExportDialogMessage =>
      'Je ontvangt een data export link in je e-mail zodra je gegevens klaar zijn.';

  @override
  String get editAccountExportDialogCancel => 'Annuleren';

  @override
  String get editAccountExportDialogConfirm => 'Exporteren';

  @override
  String get editAccountExportSuccessMessage =>
      'Een e-mail wordt verzonden zodra de export klaar is';

  @override
  String get editAccountExportErrorMessage =>
      'Er ging iets mis. Probeer het later opnieuw.';

  @override
  String get editAccountDeleteDialogTitle => 'Account verwijderen';

  @override
  String get editAccountDeleteDialogMessage =>
      'Je account en alle bijbehorende gegevens worden direct en permanent verwijderd. Deze actie kan niet ongedaan worden gemaakt. Weet je zeker dat je wilt doorgaan?';

  @override
  String get editAccountDeleteDialogCancel => 'Annuleren';

  @override
  String get editAccountDeleteDialogConfirm => 'Verwijderen';

  @override
  String get editAccountDeleteErrorMessage =>
      'Er ging iets mis. Probeer het later opnieuw.';

  @override
  String get editAccountLogoutDialogTitle => 'Uitloggen';

  @override
  String get editAccountLogoutDialogMessage =>
      'Weet je zeker dat je wilt uitloggen?';

  @override
  String get editAccountLogoutDialogCancel => 'Annuleren';

  @override
  String get editAccountLogoutDialogConfirm => 'Uitloggen';

  @override
  String get editAccountLogoutErrorMessage =>
      'Er ging iets mis. Probeer het later opnieuw.';

  @override
  String get editTagGroupSavingButton => 'Opslaan...';

  @override
  String get editTagGroupNextButton => 'Volgende';

  @override
  String get editTagGroupSaveButton => 'Opslaan';

  @override
  String get editTagGroupLoadErrorTitle => 'Laden van tags mislukt';

  @override
  String get editTagGroupRetryButton => 'Opnieuw proberen';

  @override
  String get editTagGroupNoTagsMessage => 'Geen tags beschikbaar';

  @override
  String get editTagGroupSaveErrorTitle => 'Fout';

  @override
  String editTagGroupSaveErrorMessage(String error) {
    return 'Wijzigingen opslaan mislukt: $error';
  }

  @override
  String get editTagGroupErrorDialogOk => 'OK';

  @override
  String get editNotificationsTitle => 'Notificaties';

  @override
  String get editNotificationsSavedMessage => 'Notificaties opgeslagen';

  @override
  String get editNotificationsSaveErrorMessage =>
      'Opslaan van notificaties mislukt';

  @override
  String get editNotificationsEnableTitle => 'Schakel notificaties in om ...';

  @override
  String get editNotificationsNotNowButton => 'Niet nu';

  @override
  String get editNotificationsEnableButton => 'Inschakelen';

  @override
  String get editNotificationsPermissionDialogTitle =>
      'Notificatietoestemming vereist';

  @override
  String get editNotificationsPermissionDialogMessage =>
      'Notificatietoestemming is geweigerd. Schakel dit in bij je apparaatinstellingen om updates te ontvangen.';

  @override
  String get editNotificationsPermissionDialogNotNow => 'Niet nu';

  @override
  String get editNotificationsPermissionDialogOpenSettings =>
      'Instellingen openen';

  @override
  String get editNotificationsLaterMessage =>
      'Je kunt notificaties later inschakelen in de instellingen';

  @override
  String get editNotificationsEnableErrorMessage =>
      'Inschakelen van notificaties mislukt. Je kunt het opnieuw proberen in de instellingen.';

  @override
  String get editLocationTitle => 'Locatie';

  @override
  String get editLocationSavedMessage => 'Locatie opgeslagen';

  @override
  String get editLocationSaveErrorMessage => 'Opslaan van locatie mislukt';

  @override
  String get editLocationEnableTitle => 'Schakel locatie in om';

  @override
  String get editLocationNotNowButton => 'Niet nu';

  @override
  String get editLocationEnableButton => 'Inschakelen';

  @override
  String get editLocationServicesDisabledMessage =>
      'Locatieservices zijn uitgeschakeld. Schakel ze in bij de instellingen.';

  @override
  String get editLocationPermissionDeniedMessage =>
      'Locatietoestemming geweigerd. Je kunt dit later inschakelen in de instellingen.';

  @override
  String get editLocationPermissionDialogTitle => 'Locatietoestemming vereist';

  @override
  String get editLocationPermissionDialogMessage =>
      'Locatietoestemming is permanent geweigerd. Schakel dit in bij je apparaatinstellingen om deze functie te gebruiken.';

  @override
  String get editLocationPermissionDialogNotNow => 'Niet nu';

  @override
  String get editLocationPermissionDialogOpenSettings => 'Instellingen openen';

  @override
  String get editLocationCoordinatesErrorMessage =>
      'Kan locatiecoördinaten niet ophalen';

  @override
  String get editLocationEnableErrorMessage =>
      'Inschakelen van locatie mislukt. Probeer het opnieuw.';

  @override
  String get editLocationUnavailableMessage =>
      'Kan je locatie niet ophalen. Je kan dit later toevoegen in de instellingen.';

  @override
  String get editLocationApproximateInfo =>
      'Gebruikt geschatte locatie. Schakel \'Precieze locatie\' in bij instellingen voor betere matches.';

  @override
  String get editNameTitle => 'Jij';

  @override
  String get editNameSuccessMessage => 'Wijzigingen succesvol opgeslagen';

  @override
  String get editNameErrorMessage => 'Bijwerken mislukt, probeer het opnieuw';

  @override
  String get editNameLinkedInFormatError => 'LinkedIn URL formaat is ongeldig';

  @override
  String get editNameLinkedInMismatchDialogTitle =>
      'We konden je naam niet vinden in je LinkedIn URL';

  @override
  String get editNameLinkedInMismatchDialogMessage =>
      'Je LinkedIn URL lijkt je voor- en achternaam niet te bevatten. Je kunt doorgaan of je URL nogmaals controleren.';

  @override
  String get editNameLinkedInMismatchDialogCheckUrl => 'URL controleren';

  @override
  String get editNameLinkedInMismatchDialogContinue => 'Toch doorgaan';

  @override
  String get editNameFirstNameLabel => 'VOORNAAM';

  @override
  String get editNameFirstNameHint => 'Voornaam';

  @override
  String get editNameLastNameLabel => 'ACHTERNAAM';

  @override
  String get editNameLastNameHint => 'Achternaam';

  @override
  String get editNameLinkedInLabel => 'LINKEDIN URL';

  @override
  String get editNameLinkedInHint => 'linkedin.com/in/jouw-naam';

  @override
  String get editNameLinkedInInfoMessage =>
      'We delen je LinkedIn profiel alleen in de introductie-e-mail zodra er wederzijdse interesse is. Het wordt nooit gedeeld wanneer je voor het eerst gematcht wordt.';

  @override
  String get editNameLinkedInMobileTip =>
      'In de LinkedIn mobiele app: Ga naar je profiel → tik op de drie puntjes (•••) → selecteer \'Profiel delen\' → tik op \'Link kopiëren\'';

  @override
  String get editEmailTitle => 'E-mailadres';

  @override
  String get editEmailSendCodeButton => 'Verificatiecode verzenden';

  @override
  String get editEmailAddressLabel => 'E-MAILADRES';

  @override
  String editEmailCodeSentMessage(String email) {
    return 'Een verificatiecode is verzonden naar $email. Controleer ook de spam.';
  }

  @override
  String get editEmailSuccessMessage => 'Contact e-mailadres bijgewerkt';

  @override
  String get editEmailSendCodeErrorMessage =>
      'Verzenden van bevestigingscode mislukt, probeer het opnieuw';

  @override
  String get editEmailVerifyCodeErrorMessage =>
      'Verifiëren van code mislukt, probeer het opnieuw';

  @override
  String get editEmailVerifyCodeButton => 'Code verifiëren';

  @override
  String get editEmailAddressHint => 'Een geldig e-mailadres';

  @override
  String get editEmailInfoMessage =>
      'We gebruiken dit e-mailadres alleen voor app notificaties zoals nieuwe matches, introducties en belangrijke updates';

  @override
  String get editEmailNewsletterLabel => 'INSCHRIJVEN VOOR VENYU UPDATES';

  @override
  String get editEmailVerificationCodeLabel => 'Verificatiecode';

  @override
  String get editEmailVerificationCodeHint => 'Voer 6-cijferige code in';

  @override
  String get editEmailOtpInfoMessage =>
      'Controleer ook je spam folder als je de verificatiecode niet ziet.';

  @override
  String get editCityTitle => 'Stad';

  @override
  String get editCitySavedMessage => 'Stad opgeslagen';

  @override
  String get editCityErrorMessage =>
      'Bijwerken van stad mislukt, probeer het opnieuw';

  @override
  String get editCityCityLabel => 'STAD';

  @override
  String get editCityCityHint => 'Stad';

  @override
  String get editCityInfoMessage =>
      'Je stad wordt alleen gedeeld met mensen aan wie je geïntroduceerd wordt, niet met matches. Dit helpt om betere persoonlijke ontmoetingen te faciliteren zodra een connectie is gemaakt.';

  @override
  String get editCompanyNameTitle => 'Bedrijfsnaam';

  @override
  String get editCompanyNameSuccessMessage =>
      'Bedrijfsinfo wijzigingen opgeslagen';

  @override
  String get editCompanyNameErrorMessage =>
      'Bijwerken van bedrijfsinfo mislukt, probeer het opnieuw';

  @override
  String get editCompanyNameCompanyLabel => 'BEDRIJFSNAAM';

  @override
  String get editCompanyNameCompanyHint => 'Bedrijfsnaam';

  @override
  String get editCompanyNameWebsiteLabel => 'WEBSITE';

  @override
  String get editCompanyNameWebsiteHint => 'Website';

  @override
  String get editCompanyNameInfoMessage =>
      'Je bedrijfsnaam en website worden alleen gedeeld met mensen aan wie je geïntroduceerd wordt, niet met matches. Ze helpen introducties zinvoller en relevanter te maken.';

  @override
  String get editAvatarTitle => 'Profielfoto';

  @override
  String get editAvatarSuccessMessage => 'Profielfoto opgeslagen';

  @override
  String get editAvatarErrorMessage => 'Opslaan van profielfoto mislukt';

  @override
  String get editAvatarRemoveButton => 'Verwijderen';

  @override
  String get editAvatarAddTitle => 'Voeg een profielfoto toe';

  @override
  String get editAvatarInfoMessage =>
      'Je foto is vaak je eerste indruk. Kies een duidelijke, vriendelijke headshot. Deze verschijnt wazig in matches, maar zichtbaar zodra je geïntroduceerd bent.';

  @override
  String get editAvatarCameraButton => 'Camera';

  @override
  String get editAvatarGalleryButton => 'Galerij';

  @override
  String get editAvatarNextButton => 'Volgende';

  @override
  String get editBioTitle => 'Over jou';

  @override
  String get editBioSuccessMessage => 'Profiel bio opgeslagen';

  @override
  String get editBioErrorMessage =>
      'Bijwerken van profiel bio mislukt, probeer het opnieuw';

  @override
  String get editBioInfoMessage =>
      'Je bio is zichtbaar voor iedereen waarmee je matcht. Houd in gedachten: als je niet wilt dat bepaalde persoonlijke details bekend zijn vóór een introductie (zoals je bedrijfsnaam, LinkedIn profiel, of andere identificerende informatie), laat die dan weg.\n\nGebruik deze ruimte om je ervaring, interesses en waar je voor openstaat te benadrukken, zonder gevoelige details te delen die je liever privé houdt tot na een introductie.';

  @override
  String get editBioPlaceholder => 'Schrijf hier je bio...';

  @override
  String get promptCardCreatedLabel => 'Aangemaakt';

  @override
  String get promptCardReviewedLabel => 'Beoordeeld';

  @override
  String get promptCardStatusLabel => 'Status';

  @override
  String get promptCardUpgradeTitle => 'Verleng je prompt zichtbaarheid';

  @override
  String get promptCardUpgradeSubtitle =>
      'Upgrade naar Venyu Pro om je prompt 10 dagen in plaats van 3 online te houden.';

  @override
  String get promptCardUpgradeButton => 'Upgraden naar Pro';

  @override
  String get promptIntroErrorMessage => 'Laden van matches mislukt';

  @override
  String get promptIntroRetryButton => 'Opnieuw proberen';

  @override
  String get promptIntroEmptyTitle => 'Nog geen matches';

  @override
  String get promptIntroEmptyDescription =>
      'Wanneer mensen matchen met je prompt, verschijnen hun profielen hier.';

  @override
  String get promptStatsTitle => 'Statistieken komen binnenkort';

  @override
  String get promptStatsDescription =>
      'Volg de prestaties, weergaven en engagement metrics van je prompt.';

  @override
  String interactionTypeSelectionTitleFromPrompts(String name) {
    return 'Bedankt$name';
  }

  @override
  String get interactionTypeSelectionTitleDefault => 'Make the net work';

  @override
  String get interactionTypeSelectionSubtitleFromPrompts =>
      'Make the net work for you';

  @override
  String get interactionTypeSelectionSubtitleDefault =>
      'Schrijf zelf een prompt';

  @override
  String get interactionTypeSelectionDisclaimerText =>
      'Prompts worden nagekeken voordat ze live gaan';

  @override
  String get interactionTypeSelectionDisclaimerBeforeLinkText =>
      'Prompts worden nagekeken volgens onze ';

  @override
  String get interactionTypeSelectionDisclaimerLinkText =>
      'community richtlijnen';

  @override
  String get interactionTypeSelectionShowGuidelines =>
      'Community richtlijnen tonen';

  @override
  String get interactionTypeSelectionHideGuidelines =>
      'Community richtlijnen verbergen';

  @override
  String get interactionTypeSelectionNotNowButton => 'Niet nu';

  @override
  String get promptDetailTitle => 'Prompt detail';

  @override
  String get promptDetailStatusTitle => 'Status';

  @override
  String get promptDetailHowYouMatchTitle => 'Matchen beheren';

  @override
  String get promptDetailHowYouMatchDescription =>
      'Pauzeer het matchen op deze prompt om tijdelijk te stoppen met nieuwe matches ontvangen. Je kan op elk moment hervatten.';

  @override
  String get promptDetailFirstCallTitle => 'First Call';

  @override
  String get promptDetailPublishedInTitle => 'Gepubliceerd in';

  @override
  String get promptDetailMatchesTitle => 'Matches';

  @override
  String get promptDetailErrorMessage => 'Laden van prompt mislukt';

  @override
  String get promptDetailErrorDataMessage => 'Laden van prompt mislukt';

  @override
  String get promptDetailRetryButton => 'Opnieuw proberen';

  @override
  String get promptDetailEmptyMatchesTitle => 'Nog geen matches';

  @override
  String get promptDetailEmptyMatchesDescription =>
      'Wanneer mensen matchen met je prompt, verschijnen hun profielen hier.';

  @override
  String get promptDetailEditButton => 'Prompt bewerken';

  @override
  String get promptDetailPreviewUpdatedMessage =>
      'Preview instelling bijgewerkt';

  @override
  String get promptDetailMatchSettingUpdatedMessage =>
      'Match instelling bijgewerkt';

  @override
  String get promptDetailPauseMatchingTitle => 'Matching pauzeren?';

  @override
  String promptDetailPauseMatchingMessage(String interactionType) {
    return 'Je ontvangt geen matches meer voor \"$interactionType\" op deze prompt. Je kunt matching altijd hervatten.';
  }

  @override
  String get promptDetailPauseMatchingConfirm => 'Pauzeren';

  @override
  String get promptDetailPauseMatchingCancel => 'Annuleren';

  @override
  String get promptDetailPauseMatchingMessageGeneric =>
      'Je ontvangt geen matches meer op deze prompt. Je kan matchen op elk moment hervatten.';

  @override
  String get promptDetailMatchingActiveLabel => 'Matchen is actief';

  @override
  String get promptDetailMatchingPausedLabel => 'Matchen is gepauzeerd';

  @override
  String get promptItemPausedTag => 'Gepauzeerd';

  @override
  String get promptDetailRejectButton => 'Afwijzen';

  @override
  String get promptDetailApproveButton => 'Goedkeuren';

  @override
  String get promptDetailApprovedMessage => 'Prompt goedgekeurd';

  @override
  String get promptDetailRejectedMessage => 'Prompt afgewezen';

  @override
  String get promptDetailDeleteButton => 'Prompt verwijderen';

  @override
  String get promptDetailDeleteConfirmTitle => 'Prompt verwijderen?';

  @override
  String get promptDetailDeleteConfirmMessage =>
      'Dit zal je prompt permanent verwijderen. Deze actie kan niet ongedaan gemaakt worden.';

  @override
  String get promptDetailDeleteConfirmButton => 'Verwijderen';

  @override
  String get promptDetailDeleteCancelButton => 'Annuleren';

  @override
  String get promptDetailDeletedMessage => 'Prompt verwijderd';

  @override
  String get promptDetailDeleteErrorMessage => 'Verwijderen mislukt';

  @override
  String get promptEditNextButton => 'Volgende';

  @override
  String promptEntryGreeting(String firstName) {
    return 'Hoi$firstName 👋';
  }

  @override
  String promptEntryFirstTimeDescription(int count) {
    return 'De volgende $count prompts zijn oefenvoorbeelden om je te leren hoe je ze beantwoordt.';
  }

  @override
  String promptEntryDailyDescription(int count) {
    return 'Je dagelijkse $count prompts wachten op je';
  }

  @override
  String get promptEntryButton => 'Laat zien';

  @override
  String get promptFinishTitle => 'Prompt ingediend!';

  @override
  String get promptFinishDescription =>
      'Je prompt is succesvol ingediend en wordt beoordeeld. We laten je weten wanneer deze live is.';

  @override
  String get promptFinishReviewInfo =>
      'Beoordelingen duren meestal minder dan 24 uur';

  @override
  String get promptFinishDoneButton => 'Klaar';

  @override
  String get promptPreviewTitle => 'Voorbeeld';

  @override
  String get promptPreviewNextButton => 'Volgende';

  @override
  String get promptPreviewSubmitButton => 'Indienen';

  @override
  String get promptPreviewErrorUpdate => 'Bijwerken van prompt mislukt';

  @override
  String get promptPreviewErrorSubmit => 'Indienen van prompt mislukt';

  @override
  String get promptSelectVenueTitle => 'Selecteer publiek';

  @override
  String get promptSelectVenueSubtitle => 'Waar wil je publiceren?';

  @override
  String get promptSelectVenuePublicTitle => 'Publiek publiceren';

  @override
  String get promptSelectVenuePublicDescription =>
      'Zichtbaar voor alle gebruikers';

  @override
  String get promptSelectVenueOrTitle => 'Of selecteer een specifieke venue';

  @override
  String get promptSelectVenueNextButton => 'Volgende';

  @override
  String get promptSelectVenueSubmitButton => 'Indienen';

  @override
  String get promptSelectVenueErrorSubmit => 'Indienen van prompt mislukt';

  @override
  String get promptSettingsTitle => 'Instellingen';

  @override
  String get promptSettingsSubmitButton => 'Indienen';

  @override
  String get promptSettingsErrorSubmit => 'Indienen van prompt mislukt';

  @override
  String get promptsViewTitle => 'Prompts';

  @override
  String get promptsViewEmptyActionButton => 'Nieuwe prompt';

  @override
  String get promptsViewAnswerPromptsButton => 'Onbeantwoorde prompts';

  @override
  String get promptsViewAllAnsweredMessage =>
      'Alle prompts beantwoord voor vandaag';

  @override
  String get promptsViewMyPromptsTitle => 'Mijn prompts';

  @override
  String get venueCodeFieldPlaceholder => 'Uitnodigingscode';

  @override
  String get venueDetailTitle => 'Venue details';

  @override
  String get venueDetailErrorLoading => 'Laden van venue details mislukt';

  @override
  String get venueDetailRetryButton => 'Opnieuw proberen';

  @override
  String get venueDetailNotFound => 'Venue niet gevonden';

  @override
  String get venueDetailMemberSingular => 'Lid';

  @override
  String get venueDetailMembersPlural => 'Leden';

  @override
  String get venueDetailCardSingular => 'Prompt';

  @override
  String get venueDetailCardsPlural => 'Prompts';

  @override
  String get venueDetailMatchSingular => 'Match';

  @override
  String get venueDetailMatchesPlural => 'Matches';

  @override
  String get venueDetailIntroductionSingular => 'Introductie';

  @override
  String get venueDetailIntroductionsPlural => 'Introducties';

  @override
  String get venueDetailMatchesAndIntrosTitle => 'Matches';

  @override
  String get venueDetailEmptyMatchesTitle => 'Nog geen matches';

  @override
  String get venueDetailEmptyMatchesDescription =>
      'Wanneer leden matchen via deze venue, verschijnen hun profielen hier.';

  @override
  String get venueDetailOpenForMatchmaking => 'Open voor matchmaking';

  @override
  String venueDetailOpenFrom(String startDate) {
    return 'Open voor matchmaking vanaf $startDate';
  }

  @override
  String venueDetailOpenUntil(String endDate) {
    return 'Open voor matchmaking tot $endDate';
  }

  @override
  String venueDetailOpenFromUntil(String startDate, String endDate) {
    return 'Open voor matchmaking vanaf $startDate tot $endDate';
  }

  @override
  String venueProfilesViewTitle(String venueName) {
    return '$venueName Leden';
  }

  @override
  String get venueProfilesViewEmptyTitle => 'Geen leden gevonden';

  @override
  String get venueProfilesViewEmptyDescription =>
      'Deze venue heeft nog geen leden.';

  @override
  String venuePromptsViewTitle(String venueName) {
    return '$venueName prompts';
  }

  @override
  String get venuePromptsViewEmptyTitle => 'Geen prompts gevonden';

  @override
  String get venuePromptsViewEmptyDescription =>
      'Deze venue heeft nog geen prompts.';

  @override
  String get communityGuidelinesTitle => 'Richtlijnen';

  @override
  String get communityGuidelinesAllowed =>
      'netwerken, kennis delen, hulp vragen, ervaringen en expertise delen, relevante introducties leggen, samenwerking verkennen, sparren over uitdagingen, co-founders of strategische partners zoeken, ondernemersvragen, aanbevelingen zoeken of geven';

  @override
  String get communityGuidelinesProhibited =>
      'politiek, misleiding, oplichting, spam, aanstootgevende of expliciete inhoud, toxisch of discriminerend gedrag, religieuze discussies, haatdragende uitspraken, vacatures of jobadvertenties, reclame of commerciële boodschappen';

  @override
  String get errorStateDefaultTitle => 'Er ging iets mis';

  @override
  String get errorStateRetryButton => 'Opnieuw proberen';

  @override
  String get firstCallSettingsTitle => 'First Call';

  @override
  String get firstCallSettingsDescription =>
      'Jij ziet matches eerst, anderen ontdekken het pas wanneer jij interesse toont. Screen potentiële introducties discreet voordat je de match onthult.';

  @override
  String get firstCallSettingsEnableLabel => 'Inschakelen';

  @override
  String get firstCallSettingsUpgradeSubtitle =>
      'Ontgrendel First Call en zie de matches als eerste.';

  @override
  String get firstCallSettingsUpgradeButton => 'Upgraden naar Pro';

  @override
  String get firstCallSettingsVenueInfo =>
      'Beschikbaar bij publiceren naar een venue';

  @override
  String get promptInteractionPauseButton => 'Pauzeren';

  @override
  String get promptInteractionResumeButton => 'Hervatten';

  @override
  String get paywallTitle => 'Word lid van Venyu Pro';

  @override
  String get paywallSubtitle => 'Laat het netwerk werken. Beter 💪';

  @override
  String get paywallButtonNotNow => 'Niet nu';

  @override
  String get paywallButtonSubscribe => 'Abonneren';

  @override
  String get paywallButtonContinue => 'Doorgaan';

  @override
  String get paywallButtonSubscribeContinue => 'Abonneren & Doorgaan';

  @override
  String get paywallButtonContinueToVenyu => 'Doorgaan naar Venyu';

  @override
  String get paywallButtonRestorePurchases => 'Aankopen herstellen';

  @override
  String paywallDailyCost(String currency, String price) {
    return '$currency$price per dag';
  }

  @override
  String paywallDiscountBadge(int percentage) {
    return '$percentage% KORTING';
  }

  @override
  String get paywallErrorLoadOptions => 'Laden van abonnementsopties mislukt';

  @override
  String get paywallSuccessActivated => 'Abonnement succesvol geactiveerd!';

  @override
  String get paywallErrorPurchaseFailed =>
      'Aankoop mislukt. Probeer het opnieuw.';

  @override
  String get paywallSuccessRestored => 'Aankopen succesvol hersteld!';

  @override
  String get paywallInfoNoSubscriptions => 'Geen actieve abonnementen gevonden';

  @override
  String get paywallErrorRestoreFailed => 'Herstellen van aankopen mislukt';

  @override
  String get matchesViewTitle => 'Matches';

  @override
  String get matchesViewEmptyActionButton => 'Nieuwe prompt';

  @override
  String get profileViewTitle => 'Profiel';

  @override
  String get profileViewFabJoinVenue => 'Venue toevoegen';

  @override
  String get profileHeaderBioPlaceholder => 'Schrijf iets over jezelf...';

  @override
  String get getMatchedButtonLabel => 'Word gematcht';

  @override
  String get reviewPendingPromptsErrorUpdate => 'Bijwerken van prompts mislukt';

  @override
  String get reviewPendingPromptsErrorUpdateAll =>
      'Bijwerken van alle prompts mislukt';

  @override
  String reviewPendingPromptsRejectSelected(int count) {
    return '$count afwijzen';
  }

  @override
  String reviewPendingPromptsApproveSelected(int count) {
    return '$count toestaan';
  }

  @override
  String get reviewPendingPromptsRejectAll => 'Alles afwijzen';

  @override
  String get reviewPendingPromptsApproveAll => 'Alles toestaan';

  @override
  String get matchSectionNoSharedConnections => 'Geen gedeelde connecties';

  @override
  String get matchSectionNoSharedTags => 'Geen gedeelde tags';

  @override
  String get matchSectionNoSharedVenues => 'Geen gedeelde venues';

  @override
  String get matchSectionUnknownTagGroup => 'Onbekend';

  @override
  String get matchActionsSkipDialogTitle => 'Deze match overslaan?';

  @override
  String get matchActionsSkipDialogMessage =>
      'Deze match wordt verwijderd uit je matches. De andere persoon ontvangt geen melding en zal niet weten dat je hem/haar hebt overgeslagen.';

  @override
  String get matchActionsSkipError => 'Overslaan van match mislukt';

  @override
  String get matchActionsConnectError => 'Verbinden mislukt';

  @override
  String get matchFinishTitle => 'Gelukt!';

  @override
  String get matchFinishDescription => 'Je verzoek is ingediend.';

  @override
  String matchFinishInfoMessage(String firstName) {
    return 'Als $firstName ook een introductie wil, ontvangen jullie automatisch een mail met beiden in Cc om kennis te maken.';
  }

  @override
  String get matchFinishDoneButton => 'Klaar';

  @override
  String get registrationCompleteError =>
      'Voltooien van registratie mislukt. Probeer het opnieuw.';

  @override
  String get registrationCompleteTutorialPrompt1 =>
      'met ervaring in internationaal opschalen.';

  @override
  String get registrationCompleteTutorialPrompt2 =>
      'met ervaring in Europese subsidies en graag zijn learnings deelt.';

  @override
  String get registrationCompleteTutorialPrompt3 =>
      'die al een coworking space heeft opgestart of uitgebaat.';

  @override
  String get registrationCompleteTutorialPrompt4 =>
      'met expertise in diervoeding voor nieuwe petfoodconcepten.';

  @override
  String get avatarUploadError =>
      'Uploaden van foto mislukt. Probeer het opnieuw.';

  @override
  String get avatarRemoveError =>
      'Verwijderen van foto mislukt. Probeer het opnieuw.';

  @override
  String get versionCheckUpdateAvailable =>
      'Een nieuwe versie van Venyu is beschikbaar. Update nu voor de nieuwste functies!';

  @override
  String get baseListViewLoading => 'Laden...';

  @override
  String get baseListViewErrorTitle => 'Laden van gegevens mislukt';

  @override
  String get baseFormViewErrorUpdate =>
      'Bijwerken mislukt, probeer het opnieuw';

  @override
  String get errorPrefix => 'Fout:';

  @override
  String reviewPendingPromptsAppBarTitle(String type) {
    return 'In behandeling $type';
  }

  @override
  String get inviteCodeErrorInvalidOrExpired =>
      'Deze code is ongeldig of verlopen. Controleer je code en probeer het opnieuw.';

  @override
  String get inviteCodeErrorRequired => 'Voer een uitnodigingscode in.';

  @override
  String get inviteCodeErrorLength =>
      'De code moet precies 8 karakters lang zijn.';

  @override
  String get venueErrorNotMember =>
      'Je bent geen lid van deze venue of deze bestaat niet.';

  @override
  String get venueErrorCodeInvalidOrExpired =>
      'Deze code is ongeldig of verlopen. Vraag een nieuwe code aan.';

  @override
  String get venueErrorAlreadyMember => 'Je bent al lid van deze venue.';

  @override
  String get venueErrorCodeRequired => 'Voer een venue code in.';

  @override
  String get venueErrorCodeLength =>
      'De code moet precies 8 karakters lang zijn.';

  @override
  String get venueErrorAdminRequired =>
      'Je hebt admin rechten nodig om venue leden te bekijken.';

  @override
  String get venueErrorIdRequired => 'Venue ID is vereist.';

  @override
  String get venueErrorAdminRequiredPrompts =>
      'Je hebt admin rechten nodig om venue prompts te bekijken.';

  @override
  String get venueErrorPermissionDenied =>
      'Je hebt geen toestemming om matches voor deze venue te bekijken.';

  @override
  String get optionButtonCompleteProfile => 'Profiel voltooien';
}
