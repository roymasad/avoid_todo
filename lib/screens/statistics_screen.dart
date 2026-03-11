import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/database_helper.dart';
import '../helpers/app_analytics.dart';
import '../helpers/app_crash_reporter.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../model/break_session.dart';
import '../constants/themes.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/purchase_provider.dart';
import '../providers/xp_provider.dart';
import '../helpers/xp_helper.dart';
import '../helpers/badge_helper.dart';
import '../helpers/export_helper.dart';
import '../widgets/plus_upgrade_dialog.dart';
import '../widgets/tracked_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoading = true;
  int totalAvoided = 0;
  int activeCount = 0;
  Map<CostType, double> savingsByType = {};
  Map<CostType, bool> hasTaskType = {};
  Map<String, int> tagBreakdown = {};
  Map<String, Tag> tagMap = {};
  Map<TodoPriority, int> priorityBreakdown = {};
  List<Map<String, dynamic>> weeklyStats = [];
  List<Map<String, dynamic>> mostAvoided = [];
  List<Map<String, dynamic>> recentRelapses = [];
  BreakSessionSummary _breakOverview = const BreakSessionSummary(
    totalStarted: 0,
    totalCompleted: 0,
    helpfulCount: 0,
  );

  // Relapse pattern data
  List<int> relapsesByDay = List.filled(7, 0); // index 0=Mon...6=Sun
  List<MapEntry<String, int>> topTriggerWords = [];

  // Badge data — list of DB rows {id, unlockedAt}
  List<Map<String, dynamic>> _unlockedBadges = [];

  // Phase 3: Full stats history
  Map<String, int> _dailyAvoidanceMap = {};
  List<Map<String, dynamic>> _monthlyStats = [];
  DateTime _heatmapMonth = DateTime.now();

  // Last-7-days daily stats for the weekly chart
  List<Map<String, dynamic>> _dailyStats = [];

  // Track the isPlus value we last loaded for — so we can reload if it changes
  bool? _loadedForIsPlus;

  // Key for capturing the stats body as an image (image export)
  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  /// Called whenever inherited widgets change (includes Provider).
  /// Detects if isPlus flipped after the initial load and re-fetches.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isPlus = context.read<PurchaseProvider>().isPlus;
    if (_loadedForIsPlus != null && _loadedForIsPlus != isPlus && !isLoading) {
      _loadStatistics();
    }
  }

  Future<void> _refreshStatistics() async {
    await AppAnalytics.instance.trackEvent(
      'statistics_refreshed',
      parameters: const {'source_screen': 'statistics_tab'},
    );
    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => isLoading = true);

    // Read isPlus only once per load — capture it before any await so it
    // stays consistent throughout the entire data-fetch sequence.
    final isPlus = context.read<PurchaseProvider>().isPlus;
    _loadedForIsPlus = isPlus;

    try {
      // Always load — free tier data
      final avoided = await DatabaseHelper.instance.getTotalAvoidedCount();
      final active = await DatabaseHelper.instance.getActiveCount();
      final weekly = await DatabaseHelper.instance.getWeeklyStats();
      final daily7 = await DatabaseHelper.instance.getLast7DaysStats();
      final breakOverview =
          await DatabaseHelper.instance.getBreakStatsOverview();

      if (!mounted) return;

      // Fetch recent relapses — free users get last 5, Plus gets last 10
      final db = await DatabaseHelper.instance.database;
      final relapseLimit = isPlus ? 10 : 5;
      final relapsesResult = await db.rawQuery('''
      SELECT r.relapsedAt, r.triggerNote, r.causeTag, t.todoText
      FROM relapse_logs r
      JOIN todo t ON r.todoId = t.id
      ORDER BY r.relapsedAt DESC
      LIMIT $relapseLimit
    ''');

      if (!mounted) return;

      // Plus-only data
      Map<String, int> tags = {};
      Map<String, Tag> tagMapData = {};
      Map<TodoPriority, int> priorities = {};
      List<Map<String, dynamic>> topAvoided = [];
      List<int> dayBuckets = List.filled(7, 0);
      List<MapEntry<String, int>> topWords = [];
      Map<String, int> dailyAvoidanceMapData = {};
      List<Map<String, dynamic>> monthlyStatsData = [];

      if (isPlus) {
        tags = await DatabaseHelper.instance.getTagBreakdown();
        final allTags = await DatabaseHelper.instance.getAllTags();
        tagMapData = {for (final t in allTags) t.id: t};
        priorities = await DatabaseHelper.instance.getPriorityBreakdown();
        topAvoided = await DatabaseHelper.instance.getMostAvoidedItems();

        // Relapse patterns & trigger words (Plus only)
        final allLogs = await DatabaseHelper.instance.getAllRelapseLogsRaw();
        final Map<String, int> wordFreq = {};
        const stopWords = {
          'i',
          'a',
          'an',
          'the',
          'and',
          'or',
          'but',
          'it',
          'my',
          'me',
          'was',
          'is',
          'are',
          'of',
          'to',
          'in',
          'on',
          'at',
          'for',
          'by',
          'with',
          'so',
          'had',
          'felt',
          'got',
          'just',
          'that',
          'this',
          'when',
        };
        for (final log in allLogs) {
          final dateStr = log['relapsedAt'] as String?;
          if (dateStr != null) {
            final date = DateTime.tryParse(dateStr);
            if (date != null) {
              dayBuckets[date.weekday - 1]++;
            }
          }
          final note = (log['triggerNote'] as String? ?? '').toLowerCase();
          if (note.isNotEmpty) {
            for (final word in note.split(RegExp(r'\s+'))) {
              final clean = word.replaceAll(RegExp(r'[^a-z]'), '');
              if (clean.length > 2 && !stopWords.contains(clean)) {
                wordFreq[clean] = (wordFreq[clean] ?? 0) + 1;
              }
            }
          }
        }
        final sortedWords = wordFreq.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        topWords = sortedWords.take(6).toList();

        // Phase 3: Full stats history
        final now = DateTime.now();
        dailyAvoidanceMapData = await DatabaseHelper.instance
            .getDailyAvoidanceMap(now.year, now.month);
        monthlyStatsData = await DatabaseHelper.instance.getMonthlyStats();
      }

      if (!mounted) return;

      // Calculate savings by type and find longest streak (always loaded for overview cards + badges)
      Map<CostType, double> totalSavings = {
        for (var t in CostType.values) t: 0.0
      };
      Map<CostType, bool> hasType = {for (var t in CostType.values) t: false};
      Duration longestStreak = Duration.zero;
      final allTodos =
          await DatabaseHelper.instance.readAllTodos(includeArchived: true);

      for (var todo in allTodos) {
        hasType[todo.costType] = true;
        if (todo.estimatedCost == null || todo.estimatedCost! <= 0) continue;

        double saving = 0.0;
        if (todo.isRecurring) {
          final endTime = todo.isArchived ? todo.updatedAt : DateTime.now();
          final streak = endTime.difference(todo.lastRelapsedAt);
          final double streakDays = todo.isArchived
              ? (streak.inDays >= 1 ? streak.inDays.toDouble() : 1.0)
              : streak.inHours / 24.0;
          if (streakDays > 0) {
            saving = streakDays * todo.estimatedCost!;
          }
          if (streak > longestStreak) {
            longestStreak = streak;
          }
        } else {
          if (todo.isArchived) {
            saving = todo.estimatedCost!;
          }
        }

        if (saving > 0) {
          totalSavings[todo.costType] =
              (totalSavings[todo.costType] ?? 0.0) + saving;
        }
      }

      final totalSavedMoney = totalSavings[CostType.money] ?? 0.0;

      // Badge checking — persist newly earned badges, retrieve all unlocked
      final totalRelapses =
          await DatabaseHelper.instance.getTotalRelapseCount();
      final firstHabitCreatedAt =
          await DatabaseHelper.instance.getFirstHabitCreatedAt();
      final badgeStats = BadgeCheckStats(
        longestStreak: longestStreak,
        totalSavedMoney: totalSavedMoney,
        activeCount: active,
        totalAvoided: avoided,
        totalRelapses: totalRelapses,
        helpfulBreaks: breakOverview.helpfulCount,
        firstHabitCreatedAt: firstHabitCreatedAt,
      );
      final newlyUnlocked =
          await BadgeHelper.checkAndPersistNewBadges(badgeStats);
      final allUnlocked = await DatabaseHelper.instance.getUnlockedBadges();

      setState(() {
        totalAvoided = avoided;
        activeCount = active;
        savingsByType = totalSavings;
        hasTaskType = hasType;
        tagBreakdown = tags;
        tagMap = tagMapData;
        priorityBreakdown = priorities;
        weeklyStats = weekly;
        _dailyStats = daily7;
        _breakOverview = breakOverview;
        mostAvoided = topAvoided;
        recentRelapses = relapsesResult;
        _unlockedBadges = allUnlocked;
        relapsesByDay = dayBuckets;
        topTriggerWords = topWords;
        _dailyAvoidanceMap = dailyAvoidanceMapData;
        _monthlyStats = monthlyStatsData;
        _heatmapMonth = DateTime.now();
        isLoading = false;
      });

      // Celebrate newly unlocked badges with a snackbar
      if (newlyUnlocked.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final id in newlyUnlocked) {
            if (!mounted) break;
            final badge = BadgeHelper.findById(id);
            if (badge == null) continue;
            // Free users: only celebrate free-tier badge unlocks
            if (badge.tier == BadgeTier.plus && !isPlus) continue;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(badge.icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('🏅 New badge: ${badge.title}!'),
                    ),
                  ],
                ),
                backgroundColor: badge.color,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e, st) {
      debugPrint('[StatisticsScreen] _loadStatistics error: $e\n$st');
      await AppCrashReporter.instance.recordError(
        e,
        st,
        reason: 'statistics_load',
      );
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Couldn\'t load some stats. Pull down to retry.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade800,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Fetches heatmap data for the currently displayed month without
  /// touching any other state fields.
  Future<void> _loadHeatmapData() async {
    final map = await DatabaseHelper.instance
        .getDailyAvoidanceMap(_heatmapMonth.year, _heatmapMonth.month);
    if (mounted) setState(() => _dailyAvoidanceMap = map);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isPlus = context.watch<PurchaseProvider>().isPlus;

    final body = isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _refreshStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: RepaintBoundary(
                key: _repaintKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action buttons row shown only when embedded (no AppBar)
                    if (widget.embedded)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildExportIconButton(isPlus),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              tooltip: 'Refresh',
                              visualDensity: VisualDensity.compact,
                              onPressed: _refreshStatistics,
                            ),
                          ],
                        ),
                      ),
                    // FREE: overview cards always visible
                    _buildOverviewCards(l10n),
                    const SizedBox(height: 24),
                    if (totalAvoided == 0 &&
                        recentRelapses.isEmpty &&
                        _breakOverview.totalStarted == 0)
                      _buildZeroState()
                    else ...[
                      // FREE: badges always visible
                      _buildBadgesSection(l10n, isPlus),
                      const SizedBox(height: 24),
                      // FREE: weekly chart (7-day window, no history needed)
                      _buildWeeklyChart(isDark, l10n),
                      const SizedBox(height: 24),
                      _buildBreakInsightsSection(),
                      const SizedBox(height: 24),
                      // PLUS: tag breakdown
                      if (isPlus)
                        _buildTagPieChart(isDark, l10n)
                      else
                        _buildLockedSection(
                          'Tag breakdown',
                          'See which habit categories you struggle with most.',
                          Icons.pie_chart_outline,
                          context,
                        ),
                      const SizedBox(height: 24),
                      // PLUS: relapse patterns by day
                      if (isPlus)
                        _buildRelapsePatterns(isDark)
                      else
                        _buildLockedSection(
                          'Relapse patterns',
                          'Discover which days of the week are your hardest.',
                          Icons.bar_chart_outlined,
                          context,
                        ),
                      const SizedBox(height: 24),
                      // PLUS: most avoided list
                      if (isPlus)
                        _buildMostAvoidedList(l10n)
                      else
                        _buildLockedSection(
                          'Most avoided items',
                          'Track your biggest wins over time.',
                          Icons.emoji_events_outlined,
                          context,
                        ),
                      const SizedBox(height: 24),
                      // PLUS: avoidance calendar heatmap
                      if (isPlus)
                        _buildCalendarHeatmap(isDark)
                      else
                        _buildLockedSection(
                          'Avoidance Calendar',
                          'See your daily avoidance activity as a visual monthly calendar.',
                          Icons.calendar_month_outlined,
                          context,
                        ),
                      const SizedBox(height: 24),
                      // PLUS: monthly trends chart
                      if (isPlus && _monthlyStats.isNotEmpty)
                        _buildMonthlyTrendChart(isDark)
                      else if (!isPlus)
                        _buildLockedSection(
                          'Monthly Trends',
                          'Track your progress month-by-month over the last 12 months.',
                          Icons.trending_up_outlined,
                          context,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          );

    if (widget.embedded) return body;
    return TrackedScreen(
      screenName: 'statistics_tab',
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.statistics ?? 'Statistics'),
          actions: [
            // Export CSV (Plus-gated, always visible)
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.ios_share_outlined),
                  if (!isPlus)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock,
                            size: 8, color: Colors.white),
                      ),
                    ),
                ],
              ),
              tooltip: isPlus ? 'Export' : 'Export (Plus)',
              onPressed: isPlus ? _showExportChoice : _showUpgradeDialog,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshStatistics,
            ),
          ],
        ),
        body: body,
      ),
    );
  }

  // ── Export helpers ────────────────────────────────────────────────────────

  /// Compact export icon button used in the embedded action row.
  Widget _buildExportIconButton(bool isPlus) {
    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.ios_share_outlined, size: 20),
          if (!isPlus)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, size: 8, color: Colors.white),
              ),
            ),
        ],
      ),
      tooltip: isPlus ? 'Export' : 'Export (Plus)',
      visualDensity: VisualDensity.compact,
      onPressed: isPlus ? _showExportChoice : _showUpgradeDialog,
    );
  }

  /// Bottom sheet that lets the user pick export format.
  void _showExportChoice() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Export Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.table_chart_outlined),
                ),
                title: const Text('Export as CSV'),
                subtitle: const Text(
                    'All habits, relapses & monthly summary in one file'),
                onTap: () {
                  Navigator.pop(ctx);
                  _exportData();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.ios_share_outlined),
                ),
                title: const Text('Share Image'),
                subtitle: const Text(
                    'Send your stats dashboard via AirDrop, email, or other apps'),
                onTap: () {
                  Navigator.pop(ctx);
                  _shareAsImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Captures the stats Column as a PNG and returns the saved [File].
  /// Shows and clears a loading snackbar around the capture.
  Future<File?> _captureStatsImage() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Capturing stats…'),
          ],
        ),
        duration: Duration(seconds: 10),
      ),
    );

    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Render boundary not found');

      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('PNG encoding failed');

      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/avoid_stats.png');
      await file.writeAsBytes(bytes);
      messenger.clearSnackBars();
      return file;
    } catch (e, stackTrace) {
      debugPrint('[StatisticsScreen] _captureStatsImage error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        stackTrace,
        reason: 'statistics_capture_image',
      );
      messenger.clearSnackBars();
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text('Could not capture image. Please try again.')),
        );
      }
      return null;
    }
  }

  /// Opens the system share sheet with the stats image PNG.
  Future<void> _shareAsImage() async {
    await AppAnalytics.instance.trackEvent(
      'statistics_share_image',
      parameters: const {'source_screen': 'statistics_tab'},
    );
    if (!mounted) return;
    final file = await _captureStatsImage();
    if (file == null) return;

    try {
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png', name: 'avoid_stats.png')],
      );
    } catch (e, stackTrace) {
      debugPrint('[StatisticsScreen] _shareAsImage error: $e');
      await AppCrashReporter.instance.recordError(
        e,
        stackTrace,
        reason: 'statistics_share_image',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not share image. Please try again.')),
        );
      }
    }
  }

  Future<void> _exportData() async {
    await AppAnalytics.instance.trackEvent(
      'statistics_export_csv',
      parameters: const {'source_screen': 'statistics_tab'},
    );
    if (!mounted) return;
    // Show a brief loading indicator while generating files
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Preparing export…'),
          ],
        ),
        duration: Duration(seconds: 10),
      ),
    );

    final ok = await ExportHelper.exportAllData();
    messenger.clearSnackBars();

    if (!ok && mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Export failed. Please try again.')),
      );
    }
  }

  void _showUpgradeDialog() {
    showPlusUpgradeDialog(context, entryPoint: 'statistics_tab');
  }

  // ── Section header with info tooltip ─────────────────────────────────────
  Widget _sectionHeader(String title, String tooltip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Tooltip(
          message: tooltip,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 4),
          child: Icon(Icons.info_outline,
              size: 16,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45)),
        ),
      ],
    );
  }

  // ── Empty state card ──────────────────────────────────────────────────────
  Widget _buildEmptyState(IconData icon, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        child: Center(
          child: Column(
            children: [
              Icon(icon,
                  size: 36,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.25)),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakInsightsSection() {
    String percent(double value) => '${(value * 100).round()}%';

    Widget pill(String label, String value, IconData icon, Color color) {
      return Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    final summary = _breakOverview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Break Insights',
          'Tracks how often quick urge breaks are used and how often they helped.',
        ),
        const SizedBox(height: 12),
        if (summary.totalStarted == 0)
          _buildEmptyState(
            Icons.play_circle_outline_rounded,
            'No break sessions yet. Use Break from a todo card to log quick urge interruptions.',
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    pill(
                      'Started',
                      summary.totalStarted.toString(),
                      Icons.play_circle_fill_rounded,
                      const Color(0xFF457B9D),
                    ),
                    pill(
                      'Completed',
                      summary.totalCompleted.toString(),
                      Icons.timer_outlined,
                      const Color(0xFF2A9D8F),
                    ),
                    pill(
                      'Helpful',
                      summary.helpfulCount.toString(),
                      Icons.favorite_outline_rounded,
                      const Color(0xFFE76F51),
                    ),
                    pill(
                      'Helpful rate',
                      percent(summary.helpfulRate),
                      Icons.insights_outlined,
                      const Color(0xFF6A4C93),
                    ),
                  ],
                ),
                if (summary.mostHelpedTodoText != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Most helped item: ${summary.mostHelpedTodoText}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLockedSection(
    String title,
    String description,
    IconData icon,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.tonal(
            onPressed: () {
              showPlusUpgradeDialog(
                context,
                entryPoint: 'statistics_locked_section',
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 14),
                SizedBox(width: 4),
                Text('Plus', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(AppLocalizations? l10n) {
    return Column(
      children: [
        _buildXpLevelCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                l10n?.avoided ?? 'Avoided',
                totalAvoided.toString(),
                Icons.check_circle,
                AppThemes.priorityLow,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                l10n?.active ?? 'Active',
                activeCount.toString(),
                Icons.list,
                AppThemes.lightPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n?.savingsSummary ?? 'Savings by Item Type',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = <Widget>[];
            for (final type in CostType.values) {
              final amount = savingsByType[type] ?? 0.0;
              final hasThisTask = hasTaskType[type] ?? false;
              if (amount <= 0 &&
                  !hasThisTask &&
                  type != CostType.money &&
                  type != CostType.time &&
                  type != CostType.mood &&
                  type != CostType.health) {
                continue;
              }
              IconData icon;
              String label;
              Color color;
              String prefix = "";
              String suffix = "";
              switch (type) {
                case CostType.money:
                  icon = Icons.attach_money;
                  label = l10n?.costMoney ?? 'Money';
                  color = Colors.amber.shade700;
                  prefix = "\$";
                  break;
                case CostType.mood:
                  icon = Icons.mood;
                  label = l10n?.costMood ?? 'Mood';
                  color = Colors.blue.shade600;
                  suffix = " pts";
                  break;
                case CostType.health:
                  icon = Icons.health_and_safety;
                  label = l10n?.health ?? 'Health';
                  color = Colors.green.shade600;
                  suffix = " pts";
                  break;
                case CostType.time:
                  icon = Icons.timer;
                  label = l10n?.costTime ?? 'Time';
                  color = Colors.orange.shade700;
                  suffix = " hrs";
                  break;
                case CostType.goodwill:
                  icon = Icons.handshake;
                  label = 'Goodwill';
                  color = Colors.purple.shade600;
                  suffix = " pts";
                  break;
                case CostType.patience:
                  icon = Icons.hourglass_empty;
                  label = 'Patience';
                  color = Colors.teal.shade600;
                  suffix = " pts";
                  break;
              }
              final cardWidth = (constraints.maxWidth - 12) / 2;
              cards.add(SizedBox(
                width: cardWidth,
                child: _buildStatCard(
                  label,
                  "$prefix${amount.toStringAsFixed(amount == amount.toInt() ? 0 : 1)}$suffix",
                  icon,
                  color,
                ),
              ));
            }
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: cards,
            );
          },
        ),
      ],
    );
  }

  Widget _buildXpLevelCard() {
    return Consumer<XpProvider>(
      builder: (context, xp, _) {
        final isPlus = context.read<PurchaseProvider>().isPlus;
        final level = xp.levelCapped(isPlus);
        final title = xp.titleForLevel(level);
        final prog = xp.progress(isPlus);
        final atFreeCap = !isPlus && level >= XpHelper.maxFreeLevel;
        final atMaxLevel = isPlus && level >= XpHelper.maxLevel;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final xpFloor = xp.xpFloor(isPlus);
        final xpCeil = xp.xpCeiling(isPlus);
        final xpInLevel = xp.totalXp - xpFloor;
        final xpNeeded = xpCeil - xpFloor;

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Level badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Level info + progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (atFreeCap) ...[
                            const Spacer(),
                            Text(
                              'Max free level',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (atMaxLevel) ...[
                            const Spacer(),
                            Text(
                              'Max level',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (atFreeCap)
                        Text(
                          'Unlock Plus to continue levelling up',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        )
                      else if (atMaxLevel)
                        Text(
                          'You reached the highest level in Avoid.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        )
                      else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: prog,
                            backgroundColor:
                                isDark ? Colors.white12 : Colors.black12,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.amber),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$xpInLevel / $xpNeeded XP to level ${level + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZeroState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎯', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'Nothing here yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Swipe right on a habit to mark it as avoided — your stats will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection(AppLocalizations? l10n, bool isPlus) {
    final unlockedIds = _unlockedBadges.map((b) => b['id'] as String).toSet();
    final unlockedAtMap = {
      for (final b in _unlockedBadges)
        b['id'] as String: b['unlockedAt'] as String?,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.badges ?? 'Badges & Milestones',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // ── Free badges row ────────────────────────────────────────────────
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: BadgeHelper.freeBadges().map((def) {
              return _buildBadgeCard(
                def: def,
                isUnlocked: unlockedIds.contains(def.id),
                unlockedAt: unlockedAtMap[def.id],
                isPlusLocked: false,
              );
            }).toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'swipe to see more →',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.35),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Plus badges header ─────────────────────────────────────────────
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withAlpha(100)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    'Plus',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Plus Badges',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            if (!isPlus) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: _showUpgradeDialog,
                icon: const Icon(Icons.lock_outline, size: 14),
                label: const Text('Upgrade', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // ── Plus badges row ────────────────────────────────────────────────
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: BadgeHelper.plusBadges().map((def) {
              return _buildBadgeCard(
                def: def,
                isUnlocked: isPlus && unlockedIds.contains(def.id),
                unlockedAt: isPlus ? unlockedAtMap[def.id] : null,
                isPlusLocked: !isPlus,
              );
            }).toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'swipe to see more →',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.35),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required BadgeDefinition def,
    required bool isUnlocked,
    String? unlockedAt,
    bool isPlusLocked = false,
  }) {
    final color = def.color;
    return Opacity(
      opacity: isPlusLocked ? 0.55 : 1.0,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isUnlocked ? color.withAlpha(25) : Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isUnlocked ? color.withAlpha(130) : Colors.grey.withAlpha(60),
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Tooltip(
          message: def.description,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      def.icon,
                      size: 30,
                      color: isUnlocked ? color : Colors.grey.withAlpha(100),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      def.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (isUnlocked && unlockedAt != null)
                      Text(
                        _formatBadgeDate(unlockedAt),
                        style: TextStyle(
                          fontSize: 9,
                          color: color.withAlpha(180),
                        ),
                      )
                    else
                      Icon(
                        isUnlocked ? Icons.lock_open : Icons.lock,
                        size: 10,
                        color: isUnlocked
                            ? color.withAlpha(180)
                            : Colors.grey.withAlpha(100),
                      ),
                  ],
                ),
              ),
              if (isPlusLocked)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBadgeDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildWeeklyChart(bool isDark, AppLocalizations? l10n) {
    // Always show 7 days — use _dailyStats which is pre-padded with zeros
    const dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final data = _dailyStats.isNotEmpty
        ? _dailyStats
        : List.generate(7, (i) {
            final day = DateTime.now().subtract(Duration(days: 6 - i));
            return {'weekday': day.weekday, 'count': 0};
          });

    final maxY = data
        .map((e) => (e['count'] as int).toDouble())
        .fold(0.0, (a, b) => a > b ? a : b);

    final barGroups = data.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: (entry.value['count'] as int).toDouble(),
            color: AppThemes.lightPrimary,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              l10n?.weeklyActivity ?? 'Weekly Activity',
              'How many habits you successfully avoided each day this week.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY > 0 ? maxY * 1.25 : 4,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= data.length) {
                            return const SizedBox.shrink();
                          }
                          final weekday =
                              ((data[i]['weekday'] as int?) ?? 1).clamp(1, 7);
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              dayLetters[weekday - 1],
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= data.length) return null;
                        final weekday =
                            ((data[groupIndex]['weekday'] as int?) ?? 1)
                                .clamp(1, 7);
                        const dayNames = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];
                        final count = (data[groupIndex]['count'] as int?) ?? 0;
                        return BarTooltipItem(
                          '${dayNames[weekday - 1]}\n$count avoided',
                          const TextStyle(color: Colors.white, fontSize: 11),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagPieChart(bool isDark, AppLocalizations? l10n) {
    if (tagBreakdown.isEmpty) {
      return _buildEmptyState(
        Icons.pie_chart_outline,
        'No tags yet.\nAdd tags to your habits to see a breakdown by category.',
      );
    }

    // Since tagBreakdown keys are names, we need to find the corresponding tag for color.
    // However, database_helper.instance.getTagBreakdown() returns names.
    // Let's assume names are unique enough for display, or better, we should have used IDs.
    // In our implementation, we'll try to find the tag in tagMap by comparing names if IDs aren't available.

    final sections = tagBreakdown.entries.map((entry) {
      final tag = tagMap.values.firstWhere(
        (t) => t.name == entry.key,
        orElse: () =>
            Tag(id: '', name: entry.key, colorValue: 0xFF9E9E9E), // Grey
      );

      return PieChartSectionData(
        color: tag.color,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              l10n?.byTag ?? 'By Tag',
              'Breakdown of avoidances by tag — see which categories you struggle with most.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tagBreakdown.entries.map((entry) {
                      final tag = tagMap.values.firstWhere(
                        (t) => t.name == entry.key,
                        orElse: () => Tag(
                            id: '',
                            name: entry.key,
                            colorValue: 0xFF9E9E9E), // Grey
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: tag.color,
                            ),
                            const SizedBox(width: 8),
                            Text('${entry.key}: ${entry.value}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostAvoidedList(AppLocalizations? l10n) {
    if (mostAvoided.isEmpty) {
      return _buildEmptyState(
        Icons.emoji_events_outlined,
        'No completed habits yet.\nArchive a habit to see your biggest wins here.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              l10n?.mostAvoided ?? 'Most Avoided',
              'Your habits ranked by how many times you successfully resisted the urge.',
            ),
            const SizedBox(height: 16),
            ...mostAvoided.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppThemes.lightPrimary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(data['todoText'] as String? ?? ''),
                trailing: Text(
                  '${data['avoidCount'] as int? ?? 0} ${l10n?.times ?? 'times'}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withAlpha(153),
                    fontSize: 14,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRelapsePatterns(bool isDark) {
    final totalRelapses = relapsesByDay.fold(0, (a, b) => a + b);
    if (totalRelapses == 0 && topTriggerWords.isEmpty) {
      return _buildEmptyState(
        Icons.bar_chart_outlined,
        'No relapses logged yet — keep it up! 🎉\nLog a relapse from a habit to see patterns here.',
      );
    }

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxDay = relapsesByDay.fold(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Relapse Patterns',
              'Shows which days of the week you tend to relapse most, and the most common words in your relapse notes.',
            ),
            if (totalRelapses > 0) ...[
              const SizedBox(height: 16),
              const Text(
                'Most Relapse-Prone Days',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxDay > 0 ? maxDay * 1.3 : 1,
                    barGroups: relapsesByDay.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.toDouble(),
                            color: tdAvoidRed,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= dayLabels.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(dayLabels[i],
                                style: const TextStyle(fontSize: 11));
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
            if (topTriggerWords.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Common Trigger Words',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: topTriggerWords.map((entry) {
                  return Chip(
                    label: Text('${entry.key} (${entry.value})'),
                    backgroundColor: tdAvoidRed.withAlpha(30),
                    side: BorderSide(color: tdAvoidRed.withAlpha(100)),
                    labelStyle:
                        const TextStyle(color: tdAvoidRed, fontSize: 12),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────
  // Phase 3 widgets
  // ──────────────────────────────────────────────────────────────────

  String _monthName(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  Widget _buildCalendarHeatmap(bool isDark) {
    final year = _heatmapMonth.year;
    final month = _heatmapMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // startOffset: 0 = Monday, 6 = Sunday
    final startOffset = firstDay.weekday - 1;
    final now = DateTime.now();
    final isCurrentMonth =
        _heatmapMonth.year == now.year && _heatmapMonth.month == now.month;

    final maxCount = _dailyAvoidanceMap.values.isEmpty
        ? 1
        : _dailyAvoidanceMap.values.reduce((a, b) => a > b ? a : b);

    const baseGreen = Color(0xFF43A047);
    const lightGreen = Color(0xFFB9F6CA);
    const darkGreen = Color(0xFF1B5E20);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: title + info tooltip ─────────────────────────
            _sectionHeader(
              'Avoidance Calendar',
              'Each day shows how many habits you avoided. Darker green = more avoided. Navigate between months with the arrows.',
            ),
            const SizedBox(height: 4),
            // ── Month navigation (separate row, never overflows) ──────
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _heatmapMonth =
                          DateTime(_heatmapMonth.year, _heatmapMonth.month - 1);
                    });
                    _loadHeatmapData();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  '${_monthName(_heatmapMonth)} $year',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: isCurrentMonth
                      ? null
                      : () {
                          setState(() {
                            _heatmapMonth = DateTime(
                                _heatmapMonth.year, _heatmapMonth.month + 1);
                          });
                          _loadHeatmapData();
                        },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Day-of-week headers ──────────────────────────────────
            Row(
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((label) {
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),

            // ── Day grid ─────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 1,
              ),
              itemCount: startOffset + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startOffset) return const SizedBox.shrink();

                final day = index - startOffset + 1;
                final dateStr =
                    '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
                final count = _dailyAvoidanceMap[dateStr] ?? 0;
                final isFuture = DateTime(year, month, day).isAfter(now);

                Color cellColor;
                if (isFuture) {
                  cellColor = Colors.transparent;
                } else if (count == 0) {
                  cellColor = isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05);
                } else {
                  final intensity =
                      maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;
                  cellColor =
                      Color.lerp(lightGreen, darkGreen, intensity) ?? baseGreen;
                }

                final isToday = dateStr ==
                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                return Tooltip(
                  message: count > 0 ? '$count avoided' : '',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(4),
                      border: isToday
                          ? Border.all(color: baseGreen, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        isFuture ? '' : '$day',
                        style: TextStyle(
                          fontSize: 9,
                          color: count > 0
                              ? Colors.white.withValues(alpha: 0.85)
                              : (isDark ? Colors.white30 : Colors.black26),
                          fontWeight:
                              count > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // ── Legend ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'None',
                  style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black38),
                ),
                const SizedBox(width: 4),
                ...[0.1, 0.35, 0.6, 0.85, 1.0].map((v) {
                  final c = Color.lerp(lightGreen, darkGreen, v) ?? baseGreen;
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
                const SizedBox(width: 4),
                Text(
                  'More',
                  style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black38),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendChart(bool isDark) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Build a lookup from existing DB data
    final existingMap = <String, int>{};
    for (final s in _monthlyStats) {
      existingMap[s['month'] as String? ?? ''] = (s['count'] as int?) ?? 0;
    }

    // Always generate exactly 12 months (oldest → newest), padding zeros
    final now = DateTime.now();
    final allMonths = List.generate(12, (i) {
      final d = DateTime(now.year, now.month - 11 + i, 1);
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      return {
        'month': key,
        'count': existingMap[key] ?? 0,
        'monthNum': d.month
      };
    });

    final maxCount = allMonths
        .map((e) => e['count'] as int)
        .fold(0, (a, b) => a > b ? a : b);

    final barGroups = allMonths.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: (entry.value['count'] as int).toDouble(),
            color: AppThemes.lightPrimary,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Monthly Trends',
              'Total habit avoidances per month over the last 12 months.',
            ),
            const SizedBox(height: 2),
            Text(
              'Last 12 months',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxCount > 0 ? maxCount * 1.25 : 4,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= allMonths.length) {
                            return const SizedBox.shrink();
                          }
                          final monthNum =
                              ((allMonths[i]['monthNum'] as int?) ?? 1)
                                  .clamp(1, 12);
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              monthNames[monthNum - 1],
                              style: const TextStyle(fontSize: 9),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= allMonths.length) return null;
                        final monthKey =
                            allMonths[groupIndex]['month'] as String;
                        final count = allMonths[groupIndex]['count'] as int;
                        final parts = monthKey.split('-');
                        final label = parts.length == 2
                            ? '${monthNames[((int.tryParse(parts[1]) ?? 1) - 1).clamp(0, 11)]} ${parts[0]}'
                            : monthKey;
                        return BarTooltipItem(
                          '$label\n$count avoided',
                          const TextStyle(color: Colors.white, fontSize: 11),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
