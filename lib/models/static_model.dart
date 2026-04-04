// lib/models/static_item_model.dart

class StaticItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;              // Asset path or network URL
  final List<String> images;       // Multiple images
  final bool isAssetImage;         // true = asset, false = network
  final List<String> features;
  final String? badge;

  const StaticItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.images = const [],
    this.isAssetImage = true,
    this.features = const [],
    this.badge,
  });
}

class StaticPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final bool isAssetImage;
  final List<String> features;
  final String badge;              // "Budget Friendly", "Most Popular", etc.

  const StaticPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.images = const [],
    this.isAssetImage = true,
    this.features = const [],
    this.badge = '',
  });
}