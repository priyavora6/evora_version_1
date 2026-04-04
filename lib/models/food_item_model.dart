// lib/models/food_item_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String eventTypeId;
  final String category;          // Starter, Main Course, Dessert
  final String name;              // Paneer Tikka, Dal Makhani
  final double pricePerPlate;
  final String image;
  final bool isVeg;
  final bool isActive;
  final int order;
  final DateTime? createdAt;

  FoodItem({
    required this.id,
    required this.eventTypeId,
    required this.category,
    required this.name,
    required this.pricePerPlate,
    this.image = '',
    this.isVeg = true,
    this.isActive = true,
    this.order = 0,
    this.createdAt,
  });

  factory FoodItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      eventTypeId: data['eventTypeId'] ?? '',
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      pricePerPlate: (data['pricePerPlate'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      isVeg: data['isVeg'] ?? true,
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventTypeId': eventTypeId,
      'category': category,
      'name': name,
      'pricePerPlate': pricePerPlate,
      'image': image,
      'isVeg': isVeg,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  FoodItem copyWith({
    String? id,
    String? eventTypeId,
    String? category,
    String? name,
    double? pricePerPlate,
    String? image,
    bool? isVeg,
    bool? isActive,
    int? order,
    DateTime? createdAt,
  }) {
    return FoodItem(
      id: id ?? this.id,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      category: category ?? this.category,
      name: name ?? this.name,
      pricePerPlate: pricePerPlate ?? this.pricePerPlate,
      image: image ?? this.image,
      isVeg: isVeg ?? this.isVeg,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}