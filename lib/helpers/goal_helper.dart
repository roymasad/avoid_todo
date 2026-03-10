import '../model/goal.dart';
import '../model/todo.dart';

class GoalHelper {
  // ─────────────────────────────────────────────────────────────
  // Streak milestones for auto-progression after completion
  // ─────────────────────────────────────────────────────────────

  static const List<int> _streakMilestones = [7, 14, 30, 60, 90, 180, 365];

  /// Next streak milestone after [completedTarget] days.
  static int nextStreakTarget(int completedTarget) {
    for (final m in _streakMilestones) {
      if (m > completedTarget) return m;
    }
    return completedTarget + 30;
  }

  // ─────────────────────────────────────────────────────────────
  // Progress calculation
  // ─────────────────────────────────────────────────────────────

  /// Current streak in days for a specific habit.
  static int currentStreakDays(ToDo todo) =>
      DateTime.now().difference(todo.lastRelapsedAt).inDays;

  /// Progress fraction (0.0–1.0) for [goal].
  ///
  /// [todos] should be the active (non-archived) todo list.
  /// [monthlySavings] is the total money saved this month.
  static double progress(Goal goal, List<ToDo> todos, double monthlySavings) {
    switch (goal.type) {
      case GoalType.streak:
        final match = todos.where((t) => t.id == goal.todoId).firstOrNull;
        if (match == null) return 0.0;
        return (currentStreakDays(match) / goal.targetValue).clamp(0.0, 1.0);
      case GoalType.savingsMonth:
        if (goal.targetValue <= 0) return 0.0;
        return (monthlySavings / goal.targetValue).clamp(0.0, 1.0);
    }
  }

  /// Whether the goal's target has been met.
  static bool isComplete(Goal goal, List<ToDo> todos, double monthlySavings) =>
      progress(goal, todos, monthlySavings) >= 1.0;

  // ─────────────────────────────────────────────────────────────
  // Display helpers
  // ─────────────────────────────────────────────────────────────

  /// One-line description shown on the goal card.
  static String description(Goal goal) {
    switch (goal.type) {
      case GoalType.streak:
        final days = goal.targetValue.toInt();
        final habit = goal.todoText ?? 'your habit';
        return 'Reach a $days-day streak on "$habit"';
      case GoalType.savingsMonth:
        final amount = goal.targetValue.toStringAsFixed(0);
        return 'Save \$$amount this month';
    }
  }

  /// Short value label for the progress sub-text, e.g. "5 / 7 days".
  static String progressLabel(
      Goal goal, List<ToDo> todos, double monthlySavings) {
    switch (goal.type) {
      case GoalType.streak:
        final match = todos.where((t) => t.id == goal.todoId).firstOrNull;
        final current = match != null ? currentStreakDays(match) : 0;
        final target = goal.targetValue.toInt();
        return '$current / $target days';
      case GoalType.savingsMonth:
        final current = monthlySavings.toStringAsFixed(0);
        final target = goal.targetValue.toStringAsFixed(0);
        return '\$$current / \$$target saved';
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Preset goal generation (free tier)
  // ─────────────────────────────────────────────────────────────

  /// Auto-generates a 7-day streak goal on the most challenged habit
  /// (highest relapse count). Returns null if there are no active habits.
  static Goal? buildPresetGoal(List<ToDo> activeTodos) {
    if (activeTodos.isEmpty) return null;
    final sorted = List<ToDo>.from(activeTodos)
      ..sort((a, b) => b.relapseCount.compareTo(a.relapseCount));
    final target = sorted.first;
    return Goal(
      type: GoalType.streak,
      todoId: target.id,
      todoText: target.todoText,
      targetValue: 7,
      isPreset: true,
      createdAt: DateTime.now(),
    );
  }

  /// Builds the next progression goal after a preset goal was completed.
  /// Uses [completedGoal] as the basis, stepping to the next milestone.
  static Goal buildNextPresetGoal(Goal completedGoal) => Goal(
        type: GoalType.streak,
        todoId: completedGoal.todoId,
        todoText: completedGoal.todoText,
        targetValue:
            nextStreakTarget(completedGoal.targetValue.toInt()).toDouble(),
        isPreset: true,
        createdAt: DateTime.now(),
      );
}
