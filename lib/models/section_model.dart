// lib/models/section_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  final String id;
  final String eventTypeId;       // Link to event type
  final String name;              // Vidhi, Decoration, Food
  final String description;
  final String image;
  final String icon;
  final bool isRequired;          // Some sections may be mandatory
  final bool isActive;
  final int order;
  final DateTime? createdAt;

  Section({
    required this.id,
    required this.eventTypeId,
    required this.name,
    required this.description,
    this.image = '',
    this.icon = '',
    this.isRequired = false,
    this.isActive = true,
    this.order = 0,
    this.createdAt,
  });

  factory Section.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Section(
      id: doc.id,
      eventTypeId: data['eventTypeId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      icon: data['icon'] ?? '',
      isRequired: data['isRequired'] ?? false,
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventTypeId': eventTypeId,
      'name': name,
      'description': description,
      'image': image,
      'icon': icon,
      'isRequired': isRequired,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  Section copyWith({
    String? id,
    String? eventTypeId,
    String? name,
    String? description,
    String? image,
    String? icon,
    bool? isRequired,
    bool? isActive,
    int? order,
    DateTime? createdAt,
  }) {
    return Section(
      id: id ?? this.id,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      isRequired: isRequired ?? this.isRequired,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}