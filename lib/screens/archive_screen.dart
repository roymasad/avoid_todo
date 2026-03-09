import 'package:flutter/material.dart';

import '../constants/themes.dart';
import '../helpers/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../model/tag.dart';
import '../model/todo.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<ArchiveScreen> createState() => ArchiveScreenState();
}

class ArchiveScreenState extends State<ArchiveScreen>
    with SingleTickerProviderStateMixin {
  static final Color _accentColor = Color.alphaBlend(
    Colors.white.withValues(alpha: 0.08),
    const Color(0xFFE53935),
  );

  List<ToDo> archivedTodos = [];
  List<Tag> allTags = [];
  List<Map<String, dynamic>> relapseReflections = [];
  List<Map<String, dynamic>> successReflections = [];
  bool isLoading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void refresh() => _loadHistory();

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    final todos = await DatabaseHelper.instance.readArchivedTodos();
    final tags = await DatabaseHelper.instance.getAllTags();
    final db = await DatabaseHelper.instance.database;
    final relapses = await db.rawQuery('''
      SELECT r.id, r.relapsedAt, r.triggerNote, r.causeTag, t.todoText
      FROM relapse_logs r
      JOIN todo t ON r.todoId = t.id
      WHERE (r.triggerNote IS NOT NULL AND trim(r.triggerNote) != '')
         OR (r.causeTag IS NOT NULL AND trim(r.causeTag) != '')
      ORDER BY r.relapsedAt DESC
    ''');
    final reflections = await DatabaseHelper.instance
        .getRecentMilestoneReflections(limit: null);
    final wins = reflections.where((row) {
      final note = (row['note'] as String? ?? '').trim();
      final chip = (row['chipTag'] as String? ?? '').trim();
      return note.isNotEmpty || chip.isNotEmpty;
    }).toList();

    if (!mounted) return;
    setState(() {
      archivedTodos = todos;
      allTags = tags;
      relapseReflections = relapses;
      successReflections = wins;
      isLoading = false;
    });
  }

  Future<void> _restoreTodo(ToDo todo) async {
    await DatabaseHelper.instance.restoreTodo(int.parse(todo.id!));
    _loadHistory();
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.itemRestored ?? 'Item restored to active list'),
        ),
      );
    }
  }

  Future<void> _deletePermanently(ToDo todo) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.deletePermanently ?? 'Delete Permanently'),
        content: Text(
          l10n?.deleteConfirmation ??
              'This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n?.delete ?? 'Delete',
              style: TextStyle(color: _accentColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.delete(int.parse(todo.id!));
      _loadHistory();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final minutes = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} · ${date.hour}:$minutes';
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

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 6),
              tabs: const [
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Archived'),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Slips'),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Wins'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildArchivedTab(),
                    _buildRelapseReflectionsTab(),
                    _buildSuccessReflectionsTab(),
                  ],
                ),
        ),
      ],
    );

    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: body,
    );
  }

  Widget _buildArchivedTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (archivedTodos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 64,
              color: isDark
                  ? AppThemes.darkTextSecondary
                  : AppThemes.lightTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.noArchivedItems ?? 'No archived items yet',
              style: TextStyle(
                fontSize: 18,
                color: isDark
                    ? AppThemes.darkTextSecondary
                    : AppThemes.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedTodos.length,
      itemBuilder: (context, index) {
        final todo = archivedTodos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              todo.todoText!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDark
                          ? AppThemes.darkTextSecondary
                          : AppThemes.lightTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n?.avoidedOn ?? 'Avoided on'}: ${_formatDate(todo.archivedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppThemes.darkTextSecondary
                            : AppThemes.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildTagChips(todo.tagIds),
                const SizedBox(height: 4),
                Row(
                  children: [_buildPriorityChip(todo.priority)],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () => _restoreTodo(todo),
                  tooltip: l10n?.restore ?? 'Restore',
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever, color: _accentColor),
                  onPressed: () => _deletePermanently(todo),
                  tooltip: l10n?.deletePermanently ?? 'Delete permanently',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRelapseReflectionsTab() {
    if (relapseReflections.isEmpty) {
      return _buildEmptyTab(
        icon: Icons.edit_note_outlined,
        text: 'No relapse reflections yet',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: relapseReflections.length,
      itemBuilder: (context, index) {
        final row = relapseReflections[index];
        final date = DateTime.tryParse(row['relapsedAt'] as String? ?? '');
        final note = row['triggerNote'] as String?;
        final cause = row['causeTag'] as String?;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFB94040),
              child: Icon(Icons.warning_amber_rounded, color: Colors.white),
            ),
            title: Text(
              row['todoText'] as String? ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                if (cause != null && cause.isNotEmpty) Text('Cause: $cause'),
                if (note != null && note.isNotEmpty) Text('Note: $note'),
                if (date != null)
                  Text(
                    _formatDateTime(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessReflectionsTab() {
    if (successReflections.isEmpty) {
      return _buildEmptyTab(
        icon: Icons.lightbulb_outline,
        text: 'No success reflections yet',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: successReflections.length,
      itemBuilder: (context, index) {
        final row = successReflections[index];
        final date = DateTime.tryParse(row['createdAt'] as String? ?? '');
        final note = row['note'] as String?;
        final chip = row['chipTag'] as String?;
        final reflectionType = row['reflectionType'] as String? ?? 'milestone';
        final milestoneDays = row['milestoneDays'] as int? ?? 0;
        final subtitleLines = <String>[
          if (reflectionType == 'milestone')
            '$milestoneDays day milestone'
          else
            'Successful avoid',
          if (chip != null && chip.isNotEmpty) 'What helped: $chip',
          if (note != null && note.isNotEmpty) note,
          if (date != null) _formatDateTime(date),
        ];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: const CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.lightbulb_outline, color: Colors.white),
            ),
            title: Text(
              row['todoText'] as String? ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                for (final line in subtitleLines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      line,
                      style: TextStyle(
                        fontSize: line == subtitleLines.last ? 12 : 14,
                        color: line == subtitleLines.last
                            ? Theme.of(context).hintColor
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTab({
    required IconData icon,
    required String text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: isDark
                ? AppThemes.darkTextSecondary
                : AppThemes.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: isDark
                  ? AppThemes.darkTextSecondary
                  : AppThemes.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChips(List<String> tagIds) {
    if (tagIds.isEmpty) return const SizedBox.shrink();
    final tagMap = {for (final t in allTags) t.id: t};
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tagIds.where((id) => tagMap.containsKey(id)).map((id) {
        final tag = tagMap[id]!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: tag.color.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tag.color.withAlpha(120)),
          ),
          child: Text(
            tag.name,
            style: TextStyle(
              fontSize: 10,
              color: tag.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriorityChip(TodoPriority priority) {
    String label = _getPriorityLabel(priority);
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
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
