import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../services/local_notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> _notifications = [];
  StreamSubscription<QuerySnapshot>? _subscription;

  String? _currentUserId;
  bool? _isVendorSide;
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // 🎧 START REAL-TIME LISTENER (Called when user logs in)
  void startListening({required String userId, required bool isVendorSide}) {
    // ✅ Fix: Also check if isVendorSide has changed, otherwise it returns early when switching panels
    if (_currentUserId == userId && _isVendorSide == isVendorSide && _subscription != null) return;

    stopListening();
    _currentUserId = userId;
    _isVendorSide = isVendorSide;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isVendorSide', isEqualTo: isVendorSide)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .listen(
      (snapshot) {
        final previousIds = _notifications.map((n) => n.id).toSet();
        _notifications = snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();

        // Show Local Popup only for NEW notifications arriving while app is open
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final notification = NotificationModel.fromFirestore(change.doc);
            if (!previousIds.contains(notification.id) && !notification.isRead) {
              _triggerLocalPopup(notification);
            }
          }
        }
      },
      onError: (error) {
        debugPrint("❌ Notification Stream Error: $error");
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // 🔔 TRIGGER LOCAL POPUP (When App is in Foreground)
  void _triggerLocalPopup(NotificationModel notification) {
    // Prevent old notifications from popping up on first load
    if (notification.createdAt != null) {
      if (DateTime.now().difference(notification.createdAt!).inMinutes > 1) return;
    }

    LocalNotificationService.show(
      id: notification.id.hashCode,
      title: notification.title,
      body: notification.message,
      payload: null, // You can add JSON payload here for navigation
    );
  }

  // ✅ ACTIONS
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
    } catch (e) {
      debugPrint("❌ Error marking as read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null || _isVendorSide == null) return;
    try {
      final batch = _firestore.batch();
      // ✅ Fix: Only mark current side's notifications as read
      final unread = await _firestore.collection('notifications')
          .where('userId', isEqualTo: _currentUserId)
          .where('isVendorSide', isEqualTo: _isVendorSide)
          .where('isRead', isEqualTo: false).get();

      for (var doc in unread.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint("❌ Error marking all as read: $e");
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
    } catch (e) {
      debugPrint("❌ Error deleting notification: $e");
    }
  }

  Future<void> clearAll() async {
    if (_currentUserId == null || _isVendorSide == null) return;
    try {
      final batch = _firestore.batch();
      // ✅ Fix: Only clear current side's notifications
      final all = await _firestore.collection('notifications')
          .where('userId', isEqualTo: _currentUserId)
          .where('isVendorSide', isEqualTo: _isVendorSide)
          .get();

      for (var doc in all.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint("❌ Error clearing all notifications: $e");
    }
  }

  Future<void> refresh() async {
    if (_currentUserId != null && _isVendorSide != null) {
      startListening(userId: _currentUserId!, isVendorSide: _isVendorSide!);
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _notifications = []; // Clear list when stopping
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}