import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final bool isVendorSide;
  final String? relatedId;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.isVendorSide = false,
    this.relatedId,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'general',
      isRead: data['isRead'] ?? false,
      isVendorSide: data['isVendorSide'] ?? false,
      relatedId: data['relatedId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id, userId: userId, title: title, message: message,
      type: type, isRead: isRead ?? this.isRead,
      isVendorSide: isVendorSide, relatedId: relatedId, createdAt: createdAt,
    );
  }
}