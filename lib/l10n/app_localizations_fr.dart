// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardTitle => 'Bienvenue sur Venyu';

  @override
  String get onboardDescription =>
      'Vous faites maintenant partie d\'une communauté basée sur de vraies introductions !\n\nCommençons par une visite rapide avant de configurer votre profil.';

  @override
  String get onboardStartTutorial =>
      'Avant de configurer votre profil, découvrez comment Venyu fonctionne avec un tutoriel rapide.';

  @override
  String get onboardButtonStart => 'Commencer';

  @override
  String get tutorialStep0Title => 'Comment ça marche';

  @override
  String get tutorialStep0Description =>
      'Venyu rapproche les personnes en faisant correspondre leurs offres avec les demandes des autres.';

  @override
  String get tutorialStep1Title => 'Votre offre';

  @override
  String get tutorialStep1Description =>
      'Décrivez en quelques mots ce que vous avez à offrir ou comment vous pouvez aider les autres. Gardez-le court mais clair, plus c\'est spécifique, mieux nous pourrons vous matcher avec les bonnes demandes.';

  @override
  String get tutorialStep2Title => 'Répondre aux demandes';

  @override
  String get tutorialStep2Description =>
      'Nous vous notifierons lorsque nous avons trouvé des demandes d\'autres personnes correspondant à votre offre. Décidez vous-même si vous voulez ou pouvez aider.';

  @override
  String get tutorialStep3Title => 'Soyez matché';

  @override
  String get tutorialStep3Description =>
      'La personne qui a publié la demande est matchée avec vous si vous pouvez aider. À ce stade, vous ne voyez pas encore le match. Complétez votre profil pour un score de matching optimal.';

  @override
  String get tutorialStep4Title => 'Introduction';

  @override
  String get tutorialStep4Description =>
      'La personne qui traite la demande décide quel match reçoit une introduction. Une fois que vous recevez l\'e-mail d\'introduction, vous aurez accès au profil du match et pourrez commencer à connecter.';

  @override
  String get tutorialStep5Title => 'Votre demande';

  @override
  String get tutorialStep5Description =>
      'Soumettez votre propre demande et soyez matché avec des personnes qui peuvent vous aider. Cette fois, c\'est vous qui êtes aux commandes !';

  @override
  String get tutorialButtonPrevious => 'Précédent';

  @override
  String get tutorialButtonNext => 'Suivant';

  @override
  String get tutorialDoneTitle => 'Vous êtes au courant !';

  @override
  String get tutorialDoneDescription =>
      'Complétons votre profil.\nCela ne prendra qu\'une minute.';

  @override
  String get registrationCompleteTitle => 'Presque terminé !';

  @override
  String get registrationCompleteDescription =>
      'Merci d\'avoir configuré votre profil. Ajoutons maintenant votre offre à votre profil. Soyez clair pour que nous puissions vous matcher avec les bonnes demandes !';

  @override
  String get registrationCompleteButton => 'Continuer';

  @override
  String get promptEntryTitleFirstTime => 'Essayons !';

  @override
  String get promptEntryDescriptionFirstTime =>
      'Voici 3 exemples de demandes pour vous aider à comprendre comment ça fonctionne. Ne vous inquiétez pas, ce ne sont que des exercices.';

  @override
  String get promptEntryButtonFirstTime => 'Démarrer le tutoriel';

  @override
  String dailyPromptsHintSelect(String buttonTitle) {
    return 'Sélectionnez \"$buttonTitle\"';
  }

  @override
  String get dailyPromptsHintConfirm => 'Sélectionnez \"Suivant\"';

  @override
  String get dailyPromptsButtonNext => 'Suivant';

  @override
  String get dailyPromptsReportSuccess => 'Demande signalée avec succès';

  @override
  String get dailyPromptsReportError => 'Échec du signalement de la demande';

  @override
  String get dailyPromptsNoPromptsAvailable => 'Aucune demande disponible';

  @override
  String get dailyPromptsExampleTag => 'Exemple de demande';

  @override
  String get dailyPromptsReferralCodeSent =>
      'Consultez votre e-mail pour obtenir un code d\'invitation à partager avec la personne que vous connaissez';

  @override
  String get tutorialFinishedTitle => 'Vous êtes prêt ! 🎉';

  @override
  String get tutorialFinishedDescription =>
      'Complétez votre profil pour des correspondances fortes et pertinentes.\n\nMake the net work 🤝';

  @override
  String get tutorialFinishedButton => 'C\'est parti !';

  @override
  String get registrationFinishTitle => 'C\'est fait ! 🎉';

  @override
  String get registrationFinishDescription =>
      'Votre compte est configuré et vous avez répondu à vos 3 premières demandes. Revenez demain pour répondre à plus de demandes et découvrir de nouveaux matches.';

  @override
  String get registrationFinishButton => 'Terminé !';

  @override
  String get buttonContinue => 'Continuer';

  @override
  String get buttonNext => 'Suivant';

  @override
  String get buttonPrevious => 'Précédent';

  @override
  String get buttonStart => 'Commencer';

  @override
  String get buttonGotIt => 'Compris';

  @override
  String get errorNoCardsAvailable =>
      'Aucune demande disponible pour le moment. Revenez plus tard !';

  @override
  String get errorFailedToLoadCards =>
      'Échec du chargement des demandes. Veuillez réessayer.';

  @override
  String get errorFailedToRefreshProfile =>
      'Échec de l\'actualisation du profil. Veuillez réessayer.';

  @override
  String get errorNoInternetConnection =>
      'Pas de connexion Internet. Vérifiez votre connexion et réessayez.';

  @override
  String get errorAuthenticationFailed =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get interactionTypeThisIsMeButton => 'C\'est moi';

  @override
  String get interactionTypeLookingForThisButton => 'J\'ai besoin';

  @override
  String get interactionTypeKnowSomeoneButton => 'Je peux présenter';

  @override
  String get interactionTypeNotRelevantButton => 'Pas pour moi';

  @override
  String get interactionTypeThisIsMeButtonToo => 'C\'est moi aussi';

  @override
  String get interactionTypeLookingForThisButtonToo => 'J\'ai besoin aussi';

  @override
  String get interactionTypeKnowSomeoneButtonToo =>
      'Je connais quelqu\'un aussi';

  @override
  String get interactionTypeNotRelevantButtonToo => 'Pas pour moi';

  @override
  String get interactionTypeLookingForThisSelection => 'Je cherche quelqu\'un';

  @override
  String get interactionTypeLookingForThisHint =>
      'avec de l\'expérience en...\nqui peut aider avec...\navec accès à...\nqui peut brainstormer sur...\nqui peut me présenter à...\nqui peut conseiller sur...\navec une expertise en...\n...';

  @override
  String get interactionTypeThisIsMeHint =>
      'qui peut aider avec...\navec de l\'expérience en...\nqui peut vous présenter à...\nqui peut réfléchir sur...\nqui peut conseiller sur...\navec une expertise en...\nqui a des connexions dans...\n...';

  @override
  String get interactionTypeThisIsMeSelection => 'Je suis quelqu\'un';

  @override
  String get interactionTypeLookingForThisSubtitle =>
      'peut offrir des conseils, de l\'expérience, des introductions...';

  @override
  String get interactionTypeThisIsMeSubtitle =>
      'peut aider avec de l\'expérience, des apprentissages, un réseau...';

  @override
  String get interactionTypeKnowSomeoneSelection => 'Je peux connecter';

  @override
  String get interactionTypeKnowSomeoneSubtitle =>
      'Présenter des personnes qui peuvent aider';

  @override
  String get interactionTypeKnowSomeoneHint =>
      'Qui pouvez-vous connecter pour ce besoin ?';

  @override
  String get interactionTypeNotRelevantSelection => 'Passer';

  @override
  String get interactionTypeNotRelevantSubtitle => 'Passer celui-ci';

  @override
  String get interactionTypeNotRelevantHint => 'Que souhaitez-vous partager ?';

  @override
  String get interactionTypeThisIsMeNewTitle => 'Nouvelle offre';

  @override
  String get interactionTypeLookingForThisNewTitle => 'Nouvelle demande';

  @override
  String get interactionTypeKnowSomeoneNewTitle => 'Nouvelle connexion';

  @override
  String get interactionTypeNotRelevantNewTitle => 'Passer';

  @override
  String get registrationStepNameTitle => 'Informations personnelles';

  @override
  String get registrationStepEmailTitle => 'Vérification de l\'e-mail';

  @override
  String get registrationStepLocationTitle => 'Partager la localisation';

  @override
  String get registrationStepCityTitle => 'Ville';

  @override
  String get registrationStepCompanyTitle => 'Informations sur l\'entreprise';

  @override
  String get registrationStepRolesTitle => 'Vos rôles';

  @override
  String get registrationStepSectorsTitle => 'Vos secteurs';

  @override
  String get registrationStepMeetingPreferencesTitle =>
      'Préférences de rencontre';

  @override
  String get registrationStepNetworkingGoalsTitle => 'Objectifs de réseautage';

  @override
  String get registrationStepAvatarTitle => 'Photo de profil';

  @override
  String get registrationStepNotificationsTitle => 'Notifications';

  @override
  String get registrationStepReferrerTitle => 'Comment nous avez-vous trouvé ?';

  @override
  String get registrationStepOptinTitle => 'Tirez le meilleur parti de Venyu';

  @override
  String get registrationStepOptinBody =>
      'Recevez des conseils pour renforcer votre profil et obtenir de meilleures correspondances, et restez informé des nouvelles fonctionnalités dès qu\'elles sont disponibles.';

  @override
  String get registrationStepOptinButtonYes => 'Oui, tenez-moi au courant';

  @override
  String get registrationStepOptinButtonNo => 'Non, merci';

  @override
  String get registrationStepCompleteTitle => 'Bienvenue sur Venyu !';

  @override
  String get benefitNearbyMatchesTitle =>
      'Rencontrez des entrepreneurs proches';

  @override
  String get benefitNearbyMatchesDescription =>
      'Découvrez des personnes près de chez vous';

  @override
  String get benefitDistanceAwarenessTitle => 'Voyez qui est à portée';

  @override
  String get benefitDistanceAwarenessDescription =>
      'Connaissez la distance des matches';

  @override
  String get benefitBetterMatchingTitle => 'Développez votre réseau localement';

  @override
  String get benefitBetterMatchingDescription =>
      'Obtenez de meilleurs résultats avec une approche locale';

  @override
  String get benefitMatchNotificationsTitle => 'Alertes de nouveaux matches';

  @override
  String get benefitMatchNotificationsDescription =>
      'Soyez alerté dès qu\'un nouveau match apparaît';

  @override
  String get benefitConnectionNotificationsTitle => 'Ne ratez aucune intro';

  @override
  String get benefitConnectionNotificationsDescription =>
      'Sachez immédiatement quand vous recevez une nouvelle introduction';

  @override
  String get benefitDailyRemindersTitle => 'Restez dans le jeu';

  @override
  String get benefitDailyRemindersDescription =>
      'Recevez un rappel quotidien pour make the net work';

  @override
  String get benefitFocusedReachTitle => 'Ciblage intelligent';

  @override
  String get benefitFocusedReachDescription =>
      'Publiez vos questions au bon public';

  @override
  String get benefitDiscreetPreviewTitle => 'First call';

  @override
  String get benefitDiscreetPreviewDescription =>
      'Sur vos demandes, vous avez le first call. Les matches ne sont montrés aux autres que si vous êtes intéressé.';

  @override
  String get benefitUnlimitedIntroductionsTitle => 'Intros illimitées';

  @override
  String get benefitUnlimitedIntroductionsDescription =>
      'Continuez à développer votre réseau avec des introductions illimitées et ne ratez jamais une opportunité';

  @override
  String get benefitUnlockFullProfilesTitle => 'Profils complets';

  @override
  String get benefitUnlockFullProfilesDescription =>
      'Découvrez qui se cache derrière le match en voyant leur avatar et en vérifiant les intérêts communs';

  @override
  String get benefitViewsAndImpressionsTitle => 'Vues et impressions';

  @override
  String get benefitViewsAndImpressionsDescription =>
      'Comprenez votre portée avec des statistiques simples';

  @override
  String get benefitDailyCardsBoostTitle => 'Plus de demandes quotidiennes';

  @override
  String get benefitDailyCardsBoostDescription =>
      'Plus de demandes pour développer votre réseau plus rapidement.';

  @override
  String get benefitAiPoweredMatchesTitle => 'Matches par IA (plus tard)';

  @override
  String get benefitAiPoweredMatchesDescription =>
      'Recevez des suggestions intelligentes basées sur votre profil.';

  @override
  String get editCompanyInfoNameTitle => 'Informations de l\'entreprise';

  @override
  String get editCompanyInfoNameDescription => 'Nom de votre entreprise';

  @override
  String get editPersonalInfoNameTitle => 'Nom';

  @override
  String get editPersonalInfoNameDescription => 'Votre nom';

  @override
  String get editPersonalInfoBioTitle => 'Bio';

  @override
  String get editPersonalInfoBioDescription =>
      'Une courte présentation de vous';

  @override
  String get editPersonalInfoLocationTitle => 'Ville';

  @override
  String get editPersonalInfoLocationDescription => 'La ville où vous vivez';

  @override
  String get editPersonalInfoEmailTitle => 'E-mail';

  @override
  String get editPersonalInfoEmailDescription =>
      'Votre adresse e-mail de contact';

  @override
  String get accountSettingsDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get accountSettingsDeleteAccountDescription =>
      'Supprimer définitivement votre compte';

  @override
  String get accountSettingsExportDataTitle => 'Exporter les données';

  @override
  String get accountSettingsExportDataDescription =>
      'Télécharger vos données personnelles';

  @override
  String get accountSettingsLogoutTitle => 'Déconnexion';

  @override
  String get accountSettingsLogoutDescription =>
      'Se déconnecter de votre compte';

  @override
  String get accountSettingsRateUsTitle => 'Évaluez-nous';

  @override
  String get accountSettingsRateUsDescription => '5 étoiles suffisent, merci!';

  @override
  String get accountSettingsFollowUsTitle => 'Suivez-nous';

  @override
  String get accountSettingsFollowUsDescription => 'Suivez notre page LinkedIn';

  @override
  String get accountSettingsTestimonialTitle => 'Témoignage';

  @override
  String get accountSettingsTestimonialDescription =>
      'Écrire un témoignage pour le site web';

  @override
  String get accountSettingsTermsTitle => 'Conditions générales';

  @override
  String get accountSettingsTermsDescription => 'Lire nos conditions générales';

  @override
  String get accountSettingsPrivacyTitle => 'Politique de confidentialité';

  @override
  String get accountSettingsPrivacyDescription =>
      'Lire notre politique de confidentialité';

  @override
  String get accountSettingsSupportTitle => 'Support technique';

  @override
  String get accountSettingsSupportDescription =>
      'Obtenir de l\'aide de notre équipe';

  @override
  String get accountSettingsFeatureRequestTitle => 'Demande de fonctionnalité';

  @override
  String get accountSettingsFeatureRequestDescription =>
      'Suggérer une nouvelle fonctionnalité';

  @override
  String get accountSettingsBugTitle => 'Signaler un bug';

  @override
  String get accountSettingsBugDescription => 'Signaler un problème ou bug';

  @override
  String get accountSettingsPersonalInfoTitle => 'Informations personnelles';

  @override
  String get accountSettingsPersonalInfoDescription =>
      'Gérer vos informations personnelles';

  @override
  String get accountSettingsNotificationsTitle => 'Notifications';

  @override
  String get accountSettingsNotificationsDescription =>
      'Gérer les préférences de notification';

  @override
  String get accountSettingsLocationSettingsTitle =>
      'Paramètres de localisation';

  @override
  String get accountSettingsLocationSettingsDescription =>
      'Mettre à jour les autorisations';

  @override
  String get accountSettingsLinkedInTitle => 'LinkedIn';

  @override
  String get accountSettingsLinkedInDescription =>
      'Gérer la connexion LinkedIn';

  @override
  String get accountSettingsBlockedUsersTitle => 'Utilisateurs bloqués';

  @override
  String get accountSettingsBlockedUsersDescription =>
      'Voir et gérer les utilisateurs bloqués';

  @override
  String get accountSettingsAutoIntroductionTitle => 'Auto-présentation';

  @override
  String get accountSettingsAutoIntroductionDescription =>
      'Demander automatiquement une présentation lors des matches';

  @override
  String get accountSettingsInviteCodesTitle => 'Codes d\'invitation';

  @override
  String get accountSettingsInviteCodesDescription =>
      'Codes d\'invitation disponibles';

  @override
  String get accountSettingsLinksTitle => 'Liens';

  @override
  String get accountSettingsLinksDescription => 'Vos liens sociaux personnels';

  @override
  String get profileEditAccountTitle => 'Compte';

  @override
  String get profileEditAccountDescription => 'Gérer votre compte';

  @override
  String get reviewTypeUserTitle => 'Généré par les utilisateurs';

  @override
  String get reviewTypeUserDescription =>
      'Demandes soumises par les utilisateurs';

  @override
  String get reviewTypeSystemTitle => 'Généré par IA';

  @override
  String get reviewTypeSystemDescription =>
      'Demandes quotidiennes générées par IA';

  @override
  String get appName => 'Venyu';

  @override
  String get appTagline => 'make the net work';

  @override
  String get navMatches => 'Matches';

  @override
  String get navCards => 'Mes demandes';

  @override
  String get navNotifications => 'Updates';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionSend => 'Envoyer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionNext => 'Suivant';

  @override
  String get actionSkip => 'Pas maintenant';

  @override
  String get buttonSkip => 'Passer';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionInterested => 'Présentez-moi';

  @override
  String get successSaved => 'Enregistré avec succès';

  @override
  String get dialogRemoveAvatarTitle => 'Supprimer l\'avatar';

  @override
  String get dialogRemoveAvatarMessage =>
      'Êtes-vous sûr de vouloir supprimer votre avatar ?';

  @override
  String get dialogRemoveButton => 'Supprimer';

  @override
  String get dialogOkButton => 'OK';

  @override
  String get dialogErrorTitle => 'Erreur';

  @override
  String get dialogLoadingMessage => 'Chargement...';

  @override
  String get validationEmailRequired => 'L\'e-mail est requis';

  @override
  String get validationEmailInvalid =>
      'Veuillez entrer une adresse e-mail valide';

  @override
  String get validationUrlInvalid =>
      'Veuillez entrer une URL valide (ex: exemple.com)';

  @override
  String get validationLinkedInUrlInvalid =>
      'Veuillez entrer une URL de profil LinkedIn valide\n(ex: https://www.linkedin.com/in/votrepresom)';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName est requis';
  }

  @override
  String get validationFieldRequiredDefault => 'Ce champ est requis';

  @override
  String validationMinLength(String fieldName, int minLength) {
    return '$fieldName doit contenir au moins $minLength caractères';
  }

  @override
  String validationMaxLength(String fieldName, int maxLength) {
    return '$fieldName ne peut pas dépasser $maxLength caractères';
  }

  @override
  String get validationOtpRequired => 'Le code de vérification est requis';

  @override
  String get validationOtpLength =>
      'Le code de vérification doit contenir 6 chiffres';

  @override
  String get validationOtpNumeric =>
      'Le code de vérification ne peut contenir que des chiffres';

  @override
  String get imageSourceCameraTitle => 'Caméra';

  @override
  String get imageSourceCameraDescription => 'Prendre une nouvelle photo';

  @override
  String get imageSourcePhotoLibraryTitle => 'Bibliothèque';

  @override
  String get imageSourcePhotoLibraryDescription =>
      'Choisir depuis la bibliothèque';

  @override
  String get pagesProfileEditTitle => 'Édition du profil';

  @override
  String get pagesProfileEditDescription =>
      'Modifier les informations du profil';

  @override
  String get pagesLocationTitle => 'Localisation';

  @override
  String get pagesLocationDescription => 'Paramètres de localisation';

  @override
  String get promptSectionCardTitle => 'Statut';

  @override
  String get promptSectionCardDescription =>
      'Voir les détails de votre demande';

  @override
  String get promptSectionStatsTitle => 'Stats';

  @override
  String get promptSectionStatsDescription => 'Performance et analyses';

  @override
  String get promptSectionIntroTitle => 'Intros';

  @override
  String get promptSectionIntroDescription => 'Matches et introductions';

  @override
  String get promptStatusDraftDisplay => 'Brouillon';

  @override
  String get promptStatusDraftInfo =>
      'Votre demande est sauvegardée comme brouillon. Complétez-la et soumettez-la pour commencer à recevoir des matches.';

  @override
  String get promptStatusPendingReviewDisplay => 'En attente de validation';

  @override
  String get promptStatusPendingReviewInfo =>
      'Votre demande est en cours d\'examen par notre équipe. Cela prend généralement 12-24 heures pour vérifier si le contenu respecte les directives de la communauté.';

  @override
  String get promptStatusPendingTranslationDisplay =>
      'En attente de traduction';

  @override
  String get promptStatusPendingTranslationInfo =>
      'Votre demande est en cours de traduction vers d\'autres langues.';

  @override
  String get promptStatusApprovedDisplay => 'Approuvé';

  @override
  String get promptStatusApprovedInfo =>
      'Votre demande a été approuvée et est active. Vous pouvez recevoir des matches.';

  @override
  String get promptStatusRejectedDisplay => 'Rejeté';

  @override
  String get promptStatusRejectedInfo =>
      'Votre demande a été rejetée car elle ne respecte pas les directives de la communauté. Veuillez la modifier et la soumettre à nouveau.';

  @override
  String get promptStatusArchivedDisplay => 'Archivé';

  @override
  String get promptStatusArchivedInfo =>
      'Votre demande a été archivée et n\'est plus visible par les autres utilisateurs.';

  @override
  String get venueTypeEventDisplayName => 'Événement';

  @override
  String get venueTypeEventDescription =>
      'Lieu temporaire pour événements, conférences ou rencontres';

  @override
  String get venueTypeOrganisationDisplayName => 'Communauté';

  @override
  String get venueTypeOrganisationDescription =>
      'Lieu permanent pour entreprises ou organisations';

  @override
  String get emptyStateNotificationsTitle => 'Tout est à jour !';

  @override
  String get emptyStateNotificationsDescription =>
      'Quand quelque chose d\'important se passe, nous vous informerons ici';

  @override
  String get emptyStateReviewsTitle => 'Tout est à jour !';

  @override
  String get emptyStateReviewsDescription =>
      'Quand des demandes sont soumises pour examen, elles apparaîtront ici';

  @override
  String get emptyStateMatchesTitle => 'En attente de votre premier match !';

  @override
  String get emptyStateMatchesDescription =>
      'Une fois que vous aurez un match, il apparaîtra ici. Posez votre première question pour être matché plus rapidement.';

  @override
  String get emptyStatePromptsTitle => 'Prêt à être matché ?';

  @override
  String get emptyStatePromptsDescription =>
      'Les demandes sont matchées avec les offres d\'autres entrepreneurs. Posez la vôtre pour découvrir qui peut vous aider.';

  @override
  String get emptyStateNotificationSettingsTitle =>
      'Aucun paramètre disponible';

  @override
  String get emptyStateNotificationSettingsDescription =>
      'Les paramètres de notification apparaîtront ici une fois configurés.';

  @override
  String get notificationSettingsTitle => 'Paramètres de notification';

  @override
  String get notificationSettingsPushSection => 'Notifications push';

  @override
  String get notificationSettingsEmailSection => 'Notifications email';

  @override
  String get notificationsDisabledWarning =>
      'Les notifications push sont désactivées. Appuyez ici pour les activer dans les paramètres de votre appareil.';

  @override
  String get authGoogleRetryingMessage => 'Veuillez patienter...';

  @override
  String get redeemInviteTitle => 'Entrez votre code d\'invitation';

  @override
  String get redeemInviteSubtitle =>
      'Veuillez entrer le code d\'invitation à 8 caractères que vous avez reçu pour continuer.';

  @override
  String get redeemInviteContinue => 'Continuer';

  @override
  String get redeemInvitePlaceholder => 'Entrer le code d\'invitation';

  @override
  String get waitlistFinishTitle => 'Vous êtes sur la liste !';

  @override
  String get waitlistFinishDescription =>
      'Merci de rejoindre la liste d\'attente Venyu. Nous vous informerons dès que de nouvelles places se libèrent.';

  @override
  String get waitlistFinishButton => 'Terminé';

  @override
  String get waitlistTitle => 'Rejoindre la liste d\'attente';

  @override
  String get waitlistDescription =>
      'Venyu est sur invitation uniquement. Rejoignez la liste d\'attente et soyez invité lorsque de nouvelles places s\'ouvrent.';

  @override
  String get waitlistNameHint => 'Votre nom complet';

  @override
  String get waitlistCompanyHint => 'Le nom de votre entreprise';

  @override
  String get waitlistRoleHint => 'Votre rôle / titre';

  @override
  String get waitlistEmailHint => 'Votre adresse e-mail';

  @override
  String get waitlistButton => 'Rejoindre la liste d\'attente';

  @override
  String get waitlistErrorDuplicate =>
      'Cet e-mail est déjà sur la liste d\'attente';

  @override
  String get waitlistErrorFailed =>
      'Échec d\'inscription à la liste d\'attente. Veuillez réessayer.';

  @override
  String get waitlistSuccessMessage =>
      'Vous avez été ajouté à la liste d\'attente ! Nous vous préviendrons quand nous serons prêts.';

  @override
  String get inviteScreeningTitle => 'Bienvenue sur venyu 🤝';

  @override
  String get inviteScreeningDescription =>
      'La communauté sur invitation pour entrepreneurs où les bons matches mènent à de vraies introductions.';

  @override
  String get inviteScreeningHasCode => 'J\'ai un code d\'invitation';

  @override
  String get inviteScreeningNoCode => 'Je n\'ai pas de code d\'invitation';

  @override
  String onboardWelcome(String name) {
    return 'Bienvenue $name 👋';
  }

  @override
  String get onboardStart => 'Démarrer';

  @override
  String get loginLegalText =>
      'En vous connectant, vous acceptez nos Conditions d\'utilisation.';

  @override
  String get joinVenueTitle => 'Rejoindre le lieu';

  @override
  String get joinVenueSubtitle =>
      'Entrez le code d\'invitation à 8 caractères pour rejoindre.';

  @override
  String get joinVenueButton => 'Rejoindre';

  @override
  String get joinVenuePlaceholder => 'Entrer le code du lieu';

  @override
  String get matchItemReachOut => 'Présentez-vous';

  @override
  String get matchDetailLoading => 'Chargement...';

  @override
  String get matchDetailTitleIntroduction => 'Introduction';

  @override
  String get matchDetailTitleMatch => 'Match';

  @override
  String get matchDetailMenuReport => 'Signaler';

  @override
  String get matchDetailMenuRemove => 'Supprimer';

  @override
  String get matchDetailMenuBlock => 'Bloquer';

  @override
  String get matchDetailReportSuccess => 'Profil signalé avec succès';

  @override
  String get matchDetailBlockTitle => 'Bloquer l\'utilisateur ?';

  @override
  String get matchDetailBlockMessage =>
      'Bloquer cet utilisateur supprimera le match et empêchera tout futur matching. Cette action ne peut pas être annulée.';

  @override
  String get matchDetailBlockButton => 'Bloquer';

  @override
  String get matchDetailBlockSuccess => 'Utilisateur bloqué avec succès';

  @override
  String get matchDetailRemoveTitle => 'Supprimer l\'introduction ?';

  @override
  String matchDetailRemoveMessage(String type) {
    return 'Êtes-vous sûr de vouloir supprimer cette $type ? Cette action ne peut pas être annulée.';
  }

  @override
  String get matchDetailRemoveButton => 'Supprimer';

  @override
  String get matchDetailRemoveSuccessIntroduction =>
      'Introduction supprimée avec succès';

  @override
  String get matchDetailRemoveSuccessMatch => 'Match supprimé avec succès';

  @override
  String get matchDetailTypeIntroduction => 'introduction';

  @override
  String get matchDetailTypeMatch => 'match';

  @override
  String get matchReachOutTitle => 'Introduction';

  @override
  String matchReachOutSubtitle(String name) {
    return 'Présentez-vous à $name';
  }

  @override
  String get matchReachOutGreeting => 'Bonjour';

  @override
  String get matchReachOutPromptContextSingular =>
      'La demande qui nous a matché:';

  @override
  String get matchReachOutPromptContextPlural =>
      'Les demandes qui nous ont matché:';

  @override
  String get matchReachOutMessagePlaceholder => 'Écrivez votre message ici...';

  @override
  String get matchReachOutInfoMessage =>
      'Votre message est envoyé directement par e-mail et n\'est pas stocké par Venyu. Vous pouvez envoyer une introduction par match, donc veuillez rester clair, respectueux et professionnel.';

  @override
  String get matchReachOutContactsSubtitle =>
      'Partagez des liens supplémentaires (optionnel)';

  @override
  String get matchReachOutPreviewTitle => 'Aperçu';

  @override
  String get matchReachOutPreviewFromLabel => 'De';

  @override
  String matchReachOutPreviewFromValue(String name) {
    return '$name (via Venyu)';
  }

  @override
  String get matchReachOutPreviewReplyToLabel => 'Répondre à';

  @override
  String get matchReachOutPreviewSubjectLabel => 'Objet';

  @override
  String matchReachOutPreviewSubject(String firstName) {
    return 'Introduction de $firstName';
  }

  @override
  String get matchReachOutPreviewPS =>
      'PS: N\'hésitez pas à répondre directement à cet e-mail.';

  @override
  String get matchReachOutFinishTitle => 'Introduction envoyée!';

  @override
  String matchReachOutFinishDescription(String name) {
    return 'Votre message a été envoyé à $name. Il le recevra directement dans sa boîte de réception.';
  }

  @override
  String get matchReachOutFinishDoneButton => 'Terminé';

  @override
  String get matchReachOutSuccessMessage => 'Message envoyé avec succès';

  @override
  String get matchReachOutErrorMessage => 'Échec de l\'envoi du message';

  @override
  String get matchStagesTitle => 'Étape de connexion';

  @override
  String get matchStagesDescription =>
      'Suivez la progression de cette match. Vous et votre match pouvez tous deux mettre à jour cette étape.';

  @override
  String get matchStagesSaveButton => 'Enregistrer';

  @override
  String get matchStagesSavingButton => 'Enregistrement...';

  @override
  String get matchStagesLoadErrorTitle => 'Erreur de chargement des étapes';

  @override
  String get matchStagesRetryButton => 'Réessayer';

  @override
  String get matchStagesNoStagesMessage => 'Aucune étape disponible';

  @override
  String get matchStagesSaveErrorTitle =>
      'Erreur d\'enregistrement de l\'étape';

  @override
  String matchStagesSaveErrorMessage(String error) {
    return 'Échec de l\'enregistrement de l\'étape: $error';
  }

  @override
  String get matchStagesErrorDialogOk => 'OK';

  @override
  String matchDetailFirstCallWarning(String firstName) {
    return 'Vous seul pouvez voir ce match. Une fois que vous vous présentez, $firstName vous verra aussi.';
  }

  @override
  String get matchDetailErrorLoad => 'Échec du chargement des détails du match';

  @override
  String get matchDetailRetry => 'Réessayer';

  @override
  String get matchDetailNotFound => 'Match non trouvé';

  @override
  String get matchDetailLimitTitle => 'Limite mensuelle atteinte';

  @override
  String get matchDetailLimitMessage =>
      'Vous avez atteint votre limite de 3 intros par mois. Passez à Venyu Pro pour des introductions illimitées.';

  @override
  String get matchDetailLimitButton => 'Passer à Pro';

  @override
  String get matchDetailFirstCallTitle => 'First call activé';

  @override
  String matchDetailMatchingCards(int count, String cards) {
    return '$count $cards matchés';
  }

  @override
  String get matchDetailCard => 'demande';

  @override
  String get matchDetailCards => 'demandes';

  @override
  String matchDetailSharedIntros(int count, String intros) {
    return '$count $intros partagées';
  }

  @override
  String get matchDetailIntroduction => 'match';

  @override
  String get matchDetailIntroductions => 'matches';

  @override
  String matchDetailSharedVenues(int count, String venues) {
    return '$count $venues partagés';
  }

  @override
  String get matchDetailVenue => 'lieu';

  @override
  String get matchDetailVenues => 'lieux';

  @override
  String matchDetailCompanyFacts(int count, String areas) {
    return 'Professionnel : $count $areas partagés';
  }

  @override
  String matchDetailPersonalInterests(int count, String areas) {
    return 'Personnel : $count $areas partagés';
  }

  @override
  String get matchDetailArea => 'domaine';

  @override
  String get matchDetailAreas => 'domaines';

  @override
  String matchDetailWhyMatch(String name) {
    return 'Pourquoi vous et $name êtes en match';
  }

  @override
  String get matchDetailScoreBreakdown => 'Score de matching';

  @override
  String get matchDetailUnlockTitle => 'Débloquer les intérêts mutuels';

  @override
  String matchDetailUnlockMessage(String name) {
    return 'Voyez ce que vous partagez sur le plan personnel avec $name';
  }

  @override
  String get matchDetailUnlockButton => 'Passer à Pro maintenant';

  @override
  String matchDetailInterestedInfoMessage(String name) {
    return 'Souhaitez-vous une introduction à $name ?';
  }

  @override
  String get matchDetailEmailSubject => 'Nous sommes connectés sur Venyu !';

  @override
  String get matchOverviewYou => 'Vous';

  @override
  String get profileAvatarMenuCamera => 'Caméra';

  @override
  String get profileAvatarMenuGallery => 'Galerie';

  @override
  String get profileAvatarMenuView => 'Voir';

  @override
  String get profileAvatarMenuRemove => 'Supprimer';

  @override
  String profileAvatarErrorAction(String error) {
    return 'Action sur l\'avatar échouée : $error';
  }

  @override
  String get profileAvatarErrorUpload =>
      'Échec du téléchargement de la photo. Veuillez réessayer.';

  @override
  String get profileAvatarErrorRemove =>
      'Échec de la suppression de la photo. Veuillez réessayer.';

  @override
  String get profileAvatarErrorTitle => 'Erreur';

  @override
  String get profileAvatarErrorButton => 'OK';

  @override
  String get profileAvatarCameraPermissionDenied =>
      'L\'accès à la caméra est désactivé. Veuillez l\'activer dans les paramètres de votre appareil pour prendre des photos.';

  @override
  String get profileAvatarGalleryPermissionDenied =>
      'L\'accès à la bibliothèque de photos est désactivé. Veuillez l\'activer dans les paramètres de votre appareil pour sélectionner des photos.';

  @override
  String get profileInfoAddCompanyInfo => 'Ajouter les infos entreprise';

  @override
  String get venuesErrorLoading => 'Erreur lors du chargement des lieux';

  @override
  String get venuesRetry => 'Réessayer';

  @override
  String get venuesEmptyTitle => 'Vos lieux apparaîtront ici';

  @override
  String get venuesEmptyDescription =>
      'Vous avez un code d\'invitation ? Utilisez-le pour rejoindre ce lieu et commencer à obtenir de vraies introductions dans la communauté.';

  @override
  String get venuesEmptyAction => 'Rejoindre un lieu';

  @override
  String invitesAvailableDescription(int count, String codes) {
    return 'Vous avez $count $codes d\'invitation prêts à partager. Chacun débloque Venyu pour un nouvel entrepreneur';
  }

  @override
  String get invitesCode => 'code';

  @override
  String get invitesCodes => 'codes';

  @override
  String get invitesAllSharedDescription =>
      'Tous vos codes d\'invitation ont été partagés. Merci d\'aider à faire grandir la communauté Venyu.';

  @override
  String get invitesGenerateMore => 'Générer plus de codes';

  @override
  String get invitesEmptyTitle => 'Pas encore de codes d\'invitation';

  @override
  String get invitesEmptyDescription =>
      'Vos codes d\'invitation apparaîtront ici. Vous pouvez les partager avec vos amis pour les inviter sur Venyu.';

  @override
  String get invitesEmptyAction => 'Générer des codes';

  @override
  String get invitesSubtitleAvailable => 'Codes disponibles';

  @override
  String get invitesSubtitleShared => 'Codes partagés';

  @override
  String get invitesSubtitleRedeemed => 'Codes utilisés';

  @override
  String get invitesMenuShare => 'Partager';

  @override
  String get invitesMenuCopy => 'Copier';

  @override
  String get invitesMenuMarkShared => 'Marquer comme partagé';

  @override
  String get invitesShareSubject => 'Votre invitation personnelle Venyu';

  @override
  String invitesShareText(String code) {
    return 'Rejoignez-moi sur Venyu !\n\nLa communauté sur invitation pour entrepreneurs où les bons matches mènent à de vraies introductions.\n\nTéléchargez l\'app sur 👉 www.getvenyu.com\n\n🔑 Votre code d\'invitation :\n\n$code';
  }

  @override
  String get invitesCopiedToast =>
      'Code d\'invitation copié dans le presse-papiers';

  @override
  String get invitesMarkedSentToast => 'Code d\'invitation marqué comme envoyé';

  @override
  String get invitesMarkedSentError =>
      'Échec du marquage de l\'invitation comme envoyée';

  @override
  String get invitesGenerateDialogTitle => 'Générer plus de codes';

  @override
  String get invitesGenerateDialogMessage =>
      'Générer 5 nouveaux codes d\'invitation ? Ils expireront dans 1 an.';

  @override
  String get invitesGenerateDialogConfirm => 'Générer';

  @override
  String get invitesGenerateDialogCancel => 'Annuler';

  @override
  String get invitesGenerateSuccessToast =>
      '5 nouveaux codes d\'invitation générés avec succès';

  @override
  String get invitesGenerateErrorToast =>
      'Échec de la génération des codes d\'invitation';

  @override
  String get companySectionEmptyTagGroups =>
      'Aucun groupe de tags entreprise disponible';

  @override
  String get personalSectionEmptyTagGroups =>
      'Aucun groupe de tags personnel disponible';

  @override
  String get contactSectionEmptyContacts =>
      'Aucune option de contact disponible';

  @override
  String get aboutMeSectionEmptyTitle => 'C\'est moi';

  @override
  String get aboutMeSectionEmptyDescription =>
      'Ajoutez quelques offres décrivant comment vous pouvez aider les autres. Elles sont privées et utilisées uniquement pour le matching avec les demandes des autres.';

  @override
  String get aboutMeSectionEmptyAction => 'Ajouter une offre';

  @override
  String get profileSectionAboutMeTitle => 'Mes offres';

  @override
  String get profileSectionAboutMeDescription =>
      'Offres sur qui vous êtes et comment vous aidez les autres. Elles améliorent vos matches.';

  @override
  String get profileSectionPersonalTitle => 'Personnel';

  @override
  String get profileSectionPersonalDescription => 'Informations personnelles';

  @override
  String get profileSectionCompanyTitle => 'Professionnel';

  @override
  String get profileSectionCompanyDescription =>
      'Informations professionnelles';

  @override
  String get profileSectionVenuesTitle => 'Lieux';

  @override
  String get profileSectionVenuesDescription => 'Événements et organisations';

  @override
  String get profileSectionInvitesTitle => 'Codes';

  @override
  String get profileSectionInvitesDescription => 'Invitations et codes';

  @override
  String get profileSectionContactTitle => 'Liens';

  @override
  String get profileSectionContactDescription => 'Vos liens de contact';

  @override
  String get profileSectionReviewsTitle => 'Avis';

  @override
  String get profileSectionReviewsDescription => 'Avis et retours utilisateurs';

  @override
  String profilePersonalCompletenessMessage(int percentage) {
    return 'Votre profil personnel est $percentage% complet. Complétez-le pour obtenir des matches meilleurs et plus pertinents.';
  }

  @override
  String profileCompanyCompletenessMessage(int percentage) {
    return 'Votre profil professionnel est $percentage% complet. Complétez-le pour obtenir des matches meilleurs et plus pertinents.';
  }

  @override
  String get profileContactPrivacyMessage =>
      'Vos coordonnées ne sont jamais partagées automatiquement, même lors des introductions. Vous choisissez ce que vous partagez lorsque vous contactez quelqu\'un.';

  @override
  String get editAccountTitle => 'Paramètres';

  @override
  String get editAccountProfileSectionLabel => 'Profil';

  @override
  String get editAccountSettingsSectionLabel => 'Paramètres';

  @override
  String get editAccountFeedbackSectionLabel => 'Retour';

  @override
  String get editAccountSupportLegalSectionLabel => 'Support & Légal';

  @override
  String get editAccountReviewsSectionLabel => 'Avis';

  @override
  String get editAccountSectionLabel => 'Compte';

  @override
  String get editAccountDataExportTitle => 'Export de données';

  @override
  String get editAccountDataExportDescription =>
      'Vous pouvez demander une copie de toutes vos données personnelles. Cela inclut vos informations de profil, demandes, offres, matches et historique d\'activité. L\'export sera envoyé à votre adresse e-mail enregistrée.';

  @override
  String get editAccountExportDataButton => 'Exporter toutes vos données';

  @override
  String get editAccountDeleteTitle => 'Supprimer le compte';

  @override
  String get editAccountDeleteDescription =>
      'La suppression de votre compte est définitive. Toutes vos données, y compris votre profil, demandes, offres et matches seront supprimés.';

  @override
  String get editAccountDeleteButton => 'Supprimer le compte';

  @override
  String get editAccountLogoutButton => 'Déconnexion';

  @override
  String get editAccountExportDialogTitle => 'Exporter les données';

  @override
  String get editAccountExportDialogMessage =>
      'Vous recevrez un lien d\'export par e-mail dès que vos données seront prêtes.';

  @override
  String get editAccountExportDialogCancel => 'Annuler';

  @override
  String get editAccountExportDialogConfirm => 'Exporter';

  @override
  String get editAccountExportSuccessMessage =>
      'Un e-mail sera envoyé une fois l\'export prêt';

  @override
  String get editAccountExportErrorMessage =>
      'Quelque chose s\'est mal passé. Veuillez réessayer plus tard.';

  @override
  String get editAccountDeleteDialogTitle => 'Supprimer le compte';

  @override
  String get editAccountDeleteDialogMessage =>
      'Votre compte et toutes ses données seront définitivement supprimés immédiatement. Cette action ne peut pas être annulée. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get editAccountDeleteDialogCancel => 'Annuler';

  @override
  String get editAccountDeleteDialogConfirm => 'Supprimer';

  @override
  String get editAccountDeleteErrorMessage =>
      'Quelque chose s\'est mal passé. Veuillez réessayer plus tard.';

  @override
  String get editAccountLogoutDialogTitle => 'Déconnexion';

  @override
  String get editAccountLogoutDialogMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get editAccountLogoutDialogCancel => 'Annuler';

  @override
  String get editAccountLogoutDialogConfirm => 'Déconnexion';

  @override
  String get editAccountLogoutErrorMessage =>
      'Quelque chose s\'est mal passé. Veuillez réessayer plus tard.';

  @override
  String get editAccountSettingsUpdateError =>
      'Impossible de mettre à jour le paramètre. Veuillez réessayer.';

  @override
  String get editTagGroupSavingButton => 'Enregistrement...';

  @override
  String get editTagGroupNextButton => 'Suivant';

  @override
  String get editTagGroupSaveButton => 'Enregistrer';

  @override
  String get editTagGroupLoadErrorTitle => 'Échec du chargement des tags';

  @override
  String get editTagGroupRetryButton => 'Réessayer';

  @override
  String get editTagGroupNoTagsMessage => 'Aucun tag disponible';

  @override
  String get editTagGroupSaveErrorTitle => 'Erreur';

  @override
  String editTagGroupSaveErrorMessage(String error) {
    return 'Échec de l\'enregistrement des modifications : $error';
  }

  @override
  String get editTagGroupErrorDialogOk => 'OK';

  @override
  String get editNotificationsTitle => 'Notifications';

  @override
  String get editNotificationsSavedMessage => 'Notifications enregistrées';

  @override
  String get editNotificationsSaveErrorMessage =>
      'Échec de l\'enregistrement des notifications';

  @override
  String get editNotificationsEnableTitle =>
      'Activer les notifications pour...';

  @override
  String get editNotificationsNotNowButton => 'Pas maintenant';

  @override
  String get editNotificationsEnableButton => 'Activer';

  @override
  String get editNotificationsPermissionDialogTitle =>
      'Autorisation de notification requise';

  @override
  String get editNotificationsPermissionDialogMessage =>
      'L\'autorisation de notification a été refusée. Veuillez l\'activer dans les paramètres de votre appareil pour recevoir les Updates.';

  @override
  String get editNotificationsPermissionDialogNotNow => 'Pas maintenant';

  @override
  String get editNotificationsPermissionDialogOpenSettings =>
      'Ouvrir les paramètres';

  @override
  String get editNotificationsLaterMessage =>
      'Vous pouvez activer les notifications plus tard dans les paramètres';

  @override
  String get editNotificationsEnableErrorMessage =>
      'Échec de l\'activation des notifications. Vous pouvez réessayer dans les paramètres.';

  @override
  String get editLocationTitle => 'Localisation';

  @override
  String get editLocationSavedMessage => 'Localisation enregistrée';

  @override
  String get editLocationSaveErrorMessage =>
      'Échec de l\'enregistrement de la localisation';

  @override
  String get editLocationEnableTitle => 'Activer la localisation pour';

  @override
  String get editLocationNotNowButton => 'Pas maintenant';

  @override
  String get editLocationEnableButton => 'Activer';

  @override
  String get editLocationServicesDisabledMessage =>
      'Les services de localisation sont désactivés. Veuillez les activer dans les paramètres.';

  @override
  String get editLocationPermissionDeniedMessage =>
      'Autorisation de localisation refusée. Vous pouvez l\'activer plus tard dans les paramètres.';

  @override
  String get editLocationPermissionDialogTitle =>
      'Autorisation de localisation requise';

  @override
  String get editLocationPermissionDialogMessage =>
      'L\'autorisation de localisation a été refusée de manière permanente. Veuillez l\'activer dans les paramètres de votre appareil pour utiliser cette fonctionnalité.';

  @override
  String get editLocationPermissionDialogNotNow => 'Pas maintenant';

  @override
  String get editLocationPermissionDialogOpenSettings =>
      'Ouvrir les paramètres';

  @override
  String get editLocationCoordinatesErrorMessage =>
      'Impossible d\'obtenir les coordonnées de localisation';

  @override
  String get editLocationEnableErrorMessage =>
      'Échec de l\'activation de la localisation. Veuillez réessayer.';

  @override
  String get editLocationUnavailableMessage =>
      'Impossible de récupérer votre localisation. Vous pouvez l\'ajouter plus tard dans les paramètres.';

  @override
  String get editLocationApproximateInfo =>
      'Utilisation de la localisation approximative. Activez \'Localisation précise\' dans les paramètres pour un meilleur matching.';

  @override
  String get editNameTitle => 'Votre nom';

  @override
  String get editNameSuccessMessage => 'Modifications enregistrées avec succès';

  @override
  String get editNameErrorMessage =>
      'Échec de la mise à jour, veuillez réessayer';

  @override
  String get editNameLinkedInFormatError =>
      'Le format de l\'URL LinkedIn est invalide';

  @override
  String get editNameLinkedInMismatchDialogTitle =>
      'Nous n\'avons pas trouvé votre nom dans votre URL LinkedIn';

  @override
  String get editNameLinkedInMismatchDialogMessage =>
      'Votre URL LinkedIn ne semble pas contenir votre prénom et nom. Vous pouvez continuer ou vérifier votre URL.';

  @override
  String get editNameLinkedInMismatchDialogCheckUrl => 'Vérifier l\'URL';

  @override
  String get editNameLinkedInMismatchDialogContinue => 'Continuer quand même';

  @override
  String get editNameFirstNameLabel => 'PRÉNOM';

  @override
  String get editNameFirstNameHint => 'Prénom';

  @override
  String get editNameLastNameLabel => 'NOM';

  @override
  String get editNameLastNameHint => 'Nom';

  @override
  String get editNameLinkedInLabel => 'URL LINKEDIN';

  @override
  String get editNameLinkedInHint => 'linkedin.com/in/votre-nom';

  @override
  String get editNameLinkedInInfoMessage =>
      'Nous ne partagerons votre profil LinkedIn que dans l\'e-mail d\'introduction une fois qu\'il y a un intérêt mutuel. Il n\'est jamais partagé lors du premier match.';

  @override
  String get editNameLinkedInMobileTip =>
      'Sur l\'app mobile LinkedIn : Allez sur votre profil → appuyez sur les trois points (•••) → sélectionnez \'Partager le profil\' → appuyez sur \'Copier le lien\'';

  @override
  String get editEmailTitle => 'Adresse e-mail';

  @override
  String get editEmailSendCodeButton => 'Envoyer le code de vérification';

  @override
  String get editEmailAddressLabel => 'ADRESSE E-MAIL';

  @override
  String editEmailCodeSentMessage(String email) {
    return 'Un code de vérification a été envoyé à $email. Veuillez aussi vérifier le dossier spam.';
  }

  @override
  String get editEmailSuccessMessage => 'Adresse e-mail de contact mise à jour';

  @override
  String get editEmailSendCodeErrorMessage =>
      'Échec de l\'envoi du code de confirmation, veuillez réessayer';

  @override
  String get editEmailVerifyCodeErrorMessage =>
      'Échec de la vérification du code, veuillez réessayer';

  @override
  String get editEmailVerifyCodeButton => 'Vérifier le code';

  @override
  String get editEmailAddressHint => 'Une adresse e-mail valide';

  @override
  String get editEmailInfoMessage =>
      'Nous utilisons votre e-mail uniquement pour la vérification du compte, les notifications de match, les mises à jour de vos demandes et les messages de service.';

  @override
  String get editEmailNewsletterLabel => 'S\'ABONNER AUX UPDATES VENYU';

  @override
  String get editEmailVerificationCodeLabel => 'Code de vérification';

  @override
  String get editEmailVerificationCodeHint => 'Entrez le code à 6 chiffres';

  @override
  String get editEmailOtpInfoMessage =>
      'Veuillez vérifier votre dossier spam si vous ne voyez pas le code de vérification.';

  @override
  String get editContactSettingSavedMessage => 'Coordonnées enregistrées';

  @override
  String get editContactSettingErrorMessage =>
      'Échec de la mise à jour des coordonnées, veuillez réessayer';

  @override
  String get editContactSettingValueHint => 'Entrez la valeur';

  @override
  String get editCityTitle => 'Ville';

  @override
  String get editCitySavedMessage => 'Ville enregistrée';

  @override
  String get editCityErrorMessage =>
      'Échec de la mise à jour de la ville, veuillez réessayer';

  @override
  String get editCityCityLabel => 'VILLE';

  @override
  String get editCityCityHint => 'Ville';

  @override
  String get editCityInfoMessage =>
      'Votre ville n\'est partagée qu\'avec les personnes avec qui vous matchez et n\'est pas publiquement visible. Cela facilite les rencontres en personne une fois qu\'une connexion est établie.';

  @override
  String get editCompanyNameTitle => 'Nom de l\'entreprise';

  @override
  String get editCompanyNameSuccessMessage =>
      'Modifications des infos de l\'entreprise enregistrées';

  @override
  String get editCompanyNameErrorMessage =>
      'Échec de la mise à jour des infos de l\'entreprise, veuillez réessayer';

  @override
  String get editCompanyNameCompanyLabel => 'NOM DE L\'ENTREPRISE';

  @override
  String get editCompanyNameCompanyHint => 'Nom de l\'entreprise';

  @override
  String get editCompanyNameWebsiteLabel => 'SITE WEB';

  @override
  String get editCompanyNameWebsiteHint => 'Site web';

  @override
  String get editCompanyNameInfoMessage =>
      'Votre nom d\'entreprise et site web ne sont partagés qu\'avec les personnes avec qui vous êtes présenté, pas avec les matches. Ils rendent les introductions plus significatives et pertinentes.';

  @override
  String get editAvatarTitle => 'Photo de profil';

  @override
  String get editAvatarSuccessMessage => 'Photo de profil enregistrée';

  @override
  String get editAvatarErrorMessage =>
      'Échec de l\'enregistrement de la photo de profil';

  @override
  String get editAvatarRemoveButton => 'Supprimer';

  @override
  String get editAvatarAddTitle => 'Ajouter une photo de profil';

  @override
  String get editAvatarInfoMessage =>
      'Votre photo est souvent votre première impression. Choisissez un portrait clair et amical qui vous ressemble.';

  @override
  String get editAvatarCameraButton => 'Caméra';

  @override
  String get editAvatarGalleryButton => 'Galerie';

  @override
  String get editAvatarNextButton => 'Suivant';

  @override
  String get editBioTitle => 'À propos de vous';

  @override
  String get editBioSuccessMessage => 'Bio du profil enregistrée';

  @override
  String get editBioErrorMessage =>
      'Échec de la mise à jour de la bio du profil, veuillez réessayer';

  @override
  String get editBioInfoMessage =>
      'Votre bio est votre introduction professionnelle. Partagez ce que vous faites, ce qui vous intéresse et comment vous aimez travailler avec les autres. Une bio claire aide les gens à comprendre qui se cache derrière le match.';

  @override
  String get editBioPlaceholder => 'Écrivez votre bio ici...';

  @override
  String get promptCardCreatedLabel => 'Créé';

  @override
  String get promptCardReviewedLabel => 'Révisé';

  @override
  String get promptCardStatusLabel => 'Statut';

  @override
  String get promptCardUpgradeTitle => 'Étendez la visibilité de votre demande';

  @override
  String get promptCardUpgradeSubtitle =>
      'Passez à Venyu Pro pour garder votre demande en ligne pendant 10 jours au lieu de 3.';

  @override
  String get promptCardUpgradeButton => 'Passer à Pro';

  @override
  String get promptIntroErrorMessage => 'Échec du chargement des matches';

  @override
  String get promptIntroRetryButton => 'Réessayer';

  @override
  String get promptIntroEmptyTitle => 'Pas encore de matches';

  @override
  String get promptIntroEmptyDescription =>
      'Quand des personnes matchent avec votre demande, leurs profils apparaîtront ici.';

  @override
  String get promptStatsTitle => 'Stats bientôt disponibles';

  @override
  String get promptStatsDescription =>
      'Suivez les performances de votre demande, les vues et les métriques d\'engagement.';

  @override
  String interactionTypeSelectionTitleFromPrompts(String name) {
    return 'Merci$name';
  }

  @override
  String get interactionTypeSelectionTitleDefault => 'Make the net work';

  @override
  String get interactionTypeSelectionSubtitleFromPrompts =>
      'Maintenant, faisons travailler le réseau pour vous';

  @override
  String get interactionTypeSelectionSubtitleDefault =>
      'Écrivez votre propre offre ou demande';

  @override
  String get interactionTypeSelectionDisclaimerText =>
      'Les demandes sont révisées avant d\'être publiées';

  @override
  String get interactionTypeSelectionDisclaimerBeforeLinkText =>
      'Les demandes sont révisées selon nos ';

  @override
  String get interactionTypeSelectionDisclaimerLinkText =>
      'directives de la communauté';

  @override
  String get interactionTypeSelectionShowGuidelines =>
      'Afficher les directives de la communauté';

  @override
  String get interactionTypeSelectionHideGuidelines =>
      'Masquer les directives de la communauté';

  @override
  String get interactionTypeSelectionNotNowButton => 'Pas maintenant';

  @override
  String get interactionTypeSelectionPrivatePromptsInfo =>
      'Une offre décrit comment vous pouvez aider les autres. Gardez-le court mais clair, plus c\'est spécifique, mieux nous pourrons vous matcher avec les bonnes demandes.';

  @override
  String get promptDetailTitle => 'Détail';

  @override
  String get promptDetailStatusTitle => 'Statut';

  @override
  String get promptDetailHowYouMatchTitle => 'Contrôler le matching';

  @override
  String get promptDetailHowYouMatchDescription =>
      'Mettez en pause le matching sur cette demande pour arrêter temporairement de recevoir de nouveaux matches. Vous pouvez reprendre à tout moment.';

  @override
  String get promptDetailFirstCallTitle => 'First Call';

  @override
  String get promptDetailPublishedInTitle => 'Publié dans';

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
  String get promptDetailErrorMessage => 'Échec du chargement de la demande';

  @override
  String get promptDetailErrorDataMessage =>
      'Échec du chargement des données de la demande';

  @override
  String get promptDetailRetryButton => 'Réessayer';

  @override
  String get promptDetailEmptyMatchesTitle => 'Pas encore de matches';

  @override
  String get promptDetailEmptyMatchesDescription =>
      'Quand des personnes matchent avec votre demande, leurs profils apparaîtront ici.';

  @override
  String get promptDetailEditButton => 'Modifier la demande';

  @override
  String get promptDetailPreviewUpdatedMessage =>
      'Paramètre d\'aperçu mis à jour';

  @override
  String get promptDetailMatchSettingUpdatedMessage =>
      'Paramètre de match mis à jour';

  @override
  String get promptDetailPauseMatchingTitle => 'Mettre en pause le matching ?';

  @override
  String promptDetailPauseMatchingMessage(String interactionType) {
    return 'Vous ne recevrez plus de matches pour \"$interactionType\" sur cette demande. Vous pouvez reprendre le matching à tout moment.';
  }

  @override
  String get promptDetailPauseMatchingConfirm => 'Pause';

  @override
  String get promptDetailPauseMatchingCancel => 'Annuler';

  @override
  String get promptDetailPauseMatchingMessageGeneric =>
      'Vous ne recevrez plus de matches sur cette demande. Vous pouvez reprendre le matching à tout moment.';

  @override
  String get promptDetailMatchingActiveLabel => 'Le matching est actif';

  @override
  String get promptDetailMatchingPausedLabel => 'Le matching est en pause';

  @override
  String get promptItemPausedTag => 'En pause';

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
  String get promptDetailRejectButton => 'Rejeter';

  @override
  String get promptDetailApproveButton => 'Approuver';

  @override
  String get promptDetailApprovedMessage => 'Demande approuvée';

  @override
  String get promptDetailRejectedMessage => 'Demande rejetée';

  @override
  String get promptDetailDeleteButton => 'Supprimer';

  @override
  String get promptDetailDeleteConfirmTitle => 'Supprimer ?';

  @override
  String get promptDetailDeleteConfirmMessage =>
      'Cela supprimera définitivement vos données. Cette action ne peut pas être annulée.';

  @override
  String get promptDetailDeleteConfirmButton => 'Supprimer';

  @override
  String get promptDetailDeleteCancelButton => 'Annuler';

  @override
  String get promptDetailDeletedMessage => 'Supprimé';

  @override
  String get promptDetailDeleteErrorMessage => 'Échec de la suppression';

  @override
  String get promptEditNextButton => 'Suivant';

  @override
  String promptEntryGreeting(String firstName) {
    return 'Salut$firstName 👋';
  }

  @override
  String get promptEntryGreetingFirstTime => 'Entraînons-nous d\'abord !';

  @override
  String promptEntryFirstTimeDescription(int count) {
    return 'Les $count prochaines demandes sont des exemples d\'entraînement pour vous aider à apprendre comment y répondre.';
  }

  @override
  String promptEntryDailyDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Nous avons trouvé $count nouvelles demandes qui correspondent à vos offres.',
      one: 'Nous avons trouvé 1 nouvelle demande qui correspond à vos offres.',
    );
    return '$_temp0';
  }

  @override
  String get promptEntryButton => 'Montrez-moi';

  @override
  String get promptFinishTitle => 'Demande soumise !';

  @override
  String get promptFinishDescription =>
      'Votre demande a été soumise avec succès et est en cours d\'examen. Nous vous préviendrons une fois qu\'elle sera en ligne.';

  @override
  String get promptFinishReviewInfo =>
      'Les examens prennent généralement moins de 24 heures';

  @override
  String get promptFinishDoneButton => 'Terminé';

  @override
  String get promptFinishSavedTitle => 'Offre enregistrée';

  @override
  String get promptFinishSavedDescription =>
      'Votre offre a été enregistrée avec succès !';

  @override
  String get promptPreviewTitle => 'Aperçu';

  @override
  String get promptPreviewNextButton => 'Suivant';

  @override
  String get promptPreviewSubmitButton => 'Soumettre';

  @override
  String get promptPreviewErrorUpdate => 'Échec de la mise à jour';

  @override
  String get promptPreviewErrorSubmit => 'Échec de la soumission';

  @override
  String get promptSelectVenueTitle => 'Sélectionner le public';

  @override
  String get promptSelectVenueSubtitle => 'Où souhaitez-vous publier ?';

  @override
  String get promptSelectVenuePublicTitle => 'Publier publiquement';

  @override
  String get promptSelectVenuePublicDescription =>
      'Visible par tous les utilisateurs';

  @override
  String get promptSelectVenueOrTitle => 'Ou sélectionnez un lieu spécifique';

  @override
  String get promptSelectVenueNextButton => 'Suivant';

  @override
  String get promptSelectVenueSubmitButton => 'Soumettre';

  @override
  String get promptSelectVenueErrorSubmit => 'Échec de la soumission';

  @override
  String get promptSettingsTitle => 'Paramètres';

  @override
  String get promptSettingsSubmitButton => 'Soumettre';

  @override
  String get promptSettingsErrorSubmit => 'Échec de la soumission';

  @override
  String get promptsViewTitle => 'Demandes';

  @override
  String get promptsViewEmptyActionButton => 'Posez une question';

  @override
  String get promptsViewAnswerPromptsButton => 'Demandes non répondues';

  @override
  String get promptsViewAllAnsweredMessage =>
      'Toutes les demandes répondues pour aujourd\'hui';

  @override
  String get promptsViewMyPromptsTitle => 'Mes demandes';

  @override
  String get venueCodeFieldPlaceholder => 'Code d\'invitation';

  @override
  String get venueDetailTitle => 'Détails du lieu';

  @override
  String get venueDetailErrorLoading =>
      'Échec du chargement des détails du lieu';

  @override
  String get venueDetailRetryButton => 'Réessayer';

  @override
  String get venueDetailNotFound => 'Lieu non trouvé';

  @override
  String get venueDetailMemberSingular => 'Membre';

  @override
  String get venueDetailMembersPlural => 'Membres';

  @override
  String get venueDetailCardSingular => 'Demande';

  @override
  String get venueDetailCardsPlural => 'Demandes';

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
  String get venueDetailEmptyMatchesTitle => 'Pas encore de matches';

  @override
  String get venueDetailEmptyMatchesDescription =>
      'Quand les membres matchent via ce lieu, leurs profils apparaîtront ici.';

  @override
  String get venueDetailOpenForMatchmaking => 'Ouvert pour le matching';

  @override
  String venueDetailOpenFrom(String startDate) {
    return 'Ouvert pour le matching à partir du $startDate';
  }

  @override
  String venueDetailOpenUntil(String endDate) {
    return 'Ouvert pour le matching jusqu\'au $endDate';
  }

  @override
  String venueDetailOpenFromUntil(String startDate, String endDate) {
    return 'Ouvert pour le matching du $startDate au $endDate';
  }

  @override
  String venueProfilesViewTitle(String venueName) {
    return 'Membres de $venueName';
  }

  @override
  String get venueProfilesViewEmptyTitle => 'Aucun membre trouvé';

  @override
  String get venueProfilesViewEmptyDescription =>
      'Ce lieu n\'a pas encore de membres.';

  @override
  String venuePromptsViewTitle(String venueName) {
    return 'Demandes de $venueName';
  }

  @override
  String get venuePromptsViewEmptyTitle => 'Aucune demande trouvée';

  @override
  String get venuePromptsViewEmptyDescription =>
      'Ce lieu n\'a pas encore de demandes.';

  @override
  String get communityGuidelinesTitle => 'Directives';

  @override
  String get communityGuidelinesAllowed =>
      'réseautage, Partage de connaissances, demande d\'aide, partage d\'expérience et d\'expertise, introductions pertinentes, exploration de collaborations, réflexion sur des défis, recherche de co-fondateurs ou partenaires stratégiques, questions entrepreneuriales, recherche ou don de recommandations.';

  @override
  String get communityGuidelinesProhibited =>
      'Offres cachées, spam, fraude, tromperie, contenu offensant ou explicite, comportement toxique ou discriminatoire, discussions religieuses, déclarations haineuses, politique, offres d\'emploi ou postes vacants, publicité ou messages commerciaux.';

  @override
  String get errorStateDefaultTitle => 'Quelque chose s\'est mal passé';

  @override
  String get errorStateRetryButton => 'Réessayer';

  @override
  String get firstCallSettingsTitle => 'First Call';

  @override
  String get firstCallSettingsDescription =>
      'Vous voyez les matches en premier, les autres ne le découvrent que lorsque vous montrez de l\'intérêt. Filtrez les introductions potentielles discrètement avant de révéler le match.';

  @override
  String get firstCallSettingsEnableLabel => 'Activer';

  @override
  String get firstCallSettingsUpgradeSubtitle =>
      'Débloquez First Call et voyez les matches en premier.';

  @override
  String get firstCallSettingsUpgradeButton => 'Passer à Pro';

  @override
  String get firstCallSettingsVenueInfo =>
      'Disponible lors de la publication dans un lieu';

  @override
  String get promptInteractionPauseButton => 'Pause';

  @override
  String get promptInteractionResumeButton => 'Reprendre';

  @override
  String get paywallTitle => 'Rejoignez Venyu Pro';

  @override
  String get paywallSubtitle => 'Make the net work. Better 💪';

  @override
  String get paywallButtonNotNow => 'Pas maintenant';

  @override
  String get paywallButtonSubscribe => 'S\'abonner';

  @override
  String get paywallButtonContinue => 'Continuer';

  @override
  String get paywallButtonSubscribeContinue => 'S\'abonner et continuer';

  @override
  String get paywallButtonContinueToVenyu => 'Continuer vers Venyu';

  @override
  String get paywallButtonRestorePurchases => 'Restaurer les achats';

  @override
  String paywallDailyCost(String currency, String price) {
    return '$currency$price par jour';
  }

  @override
  String paywallDiscountBadge(int percentage) {
    return '$percentage% DE RÉDUCTION';
  }

  @override
  String get paywallErrorLoadOptions =>
      'Échec du chargement des options d\'abonnement';

  @override
  String get paywallSuccessActivated => 'Abonnement activé avec succès !';

  @override
  String get paywallErrorPurchaseFailed =>
      'Échec de l\'achat. Veuillez réessayer.';

  @override
  String get paywallSuccessRestored => 'Achats restaurés avec succès !';

  @override
  String get paywallInfoNoSubscriptions => 'Aucun abonnement actif trouvé';

  @override
  String get paywallErrorRestoreFailed => 'Échec de la restauration des achats';

  @override
  String get matchesViewTitle => 'Matches';

  @override
  String get matchesViewEmptyActionButton => 'Posez une question';

  @override
  String get profileViewTitle => 'Profil';

  @override
  String get profileViewFabJoinVenue => 'Rejoindre un lieu';

  @override
  String get profileHeaderBioPlaceholder => 'Écrivez quelque chose sur vous...';

  @override
  String get profileHeaderReachOutButton => 'Présentez-vous';

  @override
  String get profileHeaderAlreadyConnectedButton => 'Déjà en contact ?';

  @override
  String get getMatchedButtonLabel => 'Être matché';

  @override
  String get reviewPendingPromptsErrorUpdate => 'Échec de la mise à jour';

  @override
  String get reviewPendingPromptsErrorUpdateAll =>
      'Échec de la mise à jour de tout';

  @override
  String reviewPendingPromptsRejectSelected(int count) {
    return 'Rejeter $count';
  }

  @override
  String reviewPendingPromptsApproveSelected(int count) {
    return 'Approuver $count';
  }

  @override
  String get reviewPendingPromptsRejectAll => 'Tout rejeter';

  @override
  String get reviewPendingPromptsApproveAll => 'Tout approuver';

  @override
  String get matchSectionNoSharedConnections => 'Aucune connexion partagée';

  @override
  String get matchSectionNoSharedTags => 'Aucun tag partagé';

  @override
  String get matchSectionNoSharedVenues => 'Aucun lieu partagé';

  @override
  String get matchSectionUnknownTagGroup => 'Inconnu';

  @override
  String get matchActionsSkipDialogTitle => 'Passer ce match ?';

  @override
  String get matchActionsSkipDialogMessage =>
      'Ce match sera supprimé de vos matches. L\'autre personne ne recevra aucune notification et ne saura pas que vous l\'avez passée.';

  @override
  String get matchActionsSkipError => 'Échec de passer le match';

  @override
  String get matchActionsConnectError => 'Échec de la connexion';

  @override
  String get matchFinishTitle => 'Super !';

  @override
  String get matchFinishDescription => 'Votre demande a été soumise.';

  @override
  String matchFinishInfoMessage(String firstName) {
    return 'Si $firstName demande également une introduction, vous recevrez tous les deux un e-mail avec vous deux en copie afin que vous puissiez entrer en contact.';
  }

  @override
  String get matchFinishDoneButton => 'Terminé';

  @override
  String get registrationCompleteError =>
      'Échec de la finalisation de l\'inscription. Veuillez réessayer.';

  @override
  String get registrationCompleteTutorialPrompt1 =>
      'avec de l\'expérience en développement international.';

  @override
  String get registrationCompleteTutorialPrompt2 =>
      'avec de l\'expérience en obtention de subventions européennes et ouvert au partage de leçons apprises.';

  @override
  String get registrationCompleteTutorialPrompt3 =>
      'qui a démarré ou géré un espace de coworking auparavant.';

  @override
  String get registrationCompleteTutorialPrompt4 =>
      'avec une expertise en nutrition animale pour de nouveaux concepts d\'aliments pour animaux.';

  @override
  String get avatarUploadError =>
      'Échec du téléchargement de la photo. Veuillez réessayer.';

  @override
  String get avatarRemoveError =>
      'Échec de la suppression de la photo. Veuillez réessayer.';

  @override
  String get versionCheckUpdateAvailable =>
      'Une nouvelle version est disponible. Appuyez ici pour mettre à jour !';

  @override
  String get baseListViewLoading => 'Chargement...';

  @override
  String get baseListViewErrorTitle => 'Échec du chargement des données';

  @override
  String get baseFormViewErrorUpdate =>
      'Échec de la mise à jour, veuillez réessayer';

  @override
  String get errorPrefix => 'Erreur :';

  @override
  String reviewPendingPromptsAppBarTitle(String type) {
    return '$type';
  }

  @override
  String get inviteCodeErrorInvalidOrExpired =>
      'Ce code est invalide ou a expiré. Veuillez vérifier votre code et réessayer.';

  @override
  String get inviteCodeErrorRequired =>
      'Veuillez entrer un code d\'invitation.';

  @override
  String get inviteCodeErrorLength =>
      'Le code doit contenir exactement 8 caractères.';

  @override
  String get venueErrorNotMember =>
      'Vous n\'êtes pas membre de ce lieu ou il n\'existe pas.';

  @override
  String get venueErrorCodeInvalidOrExpired =>
      'Ce code est invalide ou a expiré. Veuillez demander un nouveau code.';

  @override
  String get venueErrorAlreadyMember => 'Vous êtes déjà membre de ce lieu.';

  @override
  String get venueErrorCodeRequired => 'Veuillez entrer un code de lieu.';

  @override
  String get venueErrorCodeLength =>
      'Le code doit contenir exactement 8 caractères.';

  @override
  String get venueErrorAdminRequired =>
      'Vous avez besoin de privilèges d\'administrateur pour voir les membres du lieu.';

  @override
  String get venueErrorIdRequired => 'L\'ID du lieu est requis.';

  @override
  String get venueErrorAdminRequiredPrompts =>
      'Vous avez besoin de privilèges d\'administrateur pour voir les demandes du lieu.';

  @override
  String get venueErrorPermissionDenied =>
      'Vous n\'avez pas la permission de voir les matches de ce lieu.';

  @override
  String get optionButtonCompleteProfile => 'Compléter le profil';

  @override
  String returningUserTutorialWelcome(String name) {
    return 'Bon retour $name';
  }

  @override
  String get returningUserTutorialDescription =>
      'Les règles de Venyu ont changé et nous aimerions vous les expliquer étape par étape.\n\nSpoiler : nous disons adieu aux 3 prompts quotidiens, et même au mot \'prompt\'.';

  @override
  String get returningUserTutorialButton => 'Montrez-moi';

  @override
  String get returningUserTutorialDoneDescription =>
      'Merci d\'avoir pris le temps, profitez de cette nouvelle version !';

  @override
  String get returningUserTutorialDoneButton => 'Fermer';
}
