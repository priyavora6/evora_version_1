// lib/models/event_type_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class EventType {
  final String id;
  final String name;
  final String description;
  final String image;
  final String icon;
  final bool isActive;
  final int order;
  final DateTime? createdAt;

  EventType({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.icon,
    this.isActive = true,
    this.order = 0,
    this.createdAt,
  });

  // From Firestore
  factory EventType.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventType(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      icon: data['icon'] ?? '',
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'icon': icon,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Copy with
  EventType copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? icon,
    bool? isActive,
    int? order,
    DateTime? createdAt,
  }) {
    return EventType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}