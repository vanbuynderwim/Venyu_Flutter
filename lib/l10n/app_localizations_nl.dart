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
  String get tutorialStep0Title => 'Hoe het werkt';

  @override
  String get tutorialStep0Description =>
      'Venyu brengt mensen samen door hun aanbiedingen te matchen met de vragen van anderen.';

  @override
  String get tutorialStep1Title => 'Jouw aanbod';

  @override
  String get tutorialStep1Description =>
      'Beschrijf in een paar woorden wat je te bieden hebt of hoe je anderen kan helpen. Hou het kort maar duidelijk, hoe specifieker hoe beter we jou kunnen matchen met de juiste vragen.';

  @override
  String get tutorialStep2Title => 'Beantwoord vragen';

  @override
  String get tutorialStep2Description =>
      'We laten je weten wanneer we vragen van anderen hebben gevonden die passen bij jouw aanbod. Beslis zelf of je wil of kan helpen.';

  @override
  String get tutorialStep3Title => 'Word gematcht';

  @override
  String get tutorialStep3Description =>
      'De persoon van wie de vraag komt wordt met jou gematcht indien je kan helpen. Op dit punt zie jij de match nog niet. Zorg voor een compleet profiel voor een optimale matching score.';

  @override
  String get tutorialStep4Title => 'Introduction';

  @override
  String get tutorialStep4Description =>
      'De persoon die de vraag behandelt beslist welke match een introductie krijgt. Zodra je de introductie e-mail ontvangt, krijg je toegang tot het profiel van de match en kan je beginnen connecteren.';

  @override
  String get tutorialStep5Title => 'Jouw vraag';

  @override
  String get tutorialStep5Description =>
      'Dien je eigen vraag in en word gematcht met mensen die jou kunnen helpen. Deze keer zit jij aan het stuur!';

  @override
  String get tutorialButtonPrevious => 'Vorige';

  @override
  String get tutorialButtonNext => 'Volgende';

  @override
  String get tutorialDoneTitle => 'Je bent volledig mee!';

  @override
  String get tutorialDoneDescription =>
      'Laten we je profiel voltooien.\nDit duurt maar een minuutje.';

  @override
  String get registrationCompleteTitle => 'Bijna klaar!';

  @override
  String get registrationCompleteDescription =>
      'Bedankt voor het opstellen van je profiel. Laten we nu je aanbod toevoegen aan je profiel. Maak het duidelijk zodat we je kunnen matchen met de juiste vragen!';

  @override
  String get registrationCompleteButton => 'Doorgaan';

  @override
  String get promptEntryTitleFirstTime => 'Laten we het uitproberen!';

  @override
  String get promptEntryDescriptionFirstTime =>
      'Hier zijn 3 voorbeeldvragen om je te helpen begrijpen hoe het werkt. Dit is nog niet voor echt!';

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
  String get dailyPromptsReportSuccess => 'Vraag succesvol gerapporteerd';

  @override
  String get dailyPromptsReportError => 'Vraag rapporteren mislukt';

  @override
  String get dailyPromptsNoPromptsAvailable => 'Geen vragen beschikbaar';

  @override
  String get dailyPromptsExampleTag => 'Voorbeeldvraag';

  @override
  String get dailyPromptsReferralCodeSent =>
      'Check je mail voor een uitnodigingscode om te delen met de persoon die je kent';

  @override
  String get tutorialFinishedTitle => 'Je bent helemaal klaar! 🎉';

  @override
  String get tutorialFinishedDescription =>
      'Maak je profiel compleet voor sterke en relevante matches.\n\nMake the net work 🤝';

  @override
  String get tutorialFinishedButton => 'Oké!';

  @override
  String get registrationFinishTitle => 'That\'s it! 🎉';

  @override
  String get registrationFinishDescription =>
      'Je account is helemaal ingesteld en je hebt je eerste 3 vragen beantwoord. Kom morgen terug om meer vragen te beantwoorden en nieuwe matches te ontdekken.';

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
      'Momenteel geen vragen beschikbaar. Kom later terug!';

  @override
  String get errorFailedToLoadCards =>
      'Vragen laden mislukt. Probeer het opnieuw.';

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
  String get interactionTypeKnowSomeoneSelection => 'Ik ken iemand';

  @override
  String get interactionTypeKnowSomeoneSubtitle =>
      'Stel mensen voor die kunnen helpen';

  @override
  String get interactionTypeKnowSomeoneHint => 'Wie kun je aanraden?';

  @override
  String get interactionTypeNotRelevantSelection => 'Ik ken niemand';

  @override
  String get interactionTypeNotRelevantSubtitle => 'Deze sla ik over';

  @override
  String get interactionTypeNotRelevantHint => 'Wat wil je delen?';

  @override
  String get interactionTypeThisIsMeNewTitle => 'Nieuw aanbod';

  @override
  String get interactionTypeLookingForThisNewTitle => 'Nieuwe vraag';

  @override
  String get interactionTypeKnowSomeoneNewTitle => 'Nieuwe connectie';

  @override
  String get interactionTypeNotRelevantNewTitle => 'Overslaan';

  @override
  String interactionTypeMatchThisIsMe(String firstName) {
    return '$firstName biedt dit aan';
  }

  @override
  String interactionTypeMatchLookingForThis(String firstName) {
    return '$firstName zoekt dit';
  }

  @override
  String interactionTypeMatchKnowSomeone(String firstName) {
    return '$firstName kent iemand';
  }

  @override
  String get interactionTypeSelfThisIsMe => 'Ik bied dit aan';

  @override
  String get interactionTypeSelfLookingForThis => 'Ik zoek dit';

  @override
  String get interactionTypeSelfKnowSomeone => 'Ik ken iemand';

  @override
  String interactionTypePromptThisIsMe(String firstName) {
    return '$firstName is iemand';
  }

  @override
  String interactionTypePromptLookingForThis(String firstName) {
    return '$firstName zoekt iemand';
  }

  @override
  String interactionTypePromptKnowSomeone(String firstName) {
    return '$firstName kent iemand';
  }

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
  String get registrationStepReferrerTitle => 'Hoe heb je ons gevonden?';

  @override
  String get registrationStepOptinTitle => 'Haal meer uit Venyu';

  @override
  String get registrationStepOptinBody =>
      'Krijg tips om je profiel te versterken en betere matches te krijgen, en blijf op de hoogte van nieuwe functies zodra ze beschikbaar zijn.';

  @override
  String get registrationStepOptinButtonYes => 'Ja, hou me op de hoogte';

  @override
  String get registrationStepOptinButtonNo => 'Nee, bedankt';

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
      'Op je vragen krijg jij de first call. Matches worden pas aan anderen getoond als jij interesse toont.';

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
  String get benefitDailyCardsBoostTitle => 'Meer dagelijkse vragen';

  @override
  String get benefitDailyCardsBoostDescription =>
      'Meer vragen om je netwerk sneller te laten groeien.';

  @override
  String get benefitAiPoweredMatchesTitle => 'AI-gedreven matches (later)';

  @override
  String get benefitAiPoweredMatchesDescription =>
      'Ontvang slimme suggesties op basis van je profiel.';

  @override
  String get editCompanyInfoNameTitle => 'Bedrijfsgegevens';

  @override
  String get editCompanyInfoNameDescription => 'Naam van je bedrijf';

  @override
  String get editPersonalInfoNameTitle => 'Naam';

  @override
  String get editPersonalInfoNameDescription => 'Je naam';

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
  String get accountSettingsDeleteAccountTitle => 'Account verwijderen';

  @override
  String get accountSettingsDeleteAccountDescription =>
      'Verwijder je account permanent';

  @override
  String get accountSettingsExportDataTitle => 'Data exporteren';

  @override
  String get accountSettingsExportDataDescription =>
      'Download je persoonlijke gegevens';

  @override
  String get accountSettingsLogoutTitle => 'Uitloggen';

  @override
  String get accountSettingsLogoutDescription => 'Log uit van je account';

  @override
  String get accountSettingsRateUsTitle => 'Beoordeel ons';

  @override
  String get accountSettingsRateUsDescription =>
      '5 sterren is genoeg, bedankt!';

  @override
  String get accountSettingsFollowUsTitle => 'Volg ons';

  @override
  String get accountSettingsFollowUsDescription => 'Volg onze LinkedIn pagina';

  @override
  String get accountSettingsTestimonialTitle => 'Testimonial';

  @override
  String get accountSettingsTestimonialDescription =>
      'Schrijf een testimonial voor de website';

  @override
  String get accountSettingsTermsTitle => 'Algemene voorwaarden';

  @override
  String get accountSettingsTermsDescription =>
      'Lees onze algemene voorwaarden';

  @override
  String get accountSettingsPrivacyTitle => 'Privacybeleid';

  @override
  String get accountSettingsPrivacyDescription => 'Lees ons privacybeleid';

  @override
  String get accountSettingsSupportTitle => 'Contact support';

  @override
  String get accountSettingsSupportDescription =>
      'Krijg hulp van ons support team';

  @override
  String get accountSettingsFeatureRequestTitle => 'Feature verzoek';

  @override
  String get accountSettingsFeatureRequestDescription =>
      'Stel een nieuwe functie voor';

  @override
  String get accountSettingsBugTitle => 'Meld een bug';

  @override
  String get accountSettingsBugDescription => 'Meld een probleem of bug';

  @override
  String get accountSettingsPersonalInfoTitle => 'Persoonlijke gegevens';

  @override
  String get accountSettingsPersonalInfoDescription =>
      'Beheer je persoonlijke informatie';

  @override
  String get accountSettingsNotificationsTitle => 'Meldingen';

  @override
  String get accountSettingsNotificationsDescription =>
      'Beheer meldingsvoorkeuren';

  @override
  String get accountSettingsLocationSettingsTitle => 'Locatie-instellingen';

  @override
  String get accountSettingsLocationSettingsDescription =>
      'Update locatietoestemmingen';

  @override
  String get accountSettingsLinkedInTitle => 'LinkedIn';

  @override
  String get accountSettingsLinkedInDescription => 'Beheer LinkedIn verbinding';

  @override
  String get accountSettingsBlockedUsersTitle => 'Geblokkeerde gebruikers';

  @override
  String get accountSettingsBlockedUsersDescription =>
      'Bekijk en beheer geblokkeerde gebruikers';

  @override
  String get accountSettingsAutoIntroductionTitle => 'Automatische introductie';

  @override
  String get accountSettingsAutoIntroductionDescription =>
      'Automatisch introductie aanvragen bij matches';

  @override
  String get accountSettingsInviteCodesTitle => 'Uitnodigingscodes';

  @override
  String get accountSettingsInviteCodesDescription =>
      'Beschikbare uitnodigingscodes';

  @override
  String get accountSettingsLinksTitle => 'Links';

  @override
  String get accountSettingsLinksDescription => 'Je persoonlijke sociale links';

  @override
  String get accountSettingsRadiusTitle => 'Straal';

  @override
  String get accountSettingsRadiusDescription =>
      'Stel in tot hoever we je mogen matchen van je huidige locatie';

  @override
  String get editRadiusSavedMessage => 'Straal opgeslagen';

  @override
  String get editRadiusSaveErrorMessage => 'Opslaan van straal mislukt';

  @override
  String get editRadiusUnlimited => 'Onbeperkt';

  @override
  String get editRadiusInfoText =>
      'Zet op 0 voor onbeperkt bereik. We matchen je dan met relevante mensen ongeacht de afstand.';

  @override
  String get editRadiusLocationRequiredTitle => 'Locatie vereist';

  @override
  String get editRadiusLocationRequiredMessage =>
      'Om een match straal in te stellen, hebben we toegang tot je locatie nodig. Schakel locatie delen in om deze functie te gebruiken.';

  @override
  String get editRadiusEnableLocationButton => 'Locatie inschakelen';

  @override
  String get profileEditAccountTitle => 'Account';

  @override
  String get profileEditAccountDescription => 'Beheer je account';

  @override
  String get reviewTypeUserTitle => 'Door gebruiker aangemaakt';

  @override
  String get reviewTypeUserDescription => 'Vragen ingediend door gebruikers';

  @override
  String get reviewTypeSystemTitle => 'AI gegenereerd';

  @override
  String get reviewTypeSystemDescription =>
      'Dagelijks gegenereerde vragen door AI';

  @override
  String get appName => 'Venyu';

  @override
  String get appTagline => 'make the net work';

  @override
  String get navMatches => 'Matches';

  @override
  String get navCards => 'Vraag & aanbod';

  @override
  String get navNotifications => 'Updates';

  @override
  String get navProfile => 'Profiel';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get actionSend => 'Versturen';

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
      'Voer een geldige URL in (bijv. voorbeeld.com)';

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
  String get promptSectionCardDescription => 'Bekijk je vraag details';

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
      'Je vraag is opgeslagen als concept. Maak het af en dien het in om matches te ontvangen.';

  @override
  String get promptStatusPendingReviewDisplay =>
      'In afwachting van beoordeling';

  @override
  String get promptStatusPendingReviewInfo =>
      'Je vraag wordt beoordeeld door ons team. Dit duurt meestal 12-24 uur om te controleren of de inhoud voldoet aan de community richtlijnen.';

  @override
  String get promptStatusPendingTranslationDisplay => 'Wordt vertaald';

  @override
  String get promptStatusPendingTranslationInfo =>
      'Je vraag wordt vertaald naar andere talen.';

  @override
  String get promptStatusApprovedDisplay => 'Goedgekeurd';

  @override
  String get promptStatusApprovedInfo =>
      'Je vraag is goedgekeurd en staat live. Je kunt matches ontvangen.';

  @override
  String get promptStatusRejectedDisplay => 'Afgewezen';

  @override
  String get promptStatusRejectedInfo =>
      'Je vraag werd afgewezen omdat het niet voldoet aan de community richtlijnen. Pas het aan en dien het opnieuw in.';

  @override
  String get promptStatusArchivedDisplay => 'Gearchiveerd';

  @override
  String get promptStatusArchivedInfo =>
      'Je vraag is gearchiveerd en niet meer zichtbaar voor andere gebruikers.';

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
      'Wanneer vragen ter beoordeling worden ingediend, verschijnen ze hier';

  @override
  String get emptyStateMatchesTitle => 'Wachten op je eerste match!';

  @override
  String get emptyStateMatchesDescription =>
      'Zodra je een match hebt, verschijnt deze hier. Stel je eerste vraag om sneller gematcht te worden.';

  @override
  String get emptyStatePromptsTitle => 'Klaar om gematcht te worden?';

  @override
  String get emptyStatePromptsDescription =>
      'Vragen worden gematcht met het aanbod van andere ondernemers. Stel die van jou om te ontdekken wie jou kan helpen.';

  @override
  String get emptyStateKnowSomeoneTitle => 'Nog geen doorverwijzingen';

  @override
  String get emptyStateKnowSomeoneDescription =>
      'Wanneer je vragen beantwoordt met \"Die ken ik\", verschijnen ze hier.';

  @override
  String get emptyStateNotificationSettingsTitle =>
      'Geen instellingen beschikbaar';

  @override
  String get emptyStateNotificationSettingsDescription =>
      'Notificatie-instellingen verschijnen hier zodra ze zijn geconfigureerd.';

  @override
  String get notificationSettingsTitle => 'Notificatie-instellingen';

  @override
  String get notificationSettingsPushSection => 'Push notificaties';

  @override
  String get notificationSettingsEmailSection => 'Email notificaties';

  @override
  String get notificationsDisabledWarning =>
      'Push notificaties zijn uitgeschakeld. Tik hier om ze in te schakelen in je toestel instellingen.';

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
      'Door in te loggen ga je akkoord met onze Algemene Voorwaarden.';

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
  String get matchItemReachOut => 'Stel jezelf voor';

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
  String get matchReachOutTitle => 'Introductie';

  @override
  String matchReachOutSubtitle(String name) {
    return 'Stel jezelf voor aan $name';
  }

  @override
  String get matchReachOutGreeting => 'Hallo';

  @override
  String get matchReachOutPromptContextSingular => 'De vraag die ons matcht:';

  @override
  String get matchReachOutPromptContextPlural => 'De vragen die ons matchen:';

  @override
  String get matchReachOutMessagePlaceholder => 'Schrijf je bericht hier...';

  @override
  String get matchReachOutInfoMessage =>
      'Je bericht wordt rechtstreeks via e-mail verzonden en wordt niet opgeslagen door Venyu. Je kan één introductie per match sturen, dus hou het duidelijk, respectvol en professioneel.';

  @override
  String get matchReachOutContactsSubtitle => 'Deel extra links (optioneel)';

  @override
  String get matchReachOutPreviewTitle => 'Voorbeeld';

  @override
  String get matchReachOutPreviewFromLabel => 'Van';

  @override
  String matchReachOutPreviewFromValue(String name) {
    return '$name (via Venyu)';
  }

  @override
  String get matchReachOutPreviewReplyToLabel => 'Antwoord naar';

  @override
  String get matchReachOutPreviewSubjectLabel => 'Onderwerp';

  @override
  String matchReachOutPreviewSubject(String firstName) {
    return 'Introductie van $firstName';
  }

  @override
  String get matchReachOutPreviewPS =>
      'PS: Antwoord gerust rechtstreeks op deze e-mail.';

  @override
  String get matchReachOutFinishTitle => 'Introductie verzonden!';

  @override
  String matchReachOutFinishDescription(String name) {
    return 'Je bericht is verzonden naar $name. Ze ontvangen het rechtstreeks in hun inbox.';
  }

  @override
  String get matchReachOutFinishDoneButton => 'Klaar';

  @override
  String get matchReachOutSuccessMessage => 'Bericht succesvol verzonden';

  @override
  String get matchReachOutErrorMessage => 'Bericht verzenden mislukt';

  @override
  String get matchStagesTitle => 'Connectie fase';

  @override
  String get matchStagesDescription =>
      'Volg de voortgang van deze match. Zowel jij als je match kunnen deze fase aanpassen.';

  @override
  String get matchStagesSaveButton => 'Opslaan';

  @override
  String get matchStagesSavingButton => 'Opslaan...';

  @override
  String get matchStagesLoadErrorTitle => 'Fout bij laden fases';

  @override
  String get matchStagesRetryButton => 'Opnieuw proberen';

  @override
  String get matchStagesNoStagesMessage => 'Geen fases beschikbaar';

  @override
  String get matchStagesSaveErrorTitle => 'Fout bij opslaan fase';

  @override
  String matchStagesSaveErrorMessage(String error) {
    return 'Fase opslaan mislukt: $error';
  }

  @override
  String get matchStagesErrorDialogOk => 'OK';

  @override
  String matchDetailFirstCallWarning(String firstName) {
    return 'Enkel jij ziet deze match. Zodra je jezelf voorstelt, ziet $firstName jou ook.';
  }

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
  String get matchDetailCard => 'vraag';

  @override
  String get matchDetailCards => 'vragen';

  @override
  String matchDetailSharedIntros(int count, String intros) {
    return '$count gedeelde $intros';
  }

  @override
  String get matchDetailIntroduction => 'match';

  @override
  String get matchDetailIntroductions => 'matches';

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
  String get contactSectionEmptyContacts => 'Geen contactopties beschikbaar';

  @override
  String get aboutMeSectionEmptyTitle => 'Dit ben ik';

  @override
  String get aboutMeSectionEmptyDescription =>
      'Voeg een paar aanbiedingen toe die beschrijven hoe je anderen kan helpen. Ze zijn privé en worden alleen gebruikt voor matching met vragen van anderen.';

  @override
  String get aboutMeSectionEmptyAction => 'Voeg aanbod toe';

  @override
  String get profileSectionAboutMeTitle => 'Mijn aanbod';

  @override
  String get profileSectionAboutMeDescription =>
      'Aanbiedingen over wie je bent en hoe je anderen helpt. Ze verbeteren je matches.';

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
  String get profileSectionContactTitle => 'Links';

  @override
  String get profileSectionContactDescription => 'Je contact links';

  @override
  String get profileSectionReviewsTitle => 'Reviews';

  @override
  String get profileSectionReviewsDescription =>
      'Gebruikersbeoordelingen en feedback';

  @override
  String profilePersonalCompletenessMessage(int percentage) {
    return 'Je persoonlijk profiel is $percentage% compleet. Vul het volledig in om betere en meer relevante matches te krijgen.';
  }

  @override
  String profileCompanyCompletenessMessage(int percentage) {
    return 'Je professioneel profiel is $percentage% compleet. Vul het volledig in om betere en meer relevante matches te krijgen.';
  }

  @override
  String get profileContactPrivacyMessage =>
      'Je contactgegevens worden nooit automatisch gedeeld, ook niet bij introducties. Jij kiest wat je deelt wanneer je contact opneemt.';

  @override
  String get editAccountTitle => 'Instellingen';

  @override
  String get editAccountProfileSectionLabel => 'Profiel';

  @override
  String get editAccountSettingsSectionLabel => 'Instellingen';

  @override
  String get editAccountFeedbackSectionLabel => 'Feedback';

  @override
  String get editAccountSupportLegalSectionLabel => 'Support & Juridisch';

  @override
  String get editAccountReviewsSectionLabel => 'Reviews';

  @override
  String get editAccountSectionLabel => 'Account';

  @override
  String get editAccountDataExportTitle => 'Data Export';

  @override
  String get editAccountDataExportDescription =>
      'Je kunt een kopie van al je persoonlijke gegevens aanvragen. Dit omvat je profielinformatie, vragen, aanbiedingen, matches en activiteitengeschiedenis. De export wordt naar je geregistreerde e-mailadres gestuurd.';

  @override
  String get editAccountExportDataButton => 'Exporteer al je gegevens';

  @override
  String get editAccountDeleteTitle => 'Account verwijderen';

  @override
  String get editAccountDeleteDescription =>
      'Het verwijderen van je account is definitief. Al je gegevens, inclusief je profiel, vragen, aanbiedingen en matches worden verwijderd.';

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
  String get editAccountSettingsUpdateError =>
      'Instelling kon niet worden bijgewerkt. Probeer het opnieuw.';

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
  String get editNameTitle => 'Jouw naam';

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
      'We gebruiken je e-mail alleen voor accountverificatie, matchmeldingen, updates over je vragen en serviceberichten.';

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
  String get editContactSettingSavedMessage => 'Contactgegevens opgeslagen';

  @override
  String get editContactSettingErrorMessage =>
      'Bijwerken van contactgegevens mislukt, probeer het opnieuw';

  @override
  String get editContactSettingValueHint => 'Voer waarde in';

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
      'Je stad wordt alleen gedeeld met mensen waarmee je matcht en is niet publiek zichtbaar. Dit helpt om betere persoonlijke ontmoetingen te faciliteren zodra een connectie is gemaakt.';

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
      'Je foto is vaak je eerste indruk. Kies een duidelijke, vriendelijke headshot.';

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
      'Je bio is je professionele introductie. Deel wat je doet, wat je interesseert en hoe je graag samenwerkt met anderen. Een duidelijke bio helpt mensen begrijpen wie er achter de match zit.';

  @override
  String get editBioPlaceholder => 'Schrijf hier je bio...';

  @override
  String get promptCardCreatedLabel => 'Aangemaakt';

  @override
  String get promptCardReviewedLabel => 'Beoordeeld';

  @override
  String get promptCardStatusLabel => 'Status';

  @override
  String get promptCardUpgradeTitle => 'Verleng je vraag zichtbaarheid';

  @override
  String get promptCardUpgradeSubtitle =>
      'Upgrade naar Venyu Pro om je vraag 10 dagen in plaats van 3 online te houden.';

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
      'Wanneer mensen matchen met je vraag, verschijnen hun profielen hier.';

  @override
  String get promptStatsTitle => 'Statistieken komen binnenkort';

  @override
  String get promptStatsDescription =>
      'Volg de prestaties, weergaven en engagement metrics van je vraag.';

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
      'Schrijf zelf een aanbod of vraag';

  @override
  String get interactionTypeSelectionDisclaimerText =>
      'Vragen worden nagekeken voordat ze live gaan';

  @override
  String get interactionTypeSelectionDisclaimerBeforeLinkText =>
      'Vragen worden nagekeken volgens onze ';

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
  String get interactionTypeSelectionPrivatePromptsInfo =>
      'Een aanbod beschrijft hoe je anderen kan helpen. Hou het kort maar duidelijk, hoe specifieker hoe beter we jou kunnen matchen met de juiste vragen.';

  @override
  String get promptDetailTitle => 'Detail';

  @override
  String get promptDetailStatusTitle => 'Status';

  @override
  String get promptDetailHowYouMatchTitle => 'Matchen beheren';

  @override
  String get promptDetailHowYouMatchDescription =>
      'Pauzeer het matchen op deze vraag om tijdelijk te stoppen met nieuwe matches ontvangen. Je kan op elk moment hervatten.';

  @override
  String get promptDetailFirstCallTitle => 'First Call';

  @override
  String get promptDetailPublishedInTitle => 'Gepubliceerd in';

  @override
  String promptDetailMatchesTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String get promptDetailErrorMessage => 'Laden van vraag mislukt';

  @override
  String get promptDetailErrorDataMessage => 'Laden van vraag mislukt';

  @override
  String get promptDetailRetryButton => 'Opnieuw proberen';

  @override
  String get promptDetailEmptyMatchesTitle => 'Nog geen matches';

  @override
  String get promptDetailEmptyMatchesDescription =>
      'Wanneer mensen matchen met je vraag, verschijnen hun profielen hier.';

  @override
  String get promptDetailEditButton => 'Vraag bewerken';

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
    return 'Je ontvangt geen matches meer voor \"$interactionType\" op deze vraag. Je kunt matching altijd hervatten.';
  }

  @override
  String get promptDetailPauseMatchingConfirm => 'Pauzeren';

  @override
  String get promptDetailPauseMatchingCancel => 'Annuleren';

  @override
  String get promptDetailPauseMatchingMessageGeneric =>
      'Je ontvangt geen matches meer op deze vraag. Je kan matchen op elk moment hervatten.';

  @override
  String get promptDetailMatchingActiveLabel => 'Matchen is actief';

  @override
  String get promptDetailMatchingPausedLabel => 'Matchen is gepauzeerd';

  @override
  String get promptItemPausedTag => 'Gepauzeerd';

  @override
  String promptItemMatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String promptItemOtherMatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count andere matches',
      one: '1 andere match',
    );
    return '$_temp0';
  }

  @override
  String get promptDetailRejectButton => 'Afwijzen';

  @override
  String get promptDetailApproveButton => 'Goedkeuren';

  @override
  String get promptDetailApprovedMessage => 'Vraag goedgekeurd';

  @override
  String get promptDetailRejectedMessage => 'Vraag afgewezen';

  @override
  String get promptDetailDeleteButton => 'Verwijderen';

  @override
  String get promptDetailDeleteConfirmTitle => 'Verwijderen?';

  @override
  String get promptDetailDeleteConfirmMessage =>
      'Dit zal je gegevens permanent verwijderen. Deze actie kan niet ongedaan gemaakt worden.';

  @override
  String get promptDetailDeleteConfirmButton => 'Verwijderen';

  @override
  String get promptDetailDeleteCancelButton => 'Annuleren';

  @override
  String get promptDetailDeletedMessage => 'Verwijderd';

  @override
  String get promptDetailDeleteErrorMessage => 'Verwijderen mislukt';

  @override
  String get promptEditNextButton => 'Volgende';

  @override
  String promptEntryGreeting(String firstName) {
    return 'Hoi$firstName 👋';
  }

  @override
  String get promptEntryGreetingFirstTime => 'Laten we eerst oefenen!';

  @override
  String promptEntryFirstTimeDescription(int count) {
    return 'De volgende $count vragen zijn oefenvoorbeelden om je te leren hoe je ze beantwoordt.';
  }

  @override
  String promptEntryDailyDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'We hebben $count nieuwe vragen gevonden die matchen met je aanbod.',
      one: 'We hebben 1 nieuwe vraag gevonden die matcht met je aanbod.',
    );
    return '$_temp0';
  }

  @override
  String get promptEntryButton => 'Laat zien';

  @override
  String get promptFinishTitle => 'Vraag ingediend!';

  @override
  String get promptFinishDescription =>
      'Je vraag is succesvol ingediend en wordt beoordeeld. We laten je weten wanneer deze live is.';

  @override
  String get promptFinishReviewInfo =>
      'Beoordelingen duren meestal minder dan 24 uur';

  @override
  String get promptFinishDoneButton => 'Klaar';

  @override
  String get promptFinishSavedTitle => 'Aanbod opgeslagen';

  @override
  String get promptFinishSavedDescription =>
      'Je aanbod is succesvol opgeslagen!';

  @override
  String get promptPreviewTitle => 'Voorbeeld';

  @override
  String get promptPreviewNextButton => 'Volgende';

  @override
  String get promptPreviewSubmitButton => 'Indienen';

  @override
  String get promptPreviewErrorUpdate => 'Bijwerken mislukt';

  @override
  String get promptPreviewErrorSubmit => 'Indienen mislukt';

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
  String get promptSelectVenueErrorSubmit => 'Indienen mislukt';

  @override
  String get promptSettingsTitle => 'Instellingen';

  @override
  String get promptSettingsSubmitButton => 'Indienen';

  @override
  String get promptSettingsErrorSubmit => 'Indienen mislukt';

  @override
  String get promptsViewTitle => 'Vragen';

  @override
  String get promptsViewEmptyActionButton => 'Stel een vraag';

  @override
  String get promptsViewAnswerPromptsButton => 'Onbeantwoorde vragen';

  @override
  String get promptsViewAllAnsweredMessage =>
      'Alle vragen beantwoord voor vandaag';

  @override
  String get promptsViewMyPromptsTitle => 'Vraag en aanbod';

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
  String get venueDetailCardSingular => 'Vraag';

  @override
  String get venueDetailCardsPlural => 'Vragen';

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
    return '$venueName vragen';
  }

  @override
  String get venuePromptsViewEmptyTitle => 'Geen vragen gevonden';

  @override
  String get venuePromptsViewEmptyDescription =>
      'Deze venue heeft nog geen vragen.';

  @override
  String get communityGuidelinesTitle => 'Richtlijnen';

  @override
  String get communityGuidelinesAllowed =>
      'Netwerken, kennis delen, hulp vragen, ervaringen en expertise delen, relevante introducties leggen, samenwerking verkennen, sparren over uitdagingen, co-founders of strategische partners zoeken, ondernemersvragen, aanbevelingen zoeken of geven.';

  @override
  String get communityGuidelinesProhibited =>
      'Een verdoken aanbod, spam, oplichting, misleiding, aanstootgevende of expliciete inhoud, toxisch of discriminerend gedrag, religieuze discussies, haatdragende uitspraken, vacatures of jobadvertenties, politiek, reclame of commerciële boodschappen.';

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
  String get matchesViewEmptyActionButton => 'Stel een vraag';

  @override
  String get profileViewTitle => 'Profiel';

  @override
  String get profileViewFabJoinVenue => 'Venue toevoegen';

  @override
  String get profileHeaderBioPlaceholder => 'Schrijf iets over jezelf...';

  @override
  String get profileHeaderReachOutButton => 'Stel jezelf voor';

  @override
  String get profileHeaderAlreadyConnectedButton => 'Al geconnecteerd ?';

  @override
  String get getMatchedButtonLabel => 'Word gematcht';

  @override
  String get reviewPendingPromptsErrorUpdate => 'Bijwerken mislukt';

  @override
  String get reviewPendingPromptsErrorUpdateAll =>
      'Bijwerken van alles mislukt';

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
      'Een nieuwe versie is beschikbaar. Tik hier om te updaten!';

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
    return '$type';
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
      'Je hebt admin rechten nodig om venue vragen te bekijken.';

  @override
  String get venueErrorPermissionDenied =>
      'Je hebt geen toestemming om matches voor deze venue te bekijken.';

  @override
  String get optionButtonCompleteProfile => 'Profiel voltooien';

  @override
  String returningUserTutorialWelcome(String name) {
    return 'Welkom terug $name';
  }

  @override
  String get returningUserTutorialDescription =>
      'De spelregels in Venyu zijn veranderd en we leggen je het graag even stap voor stap uit.\n\nSpoiler: we nemen afscheid van de 3 dagelijkse prompts, en zelfs van het woord \'prompt\'.';

  @override
  String get returningUserTutorialButton => 'Laat zien';

  @override
  String get returningUserTutorialDoneDescription =>
      'Bedankt om even de tijd te nemen, veel plezier met deze nieuwe versie!';

  @override
  String get returningUserTutorialDoneButton => 'Sluiten';
}
