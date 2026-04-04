// lib/services/food_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item_model.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'foodMenu';

  // Get all food items for an event type
  Future<List<FoodItem>> getFoodItemsByEventType(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get food items error: $e');
      return [];
    }
  }

  // Get food items by category
  Future<List<FoodItem>> getFoodItemsByCategory(String eventTypeId, String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get food items by category error: $e');
      return [];
    }
  }

  // Get food item by ID
  Future<FoodItem?> getFoodItemById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return FoodItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get food item error: $e');
      return null;
    }
  }

  // Get all food categories
  Future<List<String>> getFoodCategories(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> categories = {};
      for (var doc in snapshot.docs) {
        categories.add((doc.data() as Map<String, dynamic>)['category'] ?? '');
      }

      return categories.toList();
    } catch (e) {
      print('Get food categories error: $e');
      return [];
    }
  }

  // Stream food items by event type
  Stream<List<FoodItem>> streamFoodItemsByEventType(String eventTypeId) {
    return _firestore
        .collection(_collection)
        .where('eventTypeId', isEqualTo: eventTypeId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FoodItem.fromFirestore(doc))
        .toList());
  }

  // Get veg only food items
  Future<List<FoodItem>> getVegFoodItems(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isVeg', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get veg food items error: $e');
      return [];
    }
  }
}