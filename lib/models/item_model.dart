import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String serviceId; // 👉 Links to Level 3
  final String title;
  final String price;
  final String imageUrl;
  final String description;

  ItemModel({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      title: data['title'] ?? '',
      price: data['price']?.toString() ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
