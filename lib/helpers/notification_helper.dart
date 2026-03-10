import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String relapseActionId = 'RELAPSE_ACTION';

  void Function(String? payload)? onNotificationAction;
  bool _pendingRelapseAction = false;
  bool get pendingRelapseAction => _pendingRelapseAction;
  void clearPendingRelapseAction() => _pendingRelapseAction = false;

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'daily_checkin_category',
          actions: [
            DarwinNotificationAction.plain(
              relapseActionId,
              'I slipped up',
              options: {DarwinNotificationActionOption.destructive},
            ),
          ],
        ),
      ],
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == relapseActionId) {
          _pendingRelapseAction = true;
          onNotificationAction?.call(response.payload);
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  Future<void> scheduleDailyCheckInNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_checkin',
      'Daily Check-in',
      channelDescription: 'Reminds you to check your avoid list',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          NotificationHelper.relapseActionId,
          'I slipped up',
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
        categoryIdentifier: 'daily_checkin_category',
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Keep up the good work!',
      body: "Don't forget to review your Avoid list today.",
      scheduledDate: _nextInstanceOf8PM(),
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleReminder(
      String id, String title, DateTime reminderTime) async {
    final int notificationId = int.tryParse(id) ?? id.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'event_reminders',
      'Event Reminders',
      channelDescription: 'Reminders for specific things to avoid',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: notificationId,
        title: 'Reminder: Avoid $title',
        body: 'This is your scheduled reminder to avoid this.',
        scheduledDate: scheduledDate,
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Exact alarms not permitted — fall back to inexact
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: notificationId,
        title: 'Reminder: Avoid $title',
        body: 'This is your scheduled reminder to avoid this.',
        scheduledDate: scheduledDate,
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelReminder(String id) async {
    final int notificationId = int.tryParse(id) ?? id.hashCode;
    await flutterLocalNotificationsPlugin.cancel(id: notificationId);
  }

  Future<void> scheduleWeeklyDigest(
      {int streakCount = 0, String body = ''}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'weekly_digest',
      'Weekly Progress Digest',
      channelDescription: 'Weekly summary of your avoidance progress',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    // Schedule for Sunday at 6 PM
    int daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
    if (daysUntilSunday == 0) daysUntilSunday = 7;
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysUntilSunday,
      18,
      0,
    );

    final notifBody = body.isNotEmpty
        ? body
        : 'Check your progress — keep the streaks alive this week!';

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1000,
      title: '📊 Your Weekly Avoidance Report',
      body: notifBody,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleDailyItemReminder(
      String id, String title, DateTime reminderTime) async {
    final int notificationId = int.tryParse(id) ?? id.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'item_daily_reminders',
      'Item Daily Reminders',
      channelDescription: 'Daily reminders for specific things to avoid',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: notificationId,
      title: 'Reminder: Avoid $title',
      body: 'This is your daily reminder to avoid this.',
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // ─────────────────────────────────────────────────────────────
  // Phase 2A: Pattern-based "heads up" reminder (Plus)
  // ─────────────────────────────────────────────────────────────

  /// Schedules a weekly 10 PM notification the night BEFORE [riskDayOfWeek]
  /// (DateTime.weekday format: 1=Mon … 7=Sun).
  ///
  /// Repeats every week via [DateTimeComponents.dayOfWeekAndTime].
  Future<void> schedulePatternReminder(int riskDayOfWeek) async {
    const dayNames = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final riskDayName = dayNames[riskDayOfWeek.clamp(1, 7)];

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pattern_reminder',
        'Pattern Reminder',
        channelDescription: 'Heads-up the night before your highest-risk day',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    // Schedule for the night BEFORE the risk day at 10 PM
    final schedulingWeekday = riskDayOfWeek == 1 ? 7 : riskDayOfWeek - 1;
    final now = tz.TZDateTime.now(tz.local);

    int daysUntil = (schedulingWeekday - now.weekday) % 7;
    // If today IS that weekday, check whether 10 PM has passed
    if (daysUntil == 0) {
      final today10pm =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, 22);
      if (today10pm.isBefore(now)) daysUntil = 7;
    }

    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysUntil,
      22,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 2001,
      title: '⚠️ Heads up for tomorrow',
      body: 'You tend to find $riskDayName tough. Stay strong tonight!',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelPatternReminder() async {
    await flutterLocalNotificationsPlugin.cancel(id: 2001);
  }

  // ─────────────────────────────────────────────────────────────
  // Phase 2B: Next-day relapse follow-up notification (Plus)
  // ─────────────────────────────────────────────────────────────

  /// Schedules a one-off 9 AM notification the next morning after a relapse.
  Future<void> scheduleRelapseFollowUp() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'relapse_followup',
        'Relapse Follow-up',
        channelDescription: 'Morning check-in after logging a relapse',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    final tomorrow9am =
        tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 9);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 2000,
      title: "Yesterday was tough — how are you doing today?",
      body: 'Check in with yourself and keep going. One day at a time.',
      scheduledDate: tomorrow9am,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // No matchDateTimeComponents → fires only once
    );
  }

  /// Cancels any pending relapse follow-up (e.g. if the user opens the app
  /// before 9 AM the next day).
  Future<void> cancelRelapseFollowUp() async {
    await flutterLocalNotificationsPlugin.cancel(id: 2000);
  }
}
