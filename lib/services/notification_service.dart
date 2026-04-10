// lib/services/notification_service.dart

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/app_routes.dart';
import '../models/notification_model.dart';
import 'local_notification_service.dart';

class NotificationType {
  static const String general = 'general';
  static const String bookingApproved = 'booking_approved';
  static const String bookingRejected = 'booking_rejected';
  static const String paymentSuccess = 'payment_success';
  static const String paymentReminder = 'payment_reminder';
  static const String paymentReceived = 'payment_received';
  static const String newWorkRequest = 'new_work_request';
  static const String vendorAssigned = 'vendor_assigned';
  static const String taskReminder = 'task_reminder';
  static const String vendorApproved = 'vendor_approved';
  static const String vendorRejected = 'vendor_rejected';
  static const String login = 'login';
}

// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Background Message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static GlobalKey<NavigatorState>? navigatorKey;
  bool _isInitialized = false;

  Future<void> init({GlobalKey<NavigatorState>? navKey}) async {
    if (_isInitialized) return;
    navigatorKey = navKey;

    if (!kIsWeb) {
      await LocalNotificationService.init(
        onNotificationTap: (payload) => _handleNavigation(jsonDecode(payload ?? '{}')),
      );
    }

    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Foreground Listener
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null && !kIsWeb) {
        LocalNotificationService.show(
          id: message.messageId.hashCode,
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: jsonEncode(message.data),
        );
      }
    });

    // Background Tap Listener
    FirebaseMessaging.onMessageOpenedApp.listen((message) => _handleNavigation(message.data));

    // Terminated Tap Listener
    _fcm.getInitialMessage().then((message) {
      if (message != null) _handleNavigation(message.data);
    });

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

    _isInitialized = true;
    debugPrint("✅ NotificationService Initialized");
  }

  void _handleNavigation(Map<String, dynamic> data) {
    if (navigatorKey?.currentState == null) return;

    final String type = data['type'] ?? 'general';
    final String? relatedId = data['relatedId'] ?? data['eventId'] ?? data['bookingId'];
    final bool isVendor = data['isVendorSide']?.toString().toLowerCase() == 'true';

    debugPrint("🧭 Navigating to: $type (Vendor: $isVendor, ID: $relatedId)");

    if (isVendor) {
      switch (type) {
        case NotificationType.vendorAssigned:
        case NotificationType.newWorkRequest:
          if (relatedId != null) {
            navigatorKey!.currentState!.pushNamed(AppRoutes.vendorEventDetails, arguments: {'eventId': relatedId});
          } else {
            navigatorKey!.currentState!.pushNamed(AppRoutes.vendorMain);
          }
          break;
        case NotificationType.paymentReceived:
          navigatorKey!.currentState!.pushNamed(AppRoutes.vendorMain);
          break;
        default:
          navigatorKey!.currentState!.pushNamed(AppRoutes.vendorNotifications);
      }
    } else {
      switch (type) {
        case NotificationType.bookingApproved:
        case NotificationType.bookingRejected:
          if (relatedId != null) {
            navigatorKey!.currentState!.pushNamed(AppRoutes.eventDetail, arguments: {'eventId': relatedId});
          } else {
            navigatorKey!.currentState!.pushNamed(AppRoutes.myEvents);
          }
          break;
        case NotificationType.paymentSuccess:
        case NotificationType.paymentReminder:
          navigatorKey!.currentState!.pushNamed(AppRoutes.myEvents);
          break;
        case NotificationType.taskReminder:
          if (relatedId != null) {
            navigatorKey!.currentState!.pushNamed(AppRoutes.eventDetail, arguments: {'eventId': relatedId, 'initialTab': 4});
          } else {
            navigatorKey!.currentState!.pushNamed(AppRoutes.dashboard);
          }
          break;
        default:
          navigatorKey!.currentState!.pushNamed(AppRoutes.notifications);
      }
    }
  }

  Future<String?> sendNotification(NotificationModel notification) async {
    try {
      final docRef = await _db.collection('notifications').add({
        'userId': notification.userId,
        'title': notification.title,
        'message': notification.message,
        'type': notification.type,
        'isRead': notification.isRead,
        'isVendorSide': notification.isVendorSide, // ✅ This keeps them separated
        'relatedId': notification.relatedId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint("❌ Error sending notification: $e");
      return null;
    }
  }

  // ✅ welcome notification ensures it goes to the correct list
  Future<void> sendWelcomeNotification({
    required String userId,
    required String userName,
    required bool isVendorMode, // Changed to isVendorMode for clarity
  }) async {
    final title = "Welcome back, $userName! ✨";
    final message = isVendorMode 
        ? "Ready to manage your business today? Check your work alerts!"
        : "Your journey to an unforgettable event starts here. Let's plan!";

    await sendNotification(NotificationModel(
      id: '',
      userId: userId,
      title: title,
      message: message,
      type: NotificationType.login,
      isVendorSide: isVendorMode, // ✅ Ensures user side only sees user welcome, vendor sees vendor welcome
      createdAt: DateTime.now(),
    ));

    if (!kIsWeb) {
      await LocalNotificationService.show(
        id: userId.hashCode,
        title: title,
        body: message,
        payload: jsonEncode({'type': NotificationType.login, 'isVendorSide': isVendorMode}),
      );
    }
  }

  Future<void> scheduleTaskReminders({
    required String userId,
    required String taskId,
    required String taskName,
    required DateTime deadline,
  }) async {
    if (kIsWeb) return;
    await LocalNotificationService.scheduleTaskReminders(
      taskId: taskId,
      taskName: taskName,
      deadline: deadline,
      userId: userId,
    );
  }

  Future<void> updateFCMToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? token = await _fcm.getToken(
        vapidKey: "BKj9TEN6enaimm1BdbnUCEYXOmvTtTgBfDL-9DabLsOhQ3CC6Sb2qIHTJorsjqjAFlodwZssV4aTH0SoMvFn-G0",
      );
      if (token != null) {
        await _db.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
          'platform': kIsWeb ? 'web' : 'mobile',
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("❌ Error updating FCM token: $e");
    }
  }

  Future<void> deleteFCMToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
      });
      if (!kIsWeb) {
        await _fcm.deleteToken();
      }
    } catch (e) {
      debugPrint("❌ Error deleting FCM token: $e");
    }
  }
}