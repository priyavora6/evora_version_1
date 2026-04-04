// lib/providers/notification_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../services/local_notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> _notifications = [];
  StreamSubscription? _subscription;
  String? _currentUserId;
  bool? _currentSide; // Tracks if we are looking at Vendor or User side
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => n.isRead == false).length;
  bool get isLoading => _isLoading;

  // 🎧 Listener updated to filter by Panel Side (User vs Vendor)
  void startNotificationsListener(String userId, bool isVendorSide) {
    if (_currentUserId == userId && _currentSide == isVendorSide && _subscription != null) return;

    _subscription?.cancel();
    _currentUserId = userId;
    _currentSide = isVendorSide;
    _isLoading = true;

    _subscription = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isVendorSide', isEqualTo: isVendorSide) // 👈 Filter for correct panel
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .listen(
          (snapshot) {
        _notifications = snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
        _isLoading = false;
        notifyListeners();

        // Trigger local popup for NEW notifications only
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            _handleIncomingAlert(change.doc);
          }
        }
      },
      onError: (e) {
        debugPrint("❌ Notification Error: $e");
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // 🔔 Logic to show the correct popup banner on the phone
  void _handleIncomingAlert(DocumentSnapshot doc) {
    try {
      final notification = NotificationModel.fromFirestore(doc);
      if (notification.isRead) return;

      // Only show popup if it happened in the last 1 minute (prevents old alerts on app start)
      final now = DateTime.now();
      if (notification.createdAt != null && now.difference(notification.createdAt!).inMinutes > 1) return;

      switch (notification.type) {
        case NotificationType.paymentReceived:
        case NotificationType.paymentSuccess:
          LocalNotificationService.showPaymentAlert(
            title: notification.title,
            body: notification.message,
            isVendor: notification.isVendorSide,
          );
          break;
        case NotificationType.vendorAssigned:
          LocalNotificationService.showWorkAlert(
            title: notification.title,
            body: notification.message,
          );
          break;
        default:
          LocalNotificationService.showGeneralAlert(
            title: notification.title,
            body: notification.message,
            isVendor: notification.isVendorSide,
          );
      }
    } catch (e) {
      debugPrint("❌ Alert Handling Error: $e");
    }
  }

  // ➕ Add Notification
  Future<void> addNotification({
    required String userId,
    required String title,
    required String message,
    String type = NotificationType.general,
    bool isVendorSide = false,
    String? relatedId,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'isRead': false,
        'isVendorSide': isVendorSide,
        'relatedId': relatedId,
        'data': data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Error adding notification: $e");
    }
  }

  // Common Actions
  Future<void> markAsRead(String id) async {
    await _firestore.collection('notifications').doc(id).update({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null || _currentSide == null) return;
    
    final batch = _firestore.batch();
    final snapshots = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: _currentUserId)
        .where('isVendorSide', isEqualTo: _currentSide)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshots.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> clearAll() async {
    if (_currentUserId == null || _currentSide == null) return;

    final batch = _firestore.batch();
    final snapshots = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: _currentUserId)
        .where('isVendorSide', isEqualTo: _currentSide)
        .get();

    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  void stopListener() {
    _subscription?.cancel();
    _subscription = null;
    _notifications = [];
    notifyListeners();
  }
}