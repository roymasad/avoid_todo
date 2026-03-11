import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../model/break_session.dart';
import '../model/todo.dart';

class BreakTriviaPrompt {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String insight;

  const BreakTriviaPrompt({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.insight,
  });
}

class BreakActivityDefinition {
  final BreakActivityType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const BreakActivityDefinition({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class BreakHelper {
  BreakHelper._();

  static const int xpHelpfulBreak = 5;
  static const String sourceHelpfulBreak = 'helpful_break';
  static const String _recordSeparator = '\n%%\n';
  static final Map<String, List<BreakTriviaPrompt>> _triviaCache =
      <String, List<BreakTriviaPrompt>>{};
  static final Map<String, List<String>> _zenFortunesCache =
      <String, List<String>>{};
  static final AppLocalizations _fallbackL10n =
      lookupAppLocalizations(const Locale('en'));

  static bool supportsPersonalBest(BreakActivityType type) {
    switch (type) {
      case BreakActivityType.defuse:
      case BreakActivityType.pairMatch:
      case BreakActivityType.cubeReset:
      case BreakActivityType.stackSweep:
      case BreakActivityType.triviaPivot:
        return true;
      case BreakActivityType.zenRoom:
        return false;
    }
  }

  static bool prefersLowerPersonalBest(BreakActivityType type) {
    switch (type) {
      case BreakActivityType.defuse:
      case BreakActivityType.pairMatch:
      case BreakActivityType.cubeReset:
      case BreakActivityType.stackSweep:
        return true;
      case BreakActivityType.triviaPivot:
      case BreakActivityType.zenRoom:
        return false;
    }
  }

  static String formatPersonalBestValue(BreakActivityType type, int score) {
    if (prefersLowerPersonalBest(type)) {
      final seconds = score ~/ 1000;
      final centiseconds = (score % 1000) ~/ 10;
      return '$seconds.${centiseconds.toString().padLeft(2, '0')}s';
    }
    return score.toString();
  }

  static String personalBestLabel(
    BreakActivityType type,
    int score,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case BreakActivityType.defuse:
      case BreakActivityType.pairMatch:
      case BreakActivityType.cubeReset:
      case BreakActivityType.stackSweep:
        return l10n.breakPersonalBestTime(
          formatPersonalBestValue(type, score),
        );
      case BreakActivityType.triviaPivot:
        return l10n.breakPersonalBestCorrect(score);
      case BreakActivityType.zenRoom:
        return l10n.breakPersonalBestTime(score.toString());
    }
  }

  static BreakActivityDefinition definitionFor(
    BreakActivityType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case BreakActivityType.defuse:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityDefuseTitle,
          subtitle: l10n.breakActivityDefuseSubtitle,
          icon: Icons.bolt_rounded,
          color: const Color(0xFFE85D04),
        );
      case BreakActivityType.pairMatch:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityPairMatchTitle,
          subtitle: l10n.breakActivityPairMatchSubtitle,
          icon: Icons.grid_view_rounded,
          color: const Color(0xFF2A9D8F),
        );
      case BreakActivityType.cubeReset:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityCubeResetTitle,
          subtitle: l10n.breakActivityCubeResetSubtitle,
          icon: Icons.view_in_ar_rounded,
          color: const Color(0xFF577590),
        );
      case BreakActivityType.stackSweep:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityStackSweepTitle,
          subtitle: l10n.breakActivityStackSweepSubtitle,
          icon: Icons.view_quilt_rounded,
          color: const Color(0xFF8D6E63),
        );
      case BreakActivityType.triviaPivot:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityTriviaPivotTitle,
          subtitle: l10n.breakActivityTriviaPivotSubtitle,
          icon: Icons.lightbulb_outline_rounded,
          color: const Color(0xFF6A4C93),
        );
      case BreakActivityType.zenRoom:
        return BreakActivityDefinition(
          type: type,
          title: l10n.breakActivityZenRoomTitle,
          subtitle: l10n.breakActivityZenRoomSubtitle,
          icon: Icons.spa_outlined,
          color: const Color(0xFF4D908E),
        );
    }
  }

  static List<BreakTriviaPrompt> triviaPrompts(AppLocalizations l10n) {
    return _triviaCache.putIfAbsent(l10n.localeName, () {
      final prompts = _parseTriviaPrompts(l10n.breakTriviaData);
      if (prompts.isNotEmpty) {
        return prompts;
      }
      return _parseTriviaPrompts(_fallbackL10n.breakTriviaData);
    });
  }

  static List<String> zenFortunes(AppLocalizations l10n) {
    return _zenFortunesCache.putIfAbsent(l10n.localeName, () {
      final fortunes = _parseRecords(l10n.breakZenFortunesData);
      if (fortunes.isNotEmpty) {
        return fortunes;
      }
      return _parseRecords(_fallbackL10n.breakZenFortunesData);
    });
  }

  static List<BreakTriviaPrompt> _parseTriviaPrompts(String data) {
    final prompts = <BreakTriviaPrompt>[];
    for (final record in _parseRecords(data)) {
      final lines = record
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      if (lines.length < 5) {
        continue;
      }
      prompts.add(
        BreakTriviaPrompt(
          question: lines[0],
          options: lines.sublist(1, 4),
          answerIndex: 1,
          insight: lines[4],
        ),
      );
    }
    return prompts;
  }

  static List<String> _parseRecords(String data) {
    return data
        .split(_recordSeparator)
        .map((record) => record.trim())
        .where((record) => record.isNotEmpty)
        .toList();
  }

  static List<BreakActivityType> poolFor(AvoidType type) {
    switch (type) {
      case AvoidType.generic:
        return BreakActivityType.values;
      case AvoidType.people:
        return const [
          BreakActivityType.defuse,
          BreakActivityType.cubeReset,
          BreakActivityType.stackSweep,
          BreakActivityType.zenRoom,
          BreakActivityType.triviaPivot,
        ];
      case AvoidType.event:
        return const [
          BreakActivityType.cubeReset,
          BreakActivityType.triviaPivot,
          BreakActivityType.stackSweep,
          BreakActivityType.zenRoom,
          BreakActivityType.pairMatch,
        ];
      case AvoidType.place:
        return const [
          BreakActivityType.defuse,
          BreakActivityType.pairMatch,
          BreakActivityType.cubeReset,
          BreakActivityType.stackSweep,
          BreakActivityType.triviaPivot,
          BreakActivityType.zenRoom,
        ];
    }
  }

  static BreakActivityType pickActivity(
    AvoidType type, {
    Random? random,
    BreakActivityType? previous,
    Iterable<BreakActivityType>? enabledActivities,
  }) {
    final generator = random ?? Random();
    final pool = List<BreakActivityType>.from(poolFor(type));
    if (enabledActivities != null) {
      final enabledSet = enabledActivities.toSet();
      pool.removeWhere((activity) => !enabledSet.contains(activity));
    }
    if (pool.isEmpty) {
      pool.addAll(poolFor(type));
    }
    if (previous != null && pool.length > 1) {
      pool.remove(previous);
    }
    return pool[generator.nextInt(pool.length)];
  }

  static bool isHelpful(BreakOutcome? outcome) =>
      outcome == BreakOutcome.passed || outcome == BreakOutcome.weaker;

  static String xpSourceFor(String todoId, DateTime when) {
    final day = when.toIso8601String().substring(0, 10);
    return '$sourceHelpfulBreak:$todoId:$day';
  }

  static String labelForOutcome(BreakOutcome outcome, AppLocalizations l10n) {
    switch (outcome) {
      case BreakOutcome.passed:
        return l10n.breakOutcomePassed;
      case BreakOutcome.weaker:
        return l10n.breakOutcomeWeaker;
      case BreakOutcome.stillStrong:
        return l10n.breakOutcomeStillStrong;
    }
  }
}
