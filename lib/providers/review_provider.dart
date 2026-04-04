// lib/providers/review_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Stats
  double _averageRating = 0.0;
  int _totalReviews = 0;
  Map<int, int> _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  // Getters
  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get averageRating => _averageRating;
  int get totalReviews => _totalReviews;
  Map<int, int> get ratingDistribution => _ratingDistribution;

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 FETCH VENDOR REVIEWS
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> fetchVendorReviews(String vendorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('vendorId', isEqualTo: vendorId)
          .where('isApproved', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _reviews = snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();

      // Calculate stats
      _calculateStats();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('❌ Error fetching reviews: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 CALCULATE STATS
  // ═══════════════════════════════════════════════════════════════════════
  void _calculateStats() {
    _totalReviews = _reviews.length;
    _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    if (_reviews.isEmpty) {
      _averageRating = 0.0;
      return;
    }

    double totalRating = 0.0;
    for (var review in _reviews) {
      totalRating += review.rating;
      int star = review.rating.round().clamp(1, 5);
      _ratingDistribution[star] = (_ratingDistribution[star] ?? 0) + 1;
    }

    _averageRating = totalRating / _reviews.length;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📡 GET REVIEWS STREAM
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
      default: // newest
        query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
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

      // Update local state
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        _reviews[index] = _reviews[index].addReply(reply);
        notifyListeners();
      }

      debugPrint('✅ Reply posted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error posting reply: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD REVIEW (User side)
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> addReview({
    required String eventId,
    required String vendorId,
    required String userId,
    required String userName,
    required String vendorName,
    required String serviceType,
    required double rating,
    required String comment,
  }) async {
    try {
      final review = ReviewModel(
        id: '',
        eventId: eventId,
        vendorId: vendorId,
        userId: userId,
        userName: userName,
        vendorName: vendorName,
        serviceType: serviceType,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('reviews').add(review.toFirestore());

      // Update vendor rating
      await _updateVendorRating(vendorId);

      // Send notification to vendor
      await _sendReviewNotification(vendorId, userName, rating);

      debugPrint('✅ Review added successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error adding review: $e');
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
    } catch (e) {
      debugPrint('❌ Error updating vendor rating: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔔 SEND REVIEW NOTIFICATION
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _sendReviewNotification(String vendorId, String userName, double rating) async {
    try {
      // Get vendor userId
      final vendorDoc = await _firestore.collection('vendors').doc(vendorId).get();
      if (!vendorDoc.exists) return;

      final vendorUserId = vendorDoc.data()?['userId'];
      if (vendorUserId == null) return;

      await _firestore.collection('notifications').add({
        'userId': vendorUserId,
        'title': '⭐ New Review Received!',
        'message': '$userName gave you a ${rating.toStringAsFixed(1)} star rating.',
        'type': 'review_received',
        'relatedId': vendorId,
        'data': {
          'vendorId': vendorId,
          'rating': rating,
          'userName': userName,
        },
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ Error sending review notification: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🧹 CLEAR
  // ═══════════════════════════════════════════════════════════════════════
  void clearReviews() {
    _reviews = [];
    _averageRating = 0.0;
    _totalReviews = 0;
    _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}