// lib/services/section_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/section_model.dart';

class SectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'sections';

  // Get all sections for an event type
  Future<List<Section>> getSectionsByEventType(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Section.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get sections error: $e');
      return [];
    }
  }

  // Get section by ID
  Future<Section?> getSectionById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Section.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get section error: $e');
      return null;
    }
  }

  // Stream sections by event type
  Stream<List<Section>> streamSectionsByEventType(String eventTypeId) {
    return _firestore
        .collection(_collection)
        .where('eventTypeId', isEqualTo: eventTypeId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Section.fromFirestore(doc))
        .toList());
  }

  // Get all sections
  Future<List<Section>> getAllSections() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Section.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get all sections error: $e');
      return [];
    }
  }
}