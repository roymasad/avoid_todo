import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import '../helpers/xp_helper.dart';

class XpProvider extends ChangeNotifier {
  int _totalXp = 0;

  /// Non-null when the user just levelled up — cleared after the UI handles it.
  int? _pendingLevelUp;

  int get totalXp => _totalXp;
  int? get pendingLevelUp => _pendingLevelUp;

  /// Actual level, uncapped (used for Plus users).
  int get currentLevel => XpHelper.getLevelForXp(_totalXp);

  /// Level capped at 20 for free users.
  int levelCapped(bool isPlus) =>
      XpHelper.getLevelForXp(_totalXp, capAtFree: !isPlus);

  /// Level title (always reflects the true level).
  String titleForLevel(int level) => XpHelper.getTitleForLevel(level);

  /// Progress fraction (0.0–1.0) to the next level, respecting the free cap.
  double progress(bool isPlus) =>
      XpHelper.getProgressToNextLevel(_totalXp, capAtFree: !isPlus);

  /// XP required for the current level.
  int xpFloor(bool isPlus) => XpHelper.getXpForLevel(levelCapped(isPlus));

  /// XP required for the next level.
  int xpCeiling(bool isPlus) => XpHelper.getXpForLevel(levelCapped(isPlus) + 1);

  void clearPendingLevelUp() {
    _pendingLevelUp = null;
  }

  // ─────────────────────────────────────────────────────────────
  // Load
  // ─────────────────────────────────────────────────────────────

  Future<void> load() async {
    _totalXp = await DatabaseHelper.instance.getTotalXp();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────
  // Award helpers
  // ─────────────────────────────────────────────────────────────

  /// Awards [amount] XP and persists it with a [source] key.
  /// Detects level-up and sets [pendingLevelUp].
  Future<void> award(String source, int amount) async {
    final levelBefore = currentLevel;
    await DatabaseHelper.instance.awardXp(source, amount);
    _totalXp += amount;
    final levelAfter = currentLevel;
    if (levelAfter > levelBefore) {
      _pendingLevelUp = levelAfter;
    }
    notifyListeners();
  }

  /// Awards +10 XP for a daily login — at most once per calendar day.
  Future<void> awardDailyLoginIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = prefs.getString('last_xp_login_date') ?? '';
    if (last == today) return;
    await prefs.setString('last_xp_login_date', today);
    await award(XpHelper.sourceDailyLogin, XpHelper.xpDailyLogin);
  }

  /// Checks every todo's current streak and awards milestone XP (7d / 30d /
  /// 90d) at most once per todo+milestone using a composite source key.
  ///
  /// Returns a list of newly unlocked milestones: each map contains
  /// `todoId` (String), `todoText` (String), and `milestoneDay` (int).
  ///
  /// [todos] should be the raw map list from the DB (must include 'id',
  /// 'todoText', 'createdAt', 'lastRelapsedAt', 'isArchived').
  Future<List<Map<String, dynamic>>> awardStreakMilestonesIfNeeded(
      List<Map<String, dynamic>> todos) async {
    const milestones = [
      (7, XpHelper.sourceMilestone7d, XpHelper.xpMilestone7d),
      (30, XpHelper.sourceMilestone30d, XpHelper.xpMilestone30d),
      (90, XpHelper.sourceMilestone90d, XpHelper.xpMilestone90d),
    ];

    final newMilestones = <Map<String, dynamic>>[];

    for (final todo in todos) {
      // Only active (non-archived) habits carry a live streak
      if ((todo['isArchived'] as int? ?? 0) == 1) continue;

      final id = todo['id']?.toString() ?? '';
      final createdAt = todo['createdAt'] as String?;
      if (id.isEmpty || createdAt == null) continue;

      final lastRelapsedStr = todo['lastRelapsedAt'] as String?;
      final since = lastRelapsedStr != null
          ? (DateTime.tryParse(lastRelapsedStr) ??
              DateTime.tryParse(createdAt)!)
          : DateTime.tryParse(createdAt)!;
      final days = DateTime.now().difference(since).inDays;

      for (final (threshold, source, amount) in milestones) {
        if (days >= threshold) {
          final key = '$source:$id';
          final already = await DatabaseHelper.instance.hasXpSourceKey(key);
          if (!already) {
            await award(key, amount);
            newMilestones.add({
              'todoId': id,
              'todoText': todo['todoText'] as String? ?? '',
              'milestoneDay': threshold,
            });
          }
        }
      }
    }

    return newMilestones;
  }
}
