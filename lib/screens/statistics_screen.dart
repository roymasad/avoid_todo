import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../helpers/database_helper.dart';
import '../model/todo.dart';
import '../constants/themes.dart';
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
  Map<TodoCategory, int> categoryBreakdown = {};
  Map<TodoPriority, int> priorityBreakdown = {};
  List<Map<String, dynamic>> weeklyStats = [];
  List<Map<String, dynamic>> mostAvoided = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => isLoading = true);
    
    final avoided = await DatabaseHelper.instance.getTotalAvoidedCount();
    final active = await DatabaseHelper.instance.getActiveCount();
    final categories = await DatabaseHelper.instance.getCategoryBreakdown();
    final priorities = await DatabaseHelper.instance.getPriorityBreakdown();
    final weekly = await DatabaseHelper.instance.getWeeklyStats();
    final topAvoided = await DatabaseHelper.instance.getMostAvoidedItems();

    setState(() {
      totalAvoided = avoided;
      activeCount = active;
      categoryBreakdown = categories;
      priorityBreakdown = priorities;
      weeklyStats = weekly;
      mostAvoided = topAvoided;
      isLoading = false;
    });
  }

  String _getCategoryLabel(TodoCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case TodoCategory.health:
        return l10n?.health ?? 'Health';
      case TodoCategory.productivity:
        return l10n?.productivity ?? 'Productivity';
      case TodoCategory.social:
        return l10n?.social ?? 'Social';
      case TodoCategory.other:
        return l10n?.other ?? 'Other';
    }
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
                    _buildCategoryPieChart(isDark, l10n),
                    const SizedBox(height: 24),
                    _buildMostAvoidedList(l10n),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards(AppLocalizations? l10n) {
    return Row(
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
                      .reduce((a, b) => a > b ? a : b) * 1.2,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < weeklyStats.length) {
                            final week = weeklyStats[value.toInt()]['week'] as String;
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

  Widget _buildCategoryPieChart(bool isDark, AppLocalizations? l10n) {
    if (categoryBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final sections = categoryBreakdown.entries.map((entry) {
      Color color;
      switch (entry.key) {
        case TodoCategory.health:
          color = AppThemes.categoryHealth;
          break;
        case TodoCategory.productivity:
          color = AppThemes.categoryProductivity;
          break;
        case TodoCategory.social:
          color = AppThemes.categorySocial;
          break;
        case TodoCategory.other:
          color = AppThemes.categoryOther;
          break;
      }
      return PieChartSectionData(
        color: color,
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
              l10n?.byCategory ?? 'By Category',
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
                    children: categoryBreakdown.entries.map((entry) {
                      Color color;
                      String label = _getCategoryLabel(entry.key);
                      switch (entry.key) {
                        case TodoCategory.health:
                          color = AppThemes.categoryHealth;
                          break;
                        case TodoCategory.productivity:
                          color = AppThemes.categoryProductivity;
                          break;
                        case TodoCategory.social:
                          color = AppThemes.categorySocial;
                          break;
                        case TodoCategory.other:
                          color = AppThemes.categoryOther;
                          break;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Text('$label: ${entry.value}'),
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
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(153),
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
}
