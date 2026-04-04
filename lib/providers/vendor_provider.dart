// lib/providers/vendor_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor_model.dart';
import '../models/vendor_booking_model.dart';

class VendorProvider extends ChangeNotifier {
  List<VendorModel> _vendors = [];
  List<VendorBookingModel> _myBookings = [];
  bool _isLoading = true;
  bool _isBooking = false;
  String? _errorMessage;

  // Getters
  List<VendorModel> get vendors => _vendors;
  List<VendorBookingModel> get myBookings => _myBookings;
  bool get isLoading => _isLoading;
  bool get isBooking => _isBooking;
  String? get errorMessage => _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ══════════════════════════════════════════════════════════════════════
  // 📋 LOAD ALL APPROVED VENDORS (real-time)
  // ══════════════════════════════════════════════════════════════════════
  void initVendorStream() {
    _isLoading = true;
    notifyListeners();

    _firestore
        .collection('vendors')
        .where('isApproved', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _vendors = snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('❌ Error loading vendors: $e');
      _errorMessage = 'Failed to load vendors';
      _isLoading = false;
      notifyListeners();
    });
  }

  // ══════════════════════════════════════════════════════════════════════
  // 📋 LOAD MY BOOKINGS (For the Organizer/User side)
  // ══════════════════════════════════════════════════════════════════════
  void loadMyBookings(String userId) {
    _firestore
        .collection('vendorBookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _myBookings = snapshot.docs
          .map((doc) => VendorBookingModel.fromFirestore(doc))
          .toList();
      notifyListeners();
    }, onError: (e) {
      debugPrint('❌ Error loading bookings: $e');
    });
  }

  // ══════════════════════════════════════════════════════════════════════
  // ➕ SEND BOOKING REQUEST
  // ══════════════════════════════════════════════════════════════════════
  Future<bool> sendBookingRequest({
    required VendorModel vendor,
    required String userId,
    required String userName,
    required String userPhone,
    required String userEmail,
    required String eventId,
    required String eventName,
    required DateTime eventDate,
    required String eventTime,   // ✅ Added
    required String eventVenue,  // ✅ Added
    required String message,
  }) async {
    _isBooking = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final booking = VendorBookingModel(
        id: '',
        vendorId: vendor.id,
        vendorName: vendor.businessName,
        vendorPhone: vendor.businessPhone, // ✅ FIXED: vendor.phone -> vendor.businessPhone
        vendorCategory: vendor.serviceType,
        serviceType: vendor.serviceType,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        userEmail: userEmail,
        eventId: eventId,
        eventName: eventName,
        eventDate: eventDate,
        eventTime: eventTime,   // ✅ Added
        eventVenue: eventVenue, // ✅ Added
        message: message,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('vendorBookings').add(booking.toFirestore());

      _isBooking = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isBooking = false;
      notifyListeners();
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // ✅ ADMIN: APPROVE VENDOR BOOKING & NOTIFY
  // ══════════════════════════════════════════════════════════════════════
  Future<bool> approveVendorBooking({
    required String bookingId,
    required double vendorPrice,
    String? adminNote,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bookingDoc = await _firestore.collection('vendorBookings').doc(bookingId).get();
      if (!bookingDoc.exists) return false;

      final data = bookingDoc.data()!;
      final batch = _firestore.batch();

      // 1. Update status to 'assigned' (since admin assigned them)
      batch.update(bookingDoc.reference, {
        'status': 'assigned',
        'vendorPrice': vendorPrice,
        'adminNote': adminNote ?? 'Booking Approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // 2. Notify VENDOR (Business Alerts)
      final vendorNotifRef = _firestore.collection('notifications').doc();
      batch.set(vendorNotifRef, {
        'userId': data['vendorId'], // Sent to vendor
        'title': '🚀 New Work Assigned!',
        'message': 'You have a new assignment for ${data['eventName']}. Reach by ${data['eventTime']}.',
        'type': 'vendor_assigned',
        'relatedId': data['eventId'],
        'isVendorSide': true, // ✅ CRITICAL for Vendor Panel
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Notify USER (Organizer)
      final userNotifRef = _firestore.collection('notifications').doc();
      batch.set(userNotifRef, {
        'userId': data['userId'], // Sent to user
        'title': '✅ Vendor Confirmed',
        'message': '${data['vendorName']} is ready for your event at ₹$vendorPrice.',
        'type': 'vendor_approved',
        'relatedId': data['eventId'],
        'isVendorSide': false,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // 💳 PROCESS PAYMENT & NOTIFY VENDOR
  // ══════════════════════════════════════════════════════════════════════
  Future<bool> processVendorPayment({
    required String bookingId,
    required String userId,
    required String userName,
    required String eventId,
    required double amount,
    required String method,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bookingDoc = await _firestore.collection('vendorBookings').doc(bookingId).get();
      if (!bookingDoc.exists) return false;

      final data = bookingDoc.data()!;
      final batch = _firestore.batch();

      // 1. Update Booking
      batch.update(bookingDoc.reference, {
        'amountPaid': amount,
        'paymentStatus': 'paid',
        'paymentMethod': method,
        'paidAt': FieldValue.serverTimestamp(),
      });

      // 2. Notify VENDOR (Money alert)
      final notifRef = _firestore.collection('notifications').doc();
      batch.set(notifRef, {
        'userId': data['vendorId'],
        'title': '💰 Payment Received!',
        'message': 'You received ₹$amount for the event: ${data['eventName']}.',
        'type': 'payment_received',
        'isVendorSide': true, // ✅ Shows in Vendor Business Alerts
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔍 SEARCH / FILTER (Remains same but optimized)
  List<VendorModel> searchVendors(String query) {
    if (query.isEmpty) return _vendors;
    final q = query.toLowerCase();
    return _vendors.where((v) =>
    v.businessName.toLowerCase().contains(q) ||
        v.serviceType.toLowerCase().contains(q)
    ).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
