// lib/models/package_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Package {
  final String id;
  final String sectionId;         // Link to Decoration section
  final String eventTypeId;       // Link to event type
  final String name;              // Basic, Premium, Royal
  final String description;
  final double price;
  final List<String> images;      // Package images
  final List<String> features;    // List of included features
  final bool isActive;
  final int order;
  final DateTime? createdAt;

  Package({
    required this.id,
    required this.sectionId,
    required this.eventTypeId,
    required this.name,
    required this.description,
    required this.price,
    this.images = const [],
    this.features = const [],
    this.isActive = true,
    this.order = 0,
    this.createdAt,
  });

  factory Package.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Package(
      id: doc.id,
      sectionId: data['sectionId'] ?? '',
      eventTypeId: data['eventTypeId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      features: List<String>.from(data['features'] ?? []),
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sectionId': sectionId,
      'eventTypeId': eventTypeId,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'features': features,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  Package copyWith({
    String? id,
    String? sectionId,
    String? eventTypeId,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    List<String>? features,
    bool? isActive,
    int? order,
    DateTime? createdAt,
  }) {
    return Package(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}