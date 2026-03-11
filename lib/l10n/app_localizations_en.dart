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

  @override
  String get breakGamesSectionTitle => 'Break Games';

  @override
  String get breakRandomGamePoolTitle => 'Random game pool';

  @override
  String get breakGamePoolLockedSubtitle =>
      'Start a free trial or unlock Plus to choose which break games appear at random.';

  @override
  String get breakKeepAtLeastOneActivityEnabled =>
      'Keep at least one break activity enabled.';

  @override
  String breakActivityEnabledCount(int enabledCount, int totalCount) {
    return '$enabledCount of $totalCount enabled';
  }

  @override
  String get breakRandomGamePoolDescription =>
      'Choose which break activities can be picked at random.';

  @override
  String get breakActivityDefuseTitle => 'Defuse';

  @override
  String get breakActivityDefuseSubtitle =>
      'Burn off the edge by disarming the moment.';

  @override
  String get breakActivityPairMatchTitle => 'Pair Match';

  @override
  String get breakActivityPairMatchSubtitle =>
      'Shift your mind into a tiny memory challenge.';

  @override
  String get breakActivityCubeResetTitle => 'Cube Reset';

  @override
  String get breakActivityCubeResetSubtitle =>
      'Twist a tiny cube back into order.';

  @override
  String get breakActivityStackSweepTitle => 'Stack Sweep';

  @override
  String get breakActivityStackSweepSubtitle =>
      'Peel away the exposed tiles until the pile is gone.';

  @override
  String get breakActivityTriviaPivotTitle => 'Trivia Pivot';

  @override
  String get breakActivityTriviaPivotSubtitle =>
      'Give your brain something else to chew on.';

  @override
  String get breakActivityFortuneCookieTitle => 'Fortune Cookie';

  @override
  String get breakActivityFortuneCookieSubtitle =>
      'Crack a cookie open and scratch out a calmer next thought.';

  @override
  String get breakActivityZenRoomTitle => 'Zen Room';

  @override
  String get breakActivityZenRoomSubtitle =>
      'Slow the scene down and reset the tone.';

  @override
  String breakPersonalBestTime(String value) {
    return 'Best: $value';
  }

  @override
  String breakPersonalBestCorrect(int count) {
    return 'Best: $count correct';
  }

  @override
  String get breakExitTitle => 'Leave this break?';

  @override
  String get breakExitBody =>
      'This session will be marked as incomplete. You can always start another break right away.';

  @override
  String get breakStay => 'Stay';

  @override
  String get breakExit => 'Exit';

  @override
  String get breakCustomizationLockedSubtitle =>
      'Start a free trial or unlock Plus to use break game hints and customization.';

  @override
  String get breakHintStrengthTitle => 'Choose hint strength';

  @override
  String get breakHintStrengthBody =>
      'Do you want just a gentle highlight, or the full cue with arrows too?';

  @override
  String get breakHintStrengthSubtle => 'A bit of help';

  @override
  String get breakHintStrengthStrong => 'A lot of help';

  @override
  String breakSheetTitle(String item) {
    return 'Break for \"$item\"';
  }

  @override
  String get breakThisItem => 'this item';

  @override
  String get breakResume => 'Resume';

  @override
  String get breakPause => 'Pause';

  @override
  String get breakDefuseInstruction =>
      'Steady the dial. Tap lock when the moving needle slips into the calm window.';

  @override
  String get breakDefuseTap => 'Tap';

  @override
  String get breakDefuseCompleteStatus =>
      'Nice. The mechanism is calm now. Keep breathing while the minute finishes.';

  @override
  String breakDefuseRingsLeft(int count) {
    return '$count rings left. Stay with the rhythm.';
  }

  @override
  String get breakDefuseWaitStatus =>
      'Wait for the needle to cross the glowing window, then tap it.';

  @override
  String get breakHintsLocked => 'Hints locked';

  @override
  String get breakHintsOn => 'Hints on';

  @override
  String get breakHintsOff => 'Hints off';

  @override
  String get breakHintsSubtle => 'Hints: a bit';

  @override
  String get breakHintsStrong => 'Hints: a lot';

  @override
  String get breakPairMatchInstruction =>
      'Find the matching emoji pairs. Tiny pattern searches are great at breaking autopilot.';

  @override
  String breakPairMatchProgress(int matchedCount, int totalCount) {
    return 'Matched $matchedCount of $totalCount pairs';
  }

  @override
  String get breakCubeResetInstruction =>
      'Drag to rotate the cube. Swipe visible stickers to turn layers.';

  @override
  String breakCubeResetProgress(
      int solvedCount, int totalCount, int twistCount) {
    return 'Solved $solvedCount of $totalCount faces in $twistCount twists';
  }

  @override
  String breakStackSweepTilesLeft(int count) {
    return '$count tiles left';
  }

  @override
  String breakTriviaCorrectInsight(String insight) {
    return 'Correct. $insight';
  }

  @override
  String breakTriviaIncorrectInsight(String insight) {
    return 'Nice try. $insight';
  }

  @override
  String get breakNext => 'Next';

  @override
  String get breakFortuneCookieTapStatus => 'Tap the cookie to crack it open.';

  @override
  String get breakFortuneCookieTapHint => 'Tap to crack';

  @override
  String get breakFortuneCookieScratchStatus =>
      'Scratch the crumbs away to reveal the wisdom underneath.';

  @override
  String get breakFortuneCookieRevealStatus =>
      'Nice. Let the line land for a second.';

  @override
  String get breakFortuneCookieFortuneLabel => 'FORTUNE';

  @override
  String get breakZenTapDrop => 'Tap a drop';

  @override
  String get breakZenFooter =>
      'Catch a drop when you want a new line. Missed taps do nothing on purpose.';

  @override
  String get breakCheckInTitle => 'Check in';

  @override
  String get breakOutcomeQuestion =>
      'What changed after this one-minute break?';

  @override
  String get breakReplayActivity => 'Replay activity';

  @override
  String get breakContinueActivity => 'Continue playing / meditating';

  @override
  String get breakOutcomePassed => 'Urge passed';

  @override
  String get breakOutcomeWeaker => 'Urge weaker';

  @override
  String get breakOutcomeStillStrong => 'Still strong';

  @override
  String get breakNeedAnotherLayer => 'Need another layer?';

  @override
  String get breakTryAnotherBreak => 'Try another break';

  @override
  String get breakGoToZenRoom => 'Go to Zen Room';

  @override
  String get breakMessageSupport => 'Message support';

  @override
  String get breakTriviaData =>
      'Which planet has the shortest day?\nEarth\nJupiter\nMars\nJupiter spins so fast its day is roughly 10 hours.\n%%\nHow many hearts does an octopus have?\nOne\nThree\nTwo\nThree. Two for the gills and one for the body.\n%%\nWhat is the only mammal that can truly fly?\nFlying squirrel\nBat\nSugar glider\nBats are the only mammals capable of sustained flight.\n%%\nWhich ocean is the deepest?\nAtlantic\nPacific\nIndian\nThe Mariana Trench is in the Pacific Ocean.\n%%\nHow many bones does an adult human usually have?\n186\n206\n226\n206 is the standard count after bones fuse in adulthood.\n%%\nWhich animal is known for sleeping upside down?\nKoala\nBat\nOtter\nBats roost upside down to launch into flight quickly.\n%%\nWhat gas do plants mostly absorb from the air?\nOxygen\nCarbon dioxide\nHelium\nPlants use carbon dioxide during photosynthesis.\n%%\nWhich instrument usually has 88 keys?\nViolin\nPiano\nFlute\nA standard piano has 88 keys.\n%%\nHow many sides does a hexagon have?\n5\n6\n8\nHex means six.\n%%\nWhich bird is often associated with delivering messages?\nParrot\nPigeon\nOwl\nCarrier pigeons were used to send messages over long distances.\n%%\nWhat is the largest organ in the human body?\nLiver\nSkin\nLungs\nYour skin is the body’s largest organ.\n%%\nWhich chess piece can move in an L shape?\nBishop\nKnight\nRook\nThe knight is the only chess piece that jumps in an L pattern.\n%%\nHow many continents are there?\n5\n7\n6\nThe standard model counts seven continents.\n%%\nWhat do bees collect from flowers?\nPebbles\nNectar\nSalt\nBees collect nectar and pollen from flowers.\n%%\nWhich month has the fewest days?\nApril\nFebruary\nNovember\nFebruary is shortest, with 28 days in most years.\n%%\nWhich sport uses a shuttlecock?\nTennis\nBadminton\nSquash\nBadminton uses a shuttlecock instead of a ball.\n%%\nWhat color do you get by mixing blue and yellow?\nPurple\nGreen\nOrange\nBlue and yellow combine to make green.\n%%\nWhich planet is famous for its rings?\nVenus\nSaturn\nMercury\nSaturn’s rings are its most recognizable feature.\n%%\nHow many minutes are in two hours?\n90\n120\n180\nTwo hours equals 120 minutes.\n%%\nWhich sea creature has eight arms?\nSquid\nOctopus\nStarfish\nOctopuses have eight arms; squid have ten appendages.\n%%\nWhat is frozen water called?\nSteam\nIce\nMist\nIce is water in solid form.\n%%\nWhich direction does the sun rise from?\nNorth\nEast\nWest\nThe sun appears to rise in the east.\n%%\nWhich mammal spends most of its life in the ocean?\nCamel\nWhale\nFox\nWhales are marine mammals.\n%%\nWhat shape has three sides?\nCircle\nTriangle\nRectangle\nA triangle has exactly three sides.\n%%\nWhich fruit is dried to make a raisin?\nPlum\nGrape\nCherry\nRaisins are dried grapes.\n%%\nWhat is the main star at the center of our solar system?\nPolaris\nThe Sun\nSirius\nThe Sun is the star our planets orbit.\n%%\nHow many days are in a leap year?\n365\n366\n364\nLeap years add one day to February for a total of 366.\n%%\nWhich animal is known for changing color to blend in?\nRabbit\nChameleon\nPenguin\nChameleons are famous for changing color.\n%%\nWhat do you call molten rock after it reaches the surface?\nMagma\nLava\nQuartz\nUnderground it is magma; on the surface it is lava.\n%%\nWhich hand on a clock moves fastest?\nHour hand\nSecond hand\nMinute hand\nThe second hand completes a full circle every minute.\n%%\nWhich season comes after spring in the northern hemisphere?\nWinter\nSummer\nAutumn\nSummer follows spring.\n%%\nHow many legs does a spider have?\n6\n8\n10\nSpiders are arachnids with eight legs.\n%%\nWhich ocean lies between Africa and Australia?\nPacific Ocean\nIndian Ocean\nArctic Ocean\nThe Indian Ocean sits between Africa, Asia, and Australia.\n%%\nWhat do caterpillars become?\nDragonflies\nButterflies\nBeetles\nMany caterpillars transform into butterflies or moths.\n%%\nWhich household object tells you temperature?\nCompass\nThermometer\nScale\nA thermometer measures temperature.\n%%\nHow many strings does a standard violin have?\n5\n4\n6\nViolins normally have four strings.\n%%\nWhich planet is closest to the Sun?\nMars\nMercury\nNeptune\nMercury is the closest planet to the Sun.\n%%\nWhat is the boiling point of water at sea level in Celsius?\n90\n100\n110\nAt sea level, water boils at 100°C.\n%%\nWhich animal is famous for building dams?\nOtter\nBeaver\nMole\nBeavers build dams from branches and mud.\n%%\nWhat is the opposite of north on a compass?\nEast\nSouth\nWest\nSouth is opposite north.\n%%\nWhich shape has no corners?\nSquare\nCircle\nTriangle\nCircles have no corners or edges.\n%%\nWhich planet is known as the Red Planet?\nVenus\nMars\nUranus\nMars appears red because of iron oxide on its surface.\n%%\nHow many hours are in one full day?\n12\n24\n36\nA full day has 24 hours.\n%%\nWhat do you use to write on a blackboard?\nInk\nChalk\nCrayon\nChalk is the classic blackboard writing tool.\n%%\nWhich animal is the tallest on land?\nElephant\nGiraffe\nCamel\nGiraffes are the tallest land animals.\n%%\nWhich sense is most tied to your nose?\nTaste\nSmell\nTouch\nYour nose handles the sense of smell.\n%%\nWhich kitchen tool is used to flip pancakes?\nWhisk\nSpatula\nLadle\nA spatula is commonly used to flip pancakes.\n%%\nWhich number comes after 999?\n1001\n1000\n990\n999 is followed by 1000.\n%%\nWhich planet is farthest from the Sun?\nSaturn\nNeptune\nEarth\nNeptune is currently the farthest recognized planet from the Sun.\n%%\nWhat do you call a word that means the opposite of another word?\nSynonym\nAntonym\nAcronym\nAn antonym is a word with the opposite meaning.\n%%\nWhich metal is liquid at room temperature?\nIron\nMercury\nSilver\nMercury is one of the few metals that is liquid at room temperature.\n%%\nWhat is the hardest natural substance on Earth?\nGold\nDiamond\nQuartz\nDiamond is the hardest naturally occurring material.\n%%\nWhich blood type is known as the universal donor?\nAB positive\nO negative\nA positive\nO negative blood can typically be given in emergencies to most people.\n%%\nWhat do you call animals that are active at night?\nAquatic\nNocturnal\nMigratory\nNocturnal animals are most active during nighttime.\n%%\nWhich language has the most native speakers worldwide?\nEnglish\nMandarin Chinese\nSpanish\nMandarin Chinese has the highest number of native speakers.\n%%\nWhich country is famous for the maple leaf symbol?\nSweden\nCanada\nNew Zealand\nThe maple leaf is one of Canada’s best-known national symbols.\n%%\nWhat is the main ingredient in guacamole?\nCucumber\nAvocado\nPea\nGuacamole is primarily made from mashed avocado.\n%%\nWhich planet rotates on its side more than the others?\nEarth\nUranus\nJupiter\nUranus has an extreme axial tilt and appears to rotate on its side.\n%%\nHow many teeth does a typical adult human have, including wisdom teeth?\n28\n32\n30\nA full adult set usually includes 32 teeth.\n%%\nWhich desert is the largest hot desert on Earth?\nGobi\nSahara\nMojave\nThe Sahara is the world’s largest hot desert.\n%%\nWhat is the name for a scientist who studies rocks?\nBiologist\nGeologist\nAstronomer\nGeologists study rocks, minerals, and Earth’s structure.\n%%\nWhich organ pumps blood through the body?\nLiver\nHeart\nKidney\nThe heart pumps blood through the circulatory system.\n%%\nWhich fruit has seeds on the outside?\nBlueberry\nStrawberry\nApple\nStrawberries are unusual because their seeds are on the outside.\n%%\nWhat is the process of water vapor turning into liquid called?\nEvaporation\nCondensation\nFreezing\nCondensation happens when water vapor cools into liquid droplets.\n%%\nWhich famous wall was built to protect northern China?\nBerlin Wall\nGreat Wall\nHadrian’s Wall\nThe Great Wall of China was built and expanded over centuries.\n%%\nHow many players are on a soccer team on the field at one time?\n9\n11\n10\nA soccer team fields 11 players including the goalkeeper.\n%%\nWhich bird cannot fly but is famous for living in Antarctica?\nSeagull\nPenguin\nFalcon\nPenguins are flightless birds strongly associated with Antarctica.\n%%\nWhat is 12 multiplied by 12?\n124\n144\n154\n12 times 12 equals 144.\n%%\nWhich gas do humans need to breathe to live?\nNitrogen\nOxygen\nHydrogen\nHumans rely on oxygen for respiration.\n%%\nWhat is the largest planet in our solar system?\nSaturn\nJupiter\nNeptune\nJupiter is the largest planet in our solar system.\n%%\nWhich part of the body contains the femur?\nArm\nLeg\nSkull\nThe femur is the thigh bone in the leg.\n%%\nWhich famous tower leans in Italy?\nEiffel Tower\nLeaning Tower of Pisa\nCN Tower\nThe Leaning Tower of Pisa is one of Italy’s best-known landmarks.\n%%\nHow many zeros are in one million?\n5\n6\n7\nOne million is written as 1,000,000.\n%%\nWhich sea animal is known for having a shell and moving slowly on land?\nSeal\nTurtle\nDolphin\nSea turtles have shells and move slowly on land.\n%%\nWhat do you call the colored part of the eye?\nRetina\nIris\nPupil\nThe iris is the colored ring around the pupil.\n%%\nWhich instrument is used to look at stars and planets?\nMicroscope\nTelescope\nPeriscope\nA telescope is designed for viewing distant objects in space.\n%%\nWhich holiday is known for pumpkins and costumes?\nEaster\nHalloween\nValentine’s Day\nHalloween is associated with costumes, candy, and pumpkins.\n%%\nWhat is 100 divided by 4?\n20\n25\n40\n100 divided by 4 equals 25.\n%%\nWhich animal is known as the king of the jungle?\nTiger\nLion\nWolf\nThe lion is commonly called the king of the jungle.\n%%\nWhat do magnets attract?\nWood\nIron\nPlastic\nMagnets strongly attract iron and some other metals.\n%%\nWhich day comes after Friday?\nThursday\nSaturday\nSunday\nSaturday follows Friday.\n%%\nWhat is the tallest mountain above sea level?\nK2\nMount Everest\nKilimanjaro\nMount Everest is the tallest mountain above sea level.\n%%\nWhich insect glows in the dark?\nAnt\nFirefly\nGrasshopper\nFireflies produce light through bioluminescence.\n%%\nHow many months are in a year?\n10\n12\n14\nA standard year has 12 months.\n%%\nWhich tool is used to cut paper in crafts?\nSpoon\nScissors\nBrush\nScissors are commonly used to cut paper.\n%%\nWhich planet is known for having a giant red storm?\nMars\nJupiter\nVenus\nJupiter’s Great Red Spot is a massive long-lasting storm.\n%%\nWhat is the main job of roots in a plant?\nMake flowers sing\nAbsorb water\nCatch sunlight\nRoots help anchor the plant and absorb water and nutrients.\n%%\nWhich shape has four equal sides and four right angles?\nTriangle\nSquare\nOval\nA square has four equal sides and four right angles.\n%%\nWhich country is famous for the pyramids of Giza?\nMexico\nEgypt\nIndia\nThe pyramids of Giza are in Egypt.\n%%\nWhat do you call frozen rain that falls in pellets?\nFog\nSleet\nSteam\nSleet is frozen precipitation that falls as small pellets.\n%%\nWhich body of water separates Europe and Africa near Spain?\nEnglish Channel\nStrait of Gibraltar\nBering Strait\nThe Strait of Gibraltar lies between southern Spain and northern Africa.\n%%\nHow many wheels does a standard bicycle have?\n1\n2\n3\nA standard bicycle has two wheels.\n%%\nWhich animal is known for carrying its house on its back?\nLizard\nSnail\nHedgehog\nA snail carries its shell on its back.\n%%\nWhat is the main color of chlorophyll?\nRed\nGreen\nBlue\nChlorophyll is the green pigment plants use to capture light.\n%%\nWhich continent is the driest inhabited one?\nAfrica\nAustralia\nEurope\nAustralia is the driest inhabited continent.\n%%\nWhat do you call a group of lions?\nPack\nPride\nHerd\nA group of lions is called a pride.\n%%\nWhich instrument has pedals and is commonly found in churches?\nTrumpet\nOrgan\nDrum\nPipe organs often have both keyboards and pedals.\n%%\nWhich common kitchen ingredient makes bread rise?\nSalt\nYeast\nPepper\nYeast produces gas that helps bread dough rise.\n%%\nWhat is 7 multiplied by 8?\n54\n56\n58\n7 times 8 equals 56.\n%%\nWhich part of Earth is made mostly of molten metal?\nCrust\nCore\nOcean\nEarth’s core is mostly metal, and its outer core is molten.';

  @override
  String get breakZenFortunesData =>
      'Pause first. Momentum is not destiny.\n%%\nThe urge is loud. It is not in charge.\n%%\nGive this moment 10 more breaths before you decide anything.\n%%\nSmall detours count. You already interrupted the spiral.\n%%\nIf your mind is storming, shrink the horizon to the next minute.\n%%\nNothing permanent needs to be decided inside a temporary wave.\n%%\nYou do not need to obey the first impulse that shows up.\n%%\nTry making this minute smaller, softer, and slower.\n%%\nYou are allowed to delay the urge without defeating it forever.\n%%\nThe win is not perfection. The win is creating space.\n%%\nA calmer next step beats a dramatic one.\n%%\nNotice the urge. Name it. Do not feed it a story.\n%%\nYour nervous system is asking for care, not punishment.\n%%\nOne gentle interruption can reroute the whole moment.\n%%\nBreathe like you are helping a friend, not scolding yourself.\n%%\nIf this feels sharp, answer with softness and structure.\n%%\nYou can be uncomfortable without being in danger.\n%%\nThe moment is intense. It is still movable.\n%%\nGive the craving less theater and more distance.\n%%\nA delayed yes often turns into a peaceful no.\n%%\nThe body settles faster when you stop arguing with it.\n%%\nChoose the next minute, not the whole future.\n%%\nCatch your breath before you catch your thoughts.\n%%\nYour progress is built out of tiny interruptions like this.\n%%\nA pause is not weakness. It is steering.\n%%\nLet the wave pass through; you do not have to build it a home.\n%%\nThe urge can knock. It does not get to move in.\n%%\nLower the stakes of this minute and it becomes easier to carry.\n%%\nYou are not behind. You are practicing the pause in real time.\n%%\nA softer nervous system makes wiser decisions.\n%%\nYou can delay without denying your humanity.\n%%\nThe craving wants speed. Answer with steadiness.\n%%\nThis is a checkpoint, not a verdict on your character.\n%%\nStay with the body for a breath before following the story.\n%%\nA little space right now is a real form of progress.\n%%\nYou have survived strong urges before without obeying them.\n%%\nThe next kind action can be very small and still count.\n%%\nCalm is often built by repetition, not revelation.\n%%\nInterruptions like this teach your brain a new route.\n%%\nA minute of distance can save an hour of regret.\n%%\nYou are allowed to want relief and still choose wisely.\n%%\nDo less. Slow down. Let the heat drop first.\n%%\nThe mind gets quieter when the body feels safer.\n%%\nYou can honor the feeling without acting it out.\n%%\nThis moment does not need drama; it needs room.\n%%\nTry loosening your jaw, your shoulders, and the timeline.\n%%\nYou are steering now, even if the turn is gentle.\n%%\nBreathe low and slow; let the urgency miss its cue.\n%%\nCravings often peak quickly and fade when not fed.\n%%\nThis pause is already changing the ending.\n%%\nYou do not need a perfect plan to take a better next step.\n%%\nGive the impulse a little boredom and it often weakens.\n%%\nThere is strength in becoming less available to the urge.\n%%\nA calm body can hold a loud mind more safely.\n%%\nLet this be a reset, not a debate.\n%%\nThe future you are protecting is built in moments exactly like this.\n%%\nIf all you do is postpone the spiral, that still matters.\n%%\nSettle the nervous system first; meaning can wait.\n%%\nA wise pause often feels ordinary while it is happening.\n%%\nYou are teaching yourself that urgency is not authority.\n%%\nSmall clean choices build quiet confidence.\n%%\nThe fastest relief is not always the truest relief.\n%%\nMake the next breath your whole assignment.\n%%\nReduce the noise, then decide.\n%%\nYou can meet this moment with less force.\n%%\nThe urge is asking for attention; give it observation instead.\n%%\nThere is no rule that says you must continue the old pattern.\n%%\nEven a partial slowdown is a meaningful win.\n%%\nYou are not trapped inside the first feeling.\n%%\nA better decision often starts with a slower body.\n%%\nGentleness is allowed here.\n%%\nYou can stay curious instead of reactive for one more minute.\n%%\nLet your breathing become the pace setter.\n%%\nThe storm in your head does not have to become weather in your life.\n%%\nStability is often just a few quieter seconds repeated.';

  @override
  String get breakFortuneCookieWisdomsData =>
      'Breathe first. The next move can wait.\n%%\nA slower minute can change the whole mood.\n%%\nDelay the urge, not your kindness.\n%%\nSmall pauses still count as strong choices.\n%%\nYou do not need to solve this moment loudly.\n%%\nLet your shoulders drop before your standards do.\n%%\nA craving is a visitor, not a boss.\n%%\nGive this wave room and it will shrink.\n%%\nGentle beats dramatic when the goal is peace.\n%%\nOne calm breath is already a new direction.\n%%\nYou can want relief without obeying the urge.\n%%\nMake the next decision from a softer body.\n%%\nThis minute deserves patience, not pressure.\n%%\nQuiet progress is still progress.\n%%\nNothing important is improved by rushing.\n%%\nStay with the breath longer than the story.\n%%\nA little space now can save a lot later.\n%%\nYou are interrupting the old route right now.\n%%\nThe urge is real. So is your choice.\n%%\nA pause is a skill, not a delay tactic.\n%%\nLet the heat cool before you answer it.\n%%\nSofter thoughts arrive after steadier breaths.\n%%\nYou are allowed to slow the scene down.\n%%\nCuriosity helps more than criticism here.\n%%\nYour future self likes this quieter version of you.\n%%\nThe first impulse is not the final truth.\n%%\nProtect the next ten minutes, not the whole year.\n%%\nA steadier body makes wiser promises.\n%%\nThis feeling can pass without becoming action.\n%%\nSlow is sometimes the bravest speed.\n%%\nYou can be uncomfortable and still be safe.\n%%\nGive the urge less attention and more distance.\n%%\nA better ending often begins with a pause.\n%%\nKind structure beats harsh pressure.\n%%\nLet the moment get smaller before you judge it.\n%%\nThe body listens when the breath gets kind.\n%%\nShort delays build long-term trust.\n%%\nYou do not owe the craving an answer now.\n%%\nPeace grows in repeated tiny choices.\n%%\nThis pause is a real win, not a placeholder.\n%%\nBreathe low. Unclench. Re-enter slowly.\n%%\nMake room for calm before making room for action.\n%%\nA gentle reset can still be powerful.\n%%\nLess urgency, more awareness.\n%%\nYou are practicing freedom in small pieces.\n%%\nOne cleaner choice can brighten the whole day.\n%%\nLet stillness do some of the work.\n%%\nA calm minute is never wasted.\n%%\nHold steady. The wave is already changing.\n%%\nSofter is not weaker. Softer is wiser.';
}
