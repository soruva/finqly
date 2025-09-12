// lib/services/notification_service.dart
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  NotificationService._();
  static final NotificationService _i = NotificationService._();
  factory NotificationService() => _i;

  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();
  final _tappedPayload = StreamController<String>.broadcast();
  Stream<String> get onTap => _tappedPayload.stream;

  static const _channelIdDaily = 'finqly_daily';
  static const _channelIdWeekly = 'finqly_weekly';
  static const _idDaily = 9001;
  static const _idWeekly = 9002;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // ---- Timezone init
    tzdata.initializeTimeZones();
    try {
      final localName = tz.local.name;
      tz.setLocalLocation(tz.getLocation(localName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // ---- Platform init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const init = InitializationSettings(android: androidInit);

    await _fln.initialize(
      init,
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null) _tappedPayload.add(payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Android 13+ notifications permission
    await _fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // ---- Channels
    final android = _fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(const AndroidNotificationChannel(
      _channelIdDaily,
      'Daily reminders',
      description: 'Daily Finqly reminder at 9:00',
      importance: Importance.defaultImportance,
    ));

    await android?.createNotificationChannel(const AndroidNotificationChannel(
      _channelIdWeekly,
      'Weekly report',
      description: 'Weekly report on Monday 9:00',
      importance: Importance.defaultImportance,
    ));
  }

  // Background tap handler must be a static/top-level entry point
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse resp) {
    // no-op
  }

  NotificationDetails _dailyDetails() => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdDaily,
          'Daily reminders',
          channelDescription: 'Daily Finqly reminder at 9:00',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      );

  NotificationDetails _weeklyDetails() => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdWeekly,
          'Weekly report',
          channelDescription: 'Weekly report on Monday 9:00',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      );

  tz.TZDateTime _nextDailyAt(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // weekday: Monday=1 ... Sunday=7
  tz.TZDateTime _nextWeekdayAt(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> scheduleDailyNineAM({bool enabled = true}) async {
    await init();
    await _fln.cancel(_idDaily);
    if (!enabled) return;

    await _fln.zonedSchedule(
      _idDaily,
      'Finqly',
      'Take today’s check-in – keep your streak!',
      _nextDailyAt(9, 0),
      _dailyDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'open_home',
    );
  }

  Future<void> scheduleWeeklyReportMondayNineAM({bool enabled = true}) async {
    await init();
    await _fln.cancel(_idWeekly);
    if (!enabled) return;

    await _fln.zonedSchedule(
      _idWeekly,
      'Your weekly report is ready',
      'Tap to see last week’s emotion trend.',
      _nextWeekdayAt(DateTime.monday, 9, 0),
      _weeklyDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'open_report',
    );
  }

  Future<void> cancelDaily() => _fln.cancel(_idDaily);
  Future<void> cancelWeekly() => _fln.cancel(_idWeekly);

  Future<void> scheduleTestIn(Duration delay, {String payload = 'open_home'}) async {
    await init();
    final when = tz.TZDateTime.now(tz.local).add(delay);
    await _fln.zonedSchedule(
      9999,
      'Test notification',
      'This is a quick test.',
      when,
      _dailyDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: payload,
    );
  }

  Future<void> cancelAll() async => _fln.cancelAll();
}
