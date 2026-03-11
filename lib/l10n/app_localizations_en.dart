// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Avoid Things Todo';

  @override
  String get appTagline => 'Stay productive by avoiding!';

  @override
  String get language => 'Language';

  @override
  String get addThingToAvoid => 'Add Thing to Avoid';

  @override
  String get whatToAvoid => 'What do you need to avoid?';

  @override
  String get category => 'Category';

  @override
  String get priority => 'Priority';

  @override
  String get addToAvoidList => 'Add to Avoid List';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editItem => 'Edit Item';

  @override
  String get search => 'Search';

  @override
  String get noItemsYet => 'No items to avoid yet';

  @override
  String get archive => 'Archive';

  @override
  String get statistics => 'Statistics';

  @override
  String get menu => 'Menu';

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'Never forget what you need to avoid anymore.';

  @override
  String get close => 'Close';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get noArchivedItems => 'No archived items yet';

  @override
  String get avoidedOn => 'Avoided on';

  @override
  String get restore => 'Restore';

  @override
  String get deletePermanently => 'Delete Permanently';

  @override
  String get deleteConfirmation =>
      'This action cannot be undone. Are you sure?';

  @override
  String get delete => 'Delete';

  @override
  String get weeklyActivity => 'Weekly Activity';

  @override
  String get byCategory => 'By Category';

  @override
  String get mostAvoided => 'Most Avoided';

  @override
  String get times => 'times';

  @override
  String get avoided => 'Avoided';

  @override
  String get active => 'Active';

  @override
  String get keepGoing => 'Keep going!';

  @override
  String avoidedThisWeek(int count) {
    return '$count avoided this week';
  }

  @override
  String get goalsTitle => 'Goals';

  @override
  String get yourGoal => 'Your Goal';

  @override
  String get addGoal => 'Add Goal';

  @override
  String get addAGoal => 'Add a Goal';

  @override
  String get tapToAddGoal => 'Tap to add a goal';

  @override
  String get goalTypeStreak => 'Streak';

  @override
  String get goalTypeMonthlySavings => 'Monthly Savings';

  @override
  String get goalHabit => 'Habit';

  @override
  String get goalTargetStreakDays => 'Target streak (days)';

  @override
  String get goalTargetSavings => 'Target savings (\$)';

  @override
  String get createGoal => 'Create Goal';

  @override
  String get swipeToAvoid => 'Swipe right to mark as avoided!';

  @override
  String get itemRestored => 'Item restored to active list';

  @override
  String get itemAvoided => 'avoided!';

  @override
  String get undo => 'Undo';

  @override
  String get health => 'Health';

  @override
  String get productivity => 'Productivity';

  @override
  String get social => 'Social';

  @override
  String get other => 'Other';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get systemDefault => 'System Default';

  @override
  String get followDeviceLanguage => 'Follow device language';

  @override
  String get spanish => 'Espanol';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugues';

  @override
  String get german => 'Deutsch';

  @override
  String get avoidedLabel => 'Avoided!';

  @override
  String get totalAvoided => 'Total Avoided';

  @override
  String get byPriority => 'By Priority';

  @override
  String get moneySaved => 'Money Saved';

  @override
  String get tags => 'Tags';

  @override
  String get newTag => 'New Tag';

  @override
  String get tagName => 'Tag name';

  @override
  String get create => 'Create';

  @override
  String get relapseTrigger => 'Relapse Trigger';

  @override
  String get triggerNote => 'Trigger Note';

  @override
  String get badges => 'Badges & Milestones';

  @override
  String get badge24hTitle => '24h Freedom';

  @override
  String get badge24hDesc => 'Stayed clean for 24 hours';

  @override
  String get badge7dTitle => '7 Day Warrior';

  @override
  String get badge7dDesc => 'Stayed clean for 7 days';

  @override
  String get badgeBudgetTitle => 'Budget Saver';

  @override
  String get badgeBudgetDesc => 'Saved over \$50';

  @override
  String get badgeMegaTitle => 'Mega Saver';

  @override
  String get badgeMegaDesc => 'Saved over \$200';

  @override
  String get badgeConsistencyTitle => 'Consistency';

  @override
  String get badgeConsistencyDesc => '5+ active habits';

  @override
  String get locked => 'Locked';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get byTag => 'By Tag';

  @override
  String get isRecurring => 'Is this a recurring habit?';

  @override
  String get eventDate => 'Event Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get estimatedCostLabel => 'Estimated Cost per Relapse/Duration';

  @override
  String get relapseDialogTitle => 'Oh no! What triggered this?';

  @override
  String get relapseDialogSubtitle =>
      'Logging your triggers helps you avoid them in the future.';

  @override
  String get relapseDialogHint => 'Optional notes...';

  @override
  String get confirmRelapse => 'Confirm Relapse';

  @override
  String get relapseSuccess => 'Streak reset. Don\'t give up!';

  @override
  String get onboardingWelcomeTitle => 'Stop the Habits Holding You Back';

  @override
  String get onboardingWelcomeDesc =>
      'Most apps track what to DO. Avoid tracks what to STOP — the habits, urges, and patterns getting in your way. Add what you want to quit, log when you slip, and build streaks that matter.';

  @override
  String get onboardingTagsTitle => 'Organize with Tags';

  @override
  String get onboardingTagsDesc =>
      'Group habits by area of life — Health, Work, Social. See at a glance which part of your life needs the most attention right now.';

  @override
  String get onboardingMoneyTitle => 'Every Slip Has a Cost';

  @override
  String get onboardingMoneyDesc =>
      'Set an estimated cost per slip (e.g. a cigarette pack, a takeout meal). Avoid multiplies it by your streak to show you the real money you\'ve saved.';

  @override
  String get onboardingRelapseTitle => 'Slipped? That\'s OK — Log It';

  @override
  String get onboardingRelapseDesc =>
      'Tap Slip to record what triggered you. Over time, Avoid spots your patterns so you can get ahead of them. No judgment, just awareness.';

  @override
  String get onboardingBreakGamesTitle => 'Defuse Urges with Break Games';

  @override
  String get onboardingBreakGamesDesc =>
      'When an urge hits, tap Break on an active avoid to launch a fast 60-second reset. These tiny games and calming activities are built to interrupt autopilot before a slip happens.';

  @override
  String get onboardingBadgesTitle => 'Earn Rewards Along the Way';

  @override
  String get onboardingBadgesDesc =>
      'Unlock badges for streaks and savings milestones. Complete goals, earn XP, and level up through 100 tiers as your habits get stronger.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get help => 'Help & Guide';

  @override
  String get helpTitle => 'App Guide & FAQ';

  @override
  String get helpWhatIsAvoidTitle => 'What is Avoid?';

  @override
  String get helpWhatIsAvoidDesc =>
      'Avoid helps you break bad habits by tracking what you want to STOP doing. Add a habit, log when you slip, and note what triggered you. Over time you\'ll spot your patterns, build long streaks, and see the real impact — in money, mood, or time — of staying clean.';

  @override
  String get faq1Question => 'How do I add something to avoid?';

  @override
  String get faq1Answer =>
      'Tap the + button at the bottom right. You can add a recurring habit (like smoking or junk food), a one-time event (like skipping a party), a person to avoid, or even a location. Set an optional cost and reminder to keep yourself accountable.';

  @override
  String get faq2Question => 'What is a slip and how do I log one?';

  @override
  String get faq2Answer =>
      'A slip (relapse) is when you give in to something you\'re trying to avoid. Tap the red Slip button on any habit card. You can add a quick note about what triggered you — this builds your trigger history and helps you spot patterns over time.';

  @override
  String get faq3Question => 'How are streaks calculated?';

  @override
  String get faq3Answer =>
      'Your streak counts the days since your last slip. For recurring habits it resets each time you slip. For one-time events it tracks until you archive the item.';

  @override
  String get faq4Question => 'How does money (or time/mood) tracking work?';

  @override
  String get faq4Answer =>
      'When adding a habit, set an estimated cost per slip — in money, hours, or mood points. Avoid multiplies this by your streak duration to show the total you\'ve saved by staying clean.';

  @override
  String get faq5Question => 'What are goals and how do I use them?';

  @override
  String get faq5Answer =>
      'Goals give you a specific target, like reaching a 7-day streak on your hardest habit. Everyone gets an auto-generated goal based on their most-relapsed habit. Plus users can also create custom goals and track savings targets.';

  @override
  String get faq6Question => 'How does XP and leveling work?';

  @override
  String get faq6Answer =>
      'You earn XP by avoiding slips, completing goals, and doing the daily commitment. There are 100 levels with titles — free users progress to level 20, Plus unlocks all 100.';

  @override
  String get faq7Question => 'What is the Daily Commitment? (Plus)';

  @override
  String get faq7Answer =>
      'Plus users see a morning screen once per day to commit to their active habits. Each commitment earns +20 XP and builds a daily ritual around your goals.';

  @override
  String get faq8Question => 'Can I track people or locations to avoid?';

  @override
  String get faq8Answer =>
      'Yes! When adding a habit choose \'Person\' to link it to a contact from your phonebook, or \'Location\' to pin a spot on the map. Great for avoiding difficult people or triggering environments.';

  @override
  String get faq9Question => 'What does Avoid Plus include?';

  @override
  String get faq9Answer =>
      'Plus is a one-time purchase that unlocks: unlimited habits, full stats history & heatmap, relapse pattern analysis, custom goals, daily commitment (+XP), smart pattern-aware notifications, home screen widget, cloud backup, and data export.';

  @override
  String get faq10Question => 'Is my data stored in the cloud?';

  @override
  String get faq10Answer =>
      'No. Avoid does not process, collect, or store your habit data on our own servers. Your data stays on your device. If you enable cloud backup, it is saved to your own iCloud or Google Drive account, not to Avoid\'s cloud.';

  @override
  String get faq11Question => 'What analytics does Avoid collect?';

  @override
  String get faq11Answer =>
      'Avoid only collects basic app usage analytics, such as screen visits and major button taps, to help improve the product. It does not send your habit names, relapse notes, contact names, location names, or other personally identifiable or user-entered habit content to analytics.';

  @override
  String get faq12Question =>
      'What are Break Games and when should I use them?';

  @override
  String get faq12Answer =>
      'Break Games are short urge-interruption activities you can launch from the Break button on an active avoid. They run for about 60 seconds and are meant to distract, steady, or redirect you during the risky moment right before a slip. Some games also track personal bests, and Plus or trial access unlocks hints and random game pool controls.';

  @override
  String get coachMarkAddTitle => 'Add your first habit';

  @override
  String get coachMarkAddDesc =>
      'Tap + to add something you want to stop — a recurring habit, a one-time event, a person, or a location.';

  @override
  String get coachMarkFilterTitle => 'Find your habits fast';

  @override
  String get coachMarkFilterDesc =>
      'Search by name, or tap a tag chip to filter habits by category.';

  @override
  String get coachMarkStatsTitle => 'See your progress';

  @override
  String get coachMarkStatsDesc =>
      'Tap the chart icon here to view your streaks, savings history, and habit insights.';

  @override
  String get coachMarkMenuTitle => 'Settings & more';

  @override
  String get coachMarkMenuDesc =>
      'Open settings to change language, theme, and access the Help guide or cloud sync.';

  @override
  String get resetTutorial => 'Reset Tutorial';

  @override
  String get tutorialResetSuccess =>
      'Tutorial reset. Restart the app to see the walkthrough again.';

  @override
  String get savingsSummary => 'Savings by Item Type';

  @override
  String get navHome => 'Home';

  @override
  String get historyTitle => 'History';

  @override
  String get archivedTab => 'Archived';

  @override
  String get slipsTab => 'Slips';

  @override
  String get winsTab => 'Wins';

  @override
  String get addButtonLabel => 'Add';

  @override
  String get tapPlusToTrackFirstHabit =>
      'Tap + to track your first habit to avoid';

  @override
  String get viewHistory => 'View History';

  @override
  String get costTypeLabel => 'Cost Type:';

  @override
  String get costMoney => 'Money';

  @override
  String get costMood => 'Mood';

  @override
  String get costTime => 'Time';

  @override
  String get streakLabel => 'Streak';

  @override
  String get slipButton => 'Slip';

  @override
  String get justNow => 'Just now';

  @override
  String get sortLatest => 'Latest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortAvoidType => 'Avoid Type';

  @override
  String get sortCostType => 'Cost Type';

  @override
  String get avoidTypeLabel => 'Avoid Type:';

  @override
  String get associatedPerson => 'Associated Person:';

  @override
  String get avoidLocation => 'Avoid Location:';

  @override
  String get pickOnMap => 'Pick on Map';

  @override
  String get eventReminderLabel => 'Event Reminder:';

  @override
  String get dailyReminderLabel => 'Daily Reminder Time:';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get setDailyReminder => 'Set Daily Reminder';

  @override
  String get selectEventDateError => 'Please select an event date.';

  @override
  String get recentRelapsesTriggers => 'Recent Relapses & Triggers';

  @override
  String get ratingDialogTitle => 'Enjoying Avoid Todo?';

  @override
  String get ratingDialogSubtitle => 'Tap a star to rate your experience';

  @override
  String get ratingDialogNotNow => 'Not now';

  @override
  String get ratingDialogContinue => 'Continue';

  @override
  String get ratingHighTitle => 'Thank you!';

  @override
  String get ratingHighBody => 'Would you mind rating us? It really helps!';

  @override
  String get ratingHighRateNow => 'Rate Now';

  @override
  String get ratingHighNoThanks => 'No thanks';

  @override
  String get ratingLowTitle => 'Help us improve';

  @override
  String get ratingLowBody => 'What can we do better?';

  @override
  String get ratingLowHint => 'Your feedback...';

  @override
  String get ratingLowSend => 'Send';

  @override
  String get ratingLowSkip => 'Skip';

  @override
  String get ratingThanks => 'Thank you for your feedback!';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get drawerWidget => 'Widget';

  @override
  String get homeScreenWidget => 'Home Screen Widget';

  @override
  String get homeScreenWidgetDesc => 'Shows your top streak on the home screen';

  @override
  String get homeScreenWidgetPlusHint =>
      'Home screen widget is a Plus feature.';

  @override
  String get addWidgetToHomeScreen => 'Add widget to home screen';

  @override
  String get addWidgetInstructions => 'Instructions & quick-add button';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get cloudSyncDesc => 'Auto-backup to iCloud / Google Drive';

  @override
  String get cloudSyncPlusHint => 'Cloud sync is a Plus feature.';

  @override
  String get manageSync => 'Manage sync';

  @override
  String syncCloudBackupTitle(String cloudName) {
    return '$cloudName Backup';
  }

  @override
  String get syncNeverSynced => 'Never synced yet.';

  @override
  String get syncLastSynced => 'Last synced:';

  @override
  String get syncUploadSuccess => '✓ Backup uploaded successfully.';

  @override
  String get syncUploadFailed =>
      'Upload failed. Check your connection and try again.';

  @override
  String get syncNoBackupFound =>
      'No backup found in the cloud yet. Tap the button below to create one.';

  @override
  String get syncBackupFoundTitle => 'Backup found';

  @override
  String get syncRestoreWarning =>
      '⚠️ This will overwrite your current data with the cloud backup.\n\nAny changes made since your last backup will be lost. Are you sure you want to restore?';

  @override
  String get syncUploading => 'Uploading…';

  @override
  String get syncBackupNow => 'Back up now';

  @override
  String get syncChecking => 'Checking…';

  @override
  String get syncCheckForBackup => 'Check and Restore';

  @override
  String get syncHowItWorksTitle => 'How it works';

  @override
  String syncHowItWorksBody(String cloudName) {
    return '• Your data is backed up to your own $cloudName — Avoid never sees it.\n• Backups happen automatically (at most every 10 minutes) after major actions.\n• To restore on a new device: install Avoid, sign in, then tap \"Check and Restore\".';
  }

  @override
  String get syncNotAvailable =>
      'Cloud sync is not available on this platform.';

  @override
  String get widgetSetupTitleIos => '🍎 iOS — Add Widget';

  @override
  String get widgetSetupTitleAndroid => '🤖 Android — Add Widget';

  @override
  String get widgetColorLabel => 'Widget colour';

  @override
  String get colorForest => 'Forest';

  @override
  String get colorMidnight => 'Midnight';

  @override
  String get colorOcean => 'Ocean';

  @override
  String get colorPurple => 'Purple';

  @override
  String get widgetAddButton => 'Add Widget to Home Screen';

  @override
  String get widgetDialogOpened => 'Widget dialog opened!';

  @override
  String get widgetLauncherHint => 'Your launcher will ask where to place it.';

  @override
  String get widgetFollowSteps => 'Follow these steps:';

  @override
  String get widgetManualSteps =>
      'Launcher doesn\'t support the button? Try manually:';

  @override
  String get widgetDone => 'Done';

  @override
  String get widgetIosStep1Title => 'Go to your Home Screen';

  @override
  String get widgetIosStep1Desc => 'Press Home or swipe up from any app.';

  @override
  String get widgetIosStep2Title => 'Long-press an empty area';

  @override
  String get widgetIosStep2Desc => 'Hold until the icons start to jiggle.';

  @override
  String get widgetIosStep3Title => 'Tap the + button';

  @override
  String get widgetIosStep3Desc => 'Top-left corner.';

  @override
  String get widgetIosStep4Title => 'Search for \"Avoid\"';

  @override
  String get widgetIosStep4Desc => 'Type in the search bar.';

  @override
  String get widgetIosStep5Title => 'Select the Avoid widget';

  @override
  String get widgetIosStep5Desc =>
      'Tap it, pick a size, then tap \"Add Widget\".';

  @override
  String get widgetIosStep6Title => 'Press Done';

  @override
  String get widgetIosStep6Desc => 'Top-right corner to finish.';

  @override
  String get widgetAndroidStep1Title => 'Go to your Home Screen';

  @override
  String get widgetAndroidStep1Desc => 'Press the Home button.';

  @override
  String get widgetAndroidStep2Title => 'Long-press an empty area';

  @override
  String get widgetAndroidStep2Desc =>
      'Hold on a blank spot until edit mode appears.';

  @override
  String get widgetAndroidStep3Title => 'Tap \"Widgets\"';

  @override
  String get widgetAndroidStep3Desc => 'Look at the bottom of the screen.';

  @override
  String get widgetAndroidStep4Title => 'Find \"Avoid Todo\"';

  @override
  String get widgetAndroidStep4Desc => 'Scroll to the A section.';

  @override
  String get widgetAndroidStep5Title => 'Long-press & drag';

  @override
  String get widgetAndroidStep5Desc =>
      'Drag the widget to any empty spot on your home screen.';

  @override
  String get plusUnlockUnlimitedAvoidsHints =>
      'Unlimited avoids, break game hints';
}
