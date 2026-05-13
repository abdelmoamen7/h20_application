import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Notification IDs
  static const int _idMealReminder1 = 1; // Breakfast
  static const int _idMealReminder2 = 2; // Lunch
  static const int _idMealReminder3 = 3; // Dinner
  static const int _idWaterReminder = 4; // Water reminder

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Request Android 13+ permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Schedule all daily reminders.
  /// Call this once after the user completes onboarding or logs in.
  static Future<void> scheduleDailyReminders() async {
    await init();
    await _cancelAll();

    await _scheduleDailyAt(
      id: _idMealReminder1,
      hour: 8,
      minute: 0,
      title: '🍳 Breakfast time!',
      body: 'Log your breakfast to track your daily calories.',
    );

    await _scheduleDailyAt(
      id: _idMealReminder2,
      hour: 13,
      minute: 0,
      title: '🥗 Lunch reminder',
      body: 'Don\'t forget to log your lunch meal.',
    );

    await _scheduleDailyAt(
      id: _idMealReminder3,
      hour: 19,
      minute: 0,
      title: '🍽️ Dinner time!',
      body: 'Log your dinner to complete today\'s nutrition.',
    );

    await _scheduleDailyAt(
      id: _idWaterReminder,
      hour: 15,
      minute: 0,
      title: '💧 Stay hydrated!',
      body: 'Have you had enough water today? Tap to log.',
    );
  }

  /// Cancel all scheduled reminders (e.g. on sign-out).
  static Future<void> cancelAll() => _cancelAll();

  static Future<void> _cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> _scheduleDailyAt({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'h20_daily_reminders',
          'Daily Reminders',
          channelDescription: 'Meal and water logging reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
    );
  }

  /// Show an immediate notification (e.g. for testing).
  static Future<void> showNow({
    required String title,
    required String body,
  }) async {
    await init();
    await _plugin.show(
      99,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'h20_daily_reminders',
          'Daily Reminders',
          channelDescription: 'Meal and water logging reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
