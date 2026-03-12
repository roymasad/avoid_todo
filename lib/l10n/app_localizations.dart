import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// The app name.
  ///
  /// In en, this message translates to:
  /// **'Avoid Things Todo'**
  String get appTitle;

  /// App tagline shown on onboarding.
  ///
  /// In en, this message translates to:
  /// **'Stay productive by avoiding!'**
  String get appTagline;

  /// Label for language selector.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Button to add a new habit.
  ///
  /// In en, this message translates to:
  /// **'Add Thing to Avoid'**
  String get addThingToAvoid;

  /// Input hint in add-habit dialog.
  ///
  /// In en, this message translates to:
  /// **'What do you need to avoid?'**
  String get whatToAvoid;

  /// Label for category field.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Label for priority field.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// Confirm button in add-habit dialog.
  ///
  /// In en, this message translates to:
  /// **'Add to Avoid List'**
  String get addToAvoidList;

  /// Generic cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Title of edit dialog.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// Search bar hint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Empty state message on home screen.
  ///
  /// In en, this message translates to:
  /// **'No items to avoid yet'**
  String get noItemsYet;

  /// Archive screen label.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// Statistics screen label.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Menu label.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// About menu item.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Short app description shown in About dialog.
  ///
  /// In en, this message translates to:
  /// **'Never forget what you need to avoid anymore.'**
  String get aboutDescription;

  /// Generic close button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Theme selector label.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Empty state in archive screen.
  ///
  /// In en, this message translates to:
  /// **'No archived items yet'**
  String get noArchivedItems;

  /// Label showing date item was archived.
  ///
  /// In en, this message translates to:
  /// **'Avoided on'**
  String get avoidedOn;

  /// Restore archived item button.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Permanent delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// Confirmation message before permanent delete.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure?'**
  String get deleteConfirmation;

  /// Generic delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Stats section title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// Stats section title.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// Stats section title.
  ///
  /// In en, this message translates to:
  /// **'Most Avoided'**
  String get mostAvoided;

  /// Unit suffix for count of avoidances.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// Stats label for avoided count.
  ///
  /// In en, this message translates to:
  /// **'Avoided'**
  String get avoided;

  /// Label for active habits count.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Encouragement shown in the stats preview when there are no weekly avoided items.
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get keepGoing;

  /// Stats preview label for the number of avoided items this week.
  ///
  /// In en, this message translates to:
  /// **'{count} avoided this week'**
  String avoidedThisWeek(int count);

  /// Goals section title on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsTitle;

  /// Home screen goal title for free users.
  ///
  /// In en, this message translates to:
  /// **'Your Goal'**
  String get yourGoal;

  /// Action label to add a goal.
  ///
  /// In en, this message translates to:
  /// **'Add Goal'**
  String get addGoal;

  /// Title for the add goal form.
  ///
  /// In en, this message translates to:
  /// **'Add a Goal'**
  String get addAGoal;

  /// Empty state prompt for goals.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a goal'**
  String get tapToAddGoal;

  /// Goal type label for streak goals.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get goalTypeStreak;

  /// Goal type label for monthly savings goals.
  ///
  /// In en, this message translates to:
  /// **'Monthly Savings'**
  String get goalTypeMonthlySavings;

  /// Field label for selecting a habit in the goal form.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get goalHabit;

  /// Field label for streak goal target in days.
  ///
  /// In en, this message translates to:
  /// **'Target streak (days)'**
  String get goalTargetStreakDays;

  /// Field label for savings goal target.
  ///
  /// In en, this message translates to:
  /// **'Target savings (\$)'**
  String get goalTargetSavings;

  /// Action label to create a goal.
  ///
  /// In en, this message translates to:
  /// **'Create Goal'**
  String get createGoal;

  /// Swipe hint shown on home screen.
  ///
  /// In en, this message translates to:
  /// **'Swipe right to mark as avoided!'**
  String get swipeToAvoid;

  /// Toast shown after restoring an item.
  ///
  /// In en, this message translates to:
  /// **'Item restored to active list'**
  String get itemRestored;

  /// Suffix in toast after marking item avoided.
  ///
  /// In en, this message translates to:
  /// **'avoided!'**
  String get itemAvoided;

  /// Undo action in snackbar.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Health category label.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// Productivity category label.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// Social category label.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// Other category label.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// High priority label.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Medium priority label.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Low priority label.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// English language option.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// French language option.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// System default language option.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Subtitle for system default language option.
  ///
  /// In en, this message translates to:
  /// **'Follow device language'**
  String get followDeviceLanguage;

  /// Spanish language option.
  ///
  /// In en, this message translates to:
  /// **'Espanol'**
  String get spanish;

  /// Italian language option.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// Portuguese language option.
  ///
  /// In en, this message translates to:
  /// **'Portugues'**
  String get portuguese;

  /// German language option.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Badge shown on avoided items.
  ///
  /// In en, this message translates to:
  /// **'Avoided!'**
  String get avoidedLabel;

  /// Stats label for total avoidances.
  ///
  /// In en, this message translates to:
  /// **'Total Avoided'**
  String get totalAvoided;

  /// Stats section title.
  ///
  /// In en, this message translates to:
  /// **'By Priority'**
  String get byPriority;

  /// Stats label for money saved.
  ///
  /// In en, this message translates to:
  /// **'Money Saved'**
  String get moneySaved;

  /// Tags section label.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Button to create a new tag.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get newTag;

  /// Input hint for tag name.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagName;

  /// Generic create button.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Label for relapse trigger field.
  ///
  /// In en, this message translates to:
  /// **'Relapse Trigger'**
  String get relapseTrigger;

  /// Label for trigger note field.
  ///
  /// In en, this message translates to:
  /// **'Trigger Note'**
  String get triggerNote;

  /// Badges section title.
  ///
  /// In en, this message translates to:
  /// **'Badges & Milestones'**
  String get badges;

  /// Title of 24h badge.
  ///
  /// In en, this message translates to:
  /// **'24h Freedom'**
  String get badge24hTitle;

  /// Description of 24h badge.
  ///
  /// In en, this message translates to:
  /// **'Stayed clean for 24 hours'**
  String get badge24hDesc;

  /// Title of 7-day badge.
  ///
  /// In en, this message translates to:
  /// **'7 Day Warrior'**
  String get badge7dTitle;

  /// Description of 7-day badge.
  ///
  /// In en, this message translates to:
  /// **'Stayed clean for 7 days'**
  String get badge7dDesc;

  /// Title of budget saver badge.
  ///
  /// In en, this message translates to:
  /// **'Budget Saver'**
  String get badgeBudgetTitle;

  /// Description of budget saver badge.
  ///
  /// In en, this message translates to:
  /// **'Saved over \$50'**
  String get badgeBudgetDesc;

  /// Title of mega saver badge.
  ///
  /// In en, this message translates to:
  /// **'Mega Saver'**
  String get badgeMegaTitle;

  /// Description of mega saver badge.
  ///
  /// In en, this message translates to:
  /// **'Saved over \$200'**
  String get badgeMegaDesc;

  /// Title of consistency badge.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get badgeConsistencyTitle;

  /// Description of consistency badge.
  ///
  /// In en, this message translates to:
  /// **'5+ active habits'**
  String get badgeConsistencyDesc;

  /// Label for locked badge.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// Label for unlocked badge.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// Stats section title.
  ///
  /// In en, this message translates to:
  /// **'By Tag'**
  String get byTag;

  /// Toggle label for recurring habit.
  ///
  /// In en, this message translates to:
  /// **'Is this a recurring habit?'**
  String get isRecurring;

  /// Label for one-time event date.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// Button to pick a date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Label for cost input field.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost per Relapse/Duration'**
  String get estimatedCostLabel;

  /// Title of relapse dialog.
  ///
  /// In en, this message translates to:
  /// **'Oh no! What triggered this?'**
  String get relapseDialogTitle;

  /// Subtitle of relapse dialog.
  ///
  /// In en, this message translates to:
  /// **'Logging your triggers helps you avoid them in the future.'**
  String get relapseDialogSubtitle;

  /// Hint in relapse notes field.
  ///
  /// In en, this message translates to:
  /// **'Optional notes...'**
  String get relapseDialogHint;

  /// Confirm button in relapse dialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm Relapse'**
  String get confirmRelapse;

  /// Toast shown after logging a relapse.
  ///
  /// In en, this message translates to:
  /// **'Streak reset. Don\'t give up!'**
  String get relapseSuccess;

  /// Onboarding slide 1 title.
  ///
  /// In en, this message translates to:
  /// **'Stop the Habits Holding You Back'**
  String get onboardingWelcomeTitle;

  /// Onboarding slide 1 description.
  ///
  /// In en, this message translates to:
  /// **'Most apps track what to DO. Avoid tracks what to STOP — the habits, urges, and patterns getting in your way. Add what you want to quit, log when you slip, and build streaks that matter.'**
  String get onboardingWelcomeDesc;

  /// Onboarding slide 2 title.
  ///
  /// In en, this message translates to:
  /// **'Organize with Tags'**
  String get onboardingTagsTitle;

  /// Onboarding slide 2 description.
  ///
  /// In en, this message translates to:
  /// **'Group habits by area of life — Health, Work, Social. See at a glance which part of your life needs the most attention right now.'**
  String get onboardingTagsDesc;

  /// Onboarding slide 3 title.
  ///
  /// In en, this message translates to:
  /// **'Every Slip Has a Cost'**
  String get onboardingMoneyTitle;

  /// Onboarding slide 3 description.
  ///
  /// In en, this message translates to:
  /// **'Set an estimated cost per slip (e.g. a cigarette pack, a takeout meal). Avoid multiplies it by your streak to show you the real money you\'ve saved.'**
  String get onboardingMoneyDesc;

  /// Onboarding slide 4 title.
  ///
  /// In en, this message translates to:
  /// **'Slipped? That\'s OK — Log It'**
  String get onboardingRelapseTitle;

  /// Onboarding slide 4 description.
  ///
  /// In en, this message translates to:
  /// **'Tap Slip to record what triggered you. Over time, Avoid spots your patterns so you can get ahead of them. No judgment, just awareness.'**
  String get onboardingRelapseDesc;

  /// Onboarding slide 5 title.
  ///
  /// In en, this message translates to:
  /// **'Defuse Urges with Break Games'**
  String get onboardingBreakGamesTitle;

  /// Onboarding slide 5 description.
  ///
  /// In en, this message translates to:
  /// **'When an urge hits, tap Break on an active avoid to launch a fast 60-second reset. These tiny games and calming activities are built to interrupt autopilot before a slip happens.'**
  String get onboardingBreakGamesDesc;

  /// Onboarding slide 6 title.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards Along the Way'**
  String get onboardingBadgesTitle;

  /// Onboarding slide 6 description.
  ///
  /// In en, this message translates to:
  /// **'Unlock badges for streaks and savings milestones. Complete goals, earn XP, and level up through 100 tiers as your habits get stronger.'**
  String get onboardingBadgesDesc;

  /// Button on last onboarding slide.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Next button on onboarding slides.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Skip button on onboarding slides.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Help menu item label.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get help;

  /// Title of the help screen.
  ///
  /// In en, this message translates to:
  /// **'App Guide & FAQ'**
  String get helpTitle;

  /// Help screen intro section title.
  ///
  /// In en, this message translates to:
  /// **'What is Avoid?'**
  String get helpWhatIsAvoidTitle;

  /// Help screen intro section description.
  ///
  /// In en, this message translates to:
  /// **'Avoid helps you break bad habits by tracking what you want to STOP doing. Add a habit, log when you slip, and note what triggered you. Over time you\'ll spot your patterns, build long streaks, and see the real impact — in money, mood, or time — of staying clean.'**
  String get helpWhatIsAvoidDesc;

  /// FAQ 1 question.
  ///
  /// In en, this message translates to:
  /// **'How do I add something to avoid?'**
  String get faq1Question;

  /// FAQ 1 answer.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button at the bottom right. You can add a recurring habit (like smoking or junk food), a one-time event (like skipping a party), a person to avoid, or even a location. Set an optional cost and reminder to keep yourself accountable.'**
  String get faq1Answer;

  /// FAQ 2 question.
  ///
  /// In en, this message translates to:
  /// **'What is a slip and how do I log one?'**
  String get faq2Question;

  /// FAQ 2 answer.
  ///
  /// In en, this message translates to:
  /// **'A slip (relapse) is when you give in to something you\'re trying to avoid. Tap the red Slip button on any habit card. You can add a quick note about what triggered you — this builds your trigger history and helps you spot patterns over time.'**
  String get faq2Answer;

  /// FAQ 3 question.
  ///
  /// In en, this message translates to:
  /// **'How are streaks calculated?'**
  String get faq3Question;

  /// FAQ 3 answer.
  ///
  /// In en, this message translates to:
  /// **'Your streak counts the days since your last slip. For recurring habits it resets each time you slip. For one-time events it tracks until you archive the item.'**
  String get faq3Answer;

  /// FAQ 4 question.
  ///
  /// In en, this message translates to:
  /// **'How does money (or time/mood) tracking work?'**
  String get faq4Question;

  /// FAQ 4 answer.
  ///
  /// In en, this message translates to:
  /// **'When adding a habit, set an estimated cost per slip — in money, hours, or mood points. Avoid multiplies this by your streak duration to show the total you\'ve saved by staying clean.'**
  String get faq4Answer;

  /// FAQ 5 question.
  ///
  /// In en, this message translates to:
  /// **'What are goals and how do I use them?'**
  String get faq5Question;

  /// FAQ 5 answer.
  ///
  /// In en, this message translates to:
  /// **'Goals give you a specific target, like reaching a 7-day streak on your hardest habit. Everyone gets an auto-generated goal based on their most-relapsed habit. Plus users can also create custom goals and track savings targets.'**
  String get faq5Answer;

  /// FAQ 6 question.
  ///
  /// In en, this message translates to:
  /// **'How does XP and leveling work?'**
  String get faq6Question;

  /// FAQ 6 answer.
  ///
  /// In en, this message translates to:
  /// **'You earn XP by avoiding slips, completing goals, and doing the daily commitment. There are 100 levels with titles — free users progress to level 20, Plus unlocks all 100.'**
  String get faq6Answer;

  /// FAQ 7 question.
  ///
  /// In en, this message translates to:
  /// **'What is the Daily Commitment? (Plus)'**
  String get faq7Question;

  /// FAQ 7 answer.
  ///
  /// In en, this message translates to:
  /// **'Plus users see a morning screen once per day to commit to their active habits. Each commitment earns +20 XP and builds a daily ritual around your goals.'**
  String get faq7Answer;

  /// FAQ 8 question.
  ///
  /// In en, this message translates to:
  /// **'Can I track people or locations to avoid?'**
  String get faq8Question;

  /// FAQ 8 answer.
  ///
  /// In en, this message translates to:
  /// **'Yes! When adding a habit choose \'Person\' to link it to a contact from your phonebook, or \'Location\' to pin a spot on the map. Great for avoiding difficult people or triggering environments.'**
  String get faq8Answer;

  /// FAQ 9 question.
  ///
  /// In en, this message translates to:
  /// **'What does Avoid Plus include?'**
  String get faq9Question;

  /// FAQ 9 answer.
  ///
  /// In en, this message translates to:
  /// **'Plus is a one-time purchase that unlocks: unlimited habits, full stats history & heatmap, relapse pattern analysis, custom goals, daily commitment (+XP), smart pattern-aware notifications, home screen widget, cloud backup, and data export.'**
  String get faq9Answer;

  /// FAQ 10 question.
  ///
  /// In en, this message translates to:
  /// **'Is my data stored in the cloud?'**
  String get faq10Question;

  /// FAQ 10 answer.
  ///
  /// In en, this message translates to:
  /// **'No. Avoid does not process, collect, or store your habit data on our own servers. Your data stays on your device. If you enable cloud backup, it is saved to your own iCloud or Google Drive account, not to Avoid\'s cloud.'**
  String get faq10Answer;

  /// FAQ 11 question.
  ///
  /// In en, this message translates to:
  /// **'What analytics does Avoid collect?'**
  String get faq11Question;

  /// FAQ 11 answer.
  ///
  /// In en, this message translates to:
  /// **'Avoid only collects basic app usage analytics, such as screen visits and major button taps, to help improve the product. It does not send your habit names, relapse notes, contact names, location names, or other personally identifiable or user-entered habit content to analytics.'**
  String get faq11Answer;

  /// FAQ 12 question.
  ///
  /// In en, this message translates to:
  /// **'What are Break Games and when should I use them?'**
  String get faq12Question;

  /// FAQ 12 answer.
  ///
  /// In en, this message translates to:
  /// **'Break Games are short urge-interruption activities you can launch from the Break button on an active avoid. They run for about 60 seconds and are meant to distract, steady, or redirect you during the risky moment right before a slip. Some games also track personal bests, and Plus or trial access unlocks hints and random game pool controls.'**
  String get faq12Answer;

  /// Coach mark step 1 title.
  ///
  /// In en, this message translates to:
  /// **'Add your first habit'**
  String get coachMarkAddTitle;

  /// Coach mark step 1 description.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add something you want to stop — a recurring habit, a one-time event, a person, or a location.'**
  String get coachMarkAddDesc;

  /// Coach mark step 2 title.
  ///
  /// In en, this message translates to:
  /// **'Find your habits fast'**
  String get coachMarkFilterTitle;

  /// Coach mark step 2 description.
  ///
  /// In en, this message translates to:
  /// **'Search by name, or tap a tag chip to filter habits by category.'**
  String get coachMarkFilterDesc;

  /// Coach mark step 3 title.
  ///
  /// In en, this message translates to:
  /// **'See your progress'**
  String get coachMarkStatsTitle;

  /// Coach mark step 3 description.
  ///
  /// In en, this message translates to:
  /// **'Tap the chart icon here to view your streaks, savings history, and habit insights.'**
  String get coachMarkStatsDesc;

  /// Coach mark step 4 title.
  ///
  /// In en, this message translates to:
  /// **'Settings & more'**
  String get coachMarkMenuTitle;

  /// Coach mark step 4 description.
  ///
  /// In en, this message translates to:
  /// **'Open settings to change language, theme, and access the Help guide or cloud sync.'**
  String get coachMarkMenuDesc;

  /// Menu item to reset the coach mark tutorial.
  ///
  /// In en, this message translates to:
  /// **'Reset Tutorial'**
  String get resetTutorial;

  /// Toast shown after resetting the tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial reset. Restart the app to see the walkthrough again.'**
  String get tutorialResetSuccess;

  /// Stats section title for savings breakdown.
  ///
  /// In en, this message translates to:
  /// **'Savings by Item Type'**
  String get savingsSummary;

  /// Bottom nav Home tab label.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// History screen title and bottom nav label.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// History sub-tab for archived items.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedTab;

  /// History sub-tab for relapse reflections.
  ///
  /// In en, this message translates to:
  /// **'Slips'**
  String get slipsTab;

  /// History sub-tab for success reflections.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsTab;

  /// Extended floating action button label on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButtonLabel;

  /// Empty state hint on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Tap + to track your first habit to avoid'**
  String get tapPlusToTrackFirstHabit;

  /// Button label to open the history screen.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// Label for cost type selector.
  ///
  /// In en, this message translates to:
  /// **'Cost Type:'**
  String get costTypeLabel;

  /// Money cost type option.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get costMoney;

  /// Mood cost type option.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get costMood;

  /// Time cost type option.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get costTime;

  /// Label for streak counter.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// Button to log a relapse.
  ///
  /// In en, this message translates to:
  /// **'Slip'**
  String get slipButton;

  /// Relative time label for very recent events.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Sort by latest option.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sortLatest;

  /// Sort by oldest option.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// Sort by avoid type option.
  ///
  /// In en, this message translates to:
  /// **'Avoid Type'**
  String get sortAvoidType;

  /// Sort by cost type option.
  ///
  /// In en, this message translates to:
  /// **'Cost Type'**
  String get sortCostType;

  /// Label for avoid type selector.
  ///
  /// In en, this message translates to:
  /// **'Avoid Type:'**
  String get avoidTypeLabel;

  /// Label for associated person field.
  ///
  /// In en, this message translates to:
  /// **'Associated Person:'**
  String get associatedPerson;

  /// Label for location to avoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid Location:'**
  String get avoidLocation;

  /// Button to open map picker.
  ///
  /// In en, this message translates to:
  /// **'Pick on Map'**
  String get pickOnMap;

  /// Label for event reminder setting.
  ///
  /// In en, this message translates to:
  /// **'Event Reminder:'**
  String get eventReminderLabel;

  /// Label for daily reminder time setting.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder Time:'**
  String get dailyReminderLabel;

  /// Button to set an event reminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// Button to set a daily reminder.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Reminder'**
  String get setDailyReminder;

  /// Validation error for missing event date.
  ///
  /// In en, this message translates to:
  /// **'Please select an event date.'**
  String get selectEventDateError;

  /// Stats section title for recent relapses.
  ///
  /// In en, this message translates to:
  /// **'Recent Relapses & Triggers'**
  String get recentRelapsesTriggers;

  /// Title of the app rating dialog.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Avoid Todo?'**
  String get ratingDialogTitle;

  /// Subtitle of the app rating dialog.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate your experience'**
  String get ratingDialogSubtitle;

  /// Dismiss button on rating dialog.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get ratingDialogNotNow;

  /// Continue button on rating dialog.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ratingDialogContinue;

  /// Title shown after high rating.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get ratingHighTitle;

  /// Body text after high rating.
  ///
  /// In en, this message translates to:
  /// **'Would you mind rating us? It really helps!'**
  String get ratingHighBody;

  /// Rate now button after high rating.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get ratingHighRateNow;

  /// Decline button after high rating.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get ratingHighNoThanks;

  /// Title shown after low rating.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get ratingLowTitle;

  /// Body text after low rating.
  ///
  /// In en, this message translates to:
  /// **'What can we do better?'**
  String get ratingLowBody;

  /// Input hint in low-rating feedback form.
  ///
  /// In en, this message translates to:
  /// **'Your feedback...'**
  String get ratingLowHint;

  /// Send button on low-rating feedback form.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get ratingLowSend;

  /// Skip button on low-rating feedback form.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get ratingLowSkip;

  /// Toast shown after submitting feedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get ratingThanks;

  /// Notifications section header in settings drawer.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Toggle to enable or disable notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Widget section header in settings drawer.
  ///
  /// In en, this message translates to:
  /// **'Widget'**
  String get drawerWidget;

  /// Toggle title for home screen widget.
  ///
  /// In en, this message translates to:
  /// **'Home Screen Widget'**
  String get homeScreenWidget;

  /// Subtitle for home screen widget toggle.
  ///
  /// In en, this message translates to:
  /// **'Shows your top streak on the home screen'**
  String get homeScreenWidgetDesc;

  /// Hint shown when free user taps widget toggle.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget is a Plus feature.'**
  String get homeScreenWidgetPlusHint;

  /// ListTile title for widget setup.
  ///
  /// In en, this message translates to:
  /// **'Add widget to home screen'**
  String get addWidgetToHomeScreen;

  /// Subtitle for widget setup tile.
  ///
  /// In en, this message translates to:
  /// **'Instructions & quick-add button'**
  String get addWidgetInstructions;

  /// Cloud Sync section header and toggle title.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// Subtitle for cloud sync toggle.
  ///
  /// In en, this message translates to:
  /// **'Auto-backup to iCloud / Google Drive'**
  String get cloudSyncDesc;

  /// Hint shown when free user taps cloud sync toggle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is a Plus feature.'**
  String get cloudSyncPlusHint;

  /// ListTile title for sync management screen.
  ///
  /// In en, this message translates to:
  /// **'Manage sync'**
  String get manageSync;

  /// Card header showing cloud service name. {cloudName} replaced at runtime with iCloud or Google Drive.
  ///
  /// In en, this message translates to:
  /// **'{cloudName} Backup'**
  String syncCloudBackupTitle(String cloudName);

  /// Status shown when no backup has been made.
  ///
  /// In en, this message translates to:
  /// **'Never synced yet.'**
  String get syncNeverSynced;

  /// Label before last sync timestamp.
  ///
  /// In en, this message translates to:
  /// **'Last synced:'**
  String get syncLastSynced;

  /// Status shown after successful backup upload.
  ///
  /// In en, this message translates to:
  /// **'✓ Backup uploaded successfully.'**
  String get syncUploadSuccess;

  /// Status shown after failed backup upload.
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Check your connection and try again.'**
  String get syncUploadFailed;

  /// Status when no cloud backup exists.
  ///
  /// In en, this message translates to:
  /// **'No backup found in the cloud yet. Tap the button below to create one.'**
  String get syncNoBackupFound;

  /// Dialog title when a cloud backup is available to restore.
  ///
  /// In en, this message translates to:
  /// **'Backup found'**
  String get syncBackupFoundTitle;

  /// Warning text in the restore confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'⚠️ This will overwrite your current data with the cloud backup.\n\nAny changes made since your last backup will be lost. Are you sure you want to restore?'**
  String get syncRestoreWarning;

  /// Label on backup button while uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get syncUploading;

  /// Button to trigger an immediate backup.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get syncBackupNow;

  /// Label on check button while looking for a backup.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get syncChecking;

  /// Button to look for an existing cloud backup.
  ///
  /// In en, this message translates to:
  /// **'Check and Restore'**
  String get syncCheckForBackup;

  /// Title of the info card in the sync screen.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get syncHowItWorksTitle;

  /// Body of how-it-works card. {cloudName} is replaced at runtime with iCloud or Google Drive.
  ///
  /// In en, this message translates to:
  /// **'• Your data is backed up to your own {cloudName} — Avoid never sees it.\n• Backups happen automatically (at most every 10 minutes) after major actions.\n• To restore on a new device: install Avoid, sign in, then tap \"Check and Restore\".'**
  String syncHowItWorksBody(String cloudName);

  /// Message shown when cloud sync is unsupported on the current platform.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is not available on this platform.'**
  String get syncNotAvailable;

  /// AppBar title for iOS widget setup screen.
  ///
  /// In en, this message translates to:
  /// **'🍎 iOS — Add Widget'**
  String get widgetSetupTitleIos;

  /// AppBar title for Android widget setup screen.
  ///
  /// In en, this message translates to:
  /// **'🤖 Android — Add Widget'**
  String get widgetSetupTitleAndroid;

  /// Label above the colour picker in widget setup.
  ///
  /// In en, this message translates to:
  /// **'Widget colour'**
  String get widgetColorLabel;

  /// Forest widget colour theme name.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get colorForest;

  /// Midnight widget colour theme name.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get colorMidnight;

  /// Ocean widget colour theme name.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get colorOcean;

  /// Purple widget colour theme name.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// Button to pin the widget to the home screen (Android).
  ///
  /// In en, this message translates to:
  /// **'Add Widget to Home Screen'**
  String get widgetAddButton;

  /// Label shown after the pin-widget dialog is triggered.
  ///
  /// In en, this message translates to:
  /// **'Widget dialog opened!'**
  String get widgetDialogOpened;

  /// Hint shown below the add-widget button.
  ///
  /// In en, this message translates to:
  /// **'Your launcher will ask where to place it.'**
  String get widgetLauncherHint;

  /// Header above the manual step list.
  ///
  /// In en, this message translates to:
  /// **'Follow these steps:'**
  String get widgetFollowSteps;

  /// Header shown when the launcher doesn't support pin-widget.
  ///
  /// In en, this message translates to:
  /// **'Launcher doesn\'t support the button? Try manually:'**
  String get widgetManualSteps;

  /// Done button on widget setup screen.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get widgetDone;

  /// iOS widget setup step 1 title.
  ///
  /// In en, this message translates to:
  /// **'Go to your Home Screen'**
  String get widgetIosStep1Title;

  /// iOS widget setup step 1 description.
  ///
  /// In en, this message translates to:
  /// **'Press Home or swipe up from any app.'**
  String get widgetIosStep1Desc;

  /// iOS widget setup step 2 title.
  ///
  /// In en, this message translates to:
  /// **'Long-press an empty area'**
  String get widgetIosStep2Title;

  /// iOS widget setup step 2 description.
  ///
  /// In en, this message translates to:
  /// **'Hold until the icons start to jiggle.'**
  String get widgetIosStep2Desc;

  /// iOS widget setup step 3 title.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button'**
  String get widgetIosStep3Title;

  /// iOS widget setup step 3 description.
  ///
  /// In en, this message translates to:
  /// **'Top-left corner.'**
  String get widgetIosStep3Desc;

  /// iOS widget setup step 4 title.
  ///
  /// In en, this message translates to:
  /// **'Search for \"Avoid\"'**
  String get widgetIosStep4Title;

  /// iOS widget setup step 4 description.
  ///
  /// In en, this message translates to:
  /// **'Type in the search bar.'**
  String get widgetIosStep4Desc;

  /// iOS widget setup step 5 title.
  ///
  /// In en, this message translates to:
  /// **'Select the Avoid widget'**
  String get widgetIosStep5Title;

  /// iOS widget setup step 5 description.
  ///
  /// In en, this message translates to:
  /// **'Tap it, pick a size, then tap \"Add Widget\".'**
  String get widgetIosStep5Desc;

  /// iOS widget setup step 6 title.
  ///
  /// In en, this message translates to:
  /// **'Press Done'**
  String get widgetIosStep6Title;

  /// iOS widget setup step 6 description.
  ///
  /// In en, this message translates to:
  /// **'Top-right corner to finish.'**
  String get widgetIosStep6Desc;

  /// Android widget setup step 1 title.
  ///
  /// In en, this message translates to:
  /// **'Go to your Home Screen'**
  String get widgetAndroidStep1Title;

  /// Android widget setup step 1 description.
  ///
  /// In en, this message translates to:
  /// **'Press the Home button.'**
  String get widgetAndroidStep1Desc;

  /// Android widget setup step 2 title.
  ///
  /// In en, this message translates to:
  /// **'Long-press an empty area'**
  String get widgetAndroidStep2Title;

  /// Android widget setup step 2 description.
  ///
  /// In en, this message translates to:
  /// **'Hold on a blank spot until edit mode appears.'**
  String get widgetAndroidStep2Desc;

  /// Android widget setup step 3 title.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Widgets\"'**
  String get widgetAndroidStep3Title;

  /// Android widget setup step 3 description.
  ///
  /// In en, this message translates to:
  /// **'Look at the bottom of the screen.'**
  String get widgetAndroidStep3Desc;

  /// Android widget setup step 4 title.
  ///
  /// In en, this message translates to:
  /// **'Find \"Avoid Todo\"'**
  String get widgetAndroidStep4Title;

  /// Android widget setup step 4 description.
  ///
  /// In en, this message translates to:
  /// **'Scroll to the A section.'**
  String get widgetAndroidStep4Desc;

  /// Android widget setup step 5 title.
  ///
  /// In en, this message translates to:
  /// **'Long-press & drag'**
  String get widgetAndroidStep5Title;

  /// Android widget setup step 5 description.
  ///
  /// In en, this message translates to:
  /// **'Drag the widget to any empty spot on your home screen.'**
  String get widgetAndroidStep5Desc;

  /// Benefit line in the Plus upgrade dialog for unlimited avoids and break game hints.
  ///
  /// In en, this message translates to:
  /// **'Unlimited avoids, break game hints'**
  String get plusUnlockUnlimitedAvoidsHints;

  /// Section title for break games in the drawer and settings.
  ///
  /// In en, this message translates to:
  /// **'Break Games'**
  String get breakGamesSectionTitle;

  /// Title for the break game random pool settings.
  ///
  /// In en, this message translates to:
  /// **'Random game pool'**
  String get breakRandomGamePoolTitle;

  /// Paywall subtitle shown when random break game pool customization is locked.
  ///
  /// In en, this message translates to:
  /// **'Start a free trial or unlock Plus to choose which break games appear at random.'**
  String get breakGamePoolLockedSubtitle;

  /// Snackbar message shown when the user tries to disable the final enabled break activity.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one break activity enabled.'**
  String get breakKeepAtLeastOneActivityEnabled;

  /// Summary showing how many break activities are enabled in the random pool.
  ///
  /// In en, this message translates to:
  /// **'{enabledCount} of {totalCount} enabled'**
  String breakActivityEnabledCount(int enabledCount, int totalCount);

  /// Description text for the break game random pool settings sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose which break activities can be picked at random.'**
  String get breakRandomGamePoolDescription;

  /// Title for the Defuse break activity.
  ///
  /// In en, this message translates to:
  /// **'Defuse'**
  String get breakActivityDefuseTitle;

  /// Subtitle for the Defuse break activity.
  ///
  /// In en, this message translates to:
  /// **'Burn off the edge by disarming the moment.'**
  String get breakActivityDefuseSubtitle;

  /// Title for the Pair Match break activity.
  ///
  /// In en, this message translates to:
  /// **'Pair Match'**
  String get breakActivityPairMatchTitle;

  /// Subtitle for the Pair Match break activity.
  ///
  /// In en, this message translates to:
  /// **'Quick memory reset.'**
  String get breakActivityPairMatchSubtitle;

  /// Title for the Cube Reset break activity.
  ///
  /// In en, this message translates to:
  /// **'Cube Reset'**
  String get breakActivityCubeResetTitle;

  /// Subtitle for the Cube Reset break activity.
  ///
  /// In en, this message translates to:
  /// **'Twist a tiny cube back into order.'**
  String get breakActivityCubeResetSubtitle;

  /// Title for the Stack Sweep break activity.
  ///
  /// In en, this message translates to:
  /// **'Stack Sweep'**
  String get breakActivityStackSweepTitle;

  /// Subtitle for the Stack Sweep break activity.
  ///
  /// In en, this message translates to:
  /// **'Peel away the exposed tiles until the pile is gone.'**
  String get breakActivityStackSweepSubtitle;

  /// Title for the Trivia Pivot break activity.
  ///
  /// In en, this message translates to:
  /// **'Trivia Pivot'**
  String get breakActivityTriviaPivotTitle;

  /// Subtitle for the Trivia Pivot break activity.
  ///
  /// In en, this message translates to:
  /// **'Give your brain something else to chew on.'**
  String get breakActivityTriviaPivotSubtitle;

  /// No description provided for @breakActivityFortuneCookieTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Cookie'**
  String get breakActivityFortuneCookieTitle;

  /// No description provided for @breakActivityFortuneCookieSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Crack a cookie open and scratch out a calmer next thought.'**
  String get breakActivityFortuneCookieSubtitle;

  /// Title for the Zen Room break activity.
  ///
  /// In en, this message translates to:
  /// **'Zen Room'**
  String get breakActivityZenRoomTitle;

  /// Subtitle for the Zen Room break activity.
  ///
  /// In en, this message translates to:
  /// **'Slow the scene down and reset the tone.'**
  String get breakActivityZenRoomSubtitle;

  /// Personal best label for time-based break activities.
  ///
  /// In en, this message translates to:
  /// **'Best: {value}'**
  String breakPersonalBestTime(String value);

  /// Personal best label for trivia break activities.
  ///
  /// In en, this message translates to:
  /// **'Best: {count} correct'**
  String breakPersonalBestCorrect(int count);

  /// Confirmation dialog title when leaving a break early.
  ///
  /// In en, this message translates to:
  /// **'Leave this break?'**
  String get breakExitTitle;

  /// Confirmation dialog body when leaving a break early.
  ///
  /// In en, this message translates to:
  /// **'This session will be marked as incomplete. You can always start another break right away.'**
  String get breakExitBody;

  /// Action label to stay in the current break.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get breakStay;

  /// Action label to exit the current break.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get breakExit;

  /// Paywall subtitle shown when break hints or customization are locked.
  ///
  /// In en, this message translates to:
  /// **'Start a free trial or unlock Plus to use break game hints and customization.'**
  String get breakCustomizationLockedSubtitle;

  /// Title for choosing cube hint strength.
  ///
  /// In en, this message translates to:
  /// **'Choose hint strength'**
  String get breakHintStrengthTitle;

  /// Body text for choosing cube hint strength.
  ///
  /// In en, this message translates to:
  /// **'Do you want just a gentle highlight, or the full cue with arrows too?'**
  String get breakHintStrengthBody;

  /// Option label for subtle cube hints.
  ///
  /// In en, this message translates to:
  /// **'A bit of help'**
  String get breakHintStrengthSubtle;

  /// Option label for strong cube hints.
  ///
  /// In en, this message translates to:
  /// **'A lot of help'**
  String get breakHintStrengthStrong;

  /// Header title for the active break sheet, showing the avoided item.
  ///
  /// In en, this message translates to:
  /// **'Break for \"{item}\"'**
  String breakSheetTitle(String item);

  /// Fallback label for an avoided item with no name in the break sheet title.
  ///
  /// In en, this message translates to:
  /// **'this item'**
  String get breakThisItem;

  /// Tooltip for resuming a paused break timer.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get breakResume;

  /// Tooltip for pausing an active break timer.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get breakPause;

  /// Instruction text for the Defuse break activity.
  ///
  /// In en, this message translates to:
  /// **'Steady the dial. Tap lock when the moving needle slips into the calm window.'**
  String get breakDefuseInstruction;

  /// Center button label in the Defuse break activity.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get breakDefuseTap;

  /// Status text shown after completing the Defuse activity before the timer ends.
  ///
  /// In en, this message translates to:
  /// **'Nice. The mechanism is calm now. Keep breathing while the minute finishes.'**
  String get breakDefuseCompleteStatus;

  /// Status text showing how many Defuse rings remain.
  ///
  /// In en, this message translates to:
  /// **'{count} rings left. Stay with the rhythm.'**
  String breakDefuseRingsLeft(int count);

  /// Status text instructing the user how to hit the Defuse timing window.
  ///
  /// In en, this message translates to:
  /// **'Wait for the needle to cross the glowing window, then tap it.'**
  String get breakDefuseWaitStatus;

  /// Button label when break hints are locked behind Plus.
  ///
  /// In en, this message translates to:
  /// **'Hints locked'**
  String get breakHintsLocked;

  /// Button label when break hints are enabled.
  ///
  /// In en, this message translates to:
  /// **'Hints on'**
  String get breakHintsOn;

  /// Button label when break hints are disabled.
  ///
  /// In en, this message translates to:
  /// **'Hints off'**
  String get breakHintsOff;

  /// Button label when subtle break hints are enabled.
  ///
  /// In en, this message translates to:
  /// **'Hints: a bit'**
  String get breakHintsSubtle;

  /// Button label when strong break hints are enabled.
  ///
  /// In en, this message translates to:
  /// **'Hints: a lot'**
  String get breakHintsStrong;

  /// Instruction text for the Pair Match break activity.
  ///
  /// In en, this message translates to:
  /// **'Match the emoji pairs.'**
  String get breakPairMatchInstruction;

  /// Progress text showing matched emoji pairs in Pair Match.
  ///
  /// In en, this message translates to:
  /// **'Matched {matchedCount} of {totalCount} pairs'**
  String breakPairMatchProgress(int matchedCount, int totalCount);

  /// Instruction text for the Cube Reset break activity.
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate the cube. Swipe visible stickers to turn layers.'**
  String get breakCubeResetInstruction;

  /// Progress text showing solved faces and twists in Cube Reset.
  ///
  /// In en, this message translates to:
  /// **'Solved {solvedCount} of {totalCount} faces in {twistCount} twists'**
  String breakCubeResetProgress(
      int solvedCount, int totalCount, int twistCount);

  /// Remaining tile count shown in the Stack Sweep break activity.
  ///
  /// In en, this message translates to:
  /// **'{count} tiles left'**
  String breakStackSweepTilesLeft(int count);

  /// Feedback shown after a correct trivia answer.
  ///
  /// In en, this message translates to:
  /// **'Correct. {insight}'**
  String breakTriviaCorrectInsight(String insight);

  /// Feedback shown after an incorrect trivia answer.
  ///
  /// In en, this message translates to:
  /// **'Nice try. {insight}'**
  String breakTriviaIncorrectInsight(String insight);

  /// Button label to advance to the next trivia question.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get breakNext;

  /// No description provided for @breakFortuneCookieTapStatus.
  ///
  /// In en, this message translates to:
  /// **'Tap the cookie to crack it open.'**
  String get breakFortuneCookieTapStatus;

  /// No description provided for @breakFortuneCookieTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to crack'**
  String get breakFortuneCookieTapHint;

  /// No description provided for @breakFortuneCookieScratchStatus.
  ///
  /// In en, this message translates to:
  /// **'Scratch the crumbs away to reveal the wisdom underneath.'**
  String get breakFortuneCookieScratchStatus;

  /// No description provided for @breakFortuneCookieRevealStatus.
  ///
  /// In en, this message translates to:
  /// **'Nice. Let the line land for a second.'**
  String get breakFortuneCookieRevealStatus;

  /// No description provided for @breakFortuneCookieFortuneLabel.
  ///
  /// In en, this message translates to:
  /// **'FORTUNE'**
  String get breakFortuneCookieFortuneLabel;

  /// Prompt badge shown in the Zen Room activity.
  ///
  /// In en, this message translates to:
  /// **'Tap a drop'**
  String get breakZenTapDrop;

  /// Footer instruction text for the Zen Room activity.
  ///
  /// In en, this message translates to:
  /// **'Catch a drop when you want a new line. Missed taps do nothing on purpose.'**
  String get breakZenFooter;

  /// Title for the outcome check-in screen after a break.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get breakCheckInTitle;

  /// Question shown on the outcome check-in screen after a break.
  ///
  /// In en, this message translates to:
  /// **'What changed after this one-minute break?'**
  String get breakOutcomeQuestion;

  /// Button label to replay a completed break activity.
  ///
  /// In en, this message translates to:
  /// **'Replay activity'**
  String get breakReplayActivity;

  /// Button label to continue an unfinished break activity.
  ///
  /// In en, this message translates to:
  /// **'Continue playing / meditating'**
  String get breakContinueActivity;

  /// Outcome option label when the urge passed after a break.
  ///
  /// In en, this message translates to:
  /// **'Urge passed'**
  String get breakOutcomePassed;

  /// Outcome option label when the urge feels weaker after a break.
  ///
  /// In en, this message translates to:
  /// **'Urge weaker'**
  String get breakOutcomeWeaker;

  /// Outcome option label when the urge still feels strong after a break.
  ///
  /// In en, this message translates to:
  /// **'Still strong'**
  String get breakOutcomeStillStrong;

  /// Heading for follow-up options when the urge still feels strong.
  ///
  /// In en, this message translates to:
  /// **'Need another layer?'**
  String get breakNeedAnotherLayer;

  /// Follow-up action to try another break activity.
  ///
  /// In en, this message translates to:
  /// **'Try another break'**
  String get breakTryAnotherBreak;

  /// Follow-up action to switch to the Zen Room break activity.
  ///
  /// In en, this message translates to:
  /// **'Go to Zen Room'**
  String get breakGoToZenRoom;

  /// Follow-up action to message trusted support after a break.
  ///
  /// In en, this message translates to:
  /// **'Message support'**
  String get breakMessageSupport;

  /// Localized trivia dataset for the Trivia Pivot break activity. Each record is separated by newline-percent-percent-newline and contains question, wrong option, correct option, wrong option, and insight on separate lines.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the shortest day?\nEarth\nJupiter\nMars\nJupiter spins so fast its day is roughly 10 hours.\n%%\nHow many hearts does an octopus have?\nOne\nThree\nTwo\nThree. Two for the gills and one for the body.\n%%\nWhat is the only mammal that can truly fly?\nFlying squirrel\nBat\nSugar glider\nBats are the only mammals capable of sustained flight.\n%%\nWhich ocean is the deepest?\nAtlantic\nPacific\nIndian\nThe Mariana Trench is in the Pacific Ocean.\n%%\nHow many bones does an adult human usually have?\n186\n206\n226\n206 is the standard count after bones fuse in adulthood.\n%%\nWhich animal is known for sleeping upside down?\nKoala\nBat\nOtter\nBats roost upside down to launch into flight quickly.\n%%\nWhat gas do plants mostly absorb from the air?\nOxygen\nCarbon dioxide\nHelium\nPlants use carbon dioxide during photosynthesis.\n%%\nWhich instrument usually has 88 keys?\nViolin\nPiano\nFlute\nA standard piano has 88 keys.\n%%\nHow many sides does a hexagon have?\n5\n6\n8\nHex means six.\n%%\nWhich bird is often associated with delivering messages?\nParrot\nPigeon\nOwl\nCarrier pigeons were used to send messages over long distances.\n%%\nWhat is the largest organ in the human body?\nLiver\nSkin\nLungs\nYour skin is the body’s largest organ.\n%%\nWhich chess piece can move in an L shape?\nBishop\nKnight\nRook\nThe knight is the only chess piece that jumps in an L pattern.\n%%\nHow many continents are there?\n5\n7\n6\nThe standard model counts seven continents.\n%%\nWhat do bees collect from flowers?\nPebbles\nNectar\nSalt\nBees collect nectar and pollen from flowers.\n%%\nWhich month has the fewest days?\nApril\nFebruary\nNovember\nFebruary is shortest, with 28 days in most years.\n%%\nWhich sport uses a shuttlecock?\nTennis\nBadminton\nSquash\nBadminton uses a shuttlecock instead of a ball.\n%%\nWhat color do you get by mixing blue and yellow?\nPurple\nGreen\nOrange\nBlue and yellow combine to make green.\n%%\nWhich planet is famous for its rings?\nVenus\nSaturn\nMercury\nSaturn’s rings are its most recognizable feature.\n%%\nHow many minutes are in two hours?\n90\n120\n180\nTwo hours equals 120 minutes.\n%%\nWhich sea creature has eight arms?\nSquid\nOctopus\nStarfish\nOctopuses have eight arms; squid have ten appendages.\n%%\nWhat is frozen water called?\nSteam\nIce\nMist\nIce is water in solid form.\n%%\nWhich direction does the sun rise from?\nNorth\nEast\nWest\nThe sun appears to rise in the east.\n%%\nWhich mammal spends most of its life in the ocean?\nCamel\nWhale\nFox\nWhales are marine mammals.\n%%\nWhat shape has three sides?\nCircle\nTriangle\nRectangle\nA triangle has exactly three sides.\n%%\nWhich fruit is dried to make a raisin?\nPlum\nGrape\nCherry\nRaisins are dried grapes.\n%%\nWhat is the main star at the center of our solar system?\nPolaris\nThe Sun\nSirius\nThe Sun is the star our planets orbit.\n%%\nHow many days are in a leap year?\n365\n366\n364\nLeap years add one day to February for a total of 366.\n%%\nWhich animal is known for changing color to blend in?\nRabbit\nChameleon\nPenguin\nChameleons are famous for changing color.\n%%\nWhat do you call molten rock after it reaches the surface?\nMagma\nLava\nQuartz\nUnderground it is magma; on the surface it is lava.\n%%\nWhich hand on a clock moves fastest?\nHour hand\nSecond hand\nMinute hand\nThe second hand completes a full circle every minute.\n%%\nWhich season comes after spring in the northern hemisphere?\nWinter\nSummer\nAutumn\nSummer follows spring.\n%%\nHow many legs does a spider have?\n6\n8\n10\nSpiders are arachnids with eight legs.\n%%\nWhich ocean lies between Africa and Australia?\nPacific Ocean\nIndian Ocean\nArctic Ocean\nThe Indian Ocean sits between Africa, Asia, and Australia.\n%%\nWhat do caterpillars become?\nDragonflies\nButterflies\nBeetles\nMany caterpillars transform into butterflies or moths.\n%%\nWhich household object tells you temperature?\nCompass\nThermometer\nScale\nA thermometer measures temperature.\n%%\nHow many strings does a standard violin have?\n5\n4\n6\nViolins normally have four strings.\n%%\nWhich planet is closest to the Sun?\nMars\nMercury\nNeptune\nMercury is the closest planet to the Sun.\n%%\nWhat is the boiling point of water at sea level in Celsius?\n90\n100\n110\nAt sea level, water boils at 100°C.\n%%\nWhich animal is famous for building dams?\nOtter\nBeaver\nMole\nBeavers build dams from branches and mud.\n%%\nWhat is the opposite of north on a compass?\nEast\nSouth\nWest\nSouth is opposite north.\n%%\nWhich shape has no corners?\nSquare\nCircle\nTriangle\nCircles have no corners or edges.\n%%\nWhich planet is known as the Red Planet?\nVenus\nMars\nUranus\nMars appears red because of iron oxide on its surface.\n%%\nHow many hours are in one full day?\n12\n24\n36\nA full day has 24 hours.\n%%\nWhat do you use to write on a blackboard?\nInk\nChalk\nCrayon\nChalk is the classic blackboard writing tool.\n%%\nWhich animal is the tallest on land?\nElephant\nGiraffe\nCamel\nGiraffes are the tallest land animals.\n%%\nWhich sense is most tied to your nose?\nTaste\nSmell\nTouch\nYour nose handles the sense of smell.\n%%\nWhich kitchen tool is used to flip pancakes?\nWhisk\nSpatula\nLadle\nA spatula is commonly used to flip pancakes.\n%%\nWhich number comes after 999?\n1001\n1000\n990\n999 is followed by 1000.\n%%\nWhich planet is farthest from the Sun?\nSaturn\nNeptune\nEarth\nNeptune is currently the farthest recognized planet from the Sun.\n%%\nWhat do you call a word that means the opposite of another word?\nSynonym\nAntonym\nAcronym\nAn antonym is a word with the opposite meaning.\n%%\nWhich metal is liquid at room temperature?\nIron\nMercury\nSilver\nMercury is one of the few metals that is liquid at room temperature.\n%%\nWhat is the hardest natural substance on Earth?\nGold\nDiamond\nQuartz\nDiamond is the hardest naturally occurring material.\n%%\nWhich blood type is known as the universal donor?\nAB positive\nO negative\nA positive\nO negative blood can typically be given in emergencies to most people.\n%%\nWhat do you call animals that are active at night?\nAquatic\nNocturnal\nMigratory\nNocturnal animals are most active during nighttime.\n%%\nWhich language has the most native speakers worldwide?\nEnglish\nMandarin Chinese\nSpanish\nMandarin Chinese has the highest number of native speakers.\n%%\nWhich country is famous for the maple leaf symbol?\nSweden\nCanada\nNew Zealand\nThe maple leaf is one of Canada’s best-known national symbols.\n%%\nWhat is the main ingredient in guacamole?\nCucumber\nAvocado\nPea\nGuacamole is primarily made from mashed avocado.\n%%\nWhich planet rotates on its side more than the others?\nEarth\nUranus\nJupiter\nUranus has an extreme axial tilt and appears to rotate on its side.\n%%\nHow many teeth does a typical adult human have, including wisdom teeth?\n28\n32\n30\nA full adult set usually includes 32 teeth.\n%%\nWhich desert is the largest hot desert on Earth?\nGobi\nSahara\nMojave\nThe Sahara is the world’s largest hot desert.\n%%\nWhat is the name for a scientist who studies rocks?\nBiologist\nGeologist\nAstronomer\nGeologists study rocks, minerals, and Earth’s structure.\n%%\nWhich organ pumps blood through the body?\nLiver\nHeart\nKidney\nThe heart pumps blood through the circulatory system.\n%%\nWhich fruit has seeds on the outside?\nBlueberry\nStrawberry\nApple\nStrawberries are unusual because their seeds are on the outside.\n%%\nWhat is the process of water vapor turning into liquid called?\nEvaporation\nCondensation\nFreezing\nCondensation happens when water vapor cools into liquid droplets.\n%%\nWhich famous wall was built to protect northern China?\nBerlin Wall\nGreat Wall\nHadrian’s Wall\nThe Great Wall of China was built and expanded over centuries.\n%%\nHow many players are on a soccer team on the field at one time?\n9\n11\n10\nA soccer team fields 11 players including the goalkeeper.\n%%\nWhich bird cannot fly but is famous for living in Antarctica?\nSeagull\nPenguin\nFalcon\nPenguins are flightless birds strongly associated with Antarctica.\n%%\nWhat is 12 multiplied by 12?\n124\n144\n154\n12 times 12 equals 144.\n%%\nWhich gas do humans need to breathe to live?\nNitrogen\nOxygen\nHydrogen\nHumans rely on oxygen for respiration.\n%%\nWhat is the largest planet in our solar system?\nSaturn\nJupiter\nNeptune\nJupiter is the largest planet in our solar system.\n%%\nWhich part of the body contains the femur?\nArm\nLeg\nSkull\nThe femur is the thigh bone in the leg.\n%%\nWhich famous tower leans in Italy?\nEiffel Tower\nLeaning Tower of Pisa\nCN Tower\nThe Leaning Tower of Pisa is one of Italy’s best-known landmarks.\n%%\nHow many zeros are in one million?\n5\n6\n7\nOne million is written as 1,000,000.\n%%\nWhich sea animal is known for having a shell and moving slowly on land?\nSeal\nTurtle\nDolphin\nSea turtles have shells and move slowly on land.\n%%\nWhat do you call the colored part of the eye?\nRetina\nIris\nPupil\nThe iris is the colored ring around the pupil.\n%%\nWhich instrument is used to look at stars and planets?\nMicroscope\nTelescope\nPeriscope\nA telescope is designed for viewing distant objects in space.\n%%\nWhich holiday is known for pumpkins and costumes?\nEaster\nHalloween\nValentine’s Day\nHalloween is associated with costumes, candy, and pumpkins.\n%%\nWhat is 100 divided by 4?\n20\n25\n40\n100 divided by 4 equals 25.\n%%\nWhich animal is known as the king of the jungle?\nTiger\nLion\nWolf\nThe lion is commonly called the king of the jungle.\n%%\nWhat do magnets attract?\nWood\nIron\nPlastic\nMagnets strongly attract iron and some other metals.\n%%\nWhich day comes after Friday?\nThursday\nSaturday\nSunday\nSaturday follows Friday.\n%%\nWhat is the tallest mountain above sea level?\nK2\nMount Everest\nKilimanjaro\nMount Everest is the tallest mountain above sea level.\n%%\nWhich insect glows in the dark?\nAnt\nFirefly\nGrasshopper\nFireflies produce light through bioluminescence.\n%%\nHow many months are in a year?\n10\n12\n14\nA standard year has 12 months.\n%%\nWhich tool is used to cut paper in crafts?\nSpoon\nScissors\nBrush\nScissors are commonly used to cut paper.\n%%\nWhich planet is known for having a giant red storm?\nMars\nJupiter\nVenus\nJupiter’s Great Red Spot is a massive long-lasting storm.\n%%\nWhat is the main job of roots in a plant?\nMake flowers sing\nAbsorb water\nCatch sunlight\nRoots help anchor the plant and absorb water and nutrients.\n%%\nWhich shape has four equal sides and four right angles?\nTriangle\nSquare\nOval\nA square has four equal sides and four right angles.\n%%\nWhich country is famous for the pyramids of Giza?\nMexico\nEgypt\nIndia\nThe pyramids of Giza are in Egypt.\n%%\nWhat do you call frozen rain that falls in pellets?\nFog\nSleet\nSteam\nSleet is frozen precipitation that falls as small pellets.\n%%\nWhich body of water separates Europe and Africa near Spain?\nEnglish Channel\nStrait of Gibraltar\nBering Strait\nThe Strait of Gibraltar lies between southern Spain and northern Africa.\n%%\nHow many wheels does a standard bicycle have?\n1\n2\n3\nA standard bicycle has two wheels.\n%%\nWhich animal is known for carrying its house on its back?\nLizard\nSnail\nHedgehog\nA snail carries its shell on its back.\n%%\nWhat is the main color of chlorophyll?\nRed\nGreen\nBlue\nChlorophyll is the green pigment plants use to capture light.\n%%\nWhich continent is the driest inhabited one?\nAfrica\nAustralia\nEurope\nAustralia is the driest inhabited continent.\n%%\nWhat do you call a group of lions?\nPack\nPride\nHerd\nA group of lions is called a pride.\n%%\nWhich instrument has pedals and is commonly found in churches?\nTrumpet\nOrgan\nDrum\nPipe organs often have both keyboards and pedals.\n%%\nWhich common kitchen ingredient makes bread rise?\nSalt\nYeast\nPepper\nYeast produces gas that helps bread dough rise.\n%%\nWhat is 7 multiplied by 8?\n54\n56\n58\n7 times 8 equals 56.\n%%\nWhich part of Earth is made mostly of molten metal?\nCrust\nCore\nOcean\nEarth’s core is mostly metal, and its outer core is molten.'**
  String get breakTriviaData;

  /// Localized fortune lines for the Zen Room break activity separated by newline-percent-percent-newline.
  ///
  /// In en, this message translates to:
  /// **'Pause first. Momentum is not destiny.\n%%\nThe urge is loud. It is not in charge.\n%%\nGive this moment 10 more breaths before you decide anything.\n%%\nSmall detours count. You already interrupted the spiral.\n%%\nIf your mind is storming, shrink the horizon to the next minute.\n%%\nNothing permanent needs to be decided inside a temporary wave.\n%%\nYou do not need to obey the first impulse that shows up.\n%%\nTry making this minute smaller, softer, and slower.\n%%\nYou are allowed to delay the urge without defeating it forever.\n%%\nThe win is not perfection. The win is creating space.\n%%\nA calmer next step beats a dramatic one.\n%%\nNotice the urge. Name it. Do not feed it a story.\n%%\nYour nervous system is asking for care, not punishment.\n%%\nOne gentle interruption can reroute the whole moment.\n%%\nBreathe like you are helping a friend, not scolding yourself.\n%%\nIf this feels sharp, answer with softness and structure.\n%%\nYou can be uncomfortable without being in danger.\n%%\nThe moment is intense. It is still movable.\n%%\nGive the craving less theater and more distance.\n%%\nA delayed yes often turns into a peaceful no.\n%%\nThe body settles faster when you stop arguing with it.\n%%\nChoose the next minute, not the whole future.\n%%\nCatch your breath before you catch your thoughts.\n%%\nYour progress is built out of tiny interruptions like this.\n%%\nA pause is not weakness. It is steering.\n%%\nLet the wave pass through; you do not have to build it a home.\n%%\nThe urge can knock. It does not get to move in.\n%%\nLower the stakes of this minute and it becomes easier to carry.\n%%\nYou are not behind. You are practicing the pause in real time.\n%%\nA softer nervous system makes wiser decisions.\n%%\nYou can delay without denying your humanity.\n%%\nThe craving wants speed. Answer with steadiness.\n%%\nThis is a checkpoint, not a verdict on your character.\n%%\nStay with the body for a breath before following the story.\n%%\nA little space right now is a real form of progress.\n%%\nYou have survived strong urges before without obeying them.\n%%\nThe next kind action can be very small and still count.\n%%\nCalm is often built by repetition, not revelation.\n%%\nInterruptions like this teach your brain a new route.\n%%\nA minute of distance can save an hour of regret.\n%%\nYou are allowed to want relief and still choose wisely.\n%%\nDo less. Slow down. Let the heat drop first.\n%%\nThe mind gets quieter when the body feels safer.\n%%\nYou can honor the feeling without acting it out.\n%%\nThis moment does not need drama; it needs room.\n%%\nTry loosening your jaw, your shoulders, and the timeline.\n%%\nYou are steering now, even if the turn is gentle.\n%%\nBreathe low and slow; let the urgency miss its cue.\n%%\nCravings often peak quickly and fade when not fed.\n%%\nThis pause is already changing the ending.\n%%\nYou do not need a perfect plan to take a better next step.\n%%\nGive the impulse a little boredom and it often weakens.\n%%\nThere is strength in becoming less available to the urge.\n%%\nA calm body can hold a loud mind more safely.\n%%\nLet this be a reset, not a debate.\n%%\nThe future you are protecting is built in moments exactly like this.\n%%\nIf all you do is postpone the spiral, that still matters.\n%%\nSettle the nervous system first; meaning can wait.\n%%\nA wise pause often feels ordinary while it is happening.\n%%\nYou are teaching yourself that urgency is not authority.\n%%\nSmall clean choices build quiet confidence.\n%%\nThe fastest relief is not always the truest relief.\n%%\nMake the next breath your whole assignment.\n%%\nReduce the noise, then decide.\n%%\nYou can meet this moment with less force.\n%%\nThe urge is asking for attention; give it observation instead.\n%%\nThere is no rule that says you must continue the old pattern.\n%%\nEven a partial slowdown is a meaningful win.\n%%\nYou are not trapped inside the first feeling.\n%%\nA better decision often starts with a slower body.\n%%\nGentleness is allowed here.\n%%\nYou can stay curious instead of reactive for one more minute.\n%%\nLet your breathing become the pace setter.\n%%\nThe storm in your head does not have to become weather in your life.\n%%\nStability is often just a few quieter seconds repeated.'**
  String get breakZenFortunesData;

  /// No description provided for @breakFortuneCookieWisdomsData.
  ///
  /// In en, this message translates to:
  /// **'Breathe first. The next move can wait.\n%%\nA slower minute can change the whole mood.\n%%\nDelay the urge, not your kindness.\n%%\nSmall pauses still count as strong choices.\n%%\nYou do not need to solve this moment loudly.\n%%\nLet your shoulders drop before your standards do.\n%%\nA craving is a visitor, not a boss.\n%%\nGive this wave room and it will shrink.\n%%\nGentle beats dramatic when the goal is peace.\n%%\nOne calm breath is already a new direction.\n%%\nYou can want relief without obeying the urge.\n%%\nMake the next decision from a softer body.\n%%\nThis minute deserves patience, not pressure.\n%%\nQuiet progress is still progress.\n%%\nNothing important is improved by rushing.\n%%\nStay with the breath longer than the story.\n%%\nA little space now can save a lot later.\n%%\nYou are interrupting the old route right now.\n%%\nThe urge is real. So is your choice.\n%%\nA pause is a skill, not a delay tactic.\n%%\nLet the heat cool before you answer it.\n%%\nSofter thoughts arrive after steadier breaths.\n%%\nYou are allowed to slow the scene down.\n%%\nCuriosity helps more than criticism here.\n%%\nYour future self likes this quieter version of you.\n%%\nThe first impulse is not the final truth.\n%%\nProtect the next ten minutes, not the whole year.\n%%\nA steadier body makes wiser promises.\n%%\nThis feeling can pass without becoming action.\n%%\nSlow is sometimes the bravest speed.\n%%\nYou can be uncomfortable and still be safe.\n%%\nGive the urge less attention and more distance.\n%%\nA better ending often begins with a pause.\n%%\nKind structure beats harsh pressure.\n%%\nLet the moment get smaller before you judge it.\n%%\nThe body listens when the breath gets kind.\n%%\nShort delays build long-term trust.\n%%\nYou do not owe the craving an answer now.\n%%\nPeace grows in repeated tiny choices.\n%%\nThis pause is a real win, not a placeholder.\n%%\nBreathe low. Unclench. Re-enter slowly.\n%%\nMake room for calm before making room for action.\n%%\nA gentle reset can still be powerful.\n%%\nLess urgency, more awareness.\n%%\nYou are practicing freedom in small pieces.\n%%\nOne cleaner choice can brighten the whole day.\n%%\nLet stillness do some of the work.\n%%\nA calm minute is never wasted.\n%%\nHold steady. The wave is already changing.\n%%\nSofter is not weaker. Softer is wiser.'**
  String get breakFortuneCookieWisdomsData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
