// lib/services/event_type_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_type_model.dart';

class EventTypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'eventTypes';

  // Get all active event types
  Future<List<EventType>> getAllEventTypes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => EventType.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get event types error: $e');
      return [];
    }
  }

  // Get event type by ID
  Future<EventType?> getEventTypeById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return EventType.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get event type error: $e');
      return null;
    }
  }

  // Stream of event types
  Stream<List<EventType>> streamEventTypes() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => EventType.fromFirestore(doc))
        .toList());
  }
}