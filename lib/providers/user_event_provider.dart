// lib/providers/user_event_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_event_model.dart';
import '../models/cart_item_model.dart';
import '../services/user_event_service.dart';

class UserEventProvider extends ChangeNotifier {
  final UserEventService _service = UserEventService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserEvent> _events = [];
  UserEvent? _selectedEvent;
  bool _isLoading = false;
  String? _error;

  // ═══════════════════════════════════════════════════════════════════════
  // 🎯 GETTERS
  // ═══════════════════════════════════════════════════════════════════════
  List<UserEvent> get events => _events;
  UserEvent? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 🔥 THIS GETTER MAKES THE SERVICE TAB WORK
  List<CartItem> get selectedItems => _selectedEvent?.selectedItems ?? [];

  List<UserEvent> get upcomingEvents {
    final now = DateTime.now();
    return _events.where((e) => e.eventDate.isAfter(now)).toList();
  }

  List<UserEvent> get pastEvents {
    final now = DateTime.now();
    return _events.where((e) => e.eventDate.isBefore(now)).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔍 FETCH EVENT BY ID
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> fetchEventById(String eventId) async {
    _isLoading = true;
    _error = null;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      _selectedEvent = await _service.getEventById(eventId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 FETCH USER EVENTS
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> fetchUserEvents(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _service.getUserEvents(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch events: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ CREATE NEW EVENT
  // ═══════════════════════════════════════════════════════════════════════
  Future<String?> createEvent({
    required String userId,
    required String userName,
    required String userPhone,
    required String userEmail,
    required String eventTypeId,
    required String eventTypeName,
    required String eventName,
    String description = '',
    required DateTime eventDate,
    required String eventTime,
    required String location,
    String venue = '',
    String city = '',
    required int guestCount,
    double estimatedBudget = 0.0,
    required double totalEstimatedCost,
    required List<CartItem> selectedItems,
    bool wantsVendors = true,
    // ✅ NEW
    String vendorPreference = 'platform',
    bool wantsPlatformVendors = true,
    bool usesOwnVendors = false,
    List<Map<String, dynamic>> ownProfessionals = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    final newEvent = UserEvent(
      id: '',
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      userEmail: userEmail,
      eventTypeId: eventTypeId,
      eventTypeName: eventTypeName,
      eventName: eventName,
      description: description,
      eventDate: eventDate,
      eventTime: eventTime,
      location: location,
      venue: venue,
      city: city,
      guestCount: guestCount,
      estimatedBudget: estimatedBudget,
      totalEstimatedCost: totalEstimatedCost,
      selectedItems: selectedItems,
      createdAt: DateTime.now(),
      wantsVendors: wantsVendors,
      // ✅ NEW
      vendorPreference: vendorPreference,
      wantsPlatformVendors: wantsPlatformVendors,
      usesOwnVendors: usesOwnVendors,
      ownProfessionals: ownProfessionals,
    );

    try {
      final eventId = await _service.createEvent(newEvent);
      if (eventId != null) {
        await fetchUserEvents(userId);
        _error = null;
        _isLoading = false;
        notifyListeners();
        return eventId;
      }
    } catch (e) {
      _error = 'Failed to create event: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  // ✅ ADDED: Update wantsVendors preference
  Future<void> updateVendorPreference(String eventId, bool wantsVendors) async {
    try {
      await _firestore.collection('userEvents').doc(eventId).update({
        'wantsVendors': wantsVendors,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (_selectedEvent?.id == eventId) {
        _selectedEvent = _selectedEvent?.copyWith(wantsVendors: wantsVendors);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating vendor preference: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 👥 GUEST & CHECK-IN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> incrementGuestCount(String eventId) async {
    try {
      await _firestore.collection('userEvents').doc(eventId).update({
        'guestCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await fetchEventById(eventId);
    } catch (e) {
      debugPrint('❌ Error incrementing guest count: $e');
    }
  }

  Future<void> decrementGuestCount(String eventId) async {
    try {
      await _firestore.collection('userEvents').doc(eventId).update({
        'guestCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await fetchEventById(eventId);
    } catch (e) {
      debugPrint('❌ Error decrementing guest count: $e');
    }
  }

  Future<Map<String, dynamic>> processGuestScan(String eventId, String qrCode) async {
    final result = await _service.checkInGuest(eventId, qrCode);
    if (result['success'] == true) {
      await fetchEventById(eventId);
    }
    return result;
  }

  Future<void> updateCheckInCount(String eventId, int change) async {
    try {
      final eventIndex = _events.indexWhere((e) => e.id == eventId);
      if (eventIndex == -1) return;

      int newCount = _events[eventIndex].checkedInCount + change;
      if (newCount < 0) newCount = 0;

      await _service.updateEventCount(eventId, newCount);
      await fetchEventById(eventId);
    } catch (e) {
      debugPrint('❌ Error updating check-in count: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ DELETE & REFRESH
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> deleteEvent(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _service.deleteEvent(eventId);
      if (success) {
        _events.removeWhere((event) => event.id == eventId);
        if (_selectedEvent?.id == eventId) _selectedEvent = null;
        _error = null;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Error deleting event: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> refreshEvents() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) await fetchUserEvents(uid);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    notifyListeners();
  }
}
