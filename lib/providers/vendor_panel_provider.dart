// lib/providers/vendor_panel_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorPanelProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;
  String? _vendorId;

  // Dashboard Stats
  int _totalEvents = 0;
  int _upcomingEvents = 0;
  int _completedEvents = 0;
  int _ongoingEvents = 0;
  double _averageRating = 0.0;
  int _totalReviews = 0;
  double _totalEarnings = 0.0;
  double _pendingEarnings = 0.0;
  double _thisMonthEarnings = 0.0;
  int _totalPayments = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get vendorId => _vendorId;

  // Stats Getters
  int get totalEvents => _totalEvents;
  int get upcomingEvents => _upcomingEvents;
  int get completedEvents => _completedEvents;
  int get ongoingEvents => _ongoingEvents;
  double get averageRating => _averageRating;
  int get totalReviews => _totalReviews;
  double get totalEarnings => _totalEarnings;
  double get pendingEarnings => _pendingEarnings;
  double get thisMonthEarnings => _thisMonthEarnings;
  int get totalPayments => _totalPayments;

  // Used by the Home Tab to map data easily
  Map<String, dynamic> get stats => {
    'totalEarnings': _totalEarnings,
    'upcomingCount': _upcomingEvents,
    'completedCount': _completedEvents,
    'rating': _averageRating,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 📊 MAIN LOAD METHOD (Fixes the Crash)
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> loadVendorData(String vendorId) async {
    _vendorId = vendorId;
    _isLoading = true;
    _errorMessage = null;

    // Safety check to update UI safely
    Future.microtask(() => notifyListeners());

    try {
      // Fetch all data in parallel for speed
      await Future.wait([
        _fetchVendorProfile(vendorId),
        _fetchEventStats(vendorId),
        _fetchEarningsStats(vendorId),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint('❌ Error loading vendor data: $e');
      notifyListeners();
    }
  }

  // Wrapper for compatibility with VendorMainScreen
  Future<void> fetchDashboardStats(String vendorId) async {
    await loadVendorData(vendorId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 👤 INTERNAL FETCH METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _fetchVendorProfile(String vendorId) async {
    try {
      final doc = await _firestore.collection('vendors').doc(vendorId).get();
      if (doc.exists) {
        final data = doc.data()!;
        _averageRating = (data['rating'] ?? 0.0).toDouble();
        _totalReviews = (data['totalReviews'] ?? 0).toInt();
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> _fetchEventStats(String vendorId) async {
    try {
      int total = 0;
      int upcoming = 0;
      int completed = 0;
      int ongoing = 0;
      final now = DateTime.now();

      // 1. Check 'vendorBookings' (Primary Source)
      final bookingsSnapshot = await _firestore
          .collection('vendorBookings')
          .where('vendorId', isEqualTo: vendorId)
          .get();

      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data();
        final status = (data['status'] ?? 'assigned').toString().toLowerCase();
        final eventDate = (data['eventDate'] as Timestamp?)?.toDate();

        total++;

        if (status == 'completed') {
          completed++;
        } else if (eventDate != null) {
          if (eventDate.isAfter(now)) upcoming++;
          else ongoing++;
        } else {
          upcoming++;
        }
      }

      // 2. Check 'userEvents' (Secondary Source - Scalability Warning)
      // Note: In a large app, relying on querying ALL events is slow.
      // We assume specific vendor assignments are handled via vendorBookings mostly.

      _totalEvents = total;
      _upcomingEvents = upcoming;
      _completedEvents = completed;
      _ongoingEvents = ongoing;

    } catch (e) {
      debugPrint('Error fetching event stats: $e');
    }
  }

  Future<void> _fetchEarningsStats(String vendorId) async {
    try {
      double total = 0;
      double month = 0;
      int count = 0;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Fetch Payments
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('vendorId', isEqualTo: vendorId)
          .where('status', isEqualTo: 'success')
          .get();

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0).toDouble();
        final date = (data['timestamp'] as Timestamp?)?.toDate();

        total += amount;
        count++;

        if (date != null && date.isAfter(startOfMonth)) {
          month += amount;
        }
      }

      _totalEarnings = total;
      _thisMonthEarnings = month;
      _totalPayments = count;
      // Pending earnings usually calculated from unpaid bookings

    } catch (e) {
      debugPrint('Error fetching earnings: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📡 STREAMS (Real-time Data)
  // ═══════════════════════════════════════════════════════════════════════════

  // Stream for "My Work" tab
  Stream<List<Map<String, dynamic>>> getAssignedWorkStream(String vendorId) {
    return _firestore
        .collection('vendorBookings')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include Doc ID
      return data;
    }).toList());
  }

  // Stream for Payments
  Stream<QuerySnapshot> getPaymentsStream(String vendorId) {
    return _firestore
        .collection('payments')
        .where('vendorId', isEqualTo: vendorId)
        .where('status', isEqualTo: 'success')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Stream for Reviews
  Stream<QuerySnapshot> getReviewsStream(String vendorId) {
    return _firestore
        .collection('reviews')
        .where('vendorId', isEqualTo: vendorId)
        .where('isApproved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ⚙️ ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<bool> markEventCompleted(String bookingId, String vendorId) async {
    try {
      await _firestore.collection('vendorBookings').doc(bookingId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Refresh local data
      await loadVendorData(vendorId);
      return true;
    } catch (e) {
      debugPrint("Error completing event: $e");
      return false;
    }
  }

  void clearData() {
    _vendorId = null;
    _totalEvents = 0;
    _upcomingEvents = 0;
    _completedEvents = 0;
    _totalEarnings = 0;
    notifyListeners();
  }
}