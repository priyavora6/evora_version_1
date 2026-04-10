import 'package:cloud_firestore/cloud_firestore.dart';

class OptionModel {
  final String id;
  final String name;
  final String description;
  final double extraPrice;

  OptionModel({required this.id, required this.name, required this.description, required this.extraPrice});

  factory OptionModel.fromMap(Map<String, dynamic> data) {
    return OptionModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      extraPrice: (data['extraPrice'] ?? 0).toDouble(),
    );
  }
}

class ServiceModel {
  final String id;
  final String categoryId;
  final String subCategoryId;
  final String name;
  final String description;
  final double basePrice;
  final String priceUnit;
  final String image;
  final String emoji;
  final List<String> tags;
  final List<OptionModel> options;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.priceUnit,
    required this.image,
    required this.emoji,
    required this.tags,
    required this.options,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    double extractedPrice = 0;
    if (data['price'] != null) {
      extractedPrice = (data['price'] as num).toDouble();
    } else if (data['basePrice'] != null) {
      extractedPrice = (data['basePrice'] as num).toDouble();
    } else if (data['priceRange'] != null) {
      String priceStr = data['priceRange'].toString().replaceAll(',', '');
      final match = RegExp(r'(\d+)').firstMatch(priceStr);
      if (match != null) {
        extractedPrice = double.tryParse(match.group(0) ?? '0') ?? 0;
      }
    }
    
    // Auto-add food category to tags if present
    List<String> tags = List<String>.from(data['tags'] ?? []);
    if (data['foodCategory'] != null && !tags.contains(data['foodCategory'])) {
      tags.add(data['foodCategory']);
    }

    return ServiceModel(
      id: doc.id,
      categoryId: data['parentCategoryId'] ?? '',
      subCategoryId: data['categoryId'] ?? '',    
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      basePrice: extractedPrice,
      priceUnit: data['priceUnit'] ?? (data['priceRange'] != null ? 'Starting price' : '/-'),
      image: data['imageUrl'] ?? data['image'] ?? '', 
      emoji: data['emoji'] ?? '',
      tags: tags,
      options: (data['options'] as List<dynamic>? ?? [])
          .map((o) => OptionModel.fromMap(o as Map<String, dynamic>))
          .toList(),
    );
  }
}
