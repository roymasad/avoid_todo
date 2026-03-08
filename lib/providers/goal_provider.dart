import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  static const _kPresetDismissedKey = 'preset_goal_dismissed_by_plus';

  /// Loads active goals from the DB.
  ///
  /// Auto-creates a streak preset goal on the most-challenged habit if none
  /// exists yet. For Plus users the preset is skipped if they previously
  /// dismissed it (stored in SharedPreferences).
  ///
  /// Returns the list of goals that were newly completed this call, so the
  /// caller can award XP and show celebration feedback.
  Future<List<Goal>> load({
    required List<ToDo> activeTodos,
    required double monthlySavings,
    required bool isPlus,
  }) async {
    // Auto-create preset goal if none is active, unless a Plus user dismissed it
    final hasPreset = await DatabaseHelper.instance.hasActivePresetGoal();
    if (!hasPreset) {
      bool skip = false;
      if (isPlus) {
        final prefs = await SharedPreferences.getInstance();
        skip = prefs.getBool(_kPresetDismissedKey) ?? false;
      }
      if (!skip) {
        final preset = GoalHelper.buildPresetGoal(activeTodos);
        if (preset != null) {
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
  ///
  /// If the removed goal is a preset and the user is Plus, records that they
  /// intentionally dismissed it so it isn't recreated on the next load.
  Future<void> removeGoal(int goalId, {bool isPlus = false}) async {
    if (isPlus) {
      final goal = _goals.where((g) => g.id == goalId).firstOrNull;
      if (goal?.isPreset == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_kPresetDismissedKey, true);
      }
    }
    await DatabaseHelper.instance.deleteGoal(goalId);
    _goals = _goals.where((g) => g.id != goalId).toList();
    notifyListeners();
  }
}
