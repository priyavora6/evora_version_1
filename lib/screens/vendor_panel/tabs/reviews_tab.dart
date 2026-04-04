// lib/screens/vendor_panel/tabs/reviews_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/review_item.dart';

class ReviewsTab extends StatefulWidget {
  const ReviewsTab({super.key});

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  String _sortBy = 'newest';

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final vendorId = authProvider.currentVendor?.id ?? '';

        if (vendorId.isEmpty) {
          return const Center(child: Text('Vendor data not found'));
        }

        return Column(
          children: [
            // Rating Overview
            _buildRatingOverview(vendorId),

            // Sort Options
            _buildSortOptions(),

            // Reviews List
            Expanded(
              child: _buildReviewsList(vendorId),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ⭐ RATING OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildRatingOverview(String vendorId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .snapshots(),
      builder: (context, snapshot) {
        double rating = 0.0;
        int totalReviews = 0;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          rating = (data['rating'] ?? 0.0).toDouble();
          totalReviews = data['totalReviews'] ?? 0;
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rating Number
              Column(
                children: [
                  Text(
                    rating > 0 ? rating.toStringAsFixed(1) : '-',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalReviews reviews',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),

              // Rating Breakdown
              Expanded(
                child: _buildRatingBreakdown(vendorId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingBreakdown(String vendorId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('vendorId', isEqualTo: vendorId)
          .where('isApproved', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
        int total = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final rating = ((doc.data() as Map<String, dynamic>)['rating'] ?? 0).round();
            if (rating >= 1 && rating <= 5) {
              distribution[rating] = (distribution[rating] ?? 0) + 1;
              total++;
            }
          }
        }

        return Column(
          children: [5, 4, 3, 2, 1].map((star) {
            final count = distribution[star] ?? 0;
            final percentage = total > 0 ? (count / total) : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text(
                    '$star',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔽 SORT OPTIONS
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Sort by:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          _buildSortChip('Newest', 'newest'),
          const SizedBox(width: 8),
          _buildSortChip('Highest', 'highest'),
          const SizedBox(width: 8),
          _buildSortChip('Lowest', 'lowest'),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📋 REVIEWS LIST
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildReviewsList(String vendorId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getReviewsStream(vendorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return ReviewItem(
              reviewId: doc.id,
              userName: data['userName'] ?? 'User',
              rating: (data['rating'] ?? 0.0).toDouble(),
              comment: data['comment'] ?? '',
              eventName: data['eventName'] ?? '',
              createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
              vendorReply: data['vendorReply'],
              showReplyButton: true,
              onReply: (reply) => _replyToReview(doc.id, reply),
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getReviewsStream(String vendorId) {
    var query = FirebaseFirestore.instance
        .collection('reviews')
        .where('vendorId', isEqualTo: vendorId)
        .where('isApproved', isEqualTo: true);

    switch (_sortBy) {
      case 'highest':
        return query.orderBy('rating', descending: true).snapshots();
      case 'lowest':
        return query.orderBy('rating', descending: false).snapshots();
      default:
        return query.orderBy('createdAt', descending: true).snapshots();
    }
  }

  Future<void> _replyToReview(String reviewId, String reply) async {
    try {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(reviewId)
          .update({
        'vendorReply': reply,
        'repliedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reply posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_border,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reviews from users will appear here\nafter you complete events.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}