// lib/models/review_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;

  // Who & What
  final String eventId;              // Which event this review is for
  final String vendorId;             // Which vendor is being reviewed
  final String userId;               // Who wrote the review

  // User Info (for display)
  final String userName;
  final String userProfileImage;

  // Vendor Info (for reference)
  final String vendorName;
  final String serviceType;          // What service they provided

  // Review Content
  final double rating;               // 1.0 to 5.0
  final String comment;
  final List<String> images;         // Optional review images

  // Vendor Response
  final String? vendorReply;
  final DateTime? repliedAt;

  // Status & Moderation
  final bool isApproved;             // Admin can moderate reviews
  final bool isReported;
  final String? reportReason;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.eventId,
    required this.vendorId,
    required this.userId,
    required this.userName,
    this.userProfileImage = '',
    required this.vendorName,
    required this.serviceType,
    required this.rating,
    required this.comment,
    this.images = const [],
    this.vendorReply,
    this.repliedAt,
    this.isApproved = true,
    this.isReported = false,
    this.reportReason,
    required this.createdAt,
    this.updatedAt,
  });

  // Helper getters
  bool get hasReply => vendorReply != null && vendorReply!.isNotEmpty;
  bool get hasImages => images.isNotEmpty;

  // Get star rating as int
  int get starRating => rating.round();

  // Check if rating is excellent (4.5+)
  bool get isExcellent => rating >= 4.5;

  // Check if rating is good (3.5+)
  bool get isGood => rating >= 3.5;

  // Check if rating is poor (<3.0)
  bool get isPoor => rating < 3.0;

  // Create from Firestore
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      eventId: data['eventId'] ?? '',
      vendorId: data['vendorId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userProfileImage: data['userProfileImage'] ?? '',
      vendorName: data['vendorName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      images: data['images'] != null
          ? List<String>.from(data['images'])
          : [],
      vendorReply: data['vendorReply'],
      repliedAt: (data['repliedAt'] as Timestamp?)?.toDate(),
      isApproved: data['isApproved'] ?? true,
      isReported: data['isReported'] ?? false,
      reportReason: data['reportReason'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Create from Map
  factory ReviewModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ReviewModel(
      id: documentId,
      eventId: data['eventId'] ?? '',
      vendorId: data['vendorId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userProfileImage: data['userProfileImage'] ?? '',
      vendorName: data['vendorName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      images: data['images'] != null
          ? List<String>.from(data['images'])
          : [],
      vendorReply: data['vendorReply'],
      repliedAt: data['repliedAt'] != null
          ? (data['repliedAt'] as Timestamp).toDate()
          : null,
      isApproved: data['isApproved'] ?? true,
      isReported: data['isReported'] ?? false,
      reportReason: data['reportReason'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'vendorId': vendorId,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'vendorName': vendorName,
      'serviceType': serviceType,
      'rating': rating,
      'comment': comment,
      'images': images,
      'vendorReply': vendorReply,
      'repliedAt': repliedAt != null ? Timestamp.fromDate(repliedAt!) : null,
      'isApproved': isApproved,
      'isReported': isReported,
      'reportReason': reportReason,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'vendorId': vendorId,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'vendorName': vendorName,
      'serviceType': serviceType,
      'rating': rating,
      'comment': comment,
      'images': images,
      'vendorReply': vendorReply,
      'repliedAt': repliedAt?.toIso8601String(),
      'isApproved': isApproved,
      'isReported': isReported,
      'reportReason': reportReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with
  ReviewModel copyWith({
    String? id,
    String? eventId,
    String? vendorId,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? vendorName,
    String? serviceType,
    double? rating,
    String? comment,
    List<String>? images,
    String? vendorReply,
    DateTime? repliedAt,
    bool? isApproved,
    bool? isReported,
    String? reportReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      vendorId: vendorId ?? this.vendorId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      vendorName: vendorName ?? this.vendorName,
      serviceType: serviceType ?? this.serviceType,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      vendorReply: vendorReply ?? this.vendorReply,
      repliedAt: repliedAt ?? this.repliedAt,
      isApproved: isApproved ?? this.isApproved,
      isReported: isReported ?? this.isReported,
      reportReason: reportReason ?? this.reportReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Add vendor reply
  ReviewModel addReply(String reply) {
    return copyWith(
      vendorReply: reply,
      repliedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Report review
  ReviewModel report(String reason) {
    return copyWith(
      isReported: true,
      reportReason: reason,
      updatedAt: DateTime.now(),
    );
  }

  // Approve review (admin)
  ReviewModel approve() {
    return copyWith(
      isApproved: true,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, vendor: $vendorName, rating: $rating, user: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}