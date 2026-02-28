import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../helpers/database_helper.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../constants/themes.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoading = true;
  int totalAvoided = 0;
  int activeCount = 0;
  double moneySaved = 0.0;
  Map<String, int> tagBreakdown = {};
  Map<String, Tag> tagMap = {};
  Map<TodoPriority, int> priorityBreakdown = {};
  List<Map<String, dynamic>> weeklyStats = [];
  List<Map<String, dynamic>> mostAvoided = [];
  List<Map<String, dynamic>> recentRelapses = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => isLoading = true);

    final avoided = await DatabaseHelper.instance.getTotalAvoidedCount();
    final active = await DatabaseHelper.instance.getActiveCount();
    final tags = await DatabaseHelper.instance.getTagBreakdown();
    final allTags = await DatabaseHelper.instance.getAllTags();
    final tagMapData = {for (final t in allTags) t.id: t};
    final priorities = await DatabaseHelper.instance.getPriorityBreakdown();
    final weekly = await DatabaseHelper.instance.getWeeklyStats();
    final topAvoided = await DatabaseHelper.instance.getMostAvoidedItems();

    // Fetch recent relapses with their todo titles
    final db = await DatabaseHelper.instance.database;
    final relapsesResult = await db.rawQuery('''
      SELECT r.relapsedAt, r.triggerNote, t.todoText 
      FROM relapse_logs r
      JOIN todo t ON r.todoId = t.id
      ORDER BY r.relapsedAt DESC
      LIMIT 10
    ''');

    // Calculate money saved from active habits (duration * cost)
    double totalSaved = 0.0;
    final allTodos = await DatabaseHelper.instance.readAllTodos();
    for (var todo in allTodos) {
      if (todo.isRecurring &&
          todo.estimatedCost != null &&
          todo.estimatedCost! > 0) {
        final duration = DateTime.now().difference(todo.lastRelapsedAt).inDays;
        totalSaved += (duration * todo.estimatedCost!);
      }
    }

    setState(() {
      totalAvoided = avoided;
      activeCount = active;
      moneySaved = totalSaved;
      tagBreakdown = tags;
      tagMap = tagMapData;
      priorityBreakdown = priorities;
      weeklyStats = weekly;
      mostAvoided = topAvoided;
      recentRelapses = relapsesResult;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewCards(l10n),
                    const SizedBox(height: 24),
                    _buildWeeklyChart(isDark, l10n),
                    const SizedBox(height: 24),
                    _buildTagPieChart(isDark, l10n),
                    const SizedBox(height: 24),
                    _buildRecentRelapses(isDark, l10n),
                    const SizedBox(height: 24),
                    _buildMostAvoidedList(l10n),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards(AppLocalizations? l10n) {
    return Column(
      children: [
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
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Money Saved', // l10n later
                '\$${moneySaved.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.amber.shade600,
              ),
            ),
          ],
        ),
      ],
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
            const Text(
              'By Tag',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            const Text(
              'Recent Relapses & Triggers', // Consider adding to l10n
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
