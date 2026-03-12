import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../helpers/break_helper.dart';
import '../helpers/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../model/break_session.dart';
import '../model/todo.dart';
import '../providers/purchase_provider.dart';
import 'plus_upgrade_dialog.dart';

class UrgeBreakSheet extends StatefulWidget {
  final ToDo todo;
  final BreakActivityType activityType;
  final Duration duration;
  final bool showTrustedSupport;
  final bool previewMode;

  const UrgeBreakSheet({
    super.key,
    required this.todo,
    required this.activityType,
    required this.showTrustedSupport,
    this.duration = const Duration(seconds: 60),
    this.previewMode = false,
  });

  static bool debugStackRectsCountAsBlocking({
    required Rect blockerRect,
    required Rect blockedRect,
    double blockerRotation = 0,
    double blockedRotation = 0,
  }) {
    final blockerPoints = _rotatedRectPoints(
      _insetRect(blockerRect),
      blockerRotation,
    );
    final blockedPoints = _rotatedRectPoints(
      _insetRect(blockedRect),
      blockedRotation,
    );
    return _convexPolygonsOverlap(blockerPoints, blockedPoints);
  }

  static Rect _insetRect(Rect rect) {
    final horizontalInset = min(rect.width * 0.06, 2.0);
    final verticalInset = min(rect.height * 0.08, 2.0);
    return Rect.fromLTWH(
      rect.left + horizontalInset,
      rect.top + verticalInset,
      max(0, rect.width - (horizontalInset * 2)),
      max(0, rect.height - (verticalInset * 2)),
    );
  }

  static List<Offset> _rotatedRectPoints(Rect rect, double rotation) {
    final center = rect.center;
    final cosTheta = cos(rotation);
    final sinTheta = sin(rotation);
    final corners = <Offset>[
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    return corners.map((point) {
      final translatedX = point.dx - center.dx;
      final translatedY = point.dy - center.dy;
      return Offset(
        center.dx + (translatedX * cosTheta) - (translatedY * sinTheta),
        center.dy + (translatedX * sinTheta) + (translatedY * cosTheta),
      );
    }).toList();
  }

  static bool _convexPolygonsOverlap(
    List<Offset> first,
    List<Offset> second,
  ) {
    final axes = <Offset>[
      ..._polygonAxes(first),
      ..._polygonAxes(second),
    ];

    for (final axis in axes) {
      final firstProjection = _projectPolygon(first, axis);
      final secondProjection = _projectPolygon(second, axis);
      if (firstProjection.$2 <= secondProjection.$1 ||
          secondProjection.$2 <= firstProjection.$1) {
        return false;
      }
    }
    return true;
  }

  static List<Offset> _polygonAxes(List<Offset> points) {
    final axes = <Offset>[];
    for (var index = 0; index < points.length; index++) {
      final next = points[(index + 1) % points.length];
      final edge = next - points[index];
      final normal = Offset(-edge.dy, edge.dx);
      final length = normal.distance;
      if (length == 0) continue;
      axes.add(Offset(normal.dx / length, normal.dy / length));
    }
    return axes;
  }

  static (double, double) _projectPolygon(List<Offset> points, Offset axis) {
    var minProjection = points.first.dx * axis.dx + points.first.dy * axis.dy;
    var maxProjection = minProjection;
    for (final point in points.skip(1)) {
      final projection = point.dx * axis.dx + point.dy * axis.dy;
      if (projection < minProjection) {
        minProjection = projection;
      }
      if (projection > maxProjection) {
        maxProjection = projection;
      }
    }
    return (minProjection, maxProjection);
  }

  @override
  State<UrgeBreakSheet> createState() => _UrgeBreakSheetState();
}

class _UrgeBreakSheetState extends State<UrgeBreakSheet>
    with TickerProviderStateMixin {
  static const int _fortuneScratchColumns = 12;
  static const int _fortuneScratchRows = 8;
  static const double _fortuneScratchRevealThreshold = 0.72;
  static const List<double> _defuseHintedSuccessWindows = [
    0.12,
    0.10,
    0.08,
    0.06,
  ];
  static const List<Color> _triviaOptionColors = [
    Color(0xFFE76F51),
    Color(0xFF2A9D8F),
    Color(0xFFE9C46A),
    Color(0xFF457B9D),
  ];
  static const List<String> _pairMatchEmojiPool = [
    '🍓',
    '🌙',
    '⚡',
    '🌊',
    '🍀',
    '🪐',
    '🔥',
    '🎯',
    '🌈',
    '🍉',
    '🍋',
    '🎲',
    '🧩',
    '🎈',
    '🌻',
    '🍇',
  ];
  static const List<String> _stackSweepSymbols = [
    '🫖',
    '🌿',
    '☁️',
    '🪨',
    '🍃',
    '🪵',
    '🫧',
    '🌤️',
    '📚',
    '🕯️',
    '🪴',
    '🌾',
    '🧘',
    '💧',
  ];
  static const List<List<Color>> _defusePalettes = [
    [Color(0xFFE85D04), Color(0xFF2A9D8F)],
    [Color(0xFFD62828), Color(0xFF457B9D)],
    [Color(0xFF9D4EDD), Color(0xFF2A9D8F)],
    [Color(0xFFF77F00), Color(0xFF4D908E)],
  ];
  static const List<Color> _cubeFaceColors = [
    Color(0xFFF7F7F7),
    Color(0xFFE63946),
    Color(0xFF2A9D8F),
    Color(0xFFF4D35E),
    Color(0xFFF77F00),
    Color(0xFF457B9D),
  ];
  static const Color _cubeHintColor = Color(0xFF8B5CF6);

  final Random _random = Random();
  late final AnimationController _ambientController;
  late final AnimationController _cubeHintPulseController;
  late final AnimationController _cubeMoveController;
  late final AnimationController _defuseDialController;
  late final AnimationController _fortuneCrackController;
  late final ConfettiController _confettiController;
  late final DateTime _startedAt;
  late DateTime _attemptStartedAt;
  Timer? _ticker;
  int _secondsRemaining = 0;
  bool _isPaused = false;
  bool _showOutcome = false;
  bool _showStillStrongOptions = false;
  bool _activityCompleted = false;
  bool _finished = false;
  int? _personalBestScore;
  int? _bestScoreEarnedThisSheet;
  DateTime? _activityCompletedAt;

  int _defuseCount = 0;
  int _defuseTargetTapCount = 4;
  int _defuseBaseDialPeriodMs = 2400;
  List<Color> _defusePalette = _defusePalettes.first;
  List<double> _defuseTargets = const [];
  bool _defuseLastAttemptAccurate = false;
  List<_CubeStickerState> _cubeStickers = const [];
  _CubeSliceMove? _cubeAnimatingMove;
  _CubeFace? _cubeActiveFace;
  _CubeProjectedSticker? _cubeTouchedSticker;
  Offset? _cubeDragStart;
  Offset? _cubeDragCurrent;
  Offset? _cubeOrbitPoint;
  bool _cubeOrbiting = false;
  double _cubeYaw = -0.72;
  double _cubePitch = -0.46;
  int _cubeMoveCount = 0;
  int _cubeScrambleLength = 0;
  _CubeHintMode _cubeHintMode = _CubeHintMode.off;
  bool _stackHintsEnabled = false;
  final List<_CubeSliceMove> _cubeMoveHistory = <_CubeSliceMove>[];
  List<int> _pairDeck = [];
  List<String> _pairMatchEmojis = const [];
  List<_StackSweepTile> _stackTiles = const [];
  final Set<int> _matchedCards = <int>{};
  final Set<int> _revealedCards = <int>{};
  final Set<int> _removedStackTileIds = <int>{};
  final Set<int> _removingStackTileIds = <int>{};
  bool _pairLocked = false;
  bool _pairHintsEnabled = false;
  bool _defuseHintsEnabled = false;
  String? _localizedLocaleName;
  List<int> _triviaOrder = const [];
  List<List<int>> _triviaOptionOrders = const [];
  List<BreakTriviaPrompt> _triviaPrompts = const [];
  int _triviaIndex = 0;
  int? _triviaSelectedAnswer;
  bool _triviaHintsEnabled = false;
  int _triviaCorrectCount = 0;
  String? _zenFortune;
  List<String> _zenFortunes = const [];
  String? _fortuneWisdom;
  List<String> _fortuneWisdoms = const [];
  final Set<int> _fortuneRevealedCells = <int>{};
  final List<Offset> _fortuneScratchPoints = <Offset>[];
  bool _fortuneCookieCracked = false;
  bool _fortuneRevealQueued = false;
  List<double> _zenDropXSeeds = const [];
  List<double> _zenDropYSeeds = const [];
  List<double> _zenDropSpeeds = const [];
  List<double> _zenDropSizes = const [];
  final Map<int, DateTime> _zenCaughtAt = <int, DateTime>{};
  final Map<int, Timer> _zenRespawnTimers = <int, Timer>{};

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    _cubeHintPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _cubeMoveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _completeCubeAnimation();
        }
      });
    _defuseDialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fortuneCrackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 900),
    );
    _startedAt = DateTime.now();
    _attemptStartedAt = _startedAt;
    _secondsRemaining = widget.duration.inSeconds;
    _loadPersonalBestScore();
    if (widget.activityType == BreakActivityType.zenRoom) {
      _ambientController.repeat();
    }
    if (widget.activityType == BreakActivityType.cubeReset) {
      _cubeHintPulseController.repeat(reverse: true);
    }
    if (widget.activityType == BreakActivityType.defuse) {
      _startDefuseDial();
    }
    if (!widget.previewMode) {
      _startTicker();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));
    if (_localizedLocaleName == l10n.localeName) {
      return;
    }
    _localizedLocaleName = l10n.localeName;
    _triviaPrompts = BreakHelper.triviaPrompts(l10n);
    _zenFortunes = BreakHelper.zenFortunes(l10n);
    _fortuneWisdoms = BreakHelper.fortuneCookieWisdoms(l10n);
    _randomizeActivityState();
  }

  Future<void> _loadPersonalBestScore() async {
    if (widget.previewMode) {
      return;
    }
    if (!BreakHelper.supportsPersonalBest(widget.activityType)) {
      return;
    }
    try {
      final best = await DatabaseHelper.instance.getBestBreakScore(
        widget.activityType,
      );
      if (!mounted) return;
      setState(() {
        _updatePersonalBestWithScore(best);
      });
    } catch (_) {
      // Widget tests do not bootstrap sqflite. Ignore unavailable storage.
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    for (final timer in _zenRespawnTimers.values) {
      timer.cancel();
    }
    _ambientController.dispose();
    _cubeHintPulseController.dispose();
    _cubeMoveController.dispose();
    _defuseDialController.dispose();
    _fortuneCrackController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<bool> _handleExitRequest() async {
    if (widget.previewMode) {
      if (!_finished && mounted) {
        _finished = true;
        Navigator.pop(context);
      }
      return true;
    }
    if (_finished) return true;
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));

    final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.breakExitTitle),
            content: Text(
              l10n.breakExitBody,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.breakStay),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.breakExit),
              ),
            ],
          ),
        ) ??
        false;

    if (!mounted || !shouldExit) return false;
    _finished = true;
    Navigator.pop(
      context,
      BreakSessionResult(
        activityType: widget.activityType,
        status: BreakSessionStatus.aborted,
        score: _scoreToPersist(),
        startedAt: _startedAt,
        endedAt: DateTime.now(),
      ),
    );
    return false;
  }

  void _complete(BreakOutcome outcome, {BreakFollowUpAction? followUpAction}) {
    if (_finished) return;
    _finished = true;
    Navigator.pop(
      context,
      BreakSessionResult(
        activityType: widget.activityType,
        status: BreakSessionStatus.completed,
        outcome: outcome,
        followUpAction: followUpAction,
        score: _scoreToPersist(),
        startedAt: _startedAt,
        endedAt: DateTime.now(),
      ),
    );
  }

  void debugCompleteCurrentActivity() {
    _handleActivityCompleted();
  }

  void debugCrackFortuneCookie() {
    if (_fortuneCookieCracked) return;
    setState(() {
      _fortuneCookieCracked = true;
    });
    _fortuneCrackController.value = 1;
  }

  void debugRevealFortuneCookie() {
    if (!_fortuneCookieCracked) {
      debugCrackFortuneCookie();
    }
    const totalCells = _fortuneScratchColumns * _fortuneScratchRows;
    final revealedCount = (totalCells * _fortuneScratchRevealThreshold).ceil();
    setState(() {
      _fortuneRevealedCells.addAll(
        List<int>.generate(revealedCount, (index) => index),
      );
    });
    if (widget.previewMode) {
      _handleActivityCompleted();
    } else {
      _markFortuneRevealed();
    }
  }

  String? debugCurrentFortuneWisdom() => _fortuneWisdom;

  double debugCubePitch() => _cubePitch;

  void _togglePause() {
    HapticFeedback.selectionClick();
    if (_isPaused) {
      _resumeSession();
    } else {
      _pauseSession();
    }
  }

  void _pauseSession() {
    if (_isPaused || _showOutcome) return;
    _ticker?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeSession() {
    if (!_isPaused) return;
    if (!_showOutcome && _secondsRemaining > 0) {
      _startTicker();
    }
    setState(() {
      _isPaused = false;
    });
  }

  int? _currentAttemptScore() {
    switch (widget.activityType) {
      case BreakActivityType.defuse:
      case BreakActivityType.pairMatch:
      case BreakActivityType.cubeReset:
      case BreakActivityType.stackSweep:
        final completedAt = _activityCompletedAt;
        if (!_activityCompleted || completedAt == null) {
          return null;
        }
        return completedAt.difference(_attemptStartedAt).inMilliseconds;
      case BreakActivityType.triviaPivot:
        return _triviaCorrectCount;
      case BreakActivityType.fortuneCookie:
      case BreakActivityType.zenRoom:
        return null;
    }
  }

  int? _scoreToPersist() {
    if (widget.previewMode) {
      return null;
    }
    final current = _currentAttemptScore();
    final best = _bestScoreEarnedThisSheet;
    if (current == null) return best;
    if (best == null) return current;
    if (BreakHelper.prefersLowerPersonalBest(widget.activityType)) {
      return min(best, current);
    }
    return max(best, current);
  }

  String? _personalBestText(AppLocalizations l10n) {
    if (widget.previewMode) {
      return null;
    }
    final currentScore = _scoreToPersist();
    if (!BreakHelper.supportsPersonalBest(widget.activityType)) {
      return null;
    }

    int? best = _personalBestScore;
    if (currentScore != null) {
      if (best == null) {
        best = currentScore;
      } else if (BreakHelper.prefersLowerPersonalBest(widget.activityType)) {
        best = min(best, currentScore);
      } else {
        best = max(best, currentScore);
      }
    }

    if (best == null || best <= 0) {
      return null;
    }
    return BreakHelper.personalBestLabel(widget.activityType, best, l10n);
  }

  bool get _hasBreakCustomizationAccess =>
      Provider.of<PurchaseProvider?>(context, listen: false)?.isPlus ?? true;

  void _showBreakCustomizationLockedDialog(String entryPoint) {
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));
    showPlusUpgradeDialog(
      context,
      subtitle: l10n.breakCustomizationLockedSubtitle,
      entryPoint: entryPoint,
    );
  }

  List<int> _buildPairDeck() {
    final pairCount = _pairMatchEmojis.length;
    final deck = <int>[
      for (var i = 0; i < pairCount; i++) i,
      for (var i = 0; i < pairCount; i++) i,
    ]..shuffle(_random);
    return deck;
  }

  List<_StackSweepTile> _buildStackTiles() {
    const layerRowCounts = [
      [6, 6, 6],
      [6, 6],
      [5, 5],
      [4, 4],
    ];
    const layerRowTops = [
      [0.48, 0.64, 0.80],
      [0.30, 0.52],
      [0.14, 0.36],
      [0.00, 0.20],
    ];

    final slots = <_StackSweepSlot>[];
    for (var layer = 0; layer < layerRowCounts.length; layer++) {
      for (var row = 0; row < layerRowCounts[layer].length; row++) {
        final count = layerRowCounts[layer][row];
        final rowInset = max(0.0, (6 - count) * 0.10);
        final start = 0.02 + (rowInset / 2);
        final end = 0.88 - (rowInset / 2);
        final rowStackOrder = _buildStackRowOrder(
          count,
          reverse: (layer + row).isOdd,
        );
        for (var col = 0; col < count; col++) {
          final left =
              count == 1 ? 0.45 : start + ((end - start) * (col / (count - 1)));
          final leftJitter = (_random.nextDouble() - 0.5) * 0.015;
          final topJitter = (_random.nextDouble() - 0.5) * 0.014;
          slots.add(
            _StackSweepSlot(
              leftFactor: (left + leftJitter).clamp(0.0, 0.9),
              topFactor: (layerRowTops[layer][row] + topJitter).clamp(0.0, 0.9),
              layer: layer,
              row: row,
              rotation: (_random.nextDouble() - 0.5) * 0.08,
              stackOrder: rowStackOrder[col],
            ),
          );
        }
      }
    }

    final symbols = List<String>.generate(
      slots.length,
      (index) => _stackSweepSymbols[index % _stackSweepSymbols.length],
    )..shuffle(_random);

    return List<_StackSweepTile>.generate(slots.length, (index) {
      return _StackSweepTile(
        id: index,
        symbol: symbols[index],
        slot: slots[index],
      );
    });
  }

  List<int> _buildStackRowOrder(int count, {required bool reverse}) {
    final visitOrder = <int>[];
    if (count.isOdd) {
      visitOrder.add(count ~/ 2);
    } else {
      visitOrder
        ..add((count ~/ 2) - 1)
        ..add(count ~/ 2);
    }

    for (var step = 1; visitOrder.length < count; step++) {
      final left = ((count - 1) ~/ 2) - step;
      final right = (count ~/ 2) + step;
      if (left >= 0) {
        visitOrder.add(left);
      }
      if (right < count) {
        visitOrder.add(right);
      }
    }

    final source = reverse ? visitOrder.reversed.toList() : visitOrder;
    final stackOrder = List<int>.filled(count, 0);
    for (var order = 0; order < source.length; order++) {
      stackOrder[source[order]] = order;
    }
    return stackOrder;
  }

  String? _pickFortuneWisdom({String? excluding}) {
    if (_fortuneWisdoms.isEmpty) return null;
    final pool = List<String>.from(_fortuneWisdoms);
    if (excluding != null && pool.length > 1) {
      pool.remove(excluding);
    }
    return pool[_random.nextInt(pool.length)];
  }

  void _randomizeActivityState() {
    final previousFortune = _fortuneWisdom;
    final emojiSelection = List<String>.from(_pairMatchEmojiPool)
      ..shuffle(_random);
    _pairMatchEmojis = emojiSelection.take(10).toList();
    _pairDeck = _buildPairDeck();
    _stackTiles = _buildStackTiles();
    _pairHintsEnabled = false;
    _defuseHintsEnabled = false;
    _defuseTargetTapCount = 4;
    _defuseCount = 0;
    _defuseBaseDialPeriodMs = 2150 + _random.nextInt(900);
    _defusePalette = _defusePalettes[_random.nextInt(_defusePalettes.length)];
    _defuseTargets = List<double>.generate(
      _defuseTargetTapCount,
      (_) => _random.nextDouble(),
    );
    _resetCubePuzzle();
    _defuseLastAttemptAccurate = false;
    _triviaCorrectCount = 0;
    _defuseDialController
      ..duration = Duration(milliseconds: _defuseBaseDialPeriodMs)
      ..value = _random.nextDouble();
    if (widget.activityType == BreakActivityType.defuse &&
        !_isPaused &&
        !_showOutcome &&
        !_activityCompleted) {
      _startDefuseDial(restart: true);
    }
    _triviaOrder = List<int>.generate(_triviaPrompts.length, (i) => i)
      ..shuffle(_random);
    _triviaOptionOrders = List<List<int>>.generate(
      _triviaPrompts.length,
      (promptIndex) => List<int>.generate(
        _triviaPrompts[promptIndex].options.length,
        (optionIndex) => optionIndex,
      )..shuffle(_random),
    );
    _triviaIndex = 0;
    _triviaHintsEnabled = false;
    _fortuneWisdom = _pickFortuneWisdom(excluding: previousFortune);
    _fortuneRevealedCells.clear();
    _fortuneScratchPoints.clear();
    _fortuneCookieCracked = false;
    _fortuneRevealQueued = false;
    _fortuneCrackController.value = 0;
    _zenFortune = _zenFortunes.isEmpty
        ? null
        : _zenFortunes[_random.nextInt(_zenFortunes.length)];
    _zenDropXSeeds = List<double>.generate(14, (_) => _random.nextDouble());
    _zenDropYSeeds = List<double>.generate(14, (_) => _random.nextDouble());
    _zenDropSpeeds =
        List<double>.generate(14, (_) => 4.0 + (_random.nextDouble() * 1.2));
    _zenDropSizes =
        List<double>.generate(14, (_) => 10 + (_random.nextDouble() * 6));
    _removedStackTileIds.clear();
    _removingStackTileIds.clear();
    for (final timer in _zenRespawnTimers.values) {
      timer.cancel();
    }
    _zenRespawnTimers.clear();
    _zenCaughtAt.clear();
    _ambientController.value = _random.nextDouble();
    if (widget.activityType == BreakActivityType.zenRoom) {
      _ambientController.repeat();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _secondsRemaining - 1;
      if (next <= 0) {
        _ticker?.cancel();
        if (widget.activityType == BreakActivityType.defuse) {
          _stopDefuseDial();
        }
        HapticFeedback.mediumImpact();
        setState(() {
          _secondsRemaining = 0;
          _showOutcome = true;
          _showStillStrongOptions = false;
        });
        return;
      }

      setState(() {
        _secondsRemaining = next;
      });
    });
  }

  void _updatePersonalBestWithScore(int? score) {
    if (score == null || score <= 0) return;
    if (!BreakHelper.supportsPersonalBest(widget.activityType)) return;

    final existing = _personalBestScore;
    if (existing == null) {
      _personalBestScore = score;
      return;
    }

    if (BreakHelper.prefersLowerPersonalBest(widget.activityType)) {
      _personalBestScore = min(existing, score);
    } else {
      _personalBestScore = max(existing, score);
    }
  }

  Future<void> _handleActivityCompleted() async {
    if (_activityCompleted || !mounted) return;
    _ticker?.cancel();
    if (widget.activityType == BreakActivityType.defuse) {
      _stopDefuseDial();
    }
    HapticFeedback.mediumImpact();
    _confettiController.play();
    final completedAt = DateTime.now();
    final score = completedAt.difference(_attemptStartedAt).inMilliseconds;
    setState(() {
      _activityCompletedAt = completedAt;
      if (!widget.previewMode) {
        _bestScoreEarnedThisSheet =
            _mergeScores(_bestScoreEarnedThisSheet, score);
        _updatePersonalBestWithScore(score);
      }
      _activityCompleted = true;
      _showOutcome = !widget.previewMode;
      _showStillStrongOptions = false;
    });
  }

  int? _mergeScores(int? existing, int? candidate) {
    if (candidate == null || candidate <= 0) return existing;
    if (existing == null || existing <= 0) return candidate;
    if (BreakHelper.prefersLowerPersonalBest(widget.activityType)) {
      return min(existing, candidate);
    }
    return max(existing, candidate);
  }

  void _continueCurrentActivity() {
    if (widget.previewMode) {
      return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _isPaused = false;
      _secondsRemaining = 30;
      _showOutcome = false;
      _showStillStrongOptions = false;
    });
    if (widget.activityType == BreakActivityType.defuse) {
      _startDefuseDial();
    }
    _startTicker();
  }

  void _resetCurrentActivity() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPaused = false;
      _attemptStartedAt = DateTime.now();
      _activityCompletedAt = null;
      _secondsRemaining = widget.duration.inSeconds;
      _showOutcome = false;
      _showStillStrongOptions = false;
      _activityCompleted = false;
      _matchedCards.clear();
      _revealedCards.clear();
      _removedStackTileIds.clear();
      _removingStackTileIds.clear();
      _pairLocked = false;
      _triviaSelectedAnswer = null;
      _randomizeActivityState();
    });
    if (widget.activityType == BreakActivityType.defuse) {
      _startDefuseDial();
    }
    if (!widget.previewMode) {
      _startTicker();
    }
  }

  double _fortuneRevealProgress() {
    const totalCells = _fortuneScratchColumns * _fortuneScratchRows;
    if (totalCells == 0) return 0;
    return _fortuneRevealedCells.length / totalCells;
  }

  void _markFortuneRevealed() {
    if (_fortuneRevealQueued) return;
    setState(() {
      _fortuneRevealQueued = true;
    });
  }

  void _completeFortuneCookie() {
    if (!_fortuneRevealQueued) return;
    HapticFeedback.lightImpact();
    _handleActivityCompleted();
  }

  Future<void> _onFortuneCookieTap() async {
    if (_fortuneCookieCracked || _fortuneCrackController.isAnimating) {
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _fortuneCookieCracked = true;
    });
    await _fortuneCrackController.forward(from: 0);
  }

  void _revealFortuneAt(Offset localPosition, Size size) {
    if (!_fortuneCookieCracked || _fortuneRevealQueued) {
      return;
    }
    final cellWidth = size.width / _fortuneScratchColumns;
    final cellHeight = size.height / _fortuneScratchRows;
    final revealRadius = max(cellWidth, cellHeight) * 1.35;
    var changed = false;
    final nextPoints = <Offset>[
      if (_fortuneScratchPoints.isEmpty ||
          (_fortuneScratchPoints.last - localPosition).distance > 6)
        localPosition,
    ];

    for (var row = 0; row < _fortuneScratchRows; row++) {
      for (var col = 0; col < _fortuneScratchColumns; col++) {
        final center = Offset(
          (col + 0.5) * cellWidth,
          (row + 0.5) * cellHeight,
        );
        if ((center - localPosition).distance > revealRadius) {
          continue;
        }
        changed = _fortuneRevealedCells.add(
              (row * _fortuneScratchColumns) + col,
            ) ||
            changed;
      }
    }

    if (!changed && nextPoints.isEmpty) return;

    setState(() {
      _fortuneScratchPoints.addAll(nextPoints);
      if (_fortuneRevealProgress() >= _fortuneScratchRevealThreshold) {
        _fortuneRevealQueued = true;
      }
    });
    if (_fortuneRevealQueued && widget.previewMode) {
      _handleActivityCompleted();
    }
  }

  String _formatCountdown() {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int _defuseDialPeriodForStep(int step) {
    final clamped = step.clamp(0, _defuseTargetTapCount - 1);
    final factor = pow(0.82, clamped).toDouble();
    return max(950, (_defuseBaseDialPeriodMs * factor).round());
  }

  void _startDefuseDial({bool restart = false}) {
    if (_defuseDialController.isAnimating && !restart) {
      return;
    }
    _defuseDialController.repeat(
      period: Duration(
        milliseconds: _defuseDialPeriodForStep(
          _defuseCount.clamp(0, _defuseTargetTapCount - 1),
        ),
      ),
    );
  }

  void _stopDefuseDial() {
    _defuseDialController.stop();
  }

  double _circularDistance(double a, double b) {
    final distance = (a - b).abs();
    return min(distance, 1 - distance);
  }

  double _defuseWindowForStep(int step) {
    final clamped = step.clamp(0, _defuseHintedSuccessWindows.length - 1);
    final hintedWindow = _defuseHintedSuccessWindows[clamped];
    if (_defuseHintsEnabled ||
        clamped == _defuseHintedSuccessWindows.length - 1) {
      return hintedWindow;
    }
    return hintedWindow * 0.7;
  }

  List<Color> _defuseRingColors() {
    return List<Color>.generate(_defuseTargetTapCount, (index) {
      if (_defuseTargetTapCount <= 1) return _defusePalette.first;
      final t = index / (_defuseTargetTapCount - 1);
      return Color.lerp(_defusePalette.first, _defusePalette.last, t) ??
          _defusePalette.first;
    });
  }

  void _onDefuseTap() {
    if (_defuseCount >= _defuseTargetTapCount) return;

    final target = _defuseTargets[_defuseCount];
    final aligned = _circularDistance(_defuseDialController.value, target) <=
        _defuseWindowForStep(_defuseCount);
    if (!aligned) {
      HapticFeedback.selectionClick();
      setState(() => _defuseLastAttemptAccurate = false);
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _defuseCount = (_defuseCount + 1).clamp(0, _defuseTargetTapCount);
      _defuseLastAttemptAccurate = true;
    });
    if (_defuseCount >= _defuseTargetTapCount) {
      _handleActivityCompleted();
      return;
    }
    _startDefuseDial(restart: true);
  }

  Future<void> _onPairCardTap(int index) async {
    if (_pairLocked ||
        _matchedCards.contains(index) ||
        _revealedCards.contains(index)) {
      return;
    }

    HapticFeedback.selectionClick();
    setState(() => _revealedCards.add(index));

    if (_revealedCards.length < 2) return;

    final first = _revealedCards.first;
    final second = _revealedCards.last;
    if (_pairDeck[first] == _pairDeck[second]) {
      setState(() {
        _matchedCards.addAll(_revealedCards);
        _revealedCards.clear();
      });
      if (_matchedCards.length == _pairDeck.length) {
        _handleActivityCompleted();
      }
      return;
    }

    setState(() => _pairLocked = true);
    await Future.delayed(const Duration(milliseconds: 675));
    if (!mounted) return;
    setState(() {
      _pairLocked = false;
      _revealedCards.clear();
    });
  }

  Rect _stackTileRectFor(_StackSweepTile tile, Size size) {
    final tileWidth = min(size.width * 0.20, 72.0);
    final tileHeight = min(size.height * 0.11, 42.0);
    final left = tile.slot.leftFactor * (size.width - tileWidth);
    final top = tile.slot.topFactor * (size.height - tileHeight);
    return Rect.fromLTWH(left, top, tileWidth, tileHeight);
  }

  bool _isStackTileAbove(_StackSweepTile candidate, _StackSweepTile tile) {
    if (candidate.slot.layer != tile.slot.layer) {
      return candidate.slot.layer > tile.slot.layer;
    }
    if (candidate.slot.row != tile.slot.row) {
      return candidate.slot.row > tile.slot.row;
    }
    return candidate.slot.stackOrder > tile.slot.stackOrder;
  }

  bool _isStackTileRemovable(_StackSweepTile tile, Size size) {
    if (_removedStackTileIds.contains(tile.id) ||
        _removingStackTileIds.contains(tile.id)) {
      return false;
    }

    final rect = _stackTileRectFor(tile, size);
    for (final other in _stackTiles) {
      if (other.id == tile.id ||
          !_isStackTileAbove(other, tile) ||
          _removedStackTileIds.contains(other.id) ||
          _removingStackTileIds.contains(other.id)) {
        continue;
      }

      if (UrgeBreakSheet.debugStackRectsCountAsBlocking(
        blockerRect: _stackTileRectFor(other, size),
        blockedRect: rect,
        blockerRotation: other.slot.rotation,
        blockedRotation: tile.slot.rotation,
      )) {
        return false;
      }
    }
    return true;
  }

  Future<void> _onStackTileTap(_StackSweepTile tile, Size size) async {
    if (!_isStackTileRemovable(tile, size)) return;

    HapticFeedback.selectionClick();
    setState(() => _removingStackTileIds.add(tile.id));
    await Future.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    final nextRemoved = _removedStackTileIds.length + 1;
    setState(() {
      _removingStackTileIds.remove(tile.id);
      _removedStackTileIds.add(tile.id);
    });
    if (nextRemoved == _stackTiles.length) {
      _handleActivityCompleted();
    }
  }

  void _onTriviaAnswer(int index) {
    HapticFeedback.selectionClick();
    final prompt = _triviaPrompts[_triviaOrder[_triviaIndex]];
    final withinScoringWindow =
        DateTime.now().difference(_attemptStartedAt) <= widget.duration;
    setState(() {
      _triviaSelectedAnswer = index;
      if (withinScoringWindow && index == prompt.answerIndex) {
        _triviaCorrectCount += 1;
        _bestScoreEarnedThisSheet =
            _mergeScores(_bestScoreEarnedThisSheet, _triviaCorrectCount);
        _updatePersonalBestWithScore(_triviaCorrectCount);
      }
    });
  }

  void _togglePairHints() {
    if (!_hasBreakCustomizationAccess) {
      _showBreakCustomizationLockedDialog('break_pair_hints_locked');
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _pairHintsEnabled = !_pairHintsEnabled;
    });
  }

  void _toggleDefuseHints() {
    if (!_hasBreakCustomizationAccess) {
      _showBreakCustomizationLockedDialog('break_defuse_hints_locked');
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _defuseHintsEnabled = !_defuseHintsEnabled;
    });
  }

  Set<int> _pairHintIndices() {
    if (!_pairHintsEnabled || _revealedCards.length != 1) {
      return const <int>{};
    }

    final firstIndex = _revealedCards.first;
    final pairValue = _pairDeck[firstIndex];
    final matchIndex =
        List<int>.generate(_pairDeck.length, (i) => i).firstWhere(
      (index) => index != firstIndex && _pairDeck[index] == pairValue,
      orElse: () => -1,
    );
    if (matchIndex == -1) {
      return const <int>{};
    }

    const columns = 4;
    final hiddenCandidates = List<int>.generate(_pairDeck.length, (i) => i)
        .where(
          (index) =>
              index != firstIndex &&
              !_matchedCards.contains(index) &&
              !_revealedCards.contains(index),
        )
        .toList();
    hiddenCandidates.sort((a, b) {
      final matchRow = matchIndex ~/ columns;
      final matchCol = matchIndex % columns;
      final aDistance =
          ((a ~/ columns) - matchRow).abs() + ((a % columns) - matchCol).abs();
      final bDistance =
          ((b ~/ columns) - matchRow).abs() + ((b % columns) - matchCol).abs();
      if (aDistance != bDistance) {
        return aDistance.compareTo(bDistance);
      }
      return a.compareTo(b);
    });

    final selected = <int>{matchIndex};
    for (final index in hiddenCandidates) {
      selected.add(index);
      if (selected.length == 4) {
        break;
      }
    }
    return selected;
  }

  List<int> _triviaOptionOrderFor(int promptIndex) {
    return _triviaOptionOrders[promptIndex];
  }

  int? _triviaRemovedOptionIndex(BreakTriviaPrompt prompt, int promptIndex) {
    if (!_triviaHintsEnabled || prompt.options.length <= 2) {
      return null;
    }
    final optionOrder = _triviaOptionOrderFor(promptIndex);
    for (var orderIndex = optionOrder.length - 1;
        orderIndex >= 0;
        orderIndex--) {
      final index = optionOrder[orderIndex];
      if (index != prompt.answerIndex) {
        return index;
      }
    }
    return null;
  }

  List<int> _visibleTriviaOptionIndices(
      BreakTriviaPrompt prompt, int promptIndex) {
    final removedIndex = _triviaRemovedOptionIndex(prompt, promptIndex);
    return _triviaOptionOrderFor(promptIndex)
        .where((index) => index != removedIndex)
        .toList();
  }

  void _toggleTriviaHints(BreakTriviaPrompt prompt, int promptIndex) {
    if (!_hasBreakCustomizationAccess) {
      _showBreakCustomizationLockedDialog('break_trivia_hints_locked');
      return;
    }
    HapticFeedback.selectionClick();
    final nextEnabled = !_triviaHintsEnabled;
    final removedIndex =
        nextEnabled ? _triviaRemovedOptionIndex(prompt, promptIndex) : null;
    setState(() {
      _triviaHintsEnabled = nextEnabled;
      if (_triviaSelectedAnswer != null &&
          _triviaSelectedAnswer == removedIndex) {
        _triviaSelectedAnswer = null;
      }
    });
  }

  List<_CubeStickerState> _buildSolvedCubeStickers() {
    final stickers = <_CubeStickerState>[];
    for (var x = -1; x <= 1; x++) {
      for (var y = -1; y <= 1; y++) {
        for (var z = -1; z <= 1; z++) {
          if (y == 1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(0, 1, 0),
                colorIndex: _CubeFaceIndex.up,
              ),
            );
          }
          if (x == 1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(1, 0, 0),
                colorIndex: _CubeFaceIndex.right,
              ),
            );
          }
          if (z == 1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(0, 0, 1),
                colorIndex: _CubeFaceIndex.front,
              ),
            );
          }
          if (y == -1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(0, -1, 0),
                colorIndex: _CubeFaceIndex.down,
              ),
            );
          }
          if (x == -1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(-1, 0, 0),
                colorIndex: _CubeFaceIndex.left,
              ),
            );
          }
          if (z == -1) {
            stickers.add(
              _CubeStickerState(
                position: _CubeInt3(x, y, z),
                normal: const _CubeInt3(0, 0, -1),
                colorIndex: _CubeFaceIndex.back,
              ),
            );
          }
        }
      }
    }
    return stickers;
  }

  int _cubeCoordOnAxis(_CubeInt3 vector, _CubeAxis axis) {
    switch (axis) {
      case _CubeAxis.x:
        return vector.x;
      case _CubeAxis.y:
        return vector.y;
      case _CubeAxis.z:
        return vector.z;
    }
  }

  _CubeInt3 _rotateCubeVectorPositive(_CubeInt3 vector, _CubeAxis axis) {
    switch (axis) {
      case _CubeAxis.x:
        return _CubeInt3(vector.x, -vector.z, vector.y);
      case _CubeAxis.y:
        return _CubeInt3(vector.z, vector.y, -vector.x);
      case _CubeAxis.z:
        return _CubeInt3(-vector.y, vector.x, vector.z);
    }
  }

  void _mutateCubeLayerOn(
    List<_CubeStickerState> stickers,
    _CubeSliceMove move,
  ) {
    final turns = ((move.quarterTurns % 4) + 4) % 4;
    if (turns == 0) return;

    for (var turn = 0; turn < turns; turn++) {
      for (final sticker in stickers) {
        if (_cubeCoordOnAxis(sticker.position, move.axis) != move.layer) {
          continue;
        }
        sticker.position =
            _rotateCubeVectorPositive(sticker.position, move.axis);
        sticker.normal = _rotateCubeVectorPositive(sticker.normal, move.axis);
      }
    }
  }

  void _mutateCubeLayer(_CubeSliceMove move) {
    _mutateCubeLayerOn(_cubeStickers, move);
  }

  void _recordCubeMove(_CubeSliceMove move) {
    if (_cubeMoveHistory.isNotEmpty &&
        move.isInverseOf(_cubeMoveHistory.last)) {
      _cubeMoveHistory.removeLast();
      return;
    }
    _cubeMoveHistory.add(move);
  }

  bool _isCubeSolved() => _cubeSolvedFaceCount() == 6;

  int _cubeSolvedFaceCount() {
    var solvedFaces = 0;
    for (final face in _CubeFace.values) {
      final normal = face.normal;
      final faceStickers =
          _cubeStickers.where((sticker) => sticker.normal == normal).toList();
      if (faceStickers.length != 9) {
        continue;
      }
      final firstColor = faceStickers.first.colorIndex;
      if (faceStickers.every((sticker) => sticker.colorIndex == firstColor)) {
        solvedFaces += 1;
      }
    }
    return solvedFaces;
  }

  _CubeSliceMove? _cubeHintMove() {
    if (_cubeAnimatingMove != null || _activityCompleted) return null;
    if (_cubeHintMode == _CubeHintMode.off) return null;
    if (_cubeMoveHistory.isEmpty) return null;
    return _cubeMoveHistory.last.inverse;
  }

  Future<void> _toggleCubeHints() async {
    if (!_hasBreakCustomizationAccess) {
      _showBreakCustomizationLockedDialog('break_cube_hints_locked');
      return;
    }
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));
    HapticFeedback.selectionClick();
    if (_cubeHintMode != _CubeHintMode.off) {
      setState(() {
        _cubeHintMode = _CubeHintMode.off;
      });
      return;
    }

    final nextMode = await showDialog<_CubeHintMode>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.breakHintStrengthTitle),
        content: Text(l10n.breakHintStrengthBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, _CubeHintMode.subtle),
            child: Text(l10n.breakHintStrengthSubtle),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _CubeHintMode.strong),
            child: Text(l10n.breakHintStrengthStrong),
          ),
        ],
      ),
    );

    if (!mounted || nextMode == null) return;
    setState(() {
      _cubeHintMode = nextMode;
    });
  }

  void _toggleStackHints() {
    if (!_hasBreakCustomizationAccess) {
      _showBreakCustomizationLockedDialog('break_stack_hints_locked');
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _stackHintsEnabled = !_stackHintsEnabled;
    });
  }

  void _resetCubePuzzle() {
    _cubeMoveController.stop();
    _cubeStickers = _buildSolvedCubeStickers();
    _cubeMoveCount = 0;
    _cubeScrambleLength = 5 + _random.nextInt(3);
    _cubeMoveHistory.clear();
    _cubeYaw = -0.72;
    _cubePitch = -0.46;
    _cubeAnimatingMove = null;
    _cubeMoveController.value = 0;
    _cubeMoveHistory.clear();
    _cubeActiveFace = null;
    _cubeTouchedSticker = null;
    _cubeDragStart = null;
    _cubeDragCurrent = null;
    _cubeOrbitPoint = null;
    _cubeOrbiting = false;

    _CubeSliceMove? previous;
    for (var i = 0; i < _cubeScrambleLength; i++) {
      final choices = _CubeSliceMove.outerFaceMoves
          .where(
            (move) =>
                previous == null ||
                move.axis != previous.axis ||
                move.layer != previous.layer,
          )
          .toList();
      final move = choices[_random.nextInt(choices.length)];
      _mutateCubeLayer(move);
      _recordCubeMove(move);
      previous = move;
    }

    if (_isCubeSolved()) {
      _resetCubePuzzle();
    }
  }

  void _applyCubeMove(_CubeSliceMove move) {
    if (_activityCompleted || _cubeAnimatingMove != null) return;

    HapticFeedback.selectionClick();
    setState(() {
      _cubeMoveCount += 1;
      _cubeAnimatingMove = move;
    });
    _cubeMoveController.forward(from: 0);
  }

  void _completeCubeAnimation() {
    final move = _cubeAnimatingMove;
    if (move == null || !mounted) return;

    setState(() {
      _mutateCubeLayer(move);
      _recordCubeMove(move);
      _cubeAnimatingMove = null;
      _cubeMoveController.value = 0;
    });

    if (_isCubeSolved()) {
      _handleActivityCompleted();
    }
  }

  _CubeProjectedSticker? _cubeStickerAt(Offset point, Size size) {
    final projected = _CubeProjection.buildProjectedStickers(
      stickers: _cubeStickers,
      size: size,
      yaw: _cubeYaw,
      pitch: _cubePitch,
    )..sort((a, b) => b.depth.compareTo(a.depth));

    for (final sticker in projected) {
      if (sticker.path.contains(point)) {
        return sticker;
      }
    }
    return null;
  }

  void _onCubeDragStart(Offset localPosition, Size size) {
    if (_cubeAnimatingMove != null) return;
    final sticker = _cubeStickerAt(localPosition, size);
    setState(() {
      _cubeDragStart = localPosition;
      _cubeDragCurrent = localPosition;
      _cubeTouchedSticker = sticker;
      _cubeActiveFace = sticker?.baseFace;
      _cubeOrbiting = sticker == null;
      _cubeOrbitPoint = sticker == null ? localPosition : null;
    });
  }

  void _onCubeDragUpdate(Offset localPosition) {
    if (_cubeAnimatingMove != null) return;
    if (_cubeOrbiting && _cubeOrbitPoint != null) {
      final delta = localPosition - _cubeOrbitPoint!;
      setState(() {
        _cubeYaw += delta.dx * 0.012;
        _cubePitch = (_cubePitch + (delta.dy * 0.012)).clamp(-1.15, 1.15);
        _cubeOrbitPoint = localPosition;
      });
      return;
    }

    if (_cubeDragStart == null) return;
    setState(() {
      _cubeDragCurrent = localPosition;
    });
  }

  void _resetCubeDrag() {
    if (_cubeActiveFace == null &&
        _cubeTouchedSticker == null &&
        _cubeDragStart == null &&
        _cubeDragCurrent == null &&
        !_cubeOrbiting &&
        _cubeOrbitPoint == null) {
      return;
    }
    setState(() {
      _cubeActiveFace = null;
      _cubeTouchedSticker = null;
      _cubeDragStart = null;
      _cubeDragCurrent = null;
      _cubeOrbiting = false;
      _cubeOrbitPoint = null;
    });
  }

  _CubeSliceMove? _cubeMoveForSwipe(
    _CubeProjectedSticker sticker,
    Offset delta,
    Size size,
  ) {
    if (delta.distance < 18) return null;

    final primary = _CubeProjection.primarySwipeAxis(
      sticker: sticker,
      size: size,
      yaw: _cubeYaw,
      pitch: _cubePitch,
      dragDelta: delta,
    );
    final swipeVector =
        primary == _CubeSwipePrimary.horizontal ? sticker.u : sticker.v;
    final axisVector = sticker.normal.cross(swipeVector);
    final axisInt = _CubeInt3(
      axisVector.x.round(),
      axisVector.y.round(),
      axisVector.z.round(),
    );
    final axis = axisInt.principalAxis;
    final axisSign = axisInt.axisSign;
    final layer = _cubeCoordOnAxis(sticker.position, axis);
    final tangent = axisVector.cross(sticker.center);
    final tangentScreen = _CubeProjection.projectVectorToScreen(
      origin: sticker.center,
      vector: tangent,
      size: size,
      yaw: _cubeYaw,
      pitch: _cubePitch,
    );
    final desiredTurn =
        tangentScreen.dx * delta.dx + tangentScreen.dy * delta.dy >= 0 ? 1 : -1;

    return _CubeSliceMove(
      axis: axis,
      layer: layer,
      quarterTurns: desiredTurn * axisSign,
    );
  }

  void _onCubeDragEnd(Size size) {
    if (_cubeAnimatingMove != null) {
      _resetCubeDrag();
      return;
    }
    final start = _cubeDragStart;
    final current = _cubeDragCurrent;
    final sticker = _cubeTouchedSticker;
    final orbiting = _cubeOrbiting;
    _resetCubeDrag();
    if (orbiting || start == null || current == null || sticker == null) {
      return;
    }

    final move = _cubeMoveForSwipe(sticker, current - start, size);
    if (move != null) {
      _applyCubeMove(move);
    }
  }

  void _nextTrivia() {
    HapticFeedback.lightImpact();
    setState(() {
      _triviaSelectedAnswer = null;
      _triviaIndex = (_triviaIndex + 1) % _triviaOrder.length;
    });
  }

  void _pickZenFortune() {
    HapticFeedback.lightImpact();
    setState(() {
      final current = _zenFortune;
      final pool = List<String>.from(_zenFortunes);
      if (current != null && pool.length > 1) {
        pool.remove(current);
      }
      if (pool.isNotEmpty) {
        _zenFortune = pool[_random.nextInt(pool.length)];
      }
    });
  }

  List<Color> _animatedZenColors() {
    const zenPalettes = [
      [Color(0xFFB7E4C7), Color(0xFF95D5B2), Color(0xFF74C69D)],
      [Color(0xFFFFE8A1), Color(0xFFFFD166), Color(0xFFF4A261)],
      [Color(0xFFBDE0FE), Color(0xFFA2D2FF), Color(0xFF8ECAE6)],
      [Color(0xFFE9D8FD), Color(0xFFD0BFFF), Color(0xFFB8C0FF)],
      [Color(0xFFCDEAC0), Color(0xFFA9DEF9), Color(0xFFE4C1F9)],
    ];
    final progress = _ambientController.value * zenPalettes.length;
    final baseIndex = progress.floor() % zenPalettes.length;
    final nextIndex = (baseIndex + 1) % zenPalettes.length;
    final t = progress - progress.floor();

    return List<Color>.generate(3, (index) {
      return Color.lerp(
            zenPalettes[baseIndex][index],
            zenPalettes[nextIndex][index],
            t,
          ) ??
          zenPalettes[baseIndex][index];
    });
  }

  Rect _zenRainRegion(Size size) {
    const horizontalInset = 14.0;
    const topInset = 14.0;
    const bottomInset = 14.0;
    return Rect.fromLTWH(
      horizontalInset,
      topInset,
      max(0, size.width - (horizontalInset * 2)),
      max(0, size.height - topInset - bottomInset),
    );
  }

  double _zenDropProgressFor(int index) {
    final raw = _zenDropYSeeds[index] +
        (_ambientController.value * _zenDropSpeeds[index]);
    return raw - raw.floorToDouble();
  }

  Offset _zenDropCenterAt(int index, Size size) {
    final progress = _zenDropProgressFor(index);
    final xBase = 26 + (_zenDropXSeeds[index] * (size.width - 52));
    final radius = _zenDropSizes[index];
    final tailLength = radius * 2.7;
    final startY = -radius - tailLength;
    final endY = size.height + radius;
    final baseY = startY + ((endY - startY) * progress);
    final x = xBase.clamp(24.0, size.width - 24.0);
    final y = baseY;
    return Offset(x, y);
  }

  bool _zenDropIsVisible(Offset center, double radius, Size size) {
    return center.dx + radius >= 0 &&
        center.dx - radius <= size.width &&
        center.dy + radius >= 0 &&
        center.dy - radius <= size.height;
  }

  void _resetZenDropAboveRegion(int index) {
    final currentPhase = _ambientController.value * _zenDropSpeeds[index];
    final wrapped = currentPhase - currentPhase.floorToDouble();
    _zenDropYSeeds[index] = (1 - wrapped) % 1.0;
  }

  double _zenCatchProgressFor(int index) {
    final caughtAt = _zenCaughtAt[index];
    if (caughtAt == null) return 0;
    final elapsed = DateTime.now().difference(caughtAt).inMilliseconds;
    return (elapsed / 420).clamp(0, 1).toDouble();
  }

  void _catchZenDrop(int index) {
    if (_zenCaughtAt.containsKey(index)) return;
    _pickZenFortune();
    setState(() {
      _zenCaughtAt[index] = DateTime.now();
    });
    _zenRespawnTimers[index]?.cancel();
    _zenRespawnTimers[index] = Timer(const Duration(milliseconds: 460), () {
      if (!mounted) return;
      setState(() {
        _zenCaughtAt.remove(index);
        _resetZenDropAboveRegion(index);
      });
      _zenRespawnTimers.remove(index)?.cancel();
    });
  }

  void _onZenTapDown(TapDownDetails details, Rect rainRegion) {
    if (!rainRegion.contains(details.localPosition)) return;
    final tapPoint = details.localPosition - rainRegion.topLeft;
    final rainSize = rainRegion.size;
    for (var i = 0; i < _zenDropSizes.length; i++) {
      if (_zenCaughtAt.containsKey(i)) continue;
      final center = _zenDropCenterAt(i, rainSize);
      final radius = _zenDropSizes[i] + 10;
      if (!_zenDropIsVisible(center, radius, rainSize)) continue;
      if ((tapPoint - center).distance <= radius) {
        _catchZenDrop(i);
        return;
      }
    }
  }

  Widget _buildStageShell(
    BuildContext context,
    BreakActivityDefinition definition,
    Widget child,
  ) {
    final compact = MediaQuery.of(context).size.height < 760;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: definition.color.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 18),
        child: child,
      ),
    );
  }

  Widget _buildPreviewControls(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            key: const Key('break_preview_restart'),
            onPressed: _resetCurrentActivity,
            icon: const Icon(Icons.autorenew_rounded),
            label: Text(l10n.breakReplayActivity),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            key: const Key('break_preview_quit'),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: Text(l10n.breakExit),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFortuneCookieActivity(
    BreakActivityDefinition definition,
    AppLocalizations l10n,
  ) {
    final revealProgress = _fortuneRevealProgress().clamp(0.0, 1.0).toDouble();
    final status = !_fortuneCookieCracked
        ? l10n.breakFortuneCookieTapStatus
        : _fortuneRevealQueued
            ? l10n.breakFortuneCookieRevealStatus
            : l10n.breakFortuneCookieScratchStatus;

    return Column(
      key: const Key('break_activity_fortune_cookie'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          status,
          key: const Key('fortune_cookie_status'),
          style: TextStyle(
            height: 1.35,
            color: definition.color.withValues(alpha: 0.92),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxHeight < 430 || constraints.maxWidth < 360;
              final noteWidth = min(
                constraints.maxWidth - (compact ? 28 : 16),
                compact ? 284.0 : 304.0,
              );
              final noteHeight = min(
                constraints.maxHeight * (compact ? 0.44 : 0.48),
                compact ? 176.0 : 188.0,
              );
              final cookieSize = min(
                constraints.maxWidth * (compact ? 0.56 : 0.52),
                compact ? 174.0 : 186.0,
              );
              final contentWidth = min(
                constraints.maxWidth - 24,
                max(noteWidth, cookieSize * 1.4) + 12,
              );
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFF3E1),
                      Color(0xFFFFE6C5),
                    ],
                  ),
                  border: Border.all(
                    color: definition.color.withValues(alpha: 0.18),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 16,
                      left: 20,
                      child: _buildFortuneBlob(
                        size: 48,
                        color: const Color(0xFFFFD7A8),
                      ),
                    ),
                    Positioned(
                      right: 26,
                      top: 28,
                      child: _buildFortuneBlob(
                        size: 28,
                        color: const Color(0xFFFFF1D4),
                      ),
                    ),
                    Positioned(
                      left: 26,
                      bottom: 26,
                      child: _buildFortuneBlob(
                        size: 34,
                        color: const Color(0xFFFFE3BF),
                      ),
                    ),
                    Positioned(
                      right: 18,
                      bottom: 24,
                      child: _buildFortuneBlob(
                        size: 54,
                        color: const Color(0xFFFFD9AF),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: AnimatedBuilder(
                          animation: _fortuneCrackController,
                          builder: (context, _) {
                            final crackValue = Curves.easeOutBack.transform(
                              _fortuneCrackController.value,
                            );
                            final cookieOpacity = (1 -
                                    Curves.easeIn.transform(
                                      _fortuneCrackController.value,
                                    ))
                                .clamp(0.0, 1.0)
                                .toDouble();
                            final noteOpacity = _fortuneCookieCracked
                                ? (0.18 +
                                        (_fortuneCrackController.value * 0.82))
                                    .clamp(0.0, 1.0)
                                    .toDouble()
                                : 0.0;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.translate(
                                  offset: Offset(0, cookieSize * 0.22),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 220),
                                    opacity: noteOpacity,
                                    child: _buildFortuneNoteCard(
                                      definition,
                                      l10n,
                                      noteWidth: noteWidth,
                                      noteHeight: noteHeight,
                                    ),
                                  ),
                                ),
                                if (_fortuneRevealQueued)
                                  Positioned(
                                    top:
                                        max(18, (constraints.maxHeight * 0.08)),
                                    child: const AnimatedScale(
                                      duration: Duration(milliseconds: 260),
                                      scale: 1.0,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Color(0xFFFFC857),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Color(0xFFFFE08C),
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.auto_awesome_rounded,
                                            color: Color(0xFFFFC857),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                IgnorePointer(
                                  ignoring: _fortuneCookieCracked ||
                                      _fortuneCrackController.isAnimating,
                                  child: GestureDetector(
                                    key: const Key('fortune_cookie_shell'),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _onFortuneCookieTap,
                                    child: SizedBox(
                                      width: cookieSize * 1.4,
                                      height: cookieSize * 1.25,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if (!_fortuneCookieCracked &&
                                              _fortuneCrackController.value ==
                                                  0)
                                            _buildFortuneCookieDisc(
                                              cookieSize,
                                              crackVisible: false,
                                            )
                                          else
                                            Opacity(
                                              opacity: cookieOpacity,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(
                                                      -cookieSize *
                                                          0.26 *
                                                          crackValue,
                                                      -cookieSize *
                                                          0.10 *
                                                          crackValue,
                                                    ),
                                                    child: Transform.rotate(
                                                      angle: -0.24 * crackValue,
                                                      child: ClipRect(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          widthFactor: 0.5,
                                                          child:
                                                              _buildFortuneCookieDisc(
                                                            cookieSize,
                                                            crackVisible: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(
                                                      cookieSize *
                                                          0.26 *
                                                          crackValue,
                                                      cookieSize *
                                                          0.10 *
                                                          crackValue,
                                                    ),
                                                    child: Transform.rotate(
                                                      angle: 0.24 * crackValue,
                                                      child: ClipRect(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          widthFactor: 0.5,
                                                          child:
                                                              _buildFortuneCookieDisc(
                                                            cookieSize,
                                                            crackVisible: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (!_fortuneCookieCracked)
                                            Positioned(
                                              bottom: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.white.withValues(
                                                    alpha: 0.84,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          999),
                                                ),
                                                child: Text(
                                                  l10n.breakFortuneCookieTapHint,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: definition.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_fortuneRevealQueued && !widget.previewMode) ...[
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.center,
            child: FilledButton.icon(
              key: const Key('fortune_cookie_continue'),
              onPressed: _completeFortuneCookie,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.breakNext),
              style: FilledButton.styleFrom(
                backgroundColor: definition.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: _fortuneCookieCracked ? 1 : 0.45,
          child: LinearProgressIndicator(
            value: _fortuneCookieCracked ? revealProgress : 0,
            minHeight: 10,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: definition.color.withValues(alpha: 0.14),
            color: definition.color,
          ),
        ),
      ],
    );
  }

  Widget _buildFortuneNoteCard(
    BreakActivityDefinition definition,
    AppLocalizations l10n, {
    required double noteWidth,
    required double noteHeight,
  }) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 240),
      scale: _fortuneRevealQueued ? 1.04 : 1.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 240),
        opacity: _fortuneCookieCracked ? 1 : 0,
        child: Container(
          width: noteWidth,
          height: noteHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFCF5),
                Color(0xFFFFF0D8),
              ],
            ),
            border: Border.all(
              color: definition.color.withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final noteSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  key: const Key('fortune_cookie_note'),
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) =>
                      _revealFortuneAt(details.localPosition, noteSize),
                  onPanUpdate: (details) =>
                      _revealFortuneAt(details.localPosition, noteSize),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: definition.color.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (constraints.maxHeight >= 72) ...[
                                Text(
                                  l10n.breakFortuneCookieFortuneLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                    color: definition.color.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      child: Text(
                                        _fortuneWisdom ?? '',
                                        key: const Key(
                                          'fortune_cookie_wisdom_text',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          height: 1.28,
                                          fontWeight: _fortuneRevealQueued
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          color: const Color(0xFF6E4A2B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 260),
                            opacity: _fortuneRevealQueued ? 0 : 1,
                            child: CustomPaint(
                              key: const Key('fortune_cookie_scratch_layer'),
                              painter: _FortuneCookieCrumbPainter(
                                rows: _fortuneScratchRows,
                                columns: _fortuneScratchColumns,
                                revealedCells: _fortuneRevealedCells,
                                scratchPoints: _fortuneScratchPoints,
                                accentColor: definition.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneCookieDisc(
    double size, {
    required bool crackVisible,
  }) {
    return SizedBox(
      width: size * 1.08,
      height: size * 0.82,
      child: CustomPaint(
        painter: _FortuneCookiePainter(
          crackVisible: crackVisible,
        ),
      ),
    );
  }

  Widget _buildFortuneBlob({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPairCardFace(
    BuildContext context,
    BreakActivityDefinition definition, {
    required bool visible,
    required bool matched,
    required bool hinted,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: visible
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  definition.color.withValues(alpha: 0.24),
                  definition.color.withValues(alpha: 0.12),
                ],
              )
            : null,
        color: visible ? null : colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: visible
              ? definition.color.withValues(
                  alpha: matched ? 0.8 : 0.45,
                )
              : hinted
                  ? definition.color.withValues(alpha: 0.72)
                  : colorScheme.outlineVariant.withValues(alpha: 0.7),
          width: hinted ? 2.1 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: hinted
                ? definition.color.withValues(alpha: 0.16)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: hinted ? 10 : 6,
            offset: Offset(0, hinted ? 5 : 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color:
                visible ? null : colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }

  Widget _buildPairCardTile(
    BuildContext context,
    BreakActivityDefinition definition,
    int index, {
    required bool visible,
    required bool matched,
    required bool hinted,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: visible ? 1 : 0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      builder: (context, progress, _) {
        final angle = pi * progress;
        final showFront = angle >= (pi / 2);
        final displayAngle = showFront ? angle - pi : angle;
        final face = showFront
            ? _buildPairCardFace(
                context,
                definition,
                visible: true,
                matched: matched,
                hinted: false,
                label: _pairMatchEmojis[_pairDeck[index]],
              )
            : _buildPairCardFace(
                context,
                definition,
                visible: false,
                matched: false,
                hinted: hinted,
                label: '?',
              );

        return Transform(
          key: Key('pair_card_flip_$index'),
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(displayAngle),
          child: face,
        );
      },
    );
  }

  Widget _buildPairGrid(BreakActivityDefinition definition) {
    const columns = 4;
    const rows = 5;
    final hintIndices = _pairHintIndices();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxHeight < 360 || constraints.maxWidth < 320;
        final spacing = compact ? 6.0 : 10.0;
        final tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        final tileHeight =
            (constraints.maxHeight - (spacing * (rows - 1))) / rows;
        final aspectRatio =
            tileHeight <= 0 ? 1.0 : (tileWidth / tileHeight).clamp(0.72, 1.4);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pairDeck.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final visible =
                _revealedCards.contains(index) || _matchedCards.contains(index);
            final matched = _matchedCards.contains(index);
            final hinted = hintIndices.contains(index) && !visible;
            return InkWell(
              key: Key('pair_card_$index'),
              borderRadius: BorderRadius.circular(18),
              onTap: () => _onPairCardTap(index),
              child: _buildPairCardTile(
                context,
                definition,
                index,
                visible: visible,
                matched: matched,
                hinted: hinted,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCubeScene(
    BreakActivityDefinition definition,
    _CubeSliceMove? hintMove, {
    required bool showArrowHints,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sceneSize = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          key: const Key('cube_scene'),
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) =>
              _onCubeDragStart(details.localPosition, sceneSize),
          onHorizontalDragUpdate: (details) =>
              _onCubeDragUpdate(details.localPosition),
          onHorizontalDragCancel: _resetCubeDrag,
          onHorizontalDragEnd: (_) => _onCubeDragEnd(sceneSize),
          onVerticalDragStart: (details) =>
              _onCubeDragStart(details.localPosition, sceneSize),
          onVerticalDragUpdate: (details) =>
              _onCubeDragUpdate(details.localPosition),
          onVerticalDragCancel: _resetCubeDrag,
          onVerticalDragEnd: (_) => _onCubeDragEnd(sceneSize),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _cubeMoveController,
              _cubeHintPulseController,
            ]),
            builder: (context, _) {
              return CustomPaint(
                size: sceneSize,
                painter: _CubePainter(
                  faceColors: _cubeFaceColors,
                  stickers: _cubeStickers,
                  yaw: _cubeYaw,
                  pitch: _cubePitch,
                  accentColor: definition.color,
                  hintColor: _cubeHintColor,
                  activeFace: _cubeActiveFace,
                  animatedMove: _cubeAnimatingMove,
                  animatedProgress: _cubeMoveController.value,
                  hintMove: hintMove,
                  hintPulse: _cubeHintPulseController.value,
                  showArrowHints: showArrowHints,
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('en'));
    final definition = BreakHelper.definitionFor(widget.activityType, l10n);
    final colorScheme = Theme.of(context).colorScheme;
    return PopScope<BreakSessionResult>(
      canPop: widget.previewMode ? true : _finished,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && !widget.previewMode) {
          await _handleExitRequest();
        }
      },
      child: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.92,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.surfaceContainerLow,
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            definition.color.withValues(alpha: 0.15),
                        child: Icon(definition.icon, color: definition.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.previewMode
                                  ? definition.title
                                  : l10n.breakSheetTitle(
                                      widget.todo.todoText ??
                                          l10n.breakThisItem,
                                    ),
                              key: const Key('break_sheet_title'),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              definition.subtitle,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        key: const Key('break_sheet_close'),
                        onPressed: widget.previewMode
                            ? () => Navigator.pop(context)
                            : _handleExitRequest,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (!widget.previewMode) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: definition.color.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_outlined, color: definition.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: widget.duration.inSeconds == 0
                                  ? 1
                                  : 1 -
                                      (_secondsRemaining /
                                          widget.duration.inSeconds),
                              backgroundColor:
                                  definition.color.withValues(alpha: 0.14),
                              color: definition.color,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatCountdown(),
                            key: const Key('break_timer'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: definition.color,
                            ),
                          ),
                          if (!_showOutcome) ...[
                            const SizedBox(width: 6),
                            IconButton(
                              key: const Key('break_pause_toggle'),
                              onPressed: _togglePause,
                              icon: Icon(
                                _isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: definition.color,
                              ),
                              tooltip: _isPaused
                                  ? l10n.breakResume
                                  : l10n.breakPause,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  Expanded(
                    child: Stack(
                      children: [
                        _buildStageShell(
                          context,
                          definition,
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _showOutcome
                                ? _buildOutcomeView(definition, l10n)
                                : _buildActivityView(definition, l10n),
                          ),
                        ),
                        IgnorePointer(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConfettiWidget(
                              confettiController: _confettiController,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
                              emissionFrequency: 0.08,
                              numberOfParticles: 22,
                              gravity: 0.18,
                              shouldLoop: false,
                              colors: const [
                                Color(0xFF2A9D8F),
                                Color(0xFFE9C46A),
                                Color(0xFFF4A261),
                                Color(0xFFE76F51),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.previewMode) ...[
                    const SizedBox(height: 16),
                    _buildPreviewControls(l10n),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityView(
    BreakActivityDefinition definition,
    AppLocalizations l10n,
  ) {
    final canUseHintHelpers = _hasBreakCustomizationAccess;
    switch (widget.activityType) {
      case BreakActivityType.defuse:
        final progress = _defuseTargetTapCount == 0
            ? 0.0
            : _defuseCount / _defuseTargetTapCount;
        final crackColor = Color.lerp(
              _defusePalette.first,
              _defusePalette.last,
              progress,
            ) ??
            definition.color;
        final personalBestText = _personalBestText(l10n);
        return Column(
          key: const Key('break_activity_defuse'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.breakDefuseInstruction,
              style: const TextStyle(height: 1.35),
            ),
            const SizedBox(height: 16),
            Row(
              children: List<Widget>.generate(_defuseTargetTapCount, (index) {
                final locked = index < _defuseCount;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _defuseTargetTapCount - 1 ? 0 : 8,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: locked
                            ? crackColor
                            : crackColor.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 420;
                  final dialSize = min(
                    constraints.maxWidth * 0.62,
                    max(64.0, constraints.maxHeight - 68),
                  );
                  final coreSize = dialSize * 0.32;
                  final labelFontSize = compact ? 20.0 : 18.0;
                  final ringColors = _defuseRingColors();

                  return GestureDetector(
                    key: const Key('defuse_safe_crack'),
                    behavior: HitTestBehavior.opaque,
                    onTap: _onDefuseTap,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _defuseDialController,
                        builder: (context, _) {
                          final activeStep = _defuseCount.clamp(
                            0,
                            _defuseTargetTapCount - 1,
                          );
                          return SizedBox(
                            width: dialSize,
                            height: dialSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size.square(dialSize),
                                  painter: _SafeCrackDialPainter(
                                    color: crackColor,
                                    ringColors: ringColors,
                                    targetTurns: _defuseTargets,
                                    needleTurn: _defuseDialController.value,
                                    successWindows: List<double>.generate(
                                      _defuseTargetTapCount,
                                      _defuseWindowForStep,
                                    ),
                                    activeStep: activeStep,
                                    unlockedCount: _defuseCount,
                                  ),
                                ),
                                Container(
                                  width: coreSize,
                                  height: coreSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        crackColor.withValues(alpha: 0.18),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: crackColor.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '☝️',
                                          style: TextStyle(
                                            fontSize: labelFontSize,
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 52,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _defuseCount >= _defuseTargetTapCount
                      ? l10n.breakDefuseCompleteStatus
                      : _defuseLastAttemptAccurate
                          ? l10n.breakDefuseRingsLeft(
                              _defuseTargetTapCount - _defuseCount,
                            )
                          : l10n.breakDefuseWaitStatus,
                  style: TextStyle(color: crackColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(999),
              color: crackColor,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: personalBestText == null
                      ? const SizedBox.shrink()
                      : Text(
                          personalBestText,
                          key: const Key('break_personal_best'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: crackColor.withValues(alpha: 0.8),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  key: const Key('defuse_hint_toggle'),
                  onPressed: _toggleDefuseHints,
                  style: TextButton.styleFrom(
                    foregroundColor: crackColor,
                    backgroundColor: crackColor.withValues(
                      alpha: !canUseHintHelpers
                          ? 0.05
                          : (_defuseHintsEnabled ? 0.14 : 0.07),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(
                        color: crackColor.withValues(
                          alpha: !canUseHintHelpers
                              ? 0.12
                              : (_defuseHintsEnabled ? 0.26 : 0.16),
                        ),
                      ),
                    ),
                  ),
                  icon: Icon(
                    !canUseHintHelpers
                        ? Icons.lock_outline_rounded
                        : _defuseHintsEnabled
                            ? Icons.lightbulb_rounded
                            : Icons.lightbulb_outline_rounded,
                    size: 18,
                  ),
                  label: Text(!canUseHintHelpers
                      ? l10n.breakHintsLocked
                      : (_defuseHintsEnabled
                          ? l10n.breakHintsOn
                          : l10n.breakHintsOff)),
                ),
              ],
            ),
          ],
        );
      case BreakActivityType.pairMatch:
        final personalBestText = _personalBestText(l10n);
        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 430;
            return Column(
              key: const Key('break_activity_pairs'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.breakPairMatchInstruction,
                  style: TextStyle(
                    height: compact ? 1.12 : 1.32,
                    fontSize: compact ? 13.0 : null,
                  ),
                ),
                SizedBox(height: compact ? 6 : 18),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(compact ? 4 : 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: definition.color.withValues(alpha: 0.12),
                      ),
                    ),
                    child: _buildPairGrid(definition),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.breakPairMatchProgress(
                              _matchedCards.length ~/ 2,
                              _pairMatchEmojis.length,
                            ),
                          ),
                          if (personalBestText != null)
                            Text(
                              personalBestText,
                              key: const Key('break_personal_best'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: definition.color.withValues(alpha: 0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      key: const Key('pair_hint_toggle'),
                      onPressed: _togglePairHints,
                      style: TextButton.styleFrom(
                        foregroundColor: definition.color,
                        backgroundColor: definition.color.withValues(
                          alpha: !canUseHintHelpers
                              ? 0.05
                              : (_pairHintsEnabled ? 0.14 : 0.07),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 10 : 12,
                          vertical: compact ? 6 : 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: definition.color.withValues(
                              alpha: !canUseHintHelpers
                                  ? 0.12
                                  : (_pairHintsEnabled ? 0.26 : 0.16),
                            ),
                          ),
                        ),
                        visualDensity: compact
                            ? const VisualDensity(
                                horizontal: -2,
                                vertical: -2,
                              )
                            : VisualDensity.standard,
                        tapTargetSize: compact
                            ? MaterialTapTargetSize.shrinkWrap
                            : MaterialTapTargetSize.padded,
                      ),
                      icon: Icon(
                        !canUseHintHelpers
                            ? Icons.lock_outline_rounded
                            : _pairHintsEnabled
                                ? Icons.lightbulb_rounded
                                : Icons.lightbulb_outline_rounded,
                        size: 18,
                      ),
                      label: Text(!canUseHintHelpers
                          ? l10n.breakHintsLocked
                          : (_pairHintsEnabled
                              ? l10n.breakHintsOn
                              : l10n.breakHintsOff)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      case BreakActivityType.cubeReset:
        final hintMove = _cubeHintMove();
        final showArrowHints = _cubeHintMode == _CubeHintMode.strong;
        final personalBestText = _personalBestText(l10n);
        return Column(
          key: const Key('break_activity_cube'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.breakCubeResetInstruction,
              style: TextStyle(
                height: 1.35,
                color: definition.color.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      definition.color.withValues(alpha: 0.10),
                      definition.color.withValues(alpha: 0.03),
                    ],
                  ),
                  border: Border.all(
                    color: definition.color.withValues(alpha: 0.14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildCubeScene(
                    definition,
                    hintMove,
                    showArrowHints: showArrowHints,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.breakCubeResetProgress(
                          _cubeSolvedFaceCount(),
                          6,
                          _cubeMoveCount,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: definition.color,
                        ),
                      ),
                      if (personalBestText != null)
                        Text(
                          personalBestText,
                          key: const Key('break_personal_best'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: definition.color.withValues(alpha: 0.8),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  key: const Key('cube_hint_toggle'),
                  onPressed: _toggleCubeHints,
                  style: TextButton.styleFrom(
                    foregroundColor: definition.color,
                    backgroundColor: definition.color.withValues(
                      alpha: !canUseHintHelpers
                          ? 0.05
                          : (_cubeHintMode == _CubeHintMode.off ? 0.07 : 0.14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(
                        color: definition.color.withValues(
                          alpha: !canUseHintHelpers
                              ? 0.12
                              : (_cubeHintMode == _CubeHintMode.off
                                  ? 0.16
                                  : 0.26),
                        ),
                      ),
                    ),
                  ),
                  icon: Icon(
                    !canUseHintHelpers
                        ? Icons.lock_outline_rounded
                        : _cubeHintMode == _CubeHintMode.off
                            ? Icons.lightbulb_outline_rounded
                            : Icons.lightbulb_rounded,
                    size: 18,
                  ),
                  label: Text(!canUseHintHelpers
                      ? l10n.breakHintsLocked
                      : switch (_cubeHintMode) {
                          _CubeHintMode.off => l10n.breakHintsOff,
                          _CubeHintMode.subtle => l10n.breakHintsSubtle,
                          _CubeHintMode.strong => l10n.breakHintsStrong,
                        }),
                ),
              ],
            ),
          ],
        );
      case BreakActivityType.stackSweep:
        final personalBestText = _personalBestText(l10n);
        return Column(
          key: const Key('break_activity_stack'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                key: const Key('stack_sweep_board'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: definition.color.withValues(alpha: 0.12),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    final renderedTiles =
                        List<_StackSweepTile>.from(_stackTiles)
                          ..sort((a, b) {
                            if (a.slot.layer != b.slot.layer) {
                              return a.slot.layer.compareTo(b.slot.layer);
                            }
                            if (a.slot.row != b.slot.row) {
                              return a.slot.row.compareTo(b.slot.row);
                            }
                            return a.slot.stackOrder
                                .compareTo(b.slot.stackOrder);
                          });

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  definition.color.withValues(alpha: 0.10),
                                  definition.color.withValues(alpha: 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ...renderedTiles.map((tile) {
                          final rect = _stackTileRectFor(tile, size);
                          final removable = _isStackTileRemovable(tile, size);
                          final showBlockedHint =
                              _stackHintsEnabled && !removable;
                          final emphasizeAsAvailable =
                              removable || !_stackHintsEnabled;
                          final removing =
                              _removingStackTileIds.contains(tile.id);
                          final removed =
                              _removedStackTileIds.contains(tile.id);

                          return Positioned(
                            left: rect.left,
                            top: rect.top,
                            child: IgnorePointer(
                              ignoring: removed || removing,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 220),
                                opacity: removed ? 0 : 1,
                                child: AnimatedSlide(
                                  duration: const Duration(milliseconds: 220),
                                  offset: removing
                                      ? const Offset(0, -0.18)
                                      : Offset.zero,
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 220),
                                    scale: removing ? 0.82 : 1,
                                    child: Transform.rotate(
                                      angle: tile.slot.rotation,
                                      child: GestureDetector(
                                        key: Key('stack_tile_${tile.id}'),
                                        onTap: () =>
                                            _onStackTileTap(tile, size),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 180),
                                          width: rect.width,
                                          height: rect.height,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: emphasizeAsAvailable
                                                  ? const [
                                                      Color(0xFFFFFBF1),
                                                      Color(0xFFF4E8D3),
                                                    ]
                                                  : showBlockedHint
                                                      ? [
                                                          const Color(
                                                            0xFFFFFBF1,
                                                          ).withValues(
                                                              alpha: 0.9),
                                                          const Color(
                                                            0xFFF4E8D3,
                                                          ).withValues(
                                                              alpha: 0.76),
                                                        ]
                                                      : const [
                                                          Color(0xFFFFFBF1),
                                                          Color(0xFFF4E8D3),
                                                        ],
                                            ),
                                            border: Border.all(
                                              color: emphasizeAsAvailable
                                                  ? definition.color
                                                  : showBlockedHint
                                                      ? definition.color
                                                          .withValues(
                                                          alpha: 0.22,
                                                        )
                                                      : const Color(
                                                          0xFFDCCCB5,
                                                        ).withValues(
                                                          alpha: 0.72,
                                                        ),
                                              width: emphasizeAsAvailable
                                                  ? 1.8
                                                  : showBlockedHint
                                                      ? 1
                                                      : 0.85,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: emphasizeAsAvailable
                                                      ? 0.14
                                                      : 0.07,
                                                ),
                                                blurRadius: removable ? 18 : 10,
                                                offset: Offset(
                                                  0,
                                                  emphasizeAsAvailable ? 10 : 5,
                                                ),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withValues(
                                                        alpha:
                                                            emphasizeAsAvailable
                                                                ? 0.35
                                                                : showBlockedHint
                                                                    ? 0.30
                                                                    : 0.16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  tile.symbol,
                                                  style: TextStyle(
                                                    fontSize:
                                                        emphasizeAsAvailable
                                                            ? 19
                                                            : 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.88),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                l10n.breakStackSweepTilesLeft(
                                  _stackTiles.length -
                                      _removedStackTileIds.length,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: definition.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: personalBestText == null
                      ? const SizedBox.shrink()
                      : Text(
                          personalBestText,
                          key: const Key('break_personal_best'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: definition.color.withValues(alpha: 0.8),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  key: const Key('stack_hint_toggle'),
                  onPressed: _toggleStackHints,
                  style: TextButton.styleFrom(
                    foregroundColor: definition.color,
                    backgroundColor: definition.color.withValues(
                      alpha: !canUseHintHelpers
                          ? 0.05
                          : (_stackHintsEnabled ? 0.14 : 0.07),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(
                        color: definition.color.withValues(
                          alpha: !canUseHintHelpers
                              ? 0.12
                              : (_stackHintsEnabled ? 0.26 : 0.16),
                        ),
                      ),
                    ),
                  ),
                  icon: Icon(
                    !canUseHintHelpers
                        ? Icons.lock_outline_rounded
                        : _stackHintsEnabled
                            ? Icons.lightbulb_rounded
                            : Icons.lightbulb_outline_rounded,
                    size: 18,
                  ),
                  label: Text(!canUseHintHelpers
                      ? l10n.breakHintsLocked
                      : (_stackHintsEnabled
                          ? l10n.breakHintsOn
                          : l10n.breakHintsOff)),
                ),
              ],
            ),
          ],
        );
      case BreakActivityType.triviaPivot:
        final promptIndex = _triviaOrder[_triviaIndex];
        final prompt = _triviaPrompts[promptIndex];
        final visibleOptionIndices = _visibleTriviaOptionIndices(
          prompt,
          promptIndex,
        );
        final personalBestText = _personalBestText(l10n);
        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 430;
            final insightText = _triviaSelectedAnswer == null
                ? null
                : (_triviaSelectedAnswer == prompt.answerIndex
                    ? l10n.breakTriviaCorrectInsight(prompt.insight)
                    : l10n.breakTriviaIncorrectInsight(prompt.insight));
            return Column(
              key: const Key('break_activity_trivia'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prompt.question,
                        style: TextStyle(
                          fontSize: compact ? 18 : 21,
                          fontWeight: FontWeight.bold,
                          height: 1.18,
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final i in visibleOptionIndices)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: compact ? 8 : 10,
                                  ),
                                  child: OutlinedButton(
                                    key: Key('trivia_option_$i'),
                                    onPressed: _triviaSelectedAnswer == null
                                        ? () => _onTriviaAnswer(i)
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: compact ? 12 : 14,
                                      ),
                                      backgroundColor: _triviaOptionColors[
                                              i % _triviaOptionColors.length]
                                          .withValues(
                                        alpha: _triviaSelectedAnswer == i
                                            ? 0.24
                                            : 0.12,
                                      ),
                                      side: BorderSide(
                                        color: _triviaSelectedAnswer == i
                                            ? _triviaOptionColors[
                                                i % _triviaOptionColors.length]
                                            : _triviaOptionColors[i %
                                                    _triviaOptionColors.length]
                                                .withValues(alpha: 0.6),
                                        width: _triviaSelectedAnswer == i
                                            ? 2
                                            : 1.2,
                                      ),
                                      foregroundColor: _triviaOptionColors[
                                          i % _triviaOptionColors.length],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        prompt.options[i],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (insightText != null) ...[
                        SizedBox(height: compact ? 8 : 10),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(compact ? 10 : 12),
                          decoration: BoxDecoration(
                            color: definition.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: definition.color.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Text(
                            insightText,
                            style: TextStyle(
                              height: 1.32,
                              fontSize: compact ? 14 : null,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (personalBestText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          personalBestText,
                          key: const Key('break_personal_best'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: definition.color.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_triviaSelectedAnswer != null)
                          FilledButton.icon(
                            key: const Key('trivia_next'),
                            onPressed: _nextTrivia,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: Text(l10n.breakNext),
                          ),
                        TextButton.icon(
                          key: const Key('trivia_hint_toggle'),
                          onPressed: () =>
                              _toggleTriviaHints(prompt, promptIndex),
                          style: TextButton.styleFrom(
                            foregroundColor: definition.color,
                            backgroundColor: definition.color.withValues(
                              alpha: !canUseHintHelpers
                                  ? 0.05
                                  : (_triviaHintsEnabled ? 0.14 : 0.07),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                              side: BorderSide(
                                color: definition.color.withValues(
                                  alpha: !canUseHintHelpers
                                      ? 0.12
                                      : (_triviaHintsEnabled ? 0.26 : 0.16),
                                ),
                              ),
                            ),
                          ),
                          icon: Icon(
                            !canUseHintHelpers
                                ? Icons.lock_outline_rounded
                                : _triviaHintsEnabled
                                    ? Icons.lightbulb_rounded
                                    : Icons.lightbulb_outline_rounded,
                            size: 18,
                          ),
                          label: Text(!canUseHintHelpers
                              ? l10n.breakHintsLocked
                              : (_triviaHintsEnabled
                                  ? l10n.breakHintsOn
                                  : l10n.breakHintsOff)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      case BreakActivityType.fortuneCookie:
        return _buildFortuneCookieActivity(definition, l10n);
      case BreakActivityType.zenRoom:
        return Column(
          key: const Key('break_activity_zen'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size =
                      Size(constraints.maxWidth, constraints.maxHeight);
                  final rainRegion = _zenRainRegion(size);
                  return AnimatedBuilder(
                    animation: _ambientController,
                    builder: (context, _) {
                      final zenColors = _animatedZenColors();
                      final dropCenters = List<Offset>.generate(
                        _zenDropSizes.length,
                        (index) => _zenDropCenterAt(index, rainRegion.size),
                      );
                      return GestureDetector(
                        key: const Key('zen_room_rain_area'),
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) =>
                            _onZenTapDown(details, rainRegion),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: zenColors,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fromRect(
                                rect: rainRegion,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: SizedBox(
                                    key: const Key('zen_rain_region'),
                                    width: rainRegion.width,
                                    height: rainRegion.height,
                                    child: CustomPaint(
                                      key: const Key('zen_rain_paint'),
                                      painter: _ZenRainPainter(
                                        centers: dropCenters,
                                        sizes: _zenDropSizes,
                                        caughtProgress: List<double>.generate(
                                          _zenDropSizes.length,
                                          _zenCatchProgressFor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.water_drop_outlined,
                                        size: 16,
                                        color: Color(0xFF205072),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.breakZenTapDrop,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF205072),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: min(size.width - 56, 224),
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.84),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.08),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _zenFortune ?? '',
                                      key: ValueKey(_zenFortune),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        height: 1.42,
                                        color: Color(0xFF385170),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.breakZenFooter,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.64),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildOutcomeView(
    BreakActivityDefinition definition,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      key: const Key('break_outcome_view'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.breakCheckInTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.breakOutcomeQuestion,
            style: const TextStyle(height: 1.35),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: Key(
                _activityCompleted
                    ? 'break_replay_activity'
                    : 'break_continue_playing',
              ),
              onPressed: _activityCompleted
                  ? _resetCurrentActivity
                  : _continueCurrentActivity,
              icon: const Icon(Icons.autorenew_rounded),
              label: Text(
                _activityCompleted
                    ? l10n.breakReplayActivity
                    : l10n.breakContinueActivity,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildOutcomeButton(
            key: const Key('break_outcome_passed'),
            label: l10n.breakOutcomePassed,
            color: const Color(0xFF2A9D8F),
            onTap: () => _complete(BreakOutcome.passed),
          ),
          const SizedBox(height: 10),
          _buildOutcomeButton(
            key: const Key('break_outcome_weaker'),
            label: l10n.breakOutcomeWeaker,
            color: definition.color,
            onTap: () => _complete(BreakOutcome.weaker),
          ),
          const SizedBox(height: 10),
          _buildOutcomeButton(
            key: const Key('break_outcome_strong'),
            label: l10n.breakOutcomeStillStrong,
            color: const Color(0xFFD62828),
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _showStillStrongOptions = true);
            },
          ),
          const SizedBox(height: 14),
          if (_showStillStrongOptions)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.breakNeedAnotherLayer,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        key: const Key('break_followup_retry'),
                        avatar: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(l10n.breakTryAnotherBreak),
                        onPressed: () => _complete(
                          BreakOutcome.stillStrong,
                          followUpAction: BreakFollowUpAction.retry,
                        ),
                      ),
                      ActionChip(
                        key: const Key('break_followup_zen'),
                        avatar: const Icon(Icons.spa_outlined, size: 18),
                        label: Text(l10n.breakGoToZenRoom),
                        onPressed: () => _complete(
                          BreakOutcome.stillStrong,
                          followUpAction: BreakFollowUpAction.zenRoom,
                        ),
                      ),
                      if (widget.showTrustedSupport)
                        ActionChip(
                          key: const Key('break_followup_support'),
                          avatar: const Icon(Icons.favorite_border, size: 18),
                          label: Text(l10n.breakMessageSupport),
                          onPressed: () => _complete(
                            BreakOutcome.stillStrong,
                            followUpAction: BreakFollowUpAction.trustedSupport,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOutcomeButton({
    required Key key,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: key,
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label),
      ),
    );
  }
}

class _ZenRainPainter extends CustomPainter {
  final List<Offset> centers;
  final List<double> sizes;
  final List<double> caughtProgress;

  const _ZenRainPainter({
    required this.centers,
    required this.sizes,
    required this.caughtProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tailPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    final dropPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    for (var i = 0; i < centers.length; i++) {
      final center = centers[i];
      final radius = sizes[i];
      final catchAmount = caughtProgress[i].clamp(0, 1);
      final opacity = (0.38 * (1 - catchAmount)).clamp(0, 1).toDouble();
      final glowOpacity =
          (0.18 + ((1 - catchAmount) * 0.18)).clamp(0, 1).toDouble();
      final driftUp = catchAmount * 10;
      final animatedCenter = Offset(center.dx, center.dy - driftUp);
      final tailLength = radius * 2.7 * (1 - (catchAmount * 0.72));
      final tailStart =
          Offset(animatedCenter.dx, animatedCenter.dy - tailLength);
      final dropRadius = radius * 0.64 * (1 - (catchAmount * 0.82));
      final glowRadius = radius * (1 + (catchAmount * 0.5));

      tailPaint.color = Colors.white.withValues(alpha: opacity * 0.9);
      dropPaint.color = Colors.white.withValues(alpha: opacity);
      glowPaint.color = const Color(0xFFD6F6FF).withValues(alpha: glowOpacity);

      if (opacity <= 0.001 || dropRadius <= 0.001) {
        continue;
      }

      canvas.drawLine(tailStart, animatedCenter, tailPaint);
      canvas.drawCircle(animatedCenter, glowRadius, glowPaint);
      canvas.drawCircle(animatedCenter, dropRadius, dropPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ZenRainPainter oldDelegate) {
    return oldDelegate.centers != centers ||
        oldDelegate.sizes != sizes ||
        oldDelegate.caughtProgress != caughtProgress;
  }
}

class _SafeCrackDialPainter extends CustomPainter {
  final Color color;
  final List<Color> ringColors;
  final List<double> targetTurns;
  final double needleTurn;
  final List<double> successWindows;
  final int activeStep;
  final int unlockedCount;

  const _SafeCrackDialPainter({
    required this.color,
    required this.ringColors,
    required this.targetTurns,
    required this.needleTurn,
    required this.successWindows,
    required this.activeStep,
    required this.unlockedCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = max(8.0, radius * 0.08);
    final emptyGap = max(8.0, radius * 0.08);
    final innerGap = emptyGap;
    final ringStep = strokeWidth + emptyGap;
    final targetPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final needlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = max(4.0, strokeWidth * 0.7)
      ..color = const Color(0xFF3B2F2F);

    const startOffset = -pi / 2;
    final coreRadius = radius * 0.18;
    final innerRingRadius = coreRadius + innerGap + (strokeWidth / 2);
    final ringRadii = List<double>.generate(
      targetTurns.length,
      (index) =>
          innerRingRadius + ((targetTurns.length - 1 - index) * ringStep),
    );
    final outerRingRadius = ringRadii.first;

    for (var index = 0; index < ringRadii.length; index++) {
      final ringRect =
          Rect.fromCircle(center: center, radius: ringRadii[index]);
      final ringColor = ringColors[index % ringColors.length];

      if (index >= unlockedCount) {
        canvas.drawArc(
          ringRect,
          0,
          pi * 2,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = ringColor.withValues(alpha: 0.17),
        );
      }

      if (index < unlockedCount) {
        continue;
      }

      if (index == activeStep) {
        final windowSweep = successWindows[index] * pi * 4;
        final aligned = min(
              (needleTurn - targetTurns[index]).abs(),
              1 - (needleTurn - targetTurns[index]).abs(),
            ) <=
            successWindows[index];
        targetPaint.color = ringColor.withValues(alpha: aligned ? 0.98 : 0.78);
        canvas.drawArc(
          ringRect,
          startOffset + (targetTurns[index] * pi * 2) - (windowSweep / 2),
          windowSweep,
          false,
          targetPaint,
        );
      }
    }

    final needleAngle = startOffset + (needleTurn * pi * 2);
    final activeRingRadius = ringRadii[activeStep];
    final innerPoint = Offset(
      center.dx + cos(needleAngle) * max(coreRadius + 8, activeRingRadius - 18),
      center.dy + sin(needleAngle) * max(coreRadius + 8, activeRingRadius - 18),
    );
    final outerPoint = Offset(
      center.dx + cos(needleAngle) * (activeRingRadius - (strokeWidth / 2)),
      center.dy + sin(needleAngle) * (activeRingRadius - (strokeWidth / 2)),
    );
    canvas.drawLine(innerPoint, outerPoint, needlePaint);
    canvas.drawCircle(
      outerPoint,
      7,
      Paint()
        ..style = PaintingStyle.fill
        ..color = ringColors[activeStep % ringColors.length],
    );

    for (var tick = 0; tick < 12; tick++) {
      final angle = startOffset + (tick / 12) * pi * 2;
      final tickStart = Offset(
        center.dx + cos(angle) * (outerRingRadius + emptyGap * 0.2),
        center.dy + sin(angle) * (outerRingRadius + emptyGap * 0.2),
      );
      final tickEnd = Offset(
        center.dx + cos(angle) * (outerRingRadius + emptyGap * 0.95),
        center.dy + sin(angle) * (outerRingRadius + emptyGap * 0.95),
      );
      canvas.drawLine(
        tickStart,
        tickEnd,
        Paint()
          ..strokeWidth = 2
          ..color = color.withValues(alpha: 0.28),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SafeCrackDialPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.ringColors != ringColors ||
        oldDelegate.targetTurns != targetTurns ||
        oldDelegate.needleTurn != needleTurn ||
        oldDelegate.successWindows != successWindows ||
        oldDelegate.activeStep != activeStep ||
        oldDelegate.unlockedCount != unlockedCount;
  }
}

class _FortuneCookiePainter extends CustomPainter {
  final bool crackVisible;

  const _FortuneCookiePainter({
    required this.crackVisible,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.48);
    final radius = min(size.width, size.height) * 0.38;
    final outerRect = Rect.fromCircle(center: center, radius: radius);
    final notchRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + (radius * 0.92)),
      width: radius * 1.04,
      height: radius * 0.86,
    );
    final outerPath = Path()..addOval(outerRect);
    final notchPath = Path()..addOval(notchRect);
    final shellPath = Path.combine(
      PathOperation.difference,
      outerPath,
      notchPath,
    );
    final innerArcRect = outerRect.deflate(radius * 0.11);
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE6A75B),
          Color(0xFFC97A3D),
          Color(0xFFB8642B),
        ],
      ).createShader(outerRect);

    canvas.drawShadow(
      shellPath,
      Colors.black.withValues(alpha: 0.24),
      14,
      false,
    );
    canvas.drawPath(shellPath, fillPaint);
    canvas.drawPath(
      shellPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(2.0, size.shortestSide * 0.03)
        ..color = const Color(0xFF9A5728),
    );
    canvas.drawArc(
      innerArcRect,
      pi * 1.03,
      pi * 0.94,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(1.2, size.shortestSide * 0.015)
        ..color = Colors.white.withValues(alpha: 0.24),
    );
    final foldPath = Path()
      ..moveTo(center.dx - (radius * 0.02), center.dy - (radius * 0.76))
      ..quadraticBezierTo(
        center.dx + (radius * 0.05),
        center.dy - (radius * 0.10),
        center.dx - (radius * 0.02),
        center.dy + (radius * 0.84),
      );
    canvas.drawPath(
      foldPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = max(2.0, size.shortestSide * 0.022)
        ..color = const Color(0xFFF4D3A8).withValues(alpha: 0.78),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + (radius * 0.06)),
        width: radius * 1.28,
        height: radius * 0.78,
      ),
      pi * 0.16,
      pi * 0.68,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(2.0, size.shortestSide * 0.02)
        ..color = const Color(0xFF9A5728).withValues(alpha: 0.85),
    );

    final chipPaints = [
      Paint()..color = const Color(0xFF9E5A2B),
      Paint()..color = const Color(0xFFB56A32),
      Paint()..color = const Color(0xFFD88B3A),
    ];
    final chipOffsets = <Offset>[
      Offset(center.dx - (radius * 0.56), center.dy - (radius * 0.70)),
      Offset(center.dx + (radius * 0.56), center.dy - (radius * 0.62)),
      Offset(center.dx - (radius * 0.34), center.dy + (radius * 0.14)),
      Offset(center.dx + (radius * 0.40), center.dy + (radius * 0.28)),
      Offset(center.dx, center.dy + (radius * 0.60)),
    ];
    for (var i = 0; i < chipOffsets.length; i++) {
      canvas.drawCircle(
        chipOffsets[i],
        size.shortestSide * (0.035 + ((i % 3) * 0.006)),
        chipPaints[i % chipPaints.length],
      );
    }

    if (crackVisible) {
      final crackPath = Path()
        ..moveTo(center.dx - 4, center.dy - (radius * 0.72))
        ..lineTo(center.dx + 5, center.dy - (radius * 0.12))
        ..lineTo(center.dx - 7, center.dy + (radius * 0.18))
        ..lineTo(center.dx + 6, center.dy + (radius * 0.70));
      canvas.drawPath(
        crackPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = max(2.4, size.shortestSide * 0.028)
          ..color = const Color(0xFFFDF1D5).withValues(alpha: 0.96),
      );
      canvas.drawPath(
        crackPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = max(1.2, size.shortestSide * 0.014)
          ..color = const Color(0xFF8E4B24),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FortuneCookiePainter oldDelegate) {
    return oldDelegate.crackVisible != crackVisible;
  }
}

class _FortuneCookieCrumbPainter extends CustomPainter {
  final int rows;
  final int columns;
  final Set<int> revealedCells;
  final List<Offset> scratchPoints;
  final Color accentColor;

  const _FortuneCookieCrumbPainter({
    required this.rows,
    required this.columns,
    required this.revealedCells,
    required this.scratchPoints,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final crumbRect = Offset.zero & size;
    final crumbPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFE6B77A),
          const Color(0xFFD99B54),
          accentColor.withValues(alpha: 0.86),
        ],
      ).createShader(crumbRect);
    final speckPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFF1D4).withValues(alpha: 0.40);
    final shinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withValues(alpha: 0.18);
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    final baseRRect = RRect.fromRectAndRadius(
      crumbRect,
      const Radius.circular(20),
    );

    canvas.saveLayer(crumbRect, Paint());
    canvas.drawRRect(baseRRect, crumbPaint);
    canvas.drawRRect(baseRRect.deflate(8), shinePaint);

    for (var i = 0; i < 64; i++) {
      final x = ((i * 37) % 100) / 100;
      final y = ((i * 19) % 100) / 100;
      final radius = size.shortestSide * (0.008 + ((i % 5) * 0.002));
      canvas.drawCircle(
        Offset(size.width * x, size.height * y),
        radius,
        speckPaint,
      );
    }

    final scratchRadius = max(size.width / columns, size.height / rows) * 1.12;
    for (final point in scratchPoints) {
      canvas.drawCircle(point, scratchRadius, clearPaint);
      canvas.drawCircle(
        point.translate(scratchRadius * 0.24, -scratchRadius * 0.12),
        scratchRadius * 0.46,
        clearPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FortuneCookieCrumbPainter oldDelegate) {
    return true;
  }
}

enum _CubeHintMode { off, subtle, strong }

class _CubePainter extends CustomPainter {
  final List<Color> faceColors;
  final List<_CubeStickerState> stickers;
  final double yaw;
  final double pitch;
  final Color accentColor;
  final Color hintColor;
  final _CubeFace? activeFace;
  final _CubeSliceMove? animatedMove;
  final double animatedProgress;
  final _CubeSliceMove? hintMove;
  final double hintPulse;
  final bool showArrowHints;

  const _CubePainter({
    required this.faceColors,
    required this.stickers,
    required this.yaw,
    required this.pitch,
    required this.accentColor,
    required this.hintColor,
    required this.activeFace,
    required this.animatedMove,
    required this.animatedProgress,
    required this.hintMove,
    required this.hintPulse,
    required this.showArrowHints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final projectedFaces = _CubeProjection.buildProjectedFaces(
      size: size,
      yaw: yaw,
      pitch: pitch,
    )..sort((a, b) => a.depth.compareTo(b.depth));
    final projectedStickers = _CubeProjection.buildProjectedStickers(
      stickers: stickers,
      size: size,
      yaw: yaw,
      pitch: pitch,
      animatedMove: animatedMove,
      animatedProgress: Curves.easeInOut.transform(animatedProgress),
    )..sort((a, b) => a.depth.compareTo(b.depth));

    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final cubeBounds = projectedFaces
        .expand((face) => face.points)
        .fold<Rect?>(null, (rect, point) {
      final next = Rect.fromLTWH(point.dx, point.dy, 0, 0);
      return rect == null ? next : rect.expandToInclude(next);
    });

    if (cubeBounds != null) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cubeBounds.center.dx, cubeBounds.bottom + 22),
          width: cubeBounds.width * 0.76,
          height: cubeBounds.height * 0.12,
        ),
        shadowPaint,
      );
    }

    final animated = animatedMove != null;
    for (final face in projectedFaces) {
      final bodyColor = activeFace == face.face
          ? accentColor.withValues(alpha: 0.22)
          : const Color(0xFF1C2634);
      final seamPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeJoin = StrokeJoin.round
        ..color = bodyColor;
      canvas.drawPath(
        face.path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = bodyColor,
      );
      canvas.drawPath(face.path, seamPaint);
      if (!animated) {
        canvas.save();
        canvas.clipPath(face.path);
        for (final sticker in projectedStickers.where(
          (sticker) => sticker.baseFace == face.face,
        )) {
          final hintMatch = hintMove != null &&
              _CubeProjection.coordOnAxis(sticker.position, hintMove!.axis) ==
                  hintMove!.layer;
          final hintStrength = 0.11 + (hintPulse * 0.12);
          final glowStrength = 0.10 + (hintPulse * 0.12);
          canvas.drawPath(
            sticker.tilePath,
            Paint()
              ..style = PaintingStyle.fill
              ..color = hintMatch
                  ? hintColor.withValues(alpha: hintStrength)
                  : const Color(0xFF142033),
          );
          if (hintMatch) {
            canvas.drawPath(
              sticker.tilePath,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 5
                ..strokeJoin = StrokeJoin.round
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
                ..color = hintColor.withValues(alpha: glowStrength),
            );
            canvas.drawPath(
              sticker.tilePath,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.1
                ..strokeJoin = StrokeJoin.round
                ..color = hintColor.withValues(
                  alpha: 0.24 + (hintPulse * 0.14),
                ),
            );
          }
          canvas.drawPath(
            sticker.path,
            Paint()
              ..style = PaintingStyle.fill
              ..color = faceColors[sticker.colorIndex],
          );
          if (hintMatch && showArrowHints) {
            _drawHintArrow(
              canvas,
              sticker: sticker,
              move: hintMove!,
              size: size,
            );
          }
          canvas.drawPath(
            sticker.path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth =
                  sticker.baseFace == activeFace || hintMatch ? 2.1 : 1
              ..color = sticker.baseFace == activeFace
                  ? accentColor.withValues(alpha: 0.7)
                  : hintMatch
                      ? hintColor.withValues(
                          alpha: 0.34 + (hintPulse * 0.12),
                        )
                      : Colors.black.withValues(alpha: 0.15),
          );
        }
      }
      if (!animated) {
        canvas.restore();
      }
      canvas.drawPath(
        face.path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.08),
      );
    }

    if (animated) {
      for (final sticker in projectedStickers) {
        canvas.drawPath(
          sticker.tilePath,
          Paint()
            ..style = PaintingStyle.fill
            ..color = const Color(0xFF142033),
        );
        canvas.drawPath(
          sticker.path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = faceColors[sticker.colorIndex],
        );
        canvas.drawPath(
          sticker.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = sticker.baseFace == activeFace ? 2 : 1
            ..color = sticker.baseFace == activeFace
                ? accentColor.withValues(alpha: 0.7)
                : Colors.black.withValues(alpha: 0.15),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CubePainter oldDelegate) {
    return true;
  }

  void _drawHintArrow(
    Canvas canvas, {
    required _CubeProjectedSticker sticker,
    required _CubeSliceMove move,
    required Size size,
  }) {
    final arrowVector = _hintArrowVector(sticker, move, size);
    if (arrowVector == null || arrowVector.distance < 8) {
      return;
    }

    final direction = arrowVector / arrowVector.distance;
    final center = _stickerCenter(sticker.path.getBounds());
    final shaftLength =
        min(sticker.path.getBounds().width, sticker.path.getBounds().height) *
            0.42;
    final tip = center + (direction * shaftLength * 0.46);
    final tail = center - (direction * shaftLength * 0.34);
    final normal = Offset(-direction.dy, direction.dx);
    final headBase = tip - (direction * 8);
    final leftWing = headBase + (normal * 5);
    final rightWing = headBase - (normal * 5);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 4.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..color = hintColor.withValues(alpha: 0.16 + (hintPulse * 0.10));
    final arrowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.9
      ..color = Colors.white.withValues(alpha: 0.78);

    final arrowPath = Path()
      ..moveTo(tail.dx, tail.dy)
      ..lineTo(tip.dx, tip.dy)
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(rightWing.dx, rightWing.dy);

    canvas.drawPath(arrowPath, glowPaint);
    canvas.drawPath(arrowPath, arrowPaint);
  }

  Offset? _hintArrowVector(
    _CubeProjectedSticker sticker,
    _CubeSliceMove move,
    Size size,
  ) {
    for (final swipeVector in [sticker.u, sticker.v]) {
      final axisVector = sticker.normal.cross(swipeVector);
      final axisInt = _CubeInt3(
        axisVector.x.round(),
        axisVector.y.round(),
        axisVector.z.round(),
      );
      if (axisInt.principalAxis != move.axis) {
        continue;
      }
      final desiredTurn = move.quarterTurns.sign * axisInt.axisSign;
      if (desiredTurn == 0) {
        continue;
      }
      final tangent = axisVector.cross(sticker.center);
      final tangentScreen = _CubeProjection.projectVectorToScreen(
        origin: sticker.center,
        vector: tangent,
        size: size,
        yaw: yaw,
        pitch: pitch,
      );
      if (tangentScreen.distance < 0.001) {
        continue;
      }
      return tangentScreen * desiredTurn.toDouble();
    }
    return null;
  }

  Offset _stickerCenter(Rect rect) => rect.center;
}

class _CubeFaceIndex {
  static const int up = 0;
  static const int right = 1;
  static const int front = 2;
  static const int down = 3;
  static const int left = 4;
  static const int back = 5;
}

enum _CubeAxis { x, y, z }

enum _CubeSwipePrimary { horizontal, vertical }

enum _CubeFace {
  up(_CubeInt3(0, 1, 0)),
  right(_CubeInt3(1, 0, 0)),
  front(_CubeInt3(0, 0, 1)),
  down(_CubeInt3(0, -1, 0)),
  left(_CubeInt3(-1, 0, 0)),
  back(_CubeInt3(0, 0, -1));

  final _CubeInt3 normal;

  const _CubeFace(this.normal);
}

class _CubeInt3 {
  final int x;
  final int y;
  final int z;

  const _CubeInt3(this.x, this.y, this.z);

  _CubeDouble3 toDouble() =>
      _CubeDouble3(x.toDouble(), y.toDouble(), z.toDouble());

  _CubeDouble3 cross(_CubeDouble3 other) {
    return _CubeDouble3(
      (y * other.z) - (z * other.y),
      (z * other.x) - (x * other.z),
      (x * other.y) - (y * other.x),
    );
  }

  _CubeAxis get principalAxis {
    if (x != 0) return _CubeAxis.x;
    if (y != 0) return _CubeAxis.y;
    return _CubeAxis.z;
  }

  int get axisSign {
    if (x != 0) return x.sign;
    if (y != 0) return y.sign;
    return z.sign;
  }

  @override
  bool operator ==(Object other) =>
      other is _CubeInt3 && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

class _CubeDouble3 {
  final double x;
  final double y;
  final double z;

  const _CubeDouble3(this.x, this.y, this.z);

  _CubeDouble3 operator +(_CubeDouble3 other) =>
      _CubeDouble3(x + other.x, y + other.y, z + other.z);

  _CubeDouble3 operator -(_CubeDouble3 other) =>
      _CubeDouble3(x - other.x, y - other.y, z - other.z);

  _CubeDouble3 scale(double factor) =>
      _CubeDouble3(x * factor, y * factor, z * factor);

  _CubeDouble3 cross(_CubeDouble3 other) {
    return _CubeDouble3(
      (y * other.z) - (z * other.y),
      (z * other.x) - (x * other.z),
      (x * other.y) - (y * other.x),
    );
  }
}

class _CubeStickerState {
  _CubeInt3 position;
  _CubeInt3 normal;
  final int colorIndex;

  _CubeStickerState({
    required this.position,
    required this.normal,
    required this.colorIndex,
  });
}

class _CubeSliceMove {
  final _CubeAxis axis;
  final int layer;
  final int quarterTurns;

  const _CubeSliceMove({
    required this.axis,
    required this.layer,
    required this.quarterTurns,
  });

  static const List<_CubeSliceMove> outerFaceMoves = [
    _CubeSliceMove(axis: _CubeAxis.x, layer: 1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.x, layer: 1, quarterTurns: -1),
    _CubeSliceMove(axis: _CubeAxis.x, layer: -1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.x, layer: -1, quarterTurns: -1),
    _CubeSliceMove(axis: _CubeAxis.y, layer: 1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.y, layer: 1, quarterTurns: -1),
    _CubeSliceMove(axis: _CubeAxis.y, layer: -1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.y, layer: -1, quarterTurns: -1),
    _CubeSliceMove(axis: _CubeAxis.z, layer: 1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.z, layer: 1, quarterTurns: -1),
    _CubeSliceMove(axis: _CubeAxis.z, layer: -1, quarterTurns: 1),
    _CubeSliceMove(axis: _CubeAxis.z, layer: -1, quarterTurns: -1),
  ];

  bool sameSliceAs(_CubeSliceMove other) {
    return axis == other.axis && layer == other.layer;
  }

  bool isInverseOf(_CubeSliceMove other) {
    return sameSliceAs(other) && quarterTurns == -other.quarterTurns;
  }

  _CubeSliceMove get inverse => _CubeSliceMove(
        axis: axis,
        layer: layer,
        quarterTurns: -quarterTurns,
      );
}

class _CubeProjectedFace {
  final _CubeFace face;
  final List<Offset> points;
  final Path path;
  final double depth;

  const _CubeProjectedFace({
    required this.face,
    required this.points,
    required this.path,
    required this.depth,
  });
}

class _CubeProjectedSticker {
  final _CubeFace baseFace;
  final _CubeInt3 position;
  final _CubeDouble3 normal;
  final _CubeDouble3 center;
  final _CubeDouble3 u;
  final _CubeDouble3 v;
  final int colorIndex;
  final Path tilePath;
  final Path path;
  final double depth;

  const _CubeProjectedSticker({
    required this.baseFace,
    required this.position,
    required this.normal,
    required this.center,
    required this.u,
    required this.v,
    required this.colorIndex,
    required this.tilePath,
    required this.path,
    required this.depth,
  });
}

class _CubeProjection {
  static const double _stickerHalfSize = 0.42;

  static List<_CubeProjectedFace> buildProjectedFaces({
    required Size size,
    required double yaw,
    required double pitch,
  }) {
    final faces = <_CubeProjectedFace>[];
    for (final face in _CubeFace.values) {
      final basis = _basisFor(face);
      final center = face.normal.toDouble().scale(1.5);
      final quad = _quadFrom(center, basis.$1, basis.$2, 1.5);
      final rotatedNormal =
          rotate(face.normal.toDouble(), yaw: yaw, pitch: pitch);
      if (rotatedNormal.z <= 0.02) continue;
      final points =
          quad.map((point) => projectPoint(point, size, yaw, pitch)).toList();
      faces.add(
        _CubeProjectedFace(
          face: face,
          points: points,
          path: _pathFrom(points),
          depth: quad
                  .map((point) => rotate(point, yaw: yaw, pitch: pitch).z)
                  .reduce((a, b) => a + b) /
              quad.length,
        ),
      );
    }
    return faces;
  }

  static List<_CubeProjectedSticker> buildProjectedStickers({
    required List<_CubeStickerState> stickers,
    required Size size,
    required double yaw,
    required double pitch,
    _CubeSliceMove? animatedMove,
    double animatedProgress = 0,
  }) {
    final projected = <_CubeProjectedSticker>[];
    for (final sticker in stickers) {
      final face = _faceForNormal(sticker.normal);
      final basis = _basisFor(face);
      var center =
          sticker.position.toDouble() + sticker.normal.toDouble().scale(0.5);
      var normal = sticker.normal.toDouble();
      var u = basis.$1;
      var v = basis.$2;

      if (animatedMove != null &&
          _coordOnAxis(sticker.position, animatedMove.axis) ==
              animatedMove.layer) {
        final angle = (pi / 2) * animatedMove.quarterTurns * animatedProgress;
        center = rotateAroundAxis(center, animatedMove.axis, angle);
        normal = rotateAroundAxis(normal, animatedMove.axis, angle);
        u = rotateAroundAxis(u, animatedMove.axis, angle);
        v = rotateAroundAxis(v, animatedMove.axis, angle);
      }

      final rotatedNormal = rotate(normal, yaw: yaw, pitch: pitch);
      if (rotatedNormal.z <= 0.02) continue;
      final tileQuad = _quadFrom(center, u, v, 0.50);
      final quad = _quadFrom(center, u, v, _stickerHalfSize);
      final tilePoints = tileQuad
          .map((point) => projectPoint(point, size, yaw, pitch))
          .toList();
      final points =
          quad.map((point) => projectPoint(point, size, yaw, pitch)).toList();
      projected.add(
        _CubeProjectedSticker(
          baseFace: face,
          position: sticker.position,
          normal: normal,
          center: center,
          u: u,
          v: v,
          colorIndex: sticker.colorIndex,
          tilePath: _pathFrom(tilePoints),
          path: _pathFrom(points),
          depth: quad
                  .map((point) => rotate(point, yaw: yaw, pitch: pitch).z)
                  .reduce((a, b) => a + b) /
              quad.length,
        ),
      );
    }
    return projected;
  }

  static _CubeSwipePrimary primarySwipeAxis({
    required _CubeProjectedSticker sticker,
    required Size size,
    required double yaw,
    required double pitch,
    required Offset dragDelta,
  }) {
    final u = projectVectorToScreen(
      origin: sticker.center,
      vector: sticker.u,
      size: size,
      yaw: yaw,
      pitch: pitch,
    );
    final v = projectVectorToScreen(
      origin: sticker.center,
      vector: sticker.v,
      size: size,
      yaw: yaw,
      pitch: pitch,
    );
    final horizontalScore =
        ((dragDelta.dx * u.dx) + (dragDelta.dy * u.dy)).abs() /
            max(0.001, u.distance);
    final verticalScore =
        ((dragDelta.dx * v.dx) + (dragDelta.dy * v.dy)).abs() /
            max(0.001, v.distance);
    return horizontalScore >= verticalScore
        ? _CubeSwipePrimary.horizontal
        : _CubeSwipePrimary.vertical;
  }

  static Offset projectVectorToScreen({
    required _CubeDouble3 origin,
    required _CubeDouble3 vector,
    required Size size,
    required double yaw,
    required double pitch,
  }) {
    final from = projectPoint(origin, size, yaw, pitch);
    final to = projectPoint(origin + vector.scale(0.4), size, yaw, pitch);
    return to - from;
  }

  static _CubeDouble3 rotate(
    _CubeDouble3 point, {
    required double yaw,
    required double pitch,
  }) {
    final cy = cos(yaw);
    final sy = sin(yaw);
    final cp = cos(pitch);
    final sp = sin(pitch);

    final x1 = (point.x * cy) + (point.z * sy);
    final z1 = (-point.x * sy) + (point.z * cy);
    final y2 = (point.y * cp) - (z1 * sp);
    final z2 = (point.y * sp) + (z1 * cp);
    return _CubeDouble3(x1, y2, z2);
  }

  static _CubeDouble3 rotateAroundAxis(
    _CubeDouble3 point,
    _CubeAxis axis,
    double angle,
  ) {
    final c = cos(angle);
    final s = sin(angle);
    switch (axis) {
      case _CubeAxis.x:
        return _CubeDouble3(
          point.x,
          (point.y * c) - (point.z * s),
          (point.y * s) + (point.z * c),
        );
      case _CubeAxis.y:
        return _CubeDouble3(
          (point.x * c) + (point.z * s),
          point.y,
          (-point.x * s) + (point.z * c),
        );
      case _CubeAxis.z:
        return _CubeDouble3(
          (point.x * c) - (point.y * s),
          (point.x * s) + (point.y * c),
          point.z,
        );
    }
  }

  static Offset projectPoint(
    _CubeDouble3 point,
    Size size,
    double yaw,
    double pitch,
  ) {
    final rotated = rotate(point, yaw: yaw, pitch: pitch);
    const cameraDistance = 8.0;
    final perspective = cameraDistance / (cameraDistance - rotated.z);
    final scale = min(size.width, size.height) * 0.19;
    return Offset(
      (size.width / 2) + (rotated.x * scale * perspective),
      (size.height / 2) - (rotated.y * scale * perspective),
    );
  }

  static (_CubeDouble3, _CubeDouble3) _basisFor(_CubeFace face) {
    switch (face) {
      case _CubeFace.up:
        return (const _CubeDouble3(1, 0, 0), const _CubeDouble3(0, 0, 1));
      case _CubeFace.right:
        return (const _CubeDouble3(0, 0, -1), const _CubeDouble3(0, -1, 0));
      case _CubeFace.front:
        return (const _CubeDouble3(1, 0, 0), const _CubeDouble3(0, -1, 0));
      case _CubeFace.down:
        return (const _CubeDouble3(1, 0, 0), const _CubeDouble3(0, 0, -1));
      case _CubeFace.left:
        return (const _CubeDouble3(0, 0, 1), const _CubeDouble3(0, -1, 0));
      case _CubeFace.back:
        return (const _CubeDouble3(-1, 0, 0), const _CubeDouble3(0, -1, 0));
    }
  }

  static _CubeFace _faceForNormal(_CubeInt3 normal) {
    return _CubeFace.values.firstWhere((face) => face.normal == normal);
  }

  static int coordOnAxis(_CubeInt3 vector, _CubeAxis axis) {
    return _coordOnAxis(vector, axis);
  }

  static int _coordOnAxis(_CubeInt3 vector, _CubeAxis axis) {
    switch (axis) {
      case _CubeAxis.x:
        return vector.x;
      case _CubeAxis.y:
        return vector.y;
      case _CubeAxis.z:
        return vector.z;
    }
  }

  static List<_CubeDouble3> _quadFrom(
    _CubeDouble3 center,
    _CubeDouble3 u,
    _CubeDouble3 v,
    double half,
  ) {
    return [
      center - u.scale(half) - v.scale(half),
      center + u.scale(half) - v.scale(half),
      center + u.scale(half) + v.scale(half),
      center - u.scale(half) + v.scale(half),
    ];
  }

  static Path _pathFrom(List<Offset> points) {
    return Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();
  }
}

class _StackSweepSlot {
  final double leftFactor;
  final double topFactor;
  final int layer;
  final int row;
  final double rotation;
  final int stackOrder;

  const _StackSweepSlot({
    required this.leftFactor,
    required this.topFactor,
    required this.layer,
    required this.row,
    this.rotation = 0,
    this.stackOrder = 0,
  });
}

class _StackSweepTile {
  final int id;
  final String symbol;
  final _StackSweepSlot slot;

  const _StackSweepTile({
    required this.id,
    required this.symbol,
    required this.slot,
  });
}
