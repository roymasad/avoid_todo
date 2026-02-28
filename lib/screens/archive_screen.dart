import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../constants/themes.dart';
import '../helpers/database_helper.dart';
import '../l10n/app_localizations.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<ToDo> archivedTodos = [];
  List<Tag> allTags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArchivedTodos();
  }

  Future<void> _loadArchivedTodos() async {
    setState(() => isLoading = true);
    final todos = await DatabaseHelper.instance.readArchivedTodos();
    final tags = await DatabaseHelper.instance.getAllTags();
    setState(() {
      archivedTodos = todos;
      allTags = tags;
      isLoading = false;
    });
  }

  Future<void> _restoreTodo(ToDo todo) async {
    await DatabaseHelper.instance.restoreTodo(int.parse(todo.id!));
    _loadArchivedTodos();
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(l10n?.itemRestored ?? 'Item restored to active list')),
      );
    }
  }

  Future<void> _deletePermanently(ToDo todo) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.deletePermanently ?? 'Delete Permanently'),
        content: Text(l10n?.deleteConfirmation ??
            'This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n?.delete ?? 'Delete',
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.delete(int.parse(todo.id!));
      _loadArchivedTodos();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.archive ?? 'Archive'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : archivedTodos.isEmpty
              ? Center(
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
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: archivedTodos.length,
                  itemBuilder: (context, index) {
                    final todo = archivedTodos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          todo.todoText!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
                              children: [
                                _buildPriorityChip(todo.priority),
                              ],
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
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              onPressed: () => _deletePermanently(todo),
                              tooltip: l10n?.deletePermanently ??
                                  'Delete permanently',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
    );
  }
}
