import 'package:flutter/material.dart';
import 'database_helper.dart';

/// Tier classification for a badge.
enum BadgeTier { free, plus }

/// Immutable definition of a single badge.
class BadgeDefinition {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final BadgeTier tier;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.tier,
  });
}

/// Stats snapshot passed to the badge checker at load time.
class BadgeCheckStats {
  final Duration longestStreak;
  final double totalSavedMoney;
  final int activeCount;
  final int totalAvoided;
  final int totalRelapses;
  final DateTime? firstHabitCreatedAt;

  const BadgeCheckStats({
    required this.longestStreak,
    required this.totalSavedMoney,
    required this.activeCount,
    required this.totalAvoided,
    required this.totalRelapses,
    this.firstHabitCreatedAt,
  });
}

/// Central registry of all badge definitions and badge-checking logic.
class BadgeHelper {
  static const List<BadgeDefinition> allBadges = [
    // ── Free badges ──────────────────────────────────────────────────────────
    BadgeDefinition(
      id: 'badge_first_step',
      title: 'First Step',
      description: 'Added your first habit to avoid',
      icon: Icons.flag_rounded,
      color: Colors.teal,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_24h',
      title: '24h Freedom',
      description: '24-hour streak on any habit',
      icon: Icons.timer_outlined,
      color: Colors.blue,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_7d',
      title: '7 Day Warrior',
      description: '7-day streak on any habit',
      icon: Icons.security_rounded,
      color: Colors.purple,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_14d',
      title: 'Two Week Shield',
      description: '14-day streak on any habit',
      icon: Icons.verified_user_rounded,
      color: Colors.indigo,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_budget',
      title: 'Budget Saver',
      description: 'Saved \$50 in money',
      icon: Icons.savings_outlined,
      color: Colors.green,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_consistency',
      title: 'Consistency',
      description: 'Tracking 5+ active habits simultaneously',
      icon: Icons.repeat_rounded,
      color: Colors.orange,
      tier: BadgeTier.free,
    ),
    BadgeDefinition(
      id: 'badge_25_avoids',
      title: 'Momentum',
      description: '25 successful avoidances',
      icon: Icons.local_fire_department_rounded,
      color: Colors.deepOrange,
      tier: BadgeTier.free,
    ),
    // ── Plus badges ──────────────────────────────────────────────────────────
    BadgeDefinition(
      id: 'badge_iron_month',
      title: 'Iron Month',
      description: '30-day streak on any habit',
      icon: Icons.shield_rounded,
      color: Colors.blueGrey,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_quarter_year',
      title: 'Quarter Year',
      description: '90-day streak on any habit',
      icon: Icons.workspace_premium,
      color: Colors.deepPurple,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_half_year',
      title: 'Half Year',
      description: '180-day streak on any habit',
      icon: Icons.military_tech_rounded,
      color: Colors.indigo,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_one_year',
      title: 'One Year',
      description: '365-day streak on any habit',
      icon: Icons.emoji_events_rounded,
      color: Colors.amber,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_mega_saver',
      title: 'Mega Saver',
      description: 'Saved \$200 in money',
      icon: Icons.savings,
      color: Colors.amber,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_high_roller',
      title: 'High Roller',
      description: 'Saved \$1,000 in money',
      icon: Icons.diamond_outlined,
      color: Colors.cyan,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_century',
      title: 'Century',
      description: '100 successful avoidances',
      icon: Icons.star_rounded,
      color: Colors.deepOrange,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_double_century',
      title: 'Double Century',
      description: '200 successful avoidances',
      icon: Icons.whatshot_rounded,
      color: Colors.redAccent,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_honest',
      title: 'Honest',
      description: 'Logged 25 relapses (self-awareness takes courage)',
      icon: Icons.favorite_rounded,
      color: Colors.pink,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_tycoon',
      title: 'Tycoon',
      description: 'Saved \$2,500 in money',
      icon: Icons.account_balance_wallet_rounded,
      color: Colors.green,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_veteran',
      title: 'Veteran',
      description: '1 year since your first habit was added',
      icon: Icons.local_police_rounded,
      color: Colors.brown,
      tier: BadgeTier.plus,
    ),
    BadgeDefinition(
      id: 'badge_legacy',
      title: 'Legacy',
      description: '2 years since your first habit was added',
      icon: Icons.history_edu_rounded,
      color: Colors.teal,
      tier: BadgeTier.plus,
    ),
  ];

  static List<BadgeDefinition> freeBadges() =>
      allBadges.where((b) => b.tier == BadgeTier.free).toList();

  static List<BadgeDefinition> plusBadges() =>
      allBadges.where((b) => b.tier == BadgeTier.plus).toList();

  static BadgeDefinition? findById(String id) {
    try {
      return allBadges.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns the set of badge IDs that [stats] qualifies for.
  static List<String> computeEarnedIds(BadgeCheckStats stats) {
    final earned = <String>[];

    // Free badges
    if (stats.activeCount > 0 || stats.totalAvoided > 0) {
      earned.add('badge_first_step');
    }
    if (stats.longestStreak.inHours >= 24) earned.add('badge_24h');
    if (stats.longestStreak.inDays >= 7) earned.add('badge_7d');
    if (stats.longestStreak.inDays >= 14) earned.add('badge_14d');
    if (stats.totalSavedMoney >= 50) earned.add('badge_budget');
    if (stats.activeCount >= 5) earned.add('badge_consistency');
    if (stats.totalAvoided >= 25) earned.add('badge_25_avoids');

    // Plus badges (persisted for all; shown/celebrated only for Plus users)
    if (stats.longestStreak.inDays >= 30) earned.add('badge_iron_month');
    if (stats.longestStreak.inDays >= 90) earned.add('badge_quarter_year');
    if (stats.longestStreak.inDays >= 180) earned.add('badge_half_year');
    if (stats.longestStreak.inDays >= 365) earned.add('badge_one_year');
    if (stats.totalSavedMoney >= 200) earned.add('badge_mega_saver');
    if (stats.totalSavedMoney >= 1000) earned.add('badge_high_roller');
    if (stats.totalSavedMoney >= 2500) earned.add('badge_tycoon');
    if (stats.totalAvoided >= 100) earned.add('badge_century');
    if (stats.totalAvoided >= 200) earned.add('badge_double_century');
    if (stats.totalRelapses >= 25) earned.add('badge_honest');
    if (stats.firstHabitCreatedAt != null) {
      final age = DateTime.now().difference(stats.firstHabitCreatedAt!);
      if (age.inDays >= 365) earned.add('badge_veteran');
      if (age.inDays >= 730) earned.add('badge_legacy');
    }

    return earned;
  }

  /// Checks all badges against [stats], persists any newly earned ones, and
  /// returns the list of newly unlocked badge IDs (used for the celebration UI).
  static Future<List<String>> checkAndPersistNewBadges(
      BadgeCheckStats stats) async {
    final earned = computeEarnedIds(stats);
    final existing = await DatabaseHelper.instance.getUnlockedBadges();
    final existingIds = existing.map((e) => e['id'] as String).toSet();

    final newIds = <String>[];
    for (final id in earned) {
      if (!existingIds.contains(id)) {
        await DatabaseHelper.instance.unlockBadge(id);
        newIds.add(id);
      }
    }
    return newIds;
  }
}
