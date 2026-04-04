import 'package:flutter/foundation.dart';

@immutable
class StaticPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final String badge;
  final List<String> features;


  const StaticPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.images,
    required this.badge,
    required this.features,
  });
}
