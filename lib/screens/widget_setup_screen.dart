import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSetupScreen extends StatefulWidget {
  const WidgetSetupScreen({super.key});

  @override
  State<WidgetSetupScreen> createState() => _WidgetSetupScreenState();
}

class _WidgetSetupScreenState extends State<WidgetSetupScreen> {
  bool _pinSupported = false;
  bool _pinRequested = false;
  int _selectedColor = 0;

  // Live data for the preview — loaded from HomeWidget's shared prefs
  String _habitName = '';
  String _streakLabel = '';
  int _habitCount = 0;

  // Gradient pairs matching the native XML drawables exactly
  static const _colors = [
    (label: 'Forest',   start: Color(0xFF2E7D32), end: Color(0xFF0D2E0F)),
    (label: 'Midnight', start: Color(0xFF1A2E42), end: Color(0xFF050C15)),
    (label: 'Ocean',    start: Color(0xFF0E4A7A), end: Color(0xFF051828)),
    (label: 'Purple',   start: Color(0xFF3D2490), end: Color(0xFF150938)),
  ];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIdx = prefs.getInt('widget_color_index') ?? 0;

    // Load actual widget data so the preview shows real content
    final habitName   = await HomeWidget.getWidgetData<String>('habit_name',   defaultValue: '') ?? '';
    final streakLabel = await HomeWidget.getWidgetData<String>('streak_label', defaultValue: '') ?? '';
    final habitCount  = await HomeWidget.getWidgetData<int>('habit_count',     defaultValue: 0)  ?? 0;

    bool pinSupported = false;
    if (Platform.isAndroid) {
      pinSupported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
    }

    if (mounted) {
      setState(() {
        _selectedColor = colorIdx;
        _habitName     = habitName;
        _streakLabel   = streakLabel;
        _habitCount    = habitCount;
        _pinSupported  = pinSupported;
      });
    }
  }

  Future<void> _requestPin() async {
    try {
      await HomeWidget.requestPinWidget(
        name: 'AvoidWidgetProvider',
        androidName: 'AvoidWidgetProvider',
      );
      if (mounted) setState(() => _pinRequested = true);
    } catch (e) {
      debugPrint('[WidgetSetup] requestPinWidget error: $e');
    }
  }

  Future<void> _setColor(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('widget_color_index', index);
    await HomeWidget.saveWidgetData<int>('widget_color_index', index);
    await HomeWidget.updateWidget(
      name: 'AvoidWidgetProvider',
      iOSName: 'AvoidWidget',
    );
    if (mounted) setState(() => _selectedColor = index);
  }

  // ── Preview ──────────────────────────────────────────────────────────────
  Widget _buildPreview() {
    final c        = _colors[_selectedColor];
    final hasData  = _habitName.isNotEmpty;
    final label    = hasData
        ? (_habitCount == 1 ? 'AVOIDING 1 HABIT' : 'AVOIDING $_habitCount HABITS')
        : 'AVOIDING';
    final name     = hasData ? _habitName  : 'Your top habit';
    final streak   = hasData ? _streakLabel : '— days';
    final suffix   = hasData ? '🔥 streak‑free' : 'Open app to start';

    return Center(
      child: Container(
        width: 200,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c.start, c.end],
          ),
          boxShadow: [
            BoxShadow(
              color: c.start.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "AVOIDING X HABITS"
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.53),
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            // Habit name
            Text(
              name,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.93),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Frosted streak pill
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text(
                streak,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            // "🔥 streak-free"
            Text(
              suffix,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    final steps = isIos ? _iosSteps : _androidFallbackSteps;

    return Scaffold(
      appBar: AppBar(
        title: Text(isIos ? '🍎 iOS — Add Widget' : '🤖 Android — Add Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live widget preview
            if (!isIos) ...[
              _buildPreview(),
              const SizedBox(height: 20),
            ],

            // Android: pin button
            if (!isIos && _pinSupported) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_to_home_screen),
                  label: Text(_pinRequested
                      ? 'Widget dialog opened!'
                      : 'Add Widget to Home Screen'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _pinRequested ? null : _requestPin,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your launcher will ask where to place it.',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
            ],

            // Color picker (Android only)
            if (!isIos) ...[
              const Text('Widget colour',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_colors.length, (i) {
                  final c        = _colors[i];
                  final selected = _selectedColor == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => _setColor(i),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [c.start, c.end],
                              ),
                              border: Border.all(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 20)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
            ],

            // Step list header
            Text(
              isIos
                  ? 'Follow these steps:'
                  : (_pinSupported
                      ? 'Launcher doesn\'t support the button? Try manually:'
                      : 'Follow these steps:'),
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.separated(
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              if (step.description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(step.description,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('widget_setup_shown', true);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _iosSteps = [
    _Step('Go to your Home Screen',
        'Press Home or swipe up from any app.'),
    _Step('Long-press an empty area',
        'Hold until the icons start to jiggle.'),
    _Step('Tap the + button', 'Top-left corner.'),
    _Step('Search for "Avoid"', 'Type in the search bar.'),
    _Step('Select the Avoid widget',
        'Tap it, pick a size, then tap "Add Widget".'),
    _Step('Press Done', 'Top-right corner to finish.'),
  ];

  static const _androidFallbackSteps = [
    _Step('Go to your Home Screen', 'Press the Home button.'),
    _Step('Long-press an empty area',
        'Hold on a blank spot until edit mode appears.'),
    _Step('Tap "Widgets"', 'Look at the bottom of the screen.'),
    _Step('Find "Avoid Todo"', 'Scroll to the A section.'),
    _Step('Long-press & drag',
        'Drag the widget to any empty spot on your home screen.'),
  ];
}

class _Step {
  final String title;
  final String description;
  const _Step(this.title, this.description);
}
