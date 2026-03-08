import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import '../model/todo.dart';

class HomeWidgetHelper {
  HomeWidgetHelper._();

  static const String _androidProvider = 'AvoidWidgetProvider';
  static const String _iosName = 'AvoidWidget';

  /// Saves all active habits sorted by streak (best first, capped at 10),
  /// then notifies the OS to refresh the widget.
  static Future<void> update(List<ToDo> activeTodos) async {
    try {
      await HomeWidget.saveWidgetData<int>('habit_count', activeTodos.length);

      if (activeTodos.isEmpty) {
        await _clearWidget();
        return;
      }

      // Sort by live streak descending, cap at 10
      final sorted = [...activeTodos]
        ..sort((a, b) => _liveStreak(b).compareTo(_liveStreak(a)));
      final habits = sorted.take(10).toList();

      await HomeWidget.saveWidgetData<int>('widget_item_count', habits.length);
      // Reset cycle index so widget always starts from the top habit after a data refresh
      await HomeWidget.saveWidgetData<int>('widget_current_index', 0);

      for (int i = 0; i < habits.length; i++) {
        final days = _liveStreak(habits[i]).inDays;
        await HomeWidget.saveWidgetData<String>('habit_${i}_name', habits[i].todoText);
        await HomeWidget.saveWidgetData<String>(
            'habit_${i}_streak', days == 1 ? '1 day' : '$days days');
      }

      // Keep legacy keys for future iOS widget compatibility
      final best = habits.first;
      final bestDays = _liveStreak(best).inDays;
      await HomeWidget.saveWidgetData<String>('habit_name', best.todoText);
      await HomeWidget.saveWidgetData<String>(
          'streak_label', bestDays == 1 ? '1 day' : '$bestDays days');

      await HomeWidget.updateWidget(
        name: _androidProvider,
        iOSName: _iosName,
      );
    } catch (e) {
      debugPrint('[HomeWidgetHelper] widget not configured yet: $e');
    }
  }

  static Future<void> _clearWidget() async {
    await HomeWidget.saveWidgetData<int>('widget_item_count', 0);
    await HomeWidget.saveWidgetData<int>('widget_current_index', 0);
    await HomeWidget.saveWidgetData<String>('habit_name', '');
    await HomeWidget.saveWidgetData<String>('streak_label', '');
    await HomeWidget.updateWidget(
      name: _androidProvider,
      iOSName: _iosName,
    );
  }

  static Duration _liveStreak(ToDo todo) =>
      DateTime.now().difference(todo.lastRelapsedAt);
}
