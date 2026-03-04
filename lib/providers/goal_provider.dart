import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../helpers/goal_helper.dart';
import '../model/goal.dart';
import '../model/todo.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  // ─────────────────────────────────────────────────────────────
  // Load + auto-preset creation
  // ─────────────────────────────────────────────────────────────

  /// Loads active goals from the DB.
  ///
  /// For free-tier users ([isPlus] == false), auto-creates a streak preset
  /// goal on the most-challenged habit if none exists yet.
  ///
  /// Returns the list of goals that were newly completed this call, so the
  /// caller can award XP and show celebration feedback.
  Future<List<Goal>> load({
    required List<ToDo> activeTodos,
    required double monthlySavings,
    required bool isPlus,
  }) async {
    // Auto-create preset for free user if needed
    if (!isPlus) {
      final hasPreset = await DatabaseHelper.instance.hasActivePresetGoal();
      if (!hasPreset) {
        final preset = GoalHelper.buildPresetGoal(activeTodos);
        if (preset != null) {
          // Don't capture the id — the subsequent query below will include it
          await DatabaseHelper.instance.createGoal(preset);
        }
      }
    }

    _goals = await DatabaseHelper.instance.getActiveGoals();

    // Detect completions
    final newlyCompleted = <Goal>[];
    for (final goal in List<Goal>.from(_goals)) {
      if (goal.completedAt != null) continue; // already recorded as complete
      if (GoalHelper.isComplete(goal, activeTodos, monthlySavings)) {
        await DatabaseHelper.instance.completeGoal(goal.id!);
        newlyCompleted.add(goal);

        // For preset goals: auto-create the next milestone
        if (goal.isPreset) {
          final next = GoalHelper.buildNextPresetGoal(goal);
          await DatabaseHelper.instance.createGoal(next);
        }
      }
    }

    // Reload after potential completions/new goals
    if (newlyCompleted.isNotEmpty) {
      _goals = await DatabaseHelper.instance.getActiveGoals();
    }

    notifyListeners();
    return newlyCompleted;
  }

  // ─────────────────────────────────────────────────────────────
  // Mutations
  // ─────────────────────────────────────────────────────────────

  /// Creates a user-defined goal (Plus only — caller must enforce).
  Future<void> addGoal(Goal goal) async {
    final newId = await DatabaseHelper.instance.createGoal(goal);
    _goals = [goal.copyWith(id: newId), ..._goals];
    notifyListeners();
  }

  /// Removes a goal entirely (user dismisses it).
  Future<void> removeGoal(int goalId) async {
    await DatabaseHelper.instance.deleteGoal(goalId);
    _goals = _goals.where((g) => g.id != goalId).toList();
    notifyListeners();
  }
}
