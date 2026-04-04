// lib/services/notification_service.dart

import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../config/app_routes.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final data = jsonDecode(details.payload!);
          _handleNavigation(data);
        }
      },
    );

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        'high_importance_channel', 'General Alerts', importance: Importance.max, playSound: true,
      ));
      await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
        'vendor_channel', 'Vendor Business Alerts', importance: Importance.max, playSound: true,
      ));
    }

    FirebaseMessaging.onMessage.listen((msg) => _showLocalNotification(msg));
    FirebaseMessaging.onMessageOpenedApp.listen((msg) => _handleNavigation(msg.data));
    debugPrint("✅ Notification Service Initialized");
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🚀 THE 8 SCENARIOS LOGIC
  // ═══════════════════════════════════════════════════════════════════════

  // 1. Login (User/Vendor)
  Future<void> sendLoginAlert(String uid, String name, bool isVendor) async {
    await _saveToFirestore(
      uid: uid, isVendor: isVendor, type: 'login',
      title: "Welcome back, $name! 👋",
      msg: "Successfully logged in to Evora.",
    );
  }

  // 2 & 4. Booking Approved + 7 Day Payment Reminder
  Future<void> sendBookingApproval(String uid, String eventName, String bookingId) async {
    await _saveToFirestore(
      uid: uid, isVendor: false, type: 'booking_approved', relatedId: bookingId,
      title: "✅ Booking Approved!",
      msg: "Your request for $eventName is approved. Please pay within 7 days.",
    );

    // Schedule 7th day local alert (Scenario 4)
    final lastDay = DateTime.now().add(const Duration(days: 6, hours: 23));
    await scheduleLocalAlert(
      id: bookingId.hashCode,
      title: "⏳ Urgent: Payment Deadline",
      body: "Today is the last day to pay for $eventName.",
      scheduledDate: lastDay,
    );
  }

  // 3 & 8. Payment Success (User) & Payment Received (Vendor)
  Future<void> sendPaymentNotifications({
    required String userId,
    required String vendorId,
    required String eventName,
    required double amount
  }) async {
    // To User
    await _saveToFirestore(
      uid: userId, isVendor: false, type: 'payment_success',
      title: "💳 Payment Successful",
      msg: "₹${amount.toInt()} paid for $eventName.",
    );
    // To Vendor (Scenario 8)
    await _saveToFirestore(
      uid: vendorId, isVendor: true, type: 'payment_received',
      title: "💰 Money Received!",
      msg: "You received ₹${amount.toInt()} for $eventName.",
    );
  }

  // 5. Task Reminders (1 Day & 1 Hour Before)
  Future<void> scheduleTaskReminders(String taskId, String taskName, DateTime deadline) async {
    // 1 Day Before
    await scheduleLocalAlert(
      id: taskId.hashCode + 1,
      title: "📅 Task Tomorrow",
      body: "Reminder: '$taskName' is due in 24 hours.",
      scheduledDate: deadline.subtract(const Duration(days: 1)),
    );
    // 1 Hour Before
    await scheduleLocalAlert(
      id: taskId.hashCode + 2,
      title: "⏳ Task Due Soon",
      body: "Action Required: '$taskName' is due in 1 hour!",
      scheduledDate: deadline.subtract(const Duration(hours: 1)),
    );
  }

  // 6. Vendor Request Approved
  Future<void> sendVendorAccountApproved(String vendorId) async {
    await _saveToFirestore(
      uid: vendorId, isVendor: true, type: 'vendor_approved',
      title: "🎊 Account Approved!",
      msg: "Congratulations! Your vendor profile is now active.",
    );
  }

  // 7. Admin Assigns Work
  Future<void> sendWorkAssignment(String vendorId, String eventName, String eventId) async {
    await _saveToFirestore(
      uid: vendorId, isVendor: true, type: 'vendor_assigned', relatedId: eventId,
      title: "🚀 New Work Assigned",
      msg: "You have been assigned to: $eventName. Check 'My Work' tab.",
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🛠️ INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _saveToFirestore({
    required String uid, required bool isVendor, required String title,
    required String msg, required String type, String? relatedId
  }) async {
    await _db.collection('notifications').add({
      'userId': uid,
      'isVendorSide': isVendor,
      'title': title,
      'message': msg,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
      'relatedId': relatedId,
    });
  }

  Future<void> scheduleLocalAlert({required int id, required String title, required String body, required DateTime scheduledDate}) async {
    if (scheduledDate.isBefore(DateTime.now())) return;
    await _localNotifications.zonedSchedule(
      id, title, body, tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(android: AndroidNotificationDetails('task_reminders', 'Planning Reminders', importance: Importance.high)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      String channelId = message.data['isVendorSide'].toString() == 'true' ? 'vendor_channel' : 'high_importance_channel';
      _localNotifications.show(
        notification.hashCode, notification.title, notification.body,
        NotificationDetails(android: AndroidNotificationDetails(channelId, 'Alerts', importance: Importance.max)),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleNavigation(Map<String, dynamic> data) {
    final bool isVendor = data['isVendorSide'].toString() == 'true';
    final String? type = data['type']?.toString();
    final String? id = data['relatedId']?.toString();

    if (isVendor) {
      if (type == 'vendor_assigned') {
        navigatorKey.currentState?.pushNamed('/vendor-event-details', arguments: {'eventId': id});
      } else {
        navigatorKey.currentState?.pushNamed('/vendor-notifications');
      }
    } else {
      if (id != null) {
        navigatorKey.currentState?.pushNamed(AppRoutes.eventDetail, arguments: {'eventId': id});
      } else {
        navigatorKey.currentState?.pushNamed(AppRoutes.dashboard);
      }
    }
  }

  Future<void> updateDeviceToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? token = await _fcm.getToken();
      if (token != null) {
        await _db.collection('users').doc(user.uid).set({'fcmToken': token, 'lastActive': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      }
    }
  }

  Future<void> deleteDeviceToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
      });
    }
  }
}
