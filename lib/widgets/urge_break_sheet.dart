import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/break_helper.dart';
import '../model/break_session.dart';
import '../model/todo.dart';

class UrgeBreakSheet extends StatefulWidget {
  final ToDo todo;
  final BreakActivityType activityType;
  final Duration duration;
  final bool showTrustedSupport;

  const UrgeBreakSheet({
    super.key,
    required this.todo,
    required this.activityType,
    required this.showTrustedSupport,
    this.duration = const Duration(seconds: 60),
  });

  @override
  State<UrgeBreakSheet> createState() => _UrgeBreakSheetState();
}

class _UrgeBreakSheetState extends State<UrgeBreakSheet>
    with TickerProviderStateMixin {
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
  static const List<String> _defusePrompts = [
    'Tap',
    'Cool',
    'Disarm',
    'Steady',
  ];

  final Random _random = Random();
  late final AnimationController _ambientController;
  late final ConfettiController _confettiController;
  late final DateTime _startedAt;
  Timer? _ticker;
  int _secondsRemaining = 0;
  bool _showOutcome = false;
  bool _showStillStrongOptions = false;
  bool _activityCompleted = false;
  bool _finished = false;

  int _defuseCount = 0;
  int _defuseTargetTapCount = 12;
  List<Color> _defusePalette = _defusePalettes.first;
  String _defusePrompt = _defusePrompts.first;
  List<int> _pairDeck = [];
  List<String> _pairMatchEmojis = const [];
  List<_StackSweepTile> _stackTiles = const [];
  final Set<int> _matchedCards = <int>{};
  final Set<int> _revealedCards = <int>{};
  final Set<int> _removedStackTileIds = <int>{};
  final Set<int> _removingStackTileIds = <int>{};
  bool _pairLocked = false;
  List<int> _triviaOrder = const [];
  int _triviaIndex = 0;
  int? _triviaSelectedAnswer;
  String? _zenFortune;
  List<double> _zenDropXSeeds = const [];
  List<double> _zenDropOffsets = const [];
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
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 900),
    );
    _startedAt = DateTime.now();
    _secondsRemaining = widget.duration.inSeconds;
    _randomizeActivityState();
    if (widget.activityType == BreakActivityType.zenRoom) {
      _ambientController.repeat();
    }
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    for (final timer in _zenRespawnTimers.values) {
      timer.cancel();
    }
    _ambientController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<bool> _handleExitRequest() async {
    if (_finished) return true;

    final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave this break?'),
            content: const Text(
              'This session will be marked as incomplete. You can always start another break right away.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
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
        startedAt: _startedAt,
        endedAt: DateTime.now(),
      ),
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

  void _randomizeActivityState() {
    final emojiSelection = List<String>.from(_pairMatchEmojiPool)
      ..shuffle(_random);
    _pairMatchEmojis = emojiSelection.take(10).toList();
    _pairDeck = _buildPairDeck();
    _stackTiles = _buildStackTiles();
    _defuseTargetTapCount = 10 + _random.nextInt(5);
    _defusePalette = _defusePalettes[_random.nextInt(_defusePalettes.length)];
    _defusePrompt = _defusePrompts[_random.nextInt(_defusePrompts.length)];
    _triviaOrder =
        List<int>.generate(BreakHelper.triviaPrompts.length, (i) => i)
          ..shuffle(_random);
    _triviaIndex = 0;
    _zenFortune = BreakHelper
        .zenFortunes[_random.nextInt(BreakHelper.zenFortunes.length)];
    _zenDropXSeeds = List<double>.generate(14, (_) => _random.nextDouble());
    _zenDropOffsets = List<double>.generate(14, (_) => _random.nextDouble());
    _zenDropSpeeds =
        List<double>.generate(14, (_) => 0.36 + (_random.nextDouble() * 0.26));
    _zenDropSizes =
        List<double>.generate(14, (_) => 11 + (_random.nextDouble() * 7));
    _removedStackTileIds.clear();
    _removingStackTileIds.clear();
    for (final timer in _zenRespawnTimers.values) {
      timer.cancel();
    }
    _zenRespawnTimers.clear();
    _zenCaughtAt.clear();
    _ambientController.value = _random.nextDouble();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _secondsRemaining - 1;
      if (next <= 0) {
        _ticker?.cancel();
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

  Future<void> _handleActivityCompleted() async {
    if (_activityCompleted || !mounted) return;
    _ticker?.cancel();
    HapticFeedback.mediumImpact();
    _confettiController.play();
    setState(() {
      _activityCompleted = true;
      _showOutcome = true;
      _showStillStrongOptions = false;
    });
  }

  void _continueCurrentActivity() {
    HapticFeedback.lightImpact();
    setState(() {
      _secondsRemaining = 30;
      _showOutcome = false;
      _showStillStrongOptions = false;
    });
    _startTicker();
  }

  void _resetCurrentActivity() {
    HapticFeedback.lightImpact();
    setState(() {
      _secondsRemaining = widget.duration.inSeconds;
      _showOutcome = false;
      _showStillStrongOptions = false;
      _activityCompleted = false;
      _defuseCount = 0;
      _matchedCards.clear();
      _revealedCards.clear();
      _removedStackTileIds.clear();
      _removingStackTileIds.clear();
      _pairLocked = false;
      _triviaSelectedAnswer = null;
      _randomizeActivityState();
    });
    _startTicker();
  }

  String _formatCountdown() {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onDefuseTap() {
    HapticFeedback.selectionClick();
    setState(() {
      _defuseCount = (_defuseCount + 1).clamp(0, _defuseTargetTapCount);
    });
    if (_defuseCount >= _defuseTargetTapCount) {
      _handleActivityCompleted();
    }
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

  Rect _stackCoverageRectFor(_StackSweepTile tile, Size size) {
    final baseRect = _stackTileRectFor(tile, size);
    final rotationPadding = 4 + (tile.slot.rotation.abs() * 50);
    return baseRect.inflate(rotationPadding);
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

    final rect = _stackCoverageRectFor(tile, size);
    for (final other in _stackTiles) {
      if (other.id == tile.id ||
          !_isStackTileAbove(other, tile) ||
          _removedStackTileIds.contains(other.id) ||
          _removingStackTileIds.contains(other.id)) {
        continue;
      }

      if (_stackCoverageRectFor(other, size).overlaps(rect)) {
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
    setState(() => _triviaSelectedAnswer = index);
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
      final pool = List<String>.from(BreakHelper.zenFortunes);
      if (current != null && pool.length > 1) {
        pool.remove(current);
      }
      _zenFortune = pool[_random.nextInt(pool.length)];
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

  Offset _zenDropCenterAt(int index, Size size) {
    final progress = _ambientController.value;
    final xBase = 26 + (_zenDropXSeeds[index] * (size.width - 52));
    final yProgress =
        (_zenDropOffsets[index] + progress * _zenDropSpeeds[index]) % 1.15;
    final y = (size.height + 60) * yProgress - 30;
    final sway = sin((progress + _zenDropOffsets[index]) * 2 * pi * 2) * 8;
    final x = (xBase + sway).clamp(24.0, size.width - 24.0);
    return Offset(x, y);
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
        _zenDropXSeeds[index] = _random.nextDouble();
        _zenDropOffsets[index] = -0.18 - (_random.nextDouble() * 0.22);
        _zenDropSpeeds[index] = 0.36 + (_random.nextDouble() * 0.26);
        _zenDropSizes[index] = 11 + (_random.nextDouble() * 7);
      });
      _zenRespawnTimers.remove(index)?.cancel();
    });
  }

  void _onZenTapDown(TapDownDetails details, Size size) {
    final tapPoint = details.localPosition;
    for (var i = 0; i < _zenDropSizes.length; i++) {
      if (_zenCaughtAt.containsKey(i)) continue;
      final center = _zenDropCenterAt(i, size);
      final radius = _zenDropSizes[i] + 10;
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
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }

  Widget _buildPairGrid(BreakActivityDefinition definition) {
    const spacing = 10.0;
    const columns = 4;
    const rows = 5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        final tileHeight =
            (constraints.maxHeight - (spacing * (rows - 1))) / rows;
        final aspectRatio =
            tileHeight <= 0 ? 1.0 : (tileWidth / tileHeight).clamp(0.72, 1.2);

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
            return InkWell(
              key: Key('pair_card_$index'),
              borderRadius: BorderRadius.circular(18),
              onTap: () => _onPairCardTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
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
                  color: visible
                      ? null
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: visible
                        ? definition.color.withValues(
                            alpha: matched ? 0.8 : 0.45,
                          )
                        : Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withValues(alpha: 0.7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    visible ? _pairMatchEmojis[_pairDeck[index]] : '?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: visible
                          ? null
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final definition = BreakHelper.definitionFor(widget.activityType);
    final colorScheme = Theme.of(context).colorScheme;
    return PopScope<BreakSessionResult>(
      canPop: _finished,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
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
                              'Break for "${widget.todo.todoText ?? 'this item'}"',
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
                        onPressed: _handleExitRequest,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildStageShell(
                          context,
                          definition,
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _showOutcome
                                ? _buildOutcomeView(definition)
                                : _buildActivityView(definition),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityView(BreakActivityDefinition definition) {
    switch (widget.activityType) {
      case BreakActivityType.defuse:
        final progress = _defuseTargetTapCount == 0
            ? 0.0
            : _defuseCount / _defuseTargetTapCount;
        final sphereColor = Color.lerp(
              _defusePalette.first,
              _defusePalette.last,
              progress,
            ) ??
            definition.color;
        final sphereSize = lerpDouble(210, 156, progress) ?? 180;
        final outerSize = sphereSize + 34;
        return Column(
          key: const Key('break_activity_defuse'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tap to bleed off the charge. Imagine the urge losing power every time you hit the core.',
              style: TextStyle(height: 1.35),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: GestureDetector(
                  key: const Key('defuse_sphere'),
                  onTap: _onDefuseTap,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_defuseCount),
                    tween: Tween<double>(begin: 0.88, end: 1),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    builder: (context, tapScale, child) {
                      return Transform.scale(
                        scale: tapScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: outerSize,
                              height: outerSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: sphereColor.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: sphereColor.withValues(alpha: 0.22),
                                  width: 2,
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: sphereSize,
                              height: sphereSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white,
                                    sphereColor.withValues(alpha: 0.96),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: sphereColor.withValues(alpha: 0.34),
                                    blurRadius: 30 - (progress * 10),
                                    spreadRadius: 5 - (progress * 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _defuseCount >= _defuseTargetTapCount
                                        ? 'Stable'
                                        : _defusePrompt,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${(_defuseCount.clamp(0, 12) * 100 / 12).round()}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
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
            Text(
              _defuseCount >= _defuseTargetTapCount
                  ? 'Nice. Keep breathing while the minute finishes.'
                  : '${_defuseTargetTapCount - _defuseCount} taps left to stabilize it',
              style: TextStyle(color: sphereColor),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(999),
              color: sphereColor,
            ),
          ],
        );
      case BreakActivityType.pairMatch:
        return Column(
          key: const Key('break_activity_pairs'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the matching emoji pairs. Tiny pattern searches are great at breaking autopilot.',
              style: TextStyle(height: 1.35),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
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
            Text('Matched ${_matchedCards.length ~/ 2} of 10 pairs'),
          ],
        );
      case BreakActivityType.stackSweep:
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
                                              colors: removable
                                                  ? const [
                                                      Color(0xFFFFFBF1),
                                                      Color(0xFFF4E8D3),
                                                    ]
                                                  : [
                                                      const Color(
                                                        0xFFFFFBF1,
                                                      ).withValues(alpha: 0.9),
                                                      const Color(
                                                        0xFFF4E8D3,
                                                      ).withValues(alpha: 0.76),
                                                    ],
                                            ),
                                            border: Border.all(
                                              color: removable
                                                  ? definition.color
                                                  : definition.color.withValues(
                                                      alpha: 0.22,
                                                    ),
                                              width: removable ? 1.8 : 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha:
                                                      removable ? 0.14 : 0.07,
                                                ),
                                                blurRadius: removable ? 18 : 10,
                                                offset: Offset(
                                                  0,
                                                  removable ? 10 : 5,
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
                                                        alpha: 0.35,
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
                                                        removable ? 19 : 18,
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
                                '${_stackTiles.length - _removedStackTileIds.length} tiles left',
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
          ],
        );
      case BreakActivityType.triviaPivot:
        final prompt = BreakHelper.triviaPrompts[_triviaOrder[_triviaIndex]];
        return Column(
          key: const Key('break_activity_trivia'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prompt.question,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < prompt.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  key: Key('trivia_option_$i'),
                  onPressed: () => _onTriviaAnswer(i),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    backgroundColor:
                        _triviaOptionColors[i % _triviaOptionColors.length]
                            .withValues(
                      alpha: _triviaSelectedAnswer == i ? 0.24 : 0.12,
                    ),
                    side: BorderSide(
                      color: _triviaSelectedAnswer == i
                          ? _triviaOptionColors[i % _triviaOptionColors.length]
                          : _triviaOptionColors[i % _triviaOptionColors.length]
                              .withValues(alpha: 0.6),
                      width: _triviaSelectedAnswer == i ? 2 : 1.2,
                    ),
                    foregroundColor:
                        _triviaOptionColors[i % _triviaOptionColors.length],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      prompt.options[i],
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            if (_triviaSelectedAnswer != null) ...[
              const SizedBox(height: 10),
              Text(
                _triviaSelectedAnswer == prompt.answerIndex
                    ? 'Correct. ${prompt.insight}'
                    : 'Nice try. ${prompt.insight}',
                style: const TextStyle(height: 1.35),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  key: const Key('trivia_next'),
                  onPressed: _nextTrivia,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Next'),
                ),
              ),
            ],
          ],
        );
      case BreakActivityType.zenRoom:
        return Column(
          key: const Key('break_activity_zen'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, _) {
                  final zenColors = _animatedZenColors();
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final size =
                          Size(constraints.maxWidth, constraints.maxHeight);
                      final dropCenters = List<Offset>.generate(
                        _zenDropSizes.length,
                        (index) => _zenDropCenterAt(index, size),
                      );
                      return GestureDetector(
                        key: const Key('zen_room_rain_area'),
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) => _onZenTapDown(details, size),
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
                              Positioned.fill(
                                child: CustomPaint(
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
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.water_drop_outlined,
                                        size: 16,
                                        color: Color(0xFF205072),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Tap a drop',
                                        style: TextStyle(
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
                                  width: 224,
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
                                      style: const TextStyle(height: 1.42),
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
              'Catch a drop when you want a new line. Missed taps do nothing on purpose.',
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

  Widget _buildOutcomeView(BreakActivityDefinition definition) {
    return SingleChildScrollView(
      key: const Key('break_outcome_view'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Check in',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'What changed after this one-minute break?',
            style: TextStyle(height: 1.35),
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
                    ? 'Replay activity'
                    : 'Continue playing / meditating',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildOutcomeButton(
            key: const Key('break_outcome_passed'),
            label: 'Urge passed',
            color: const Color(0xFF2A9D8F),
            onTap: () => _complete(BreakOutcome.passed),
          ),
          const SizedBox(height: 10),
          _buildOutcomeButton(
            key: const Key('break_outcome_weaker'),
            label: 'Urge weaker',
            color: definition.color,
            onTap: () => _complete(BreakOutcome.weaker),
          ),
          const SizedBox(height: 10),
          _buildOutcomeButton(
            key: const Key('break_outcome_strong'),
            label: 'Still strong',
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
                  const Text(
                    'Need another layer?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        key: const Key('break_followup_retry'),
                        avatar: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Try another break'),
                        onPressed: () => _complete(
                          BreakOutcome.stillStrong,
                          followUpAction: BreakFollowUpAction.retry,
                        ),
                      ),
                      ActionChip(
                        key: const Key('break_followup_zen'),
                        avatar: const Icon(Icons.spa_outlined, size: 18),
                        label: const Text('Go to Zen Room'),
                        onPressed: () => _complete(
                          BreakOutcome.stillStrong,
                          followUpAction: BreakFollowUpAction.zenRoom,
                        ),
                      ),
                      if (widget.showTrustedSupport)
                        ActionChip(
                          key: const Key('break_followup_support'),
                          avatar: const Icon(Icons.favorite_border, size: 18),
                          label: const Text('Message support'),
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
