import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest_model.dart';
import '../services/guest_service.dart';

class GuestProvider extends ChangeNotifier {
  final GuestService _service = GuestService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<GuestModel> _guests = [];
  bool _isLoading = false;
  String? _error;

  StreamSubscription<QuerySnapshot>? _guestSubscription;

  // Getters
  List<GuestModel> get guests => _guests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Derived Stats
  int get totalRSVP => _guests.length;
  int get totalCheckedIn => _guests.where((g) => g.status == 'checked_in').length;
  List<GuestModel> get vips => _guests.where((g) => g.isVIP).toList();
  List<GuestModel> get regularGuests => _guests.where((g) => !g.isVIP).toList();

  // ═══════════════════════════════════════════════════════════════════════
  // 📡 START LIVE LISTENER
  // ═══════════════════════════════════════════════════════════════════════
  void startListening(String eventId) {
    _isLoading = true;
    notifyListeners();

    _guestSubscription?.cancel();

    _guestSubscription = _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('guests')
        .orderBy('rsvpDate', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        _guests = snapshot.docs.map((doc) => GuestModel.fromFirestore(doc)).toList();
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _error = "Failed to load guests: $e";
        print(_error);
        notifyListeners();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD VIP GUEST
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> addGuest(String eventId, GuestModel guest) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _service.addGuest(eventId, guest);

    if (!success) {
      _error = "Failed to add guest.";
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ DELETE GUEST
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> deleteGuest(String eventId, String guestId) async {
    return await _service.deleteGuest(eventId, guestId);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ CHECK IN (Direct Logic)
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> checkInGuest(String eventId, String guestId) async {
    return await _service.checkInGuest(eventId, guestId);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔍 VALIDATE AND CHECK IN (Called by Scanner UI) ✅ ADDED THIS
  // ═══════════════════════════════════════════════════════════════════════
  Future<Map<String, dynamic>> validateAndCheckInGuest(String eventId, String guestId) async {
    try {
      // 1. Get Guest
      final guest = await _service.getGuestById(eventId, guestId);

      if (guest == null) {
        return {'success': false, 'message': '❌ Guest not found', 'guestName': null};
      }

      // 2. Check if already checked in
      if (guest.status == 'checked_in') {
        return {'success': false, 'message': '⚠️ Already Checked In', 'guestName': guest.name};
      }

      // 3. Check In
      await _service.checkInGuest(eventId, guestId);
      return {'success': true, 'message': '✅ Access Granted', 'guestName': guest.name};

    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'guestName': null};
    }
  }

  @override
  void dispose() {
    _guestSubscription?.cancel();
    super.dispose();
  }
}