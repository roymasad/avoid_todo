import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../helpers/xp_helper.dart';
import '../helpers/database_helper.dart';
import '../providers/xp_provider.dart';
import '../constants/colors.dart';
import '../constants/tips.dart';

/// Full-screen daily commitment flow shown once per day to Plus users.
/// Pops `true` when the user commits to their habits, `false` if skipped.
class DailyCommitmentScreen extends StatefulWidget {
  final List<ToDo> activeTodos;

  const DailyCommitmentScreen({super.key, required this.activeTodos});

  @override
  State<DailyCommitmentScreen> createState() => _DailyCommitmentScreenState();
}

class _DailyCommitmentScreenState extends State<DailyCommitmentScreen>
    with TickerProviderStateMixin {
  late final List<bool> _committed;
  late final List<AnimationController> _fadeControllers;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _committed = List.filled(widget.activeTodos.length, false);

    // Staggered fade-in controllers for each habit row
    _fadeControllers = List.generate(
      widget.activeTodos.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _fadeAnimations = _fadeControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    // Stagger the animations
    for (int i = 0; i < _fadeControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 150 + i * 120), () {
        if (mounted) _fadeControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _fadeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌅';
    if (hour < 17) return 'Good afternoon ☀️';
    return 'Good evening 🌙';
  }

  String _formatStreak(ToDo todo) {
    final duration = DateTime.now().difference(todo.lastRelapsedAt);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    if (days > 0) return '${days}d ${hours}h free';
    if (duration.inHours > 0) return '${duration.inHours}h free';
    return 'Just started';
  }

  IconData _leadingIcon(ToDo todo) {
    switch (todo.avoidType) {
      case AvoidType.people:
        return Icons.person;
      case AvoidType.event:
        return Icons.event;
      case AvoidType.place:
        return Icons.place;
      default:
        return todo.isRecurring ? Icons.whatshot : Icons.block;
    }
  }

  String? _getTodayTip() {
    return getTipForStreak(7) ?? getTipForRelapse();
  }

  bool get _anyCommitted => _committed.any((c) => c);
  int get _committedCount => _committed.where((c) => c).length;

  Future<void> _commit() async {
    final xpProvider = context.read<XpProvider>();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Award +20 XP per committed habit — unique per habit per day
    for (int i = 0; i < widget.activeTodos.length; i++) {
      if (!_committed[i]) continue;
      final todo = widget.activeTodos[i];
      final key = '${XpHelper.sourceDailyCommit}:${todo.id}:$today';
      final already = await DatabaseHelper.instance.hasXpSourceKey(key);
      if (!already) {
        await xpProvider.award(key, XpHelper.xpDailyCommit);
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tip = _getTodayTip();
    final count = _committedCount;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Commit to your habits for today',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Skip',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: widget.activeTodos.isEmpty
                          ? 0
                          : count / widget.activeTodos.length,
                      backgroundColor:
                          isDark ? Colors.white12 : Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        count == widget.activeTodos.length
                            ? Colors.green
                            : tdAvoidRed,
                      ),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count / ${widget.activeTodos.length} committed',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            // ── Habit list ─────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: widget.activeTodos.length,
                itemBuilder: (context, i) {
                  final todo = widget.activeTodos[i];
                  final isCommitted = _committed[i];
                  return FadeTransition(
                    opacity: _fadeAnimations[i],
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _committed[i] = !isCommitted),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCommitted
                              ? Colors.green.withAlpha(25)
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isCommitted
                                ? Colors.green.withAlpha(120)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Leading icon badge
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isCommitted
                                    ? Colors.green.withAlpha(30)
                                    : (isDark
                                        ? Colors.white12
                                        : Colors.black.withAlpha(12)),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _leadingIcon(todo),
                                color:
                                    isCommitted ? Colors.green : tdAvoidRed,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Habit name + streak
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo.todoText ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isCommitted
                                          ? Colors.green.shade700
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatStreak(todo),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isCommitted
                                          ? Colors.green.withAlpha(180)
                                          : (isDark
                                              ? Colors.white54
                                              : Colors.black45),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Animated check
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isCommitted
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 28,
                                      key: ValueKey('checked'),
                                    )
                                  : Icon(
                                      Icons.radio_button_unchecked,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.black26,
                                      size: 28,
                                      key: const ValueKey('unchecked'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Today's tip ────────────────────────────────────────────────
            if (tip != null)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: tdAvoidRed.withAlpha(15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: tdAvoidRed.withAlpha(40)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ── "Start my day" button ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _anyCommitted ? _commit : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _anyCommitted
                        ? 'Start my day  +${count * XpHelper.xpDailyCommit} XP'
                        : 'Tap habits to commit',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
