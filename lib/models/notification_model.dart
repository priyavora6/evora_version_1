// lib/models/notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final bool isVendorSide; // ✅ True if it belongs to Vendor Panel alerts
  final String? relatedId; // eventId, bookingId, or taskId
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.isVendorSide,
    this.relatedId,
    this.data,
    this.createdAt,
    this.readAt,
  });

  // 📥 FROM FIRESTORE
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'Notification',
      message: data['message'] ?? '',
      type: data['type'] ?? NotificationType.general,
      isRead: data['isRead'] ?? false,
      isVendorSide: data['isVendorSide'] ?? false,
      relatedId: data['relatedId'],
      data: data['data'] != null ? Map<String, dynamic>.from(data['data']) : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      readAt: (data['readAt'] as Timestamp?)?.toDate(),
    );
  }

  // Helper getters for backward compatibility or ease of use
  String? get eventId => relatedId;
  String? get bookingId => relatedId;

  // 📤 TO FIRESTORE
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'isVendorSide': isVendorSide,
      'relatedId': relatedId,
      'data': data,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🏷️ NOTIFICATION TYPE CONSTANTS (Mapping your 8 Scenarios)
// ═══════════════════════════════════════════════════════════════════════════════
class NotificationType {
  static const String general = 'general';

  // 1. Auth (Scenario 1)
  static const String login = 'login';

  // 2. Booking (Scenario 2)
  static const String bookingApproved = 'booking_approved';

  // 3. Payment User (Scenario 3 & 4)
  static const String paymentSuccess = 'payment_success';
  static const String paymentReminder = 'payment_reminder';

  // 4. Tasks (Scenario 5)
  static const String taskReminder = 'task_reminder';

  // 5. Vendor Specific (Scenario 6, 7, 8)
  static const String vendorApproved = 'vendor_approved';
  static const String vendorAssigned = 'vendor_assigned';
  static const String paymentReceived = 'payment_received';
}

// ═══════════════════════════════════════════════════════════════════════════════
// 🏭 NOTIFICATION FACTORY (Triggering the 8 Scenarios)
// ═══════════════════════════════════════════════════════════════════════════════
class NotificationFactory {

  // Scenario 1: Login
  static NotificationModel login({required String uid, required String name, required bool isVendor}) {
    return NotificationModel(
      id: '', userId: uid, isVendorSide: isVendor, type: NotificationType.login,
      title: "Welcome back, $name! 👋",
      message: "Successfully logged in to your Evora account.",
    );
  }

  // Scenario 2: Booking Approved
  static NotificationModel bookingApproved({required String uid, required String eventName, required String bookingId}) {
    return NotificationModel(
      id: '', userId: uid, isVendorSide: false, type: NotificationType.bookingApproved,
      relatedId: bookingId,
      title: "✅ Booking Approved",
      message: "Your request for $eventName has been approved by the admin.",
    );
  }

  // Scenario 3: Payment Successful
  static NotificationModel paymentSuccess({required String uid, required double amt, required String eventName}) {
    return NotificationModel(
      id: '', userId: uid, isVendorSide: false, type: NotificationType.paymentSuccess,
      title: "💳 Payment Successful",
      message: "₹${amt.toInt()} has been successfully paid for $eventName.",
    );
  }

  // Scenario 4: 7-Day Payment Reminder
  static NotificationModel paymentReminder({required String uid, required String eventName}) {
    return NotificationModel(
      id: '', userId: uid, isVendorSide: false, type: NotificationType.paymentReminder,
      title: "⏳ Payment Due",
      message: "Reminder: Please complete your payment for $eventName within the next 24 hours.",
    );
  }

  // Scenario 5: Task Reminder (1 Day / 1 Hour)
  static NotificationModel taskAlert({required String uid, required String taskName, required String timeLabel}) {
    return NotificationModel(
      id: '', userId: uid, isVendorSide: false, type: NotificationType.taskReminder,
      title: "📅 Task Reminder: $timeLabel",
      message: "Don't forget to complete: $taskName",
    );
  }

  // Scenario 6: Vendor Approved
  static NotificationModel vendorApproved({required String vendorId}) {
    return NotificationModel(
      id: '', userId: vendorId, isVendorSide: true, type: NotificationType.vendorApproved,
      title: "🎊 Account Verified!",
      message: "Your vendor profile is approved. You can now receive work assignments.",
    );
  }

  // Scenario 7: Admin Assigned Work
  static NotificationModel workAssigned({required String vendorId, required String eventName, required String eventId}) {
    return NotificationModel(
      id: '', userId: vendorId, isVendorSide: true, type: NotificationType.vendorAssigned,
      relatedId: eventId,
      title: "🚀 New Work Assigned",
      message: "Admin has assigned you to the event: $eventName. Check 'My Work'.",
    );
  }

  // Scenario 8: Payment Received (Vendor Side)
  static NotificationModel paymentReceived({required String vendorId, required double amt, required String eventName}) {
    return NotificationModel(
      id: '', userId: vendorId, isVendorSide: true, type: NotificationType.paymentReceived,
      title: "💰 Money Received!",
      message: "You received ₹${amt.toInt()} for your services at $eventName.",
    );
  }
}