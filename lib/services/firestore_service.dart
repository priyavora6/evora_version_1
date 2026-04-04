// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // Generic get collection
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  // Generic get document
  DocumentReference document(String path) {
    return _firestore.doc(path);
  }

  // Generic add document
  Future<String?> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await _firestore.collection(collectionPath).add(data);
      return docRef.id;
    } catch (e) {
      print('Add document error: $e');
      return null;
    }
  }

  // Generic update document
  Future<bool> updateDocument(String path, Map<String, dynamic> data) async {
    try {
      await _firestore.doc(path).update(data);
      return true;
    } catch (e) {
      print('Update document error: $e');
      return false;
    }
  }

  // Generic delete document
  Future<bool> deleteDocument(String path) async {
    try {
      await _firestore.doc(path).delete();
      return true;
    } catch (e) {
      print('Delete document error: $e');
      return false;
    }
  }
}