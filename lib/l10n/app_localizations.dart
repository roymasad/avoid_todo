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
  /// **'Earn Rewards Along the Way'**
  String get onboardingBadgesTitle;

  /// Onboarding slide 5 description.
  ///
  /// In en, this message translates to:
  /// **'Unlock badges for streaks and savings milestones. Complete goals, earn XP, and level up through 50 tiers as your habits get stronger.'**
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
  /// **'You earn XP by avoiding slips, completing goals, and doing the daily commitment. There are 50 levels with titles — free users progress to level 20, Plus unlocks all 50.'**
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
  /// **'Check for backup'**
  String get syncCheckForBackup;

  /// Title of the info card in the sync screen.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get syncHowItWorksTitle;

  /// Body of how-it-works card. {cloudName} is replaced at runtime with iCloud or Google Drive.
  ///
  /// In en, this message translates to:
  /// **'• Your data is backed up to your own {cloudName} — Avoid never sees it.\n• Backups happen automatically (at most every 10 minutes) after major actions.\n• To restore on a new device: install Avoid, sign in, then tap \"Check for backup\".'**
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
