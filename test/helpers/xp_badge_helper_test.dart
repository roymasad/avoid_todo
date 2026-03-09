import 'package:avoid_todo/helpers/badge_helper.dart';
import 'package:avoid_todo/helpers/xp_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('XpHelper caps Plus progression at level 100', () {
    expect(XpHelper.maxLevel, 100);
    expect(XpHelper.getLevelForXp(999999), 100);
    expect(
      XpHelper.getProgressToNextLevel(999999),
      1.0,
    );
  });

  test('BadgeHelper unlocks new extended milestone badges', () {
    final earned = BadgeHelper.computeEarnedIds(
      BadgeCheckStats(
        longestStreak: const Duration(days: 20),
        totalSavedMoney: 3000,
        activeCount: 6,
        totalAvoided: 250,
        totalRelapses: 30,
        firstHabitCreatedAt: DateTime.now().subtract(const Duration(days: 800)),
      ),
    );

    expect(earned, contains('badge_14d'));
    expect(earned, contains('badge_25_avoids'));
    expect(earned, contains('badge_double_century'));
    expect(earned, contains('badge_tycoon'));
    expect(earned, contains('badge_legacy'));
  });
}
