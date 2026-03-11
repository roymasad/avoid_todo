// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Avoid Things Todo';

  @override
  String get appTagline => 'Restez productif en évitant !';

  @override
  String get language => 'Langue';

  @override
  String get addThingToAvoid => 'Ajouter une chose à éviter';

  @override
  String get whatToAvoid => 'Que devez-vous éviter ?';

  @override
  String get category => 'Catégorie';

  @override
  String get priority => 'Priorité';

  @override
  String get addToAvoidList => 'Ajouter à la liste d\'évitement';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get editItem => 'Modifier l\'élément';

  @override
  String get search => 'Rechercher';

  @override
  String get noItemsYet => 'Aucun élément à éviter pour le moment';

  @override
  String get archive => 'Archives';

  @override
  String get statistics => 'Statistiques';

  @override
  String get menu => 'Menu';

  @override
  String get about => 'À propos';

  @override
  String get aboutDescription =>
      'N\'oubliez plus jamais ce que vous devez éviter.';

  @override
  String get close => 'Fermer';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get noArchivedItems => 'Aucun élément archivé pour le moment';

  @override
  String get avoidedOn => 'Évité le';

  @override
  String get restore => 'Restaurer';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get deleteConfirmation =>
      'Cette action ne peut pas être annulée. Êtes-vous sûr ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get weeklyActivity => 'Activité hebdomadaire';

  @override
  String get byCategory => 'Par catégorie';

  @override
  String get mostAvoided => 'Les plus évités';

  @override
  String get times => 'fois';

  @override
  String get avoided => 'Évités';

  @override
  String get active => 'Actifs';

  @override
  String get keepGoing => 'Continuez !';

  @override
  String avoidedThisWeek(int count) {
    return '$count évités cette semaine';
  }

  @override
  String get goalsTitle => 'Objectifs';

  @override
  String get yourGoal => 'Votre objectif';

  @override
  String get addGoal => 'Ajouter un objectif';

  @override
  String get addAGoal => 'Ajouter un objectif';

  @override
  String get tapToAddGoal => 'Touchez pour ajouter un objectif';

  @override
  String get goalTypeStreak => 'Série';

  @override
  String get goalTypeMonthlySavings => 'Économies mensuelles';

  @override
  String get goalHabit => 'Habitude';

  @override
  String get goalTargetStreakDays => 'Série cible (jours)';

  @override
  String get goalTargetSavings => 'Économies cibles (\$)';

  @override
  String get createGoal => 'Créer l\'objectif';

  @override
  String get swipeToAvoid =>
      'Glissez vers la droite pour marquer comme évité !';

  @override
  String get itemRestored => 'Élément restauré dans la liste active';

  @override
  String get itemAvoided => 'évité !';

  @override
  String get undo => 'Annuler';

  @override
  String get health => 'Santé';

  @override
  String get productivity => 'Productivité';

  @override
  String get social => 'Social';

  @override
  String get other => 'Autre';

  @override
  String get high => 'Haute';

  @override
  String get medium => 'Moyenne';

  @override
  String get low => 'Basse';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get systemDefault => 'Par defaut du systeme';

  @override
  String get followDeviceLanguage => 'Suivre la langue de l\'appareil';

  @override
  String get spanish => 'Espanol';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugues';

  @override
  String get german => 'Deutsch';

  @override
  String get avoidedLabel => 'Évité !';

  @override
  String get totalAvoided => 'Total Évités';

  @override
  String get byPriority => 'Par priorité';

  @override
  String get moneySaved => 'Argent économisé';

  @override
  String get tags => 'Étiquettes';

  @override
  String get newTag => 'Nouvelle étiquette';

  @override
  String get tagName => 'Nom de l\'étiquette';

  @override
  String get create => 'Créer';

  @override
  String get relapseTrigger => 'Déclencheur de rechute';

  @override
  String get triggerNote => 'Note de déclenchement';

  @override
  String get badges => 'Badges et Jalons';

  @override
  String get badge24hTitle => '24h de Liberté';

  @override
  String get badge24hDesc => 'Sans rechute pendant 24 heures';

  @override
  String get badge7dTitle => 'Guerrier de 7 Jours';

  @override
  String get badge7dDesc => 'Sans rechute pendant 7 jours';

  @override
  String get badgeBudgetTitle => 'Économiseur Budget';

  @override
  String get badgeBudgetDesc => 'Plus de 50 \$ économisés';

  @override
  String get badgeMegaTitle => 'Méga Économiseur';

  @override
  String get badgeMegaDesc => 'Plus de 200 \$ économisés';

  @override
  String get badgeConsistencyTitle => 'Constance';

  @override
  String get badgeConsistencyDesc => 'Plus de 5 habitudes actives';

  @override
  String get locked => 'Verrouillé';

  @override
  String get unlocked => 'Déverrouillé';

  @override
  String get byTag => 'Par étiquette';

  @override
  String get isRecurring => 'S\'agit-il d\'une habitude récurrente ?';

  @override
  String get eventDate => 'Date de l\'événement';

  @override
  String get selectDate => 'Choisir une date';

  @override
  String get estimatedCostLabel => 'Coût estimé par rechute/durée';

  @override
  String get relapseDialogTitle => 'Oh non ! Quel a été le déclencheur ?';

  @override
  String get relapseDialogSubtitle =>
      'Noter vos déclencheurs vous aide à les éviter à l\'avenir.';

  @override
  String get relapseDialogHint => 'Notes optionnelles...';

  @override
  String get confirmRelapse => 'Confirmer la rechute';

  @override
  String get relapseSuccess => 'Série réinitialisée. N\'abandonnez pas !';

  @override
  String get onboardingWelcomeTitle =>
      'Arrêtez les habitudes qui vous freinent';

  @override
  String get onboardingWelcomeDesc =>
      'La plupart des applis suivent ce que vous devez FAIRE. Avoid suit ce que vous devez ARRÊTER — les habitudes, les envies et les schémas qui vous bloquent. Ajoutez ce que vous voulez quitter, notez vos rechutes et construisez des séries qui comptent.';

  @override
  String get onboardingTagsTitle => 'Organisez avec des Étiquettes';

  @override
  String get onboardingTagsDesc =>
      'Regroupez vos habitudes par domaine de vie — Santé, Travail, Social. Voyez d\'un coup d\'œil quelle partie de votre vie nécessite le plus d\'attention en ce moment.';

  @override
  String get onboardingMoneyTitle => 'Chaque rechute a un coût';

  @override
  String get onboardingMoneyDesc =>
      'Définissez un coût estimé par rechute (ex. un paquet de cigarettes, un repas à emporter). Avoid le multiplie par votre série pour vous montrer l\'argent réellement économisé.';

  @override
  String get onboardingRelapseTitle => 'Une rechute ? C\'est OK — Notez-la';

  @override
  String get onboardingRelapseDesc =>
      'Appuyez sur Rechute pour noter ce qui vous a déclenché. Avec le temps, Avoid repère vos schémas pour que vous puissiez les anticiper. Sans jugement, juste de la conscience.';

  @override
  String get onboardingBreakGamesTitle =>
      'Désamorcez les envies avec les Break Games';

  @override
  String get onboardingBreakGamesDesc =>
      'Quand une envie monte, appuyez sur Break sur un avoid actif pour lancer un reset rapide de 60 secondes. Ces mini-jeux et activités apaisantes sont pensés pour casser le pilote automatique avant qu\'une rechute n\'arrive.';

  @override
  String get onboardingBadgesTitle => 'Gagnez des récompenses en chemin';

  @override
  String get onboardingBadgesDesc =>
      'Débloquez des badges pour vos séries et économies. Complétez des objectifs, gagnez de l\'XP et montez de niveau parmi 100 paliers au fil de vos progrès.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get help => 'Aide et Guide';

  @override
  String get helpTitle => 'Guide de l\'application et FAQ';

  @override
  String get helpWhatIsAvoidTitle => 'Qu\'est-ce qu\'Avoid ?';

  @override
  String get helpWhatIsAvoidDesc =>
      'Avoid vous aide à briser les mauvaises habitudes en suivant ce que vous voulez ARRÊTER de faire. Ajoutez une habitude, notez vos rechutes et identifiez ce qui les déclenche. Avec le temps, vous repérerez vos schémas, construirez de longues séries et mesurerez l\'impact réel — en argent, humeur ou temps — de rester propre.';

  @override
  String get faq1Question => 'Comment ajouter quelque chose à éviter ?';

  @override
  String get faq1Answer =>
      'Appuyez sur le bouton + en bas à droite. Vous pouvez ajouter une habitude récurrente (comme fumer ou la malbouffe), un événement ponctuel (comme éviter une fête), une personne ou même un lieu. Définissez un coût optionnel et un rappel pour rester responsable.';

  @override
  String get faq2Question =>
      'Qu\'est-ce qu\'une rechute et comment l\'enregistrer ?';

  @override
  String get faq2Answer =>
      'Une rechute, c\'est quand vous cédez à quelque chose que vous essayez d\'éviter. Appuyez sur le bouton rouge Rechute de n\'importe quelle carte. Vous pouvez ajouter une note rapide sur ce qui vous a déclenché — cela enrichit votre historique et vous aide à repérer vos schémas.';

  @override
  String get faq3Question => 'Comment les séries sont-elles calculées ?';

  @override
  String get faq3Answer =>
      'Votre série compte les jours depuis votre dernière rechute. Pour les habitudes récurrentes, elle se remet à zéro à chaque rechute. Pour les événements ponctuels, elle est suivie jusqu\'à l\'archivage.';

  @override
  String get faq4Question =>
      'Comment fonctionne le suivi de l\'argent (ou du temps/humeur) ?';

  @override
  String get faq4Answer =>
      'Lors de l\'ajout d\'une habitude, définissez un coût estimé par rechute — en argent, heures ou points d\'humeur. Avoid le multiplie par la durée de votre série pour afficher le total économisé en restant propre.';

  @override
  String get faq5Question => 'Que sont les objectifs et comment les utiliser ?';

  @override
  String get faq5Answer =>
      'Les objectifs vous donnent une cible précise, comme atteindre 7 jours de série sur votre habitude la plus difficile. Chacun reçoit un objectif auto-généré basé sur l\'habitude avec le plus de rechutes. Les utilisateurs Plus peuvent aussi créer des objectifs personnalisés et suivre des cibles d\'économies.';

  @override
  String get faq6Question => 'Comment fonctionnent l\'XP et les niveaux ?';

  @override
  String get faq6Answer =>
      'Vous gagnez de l\'XP en évitant les rechutes, en complétant des objectifs et en faisant l\'engagement quotidien. Il y a 100 niveaux — les utilisateurs gratuits progressent jusqu\'au niveau 20, Plus débloque les 100.';

  @override
  String get faq7Question => 'Qu\'est-ce que l\'Engagement Quotidien ? (Plus)';

  @override
  String get faq7Answer =>
      'Les utilisateurs Plus voient chaque matin un écran pour s\'engager envers leurs habitudes actives. Chaque engagement rapporte +20 XP et renforce un rituel quotidien autour de vos objectifs.';

  @override
  String get faq8Question =>
      'Puis-je suivre des personnes ou des lieux à éviter ?';

  @override
  String get faq8Answer =>
      'Oui ! Lors de l\'ajout d\'une habitude, choisissez \'Personne\' pour la lier à un contact de votre répertoire, ou \'Lieu\' pour épingler un endroit sur la carte. Idéal pour éviter des personnes difficiles ou des environnements déclencheurs.';

  @override
  String get faq9Question => 'Qu\'inclut Avoid Plus ?';

  @override
  String get faq9Answer =>
      'Plus est un achat unique qui débloque : habitudes illimitées, historique complet des stats & carte de chaleur, analyse des schémas de rechute, objectifs personnalisés, engagement quotidien (+XP), notifications intelligentes, widget d\'écran d\'accueil, sauvegarde cloud et export de données.';

  @override
  String get faq10Question => 'Mes données sont-elles stockées dans le cloud ?';

  @override
  String get faq10Answer =>
      'Non. Avoid ne traite, ne collecte ni ne stocke les données de vos habitudes sur ses propres serveurs. Vos données restent sur votre appareil. Si vous activez la sauvegarde cloud, elles sont enregistrées dans votre propre compte iCloud ou Google Drive, pas dans le cloud d\'Avoid.';

  @override
  String get faq11Question =>
      'Quelles données analytiques Avoid collecte-t-il ?';

  @override
  String get faq11Answer =>
      'Avoid collecte uniquement des données d\'usage basiques de l\'application, comme les écrans visités et les principaux boutons touchés, afin d\'améliorer le produit. Il n\'envoie pas aux analytics les noms de vos habitudes, les notes de rechute, les noms de contacts, les noms de lieux ni tout autre contenu identifiable ou saisi par l\'utilisateur.';

  @override
  String get faq12Question =>
      'Que sont les Break Games et quand faut-il les utiliser ?';

  @override
  String get faq12Answer =>
      'Les Break Games sont de courtes activités d\'interruption d\'envie que vous pouvez lancer depuis le bouton Break d\'un avoid actif. Elles durent environ 60 secondes et servent à vous distraire, vous stabiliser ou vous rediriger au moment critique juste avant une rechute. Certains jeux enregistrent aussi vos meilleurs scores, et Plus ou l\'essai débloquent les aides et le contrôle du pool aléatoire.';

  @override
  String get coachMarkAddTitle => 'Ajoutez votre première habitude';

  @override
  String get coachMarkAddDesc =>
      'Appuyez sur + pour ajouter quelque chose que vous voulez arrêter — une habitude récurrente, un événement ponctuel, une personne ou un lieu.';

  @override
  String get coachMarkFilterTitle => 'Trouvez vos habitudes rapidement';

  @override
  String get coachMarkFilterDesc =>
      'Recherchez par nom ou appuyez sur une étiquette pour filtrer vos habitudes par catégorie.';

  @override
  String get coachMarkStatsTitle => 'Suivez votre progression';

  @override
  String get coachMarkStatsDesc =>
      'Appuyez sur l\'icône graphique ici pour voir vos séries, économies et analyses d\'habitudes.';

  @override
  String get coachMarkMenuTitle => 'Paramètres & plus';

  @override
  String get coachMarkMenuDesc =>
      'Ouvrez les paramètres pour changer la langue, le thème et accéder au guide d\'Aide ou à la synchro cloud.';

  @override
  String get resetTutorial => 'Réinitialiser le tutoriel';

  @override
  String get tutorialResetSuccess =>
      'Tutoriel réinitialisé. Redémarrez l\'application pour revoir le guide.';

  @override
  String get savingsSummary => 'Économies par type d\'article';

  @override
  String get navHome => 'Accueil';

  @override
  String get historyTitle => 'Historique';

  @override
  String get archivedTab => 'Archives';

  @override
  String get slipsTab => 'Écarts';

  @override
  String get winsTab => 'Victoires';

  @override
  String get addButtonLabel => 'Ajouter';

  @override
  String get tapPlusToTrackFirstHabit =>
      'Touchez + pour suivre votre première habitude à éviter';

  @override
  String get viewHistory => 'Voir l\'historique';

  @override
  String get costTypeLabel => 'Type de coût :';

  @override
  String get costMoney => 'Argent';

  @override
  String get costMood => 'Humeur';

  @override
  String get costTime => 'Temps';

  @override
  String get streakLabel => 'Série';

  @override
  String get slipButton => 'Rechute';

  @override
  String get justNow => 'À l\'instant';

  @override
  String get sortLatest => 'Plus récent';

  @override
  String get sortOldest => 'Plus ancien';

  @override
  String get sortAvoidType => 'Type d\'évitement';

  @override
  String get sortCostType => 'Type de coût';

  @override
  String get avoidTypeLabel => 'Type d\'évitement :';

  @override
  String get associatedPerson => 'Personne associée :';

  @override
  String get avoidLocation => 'Lieu à éviter :';

  @override
  String get pickOnMap => 'Choisir sur la carte';

  @override
  String get eventReminderLabel => 'Rappel d\'événement :';

  @override
  String get dailyReminderLabel => 'Heure du rappel quotidien :';

  @override
  String get setReminder => 'Définir un rappel';

  @override
  String get setDailyReminder => 'Rappel quotidien';

  @override
  String get selectEventDateError =>
      'Veuillez sélectionner une date d\'événement.';

  @override
  String get recentRelapsesTriggers => 'Rechutes récentes & déclencheurs';

  @override
  String get ratingDialogTitle => 'Vous aimez Avoid Todo ?';

  @override
  String get ratingDialogSubtitle =>
      'Touchez une étoile pour noter votre expérience';

  @override
  String get ratingDialogNotNow => 'Plus tard';

  @override
  String get ratingDialogContinue => 'Continuer';

  @override
  String get ratingHighTitle => 'Merci !';

  @override
  String get ratingHighBody =>
      'Pourriez-vous nous noter ? Ça nous aide vraiment !';

  @override
  String get ratingHighRateNow => 'Noter maintenant';

  @override
  String get ratingHighNoThanks => 'Non merci';

  @override
  String get ratingLowTitle => 'Aidez-nous à nous améliorer';

  @override
  String get ratingLowBody => 'Que pouvons-nous faire mieux ?';

  @override
  String get ratingLowHint => 'Votre avis...';

  @override
  String get ratingLowSend => 'Envoyer';

  @override
  String get ratingLowSkip => 'Ignorer';

  @override
  String get ratingThanks => 'Merci pour votre retour !';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get drawerWidget => 'Widget';

  @override
  String get homeScreenWidget => 'Widget d\'écran d\'accueil';

  @override
  String get homeScreenWidgetDesc =>
      'Affiche votre meilleure série sur l\'écran d\'accueil';

  @override
  String get homeScreenWidgetPlusHint =>
      'Le widget d\'écran d\'accueil est une fonctionnalité Plus.';

  @override
  String get addWidgetToHomeScreen => 'Ajouter le widget à l\'écran d\'accueil';

  @override
  String get addWidgetInstructions => 'Instructions et bouton d\'ajout rapide';

  @override
  String get cloudSync => 'Synchro cloud';

  @override
  String get cloudSyncDesc => 'Sauvegarde auto. sur iCloud / Google Drive';

  @override
  String get cloudSyncPlusHint =>
      'La synchro cloud est une fonctionnalité Plus.';

  @override
  String get manageSync => 'Gérer la synchro';

  @override
  String syncCloudBackupTitle(String cloudName) {
    return 'Sauvegarde $cloudName';
  }

  @override
  String get syncNeverSynced => 'Jamais synchronisé.';

  @override
  String get syncLastSynced => 'Dernière synchro :';

  @override
  String get syncUploadSuccess => '✓ Sauvegarde envoyée avec succès.';

  @override
  String get syncUploadFailed =>
      'Échec de l\'envoi. Vérifiez votre connexion et réessayez.';

  @override
  String get syncNoBackupFound =>
      'Aucune sauvegarde trouvée dans le cloud. Appuyez sur le bouton ci-dessous pour en créer une.';

  @override
  String get syncBackupFoundTitle => 'Sauvegarde trouvée';

  @override
  String get syncRestoreWarning =>
      '⚠️ Cela remplacera vos données actuelles par la sauvegarde cloud.\n\nToute modification depuis votre dernière sauvegarde sera perdue. Voulez-vous vraiment restaurer ?';

  @override
  String get syncUploading => 'Envoi en cours…';

  @override
  String get syncBackupNow => 'Sauvegarder maintenant';

  @override
  String get syncChecking => 'Vérification…';

  @override
  String get syncCheckForBackup => 'Verifier et restaurer';

  @override
  String get syncHowItWorksTitle => 'Comment ça fonctionne';

  @override
  String syncHowItWorksBody(String cloudName) {
    return '• Vos données sont sauvegardées dans votre $cloudName — Avoid n\'y a jamais accès.\n• Les sauvegardes se font automatiquement (au plus toutes les 10 minutes) après les actions importantes.\n• Pour restaurer sur un nouvel appareil : installez Avoid, connectez-vous, puis appuyez sur « Verifier et restaurer ».';
  }

  @override
  String get syncNotAvailable =>
      'La synchro cloud n\'est pas disponible sur cette plateforme.';

  @override
  String get widgetSetupTitleIos => '🍎 iOS — Ajouter le widget';

  @override
  String get widgetSetupTitleAndroid => '🤖 Android — Ajouter le widget';

  @override
  String get widgetColorLabel => 'Couleur du widget';

  @override
  String get colorForest => 'Forêt';

  @override
  String get colorMidnight => 'Minuit';

  @override
  String get colorOcean => 'Océan';

  @override
  String get colorPurple => 'Violet';

  @override
  String get widgetAddButton => 'Ajouter le widget à l\'écran d\'accueil';

  @override
  String get widgetDialogOpened => 'Fenêtre widget ouverte !';

  @override
  String get widgetLauncherHint => 'Votre lanceur vous demandera où le placer.';

  @override
  String get widgetFollowSteps => 'Suivez ces étapes :';

  @override
  String get widgetManualSteps =>
      'Le lanceur ne prend pas en charge le bouton ? Essayez manuellement :';

  @override
  String get widgetDone => 'Terminé';

  @override
  String get widgetIosStep1Title => 'Aller à l\'écran d\'accueil';

  @override
  String get widgetIosStep1Desc =>
      'Appuyez sur le bouton Accueil ou glissez vers le haut.';

  @override
  String get widgetIosStep2Title => 'Appui long sur une zone vide';

  @override
  String get widgetIosStep2Desc =>
      'Maintenez jusqu\'à ce que les icônes se mettent à trembler.';

  @override
  String get widgetIosStep3Title => 'Appuyez sur le bouton +';

  @override
  String get widgetIosStep3Desc => 'Coin supérieur gauche.';

  @override
  String get widgetIosStep4Title => 'Recherchez « Avoid »';

  @override
  String get widgetIosStep4Desc => 'Tapez dans la barre de recherche.';

  @override
  String get widgetIosStep5Title => 'Sélectionnez le widget Avoid';

  @override
  String get widgetIosStep5Desc =>
      'Appuyez dessus, choisissez une taille, puis « Ajouter le widget ».';

  @override
  String get widgetIosStep6Title => 'Appuyez sur Terminé';

  @override
  String get widgetIosStep6Desc => 'Coin supérieur droit pour terminer.';

  @override
  String get widgetAndroidStep1Title => 'Aller à l\'écran d\'accueil';

  @override
  String get widgetAndroidStep1Desc => 'Appuyez sur le bouton Accueil.';

  @override
  String get widgetAndroidStep2Title => 'Appui long sur une zone vide';

  @override
  String get widgetAndroidStep2Desc =>
      'Maintenez jusqu\'à l\'apparition du mode édition.';

  @override
  String get widgetAndroidStep3Title => 'Appuyez sur « Widgets »';

  @override
  String get widgetAndroidStep3Desc => 'Regardez en bas de l\'écran.';

  @override
  String get widgetAndroidStep4Title => 'Trouvez « Avoid Todo »';

  @override
  String get widgetAndroidStep4Desc => 'Faites défiler jusqu\'à la section A.';

  @override
  String get widgetAndroidStep5Title => 'Appui long & glisser';

  @override
  String get widgetAndroidStep5Desc =>
      'Faites glisser le widget vers un endroit vide de votre écran d\'accueil.';

  @override
  String get plusUnlockUnlimitedAvoidsHints =>
      'Unlimited avoids, break game hints';

  @override
  String get breakGamesSectionTitle => 'Break Games';

  @override
  String get breakRandomGamePoolTitle => 'Pool aléatoire de jeux';

  @override
  String get breakGamePoolLockedSubtitle =>
      'Lancez un essai gratuit ou débloquez Plus pour choisir quels Break Games apparaissent au hasard.';

  @override
  String get breakKeepAtLeastOneActivityEnabled =>
      'Gardez au moins une activité Break activée.';

  @override
  String breakActivityEnabledCount(int enabledCount, int totalCount) {
    return '$enabledCount sur $totalCount activés';
  }

  @override
  String get breakRandomGamePoolDescription =>
      'Choisissez quelles activités Break peuvent être sélectionnées au hasard.';

  @override
  String get breakActivityDefuseTitle => 'Désamorcer';

  @override
  String get breakActivityDefuseSubtitle =>
      'Faites retomber la tension en désamorçant le moment.';

  @override
  String get breakActivityPairMatchTitle => 'Paires';

  @override
  String get breakActivityPairMatchSubtitle =>
      'Faites glisser votre esprit vers un petit défi de mémoire.';

  @override
  String get breakActivityCubeResetTitle => 'Reset Cube';

  @override
  String get breakActivityCubeResetSubtitle =>
      'Remettez un petit cube en ordre.';

  @override
  String get breakActivityStackSweepTitle => 'Balayage de pile';

  @override
  String get breakActivityStackSweepSubtitle =>
      'Retirez les tuiles visibles jusqu’à ce que la pile disparaisse.';

  @override
  String get breakActivityTriviaPivotTitle => 'Pivot quiz';

  @override
  String get breakActivityTriviaPivotSubtitle =>
      'Donnez autre chose à mâcher à votre cerveau.';

  @override
  String get breakActivityFortuneCookieTitle => 'Biscuit chinois';

  @override
  String get breakActivityFortuneCookieSubtitle =>
      'Cassez un biscuit et grattez les miettes pour faire apparaître une pensée plus calme.';

  @override
  String get breakActivityZenRoomTitle => 'Salle Zen';

  @override
  String get breakActivityZenRoomSubtitle =>
      'Ralentissez la scène et réinitialisez l’ambiance.';

  @override
  String breakPersonalBestTime(String value) {
    return 'Record : $value';
  }

  @override
  String breakPersonalBestCorrect(int count) {
    return 'Record : $count bonnes réponses';
  }

  @override
  String get breakExitTitle => 'Quitter cette pause ?';

  @override
  String get breakExitBody =>
      'Cette session sera marquée comme incomplète. Vous pourrez toujours relancer une autre pause tout de suite.';

  @override
  String get breakStay => 'Rester';

  @override
  String get breakExit => 'Quitter';

  @override
  String get breakCustomizationLockedSubtitle =>
      'Lancez un essai gratuit ou débloquez Plus pour utiliser les indices et la personnalisation des Break Games.';

  @override
  String get breakHintStrengthTitle => 'Choisir la force des indices';

  @override
  String get breakHintStrengthBody =>
      'Voulez-vous juste une légère mise en évidence ou l’indice complet avec des flèches ?';

  @override
  String get breakHintStrengthSubtle => 'Un peu d’aide';

  @override
  String get breakHintStrengthStrong => 'Beaucoup d’aide';

  @override
  String breakSheetTitle(String item) {
    return 'Pause pour \"$item\"';
  }

  @override
  String get breakThisItem => 'cet élément';

  @override
  String get breakResume => 'Reprendre';

  @override
  String get breakPause => 'Pause';

  @override
  String get breakDefuseInstruction =>
      'Stabilisez le cadran. Touchez verrouiller quand l’aiguille glisse dans la zone calme.';

  @override
  String get breakDefuseTap => 'Touchez';

  @override
  String get breakDefuseCompleteStatus =>
      'Bien. Le mécanisme est calme maintenant. Continuez à respirer jusqu’à la fin de la minute.';

  @override
  String breakDefuseRingsLeft(int count) {
    return 'Encore $count anneaux. Restez dans le rythme.';
  }

  @override
  String get breakDefuseWaitStatus =>
      'Attendez que l’aiguille traverse la fenêtre lumineuse, puis touchez.';

  @override
  String get breakHintsLocked => 'Indices verrouillés';

  @override
  String get breakHintsOn => 'Indices activés';

  @override
  String get breakHintsOff => 'Indices désactivés';

  @override
  String get breakHintsSubtle => 'Indices : un peu';

  @override
  String get breakHintsStrong => 'Indices : beaucoup';

  @override
  String get breakPairMatchInstruction =>
      'Trouvez les paires d’emoji. Les petites recherches de motifs sont très efficaces pour casser le pilote automatique.';

  @override
  String breakPairMatchProgress(int matchedCount, int totalCount) {
    return '$matchedCount paires sur $totalCount trouvées';
  }

  @override
  String get breakCubeResetInstruction =>
      'Faites glisser pour faire tourner le cube. Balayez les autocollants visibles pour tourner les couches.';

  @override
  String breakCubeResetProgress(
      int solvedCount, int totalCount, int twistCount) {
    return '$solvedCount faces sur $totalCount résolues en $twistCount mouvements';
  }

  @override
  String breakStackSweepTilesLeft(int count) {
    return '$count tuiles restantes';
  }

  @override
  String breakTriviaCorrectInsight(String insight) {
    return 'Correct. $insight';
  }

  @override
  String breakTriviaIncorrectInsight(String insight) {
    return 'Bien essayé. $insight';
  }

  @override
  String get breakNext => 'Suivant';

  @override
  String get breakFortuneCookieTapStatus =>
      'Touchez le biscuit pour le casser.';

  @override
  String get breakFortuneCookieTapHint => 'Touchez pour casser';

  @override
  String get breakFortuneCookieScratchStatus =>
      'Grattez les miettes pour révéler le message dessous.';

  @override
  String get breakFortuneCookieRevealStatus =>
      'Bien. Laissez la phrase se poser un instant.';

  @override
  String get breakFortuneCookieFortuneLabel => 'MESSAGE';

  @override
  String get breakZenTapDrop => 'Touchez une goutte';

  @override
  String get breakZenFooter =>
      'Attrapez une goutte quand vous voulez une nouvelle phrase. Les touches ratées ne font rien, exprès.';

  @override
  String get breakCheckInTitle => 'Faites le point';

  @override
  String get breakOutcomeQuestion =>
      'Qu’est-ce qui a changé après cette pause d’une minute ?';

  @override
  String get breakReplayActivity => 'Rejouer l’activité';

  @override
  String get breakContinueActivity => 'Continuer à jouer / méditer';

  @override
  String get breakOutcomePassed => 'L’envie est passée';

  @override
  String get breakOutcomeWeaker => 'Envie plus faible';

  @override
  String get breakOutcomeStillStrong => 'Toujours forte';

  @override
  String get breakNeedAnotherLayer => 'Besoin d’une autre couche ?';

  @override
  String get breakTryAnotherBreak => 'Essayer une autre pause';

  @override
  String get breakGoToZenRoom => 'Aller à la Salle Zen';

  @override
  String get breakMessageSupport => 'Contacter le soutien';

  @override
  String get breakTriviaData =>
      'Quelle planète a les jours les plus courts ?\nTerre\nJupiter\nMars\nJupiter tourne si vite qu\'une journée y dure environ 10 heures.\n%%\nCombien de cœurs possède une pieuvre ?\nUn\nTrois\nDeux\nTrois. Deux pour les branchies et un pour le reste du corps.\n%%\nQuel est le seul mammifère capable de vraiment voler ?\nÉcureuil volant\nChauve-souris\nPhalanger volant\nLes chauves-souris sont les seuls mammifères capables d\'un vol soutenu.\n%%\nQuel océan est le plus profond ?\nAtlantique\nPacifique\nIndien\nLa fosse des Mariannes se trouve dans l\'océan Pacifique.\n%%\nCombien d\'os un adulte humain a-t-il généralement ?\n186\n206\n226\n206 est le nombre habituel après la fusion de certains os à l\'âge adulte.\n%%\nQuel animal est connu pour dormir la tête en bas ?\nKoala\nChauve-souris\nLoutre\nLes chauves-souris dorment la tête en bas pour s\'envoler rapidement.\n%%\nQuel gaz les plantes absorbent-elles surtout dans l\'air ?\nOxygène\nDioxyde de carbone\nHélium\nLes plantes utilisent le dioxyde de carbone pendant la photosynthèse.\n%%\nQuel instrument possède généralement 88 touches ?\nViolon\nPiano\nFlûte\nUn piano standard possède 88 touches.\n%%\nCombien de côtés a un hexagone ?\n5\n6\n8\nLe préfixe hexa signifie six.\n%%\nQuel oiseau est souvent associé à la livraison de messages ?\nPerroquet\nPigeon\nHibou\nLes pigeons voyageurs servaient à envoyer des messages sur de longues distances.\n%%\nQuel est le plus grand organe du corps humain ?\nFoie\nPeau\nPoumons\nLa peau est le plus grand organe du corps.\n%%\nQuelle pièce d\'échecs peut se déplacer en L ?\nFou\nCavalier\nTour\nLe cavalier est la seule pièce qui se déplace en forme de L.\n%%\nCombien y a-t-il de continents ?\n5\n7\n6\nLe modèle le plus courant compte sept continents.\n%%\nQue récoltent les abeilles sur les fleurs ?\nCailloux\nNectar\nSel\nLes abeilles récoltent du nectar et du pollen sur les fleurs.\n%%\nQuel mois a le moins de jours ?\nAvril\nFévrier\nNovembre\nFévrier est le plus court, avec 28 jours la plupart du temps.\n%%\nDans quel sport utilise-t-on un volant ?\nTennis\nBadminton\nSquash\nAu badminton, on joue avec un volant plutôt qu\'une balle.\n%%\nQuelle couleur obtient-on en mélangeant du bleu et du jaune ?\nViolet\nVert\nOrange\nLe bleu et le jaune donnent du vert.\n%%\nQuelle planète est célèbre pour ses anneaux ?\nVénus\nSaturne\nMercure\nLes anneaux de Saturne sont sa caractéristique la plus connue.\n%%\nCombien de minutes y a-t-il dans deux heures ?\n90\n120\n180\nDeux heures correspondent à 120 minutes.\n%%\nQuel animal marin a huit bras ?\nCalamar\nPieuvre\nÉtoile de mer\nLes pieuvres ont huit bras, alors que les calmars ont dix appendices.\n%%\nComment appelle-t-on l\'eau gelée ?\nVapeur\nGlace\nBrume\nLa glace est l\'eau à l\'état solide.\n%%\nDe quel côté le soleil se lève-t-il ?\nNord\nEst\nOuest\nLe soleil semble se lever à l\'est.\n%%\nQuel mammifère passe la majeure partie de sa vie dans l\'océan ?\nChameau\nBaleine\nRenard\nLes baleines sont des mammifères marins.\n%%\nQuelle forme a trois côtés ?\nCercle\nTriangle\nRectangle\nUn triangle a exactement trois côtés.\n%%\nQuel fruit séché devient un raisin sec ?\nPrune\nRaisin\nCerise\nLes raisins secs sont des raisins séchés.\n%%\nQuelle est l\'étoile principale au centre de notre système solaire ?\nPolaris\nLe Soleil\nSirius\nLe Soleil est l\'étoile autour de laquelle tournent nos planètes.\n%%\nCombien de jours compte une année bissextile ?\n365\n366\n364\nUne année bissextile ajoute un jour à février pour un total de 366 jours.\n%%\nQuel animal est connu pour changer de couleur afin de se camoufler ?\nLapin\nCaméléon\nManchot\nLes caméléons sont célèbres pour leur capacité à changer de couleur.\n%%\nComment appelle-t-on la roche en fusion une fois à la surface ?\nMagma\nLave\nQuartz\nSous terre, c\'est du magma ; à la surface, c\'est de la lave.\n%%\nQuelle aiguille d\'une horloge tourne le plus vite ?\nAiguille des heures\nAiguille des secondes\nAiguille des minutes\nL\'aiguille des secondes fait un tour complet chaque minute.\n%%\nQuelle saison vient après le printemps dans l\'hémisphère nord ?\nHiver\nÉté\nAutomne\nL\'été vient après le printemps.\n%%\nCombien de pattes a une araignée ?\n6\n8\n10\nLes araignées sont des arachnides à huit pattes.\n%%\nQuel océan se trouve entre l\'Afrique et l\'Australie ?\nOcéan Pacifique\nOcéan Indien\nOcéan Arctique\nL\'océan Indien se situe entre l\'Afrique, l\'Asie et l\'Australie.\n%%\nQue deviennent les chenilles ?\nLibellules\nPapillons\nColéoptères\nBeaucoup de chenilles se transforment en papillons ou en mites.\n%%\nQuel objet de la maison sert à mesurer la température ?\nBoussole\nThermomètre\nBalance\nUn thermomètre mesure la température.\n%%\nCombien de cordes possède un violon standard ?\n5\n4\n6\nUn violon possède normalement quatre cordes.\n%%\nQuelle planète est la plus proche du Soleil ?\nMars\nMercure\nNeptune\nMercure est la planète la plus proche du Soleil.\n%%\nQuel est le point d\'ébullition de l\'eau au niveau de la mer en degrés Celsius ?\n90\n100\n110\nAu niveau de la mer, l\'eau bout à 100 °C.\n%%\nQuel animal est célèbre pour construire des barrages ?\nLoutre\nCastor\nTaupe\nLes castors construisent des barrages avec des branches et de la boue.\n%%\nQuel est l\'opposé du nord sur une boussole ?\nEst\nSud\nOuest\nLe sud est l\'opposé du nord.\n%%\nQuelle forme n\'a aucun coin ?\nCarré\nCercle\nTriangle\nLes cercles n\'ont ni coins ni arêtes.\n%%\nQuelle planète est connue comme la planète rouge ?\nVénus\nMars\nUranus\nMars paraît rouge à cause de l\'oxyde de fer présent à sa surface.\n%%\nCombien d\'heures y a-t-il dans une journée complète ?\n12\n24\n36\nUne journée complète compte 24 heures.\n%%\nAvec quoi écrit-on sur un tableau noir ?\nEncre\nCraie\nCrayon\nLa craie est l\'outil classique pour écrire sur un tableau noir.\n%%\nQuel animal est le plus grand sur terre ?\nÉléphant\nGirafe\nChameau\nLes girafes sont les animaux terrestres les plus grands.\n%%\nQuel sens est le plus lié à votre nez ?\nGoût\nOdorat\nToucher\nLe nez est associé au sens de l\'odorat.\n%%\nQuel ustensile de cuisine sert à retourner des crêpes ?\nFouet\nSpatule\nLouche\nUne spatule sert couramment à retourner des crêpes.\n%%\nQuel nombre vient après 999 ?\n1001\n1000\n990\nAprès 999 vient 1000.\n%%\nQuelle planète est la plus éloignée du Soleil ?\nSaturne\nNeptune\nTerre\nNeptune est actuellement la planète reconnue la plus éloignée du Soleil.\n%%\nComment appelle-t-on un mot qui signifie le contraire d\'un autre ?\nSynonyme\nAntonyme\nAcronyme\nUn antonyme est un mot de sens opposé.\n%%\nQuel métal est liquide à température ambiante ?\nFer\nMercure\nArgent\nLe mercure est l\'un des rares métaux liquides à température ambiante.\n%%\nQuelle est la substance naturelle la plus dure sur Terre ?\nOr\nDiamant\nQuartz\nLe diamant est le matériau naturel le plus dur.\n%%\nQuel groupe sanguin est connu comme donneur universel ?\nAB positif\nO négatif\nA positif\nLe sang O négatif peut généralement être transfusé en urgence à la plupart des gens.\n%%\nComment appelle-t-on les animaux actifs la nuit ?\nAquatiques\nNocturnes\nMigrateurs\nLes animaux nocturnes sont surtout actifs pendant la nuit.\n%%\nQuelle langue compte le plus de locuteurs natifs dans le monde ?\nAnglais\nChinois mandarin\nEspagnol\nLe chinois mandarin a le plus grand nombre de locuteurs natifs.\n%%\nQuel pays est célèbre pour le symbole de la feuille d\'érable ?\nSuède\nCanada\nNouvelle-Zélande\nLa feuille d\'érable est l\'un des symboles les plus connus du Canada.\n%%\nQuel est l\'ingrédient principal du guacamole ?\nConcombre\nAvocat\nPetit pois\nLe guacamole est principalement préparé à base d\'avocat écrasé.\n%%\nQuelle planète tourne davantage sur le côté que les autres ?\nTerre\nUranus\nJupiter\nUranus a une inclinaison extrême et semble tourner sur le côté.\n%%\nCombien de dents possède généralement un adulte, dents de sagesse comprises ?\n28\n32\n30\nUne dentition adulte complète comprend généralement 32 dents.\n%%\nQuel désert est le plus grand désert chaud de la planète ?\nGobi\nSahara\nMojave\nLe Sahara est le plus grand désert chaud du monde.\n%%\nComment appelle-t-on un scientifique qui étudie les roches ?\nBiologiste\nGéologue\nAstronome\nLes géologues étudient les roches, les minéraux et la structure de la Terre.\n%%\nQuel organe pompe le sang dans le corps ?\nFoie\nCœur\nRein\nLe cœur fait circuler le sang dans tout le système sanguin.\n%%\nQuel fruit a ses graines à l\'extérieur ?\nMyrtille\nFraise\nPomme\nLes fraises sont particulières parce que leurs graines sont à l\'extérieur.\n%%\nComment s\'appelle le processus par lequel la vapeur d\'eau devient liquide ?\nÉvaporation\nCondensation\nGel\nLa condensation se produit lorsque la vapeur d\'eau se refroidit et redevient liquide.\n%%\nQuel mur célèbre a été construit pour protéger le nord de la Chine ?\nMur de Berlin\nGrande Muraille\nMur d\'Hadrien\nLa Grande Muraille de Chine a été construite et agrandie sur plusieurs siècles.\n%%\nCombien de joueurs une équipe de football a-t-elle sur le terrain à un moment donné ?\n9\n11\n10\nUne équipe de football aligne 11 joueurs, gardien compris.\n%%\nQuel oiseau ne peut pas voler mais est célèbre pour vivre en Antarctique ?\nMouette\nManchot\nFaucon\nLes manchots sont des oiseaux incapables de voler et fortement associés à l\'Antarctique.\n%%\nCombien font 12 multiplié par 12 ?\n124\n144\n154\n12 multiplié par 12 fait 144.\n%%\nDe quel gaz les humains ont-ils besoin pour respirer et vivre ?\nAzote\nOxygène\nHydrogène\nLes humains ont besoin d\'oxygène pour respirer.\n%%\nQuelle est la plus grande planète de notre système solaire ?\nSaturne\nJupiter\nNeptune\nJupiter est la plus grande planète de notre système solaire.\n%%\nDans quelle partie du corps se trouve le fémur ?\nBras\nJambe\nCrâne\nLe fémur est l\'os de la cuisse, dans la jambe.\n%%\nQuelle tour célèbre penche en Italie ?\nTour Eiffel\nTour de Pise\nTour CN\nLa tour penchée de Pise est l\'un des monuments les plus connus d\'Italie.\n%%\nCombien de zéros y a-t-il dans un million ?\n5\n6\n7\nUn million s\'écrit 1 000 000.\n%%\nQuel animal marin est connu pour avoir une carapace et se déplacer lentement sur terre ?\nPhoque\nTortue\nDauphin\nLes tortues marines ont une carapace et avancent lentement sur la terre ferme.\n%%\nComment appelle-t-on la partie colorée de l\'œil ?\nRétine\nIris\nPupille\nL\'iris est l\'anneau coloré autour de la pupille.\n%%\nQuel instrument sert à observer les étoiles et les planètes ?\nMicroscope\nTélescope\nPériscope\nUn télescope est conçu pour observer des objets lointains dans l\'espace.\n%%\nQuelle fête est connue pour les citrouilles et les costumes ?\nPâques\nHalloween\nSaint-Valentin\nHalloween est associée aux costumes, aux bonbons et aux citrouilles.\n%%\nCombien font 100 divisé par 4 ?\n20\n25\n40\n100 divisé par 4 fait 25.\n%%\nQuel animal est connu comme le roi de la jungle ?\nTigre\nLion\nLoup\nLe lion est souvent appelé le roi de la jungle.\n%%\nQu\'est-ce que les aimants attirent ?\nBois\nFer\nPlastique\nLes aimants attirent fortement le fer et certains autres métaux.\n%%\nQuel jour vient après vendredi ?\nJeudi\nSamedi\nDimanche\nSamedi vient après vendredi.\n%%\nQuelle est la plus haute montagne au-dessus du niveau de la mer ?\nK2\nMont Everest\nKilimandjaro\nLe mont Everest est la plus haute montagne au-dessus du niveau de la mer.\n%%\nQuel insecte brille dans le noir ?\nFourmi\nLuciole\nSauterelle\nLes lucioles produisent de la lumière grâce à la bioluminescence.\n%%\nCombien y a-t-il de mois dans une année ?\n10\n12\n14\nUne année standard compte 12 mois.\n%%\nQuel outil utilise-t-on pour couper du papier dans les travaux manuels ?\nCuillère\nCiseaux\nPinceau\nLes ciseaux servent couramment à couper du papier.\n%%\nQuelle planète est connue pour avoir une gigantesque tempête rouge ?\nMars\nJupiter\nVénus\nLa Grande Tache rouge de Jupiter est une énorme tempête durable.\n%%\nQuel est le rôle principal des racines d\'une plante ?\nFaire chanter les fleurs\nAbsorber l\'eau\nCapter la lumière du soleil\nLes racines aident à ancrer la plante et à absorber l\'eau et les nutriments.\n%%\nQuelle forme a quatre côtés égaux et quatre angles droits ?\nTriangle\nCarré\nOvale\nUn carré a quatre côtés égaux et quatre angles droits.\n%%\nQuel pays est célèbre pour les pyramides de Gizeh ?\nMexique\nÉgypte\nInde\nLes pyramides de Gizeh se trouvent en Égypte.\n%%\nComment appelle-t-on la pluie gelée qui tombe en petites billes ?\nBrouillard\nGrésil\nVapeur\nLe grésil est une précipitation gelée qui tombe sous forme de petites billes.\n%%\nQuel bras de mer sépare l\'Europe et l\'Afrique près de l\'Espagne ?\nManche\nDétroit de Gibraltar\nDétroit de Béring\nLe détroit de Gibraltar se situe entre le sud de l\'Espagne et le nord de l\'Afrique.\n%%\nCombien de roues a un vélo standard ?\n1\n2\n3\nUn vélo standard a deux roues.\n%%\nQuel animal est connu pour porter sa maison sur son dos ?\nLézard\nEscargot\nHérisson\nUn escargot porte sa coquille sur son dos.\n%%\nQuelle est la couleur principale de la chlorophylle ?\nRouge\nVert\nBleu\nLa chlorophylle est le pigment vert que les plantes utilisent pour capter la lumière.\n%%\nQuel continent habité est le plus sec ?\nAfrique\nAustralie\nEurope\nL\'Australie est le continent habité le plus sec.\n%%\nComment appelle-t-on un groupe de lions ?\nMeute\nTroupe\nTroupeau\nUn groupe de lions s\'appelle une troupe.\n%%\nQuel instrument possède des pédales et se trouve souvent dans les églises ?\nTrompette\nOrgue\nTambour\nLes orgues possèdent souvent à la fois des claviers et des pédales.\n%%\nQuel ingrédient de cuisine courant fait lever le pain ?\nSel\nLevure\nPoivre\nLa levure produit un gaz qui aide la pâte à pain à lever.\n%%\nCombien font 7 multiplié par 8 ?\n54\n56\n58\n7 multiplié par 8 fait 56.\n%%\nQuelle partie de la Terre est composée en grande partie de métal en fusion ?\nCroûte\nNoyau\nOcéan\nLe noyau terrestre est principalement métallique, et son noyau externe est en fusion.';

  @override
  String get breakZenFortunesData =>
      'Fais d\'abord une pause. L\'élan n\'est pas un destin.\n%%\nL\'envie est bruyante. Elle ne commande pas.\n%%\nDonne encore 10 respirations à ce moment avant de décider quoi que ce soit.\n%%\nLes petits détours comptent. Tu as déjà interrompu la spirale.\n%%\nSi ton esprit est en tempête, réduis l\'horizon à la minute qui vient.\n%%\nRien de permanent n\'a besoin d\'être décidé au milieu d\'une vague passagère.\n%%\nTu n\'as pas à obéir à la première impulsion qui apparaît.\n%%\nEssaie de rendre cette minute plus petite, plus douce et plus lente.\n%%\nTu peux repousser l\'envie sans avoir à la vaincre pour toujours.\n%%\nLa victoire, ce n\'est pas la perfection. C\'est créer de l\'espace.\n%%\nUn pas suivant plus calme vaut mieux qu\'un geste dramatique.\n%%\nRemarque l\'envie. Nomme-la. Ne lui raconte pas d\'histoire.\n%%\nTon système nerveux demande du soin, pas une punition.\n%%\nUne interruption douce peut réorienter tout le moment.\n%%\nRespire comme si tu aidais un ami, pas comme si tu te grondais.\n%%\nSi cela paraît tranchant, réponds avec douceur et structure.\n%%\nTu peux être mal à l\'aise sans être en danger.\n%%\nLe moment est intense. Il peut encore bouger.\n%%\nDonne moins de scène à l\'envie et plus de distance.\n%%\nUn oui différé devient souvent un non paisible.\n%%\nLe corps se calme plus vite quand tu cesses de discuter avec lui.\n%%\nChoisis la prochaine minute, pas tout l\'avenir.\n%%\nReprends ton souffle avant de suivre tes pensées.\n%%\nTes progrès se construisent avec de petites interruptions comme celle-ci.\n%%\nUne pause n\'est pas une faiblesse. C\'est du pilotage.\n%%\nLaisse passer la vague ; tu n\'as pas à lui construire une maison.\n%%\nL\'envie peut frapper. Elle n\'a pas le droit d\'entrer.\n%%\nFais baisser l\'enjeu de cette minute et elle devient plus facile à porter.\n%%\nTu n\'es pas en retard. Tu pratiques la pause en temps réel.\n%%\nUn système nerveux plus apaisé prend de meilleures décisions.\n%%\nTu peux attendre sans nier ton humanité.\n%%\nL\'envie veut de la vitesse. Réponds par de la stabilité.\n%%\nC\'est un point de contrôle, pas un verdict sur qui tu es.\n%%\nReste avec le corps le temps d\'un souffle avant de suivre l\'histoire.\n%%\nUn peu d\'espace maintenant est déjà une vraie forme de progrès.\n%%\nTu as déjà traversé de fortes envies sans leur obéir.\n%%\nLe prochain geste bienveillant peut être tout petit et compter quand même.\n%%\nLe calme se construit souvent par répétition, pas par révélation.\n%%\nDes interruptions comme celle-ci apprennent à ton cerveau un nouveau chemin.\n%%\nUne minute de distance peut éviter une heure de regret.\n%%\nTu as le droit de vouloir du soulagement et de choisir quand même avec sagesse.\n%%\nFais moins. Ralentis. Laisse d\'abord retomber la chaleur.\n%%\nL\'esprit devient plus silencieux quand le corps se sent plus en sécurité.\n%%\nTu peux honorer ce ressenti sans le mettre en acte.\n%%\nCe moment n\'a pas besoin de drame ; il a besoin d\'espace.\n%%\nEssaie de relâcher ta mâchoire, tes épaules et la pression du temps.\n%%\nC\'est toi qui tiens la barre maintenant, même si le virage est doux.\n%%\nRespire bas et lentement ; laisse l\'urgence rater son entrée.\n%%\nLes envies montent souvent vite et retombent si on ne les alimente pas.\n%%\nCette pause change déjà la fin.\n%%\nTu n\'as pas besoin d\'un plan parfait pour faire un meilleur prochain pas.\n%%\nOffre un peu d\'ennui à l\'impulsion et elle faiblit souvent.\n%%\nIl y a de la force à devenir moins disponible pour l\'envie.\n%%\nUn corps calme peut contenir un esprit bruyant avec plus de sécurité.\n%%\nQue ceci soit une remise à zéro, pas un débat.\n%%\nL\'avenir que tu protèges se construit dans des moments exactement comme celui-ci.\n%%\nMême si tu ne fais que repousser la spirale, cela compte quand même.\n%%\nApaise d\'abord le système nerveux ; le sens peut attendre.\n%%\nUne pause sage paraît souvent ordinaire pendant qu\'elle se produit.\n%%\nTu t\'apprends que l\'urgence n\'est pas une autorité.\n%%\nDe petits choix nets construisent une confiance tranquille.\n%%\nLe soulagement le plus rapide n\'est pas toujours le plus juste.\n%%\nFais du prochain souffle toute ta mission.\n%%\nRéduis le bruit, puis décide.\n%%\nTu peux rencontrer ce moment avec moins de force.\n%%\nL\'envie demande de l\'attention ; offre-lui plutôt de l\'observation.\n%%\nAucune règle ne dit que tu dois poursuivre l\'ancien schéma.\n%%\nMême un ralentissement partiel est une vraie victoire.\n%%\nTu n\'es pas enfermé dans la première émotion.\n%%\nUne meilleure décision commence souvent avec un corps plus lent.\n%%\nLa douceur a sa place ici.\n%%\nTu peux rester curieux plutôt que réactif pendant encore une minute.\n%%\nQue ta respiration donne le rythme.\n%%\nLa tempête dans ta tête n\'a pas à devenir le climat de ta vie.\n%%\nLa stabilité, c\'est souvent quelques secondes plus calmes répétées.';

  @override
  String get breakFortuneCookieWisdomsData =>
      'Respirez d\'abord. Le prochain geste peut attendre.\n%%\nUne minute plus lente peut changer toute l\'ambiance.\n%%\nRepoussez l\'envie, pas votre douceur.\n%%\nLes petites pauses restent de vrais choix forts.\n%%\nVous n\'avez pas besoin de résoudre ce moment en force.\n%%\nLaissez tomber vos épaules avant de laisser tomber vos repères.\n%%\nUne envie est une visiteuse, pas une patronne.\n%%\nDonnez de l\'espace à cette vague et elle rétrécira.\n%%\nLa douceur vaut mieux que le spectaculaire quand le but est la paix.\n%%\nUn souffle calme est déjà une nouvelle direction.\n%%\nVous pouvez vouloir du soulagement sans obéir à l\'envie.\n%%\nPrenez la prochaine décision avec un corps plus apaisé.\n%%\nCette minute mérite de la patience, pas de la pression.\n%%\nUn progrès discret reste un progrès.\n%%\nRien d\'important ne gagne à être précipité.\n%%\nRestez avec le souffle plus longtemps qu\'avec l\'histoire.\n%%\nUn peu d\'espace maintenant peut éviter beaucoup plus tard.\n%%\nVous interrompez déjà l\'ancien chemin.\n%%\nL\'envie est réelle. Votre choix aussi.\n%%\nUne pause est une compétence, pas une esquive.\n%%\nLaissez retomber la chaleur avant de lui répondre.\n%%\nLes pensées plus douces arrivent après des souffles plus stables.\n%%\nVous avez le droit de ralentir la scène.\n%%\nIci, la curiosité aide plus que la critique.\n%%\nVotre futur vous aime bien dans cette version plus calme.\n%%\nLa première impulsion n\'est pas la vérité finale.\n%%\nProtégez les dix prochaines minutes, pas toute l\'année.\n%%\nUn corps plus stable fait des promesses plus sages.\n%%\nCe ressenti peut passer sans devenir un acte.\n%%\nLent est parfois la vitesse la plus courageuse.\n%%\nVous pouvez être mal à l\'aise et rester en sécurité.\n%%\nDonnez moins d\'attention à l\'envie et plus de distance.\n%%\nUne meilleure fin commence souvent par une pause.\n%%\nUne structure bienveillante vaut mieux qu\'une pression dure.\n%%\nLaissez le moment rapetisser avant de le juger.\n%%\nLe corps écoute quand le souffle devient gentil.\n%%\nLes petits délais construisent une confiance durable.\n%%\nVous ne devez pas de réponse immédiate à l\'envie.\n%%\nLa paix grandit dans les petits choix répétés.\n%%\nCette pause est une vraie victoire, pas un simple entre-deux.\n%%\nRespirez bas. Desserrez. Revenez doucement.\n%%\nFaites de la place au calme avant de faire de la place à l\'action.\n%%\nUne remise à zéro douce peut quand même être puissante.\n%%\nMoins d\'urgence, plus de présence.\n%%\nVous pratiquez la liberté par petits morceaux.\n%%\nUn choix plus net peut éclairer toute la journée.\n%%\nLaissez l\'immobilité faire une partie du travail.\n%%\nUne minute calme n\'est jamais perdue.\n%%\nTenez bon. La vague est déjà en train de changer.\n%%\nPlus doux ne veut pas dire plus faible. Plus doux veut dire plus sage.';
}
