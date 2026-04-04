// lib/models/static_item_model.dart

class StaticItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final bool isAssetImage;
  final List<String> features;

  const StaticItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.images = const [],
    this.isAssetImage = true,
    this.features = const [],
  });
}

// 🔥 MAKE SURE THIS CLASS IS HERE:
class StaticPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final bool isAssetImage;
  final List<String> features;
  final String badge;

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