import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../helpers/database_helper.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../constants/themes.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/purchase_provider.dart';
import '../providers/xp_provider.dart';
import '../helpers/xp_helper.dart';

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

  // Relapse pattern data
  List<int> relapsesByDay = List.filled(7, 0); // index 0=Mon...6=Sun
  List<MapEntry<String, int>> topTriggerWords = [];

  // Badge flags
  bool is24hUnlocked = false;
  bool is7dUnlocked = false;
  bool isBudgetUnlocked = false;
  bool isMegaUnlocked = false;
  bool isConsistencyUnlocked = false;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => isLoading = true);

    final isPlus = context.read<PurchaseProvider>().isPlus;

    // Always load — free tier data
    final avoided = await DatabaseHelper.instance.getTotalAvoidedCount();
    final active = await DatabaseHelper.instance.getActiveCount();
    final weekly = await DatabaseHelper.instance.getWeeklyStats();

    // Fetch recent relapses — free users get last 5, Plus gets last 10
    final db = await DatabaseHelper.instance.database;
    final relapseLimit = isPlus ? 10 : 5;
    final relapsesResult = await db.rawQuery('''
      SELECT r.relapsedAt, r.triggerNote, t.todoText
      FROM relapse_logs r
      JOIN todo t ON r.todoId = t.id
      ORDER BY r.relapsedAt DESC
      LIMIT $relapseLimit
    ''');

    // Plus-only data
    Map<String, int> tags = {};
    Map<String, Tag> tagMapData = {};
    Map<TodoPriority, int> priorities = {};
    List<Map<String, dynamic>> topAvoided = [];
    List<int> dayBuckets = List.filled(7, 0);
    List<MapEntry<String, int>> topWords = [];

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
        'i', 'a', 'an', 'the', 'and', 'or', 'but', 'it', 'my', 'me',
        'was', 'is', 'are', 'of', 'to', 'in', 'on', 'at', 'for', 'by',
        'with', 'so', 'had', 'felt', 'got', 'just', 'that', 'this', 'when',
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
    }

    // Calculate savings by type and find longest streak (always loaded for overview cards + badges)
    Map<CostType, double> totalSavings = {
      for (var t in CostType.values) t: 0.0
    };
    Map<CostType, bool> hasType = {for (var t in CostType.values) t: false};
    Duration longestStreak = Duration.zero;
    final allTodos = await DatabaseHelper.instance.readAllTodos(includeArchived: true);

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
        if (!todo.isArchived && streak > longestStreak) {
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
    final current24h = longestStreak.inHours >= 24;
    final current7d = longestStreak.inDays >= 7;
    final currentBudget = totalSavedMoney >= 50;
    final currentMega = totalSavedMoney >= 200;
    final currentConsistency = active >= 5;

    setState(() {
      totalAvoided = avoided;
      activeCount = active;
      savingsByType = totalSavings;
      hasTaskType = hasType;
      tagBreakdown = tags;
      tagMap = tagMapData;
      priorityBreakdown = priorities;
      weeklyStats = weekly;
      mostAvoided = topAvoided;
      recentRelapses = relapsesResult;
      is24hUnlocked = current24h;
      is7dUnlocked = current7d;
      isBudgetUnlocked = currentBudget;
      isMegaUnlocked = currentMega;
      isConsistencyUnlocked = currentConsistency;
      relapsesByDay = dayBuckets;
      topTriggerWords = topWords;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isPlus = context.watch<PurchaseProvider>().isPlus;

    final body = isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FREE: overview cards always visible
                  _buildOverviewCards(l10n),
                  const SizedBox(height: 24),
                  if (totalAvoided == 0 && recentRelapses.isEmpty)
                    _buildZeroState()
                  else ...[
                    // FREE: badges always visible
                    _buildBadgesSection(l10n),
                    const SizedBox(height: 24),
                    // FREE: weekly chart (7-day window, no history needed)
                    _buildWeeklyChart(isDark, l10n),
                    const SizedBox(height: 24),
                    // FREE: recent relapses (last 5)
                    _buildRecentRelapses(isDark, l10n),
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
                  ],
                ],
              ),
            ),
          );

    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.statistics ?? 'Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: body,
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
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
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('Unlock Avoid Plus'),
                    ],
                  ),
                  content: Text(
                    '${context.read<PurchaseProvider>().plusPriceString ?? '\$2.99'} · One-time purchase\n\nUnlock full stats history, relapse patterns, tag breakdown, trigger words, goals, smart notifications, and more.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Maybe later'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await context.read<PurchaseProvider>().purchasePlus();
                      },
                      child: Text('Unlock — ${context.read<PurchaseProvider>().plusPriceString ?? '\$2.99'}'),
                    ),
                  ],
                ),
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
              if (amount <= 0 && !hasThisTask &&
                  type != CostType.money && type != CostType.time &&
                  type != CostType.mood && type != CostType.health) {
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
        final atCap = !isPlus && level >= XpHelper.maxFreeLevel;
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
                          if (atCap) ...[
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
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (atCap)
                        Text(
                          'Unlock Plus to continue levelling up',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : Colors.black54,
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

  Widget _buildBadgesSection(AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.badges ?? 'Badges & Milestones',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildBadgeIcon(
                l10n?.badge24hTitle ?? '24h Freedom',
                l10n?.badge24hDesc ?? '24h streak',
                Icons.timer_outlined,
                is24hUnlocked,
                Colors.blue,
              ),
              _buildBadgeIcon(
                l10n?.badge7dTitle ?? '7 Day Warrior',
                l10n?.badge7dDesc ?? '7 days streak',
                Icons.security_rounded,
                is7dUnlocked,
                Colors.purple,
              ),
              _buildBadgeIcon(
                l10n?.badgeBudgetTitle ?? 'Budget Saver',
                l10n?.badgeBudgetDesc ?? 'Saved \$50',
                Icons.savings_outlined,
                isBudgetUnlocked,
                Colors.green,
              ),
              _buildBadgeIcon(
                l10n?.badgeMegaTitle ?? 'Mega Saver',
                l10n?.badgeMegaDesc ?? 'Saved \$200',
                Icons.workspace_premium,
                isMegaUnlocked,
                Colors.amber,
              ),
              _buildBadgeIcon(
                l10n?.badgeConsistencyTitle ?? 'Consistency',
                l10n?.badgeConsistencyDesc ?? '5+ habits',
                Icons.repeat_rounded,
                isConsistencyUnlocked,
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeIcon(
      String title, String desc, IconData icon, bool isUnlocked, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isUnlocked ? color.withAlpha(25) : Colors.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color.withAlpha(127) : Colors.grey.withAlpha(127),
          width: 2,
        ),
      ),
      child: Tooltip(
        message: desc,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isUnlocked ? color : Colors.grey,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
            Icon(
              isUnlocked ? Icons.lock_open : Icons.lock,
              size: 12,
              color: isUnlocked ? color : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(bool isDark, AppLocalizations? l10n) {
    if (weeklyStats.isEmpty) {
      return const SizedBox.shrink();
    }

    final barGroups = weeklyStats.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (data['count'] as int).toDouble(),
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
            Text(
              l10n?.weeklyActivity ?? 'Weekly Activity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weeklyStats
                          .map((e) => (e['count'] as int).toDouble())
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < weeklyStats.length) {
                            final week =
                                weeklyStats[value.toInt()]['week'] as String;
                            return Text(
                              week.split('-').last,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
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
      return const SizedBox.shrink();
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
            Text(
              l10n?.byTag ?? 'By Tag',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.mostAvoided ?? 'Most Avoided',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                title: Text(data['todoText'] as String),
                trailing: Text(
                  '${data['avoidCount']} ${l10n?.times ?? 'times'}',
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

  Widget _buildRecentRelapses(bool isDark, AppLocalizations? l10n) {
    if (recentRelapses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.recentRelapsesTriggers ?? 'Recent Relapses & Triggers',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recentRelapses.map((data) {
              final date = DateTime.parse(data['relapsedAt'] as String);
              final String timeAgo = _timeAgo(date);
              final note = data['triggerNote'] as String?;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: tdAvoidRed,
                  child: Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 20),
                ),
                title: Text(data['todoText'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: note != null && note.isNotEmpty
                    ? Text('Trigger: $note\n$timeAgo')
                    : Text(timeAgo),
                isThreeLine: note != null && note.isNotEmpty,
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
      return const SizedBox.shrink();
    }

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxDay = relapsesByDay.fold(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relapse Patterns',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            dayLabels[value.toInt()],
                            style: const TextStyle(fontSize: 11),
                          ),
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

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} mins ago';
    } else {
      return 'Just now';
    }
  }
}
