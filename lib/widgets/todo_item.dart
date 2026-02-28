import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../helpers/database_helper.dart';
import '../constants/themes.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final Function(ToDo) onEditItem;
  final Function(ToDo)? onRelapse;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onEditItem,
    this.onRelapse,
  });

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.todo.isRecurring && !widget.todo.isArchived) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(ToDoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todo.isRecurring && !widget.todo.isArchived) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) setState(() {});
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTagChips() {
    if (widget.todo.tagIds.isEmpty) return const SizedBox.shrink();
    return FutureBuilder<List<Tag>>(
      future: DatabaseHelper.instance.getAllTags(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final tagMap = {for (final t in snapshot.data!) t.id: t};
        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: widget.todo.tagIds
              .where((id) => tagMap.containsKey(id))
              .map((id) {
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
                style: TextStyle(fontSize: 11, color: tag.color),
              ),
            );
          }).toList(),
        );
      },
    );
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

  String _formatStreak(DateTime start) {
    final duration = DateTime.now().difference(start);
    if (duration.isNegative) return "0s";

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
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
            color:
                isDark ? Colors.black.withAlpha(51) : Colors.grey.withAlpha(51),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => widget.onEditItem(widget.todo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          widget.todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTagChips(),
              const SizedBox(height: 4),
              Row(children: [
                _buildPriorityChip(context, widget.todo.priority)
              ]),
            ],
          ),
        ),
        leading: widget.todo.isRecurring
            ? Icon(
                Icons.whatshot,
                color: widget.todo.isArchived ? Colors.grey : tdAvoidRed,
              )
            : Icon(
                Icons.event,
                color: isDark
                    ? AppThemes.darkTextSecondary
                    : AppThemes.lightTextSecondary,
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.todo.isRecurring && !widget.todo.isArchived)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatStreak(widget.todo.lastRelapsedAt),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Streak',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            if (!widget.todo.isRecurring && widget.todo.eventDate != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  DateFormat.yMMMd().format(widget.todo.eventDate!),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => widget.onEditItem(widget.todo),
              color: isDark
                  ? AppThemes.darkTextSecondary
                  : AppThemes.lightTextSecondary,
            ),
            if (widget.todo.isRecurring && !widget.todo.isArchived)
              InkWell(
                onTap: () {
                  widget.onRelapse?.call(widget.todo);
                },
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: tdAvoidRed.withAlpha(51),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: tdAvoidRed),
                  ),
                  child: const Center(
                    child: Icon(Icons.restore, size: 18, color: tdAvoidRed),
                  ),
                ),
              ),
            if (!widget.todo.isRecurring && !widget.todo.isArchived)
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
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final l10n = AppLocalizations.of(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n?.swipeToAvoid ??
                            'Swipe right to mark as avoided!'),
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
