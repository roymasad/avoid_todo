import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/themes.dart';
import '../l10n/app_localizations.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onEditItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onEditItem,
  });

  String _getCategoryLabel(BuildContext context, TodoCategory category) {
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

  String _getPriorityLabel(BuildContext context, TodoPriority priority) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withAlpha(51) 
                : Colors.grey.withAlpha(51),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => onEditItem(todo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildCategoryChip(context, todo.category),
              const SizedBox(width: 8),
              _buildPriorityChip(context, todo.priority),
            ],
          ),
        ),
        leading: Icon(
          Icons.block,
          color: isDark 
              ? AppThemes.darkTextSecondary 
              : AppThemes.lightTextSecondary,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => onEditItem(todo),
              color: isDark 
                  ? AppThemes.darkTextSecondary 
                  : AppThemes.lightTextSecondary,
            ),
            Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  final l10n = AppLocalizations.of(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n?.swipeToAvoid ?? 'Swipe right to mark as avoided!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, TodoCategory category) {
    String label = _getCategoryLabel(context, category);
    Color color;
    switch (category) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, TodoPriority priority) {
    String label = _getPriorityLabel(context, priority);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
