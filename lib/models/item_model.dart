// lib/models/item_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class SectionItem {
  final String id;
  final String sectionId;         // Link to section
  final String name;              // Mandap Setup, Pandit Fees, DJ
  final String description;
  final double price;
  final String image;
  final List<String> images;      // Multiple images
  final bool isActive;
  final int order;
  final DateTime? createdAt;

  SectionItem({
    required this.id,
    required this.sectionId,
    required this.name,
    required this.description,
    required this.price,
    this.image = '',
    this.images = const [],
    this.isActive = true,
    this.order = 0,
    this.createdAt,
  });

  factory SectionItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SectionItem(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'images': images,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  SectionItem copyWith({
    String? id,
    String? sectionId,
    String? name,
    String? description,
    double? price,
    String? image,
    List<String>? images,
    bool? isActive,
    int? order,
    DateTime? createdAt,
  }) {
    return SectionItem(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}