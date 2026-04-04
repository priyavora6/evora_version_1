// lib/services/local_notification_service.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Timezone (Essential for Scenario 4 & 5)
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // 2. Settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));

    // 3. Channels
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        'vendor_biz', 'Business Alerts', importance: Importance.max, playSound: true,
      ));
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        'user_alerts', 'Personal Alerts', importance: Importance.high, playSound: true,
      ));
    }
  }

  // 💰 Payment Success/Received Alert
  static Future<void> showPaymentAlert({required String title, required String body, required bool isVendor}) async {
    await _plugin.show(
      99, title, body,
      NotificationDetails(
        android: AndroidNotificationDetails(
            isVendor ? 'vendor_biz' : 'user_alerts',
            'Payments',
            color: Colors.green,
            importance: Importance.max,
            priority: Priority.high
        ),
      ),
    );
  }

  // 🚀 Work Assigned Alert
  static Future<void> showWorkAlert({required String title, required String body}) async {
    await _plugin.show(
      100, title, body,
      const NotificationDetails(
        android: AndroidNotificationDetails('vendor_biz', 'New Work', color: Colors.blue, importance: Importance.max),
      ),
    );
  }

  // 📅 General/Login Alert
  static Future<void> showGeneralAlert({required String title, required String body, required bool isVendor}) async {
    await _plugin.show(
      101, title, body,
      NotificationDetails(
        android: AndroidNotificationDetails(isVendor ? 'vendor_biz' : 'user_alerts', 'General', importance: Importance.high),
      ),
    );
  }

  // ⏰ Scheduled Task/Payment Reminder (Scenarios 4 & 5)
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required bool isVendor,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id, title, body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
            isVendor ? 'vendor_biz' : 'user_alerts',
            'Reminders',
            color: Colors.redAccent,
            importance: Importance.max
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancel(int id) async => await _plugin.cancel(id);
}