/// XP constants, level thresholds, and computation helpers.
///
/// Levels 1–20 are Free. Levels 21–100 require Plus.
class XpHelper {
  // ─────────────────────────────────────────────────────────────
  // XP amounts per event
  // ─────────────────────────────────────────────────────────────

  static const int xpDailyLogin = 10;
  static const int xpRelapse = 15; // honesty rewarded
  static const int xpTriggerNote = 10; // relapse with a trigger note attached
  static const int xpArchive = 100; // habit successfully avoided
  static const int xpMilestone7d = 50;
  static const int xpMilestone30d = 100;
  static const int xpMilestone90d = 200;
  static const int xpFollowUpCause = 10; // Plus: relapse cause chip tagged
  static const int xpWhatWorked = 10; // Plus: "What worked" reflection filled
  static const int xpDailyCommit = 20; // Plus: daily commitment per habit
  static const int xpHelpfulBreak = 5; // once per todo per day

  // ─────────────────────────────────────────────────────────────
  // XP event source keys (stored in xp_events.source column)
  // ─────────────────────────────────────────────────────────────

  static const String sourceDailyLogin = 'daily_login';
  static const String sourceRelapse = 'relapse';
  static const String sourceTriggerNote = 'trigger_note';
  static const String sourceArchive = 'archive';
  static const String sourceMilestone7d = 'streak_7d';
  static const String sourceMilestone30d = 'streak_30d';
  static const String sourceMilestone90d = 'streak_90d';
  static const String sourceFollowUpCause = 'follow_up_cause';
  static const String sourceWhatWorked = 'what_worked_reflection';
  static const String sourceDailyCommit = 'daily_commit';
  static const String sourceHelpfulBreak = 'helpful_break';

  // ─────────────────────────────────────────────────────────────
  // Level definitions
  // ─────────────────────────────────────────────────────────────

  static const int maxFreeLevel = 20;
  static const int maxLevel = 100;

  static const List<_LevelDef> _levels = [
    // Free tier — levels 1–20
    _LevelDef(1, 0, 'Beginner'),
    _LevelDef(2, 100, 'Aware'),
    _LevelDef(3, 200, 'Awakened'),
    _LevelDef(4, 350, 'Focused'),
    _LevelDef(5, 500, 'Resistant'),
    _LevelDef(6, 700, 'Determined'),
    _LevelDef(7, 900, 'Steadfast'),
    _LevelDef(8, 1100, 'Resolute'),
    _LevelDef(9, 1300, 'Tenacious'),
    _LevelDef(10, 1500, 'Disciplined'),
    _LevelDef(11, 1800, 'Hardened'),
    _LevelDef(12, 2100, 'Battle-Tested'),
    _LevelDef(13, 2400, 'Unyielding'),
    _LevelDef(14, 2750, 'Iron-Willed'),
    _LevelDef(15, 3100, 'Relentless'),
    _LevelDef(16, 3500, 'Invincible'),
    _LevelDef(17, 3900, 'Dominant'),
    _LevelDef(18, 4300, 'Elite'),
    _LevelDef(19, 4650, 'Champion'),
    _LevelDef(20, 5000, 'Unbreakable'),
    // Plus tier — levels 21–100
    _LevelDef(21, 5500, 'Ascendant'),
    _LevelDef(22, 6100, 'Formidable'),
    _LevelDef(23, 6800, 'Unstoppable'),
    _LevelDef(24, 7600, 'Ironclad'),
    _LevelDef(25, 8500, 'Indomitable'),
    _LevelDef(26, 9500, 'Titan'),
    _LevelDef(27, 10200, 'Mythbreaker'),
    _LevelDef(28, 10900, 'Sovereign'),
    _LevelDef(29, 11500, 'Eternal'),
    _LevelDef(30, 12000, 'Legend'),
    _LevelDef(35, 18000, 'Warlord'),
    _LevelDef(40, 23000, 'Transcendent'),
    _LevelDef(45, 27000, 'Immortal'),
    _LevelDef(50, 30000, 'Mythic'),
    _LevelDef(55, 34000, 'Paragon'),
    _LevelDef(60, 39000, 'Overlord'),
    _LevelDef(65, 45000, 'Celestial'),
    _LevelDef(70, 52000, 'Voidwalker'),
    _LevelDef(75, 60000, 'Godforged'),
    _LevelDef(80, 69000, 'Apex'),
    _LevelDef(85, 79000, 'Eclipsed'),
    _LevelDef(90, 90000, 'Omniscient'),
    _LevelDef(95, 102000, 'Beyond'),
    _LevelDef(100, 115000, 'Unbound'),
  ];

  // ─────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────

  /// Returns the level (1-based) for [xp].
  /// When [capAtFree] is true, caps at [maxFreeLevel].
  static int getLevelForXp(int xp, {bool capAtFree = false}) {
    int level = 1;
    for (final def in _levels) {
      if (xp >= def.xpRequired) {
        level = def.level;
      } else {
        break;
      }
    }
    if (capAtFree && level > maxFreeLevel) return maxFreeLevel;
    if (level > maxLevel) return maxLevel;
    return level;
  }

  /// Returns the minimum XP required to reach [level].
  static int getXpForLevel(int level) {
    if (level <= 1) return 0;
    if (level >= maxLevel) return _levels.last.xpRequired;
    for (final def in _levels) {
      if (def.level == level) return def.xpRequired;
    }
    // Interpolate between the two bracketing defined milestones
    _LevelDef? lower;
    _LevelDef? upper;
    for (int i = 0; i < _levels.length - 1; i++) {
      if (_levels[i].level < level && _levels[i + 1].level > level) {
        lower = _levels[i];
        upper = _levels[i + 1];
        break;
      }
    }
    if (lower == null || upper == null) return _levels.last.xpRequired;
    final fraction = (level - lower.level) / (upper.level - lower.level);
    return lower.xpRequired +
        ((upper.xpRequired - lower.xpRequired) * fraction).round();
  }

  /// Returns the title string for [level].
  static String getTitleForLevel(int level) {
    for (final def in _levels) {
      if (def.level == level) return def.title;
    }
    // Closest lower bound
    String title = _levels.first.title;
    for (final def in _levels) {
      if (def.level <= level) title = def.title;
    }
    return title;
  }

  /// Progress fraction (0.0–1.0) through the current level toward the next.
  /// Returns 1.0 when at the free level cap (nothing to show beyond).
  static double getProgressToNextLevel(int xp, {bool capAtFree = false}) {
    final currentLevel = getLevelForXp(xp, capAtFree: capAtFree);
    if (currentLevel >= maxLevel) return 1.0;
    if (capAtFree && currentLevel >= maxFreeLevel) return 1.0;
    final currentLevelXp = getXpForLevel(currentLevel);
    final nextLevelXp = getXpForLevel(currentLevel + 1);
    if (nextLevelXp <= currentLevelXp) return 1.0;
    return ((xp - currentLevelXp) / (nextLevelXp - currentLevelXp))
        .clamp(0.0, 1.0);
  }
}

class _LevelDef {
  final int level;
  final int xpRequired;
  final String title;
  const _LevelDef(this.level, this.xpRequired, this.title);
}
