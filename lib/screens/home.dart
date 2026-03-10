import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../model/relapse_log.dart';
import '../constants/colors.dart';
import '../constants/themes.dart';
import '../constants/tips.dart';
import '../widgets/todo_item.dart';
import '../helpers/database_helper.dart';
import '../helpers/notification_helper.dart';
import '../providers/theme_provider.dart';
import '../providers/purchase_provider.dart';
import '../providers/xp_provider.dart';
import '../helpers/xp_helper.dart';
import '../providers/goal_provider.dart';
import '../helpers/goal_helper.dart';
import '../model/goal.dart';
import '../model/trusted_support_contact.dart';
import '../l10n/app_localizations.dart';
import 'archive_screen.dart';
import 'statistics_screen.dart';
import 'daily_commitment_screen.dart';
import 'widget_setup_screen.dart';
import 'sync_screen.dart';
import '../helpers/home_widget_helper.dart';
import '../helpers/sync_helper.dart';
import 'help_screen.dart';
import 'map_picker_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../helpers/rating_helper.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/language_settings_tile.dart';
import '../widgets/plus_upgrade_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../helpers/trusted_support_helper.dart';
// Note: Map implementation uses simple location names for now.

enum SortOption { latest, oldest, avoidType, costType, priority }

enum CommitmentPromptFrequency { daily, weekly, never }

class _TrustedSupportChoice {
  final String contactId;
  final String contactName;
  final TrustedSupportChannel channel;
  final String destinationValue;
  final String destinationLabel;

  const _TrustedSupportChoice({
    required this.contactId,
    required this.contactName,
    required this.channel,
    required this.destinationValue,
    required this.destinationLabel,
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  static final Color _fabBaseColor = Color.alphaBlend(
    Colors.white.withValues(alpha: 0.08),
    tdAvoidRed,
  );

  List<ToDo> todosList = [];
  late List<ToDo> _foundToDo = [];
  bool _isLoading = true;
  final _todoController = TextEditingController();
  int _statsRefreshVersion = 0;
  final _searchController = TextEditingController();
  final _costController = TextEditingController();
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _fabSheenAnimation;
  late AnimationController _swipeHintController;
  late Animation<Offset> _swipeHintAnimation;
  bool _swipeHintPlayed = false;
  Timer? _swipeHintTimer;
  bool _commitmentCheckDone = false; // Phase 1C: only check once per session
  CommitmentPromptFrequency _commitmentPromptFrequency =
      CommitmentPromptFrequency.daily;

  // Coach Marks Keys
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey<ArchiveScreenState> _archiveKey =
      GlobalKey<ArchiveScreenState>();

  AvoidType _selectedType = AvoidType.generic;
  String? _selectedContactId;
  String? _locationName;
  double? _latitude;
  double? _longitude;
  DateTime? _reminderDateTime;

  List<TargetFocus> targets = [];
  bool _coachMarkScheduled = false;

  // Filters
  List<String> _selectedTagIds = [];
  TodoPriority _selectedPriority = TodoPriority.medium;
  List<Tag> _allTags = [];

  // Notification setting
  bool _notificationsEnabled = true;

  // Phase 4: Home screen widget
  bool _widgetEnabled = false;

  // Phase 6: Cloud sync
  bool _syncEnabled = false;
  TrustedSupportContact? _trustedSupportContact;

  // Phase 1 New Fields
  bool _isRecurring = true;
  DateTime? _eventDate;
  CostType _selectedCostType = CostType.money;
  SortOption _selectedSortOption = SortOption.latest;

  // Stats card
  int _weeklyAvoided = 0;
  double _monthlyMoneySavings = 0.0;

  // Goals section
  bool _goalsExpanded = false;

  // Bottom nav
  int _selectedIndex = 0;

  // App version (loaded dynamically from package info)
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6800),
    );
    _fabSheenAnimation = Tween<double>(
      begin: -1.8,
      end: 2.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
    _swipeHintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _swipeHintAnimation = TweenSequence<Offset>([
      // Nudge right → peek green (archive)
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0.03, 0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.03, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      // Nudge left → peek red (relapse)
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(-0.025, 0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(-0.025, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_swipeHintController);
    _fetchTodos();
    _fetchTags();
    _loadNotificationPref();
    _loadTrustedSupportContact();
    _loadAppVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<XpProvider>().load().then((_) {
        if (mounted) context.read<XpProvider>().awardDailyLoginIfNeeded();
      });
    });

    // Handle "I slipped up" notification action
    NotificationHelper().onNotificationAction = (payload) {
      if (mounted && _foundToDo.isNotEmpty) {
        _triggerRelapse(_foundToDo.first);
      }
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _checkCoachMarks() moved to didChangeDependencies so it waits for
      // the route's slide-in animation to complete before reading widget positions.
      // Handle case where app was launched via notification action
      if (NotificationHelper().pendingRelapseAction) {
        NotificationHelper().clearPendingRelapseAction();
        if (_foundToDo.isNotEmpty) {
          _triggerRelapse(_foundToDo.first);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_coachMarkScheduled) return;
    _coachMarkScheduled = true;

    final route = ModalRoute.of(context);
    if (route?.animation == null ||
        route!.animation!.status == AnimationStatus.completed) {
      // No navigation animation in progress (second launch / root widget)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checkCoachMarks();
      });
    } else {
      // First launch: slide-in animation still running — wait for it to finish
      // so widget positions are correct when tutorial_coach_mark reads them.
      late AnimationStatusListener listener;
      listener = (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          route.animation!.removeStatusListener(listener);
          if (mounted) _checkCoachMarks();
        }
      };
      route.animation!.addStatusListener(listener);
    }
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _widgetEnabled = prefs.getBool('widget_enabled') ?? false;
      _syncEnabled = prefs.getBool('sync_enabled') ?? false;
      _commitmentPromptFrequency = _commitmentPromptFrequencyFromString(
        prefs.getString('commitment_prompt_frequency'),
      );
    });
  }

  CommitmentPromptFrequency _commitmentPromptFrequencyFromString(
      String? value) {
    switch (value) {
      case 'weekly':
        return CommitmentPromptFrequency.weekly;
      case 'never':
        return CommitmentPromptFrequency.never;
      case 'daily':
      default:
        return CommitmentPromptFrequency.daily;
    }
  }

  String _commitmentPromptFrequencyValue(CommitmentPromptFrequency value) {
    switch (value) {
      case CommitmentPromptFrequency.weekly:
        return 'weekly';
      case CommitmentPromptFrequency.never:
        return 'never';
      case CommitmentPromptFrequency.daily:
        return 'daily';
    }
  }

  String _commitmentPromptFrequencyLabel(CommitmentPromptFrequency value) {
    switch (value) {
      case CommitmentPromptFrequency.weekly:
        return 'Once a week';
      case CommitmentPromptFrequency.never:
        return 'Never';
      case CommitmentPromptFrequency.daily:
        return 'Every day';
    }
  }

  String _currentCommitmentPeriodKey(DateTime now) {
    switch (_commitmentPromptFrequency) {
      case CommitmentPromptFrequency.weekly:
        return '${now.year}-W${_isoWeek(now)}';
      case CommitmentPromptFrequency.never:
        return 'never';
      case CommitmentPromptFrequency.daily:
        return now.toIso8601String().substring(0, 10);
    }
  }

  String _commitmentFrequencySubtitle(bool isPlus) {
    if (!isPlus) {
      return 'Choose how often the commitment screen shows up.';
    }
    return _commitmentPromptFrequencyLabel(_commitmentPromptFrequency);
  }

  Future<void> _setCommitmentPromptFrequency(
    CommitmentPromptFrequency value,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'commitment_prompt_frequency',
      _commitmentPromptFrequencyValue(value),
    );
    if (!mounted) return;
    setState(() => _commitmentPromptFrequency = value);
  }

  Future<void> _showCommitmentPromptSettings() async {
    final selected = await showModalBottomSheet<CommitmentPromptFrequency>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text('Commitment Check-In'),
                subtitle: Text(
                  'Control how often the full-screen commitment prompt appears.',
                ),
              ),
              RadioGroup<CommitmentPromptFrequency>(
                groupValue: _commitmentPromptFrequency,
                onChanged: (value) {
                  if (value != null) {
                    Navigator.pop(context, value);
                  }
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<CommitmentPromptFrequency>(
                      value: CommitmentPromptFrequency.daily,
                      title: Text('Every day'),
                    ),
                    RadioListTile<CommitmentPromptFrequency>(
                      value: CommitmentPromptFrequency.weekly,
                      title: Text('Once a week'),
                    ),
                    RadioListTile<CommitmentPromptFrequency>(
                      value: CommitmentPromptFrequency.never,
                      title: Text('Never'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      await _setCommitmentPromptFrequency(selected);
    }
  }

  Future<void> _loadTrustedSupportContact() async {
    final contact = await DatabaseHelper.instance.getTrustedSupportContact();
    if (mounted) {
      setState(() => _trustedSupportContact = contact);
    }
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = '${info.version} (build ${info.buildNumber})';
      });
    }
  }

  Future<void> _checkCoachMarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenCoachMarks = prefs.getBool('hasSeenCoachMarks') ?? false;
    if (!hasSeenCoachMarks) {
      _showCoachMarks(); // rating check fires inside onFinish callback
    } else {
      _checkRatingPrompt(); // coach marks already done, safe to check now
    }
  }

  Future<void> _checkRatingPrompt() async {
    final shouldShow = await RatingHelper.shouldShowRatingDialog();
    if (!shouldShow || !mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RatingDialog(),
    );
  }

  void _showCoachMarks() {
    _initTargets();
    TutorialCoachMark(
      targets: targets,
      colorShadow: tdAvoidRed,
      hideSkip: true,
      paddingFocus: 10,
      opacityShadow: 0.7,
      onFinish: () {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('hasSeenCoachMarks', true);
        });
        _checkRatingPrompt();
      },
    ).show(context: context);
  }

  void _initTargets() {
    final l10n = AppLocalizations.of(context)!;
    targets.clear();

    // Shared helper: tappable content block that advances the coach mark.
    Widget coachContent(
      TutorialCoachMarkController ctrl,
      String title,
      String desc, {
      Widget? prefix,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ctrl.next,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prefix != null) prefix,
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                desc,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '▶  tap to continue',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Step 1: Add button (FAB) — most basic, show first
    targets.add(
      TargetFocus(
        identify: "add",
        keyTarget: _addKey,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, ctrl) => coachContent(
              ctrl,
              l10n.coachMarkAddTitle,
              l10n.coachMarkAddDesc,
            ),
          ),
        ],
      ),
    );

    // Step 2: Search/filter bar
    targets.add(
      TargetFocus(
        identify: "search",
        keyTarget: _searchKey,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, ctrl) => coachContent(
              ctrl,
              l10n.coachMarkFilterTitle,
              l10n.coachMarkFilterDesc,
              prefix: const SizedBox(height: 80),
            ),
          ),
        ],
      ),
    );

    // Step 3: Statistics tab in the bottom NavigationBar
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    const navBarHeight = 80.0; // M3 NavigationBar default height
    final tabWidth = screenSize.width / 3;
    targets.add(
      TargetFocus(
        identify: "stats",
        enableOverlayTab: true,
        targetPosition: TargetPosition(
          Size(tabWidth, navBarHeight),
          // Second tab (index 1): starts at tabWidth from left
          Offset(tabWidth, screenSize.height - navBarHeight - bottomPadding),
        ),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, ctrl) => coachContent(
              ctrl,
              l10n.coachMarkStatsTitle,
              l10n.coachMarkStatsDesc,
            ),
          ),
        ],
      ),
    );

    // Step 4: Settings/menu button (top-right)
    targets.add(
      TargetFocus(
        identify: "menu",
        keyTarget: _menuKey,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, ctrl) => coachContent(
              ctrl,
              l10n.coachMarkMenuTitle,
              l10n.coachMarkMenuDesc,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _swipeHintController.dispose();
    _swipeHintTimer?.cancel();
    _todoController.dispose();
    _searchController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _fetchTodos() async {
    final todos = await DatabaseHelper.instance.readAllTodos();
    final weekly = await DatabaseHelper.instance.getThisWeekArchivedCount();
    final monthlySavings =
        await DatabaseHelper.instance.getThisMonthMoneySavings();
    todosList = todos;
    setState(() {
      _weeklyAvoided = weekly;
      _monthlyMoneySavings = monthlySavings;
      _isLoading = false;
    });
    _runFilter(_searchController.text);

    // Play swipe hint animation after first load, then repeat every 30 s
    if (!_swipeHintPlayed && _foundToDo.isNotEmpty) {
      _swipeHintPlayed = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _swipeHintController.forward(from: 0);
      });
      _swipeHintTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) _swipeHintController.forward(from: 0);
      });
    }

    if (!mounted) return;

    // Check streak milestones and award XP if any thresholds just crossed
    final purchase = context.read<PurchaseProvider>();
    final isPlus = purchase.isPlus;
    final hasPurchasedPlus = purchase.hasPurchasedPlus;
    final rawTodos = todos.map((t) => t.toMap()).toList();
    await context.read<XpProvider>().awardStreakMilestonesIfNeeded(rawTodos);

    // Load goals and check for completions
    if (!mounted) return;
    final newlyCompleted = await context.read<GoalProvider>().load(
          activeTodos: todos,
          monthlySavings: monthlySavings,
          isPlus: isPlus,
        );

    // Award XP for completed goals (Plus only)
    if (mounted && isPlus && newlyCompleted.isNotEmpty) {
      final xp = context.read<XpProvider>();
      for (final goal in newlyCompleted) {
        final xpAmount = goal.type == GoalType.savingsMonth ? 100 : 50;
        await xp.award('goal_complete:${goal.id}', xpAmount);
      }
      // Show celebration for each completed goal
      for (final goal in newlyCompleted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('🎯 Goal complete! "${GoalHelper.description(goal)}"'),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else if (mounted && !isPlus && newlyCompleted.isNotEmpty) {
      // Free users: celebration but no XP
      for (final goal in newlyCompleted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('🎯 Goal complete! "${GoalHelper.description(goal)}"'),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    // Phase 1C: Daily commitment flow (Plus only, once per session/day)
    _maybeShowDailyCommitment(todos, isPlus);

    // Phase 2A: Pattern-based reminder (Plus only, once per ISO week)
    if (isPlus) {
      _schedulePatternReminderIfNeeded();
    } else {
      await NotificationHelper().cancelPatternReminder();
    }

    // Phase 2B: Cancel any pending relapse follow-up on natural app open
    if (isPlus) {
      NotificationHelper().cancelRelapseFollowUp();
    } else {
      await NotificationHelper().cancelRelapseFollowUp();
    }

    // Phase 4: Push data to home screen widget (Plus + widget enabled)
    if (isPlus && _widgetEnabled) {
      final active =
          todos.where((t) => !t.isArchived && t.isRecurring).toList();
      HomeWidgetHelper.update(active);
    } else if (!isPlus && _widgetEnabled) {
      await HomeWidgetHelper.clear();
    }

    // Phase 6: Cloud sync — check for newer backup on first load
    if (hasPurchasedPlus && _syncEnabled) {
      SyncHelper.uploadIfNeeded();
    }
  }

  /// Shows the daily commitment screen if:
  ///  - user is Plus, has active recurring habits, AND hasn't committed today.
  Future<void> _maybeShowDailyCommitment(List<ToDo> todos, bool isPlus) async {
    if (_commitmentCheckDone) return;
    _commitmentCheckDone = true;

    if (!isPlus) return;
    if (_commitmentPromptFrequency == CommitmentPromptFrequency.never) return;

    final activeTodos =
        todos.where((t) => !t.isArchived && t.isRecurring).toList();
    if (activeTodos.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final periodKey = _currentCommitmentPeriodKey(now);
    final lastCommitmentKey = prefs.getString(
      _commitmentPromptFrequency == CommitmentPromptFrequency.weekly
          ? 'last_commitment_week'
          : 'last_commitment_date',
    );
    if (lastCommitmentKey == periodKey) return;

    if (!mounted) return;

    final committed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyCommitmentScreen(activeTodos: activeTodos),
        fullscreenDialog: true,
      ),
    );

    // Save the date only when the user tapped "Start my day"
    if ((committed ?? false) && mounted) {
      await prefs.setString(
        _commitmentPromptFrequency == CommitmentPromptFrequency.weekly
            ? 'last_commitment_week'
            : 'last_commitment_date',
        periodKey,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Phase 2A: Pattern-based heads-up notification (Plus)
  // ─────────────────────────────────────────────────────────────

  /// Computes the highest-risk day of week from relapse history and schedules
  /// a 10 PM heads-up the night before — at most once per ISO calendar week.
  Future<void> _schedulePatternReminderIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final weekKey = '${now.year}-W${_isoWeek(now)}';
    if (prefs.getString('last_pattern_schedule_week') == weekKey) return;

    final pattern = await DatabaseHelper.instance.getRelapseDayPattern();
    // Only schedule if there is real relapse data
    final hasData = pattern.values.any((count) => count > 0);
    if (!hasData) return;

    final maxEntry =
        pattern.entries.reduce((a, b) => a.value > b.value ? a : b);

    await NotificationHelper().schedulePatternReminder(maxEntry.key);
    await prefs.setString('last_pattern_schedule_week', weekKey);
  }

  /// Returns the ISO 8601 week number for [date].
  int _isoWeek(DateTime date) {
    final doy = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    return ((doy - date.weekday + 10) / 7).floor();
  }

  Future<void> _fetchTags() async {
    final tags = await DatabaseHelper.instance.getAllTags();
    setState(() => _allTags = tags);
  }

  Future<void> _addTodo(String todo) async {
    if (todo.isEmpty) return;

    // Free tier: maximum 10 active todos
    final isPlus = context.read<PurchaseProvider>().isPlus;
    if (!isPlus && todosList.length >= 10) {
      // Don't pop here — the call-site already calls Navigator.pop after _addTodo.
      // Schedule the dialog for the next frame so it shows AFTER the sheet is gone,
      // not before (otherwise the call-site's pop would dismiss the dialog).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showPlusDialog(context,
              subtitle: 'Unlock Plus for unlimited habits.');
        }
      });
      return;
    }

    if (!_isRecurring && _eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.selectEventDateError ??
                'Please select an event date.')),
      );
      return;
    }

    final newTodo = ToDo(
      todoText: todo,
      tagIds: List.from(_selectedTagIds),
      priority: _selectedPriority,
      orderIndex: todosList.length,
      isRecurring: _isRecurring,
      relapseCount: 0,
      estimatedCost: double.tryParse(_costController.text),
      costType: _selectedCostType,
      avoidType: _selectedType,
      contactId: _selectedContactId,
      locationName: _locationName,
      latitude: _latitude,
      longitude: _longitude,
      reminderDateTime: _reminderDateTime,
    );

    final newId = await DatabaseHelper.instance.create(newTodo);
    if (_reminderDateTime != null && _notificationsEnabled) {
      if (_selectedType == AvoidType.event) {
        await NotificationHelper()
            .scheduleReminder(newId, todo, _reminderDateTime!);
      } else {
        await NotificationHelper()
            .scheduleDailyItemReminder(newId, todo, _reminderDateTime!);
      }
    }
    _todoController.clear();
    _costController.clear();
    setState(() {
      _selectedCostType = CostType.money;
      _selectedTagIds = [];
      _selectedPriority = TodoPriority.medium;
      _isRecurring = true;
      _eventDate = null;
      _selectedType = AvoidType.generic;
      _selectedContactId = null;
      _locationName = null;
      _latitude = null;
      _longitude = null;
      _reminderDateTime = null;
    });
    _fetchTodos();
    _showTagTipIfRelevant(_selectedTagIds);
  }

  void _showTagTipIfRelevant(List<String> tagIds) {
    final relevantIds = ['health', 'productivity', 'social'];
    final matchedId =
        tagIds.firstWhere((id) => relevantIds.contains(id), orElse: () => '');
    if (matchedId.isEmpty) return;
    final tip = getTipForTagId(matchedId);
    if (tip != null && mounted) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('💡 $tip'),
              duration: const Duration(seconds: 6),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  Future<void> _archiveTodo(int id) async {
    final xpProvider = context.read<XpProvider>();
    await DatabaseHelper.instance.archiveTodo(id);
    await NotificationHelper().cancelReminder(id.toString());
    _confettiController.play();
    xpProvider.award(XpHelper.sourceArchive, XpHelper.xpArchive);
    _fetchTodos();
  }

  void _showItemAvoidedSnackBar(ToDo todo) {
    final messenger = ScaffoldMessenger.of(context);
    var undone = false;

    () async {
      final controller = messenger.showSnackBar(
        SnackBar(
          content: Text('"${todo.todoText}" avoided'),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          persist: false,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              undone = true;
              await DatabaseHelper.instance.restoreTodo(
                int.parse(todo.id!),
              );
              _fetchTodos();
            },
          ),
        ),
      );

      await controller.closed;
      if (!mounted || undone) return;
      if (!undone) {
        await _showAvoidReflectionPrompt(todo);
      }

      final streakDays = DateTime.now().difference(todo.lastRelapsedAt).inDays;
      final tip = getTipForStreak(streakDays);
      if (tip != null && mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('💡 $tip'),
            duration: const Duration(seconds: 6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }();
  }

  String _getPriorityLabel(TodoPriority priority) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case TodoPriority.high:
        return l10n?.high ?? 'High';
      case TodoPriority.medium:
        return l10n?.medium ?? 'Medium';
      case TodoPriority.low:
        return l10n?.low ?? 'Low';
    }
  }

  IconData _getCostIcon(CostType type) {
    switch (type) {
      case CostType.money:
        return Icons.attach_money;
      case CostType.mood:
        return Icons.mood;
      case CostType.health:
        return Icons.health_and_safety;
      case CostType.time:
        return Icons.timer;
      case CostType.goodwill:
        return Icons.handshake;
      case CostType.patience:
        return Icons.hourglass_empty;
    }
  }

  Future<void> _showCreateTagDialog(
    BuildContext ctx,
    List<Tag> localTags,
    void Function(VoidCallback) setModalState,
  ) async {
    final nameController = TextEditingController();
    int selectedColor = Tag.palette.first;

    await showDialog(
      context: ctx,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tag name'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Tag.palette.map((colorVal) {
                  final isSelected = selectedColor == colorVal;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = colorVal),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(width: 3, color: Colors.white)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Color(colorVal).withAlpha(120),
                                    blurRadius: 6)
                              ]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final newTag = Tag(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  colorValue: selectedColor,
                );
                await DatabaseHelper.instance.createTag(newTag);
                await _fetchTags();
                setModalState(() => localTags.add(newTag));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tdAvoidRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog() {
    _animationController.stop();
    final locationController = TextEditingController(text: _locationName);
    bool showAdvanced = false;

    // ── Autocomplete state ────────────────────────────────────────
    List<String> suggestionHistory = [];
    List<String> suggestions = [];
    void Function(void Function())? capturedSetState;

    void updateSuggestions() {
      final text = _todoController.text.trim();
      final matches = text.isEmpty
          ? <String>[]
          : suggestionHistory
              .where((h) =>
                  h.toLowerCase().contains(text.toLowerCase()) && h != text)
              .take(5)
              .toList();
      capturedSetState?.call(() => suggestions = matches);
    }

    _todoController.addListener(updateSuggestions);

    DatabaseHelper.instance.database.then((db) async {
      final rows = await db.rawQuery(
        'SELECT todoText FROM todo GROUP BY todoText ORDER BY MAX(createdAt) DESC LIMIT 200',
      );
      suggestionHistory = rows.map((r) => r['todoText'] as String).toList();
      updateSuggestions();
    });
    // ─────────────────────────────────────────────────────────────

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          capturedSetState = setModalState;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.addThingToAvoid ??
                        'Add Thing to Avoid',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.whatToAvoid ??
                          'What do you need to avoid?',
                      prefixIcon: const Icon(Icons.block),
                    ),
                    autofocus: true,
                  ),
                  // ── Autocomplete suggestions ──────────────────────
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: suggestions
                            .map((s) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ActionChip(
                                    label: Text(
                                      s,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    onPressed: () {
                                      _todoController.text = s;
                                      _todoController.selection =
                                          TextSelection.collapsed(
                                              offset: s.length);
                                      setModalState(() => suggestions = []);
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  // ─────────────────────────────────────────────────
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)?.avoidTypeLabel ??
                          'Avoid Type:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AvoidType.values.map((type) {
                        final isSelected = _selectedType == type;
                        IconData icon;
                        String label;
                        switch (type) {
                          case AvoidType.generic:
                            icon = Icons.block;
                            label = 'Habit';
                            break;
                          case AvoidType.people:
                            icon = Icons.person;
                            label = 'Person';
                            break;
                          case AvoidType.event:
                            icon = Icons.event;
                            label = 'Event';
                            break;
                          case AvoidType.place:
                            icon = Icons.place;
                            label = 'Place';
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            avatar: Icon(icon, size: 16),
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  _selectedType = type;
                                });
                              }
                            },
                            selectedColor: _fabBaseColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  if (_selectedType == AvoidType.people) ...[
                    const SizedBox(height: 16),
                    Text(
                        AppLocalizations.of(context)?.associatedPerson ??
                            'Associated Person:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final granted = await FlutterContacts.requestPermission(
                            readonly: true);
                        if (!granted) return;
                        final contact =
                            await FlutterContacts.openExternalPick();
                        if (contact != null) {
                          setModalState(() {
                            _selectedContactId = contact.id;
                            _todoController.text = contact.displayName;
                          });
                        }
                      },
                      icon: const Icon(Icons.contact_phone),
                      label: Text(_selectedContactId == null
                          ? 'Select from Contacts'
                          : 'Change Contact'),
                    ),
                  ],

                  if (_selectedType == AvoidType.place) ...[
                    const SizedBox(height: 16),
                    Text(
                        AppLocalizations.of(context)?.avoidLocation ??
                            'Avoid Location:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: locationController,
                      onChanged: (val) => _locationName = val,
                      decoration: const InputDecoration(
                        hintText: 'Place name or address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPickerScreen(
                              initialLat: _latitude,
                              initialLng: _longitude,
                            ),
                          ),
                        );
                        if (result != null && result is Map<String, dynamic>) {
                          setModalState(() {
                            _latitude = result['lat'];
                            _longitude = result['lng'];
                            _locationName = result['address'];
                            locationController.text = _locationName ?? '';
                          });
                        }
                      },
                      icon: const Icon(Icons.map),
                      label: Text(AppLocalizations.of(context)?.pickOnMap ??
                          'Pick on Map'),
                    ),
                  ],

                  if (_selectedType == AvoidType.event) ...[
                    const SizedBox(height: 16),
                    Text(
                        AppLocalizations.of(context)?.eventReminderLabel ??
                            'Event Reminder:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.alarm),
                      title: Text(_reminderDateTime == null
                          ? (AppLocalizations.of(context)?.setReminder ??
                              'Set Reminder')
                          : '${_reminderDateTime!.day}/${_reminderDateTime!.month} ${_reminderDateTime!.hour}:${_reminderDateTime!.minute}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(hours: 1)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null && context.mounted) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setModalState(() {
                              _reminderDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      trailing: _reminderDateTime != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => setModalState(() {
                                _reminderDateTime = null;
                              }),
                            )
                          : null,
                    ),
                  ],

                  if (_selectedType != AvoidType.event) ...[
                    const SizedBox(height: 16),
                    Text(
                        AppLocalizations.of(context)?.dailyReminderLabel ??
                            'Daily Reminder Time:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.alarm),
                      title: Text(_reminderDateTime == null
                          ? (AppLocalizations.of(context)?.setDailyReminder ??
                              'Set Daily Reminder')
                          : 'Every day at ${_reminderDateTime!.hour.toString().padLeft(2, '0')}:${_reminderDateTime!.minute.toString().padLeft(2, '0')}'),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _reminderDateTime != null
                              ? TimeOfDay.fromDateTime(_reminderDateTime!)
                              : const TimeOfDay(hour: 20, minute: 0),
                        );
                        if (time != null) {
                          final now = DateTime.now();
                          setModalState(() {
                            _reminderDateTime = DateTime(now.year, now.month,
                                now.day, time.hour, time.minute);
                          });
                        }
                      },
                      trailing: _reminderDateTime != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => setModalState(() {
                                _reminderDateTime = null;
                              }),
                            )
                          : null,
                    ),
                  ],

                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)?.tags ?? 'Tags:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Tag>>(
                    future: DatabaseHelper.instance.getAllTags(),
                    builder: (context, snapshot) {
                      final localTags = snapshot.data ?? _allTags;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...localTags.map((tag) {
                              final isSelected =
                                  _selectedTagIds.contains(tag.id);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(tag.name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      if (selected) {
                                        _selectedTagIds.add(tag.id);
                                      } else {
                                        _selectedTagIds.remove(tag.id);
                                      }
                                    });
                                  },
                                  selectedColor: tag.color.withAlpha(180),
                                  checkmarkColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : null,
                                  ),
                                ),
                              );
                            }),
                            ActionChip(
                              avatar: const Icon(Icons.add, size: 16),
                              label: Text(
                                  AppLocalizations.of(context)?.newTag ??
                                      'New tag'),
                              onPressed: () => _showCreateTagDialog(
                                  context, localTags, setModalState),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)?.priority ?? 'Priority:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TodoPriority.values.map((priority) {
                      final isSelected = _selectedPriority == priority;
                      Color color;
                      switch (priority) {
                        case TodoPriority.high:
                          color = AppThemes.priorityHigh;
                          break;
                        case TodoPriority.medium:
                          color = AppThemes.priorityMedium;
                          break;
                        case TodoPriority.low:
                          color = AppThemes.priorityLow;
                          break;
                      }
                      return ChoiceChip(
                        label: Text(_getPriorityLabel(priority)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _selectedPriority = priority;
                            });
                          }
                        },
                        selectedColor: color,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Recurring vs Single Event Toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        AppLocalizations.of(context)?.isRecurring ??
                            'Is this a recurring habit?',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    value: _isRecurring,
                    onChanged: (bool value) {
                      setModalState(() {
                        _isRecurring = value;
                        if (value) {
                          _eventDate = null; // Clear date if switching back
                        }
                      });
                    },
                    activeThumbColor: tdAvoidRed,
                  ),

                  if (!_isRecurring)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text(
                              '${AppLocalizations.of(context)?.eventDate ?? 'Event Date'}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          TextButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: Text(_eventDate == null
                                ? (AppLocalizations.of(context)?.selectDate ??
                                    'Select Date')
                                : '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now().add(const Duration(days: 1)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  _eventDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                  // Advanced options toggle
                  TextButton.icon(
                    onPressed: () =>
                        setModalState(() => showAdvanced = !showAdvanced),
                    icon: Icon(
                      showAdvanced ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                    ),
                    label: Text(showAdvanced
                        ? 'Advanced options'
                        : 'Advanced options (cost tracking)'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                  ),

                  if (showAdvanced) ...[
                    const SizedBox(height: 8),
                    Text(
                        AppLocalizations.of(context)?.costTypeLabel ??
                            'Cost Type:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: CostType.values
                            .where((t) =>
                                t != CostType.goodwill &&
                                t != CostType.patience)
                            .map((type) {
                          final isSelected = _selectedCostType == type;
                          IconData icon;
                          String label;
                          switch (type) {
                            case CostType.money:
                              icon = Icons.attach_money;
                              label = AppLocalizations.of(context)?.costMoney ??
                                  'Money';
                              break;
                            case CostType.mood:
                              icon = Icons.mood;
                              label = AppLocalizations.of(context)?.costMood ??
                                  'Mood';
                              break;
                            case CostType.health:
                              icon = Icons.health_and_safety;
                              label = AppLocalizations.of(context)?.health ??
                                  'Health';
                              break;
                            case CostType.time:
                              icon = Icons.timer;
                              label = AppLocalizations.of(context)?.costTime ??
                                  'Time';
                              break;
                            case CostType.goodwill:
                              icon = Icons.handshake;
                              label = 'Goodwill';
                              break;
                            case CostType.patience:
                              icon = Icons.hourglass_empty;
                              label = 'Patience';
                              break;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              avatar: Icon(icon, size: 16),
                              label: Text(label),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setModalState(() {
                                    _selectedCostType = type;
                                  });
                                }
                              },
                              selectedColor: Colors.blue.withAlpha(200),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)?.estimatedCostLabel ??
                                'Cost Amount (per relapse/duration)',
                        hintText: 'e.g., 5.0',
                        prefixIcon: Icon(_getCostIcon(_selectedCostType)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _addTodo(_todoController.text);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _fabBaseColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                          AppLocalizations.of(context)?.addToAvoidList ??
                              'Add to Avoid List'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ); // closes return Padding
        }, // closes builder block
      ),
    ).whenComplete(() {
      _todoController.removeListener(updateSuggestions);
      if (mounted && _selectedIndex == 0) {
        _animationController.repeat(reverse: true);
      }
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Apply Sorting
    switch (_selectedSortOption) {
      case SortOption.latest:
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        results.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.avoidType:
        results.sort((a, b) => a.avoidType.index.compareTo(b.avoidType.index));
        break;
      case SortOption.costType:
        results.sort((a, b) => a.costType.index.compareTo(b.costType.index));
        break;
      case SortOption.priority:
        results.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
    }

    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _selectedIndex = 0);
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppThemes.darkBackground : AppThemes.lightBackground,
        appBar: _buildAppBar(),
        endDrawer: _selectedIndex == 0 ? _buildDrawer(themeProvider) : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) {
            setState(() {
              if (i == 1 && _selectedIndex != 1) {
                _statsRefreshVersion++;
              }
              _selectedIndex = i;
            });
            if (i == 0) _fetchTodos();
            if (i == 2) _archiveKey.currentState?.refresh();
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: AppLocalizations.of(context)?.navHome ?? 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: AppLocalizations.of(context)?.statistics ?? 'Statistics',
            ),
            const NavigationDestination(
              icon: Icon(Icons.archive_outlined),
              selectedIcon: Icon(Icons.archive),
              label: 'History',
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildSearchBox(key: _searchKey)),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: PopupMenuButton<SortOption>(
                              icon: const Icon(Icons.sort),
                              onSelected: (SortOption result) {
                                setState(() {
                                  _selectedSortOption = result;
                                  _runFilter(_searchController.text);
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                final l10n = AppLocalizations.of(context);
                                return <PopupMenuEntry<SortOption>>[
                                  PopupMenuItem<SortOption>(
                                    value: SortOption.latest,
                                    child: Text(l10n?.sortLatest ?? 'Latest'),
                                  ),
                                  PopupMenuItem<SortOption>(
                                    value: SortOption.oldest,
                                    child: Text(l10n?.sortOldest ?? 'Oldest'),
                                  ),
                                  PopupMenuItem<SortOption>(
                                    value: SortOption.avoidType,
                                    child: Text(
                                        l10n?.sortAvoidType ?? 'Avoid Type'),
                                  ),
                                  PopupMenuItem<SortOption>(
                                    value: SortOption.costType,
                                    child:
                                        Text(l10n?.sortCostType ?? 'Cost Type'),
                                  ),
                                  PopupMenuItem<SortOption>(
                                    value: SortOption.priority,
                                    child: Text(l10n?.priority ?? 'Priority'),
                                  ),
                                ];
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_foundToDo.isNotEmpty || _weeklyAvoided > 0) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const StatisticsScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withAlpha(40)
                                      : Colors.grey.withAlpha(40),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        spacing: 16,
                                        runSpacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.bolt,
                                                  size: 18,
                                                  color: Colors.orange),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${_foundToDo.length} active',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? AppThemes
                                                          .darkTextSecondary
                                                      : AppThemes
                                                          .lightTextSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _weeklyAvoided > 0
                                                    ? Icons.check_circle_outline
                                                    : Icons.electric_bolt,
                                                size: 18,
                                                color: _weeklyAvoided > 0
                                                    ? Colors.green
                                                    : Colors.orange,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _weeklyAvoided > 0
                                                    ? '$_weeklyAvoided avoided this week'
                                                    : 'Keep going!',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? AppThemes
                                                          .darkTextSecondary
                                                      : AppThemes
                                                          .lightTextSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.chevron_right,
                                        size: 18,
                                        color: isDark
                                            ? AppThemes.darkTextSecondary
                                            : AppThemes.lightTextSecondary),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Consumer<XpProvider>(
                                  builder: (_, xp, __) {
                                    final isPlus =
                                        context.read<PurchaseProvider>().isPlus;
                                    final level = xp.levelCapped(isPlus);
                                    final title = xp.titleForLevel(level);
                                    final prog = xp.progress(isPlus);
                                    final atFreeCap = !isPlus &&
                                        level >= XpHelper.maxFreeLevel;
                                    final atMaxLevel =
                                        isPlus && level >= XpHelper.maxLevel;
                                    final textColor = isDark
                                        ? AppThemes.darkTextSecondary
                                        : AppThemes.lightTextSecondary;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded,
                                                size: 13, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Lv.$level · $title',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (atFreeCap)
                                              const Text(
                                                '⭐ Plus to level up',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.amber),
                                              )
                                            else if (atMaxLevel)
                                              const Text(
                                                'Max level',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.amber),
                                              )
                                            else
                                              Text(
                                                '${xp.totalXp} / ${xp.xpCeiling(isPlus)} XP',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: textColor),
                                              ),
                                          ],
                                        ),
                                        if (!atFreeCap && !atMaxLevel) ...[
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: LinearProgressIndicator(
                                              value: prog,
                                              backgroundColor: isDark
                                                  ? Colors.white12
                                                  : Colors.black12,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.amber),
                                              minHeight: 4,
                                            ),
                                          ),
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // ── Goals section ──────────────────────────────────
                      Consumer<GoalProvider>(
                        builder: (_, goalProvider, __) {
                          final goals = goalProvider.goals;
                          final isPlus =
                              context.read<PurchaseProvider>().isPlus;
                          if (goals.isEmpty && !isPlus) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildGoalsSection(goals, isPlus, isDark),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _isLoading
                            ? _buildShimmerList(isDark)
                            : _foundToDo.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 64,
                                          color: isDark
                                              ? AppThemes.darkTextSecondary
                                              : AppThemes.lightTextSecondary,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          AppLocalizations.of(context)
                                                  ?.noItemsYet ??
                                              'No items to avoid yet',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: isDark
                                                ? AppThemes.darkTextSecondary
                                                : AppThemes.lightTextSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tap + to track your first habit to avoid',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: (isDark
                                                    ? AppThemes
                                                        .darkTextSecondary
                                                    : AppThemes
                                                        .lightTextSecondary)
                                                .withAlpha(180),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton.icon(
                                          icon: const Icon(
                                              Icons.archive_outlined,
                                              size: 16),
                                          label: const Text('View History →'),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const ArchiveScreen()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: _foundToDo.length,
                                    itemBuilder: (context, i) {
                                      final dismissible = Dismissible(
                                        key: ValueKey(_foundToDo[i].id),
                                        direction: DismissDirection.horizontal,
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.archive,
                                                  color: Colors.white),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)
                                                        ?.avoidedLabel ??
                                                    'Avoided!',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        secondaryBackground: Container(
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: tdAvoidRed.withAlpha(200),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.restore,
                                                  color: Colors.white),
                                              SizedBox(height: 4),
                                              Text(
                                                'Relapse',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            _triggerRelapse(_foundToDo[i]);
                                            return false;
                                          }
                                          return true;
                                        },
                                        onDismissed: (_) async {
                                          final todo = _foundToDo[i];
                                          // Remove synchronously first so Flutter never
                                          // tries to rebuild a widget it already dismissed
                                          setState(
                                              () => _foundToDo.removeAt(i));
                                          await _archiveTodo(
                                              int.parse(todo.id!));
                                          if (mounted) {
                                            _showItemAvoidedSnackBar(todo);
                                          }
                                        },
                                        child: ToDoItem(
                                          todo: _foundToDo[i],
                                          onEditItem: _editTodo,
                                        ),
                                      );

                                      // For the first item: wrap in an AnimatedBuilder
                                      // that renders real green/red hint backgrounds and
                                      // translates the card so they peek through.
                                      if (i != 0) return dismissible;
                                      return AnimatedBuilder(
                                        animation: _swipeHintController,
                                        builder: (context, _) {
                                          final dx =
                                              _swipeHintAnimation.value.dx;
                                          final pixelDx = dx *
                                              MediaQuery.of(context).size.width;
                                          final showGreen = dx > 0.001;
                                          final showRed = dx < -0.001;
                                          return Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              if (showGreen || showRed)
                                                Positioned.fill(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 12),
                                                    decoration: BoxDecoration(
                                                      color: showGreen
                                                          ? Colors.green
                                                          : tdAvoidRed
                                                              .withAlpha(200),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    alignment: showGreen
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                    padding: EdgeInsets.only(
                                                      left: showGreen ? 20 : 0,
                                                      right: showRed ? 20 : 0,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          showGreen
                                                              ? Icons.archive
                                                              : Icons.restore,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          showGreen
                                                              ? (AppLocalizations.of(
                                                                          context)
                                                                      ?.avoidedLabel ??
                                                                  'Avoided!')
                                                              : 'Relapse',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              Transform.translate(
                                                offset: Offset(pixelDx, 0),
                                                child: dismissible,
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                  ),
                ),
              ],
            ),
            StatisticsScreen(
              key: ValueKey('stats_$_statsRefreshVersion'),
              embedded: true,
            ),
            ArchiveScreen(key: _archiveKey, embedded: true),
          ],
        ),
        floatingActionButton: _selectedIndex == 0
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: _fabBaseColor.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          FloatingActionButton.extended(
                            key: _addKey,
                            onPressed: _showAddTodoDialog,
                            backgroundColor: _fabBaseColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            highlightElevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            splashColor: Colors.white.withValues(alpha: 0.14),
                            icon: const Icon(Icons.add),
                            label: const Text('Add'),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(
                                      _fabSheenAnimation.value - 1.5,
                                      -1.0,
                                    ),
                                    end: Alignment(
                                      _fabSheenAnimation.value + 1.5,
                                      1.0,
                                    ),
                                    colors: const [
                                      Colors.transparent,
                                      Color(0x00FFFFFF),
                                      Color(0x33FFFFFF),
                                      Color(0x00FFFFFF),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.28, 0.5, 0.72, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  Future<void> _editTodo(ToDo todo) async {
    final textController = TextEditingController(text: todo.todoText);
    final costController =
        TextEditingController(text: todo.estimatedCost?.toString() ?? '');
    final locationController = TextEditingController(text: todo.locationName);
    List<String> editTagIds = List.from(todo.tagIds);
    TodoPriority editPriority = todo.priority;
    bool editIsRecurring = todo.isRecurring;
    DateTime? editEventDate = todo.eventDate;
    AvoidType editType = todo.avoidType;
    bool editShowAdvanced = todo.estimatedCost != null;
    String? editContactId = todo.contactId;
    String? editLocationName = todo.locationName;
    double? editLatitude = todo.latitude;
    double? editLongitude = todo.longitude;
    DateTime? editReminderDateTime = todo.reminderDateTime;
    CostType editCostType = todo.costType;
    final localTags = List<Tag>.from(_allTags);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.editItem ?? 'Edit Item',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'What do you need to avoid?',
                    prefixIcon: Icon(Icons.block),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Text(
                    AppLocalizations.of(context)?.avoidTypeLabel ??
                        'Avoid Type:',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AvoidType.values.map((type) {
                      final isSelected = editType == type;
                      IconData icon;
                      String label;
                      switch (type) {
                        case AvoidType.generic:
                          icon = Icons.block;
                          label = 'Habit';
                          break;
                        case AvoidType.people:
                          icon = Icons.person;
                          label = 'Person';
                          break;
                        case AvoidType.event:
                          icon = Icons.event;
                          label = 'Event';
                          break;
                        case AvoidType.place:
                          icon = Icons.place;
                          label = 'Place';
                          break;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          avatar: Icon(icon, size: 16),
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                editType = type;
                              });
                            }
                          },
                          selectedColor: _fabBaseColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (editType == AvoidType.people) ...[
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)?.associatedPerson ??
                          'Associated Person:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final granted = await FlutterContacts.requestPermission(
                          readonly: true);
                      if (!granted) return;
                      final contact = await FlutterContacts.openExternalPick();
                      if (contact != null) {
                        setModalState(() {
                          editContactId = contact.id;
                          textController.text = contact.displayName;
                        });
                      }
                    },
                    icon: const Icon(Icons.contact_phone),
                    label: Text(editContactId == null
                        ? 'Select from Contacts'
                        : 'Change Contact'),
                  ),
                ],
                if (editType == AvoidType.place) ...[
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)?.avoidLocation ??
                          'Avoid Location:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: locationController,
                    onChanged: (val) => editLocationName = val,
                    decoration: const InputDecoration(
                      hintText: 'Place name or address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPickerScreen(
                            initialLat: editLatitude,
                            initialLng: editLongitude,
                          ),
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        setModalState(() {
                          editLatitude = result['lat'];
                          editLongitude = result['lng'];
                          editLocationName = result['address'];
                          locationController.text = editLocationName ?? '';
                        });
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: Text(AppLocalizations.of(context)?.pickOnMap ??
                        'Pick on Map'),
                  ),
                ],
                if (editType == AvoidType.event) ...[
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)?.eventReminderLabel ??
                          'Event Reminder:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.alarm),
                    title: Text(editReminderDateTime == null
                        ? (AppLocalizations.of(context)?.setReminder ??
                            'Set Reminder')
                        : '${editReminderDateTime!.day}/${editReminderDateTime!.month} ${editReminderDateTime!.hour}:${editReminderDateTime!.minute}'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: editReminderDateTime ??
                            DateTime.now().add(const Duration(hours: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: editReminderDateTime != null
                              ? TimeOfDay.fromDateTime(editReminderDateTime!)
                              : TimeOfDay.now(),
                        );
                        if (time != null) {
                          setModalState(() {
                            editReminderDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    trailing: editReminderDateTime != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setModalState(() {
                              editReminderDateTime = null;
                            }),
                          )
                        : null,
                  ),
                ],
                if (editType != AvoidType.event) ...[
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)?.dailyReminderLabel ??
                          'Daily Reminder Time:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.alarm),
                    title: Text(editReminderDateTime == null
                        ? (AppLocalizations.of(context)?.setDailyReminder ??
                            'Set Daily Reminder')
                        : 'Every day at ${editReminderDateTime!.hour.toString().padLeft(2, '0')}:${editReminderDateTime!.minute.toString().padLeft(2, '0')}'),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: editReminderDateTime != null
                            ? TimeOfDay.fromDateTime(editReminderDateTime!)
                            : const TimeOfDay(hour: 20, minute: 0),
                      );
                      if (time != null) {
                        final now = DateTime.now();
                        setModalState(() {
                          editReminderDateTime = DateTime(now.year, now.month,
                              now.day, time.hour, time.minute);
                        });
                      }
                    },
                    trailing: editReminderDateTime != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setModalState(() {
                              editReminderDateTime = null;
                            }),
                          )
                        : null,
                  ),
                ],
                const SizedBox(height: 16),
                const Text('Tags:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...localTags.map((tag) {
                        final isSelected = editTagIds.contains(tag.id);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(tag.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  editTagIds.add(tag.id);
                                } else {
                                  editTagIds.remove(tag.id);
                                }
                              });
                            },
                            selectedColor: tag.color.withAlpha(180),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        );
                      }),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: Text(
                            AppLocalizations.of(context)?.newTag ?? 'New tag'),
                        onPressed: () => _showCreateTagDialog(
                            context, localTags, setModalState),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)?.priority ?? 'Priority:',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: TodoPriority.values.map((priority) {
                    final isSelected = editPriority == priority;
                    Color color;
                    String label;
                    switch (priority) {
                      case TodoPriority.high:
                        color = AppThemes.priorityHigh;
                        label = 'High';
                        break;
                      case TodoPriority.medium:
                        color = AppThemes.priorityMedium;
                        label = 'Medium';
                        break;
                      case TodoPriority.low:
                        color = AppThemes.priorityLow;
                        label = 'Low';
                        break;
                    }
                    return ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setModalState(() {
                            editPriority = priority;
                          });
                        }
                      },
                      selectedColor: color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Is this a recurring habit?',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  value: editIsRecurring,
                  onChanged: (bool value) {
                    setModalState(() {
                      editIsRecurring = value;
                      if (value) {
                        editEventDate = null;
                      }
                    });
                  },
                  activeThumbColor: tdAvoidRed,
                ),
                if (!editIsRecurring)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Text('Event Date: ',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(editEventDate == null
                              ? 'Select Date'
                              : '${editEventDate!.day}/${editEventDate!.month}/${editEventDate!.year}'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: editEventDate ?? DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setModalState(() {
                                editEventDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                // Advanced options toggle (edit form)
                TextButton.icon(
                  onPressed: () =>
                      setModalState(() => editShowAdvanced = !editShowAdvanced),
                  icon: Icon(
                    editShowAdvanced ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                  label: Text(editShowAdvanced
                      ? 'Advanced options'
                      : 'Advanced options (cost tracking)'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
                ),

                if (editShowAdvanced) ...[
                  const SizedBox(height: 8),
                  Text(
                      AppLocalizations.of(context)?.costTypeLabel ??
                          'Cost Type:',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: CostType.values
                          .where((t) =>
                              t != CostType.goodwill && t != CostType.patience)
                          .map((type) {
                        final isSelected = editCostType == type;
                        IconData icon;
                        String label;
                        switch (type) {
                          case CostType.money:
                            icon = Icons.attach_money;
                            label = AppLocalizations.of(context)?.costMoney ??
                                'Money';
                            break;
                          case CostType.mood:
                            icon = Icons.mood;
                            label = AppLocalizations.of(context)?.costMood ??
                                'Mood';
                            break;
                          case CostType.health:
                            icon = Icons.health_and_safety;
                            label = AppLocalizations.of(context)?.health ??
                                'Health';
                            break;
                          case CostType.time:
                            icon = Icons.timer;
                            label = AppLocalizations.of(context)?.costTime ??
                                'Time';
                            break;
                          case CostType.goodwill:
                            icon = Icons.handshake;
                            label = 'Goodwill';
                            break;
                          case CostType.patience:
                            icon = Icons.hourglass_empty;
                            label = 'Patience';
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            avatar: Icon(icon, size: 16),
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  editCostType = type;
                                });
                              }
                            },
                            selectedColor: Colors.blue.withAlpha(200),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: costController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)?.estimatedCostLabel ??
                              'Cost Amount (per relapse/duration)',
                      hintText: 'e.g., 5.0',
                      prefixIcon: Icon(_getCostIcon(editCostType)),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!editIsRecurring && editEventDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                          ?.selectEventDateError ??
                                      'Please select an event date.')),
                            );
                            return;
                          }

                          final updatedTodo = todo.copyWith(
                            todoText: textController.text,
                            tagIds: editTagIds,
                            priority: editPriority,
                            isRecurring: editIsRecurring,
                            eventDate: editEventDate,
                            estimatedCost: double.tryParse(costController.text),
                            costType: editCostType,
                            avoidType: editType,
                            contactId: editContactId,
                            locationName: editLocationName,
                            latitude: editLatitude,
                            longitude: editLongitude,
                            reminderDateTime: editReminderDateTime,
                          );
                          await DatabaseHelper.instance.update(updatedTodo);
                          if (editReminderDateTime != null &&
                              _notificationsEnabled) {
                            if (editType == AvoidType.event) {
                              await NotificationHelper().scheduleReminder(
                                  todo.id!,
                                  updatedTodo.todoText!,
                                  editReminderDateTime!);
                            } else {
                              await NotificationHelper()
                                  .scheduleDailyItemReminder(
                                      todo.id!,
                                      updatedTodo.todoText!,
                                      editReminderDateTime!);
                            }
                          } else if (todo.reminderDateTime != null) {
                            await NotificationHelper().cancelReminder(todo.id!);
                          }
                          _fetchTodos();
                          if (context.mounted) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _fabBaseColor,
                          foregroundColor: Colors.white,
                        ),
                        child:
                            Text(AppLocalizations.of(context)?.save ?? 'Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _triggerRelapse(ToDo todo) async {
    final xpProvider = context.read<XpProvider>();
    final isPlus = context.read<PurchaseProvider>().isPlus;
    final messenger = ScaffoldMessenger.of(context);
    final updatedTodo = todo.copyWith(
      lastRelapsedAt: DateTime.now(),
      relapseCount: todo.relapseCount + 1,
    );
    await DatabaseHelper.instance.update(updatedTodo);

    final relapseLogId = await DatabaseHelper.instance.addRelapseLog(
      RelapseLog(todoId: todo.id!),
    );

    await xpProvider.award(
      XpHelper.sourceRelapse,
      XpHelper.xpRelapse,
    );

    if (isPlus) {
      await NotificationHelper().scheduleRelapseFollowUp();
    }

    _fetchTodos();
    if (!mounted) return;

    await _showRelapseReflectionPrompt(
      todo: todo,
      relapseLogId: relapseLogId,
      isPlus: isPlus,
    );

    final trustedSupport = _trustedSupportContact;
    if (isPlus && (trustedSupport?.isEnabled ?? false)) {
      await _showTrustedSupportPrompt(trustedSupport!);
    }

    final tip = getTipForRelapse();
    if (tip != null) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('💡 $tip'),
              duration: const Duration(seconds: 6),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  SnackBar _buildPromptSnackBar({
    required String message,
    required String actionLabel,
    required IconData icon,
    required Color actionColor,
    required VoidCallback onAction,
  }) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withAlpha(230),
      persist: false,
      showCloseIcon: true,
      closeIconColor: Colors.white70,
      action: SnackBarAction(
        label: actionLabel,
        textColor: actionColor,
        onPressed: onAction,
      ),
    );
  }

  Future<void> _showRelapseReflectionPrompt({
    required ToDo todo,
    required int relapseLogId,
    required bool isPlus,
  }) async {
    if (!mounted) return;

    var tapped = false;
    final messenger = ScaffoldMessenger.of(context);
    final controller = messenger.showSnackBar(
      _buildPromptSnackBar(
        message: '"${todo.todoText}" relapsed. Add why?',
        actionLabel: 'Reflect',
        icon: Icons.edit_note_outlined,
        actionColor: const Color(0xFFFFC9C9),
        onAction: () {
          tapped = true;
        },
      ),
    );

    final reason = await controller.closed;
    if (!mounted || !tapped || reason != SnackBarClosedReason.action) return;

    await _showRelapseReflectionSheet(
      relapseLogId: relapseLogId,
      isPlus: isPlus,
    );
  }

  Future<void> _showRelapseReflectionSheet({
    required int relapseLogId,
    required bool isPlus,
  }) async {
    if (!mounted) return;
    final xpProvider = context.read<XpProvider>();
    final noteController = TextEditingController();
    String? selectedCause;

    const causeOptions = [
      'Stress',
      'Boredom',
      'Environment',
      'Social pressure',
      'Impulse',
      'Other',
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What triggered it?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Optional. You can review this later in History.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                if (isPlus) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'What caused it?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: causeOptions.map((cause) {
                      final selected = selectedCause == cause;
                      return FilterChip(
                        label:
                            Text(cause, style: const TextStyle(fontSize: 12)),
                        selected: selected,
                        onSelected: (_) => setSheetState(() {
                          selectedCause = selected ? null : cause;
                        }),
                        selectedColor: tdAvoidRed.withAlpha(30),
                        checkmarkColor: tdAvoidRed,
                        side: BorderSide(
                          color: selected
                              ? tdAvoidRed.withAlpha(150)
                              : Colors.grey.withAlpha(80),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: 'Optional notes...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final note = noteController.text.trim();
                          await DatabaseHelper.instance.updateRelapseLogDetails(
                            relapseLogId,
                            triggerNote: note.isEmpty ? null : note,
                            causeTag: selectedCause,
                          );

                          if (note.isNotEmpty) {
                            await xpProvider.award(
                              XpHelper.sourceTriggerNote,
                              XpHelper.xpTriggerNote,
                            );
                          }
                          if (isPlus && selectedCause != null) {
                            await xpProvider.award(
                              XpHelper.sourceFollowUpCause,
                              XpHelper.xpFollowUpCause,
                            );
                          }

                          if (!mounted || !ctx.mounted) return;
                          Navigator.pop(ctx);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                note.isNotEmpty || selectedCause != null
                                    ? 'Reflection saved.'
                                    : 'Nothing was added.',
                              ),
                            ),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAvoidReflectionPrompt(ToDo todo) async {
    if (!mounted || todo.id == null) return;

    var tapped = false;
    final messenger = ScaffoldMessenger.of(context);
    final controller = messenger.showSnackBar(
      _buildPromptSnackBar(
        message: '"${todo.todoText}" avoided. What worked?',
        actionLabel: 'Reflect',
        icon: Icons.lightbulb_outline,
        actionColor: const Color(0xFFB8F5E0),
        onAction: () {
          tapped = true;
        },
      ),
    );

    final reason = await controller.closed;
    if (!mounted || !tapped || reason != SnackBarClosedReason.action) return;

    await _showWhatWorkedSheet(
      todo.id!,
      todo.todoText ?? 'This item',
      0,
      reflectionType: 'avoid',
    );
  }

  /// Shows the optional "What Worked?" reflection bottom sheet.
  Future<void> _showWhatWorkedSheet(
    String todoId,
    String todoText,
    int milestoneDays, {
    required String reflectionType,
  }) async {
    if (!mounted) return;
    final xpProvider = context.read<XpProvider>();
    final noteController = TextEditingController();

    const chipOptions = [
      'Kept busy',
      'Avoided triggers',
      'Told someone',
      'Distracted myself',
      'Remembered my why',
      'Other',
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        String? selectedChip;
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Celebration header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 36)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reflectionType == 'milestone'
                                  ? _milestoneCelebTitle(milestoneDays)
                                  : 'Nice save! 💪',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              reflectionType == 'milestone'
                                  ? '$milestoneDays days avoiding "$todoText"'
                                  : 'You avoided "$todoText"',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'What helped you stay strong?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Optional — helps track what works for you.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chipOptions.map((chip) {
                      final selected = selectedChip == chip;
                      return FilterChip(
                        label: Text(chip, style: const TextStyle(fontSize: 13)),
                        selected: selected,
                        onSelected: (_) => setSheetState(() {
                          selectedChip = selected ? null : chip;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      hintText: 'Add a note... (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Skip'),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () async {
                          final note = noteController.text.trim();
                          final hasReflection =
                              selectedChip != null || note.isNotEmpty;
                          Navigator.pop(ctx);
                          if (hasReflection) {
                            await DatabaseHelper.instance
                                .addMilestoneReflection(
                              todoId: todoId,
                              milestoneDays: milestoneDays,
                              reflectionType: reflectionType,
                              chipTag: selectedChip,
                              note: note.isNotEmpty ? note : null,
                            );
                          }
                          if (hasReflection) {
                            await xpProvider.award(
                              XpHelper.sourceWhatWorked,
                              XpHelper.xpWhatWorked,
                            );
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  hasReflection
                                      ? '+10 XP — Reflection saved! 💪'
                                      : 'No reflection added.',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text('Save reflection'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _milestoneCelebTitle(int days) {
    if (days >= 90) return 'Quarter Year! 🏆';
    if (days >= 30) return 'Iron Month! 🛡️';
    return '7-Day Streak! ⚡';
  }

  Widget _buildShimmerList(bool isDark) {
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox({Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _runFilter(value),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
          ),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)?.search ?? 'Search',
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Goals UI
  // ─────────────────────────────────────────────────────────────

  Widget _buildGoalsSection(List<Goal> goals, bool isPlus, bool isDark) {
    final textSecondary =
        isDark ? AppThemes.darkTextSecondary : AppThemes.lightTextSecondary;

    // ── Collapsed strip ──────────────────────────────────────────
    if (!_goalsExpanded) {
      // Pick the first goal for the inline summary
      final first = goals.isNotEmpty ? goals.first : null;
      final prog = first != null
          ? GoalHelper.progress(first, todosList, _monthlyMoneySavings)
          : 0.0;
      final label = first != null
          ? GoalHelper.progressLabel(first, todosList, _monthlyMoneySavings)
          : '';
      final desc = first != null
          ? GoalHelper.description(first)
          : (isPlus ? 'Tap to add a goal' : '');

      return GestureDetector(
        onTap: () => setState(() => _goalsExpanded = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
              const Icon(Icons.flag_rounded, size: 14, color: Colors.teal),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (first != null) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: prog,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          prog >= 1.0 ? Colors.green : Colors.teal),
                      minHeight: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
              ],
              const SizedBox(width: 6),
              Icon(Icons.expand_more, size: 16, color: textSecondary),
            ],
          ),
        ),
      );
    }

    // ── Expanded view ────────────────────────────────────────────
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with collapse button
        Row(
          children: [
            const Icon(Icons.flag_rounded, size: 16, color: Colors.teal),
            const SizedBox(width: 6),
            Text(
              isPlus
                  ? 'Goals${goals.isNotEmpty ? ' (${goals.length})' : ''}'
                  : 'Your Goal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
            const Spacer(),
            if (isPlus)
              GestureDetector(
                onTap: () => _showAddGoalSheet(context),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 16, color: Colors.teal),
                    SizedBox(width: 4),
                    Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _goalsExpanded = false),
              child: Icon(Icons.expand_less, size: 18, color: textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Cards
        if (goals.isEmpty && isPlus)
          _buildEmptyGoalCard(isDark)
        else if (goals.length == 1)
          _buildGoalCard(goals.first, isPlus, isDark)
        else
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: goals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => SizedBox(
                  width: 280, child: _buildGoalCard(goals[i], isPlus, isDark)),
            ),
          ),
      ],
    );
  }

  Widget _buildGoalCard(Goal goal, bool isPlus, bool isDark) {
    final prog = GoalHelper.progress(goal, todosList, _monthlyMoneySavings);
    final label =
        GoalHelper.progressLabel(goal, todosList, _monthlyMoneySavings);
    final desc = GoalHelper.description(goal);
    final isDone = prog >= 1.0;
    final progressColor = isDone ? Colors.green : Colors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.teal.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withAlpha(30) : Colors.grey.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isDone ? '✅' : '🎯',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDone
                        ? Colors.green
                        : (isDark
                            ? AppThemes.darkTextSecondary
                            : AppThemes.lightTextSecondary),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isPlus)
                GestureDetector(
                  onTap: () {
                    if (goal.id != null) {
                      context
                          .read<GoalProvider>()
                          .removeGoal(goal.id!, isPlus: isPlus);
                    }
                  },
                  child: Icon(Icons.close,
                      size: 14,
                      color: isDark
                          ? AppThemes.darkTextSecondary
                          : AppThemes.lightTextSecondary),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: prog,
              backgroundColor: isDark ? Colors.white12 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDone
                  ? Colors.green
                  : (isDark
                      ? AppThemes.darkTextSecondary
                      : AppThemes.lightTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGoalCard(bool isDark) {
    return GestureDetector(
      onTap: () => _showAddGoalSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.teal.withValues(alpha: 0.25)),
        ),
        child: const Row(
          children: [
            Icon(Icons.add_circle_outline, color: Colors.teal, size: 20),
            SizedBox(width: 10),
            Text(
              'Tap to add a goal',
              style: TextStyle(
                fontSize: 13,
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    GoalType type = GoalType.streak;
    ToDo? selectedTodo = todosList.isNotEmpty ? todosList.first : null;
    final targetController = TextEditingController(text: '7');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Goal type selector
              Row(
                children: [
                  Expanded(
                    child: _typeChip(
                      label: '🏃 Streak',
                      selected: type == GoalType.streak,
                      onTap: () => setSheetState(() => type = GoalType.streak),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _typeChip(
                      label: '💰 Monthly Savings',
                      selected: type == GoalType.savingsMonth,
                      onTap: () =>
                          setSheetState(() => type = GoalType.savingsMonth),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Habit picker (streak only)
              if (type == GoalType.streak && todosList.isNotEmpty) ...[
                const Text('Habit',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                DropdownButtonFormField<ToDo>(
                  initialValue: selectedTodo,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), isDense: true),
                  items: todosList
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.todoText ?? '',
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) => setSheetState(() => selectedTodo = val),
                ),
                const SizedBox(height: 16),
              ],
              // Target value
              Text(
                type == GoalType.streak
                    ? 'Target streak (days)'
                    : 'Target savings (\$)',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final target = double.tryParse(targetController.text);
                        if (target == null || target <= 0) return;
                        final goal = Goal(
                          type: type,
                          todoId:
                              type == GoalType.streak ? selectedTodo?.id : null,
                          todoText: type == GoalType.streak
                              ? selectedTodo?.todoText
                              : null,
                          targetValue: target,
                          createdAt: DateTime.now(),
                        );
                        context.read<GoalProvider>().addGoal(goal);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Create Goal'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Colors.teal.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.teal : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.teal : null,
            ),
          ),
        ),
      ),
    );
  }

  String _trustedSupportSubtitle() {
    final contact = _trustedSupportContact;
    if (contact == null) {
      return 'Prepare a message to one saved supporter after a relapse';
    }

    final channel =
        contact.channel == TrustedSupportChannel.sms ? 'SMS' : 'Email';
    final masked = TrustedSupportHelper.maskDestination(
      contact.channel,
      contact.destinationValue,
    );
    final status = contact.isEnabled ? 'On' : 'Off';
    return '${contact.contactName} · $channel · $masked · $status';
  }

  Widget _buildPlusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Plus',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _labelText(Object? label, String fallback) {
    if (label == null) return fallback;
    final text = label.toString();
    if (text.contains('.')) {
      return text.split('.').last;
    }
    return text;
  }

  Future<_TrustedSupportChoice?> _pickTrustedSupportChoice() async {
    final granted = await FlutterContacts.requestPermission(readonly: true);
    if (!granted) return null;

    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return null;

    final choices = <_TrustedSupportChoice>[
      for (final phone in contact.phones)
        if (phone.number.trim().isNotEmpty)
          _TrustedSupportChoice(
            contactId: contact.id,
            contactName: contact.displayName,
            channel: TrustedSupportChannel.sms,
            destinationValue: phone.number.trim(),
            destinationLabel: _labelText(phone.label, 'Phone'),
          ),
      for (final email in contact.emails)
        if (email.address.trim().isNotEmpty)
          _TrustedSupportChoice(
            contactId: contact.id,
            contactName: contact.displayName,
            channel: TrustedSupportChannel.email,
            destinationValue: email.address.trim(),
            destinationLabel: _labelText(email.label, 'Email'),
          ),
    ];

    if (choices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('That contact has no phone number or email to use.'),
          ),
        );
      }
      return null;
    }

    if (choices.length == 1) return choices.first;

    if (!mounted) return null;
    return showModalBottomSheet<_TrustedSupportChoice>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Choose how to reach ${contact.displayName}'),
              subtitle:
                  const Text('Pick the exact destination to prepare later'),
            ),
            for (final choice in choices)
              ListTile(
                leading: Icon(
                  choice.channel == TrustedSupportChannel.sms
                      ? Icons.sms_outlined
                      : Icons.email_outlined,
                ),
                title: Text(
                  choice.channel == TrustedSupportChannel.sms ? 'SMS' : 'Email',
                ),
                subtitle: Text(
                  '${choice.destinationLabel} · ${choice.destinationValue}',
                ),
                onTap: () => Navigator.pop(ctx, choice),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _showTrustedSupportSettings() async {
    TrustedSupportContact? draft = _trustedSupportContact;
    var enabled = draft?.isEnabled ?? true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trusted Support',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Avoid opens a message for your saved supporter. You review and send it yourself.',
                    style: TextStyle(color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: tdAvoidRed.withAlpha(25),
                        child: const Icon(Icons.favorite_border,
                            color: tdAvoidRed),
                      ),
                      title:
                          Text(draft?.contactName ?? 'No supporter selected'),
                      subtitle: Text(
                        draft == null
                            ? 'Choose one trusted person from your phone contacts'
                            : (() {
                                final currentDraft = draft!;
                                final channel = currentDraft.channel ==
                                        TrustedSupportChannel.sms
                                    ? 'SMS'
                                    : 'Email';
                                final masked =
                                    TrustedSupportHelper.maskDestination(
                                  currentDraft.channel,
                                  currentDraft.destinationValue,
                                );
                                return '$channel · ${currentDraft.destinationLabel} · $masked';
                              })(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () async {
                      final choice = await _pickTrustedSupportChoice();
                      if (choice == null) return;
                      setSheetState(() {
                        draft = TrustedSupportContact(
                          id: draft?.id,
                          contactId: choice.contactId,
                          contactName: choice.contactName,
                          channel: choice.channel,
                          destinationValue: choice.destinationValue,
                          destinationLabel: choice.destinationLabel,
                          isEnabled: enabled,
                          createdAt: draft?.createdAt,
                        );
                      });
                    },
                    icon: const Icon(Icons.contact_phone_outlined),
                    label: Text(draft == null
                        ? 'Select trusted supporter'
                        : 'Change supporter'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable after relapse'),
                    subtitle: const Text(
                      'Show the prepared message sheet after you log a relapse',
                    ),
                    value: enabled && draft != null,
                    onChanged: draft == null
                        ? null
                        : (value) => setSheetState(() => enabled = value),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (_trustedSupportContact != null)
                        TextButton(
                          onPressed: () async {
                            await DatabaseHelper.instance
                                .deleteTrustedSupportContact();
                            if (!mounted) return;
                            setState(() => _trustedSupportContact = null);
                            if (ctx.mounted) Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Trusted support removed.'),
                              ),
                            );
                          },
                          child: const Text('Remove'),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: draft == null
                            ? null
                            : () async {
                                final saved = draft!.copyWith(
                                  isEnabled: enabled,
                                );
                                await DatabaseHelper.instance
                                    .upsertTrustedSupportContact(saved);
                                if (!mounted) return;
                                setState(() => _trustedSupportContact = saved);
                                if (ctx.mounted) Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      enabled
                                          ? 'Trusted support is ready.'
                                          : 'Trusted support saved but turned off.',
                                    ),
                                  ),
                                );
                              },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTrustedSupportPrompt(TrustedSupportContact contact) async {
    final templates = TrustedSupportHelper.buildTemplates(contact.contactName);
    var selectedIndex = 0;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reach out to ${contact.contactName}?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A message is ready. Avoid will open the composer for your saved supporter.',
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: Icon(
                      contact.channel == TrustedSupportChannel.sms
                          ? Icons.sms_outlined
                          : Icons.email_outlined,
                      color: tdAvoidRed,
                    ),
                    title: Text(contact.contactName),
                    subtitle: Text(
                      '${contact.channel == TrustedSupportChannel.sms ? 'SMS' : 'Email'} · ${TrustedSupportHelper.maskDestination(contact.channel, contact.destinationValue)}',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a message',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                RadioGroup<int>(
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => selectedIndex = value);
                    }
                  },
                  child: Column(
                    children: [
                      for (var i = 0; i < templates.length; i++)
                        RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          value: i,
                          title: Text(templates[i].label),
                          subtitle: Text(templates[i].body),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Not now'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final body = templates[selectedIndex].body;
                          Navigator.pop(ctx);
                          await Future<void>.delayed(
                            const Duration(milliseconds: 100),
                          );
                          final result = await TrustedSupportHelper
                              .composeTrustedSupportMessage(
                            contact: contact,
                            body: body,
                          );
                          if (!mounted) return;
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                switch (result) {
                                  TrustedSupportComposeResult.opened =>
                                    'Composer opened for ${contact.contactName}.',
                                  TrustedSupportComposeResult.sent =>
                                    'Message sent to ${contact.contactName}.',
                                  TrustedSupportComposeResult.cancelled =>
                                    'Message canceled.',
                                  TrustedSupportComposeResult.unavailable =>
                                    'This device cannot open that messaging option right now.',
                                  TrustedSupportComposeResult.error =>
                                    'Could not open the message composer.',
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text('Open message'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlusDialog(BuildContext context, {String? subtitle}) {
    showPlusUpgradeDialog(context, subtitle: subtitle);
  }

  Future<void> _showTrialDebugDialog() async {
    final messenger = ScaffoldMessenger.of(context);
    final purchase = context.read<PurchaseProvider>();
    final debugState = await purchase.trialDebugState();
    if (!mounted) return;
    if (debugState == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Trial debugging is unavailable here.')),
      );
      return;
    }

    final status = debugState.status;
    final diagnostics = <String>[
      'Storage: ${debugState.storageLabel}',
      'Storage available: ${debugState.isStorageAvailable}',
      'Local cache present: ${debugState.hasCachedStatus}',
      'Active trial: ${purchase.hasActiveTrial}',
      'Paid Plus: ${purchase.hasPurchasedPlus}',
      if (status != null) ...[
        'Source: ${status.source.name}',
        'Account key: ${status.accountKey}',
        'Started UTC: ${status.startedAtUtc.toIso8601String()}',
        'Expires UTC: ${status.expiresAtUtc.toIso8601String()}',
        'Last seen UTC: ${status.lastSeenAtUtc.toIso8601String()}',
      ] else
        'Remote status: none found',
    ].join('\n');

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Trial Diagnostics'),
        content: SingleChildScrollView(
          child: SelectableText(
            diagnostics,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final expired = await purchase.expireTrialDebugState();
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    expired
                        ? 'Trial marked as expired in local cache and cloud storage.'
                        : 'Could not expire the trial. Make sure the same iCloud/Google account is available and that a trial exists.',
                  ),
                ),
              );
            },
            child: const Text('Expire Trial'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final cleared = await purchase.resetTrialDebugState();
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    cleared
                        ? 'Trial state cleared from local cache and cloud storage.'
                        : 'Could not clear trial state. Make sure the same iCloud/Google account is available.',
                  ),
                ),
              );
            },
            child: const Text('Reset Trial'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_selectedIndex == 1) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Text('Statistics'),
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _fetchTodos();
            setState(() => _selectedIndex = 0);
          },
        ),
        title: const Text('History'),
      );
    }
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: const Text(
        'Avoid To Do',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        Consumer<PurchaseProvider>(
          builder: (context, purchase, _) {
            if (purchase.hasPurchasedPlus) return const SizedBox.shrink();

            if (purchase.hasActiveTrial && purchase.trialStatus != null) {
              final expiresAt = DateFormat.yMMMd()
                  .format(purchase.trialStatus!.expiresAtUtc.toLocal());
              return IconButton(
                icon: const Icon(Icons.timer_outlined, color: Colors.orange),
                tooltip: 'Trial active until $expiresAt',
                onPressed: () => _showPlusDialog(
                  context,
                  subtitle:
                      'Your free trial is active until $expiresAt. Purchase Plus to keep access after it ends.',
                ),
              );
            }

            return IconButton(
              icon: const Icon(Icons.star_outline, color: Colors.amber),
              tooltip: 'Unlock Plus',
              onPressed: () => _showPlusDialog(context),
            );
          },
        ),
        Builder(
          builder: (context) => IconButton(
            key: _menuKey,
            icon: Icon(Icons.settings, color: _fabBaseColor),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }

  Drawer _buildDrawer(ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: tdAvoidRed,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/avoid_logo.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n?.appTitle ?? 'Avoid ToDo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n?.appTagline ?? 'Stay productive by avoiding!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n?.language ?? 'Language',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const LanguageSettingsTile(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n?.theme ?? 'Theme',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          RadioGroup<ThemeModeOption>(
            groupValue: themeProvider.themeModeOption,
            onChanged: (value) {
              if (value != null) themeProvider.setTheme(value);
            },
            child: Column(
              children: [
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.system ?? 'System'),
                  value: ThemeModeOption.system,
                  secondary: const Icon(Icons.brightness_auto),
                ),
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.light ?? 'Light'),
                  value: ThemeModeOption.light,
                  secondary: const Icon(Icons.brightness_7),
                ),
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.dark ?? 'Dark'),
                  value: ThemeModeOption.dark,
                  secondary: const Icon(Icons.brightness_2),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n?.notifications ?? 'Notifications',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l10n?.enableNotifications ?? 'Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (val) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('notifications_enabled', val);
              setState(() => _notificationsEnabled = val);
              if (val) {
                await NotificationHelper().scheduleDailyCheckInNotification();
                await NotificationHelper().scheduleWeeklyDigest();
              } else {
                await NotificationHelper().cancelAllNotifications();
              }
            },
          ),
          // Home Screen Widget toggle (Plus-gated, always visible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              l10n?.drawerWidget ?? 'Widget',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Builder(builder: (context) {
            final isPlus = context.read<PurchaseProvider>().isPlus;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.widgets_outlined,
                    color: isPlus ? null : Colors.grey,
                  ),
                  title: Row(
                    children: [
                      Text(l10n?.homeScreenWidget ?? 'Home Screen Widget'),
                      if (!isPlus) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Plus',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    l10n?.homeScreenWidgetDesc ??
                        'Shows your top streak on the home screen',
                    style: TextStyle(color: isPlus ? null : Colors.grey),
                  ),
                  value: isPlus && _widgetEnabled,
                  onChanged: isPlus
                      ? (val) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('widget_enabled', val);
                          setState(() => _widgetEnabled = val);
                          if (val) {
                            final active = todosList
                                .where((t) => !t.isArchived && t.isRecurring)
                                .toList();
                            await HomeWidgetHelper.update(active);
                          }
                        }
                      : (_) => _showPlusDialog(context,
                          subtitle:
                              'Unlock Plus to use the home screen widget.'),
                ),
                if (isPlus && _widgetEnabled)
                  ListTile(
                    leading: const Icon(Icons.add_to_home_screen),
                    title: Text(l10n?.addWidgetToHomeScreen ??
                        'Add widget to home screen'),
                    subtitle: Text(l10n?.addWidgetInstructions ??
                        'Instructions & quick-add button'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WidgetSetupScreen(),
                        ),
                      );
                    },
                  ),
              ],
            );
          }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              'Commitment Check-In',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Builder(builder: (context) {
            final isPlus = context.read<PurchaseProvider>().isPlus;
            return ListTile(
              leading: Icon(
                Icons.flag_outlined,
                color: isPlus ? null : Colors.grey,
              ),
              title: Row(
                children: [
                  const Text('Commitment Check-In'),
                  if (!isPlus) ...[
                    const SizedBox(width: 8),
                    _buildPlusBadge(),
                  ],
                ],
              ),
              subtitle: Text(
                _commitmentFrequencySubtitle(isPlus),
                style: TextStyle(color: isPlus ? null : Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (!isPlus) {
                  _showPlusDialog(
                    context,
                    subtitle: 'Unlock Plus to control the commitment check-in.',
                  );
                  return;
                }
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showCommitmentPromptSettings();
                });
              },
            );
          }),
          // Cloud Sync toggle (Plus-gated, always visible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              l10n?.cloudSync ?? 'Cloud Sync',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Builder(builder: (context) {
            final purchase = context.watch<PurchaseProvider>();
            final hasPurchasedPlus = purchase.hasPurchasedPlus;
            final hasTrial = purchase.hasActiveTrial;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.cloud_sync_outlined,
                    color: hasPurchasedPlus ? null : Colors.grey,
                  ),
                  title: Row(
                    children: [
                      Text(l10n?.cloudSync ?? 'Cloud Sync'),
                      if (!hasPurchasedPlus) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: hasTrial
                                ? Colors.blueGrey.shade600
                                : Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            hasTrial ? 'Buy Plus' : 'Plus',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    hasTrial
                        ? 'Cloud backup unlocks after purchasing Plus.'
                        : (l10n?.cloudSyncDesc ??
                            'Auto-backup to iCloud / Google Drive'),
                    style:
                        TextStyle(color: hasPurchasedPlus ? null : Colors.grey),
                  ),
                  value: hasPurchasedPlus && _syncEnabled,
                  onChanged: hasPurchasedPlus
                      ? (val) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('sync_enabled', val);
                          setState(() => _syncEnabled = val);
                          if (val) {
                            await SyncHelper.uploadIfNeeded();
                          }
                        }
                      : (_) => _showPlusDialog(
                            context,
                            subtitle: hasTrial
                                ? 'Cloud backup and restore unlock after purchasing Plus.'
                                : 'Unlock Plus to use cloud backup.',
                          ),
                ),
                if (hasPurchasedPlus && _syncEnabled)
                  ListTile(
                    leading: const Icon(Icons.manage_history_outlined),
                    title: Text(l10n?.manageSync ?? 'Manage sync'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SyncScreen()),
                      );
                    },
                  ),
              ],
            );
          }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              'Trusted Support',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Builder(builder: (context) {
            final isPlus = context.read<PurchaseProvider>().isPlus;
            return ListTile(
              leading: Icon(
                Icons.support_agent_outlined,
                color: isPlus ? null : Colors.grey,
              ),
              title: Row(
                children: [
                  const Text('Trusted Support'),
                  if (!isPlus) ...[
                    const SizedBox(width: 8),
                    _buildPlusBadge(),
                  ],
                ],
              ),
              subtitle: Text(
                _trustedSupportSubtitle(),
                style: TextStyle(color: isPlus ? null : Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (!isPlus) {
                  _showPlusDialog(
                    context,
                    subtitle:
                        'Unlock Plus to set up Trusted Support after a relapse.',
                  );
                  return;
                }
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showTrustedSupportSettings();
                });
              },
            );
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n?.help ?? 'Help & Guide'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          if (kDebugMode) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                'Debug',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text('Trial diagnostics'),
              subtitle: const Text('Inspect and reset trial storage'),
              onTap: () async {
                Navigator.pop(context);
                await _showTrialDebugDialog();
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n?.about ?? 'About'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(l10n?.appTitle ?? 'Avoid Todo App'),
                    content: Text(
                        '${l10n?.aboutDescription ?? 'Never forget what you need to avoid anymore.'}\n\nVersion $_appVersion'),
                    actions: [
                      TextButton(
                        child: Text(l10n?.close ?? 'Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orange),
            title: Text(l10n?.resetTutorial ?? 'Reset Tutorial',
                style: const TextStyle(color: Colors.orange)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasSeenOnboarding', false);
              await prefs.setBool('hasSeenCoachMarks', false);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n?.tutorialResetSuccess ??
                        'Tutorial reset. Restart the app to see the walkthrough again.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
