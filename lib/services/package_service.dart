// lib/services/package_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/package_model.dart';

class PackageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'packages';

  // Get all packages for a section (e.g., Decoration section)
  Future<List<Package>> getPackagesBySection(String sectionId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('sectionId', isEqualTo: sectionId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Package.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get packages error: $e');
      return [];
    }
  }

  // Get packages by event type
  Future<List<Package>> getPackagesByEventType(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Package.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get packages by event type error: $e');
      return [];
    }
  }

  // Get package by ID
  Future<Package?> getPackageById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Package.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get package error: $e');
      return null;
    }
  }

  // Stream packages by section
  Stream<List<Package>> streamPackagesBySection(String sectionId) {
    return _firestore
        .collection(_collection)
        .where('sectionId', isEqualTo: sectionId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Package.fromFirestore(doc))
        .toList());
  }

  // Get all packages
  Future<List<Package>> getAllPackages() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Package.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get all packages error: $e');
      return [];
    }
  }
}