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
  String get onboardingBreakGamesTitle =>
      'Disinnesca gli impulsi con i Break Games';

  @override
  String get onboardingBreakGamesDesc =>
      'Quando arriva un impulso, tocca Break su un avoid attivo per avviare un reset rapido di 60 secondi. Questi mini giochi e attività calmanti servono a interrompere il pilota automatico prima che avvenga una ricaduta.';

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
  String get faq11Question => 'Quali analisi raccoglie Avoid?';

  @override
  String get faq11Answer =>
      'Avoid raccoglie solo analisi di base sull\'uso dell\'app, come le schermate visitate e i tocchi sui pulsanti principali, per migliorare il prodotto. Non invia alle analytics i nomi delle tue abitudini, le note sulle ricadute, i nomi dei contatti, i nomi dei luoghi o altri contenuti identificabili o inseriti dall\'utente.';

  @override
  String get faq12Question => 'Cosa sono i Break Games e quando dovrei usarli?';

  @override
  String get faq12Answer =>
      'I Break Games sono brevi attività per interrompere un impulso che puoi avviare dal pulsante Break su un avoid attivo. Durano circa 60 secondi e servono a distrarti, stabilizzarti o reindirizzarti proprio nel momento rischioso prima di una ricaduta. Alcuni giochi salvano anche i tuoi record personali, e Plus o la prova sbloccano gli aiuti e il controllo del pool casuale.';

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

  @override
  String get plusUnlockUnlimitedAvoidsHints =>
      'Unlimited avoids, break game hints';

  @override
  String get breakGamesSectionTitle => 'Break Games';

  @override
  String get breakRandomGamePoolTitle => 'Pool casuale di giochi';

  @override
  String get breakGamePoolLockedSubtitle =>
      'Avvia una prova gratuita o sblocca Plus per scegliere quali Break Games possono apparire casualmente.';

  @override
  String get breakKeepAtLeastOneActivityEnabled =>
      'Mantieni attiva almeno una attività break.';

  @override
  String breakActivityEnabledCount(int enabledCount, int totalCount) {
    return '$enabledCount su $totalCount attivi';
  }

  @override
  String get breakRandomGamePoolDescription =>
      'Scegli quali attività break possono essere selezionate a caso.';

  @override
  String get breakActivityDefuseTitle => 'Disinnesca';

  @override
  String get breakActivityDefuseSubtitle =>
      'Smorza il momento disinnescando la tensione.';

  @override
  String get breakActivityPairMatchTitle => 'Trova la coppia';

  @override
  String get breakActivityPairMatchSubtitle =>
      'Porta la mente su una piccola sfida di memoria.';

  @override
  String get breakActivityCubeResetTitle => 'Reset Cubo';

  @override
  String get breakActivityCubeResetSubtitle =>
      'Riporta un piccolo cubo in ordine.';

  @override
  String get breakActivityStackSweepTitle => 'Pulisci la pila';

  @override
  String get breakActivityStackSweepSubtitle =>
      'Rimuovi le tessere esposte finché la pila non sparisce.';

  @override
  String get breakActivityTriviaPivotTitle => 'Pivot quiz';

  @override
  String get breakActivityTriviaPivotSubtitle =>
      'Dai al cervello qualcosa di diverso su cui concentrarsi.';

  @override
  String get breakActivityZenRoomTitle => 'Stanza Zen';

  @override
  String get breakActivityZenRoomSubtitle =>
      'Rallenta la scena e resetta il tono.';

  @override
  String breakPersonalBestTime(String value) {
    return 'Record: $value';
  }

  @override
  String breakPersonalBestCorrect(int count) {
    return 'Record: $count corrette';
  }

  @override
  String get breakExitTitle => 'Uscire da questa pausa?';

  @override
  String get breakExitBody =>
      'Questa sessione verrà segnata come incompleta. Puoi sempre iniziare subito un’altra pausa.';

  @override
  String get breakStay => 'Resta';

  @override
  String get breakExit => 'Esci';

  @override
  String get breakCustomizationLockedSubtitle =>
      'Avvia una prova gratuita o sblocca Plus per usare suggerimenti e personalizzazione dei Break Games.';

  @override
  String get breakHintStrengthTitle => 'Scegli l’intensità del suggerimento';

  @override
  String get breakHintStrengthBody =>
      'Vuoi solo una leggera evidenziazione o l’indizio completo con anche le frecce?';

  @override
  String get breakHintStrengthSubtle => 'Un po’ di aiuto';

  @override
  String get breakHintStrengthStrong => 'Tanto aiuto';

  @override
  String breakSheetTitle(String item) {
    return 'Pausa per \"$item\"';
  }

  @override
  String get breakThisItem => 'questo elemento';

  @override
  String get breakResume => 'Riprendi';

  @override
  String get breakPause => 'Pausa';

  @override
  String get breakDefuseInstruction =>
      'Stabilizza il quadrante. Tocca blocca quando la lancetta entra nella finestra calma.';

  @override
  String get breakDefuseTap => 'Tocca';

  @override
  String get breakDefuseCompleteStatus =>
      'Bene. Il meccanismo ora è calmo. Continua a respirare finché il minuto non finisce.';

  @override
  String breakDefuseRingsLeft(int count) {
    return 'Restano $count anelli. Resta nel ritmo.';
  }

  @override
  String get breakDefuseWaitStatus =>
      'Aspetta che la lancetta attraversi la finestra luminosa, poi tocca.';

  @override
  String get breakHintsLocked => 'Aiuti bloccati';

  @override
  String get breakHintsOn => 'Aiuti attivi';

  @override
  String get breakHintsOff => 'Aiuti disattivi';

  @override
  String get breakHintsSubtle => 'Aiuti: un po’';

  @override
  String get breakHintsStrong => 'Aiuti: molto';

  @override
  String get breakPairMatchInstruction =>
      'Trova le coppie di emoji uguali. Piccole ricerche di schemi aiutano molto a interrompere il pilota automatico.';

  @override
  String breakPairMatchProgress(int matchedCount, int totalCount) {
    return '$matchedCount coppie su $totalCount trovate';
  }

  @override
  String get breakCubeResetInstruction =>
      'Trascina per ruotare il cubo. Scorri sugli sticker visibili per girare i livelli.';

  @override
  String breakCubeResetProgress(
      int solvedCount, int totalCount, int twistCount) {
    return '$solvedCount facce su $totalCount risolte in $twistCount mosse';
  }

  @override
  String breakStackSweepTilesLeft(int count) {
    return '$count tessere rimaste';
  }

  @override
  String breakTriviaCorrectInsight(String insight) {
    return 'Corretto. $insight';
  }

  @override
  String breakTriviaIncorrectInsight(String insight) {
    return 'Bel tentativo. $insight';
  }

  @override
  String get breakNext => 'Avanti';

  @override
  String get breakZenTapDrop => 'Tocca una goccia';

  @override
  String get breakZenFooter =>
      'Prendi una goccia quando vuoi una nuova frase. I tocchi mancati non fanno nulla di proposito.';

  @override
  String get breakCheckInTitle => 'Fai il punto';

  @override
  String get breakOutcomeQuestion =>
      'Cosa è cambiato dopo questa pausa di un minuto?';

  @override
  String get breakReplayActivity => 'Rigioca attività';

  @override
  String get breakContinueActivity => 'Continua a giocare / meditare';

  @override
  String get breakOutcomePassed => 'Impulso passato';

  @override
  String get breakOutcomeWeaker => 'Impulso più debole';

  @override
  String get breakOutcomeStillStrong => 'Ancora forte';

  @override
  String get breakNeedAnotherLayer => 'Serve un altro livello?';

  @override
  String get breakTryAnotherBreak => 'Prova un’altra pausa';

  @override
  String get breakGoToZenRoom => 'Vai alla Stanza Zen';

  @override
  String get breakMessageSupport => 'Contatta il supporto';

  @override
  String get breakTriviaData =>
      'Quale pianeta ha il giorno più corto?\nTerra\nGiove\nMarte\nGiove ruota così velocemente che un suo giorno dura circa 10 ore.\n%%\nQuanti cuori ha un polpo?\nUno\nTre\nDue\nTre. Due per le branchie e uno per il resto del corpo.\n%%\nQual è l\'unico mammifero che può davvero volare?\nScoiattolo volante\nPipistrello\nPetauro dello zucchero\nI pipistrelli sono gli unici mammiferi capaci di un volo sostenuto.\n%%\nQuale oceano è il più profondo?\nAtlantico\nPacifico\nIndiano\nLa Fossa delle Marianne si trova nell\'oceano Pacifico.\n%%\nQuante ossa ha di solito un essere umano adulto?\n186\n206\n226\n206 è il numero standard dopo che alcune ossa si fondono nell\'età adulta.\n%%\nQuale animale è noto per dormire a testa in giù?\nKoala\nPipistrello\nLontra\nI pipistrelli riposano a testa in giù per poter prendere subito il volo.\n%%\nQuale gas assorbono soprattutto le piante dall\'aria?\nOssigeno\nAnidride carbonica\nElio\nLe piante usano l\'anidride carbonica durante la fotosintesi.\n%%\nQuale strumento ha di solito 88 tasti?\nViolino\nPianoforte\nFlauto\nUn pianoforte standard ha 88 tasti.\n%%\nQuanti lati ha un esagono?\n5\n6\n8\nEsa significa sei.\n%%\nQuale uccello è spesso associato alla consegna di messaggi?\nPappagallo\nPiccione\nGufo\nI piccioni viaggiatori venivano usati per inviare messaggi a lunga distanza.\n%%\nQual è l\'organo più grande del corpo umano?\nFegato\nPelle\nPolmoni\nLa pelle è l\'organo più grande del corpo.\n%%\nQuale pezzo degli scacchi si muove a L?\nAlfiere\nCavallo\nTorre\nIl cavallo è l\'unico pezzo degli scacchi che si muove a L.\n%%\nQuanti continenti ci sono?\n5\n7\n6\nIl modello standard conta sette continenti.\n%%\nChe cosa raccolgono le api dai fiori?\nSassolini\nNettare\nSale\nLe api raccolgono nettare e polline dai fiori.\n%%\nQuale mese ha meno giorni?\nAprile\nFebbraio\nNovembre\nFebbraio è il più corto, con 28 giorni nella maggior parte degli anni.\n%%\nIn quale sport si usa un volano?\nTennis\nBadminton\nSquash\nNel badminton si usa un volano invece di una palla.\n%%\nChe colore ottieni mescolando blu e giallo?\nViola\nVerde\nArancione\nBlu e giallo insieme formano il verde.\n%%\nQuale pianeta è famoso per i suoi anelli?\nVenere\nSaturno\nMercurio\nGli anelli di Saturno sono la sua caratteristica più riconoscibile.\n%%\nQuanti minuti ci sono in due ore?\n90\n120\n180\nDue ore equivalgono a 120 minuti.\n%%\nQuale creatura marina ha otto braccia?\nCalamaro\nPolpo\nStella marina\nI polpi hanno otto braccia; i calamari hanno dieci appendici.\n%%\nCome si chiama l\'acqua ghiacciata?\nVapore\nGhiaccio\nNebbia\nIl ghiaccio è acqua allo stato solido.\n%%\nDa quale direzione sorge il sole?\nNord\nEst\nOvest\nIl sole sembra sorgere a est.\n%%\nQuale mammifero passa la maggior parte della vita nell\'oceano?\nCammello\nBalena\nVolpe\nLe balene sono mammiferi marini.\n%%\nQuale forma ha tre lati?\nCerchio\nTriangolo\nRettangolo\nUn triangolo ha esattamente tre lati.\n%%\nQuale frutto essiccato diventa un\'uvetta?\nPrugna\nUva\nCiliegia\nL\'uvetta è fatta con uva essiccata.\n%%\nQual è la stella principale al centro del nostro sistema solare?\nPolaris\nIl Sole\nSirio\nIl Sole è la stella attorno a cui orbitano i nostri pianeti.\n%%\nQuanti giorni ha un anno bisestile?\n365\n366\n364\nGli anni bisestili aggiungono un giorno a febbraio per un totale di 366 giorni.\n%%\nQuale animale è noto per cambiare colore per mimetizzarsi?\nConiglio\nCamaleonte\nPinguino\nI camaleonti sono famosi per cambiare colore.\n%%\nCome si chiama la roccia fusa quando raggiunge la superficie?\nMagma\nLava\nQuarzo\nSotto terra si chiama magma; in superficie lava.\n%%\nQuale lancetta di un orologio si muove più velocemente?\nLancetta delle ore\nLancetta dei secondi\nLancetta dei minuti\nLa lancetta dei secondi compie un giro completo ogni minuto.\n%%\nQuale stagione arriva dopo la primavera nell\'emisfero nord?\nInverno\nEstate\nAutunno\nDopo la primavera arriva l\'estate.\n%%\nQuante zampe ha un ragno?\n6\n8\n10\nI ragni sono aracnidi con otto zampe.\n%%\nQuale oceano si trova tra l\'Africa e l\'Australia?\nOceano Pacifico\nOceano Indiano\nOceano Artico\nL\'oceano Indiano si trova tra Africa, Asia e Australia.\n%%\nIn cosa si trasformano i bruchi?\nLibellule\nFarfalle\nColeotteri\nMolti bruchi si trasformano in farfalle o falene.\n%%\nQuale oggetto di casa indica la temperatura?\nBussola\nTermometro\nBilancia\nUn termometro misura la temperatura.\n%%\nQuante corde ha un violino standard?\n5\n4\n6\nI violini hanno normalmente quattro corde.\n%%\nQuale pianeta è più vicino al Sole?\nMarte\nMercurio\nNettuno\nMercurio è il pianeta più vicino al Sole.\n%%\nQual è il punto di ebollizione dell\'acqua al livello del mare in gradi Celsius?\n90\n100\n110\nAl livello del mare, l\'acqua bolle a 100 °C.\n%%\nQuale animale è famoso per costruire dighe?\nLontra\nCastoro\nTalpa\nI castori costruiscono dighe con rami e fango.\n%%\nQual è l\'opposto del nord su una bussola?\nEst\nSud\nOvest\nIl sud è l\'opposto del nord.\n%%\nQuale forma non ha angoli?\nQuadrato\nCerchio\nTriangolo\nI cerchi non hanno angoli né spigoli.\n%%\nQuale pianeta è conosciuto come il pianeta rosso?\nVenere\nMarte\nUrano\nMarte appare rosso per l\'ossido di ferro presente sulla sua superficie.\n%%\nQuante ore ci sono in un giorno intero?\n12\n24\n36\nUn giorno intero dura 24 ore.\n%%\nCon cosa si scrive su una lavagna?\nInchiostro\nGesso\nPastello\nIl gesso è lo strumento classico per scrivere sulla lavagna.\n%%\nQuale animale è il più alto sulla terraferma?\nElefante\nGiraffa\nCammello\nLe giraffe sono gli animali terrestri più alti.\n%%\nQuale senso è più legato al tuo naso?\nGusto\nOlfatto\nTatto\nIl naso è collegato al senso dell\'olfatto.\n%%\nQuale utensile da cucina si usa per girare i pancake?\nFrusta\nSpatola\nMestolo\nUna spatola si usa comunemente per girare i pancake.\n%%\nQuale numero viene dopo 999?\n1001\n1000\n990\nDopo 999 viene 1000.\n%%\nQuale pianeta è il più lontano dal Sole?\nSaturno\nNettuno\nTerra\nNettuno è attualmente il pianeta riconosciuto più lontano dal Sole.\n%%\nCome si chiama una parola che significa il contrario di un\'altra?\nSinonimo\nAntonimo\nAcronimo\nUn antonimo è una parola con significato opposto.\n%%\nQuale metallo è liquido a temperatura ambiente?\nFerro\nMercurio\nArgento\nIl mercurio è uno dei pochi metalli liquidi a temperatura ambiente.\n%%\nQual è la sostanza naturale più dura sulla Terra?\nOro\nDiamante\nQuarzo\nIl diamante è il materiale naturale più duro.\n%%\nQuale gruppo sanguigno è conosciuto come donatore universale?\nAB positivo\nO negativo\nA positivo\nIl sangue O negativo può di solito essere dato in emergenza alla maggior parte delle persone.\n%%\nCome si chiamano gli animali attivi di notte?\nAcquatici\nNotturni\nMigratori\nGli animali notturni sono più attivi durante la notte.\n%%\nQuale lingua ha il maggior numero di madrelingua nel mondo?\nInglese\nCinese mandarino\nSpagnolo\nIl cinese mandarino ha il numero più alto di madrelingua al mondo.\n%%\nQuale paese è famoso per il simbolo della foglia d\'acero?\nSvezia\nCanada\nNuova Zelanda\nLa foglia d\'acero è uno dei simboli nazionali più noti del Canada.\n%%\nQual è l\'ingrediente principale del guacamole?\nCetriolo\nAvocado\nPisello\nIl guacamole è preparato soprattutto con avocado schiacciato.\n%%\nQuale pianeta ruota più di lato rispetto agli altri?\nTerra\nUrano\nGiove\nUrano ha un\'inclinazione estrema e sembra ruotare su un fianco.\n%%\nQuanti denti ha di solito un adulto, inclusi i denti del giudizio?\n28\n32\n30\nUna dentatura adulta completa comprende di solito 32 denti.\n%%\nQuale deserto è il più grande deserto caldo della Terra?\nGobi\nSahara\nMojave\nIl Sahara è il più grande deserto caldo del mondo.\n%%\nCome si chiama uno scienziato che studia le rocce?\nBiologo\nGeologo\nAstronomo\nI geologi studiano rocce, minerali e struttura della Terra.\n%%\nQuale organo pompa il sangue nel corpo?\nFegato\nCuore\nRene\nIl cuore pompa il sangue nel sistema circolatorio.\n%%\nQuale frutto ha i semi all\'esterno?\nMirtillo\nFragola\nMela\nLe fragole sono insolite perché hanno i semi all\'esterno.\n%%\nCome si chiama il processo in cui il vapore acqueo diventa liquido?\nEvaporazione\nCondensazione\nCongelamento\nLa condensazione avviene quando il vapore acqueo si raffredda e diventa liquido.\n%%\nQuale famosa muraglia fu costruita per proteggere il nord della Cina?\nMuro di Berlino\nGrande Muraglia\nVallo di Adriano\nLa Grande Muraglia cinese fu costruita ed estesa nel corso dei secoli.\n%%\nQuanti giocatori ha una squadra di calcio in campo nello stesso momento?\n9\n11\n10\nUna squadra di calcio schiera 11 giocatori, incluso il portiere.\n%%\nQuale uccello non può volare ma è famoso per vivere in Antartide?\nGabbiano\nPinguino\nFalco\nI pinguini sono uccelli incapaci di volare e fortemente associati all\'Antartide.\n%%\nQuanto fa 12 moltiplicato per 12?\n124\n144\n154\n12 per 12 fa 144.\n%%\nDi quale gas hanno bisogno gli esseri umani per respirare e vivere?\nAzoto\nOssigeno\nIdrogeno\nGli esseri umani hanno bisogno di ossigeno per respirare.\n%%\nQual è il pianeta più grande del nostro sistema solare?\nSaturno\nGiove\nNettuno\nGiove è il pianeta più grande del nostro sistema solare.\n%%\nIn quale parte del corpo si trova il femore?\nBraccio\nGamba\nCranio\nIl femore è l\'osso della coscia nella gamba.\n%%\nQuale famosa torre pende in Italia?\nTorre Eiffel\nTorre di Pisa\nTorre CN\nLa Torre di Pisa è uno dei monumenti più conosciuti d\'Italia.\n%%\nQuanti zeri ci sono in un milione?\n5\n6\n7\nUn milione si scrive 1.000.000.\n%%\nQuale animale marino è noto per avere un guscio e muoversi lentamente sulla terra?\nFoca\nTartaruga\nDelfino\nLe tartarughe marine hanno un guscio e si muovono lentamente sulla terraferma.\n%%\nCome si chiama la parte colorata dell\'occhio?\nRetina\nIride\nPupilla\nL\'iride è l\'anello colorato attorno alla pupilla.\n%%\nQuale strumento si usa per osservare stelle e pianeti?\nMicroscopio\nTelescopio\nPeriscopio\nUn telescopio è progettato per osservare oggetti lontani nello spazio.\n%%\nQuale festa è famosa per zucche e costumi?\nPasqua\nHalloween\nSan Valentino\nHalloween è associato a costumi, dolci e zucche.\n%%\nQuanto fa 100 diviso 4?\n20\n25\n40\n100 diviso 4 fa 25.\n%%\nQuale animale è conosciuto come il re della giungla?\nTigre\nLeone\nLupo\nIl leone è spesso chiamato il re della giungla.\n%%\nCosa attirano i magneti?\nLegno\nFerro\nPlastica\nI magneti attirano fortemente il ferro e alcuni altri metalli.\n%%\nQuale giorno viene dopo venerdì?\nGiovedì\nSabato\nDomenica\nDopo venerdì arriva sabato.\n%%\nQual è la montagna più alta sopra il livello del mare?\nK2\nMonte Everest\nKilimangiaro\nIl monte Everest è la montagna più alta sopra il livello del mare.\n%%\nQuale insetto brilla al buio?\nFormica\nLucciola\nCavalletta\nLe lucciole producono luce tramite bioluminescenza.\n%%\nQuanti mesi ha un anno?\n10\n12\n14\nUn anno standard ha 12 mesi.\n%%\nQuale strumento si usa per tagliare la carta nei lavoretti?\nCucchiaio\nForbici\nPennello\nLe forbici si usano comunemente per tagliare la carta.\n%%\nQuale pianeta è noto per avere una gigantesca tempesta rossa?\nMarte\nGiove\nVenere\nLa Grande Macchia Rossa di Giove è una tempesta enorme e di lunga durata.\n%%\nQual è il compito principale delle radici in una pianta?\nFar cantare i fiori\nAssorbire acqua\nCatturare la luce del sole\nLe radici aiutano ad ancorare la pianta e ad assorbire acqua e nutrienti.\n%%\nQuale forma ha quattro lati uguali e quattro angoli retti?\nTriangolo\nQuadrato\nOvale\nUn quadrato ha quattro lati uguali e quattro angoli retti.\n%%\nQuale paese è famoso per le piramidi di Giza?\nMessico\nEgitto\nIndia\nLe piramidi di Giza si trovano in Egitto.\n%%\nCome si chiama la pioggia gelata che cade in piccoli granuli?\nNebbia\nNevischio\nVapore\nIl nevischio è una precipitazione gelata che cade in piccoli granuli.\n%%\nQuale specchio d\'acqua separa Europa e Africa vicino alla Spagna?\nCanale della Manica\nStretto di Gibilterra\nStretto di Bering\nLo stretto di Gibilterra si trova tra il sud della Spagna e il nord dell\'Africa.\n%%\nQuante ruote ha una bicicletta standard?\n1\n2\n3\nUna bicicletta standard ha due ruote.\n%%\nQuale animale è noto per portare la sua casa sul dorso?\nLucertola\nLumaca\nRiccio\nUna lumaca porta il proprio guscio sul dorso.\n%%\nQual è il colore principale della clorofilla?\nRosso\nVerde\nBlu\nLa clorofilla è il pigmento verde che le piante usano per catturare la luce.\n%%\nQuale continente abitato è il più secco?\nAfrica\nAustralia\nEuropa\nL\'Australia è il continente abitato più secco.\n%%\nCome si chiama un gruppo di leoni?\nBranco\nPride\nMandria\nUn gruppo di leoni si chiama pride.\n%%\nQuale strumento ha pedali e si trova comunemente nelle chiese?\nTromba\nOrgano\nTamburo\nGli organi a canne hanno spesso sia tastiere sia pedali.\n%%\nQuale ingrediente da cucina comune fa lievitare il pane?\nSale\nLievito\nPepe\nIl lievito produce gas che aiuta l\'impasto del pane a lievitare.\n%%\nQuanto fa 7 moltiplicato per 8?\n54\n56\n58\n7 per 8 fa 56.\n%%\nQuale parte della Terra è composta soprattutto da metallo fuso?\nCrosta\nNucleo\nOceano\nIl nucleo terrestre è composto in gran parte da metallo e il suo nucleo esterno è fuso.';

  @override
  String get breakZenFortunesData =>
      'Fai prima una pausa. Lo slancio non è destino.\n%%\nL\'impulso è rumoroso. Non comanda lui.\n%%\nDai a questo momento ancora 10 respiri prima di decidere qualsiasi cosa.\n%%\nLe piccole deviazioni contano. Hai già interrotto la spirale.\n%%\nSe la tua mente è in tempesta, riduci l\'orizzonte al prossimo minuto.\n%%\nNulla di permanente va deciso dentro un\'onda temporanea.\n%%\nNon devi obbedire al primo impulso che compare.\n%%\nProva a rendere questo minuto più piccolo, più morbido e più lento.\n%%\nPuoi rimandare l\'impulso senza doverlo sconfiggere per sempre.\n%%\nLa vittoria non è perfezione. La vittoria è creare spazio.\n%%\nUn passo successivo più calmo vale più di uno drammatico.\n%%\nNota l\'impulso. Dagli un nome. Non costruirci sopra una storia.\n%%\nIl tuo sistema nervoso sta chiedendo cura, non punizione.\n%%\nUna gentile interruzione può deviare tutto il momento.\n%%\nRespira come se stessi aiutando un amico, non rimproverando te stesso.\n%%\nSe sembra tagliente, rispondi con dolcezza e struttura.\n%%\nPuoi stare a disagio senza essere in pericolo.\n%%\nIl momento è intenso. Può ancora cambiare.\n%%\nDai meno teatro al craving e più distanza.\n%%\nUn sì rimandato spesso diventa un no sereno.\n%%\nIl corpo si calma più in fretta quando smetti di litigare con lui.\n%%\nScegli il prossimo minuto, non tutto il futuro.\n%%\nRiprendi fiato prima di inseguire i pensieri.\n%%\nI tuoi progressi sono fatti di piccole interruzioni come questa.\n%%\nUna pausa non è debolezza. È guida.\n%%\nLascia passare l\'onda; non devi costruirle una casa.\n%%\nL\'impulso può bussare. Non può trasferirsi dentro.\n%%\nAbbassa la posta di questo minuto e sarà più facile da portare.\n%%\nNon sei in ritardo. Stai praticando la pausa in tempo reale.\n%%\nUn sistema nervoso più morbido prende decisioni più sagge.\n%%\nPuoi rimandare senza negare la tua umanità.\n%%\nIl craving vuole velocità. Rispondi con fermezza.\n%%\nQuesto è un punto di controllo, non un verdetto sul tuo carattere.\n%%\nResta nel corpo per un respiro prima di seguire la storia.\n%%\nUn po\' di spazio adesso è già un vero progresso.\n%%\nHai già attraversato impulsi forti senza obbedirgli.\n%%\nLa prossima azione gentile può essere molto piccola e contare comunque.\n%%\nLa calma si costruisce spesso con la ripetizione, non con la rivelazione.\n%%\nInterruzioni come questa insegnano al tuo cervello una nuova strada.\n%%\nUn minuto di distanza può evitarti un\'ora di rimpianto.\n%%\nTi è concesso volere sollievo e scegliere comunque con saggezza.\n%%\nFai meno. Rallenta. Lascia scendere prima il calore.\n%%\nLa mente si fa più quieta quando il corpo si sente più al sicuro.\n%%\nPuoi onorare ciò che senti senza metterlo in scena.\n%%\nQuesto momento non ha bisogno di dramma; ha bisogno di spazio.\n%%\nProva a sciogliere mascella, spalle e pressione del tempo.\n%%\nOra stai guidando tu, anche se la curva è dolce.\n%%\nRespira in basso e lentamente; lascia che l\'urgenza perda il suo momento.\n%%\nI craving spesso salgono in fretta e svaniscono se non li alimenti.\n%%\nQuesta pausa sta già cambiando il finale.\n%%\nNon ti serve un piano perfetto per fare un passo migliore.\n%%\nDai un po\' di noia all\'impulso e spesso si indebolisce.\n%%\nC\'è forza nel renderti meno disponibile all\'impulso.\n%%\nUn corpo calmo può contenere una mente rumorosa con più sicurezza.\n%%\nChe questo sia un reset, non un dibattito.\n%%\nIl futuro che stai proteggendo si costruisce in momenti esattamente come questo.\n%%\nAnche se fai solo slittare la spirale, conta lo stesso.\n%%\nCalma prima il sistema nervoso; il significato può aspettare.\n%%\nUna pausa saggia spesso sembra ordinaria mentre accade.\n%%\nTi stai insegnando che l\'urgenza non è autorità.\n%%\nPiccole scelte pulite costruiscono una fiducia silenziosa.\n%%\nIl sollievo più rapido non è sempre quello più vero.\n%%\nFai del prossimo respiro il tuo unico compito.\n%%\nRiduci il rumore, poi decidi.\n%%\nPuoi incontrare questo momento con meno forza.\n%%\nL\'impulso chiede attenzione; offrigli osservazione invece.\n%%\nNon esiste alcuna regola che dica che devi continuare il vecchio schema.\n%%\nAnche un rallentamento parziale è una vittoria reale.\n%%\nNon sei intrappolato nella prima emozione.\n%%\nUna decisione migliore spesso inizia con un corpo più lento.\n%%\nQui la gentilezza è permessa.\n%%\nPuoi restare curioso invece che reattivo per ancora un minuto.\n%%\nLascia che il tuo respiro dia il ritmo.\n%%\nLa tempesta nella tua testa non deve diventare il clima della tua vita.\n%%\nLa stabilità spesso è solo qualche secondo più quieto, ripetuto.';
}
