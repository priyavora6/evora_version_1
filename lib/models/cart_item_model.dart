// lib/models/cart_item_model.dart

class CartItem {
  final String id;
  final String sectionId;
  final String sectionName;
  final String itemName;
  final double price;
  final int quantity;
  final String image;
  final String type;              // 'item' or 'package' or 'food'

  CartItem({
    required this.id,
    required this.sectionId,
    required this.sectionName,
    required this.itemName,
    required this.price,
    this.quantity = 1,
    this.image = '',
    this.type = 'item',
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? sectionId,
    String? sectionName,
    String? itemName,
    double? price,
    int? quantity,
    String? image,
    String? type,
  }) {
    return CartItem(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sectionId': sectionId,
      'sectionName': sectionName,
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'image': image,
      'type': type,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      sectionId: map['sectionId'] ?? '',
      sectionName: map['sectionName'] ?? '',
      itemName: map['itemName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      image: map['image'] ?? '',
      type: map['type'] ?? 'item',
    );
  }
}