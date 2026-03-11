import 'package:avoid_todo/helpers/break_helper.dart';
import 'package:avoid_todo/model/break_session.dart';
import 'package:avoid_todo/model/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'people pool excludes pair match but keeps defuse, cube, stack sweep, and zen room',
      () {
    final pool = BreakHelper.poolFor(AvoidType.people);

    expect(pool, contains(BreakActivityType.defuse));
    expect(pool, contains(BreakActivityType.cubeReset));
    expect(pool, contains(BreakActivityType.stackSweep));
    expect(pool, contains(BreakActivityType.zenRoom));
    expect(pool, isNot(contains(BreakActivityType.pairMatch)));
  });

  test('generic pool exposes every launch activity', () {
    final pool = BreakHelper.poolFor(AvoidType.generic);

    expect(
      pool,
      containsAll([
        BreakActivityType.defuse,
        BreakActivityType.pairMatch,
        BreakActivityType.cubeReset,
        BreakActivityType.stackSweep,
        BreakActivityType.triviaPivot,
        BreakActivityType.zenRoom,
      ]),
    );
    expect(pool, hasLength(6));
  });

  test('picked activity always belongs to the filtered pool', () {
    final pool = BreakHelper.poolFor(AvoidType.event);

    for (var i = 0; i < 25; i++) {
      final picked = BreakHelper.pickActivity(AvoidType.event);
      expect(pool, contains(picked));
    }
  });

  test('picker avoids immediate repeats when another option exists', () {
    final picked = BreakHelper.pickActivity(
      AvoidType.people,
      previous: BreakActivityType.zenRoom,
    );

    expect(picked, isNot(BreakActivityType.zenRoom));
    expect(BreakHelper.poolFor(AvoidType.people), contains(picked));
  });

  test('picker honors enabled activity filters', () {
    for (var i = 0; i < 10; i++) {
      final picked = BreakHelper.pickActivity(
        AvoidType.place,
        enabledActivities: const [
          BreakActivityType.stackSweep,
          BreakActivityType.triviaPivot,
        ],
      );

      expect(
        picked,
        anyOf(
          BreakActivityType.stackSweep,
          BreakActivityType.triviaPivot,
        ),
      );
    }
  });

  test('picker falls back to avoid-type pool if enabled filter empties it', () {
    final pool = BreakHelper.poolFor(AvoidType.people);

    for (var i = 0; i < 10; i++) {
      final picked = BreakHelper.pickActivity(
        AvoidType.people,
        enabledActivities: const [BreakActivityType.pairMatch],
      );

      expect(pool, contains(picked));
    }
  });
}
