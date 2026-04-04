// lib/services/review_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD REVIEW
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> addReview(ReviewModel review) async {
    try {
      await _firestore.collection('reviews').add(review.toFirestore());

      // Update vendor rating
      await _updateVendorRating(review.vendorId);

      debugPrint('✅ Review added successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error adding review: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 GET REVIEWS BY VENDOR
  // ═══════════════════════════════════════════════════════════════════════
  Future<List<ReviewModel>> getReviewsByVendor(String vendorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('vendorId', isEqualTo: vendorId)
          .where('isApproved', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching reviews: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 GET REVIEWS BY USER
  // ═══════════════════════════════════════════════════════════════════════
  Future<List<ReviewModel>> getReviewsByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching user reviews: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 💬 REPLY TO REVIEW
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> replyToReview(String reviewId, String reply) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'vendorReply': reply,
        'repliedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Reply added successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error adding reply: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 UPDATE VENDOR RATING
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _updateVendorRating(String vendorId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('vendorId', isEqualTo: vendorId)
          .where('isApproved', isEqualTo: true)
          .get();

      if (reviewsSnapshot.docs.isEmpty) return;

      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += (doc.data()['rating'] ?? 0.0).toDouble();
      }

      final avgRating = totalRating / reviewsSnapshot.docs.length;

      await _firestore.collection('vendors').doc(vendorId).update({
        'rating': double.parse(avgRating.toStringAsFixed(1)),
        'totalReviews': reviewsSnapshot.docs.length,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Vendor rating updated: $avgRating');
    } catch (e) {
      debugPrint('❌ Error updating vendor rating: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ CHECK IF USER CAN REVIEW
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> canUserReviewVendor(String userId, String eventId, String vendorId) async {
    try {
      // Check if event is completed
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) return false;

      final eventDate = (eventDoc.data()?['eventDate'] as Timestamp?)?.toDate();
      if (eventDate == null || eventDate.isAfter(DateTime.now())) {
        return false; // Event not completed yet
      }

      // Check if vendor was assigned to this event
      final assignedVendors = eventDoc.data()?['assignedVendors'] as List<dynamic>? ?? [];
      final wasAssigned = assignedVendors.any((v) => v['vendorId'] == vendorId);
      if (!wasAssigned) return false;

      // Check if user already reviewed
      final existingReview = await _firestore
          .collection('reviews')
          .where('eventId', isEqualTo: eventId)
          .where('vendorId', isEqualTo: vendorId)
          .where('userId', isEqualTo: userId)
          .get();

      return existingReview.docs.isEmpty;
    } catch (e) {
      debugPrint('❌ Error checking review eligibility: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📡 STREAM: VENDOR REVIEWS
  // ═══════════════════════════════════════════════════════════════════════
  Stream<List<ReviewModel>> getVendorReviewsStream(String vendorId, {String sortBy = 'newest'}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('reviews')
        .where('vendorId', isEqualTo: vendorId)
        .where('isApproved', isEqualTo: true);

    switch (sortBy) {
      case 'highest':
        query = query.orderBy('rating', descending: true);
        break;
      case 'lowest':
        query = query.orderBy('rating', descending: false);
        break;
      default:
        query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }
}