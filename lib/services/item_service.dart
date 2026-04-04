// lib/services/item_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'sectionItems';

  // Get all items for a section
  Future<List<SectionItem>> getItemsBySection(String sectionId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('sectionId', isEqualTo: sectionId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => SectionItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get items error: $e');
      return [];
    }
  }

  // Get item by ID
  Future<SectionItem?> getItemById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return SectionItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get item error: $e');
      return null;
    }
  }

  // Stream items by section
  Stream<List<SectionItem>> streamItemsBySection(String sectionId) {
    return _firestore
        .collection(_collection)
        .where('sectionId', isEqualTo: sectionId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SectionItem.fromFirestore(doc))
        .toList());
  }

  // Get all items
  Future<List<SectionItem>> getAllItems() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => SectionItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get all items error: $e');
      return [];
    }
  }

  // Search items by name
  Future<List<SectionItem>> searchItems(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      List<SectionItem> allItems = snapshot.docs
          .map((doc) => SectionItem.fromFirestore(doc))
          .toList();

      // Filter by name (client-side search)
      return allItems
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Search items error: $e');
      return [];
    }
  }
}