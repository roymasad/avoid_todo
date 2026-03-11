enum BreakActivityType {
  defuse,
  pairMatch,
  cubeReset,
  stackSweep,
  triviaPivot,
  fortuneCookie,
  zenRoom,
}

enum BreakSessionStatus { completed, aborted }

enum BreakOutcome { passed, weaker, stillStrong }

enum BreakFollowUpAction { retry, zenRoom, trustedSupport }

class BreakSessionResult {
  final BreakActivityType activityType;
  final BreakSessionStatus status;
  final BreakOutcome? outcome;
  final BreakFollowUpAction? followUpAction;
  final int? score;
  final DateTime startedAt;
  final DateTime endedAt;

  const BreakSessionResult({
    required this.activityType,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    this.outcome,
    this.followUpAction,
    this.score,
  });

  bool get isHelpful =>
      outcome == BreakOutcome.passed || outcome == BreakOutcome.weaker;
}

class BreakSessionSummary {
  final int totalStarted;
  final int totalCompleted;
  final int helpfulCount;
  final DateTime? lastUsedAt;
  final String? mostHelpedTodoText;

  const BreakSessionSummary({
    required this.totalStarted,
    required this.totalCompleted,
    required this.helpfulCount,
    this.lastUsedAt,
    this.mostHelpedTodoText,
  });

  double get completionRate =>
      totalStarted == 0 ? 0 : totalCompleted / totalStarted;

  double get helpfulRate =>
      totalCompleted == 0 ? 0 : helpfulCount / totalCompleted;
}
