import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Avoid Things Todo'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Stay productive by avoiding!'**
  String get appTagline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @addThingToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Add Thing to Avoid'**
  String get addThingToAvoid;

  /// No description provided for @whatToAvoid.
  ///
  /// In en, this message translates to:
  /// **'What do you need to avoid?'**
  String get whatToAvoid;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @addToAvoidList.
  ///
  /// In en, this message translates to:
  /// **'Add to Avoid List'**
  String get addToAvoidList;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items to avoid yet'**
  String get noItemsYet;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Never forget what you need to avoid anymore.'**
  String get aboutDescription;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @noArchivedItems.
  ///
  /// In en, this message translates to:
  /// **'No archived items yet'**
  String get noArchivedItems;

  /// No description provided for @avoidedOn.
  ///
  /// In en, this message translates to:
  /// **'Avoided on'**
  String get avoidedOn;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure?'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @mostAvoided.
  ///
  /// In en, this message translates to:
  /// **'Most Avoided'**
  String get mostAvoided;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @avoided.
  ///
  /// In en, this message translates to:
  /// **'Avoided'**
  String get avoided;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @swipeToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Swipe right to mark as avoided!'**
  String get swipeToAvoid;

  /// No description provided for @itemRestored.
  ///
  /// In en, this message translates to:
  /// **'Item restored to active list'**
  String get itemRestored;

  /// No description provided for @itemAvoided.
  ///
  /// In en, this message translates to:
  /// **'avoided!'**
  String get itemAvoided;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @avoidedLabel.
  ///
  /// In en, this message translates to:
  /// **'Avoided!'**
  String get avoidedLabel;

  /// No description provided for @totalAvoided.
  ///
  /// In en, this message translates to:
  /// **'Total Avoided'**
  String get totalAvoided;

  /// No description provided for @byPriority.
  ///
  /// In en, this message translates to:
  /// **'By Priority'**
  String get byPriority;

  /// No description provided for @moneySaved.
  ///
  /// In en, this message translates to:
  /// **'Money Saved'**
  String get moneySaved;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get newTag;

  /// No description provided for @tagName.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @relapseTrigger.
  ///
  /// In en, this message translates to:
  /// **'Relapse Trigger'**
  String get relapseTrigger;

  /// No description provided for @triggerNote.
  ///
  /// In en, this message translates to:
  /// **'Trigger Note'**
  String get triggerNote;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges & Milestones'**
  String get badges;

  /// No description provided for @badge24hTitle.
  ///
  /// In en, this message translates to:
  /// **'24h Freedom'**
  String get badge24hTitle;

  /// No description provided for @badge24hDesc.
  ///
  /// In en, this message translates to:
  /// **'Stayed clean for 24 hours'**
  String get badge24hDesc;

  /// No description provided for @badge7dTitle.
  ///
  /// In en, this message translates to:
  /// **'7 Day Warrior'**
  String get badge7dTitle;

  /// No description provided for @badge7dDesc.
  ///
  /// In en, this message translates to:
  /// **'Stayed clean for 7 days'**
  String get badge7dDesc;

  /// No description provided for @badgeBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Saver'**
  String get badgeBudgetTitle;

  /// No description provided for @badgeBudgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Saved over \$50'**
  String get badgeBudgetDesc;

  /// No description provided for @badgeMegaTitle.
  ///
  /// In en, this message translates to:
  /// **'Mega Saver'**
  String get badgeMegaTitle;

  /// No description provided for @badgeMegaDesc.
  ///
  /// In en, this message translates to:
  /// **'Saved over \$200'**
  String get badgeMegaDesc;

  /// No description provided for @badgeConsistencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get badgeConsistencyTitle;

  /// No description provided for @badgeConsistencyDesc.
  ///
  /// In en, this message translates to:
  /// **'5+ active habits'**
  String get badgeConsistencyDesc;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @byTag.
  ///
  /// In en, this message translates to:
  /// **'By Tag'**
  String get byTag;

  /// No description provided for @isRecurring.
  ///
  /// In en, this message translates to:
  /// **'Is this a recurring habit?'**
  String get isRecurring;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @estimatedCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost per Relapse/Duration'**
  String get estimatedCostLabel;

  /// No description provided for @relapseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Oh no! What triggered this?'**
  String get relapseDialogTitle;

  /// No description provided for @relapseDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Logging your triggers helps you avoid them in the future.'**
  String get relapseDialogSubtitle;

  /// No description provided for @relapseDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes...'**
  String get relapseDialogHint;

  /// No description provided for @confirmRelapse.
  ///
  /// In en, this message translates to:
  /// **'Confirm Relapse'**
  String get confirmRelapse;

  /// No description provided for @relapseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Streak reset. Don\'t give up!'**
  String get relapseSuccess;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Avoid ToDo'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'A different kind of productivity app. Focus on what you should STOP doing to live a better life.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize with Tags'**
  String get onboardingTagsTitle;

  /// No description provided for @onboardingTagsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create custom categories to track different areas of your life like Health, Work, or Social habits.'**
  String get onboardingTagsDesc;

  /// No description provided for @onboardingMoneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Your Savings'**
  String get onboardingMoneyTitle;

  /// No description provided for @onboardingMoneyDesc.
  ///
  /// In en, this message translates to:
  /// **'See the real financial impact of your habits. Every avoided relapse is money in your pocket!'**
  String get onboardingMoneyDesc;

  /// No description provided for @onboardingRelapseTitle.
  ///
  /// In en, this message translates to:
  /// **'Understand Your Triggers'**
  String get onboardingRelapseTitle;

  /// No description provided for @onboardingRelapseDesc.
  ///
  /// In en, this message translates to:
  /// **'Log relapses and notes to identify what causes them. Knowledge is power in breaking habits.'**
  String get onboardingRelapseDesc;

  /// No description provided for @onboardingBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Earn Achievement Badges'**
  String get onboardingBadgesTitle;

  /// No description provided for @onboardingBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated with milestones for long streaks and significant savings. You\'ve got this!'**
  String get onboardingBadgesDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get help;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'App Guide & FAQ'**
  String get helpTitle;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How are streaks calculated?'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Streaks for recurring habits start from your last completion or relapse. For single events, they track until you archive the goal.'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'How does money tracking work?'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Set an estimated cost for each habit. We multiply this by your successful streak duration to show total savings.'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'Can I edit my tags?'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes! Long-press any tag in the filter or edit screen to manage your custom tags.'**
  String get faq3Answer;

  /// No description provided for @coachMarkAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Track a new habit'**
  String get coachMarkAddTitle;

  /// No description provided for @coachMarkAddDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add something you want to avoid.'**
  String get coachMarkAddDesc;

  /// No description provided for @coachMarkFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter your list'**
  String get coachMarkFilterTitle;

  /// No description provided for @coachMarkFilterDesc.
  ///
  /// In en, this message translates to:
  /// **'Search by name or filter by tags to find specific items.'**
  String get coachMarkFilterDesc;

  /// No description provided for @coachMarkMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore more'**
  String get coachMarkMenuTitle;

  /// No description provided for @coachMarkMenuDesc.
  ///
  /// In en, this message translates to:
  /// **'Open the menu to view Statistics, Archive, and this Help guide.'**
  String get coachMarkMenuDesc;

  /// No description provided for @resetTutorial.
  ///
  /// In en, this message translates to:
  /// **'Reset Tutorial'**
  String get resetTutorial;

  /// No description provided for @tutorialResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tutorial reset. Restart the app to see the walkthrough again.'**
  String get tutorialResetSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
