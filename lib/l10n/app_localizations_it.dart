// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Avoid Things Todo';

  @override
  String get appTagline => 'Resta produttivo evitando cio che ti ostacola.';

  @override
  String get language => 'Lingua';

  @override
  String get addThingToAvoid => 'Aggiungi qualcosa da evitare';

  @override
  String get whatToAvoid => 'Che cosa devi evitare?';

  @override
  String get category => 'Categoria';

  @override
  String get priority => 'Priorita';

  @override
  String get addToAvoidList => 'Aggiungi alla lista';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get editItem => 'Modifica elemento';

  @override
  String get search => 'Cerca';

  @override
  String get noItemsYet => 'Non ci sono ancora elementi da evitare';

  @override
  String get archive => 'Archivio';

  @override
  String get statistics => 'Statistiche';

  @override
  String get menu => 'Menù';

  @override
  String get about => 'Informazioni';

  @override
  String get aboutDescription => 'Non dimenticare piu cio che devi evitare.';

  @override
  String get close => 'Chiudi';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get noArchivedItems => 'Non ci sono ancora elementi archiviati';

  @override
  String get avoidedOn => 'Evitato il';

  @override
  String get restore => 'Ripristina';

  @override
  String get deletePermanently => 'Elimina definitivamente';

  @override
  String get deleteConfirmation =>
      'Questa azione non puo essere annullata. Sei sicuro?';

  @override
  String get delete => 'Elimina';

  @override
  String get weeklyActivity => 'Attivita settimanale';

  @override
  String get byCategory => 'Per categoria';

  @override
  String get mostAvoided => 'Piu evitato';

  @override
  String get times => 'volte';

  @override
  String get avoided => 'Evitato';

  @override
  String get active => 'Attivo';

  @override
  String get keepGoing => 'Continua cosi!';

  @override
  String avoidedThisWeek(int count) {
    return '$count evitati questa settimana';
  }

  @override
  String get goalsTitle => 'Obiettivi';

  @override
  String get yourGoal => 'Il tuo obiettivo';

  @override
  String get addGoal => 'Aggiungi obiettivo';

  @override
  String get addAGoal => 'Aggiungi un obiettivo';

  @override
  String get tapToAddGoal => 'Tocca per aggiungere un obiettivo';

  @override
  String get goalTypeStreak => 'Serie';

  @override
  String get goalTypeMonthlySavings => 'Risparmio mensile';

  @override
  String get goalHabit => 'Abitudine';

  @override
  String get goalTargetStreakDays => 'Serie obiettivo (giorni)';

  @override
  String get goalTargetSavings => 'Risparmio obiettivo (\$)';

  @override
  String get createGoal => 'Crea obiettivo';

  @override
  String get swipeToAvoid => 'Scorri a destra per segnare come evitato';

  @override
  String get itemRestored => 'Elemento ripristinato nella lista attiva';

  @override
  String get itemAvoided => 'evitato!';

  @override
  String get undo => 'Annulla';

  @override
  String get health => 'Salute';

  @override
  String get productivity => 'Produttivita';

  @override
  String get social => 'Sociale';

  @override
  String get other => 'Altro';

  @override
  String get high => 'Alta';

  @override
  String get medium => 'Media';

  @override
  String get low => 'Bassa';

  @override
  String get english => 'Inglese';

  @override
  String get french => 'Francese';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get followDeviceLanguage => 'Segui la lingua del dispositivo';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get german => 'Tedesco';

  @override
  String get avoidedLabel => 'Evitato!';

  @override
  String get totalAvoided => 'Totale evitato';

  @override
  String get byPriority => 'Per priorita';

  @override
  String get moneySaved => 'Denaro risparmiato';

  @override
  String get tags => 'Tag';

  @override
  String get newTag => 'Nuovo tag';

  @override
  String get tagName => 'Nome del tag';

  @override
  String get create => 'Crea';

  @override
  String get relapseTrigger => 'Fattore scatenante della ricaduta';

  @override
  String get triggerNote => 'Nota sul fattore scatenante';

  @override
  String get badges => 'Badge e traguardi';

  @override
  String get badge24hTitle => 'Libertà di 24 ore';

  @override
  String get badge24hDesc => 'Sei rimasto saldo per 24 ore';

  @override
  String get badge7dTitle => 'Guerriero dei 7 giorni';

  @override
  String get badge7dDesc => 'Sei rimasto saldo per 7 giorni';

  @override
  String get badgeBudgetTitle => 'Maestro del risparmio';

  @override
  String get badgeBudgetDesc => 'Hai risparmiato più di \$50';

  @override
  String get badgeMegaTitle => 'Super risparmiatore';

  @override
  String get badgeMegaDesc => 'Hai risparmiato più di \$200';

  @override
  String get badgeConsistencyTitle => 'Costanza';

  @override
  String get badgeConsistencyDesc => '5+ abitudini attive';

  @override
  String get locked => 'Bloccato';

  @override
  String get unlocked => 'Sbloccato';

  @override
  String get byTag => 'Per tag';

  @override
  String get isRecurring => 'E un abitudine ricorrente?';

  @override
  String get eventDate => 'Data dell evento';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get estimatedCostLabel => 'Costo stimato per ricaduta/durata';

  @override
  String get relapseDialogTitle => 'Oh no! Cosa l ha scatenato?';

  @override
  String get relapseDialogSubtitle =>
      'Registrare i tuoi trigger ti aiuta a evitarli in futuro.';

  @override
  String get relapseDialogHint => 'Note facoltative...';

  @override
  String get confirmRelapse => 'Conferma ricaduta';

  @override
  String get relapseSuccess => 'La serie e stata azzerata. Non mollare!';

  @override
  String get onboardingWelcomeTitle => 'Ferma le abitudini che ti trattengono';

  @override
  String get onboardingWelcomeDesc =>
      'La maggior parte delle app tiene traccia di ciò che DEVI fare. Avoid tiene traccia di ciò che devi SMETTERE di fare: abitudini, impulsi e schemi che ti ostacolano. Aggiungi ciò che vuoi lasciare, registra quando ricadi e costruisci serie che contano davvero.';

  @override
  String get onboardingTagsTitle => 'Organizzati con i tag';

  @override
  String get onboardingTagsDesc =>
      'Raggruppa le abitudini per area della tua vita: Salute, Lavoro, Sociale. Vedi subito quale parte della tua vita ha bisogno di più attenzione in questo momento.';

  @override
  String get onboardingMoneyTitle => 'Ogni ricaduta ha un costo';

  @override
  String get onboardingMoneyDesc =>
      'Imposta un costo stimato per ogni ricaduta, ad esempio un pacchetto di sigarette o un pasto d’asporto. Avoid lo moltiplica per la tua serie per mostrarti il denaro reale che hai risparmiato.';

  @override
  String get onboardingRelapseTitle => 'Sei ricaduto? Va bene: registralo';

  @override
  String get onboardingRelapseDesc =>
      'Tocca Ricaduta per registrare cosa ti ha fatto cedere. Con il tempo, Avoid individua i tuoi schemi per aiutarti ad anticiparli. Nessun giudizio, solo consapevolezza.';

  @override
  String get onboardingBadgesTitle => 'Ottieni ricompense lungo il percorso';

  @override
  String get onboardingBadgesDesc =>
      'Sblocca badge per le serie e i traguardi di risparmio. Completa obiettivi, guadagna XP e sali attraverso 100 livelli mentre le tue abitudini diventano più forti.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get next => 'Avanti';

  @override
  String get skip => 'Salta';

  @override
  String get help => 'Aiuto e guida';

  @override
  String get helpTitle => 'Guida dell app e FAQ';

  @override
  String get helpWhatIsAvoidTitle => 'Che cos’è Avoid?';

  @override
  String get helpWhatIsAvoidDesc =>
      'Avoid ti aiuta a spezzare le cattive abitudini tracciando ciò che vuoi SMETTERE di fare. Aggiungi un’abitudine, registra quando ricadi e annota cosa l’ha scatenata. Con il tempo noterai i tuoi schemi, costruirai serie più lunghe e vedrai l’impatto reale, in denaro, umore o tempo, del restare saldo.';

  @override
  String get faq1Question => 'Come faccio ad aggiungere qualcosa da evitare?';

  @override
  String get faq1Answer =>
      'Tocca il pulsante + in basso a destra. Puoi aggiungere un’abitudine ricorrente, come fumare o il junk food, un evento singolo, come saltare una festa, una persona da evitare o persino un luogo. Imposta un costo e un promemoria facoltativi per tenerti responsabile.';

  @override
  String get faq2Question => 'Cos’è una ricaduta e come la registro?';

  @override
  String get faq2Answer =>
      'Una ricaduta avviene quando cedi a qualcosa che stai cercando di evitare. Tocca il pulsante rosso Ricaduta su qualsiasi scheda abitudine. Puoi aggiungere una nota rapida su ciò che ti ha scatenato: così costruisci la cronologia dei tuoi trigger e riconosci i tuoi schemi nel tempo.';

  @override
  String get faq3Question => 'Come vengono calcolate le serie?';

  @override
  String get faq3Answer =>
      'La tua serie conta i giorni trascorsi dall’ultima ricaduta. Per le abitudini ricorrenti si azzera ogni volta che ricadi. Per gli eventi una tantum continua finché non archivi l’elemento.';

  @override
  String get faq4Question =>
      'Come funziona il monitoraggio di denaro, tempo o umore?';

  @override
  String get faq4Answer =>
      'Quando aggiungi un’abitudine, imposta un costo stimato per ogni ricaduta, in denaro, ore o punti umore. Avoid lo moltiplica per la durata della tua serie per mostrarti il totale risparmiato restando saldo.';

  @override
  String get faq5Question => 'Cosa sono gli obiettivi e come li uso?';

  @override
  String get faq5Answer =>
      'Gli obiettivi ti danno un traguardo concreto, come raggiungere una serie di 7 giorni con l’abitudine più difficile. Tutti ricevono un obiettivo generato automaticamente in base all’abitudine con più ricadute. Gli utenti Plus possono anche creare obiettivi personalizzati e monitorare target di risparmio.';

  @override
  String get faq6Question => 'Come funzionano XP e livelli?';

  @override
  String get faq6Answer =>
      'Guadagni XP evitando ricadute, completando obiettivi e facendo l’impegno quotidiano. Ci sono 100 livelli con titoli: gli utenti free avanzano fino al livello 20, mentre Plus sblocca tutti e 100.';

  @override
  String get faq7Question => 'Che cos’è l’Impegno quotidiano? (Plus)';

  @override
  String get faq7Answer =>
      'Gli utenti Plus vedono una schermata mattutina una volta al giorno per impegnarsi con le proprie abitudini attive. Ogni impegno assegna +20 XP e crea un rituale quotidiano attorno ai tuoi obiettivi.';

  @override
  String get faq8Question =>
      'Posso tenere traccia di persone o luoghi da evitare?';

  @override
  String get faq8Answer =>
      'Sì. Quando aggiungi un’abitudine, scegli Persona per collegarla a un contatto della rubrica, oppure Luogo per fissare un punto sulla mappa. È perfetto per evitare persone difficili o ambienti che ti scatenano.';

  @override
  String get faq9Question => 'Cosa include Avoid Plus?';

  @override
  String get faq9Answer =>
      'Plus è un acquisto una tantum che sblocca abitudini illimitate, cronologia completa delle statistiche e heatmap, analisi dei pattern di ricaduta, obiettivi personalizzati, impegno quotidiano (+XP), notifiche intelligenti basate sui pattern, widget per la schermata Home, backup cloud ed esportazione dei dati.';

  @override
  String get faq10Question => 'I miei dati vengono salvati nel cloud?';

  @override
  String get faq10Answer =>
      'No. Avoid non elabora, raccoglie né salva i dati delle tue abitudini sui propri server. I tuoi dati restano sul tuo dispositivo. Se attivi il backup cloud, vengono salvati nel tuo account iCloud o Google Drive, non nel cloud di Avoid.';

  @override
  String get coachMarkAddTitle => 'Aggiungi la tua prima abitudine';

  @override
  String get coachMarkAddDesc =>
      'Tocca + per aggiungere qualcosa che vuoi smettere di fare: un’abitudine ricorrente, un evento singolo, una persona o un luogo.';

  @override
  String get coachMarkFilterTitle => 'Trova rapidamente le tue abitudini';

  @override
  String get coachMarkFilterDesc =>
      'Cerca per nome oppure tocca un tag per filtrare le abitudini per categoria.';

  @override
  String get coachMarkStatsTitle => 'Segui i tuoi progressi';

  @override
  String get coachMarkStatsDesc =>
      'Tocca qui l’icona del grafico per vedere serie, cronologia dei risparmi e informazioni utili sulle abitudini.';

  @override
  String get coachMarkMenuTitle => 'Impostazioni e altro';

  @override
  String get coachMarkMenuDesc =>
      'Apri le impostazioni per cambiare lingua e tema e per accedere alla guida o alla sincronizzazione cloud.';

  @override
  String get resetTutorial => 'Reimposta tutorial';

  @override
  String get tutorialResetSuccess =>
      'Tutorial reimpostato. Riavvia l app per rivedere la guida.';

  @override
  String get savingsSummary => 'Risparmi per tipo di elemento';

  @override
  String get navHome => 'Inizio';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get archivedTab => 'Archiviati';

  @override
  String get slipsTab => 'Ricadute';

  @override
  String get winsTab => 'Successi';

  @override
  String get addButtonLabel => 'Aggiungi';

  @override
  String get tapPlusToTrackFirstHabit =>
      'Tocca + per tracciare la tua prima abitudine da evitare';

  @override
  String get viewHistory => 'Vedi cronologia';

  @override
  String get costTypeLabel => 'Tipo di costo:';

  @override
  String get costMoney => 'Denaro';

  @override
  String get costMood => 'Umore';

  @override
  String get costTime => 'Tempo';

  @override
  String get streakLabel => 'Serie';

  @override
  String get slipButton => 'Ricaduta';

  @override
  String get justNow => 'Proprio ora';

  @override
  String get sortLatest => 'Piu recente';

  @override
  String get sortOldest => 'Piu vecchio';

  @override
  String get sortAvoidType => 'Tipo da evitare';

  @override
  String get sortCostType => 'Tipo di costo';

  @override
  String get avoidTypeLabel => 'Tipo da evitare:';

  @override
  String get associatedPerson => 'Persona associata:';

  @override
  String get avoidLocation => 'Luogo da evitare:';

  @override
  String get pickOnMap => 'Scegli sulla mappa';

  @override
  String get eventReminderLabel => 'Promemoria evento:';

  @override
  String get dailyReminderLabel => 'Ora del promemoria giornaliero:';

  @override
  String get setReminder => 'Imposta promemoria';

  @override
  String get setDailyReminder => 'Imposta promemoria giornaliero';

  @override
  String get selectEventDateError => 'Seleziona una data per l evento.';

  @override
  String get recentRelapsesTriggers => 'Ricadute e trigger recenti';

  @override
  String get ratingDialogTitle => 'Ti piace Avoid Todo?';

  @override
  String get ratingDialogSubtitle =>
      'Tocca una stella per valutare la tua esperienza';

  @override
  String get ratingDialogNotNow => 'Non ora';

  @override
  String get ratingDialogContinue => 'Continua';

  @override
  String get ratingHighTitle => 'Grazie!';

  @override
  String get ratingHighBody =>
      'Ti andrebbe di lasciarci una valutazione? Ci aiuta davvero molto!';

  @override
  String get ratingHighRateNow => 'Valuta ora';

  @override
  String get ratingHighNoThanks => 'No, grazie';

  @override
  String get ratingLowTitle => 'Aiutaci a migliorare';

  @override
  String get ratingLowBody => 'Cosa possiamo fare meglio?';

  @override
  String get ratingLowHint => 'Il tuo feedback...';

  @override
  String get ratingLowSend => 'Invia';

  @override
  String get ratingLowSkip => 'Salta';

  @override
  String get ratingThanks => 'Grazie per il tuo feedback!';

  @override
  String get notifications => 'Notifiche';

  @override
  String get enableNotifications => 'Abilita notifiche';

  @override
  String get drawerWidget => 'Widget';

  @override
  String get homeScreenWidget => 'Widget della schermata Home';

  @override
  String get homeScreenWidgetDesc =>
      'Mostra la tua serie migliore nella schermata Home';

  @override
  String get homeScreenWidgetPlusHint =>
      'Il widget della schermata Home e una funzione Plus.';

  @override
  String get addWidgetToHomeScreen => 'Aggiungi widget alla schermata Home';

  @override
  String get addWidgetInstructions => 'Istruzioni e pulsante rapido';

  @override
  String get cloudSync => 'Sincronizzazione cloud';

  @override
  String get cloudSyncDesc => 'Backup automatico su iCloud / Google Drive';

  @override
  String get cloudSyncPlusHint =>
      'La sincronizzazione cloud e una funzione Plus.';

  @override
  String get manageSync => 'Gestisci sincronizzazione';

  @override
  String syncCloudBackupTitle(String cloudName) {
    return 'Backup su $cloudName';
  }

  @override
  String get syncNeverSynced => 'Non ancora sincronizzato.';

  @override
  String get syncLastSynced => 'Ultima sincronizzazione:';

  @override
  String get syncUploadSuccess => '✓ Backup caricato con successo.';

  @override
  String get syncUploadFailed =>
      'Caricamento non riuscito. Controlla la connessione e riprova.';

  @override
  String get syncNoBackupFound =>
      'Nessun backup trovato nel cloud per ora. Tocca il pulsante qui sotto per crearne uno.';

  @override
  String get syncBackupFoundTitle => 'Backup trovato';

  @override
  String get syncRestoreWarning =>
      '⚠️ Questo sostituirà i dati attuali con il backup nel cloud.\n\nTutte le modifiche effettuate dopo l’ultimo backup andranno perse. Vuoi davvero ripristinarlo?';

  @override
  String get syncUploading => 'Caricamento…';

  @override
  String get syncBackupNow => 'Esegui backup ora';

  @override
  String get syncChecking => 'Controllo in corso…';

  @override
  String get syncCheckForBackup => 'Controlla e ripristina';

  @override
  String get syncHowItWorksTitle => 'Come funziona';

  @override
  String syncHowItWorksBody(String cloudName) {
    return '• I tuoi dati vengono salvati nel tuo account $cloudName; Avoid non li vede mai.\n• I backup avvengono automaticamente, al massimo ogni 10 minuti, dopo le azioni più importanti.\n• Per ripristinare su un nuovo dispositivo: installa Avoid, accedi e tocca \"Controlla e ripristina\".';
  }

  @override
  String get syncNotAvailable =>
      'La sincronizzazione cloud non e disponibile su questa piattaforma.';

  @override
  String get widgetSetupTitleIos => 'iOS - Aggiungi widget';

  @override
  String get widgetSetupTitleAndroid => 'Android - Aggiungi widget';

  @override
  String get widgetColorLabel => 'Colore del widget';

  @override
  String get colorForest => 'Foresta';

  @override
  String get colorMidnight => 'Mezzanotte';

  @override
  String get colorOcean => 'Oceano';

  @override
  String get colorPurple => 'Viola';

  @override
  String get widgetAddButton => 'Aggiungi widget alla schermata Home';

  @override
  String get widgetDialogOpened => 'Finestra del widget aperta!';

  @override
  String get widgetLauncherHint => 'Il launcher ti chiedera dove posizionarlo.';

  @override
  String get widgetFollowSteps => 'Segui questi passaggi:';

  @override
  String get widgetManualSteps =>
      'Il launcher non supporta il pulsante? Prova manualmente:';

  @override
  String get widgetDone => 'Fatto';

  @override
  String get widgetIosStep1Title => 'Vai alla schermata Home';

  @override
  String get widgetIosStep1Desc =>
      'Premi Home o scorri verso l’alto da qualsiasi app.';

  @override
  String get widgetIosStep2Title => 'Tieni premuta un’area vuota';

  @override
  String get widgetIosStep2Desc =>
      'Continua a tenere premuto finché le icone non iniziano a muoversi.';

  @override
  String get widgetIosStep3Title => 'Tocca il pulsante +';

  @override
  String get widgetIosStep3Desc => 'Nell’angolo in alto a sinistra.';

  @override
  String get widgetIosStep4Title => 'Cerca \"Avoid\"';

  @override
  String get widgetIosStep4Desc => 'Scrivilo nella barra di ricerca.';

  @override
  String get widgetIosStep5Title => 'Seleziona il widget Avoid';

  @override
  String get widgetIosStep5Desc =>
      'Toccalo, scegli una dimensione e poi tocca \"Aggiungi widget\".';

  @override
  String get widgetIosStep6Title => 'Premi Fine';

  @override
  String get widgetIosStep6Desc => 'In alto a destra per terminare.';

  @override
  String get widgetAndroidStep1Title => 'Vai alla schermata Home';

  @override
  String get widgetAndroidStep1Desc => 'Premi il pulsante Home.';

  @override
  String get widgetAndroidStep2Title => 'Tieni premuta un’area vuota';

  @override
  String get widgetAndroidStep2Desc =>
      'Tieni premuto uno spazio vuoto finché non appare la modalità di modifica.';

  @override
  String get widgetAndroidStep3Title => 'Tocca \"Widget\"';

  @override
  String get widgetAndroidStep3Desc =>
      'Guarda nella parte inferiore dello schermo.';

  @override
  String get widgetAndroidStep4Title => 'Trova \"Avoid Todo\"';

  @override
  String get widgetAndroidStep4Desc => 'Scorri fino alla sezione A.';

  @override
  String get widgetAndroidStep5Title => 'Tieni premuto e trascina';

  @override
  String get widgetAndroidStep5Desc =>
      'Trascina il widget in qualsiasi punto libero della schermata Home.';
}
