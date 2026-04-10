import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io' show Platform;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static const String highImportanceChannelId = 'evora_high_importance';

  static Future<void> init({Function(String? payload)? onNotificationTap}) async {
    if (_isInitialized || kIsWeb) return;

    tz_data.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (details) {
        if (onNotificationTap != null) onNotificationTap(details.payload);
      },
    );

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        highImportanceChannelId,
        'Evora High Importance',
        description: 'Used for critical booking and payment updates',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ));
    }

    _isInitialized = true;
    debugPrint("✅ LocalNotificationService Initialized");
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) return;

    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          highImportanceChannelId,
          'Evora High Importance',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      ),
      payload: payload,
    );
  }

  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (kIsWeb) return;

    if (scheduledDate.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          highImportanceChannelId,
          'Evora High Importance',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> scheduleTaskReminders({
    required String taskId,
    required String taskName,
    required DateTime deadline,
    required String userId,
  }) async {
    if (kIsWeb) return;

    // 1 Day Before
    final oneDayBefore = deadline.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(DateTime.now())) {
      await schedule(
        id: (taskId + "_1d").hashCode,
        title: "📅 Task Tomorrow",
        body: "Reminder: '$taskName' is due in 24 hours.",
        scheduledDate: oneDayBefore,
        payload: jsonEncode({'type': 'task_reminder', 'taskId': taskId, 'userId': userId}),
      );
    }

    // 1 Hour Before
    final oneHourBefore = deadline.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(DateTime.now())) {
      await schedule(
        id: (taskId + "_1h").hashCode,
        title: "⏰ Task Due Soon!",
        body: "URGENT: '$taskName' is due in 1 hour!",
        scheduledDate: oneHourBefore,
        payload: jsonEncode({'type': 'task_reminder', 'taskId': taskId, 'userId': userId}),
      );
    }
  }

  static Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }
}