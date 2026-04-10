import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String id;
  final String categoryId; // 👉 Links to Level 1
  final String name;
  final String description;
  final String image;
  final String emoji;

  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.image,
    required this.emoji,
  });

  factory SubCategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SubCategoryModel(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      // ✅ Handle both 'image' and 'imageUrl' to prevent empty URL errors
      image: data['image'] ?? data['imageUrl'] ?? '',
      emoji: data['emoji'] ?? '✨',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'image': image,
      'emoji': emoji,
    };
  }
}
