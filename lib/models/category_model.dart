import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final String icon;
  final String description;
  final String imageUrl;
  final int order;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.emoji = '✨',
    required this.icon,
    required this.description,
    this.imageUrl = '',
    this.order = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      emoji: data['emoji'] ?? '✨',
      icon: data['icon'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'emoji': emoji,
      'icon': icon,
      'description': description,
      'imageUrl': imageUrl,
      'order': order,
      'isActive': isActive,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? emoji,
    String? icon,
    String? description,
    String? imageUrl,
    int? order,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, emoji: $emoji, imageUrl: $imageUrl)';
  }
}
