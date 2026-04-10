class CartItem {
  final String id;
  final String categoryId; // Level 1 Category ID
  final String subCategoryId; // Level 2 SubCategory ID (Added)
  final String name;
  final String image;
  final double price;
  final String subcategoryName;
  final String? selectedOptionName;
  int quantity;

  CartItem({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.image,
    required this.price,
    required this.subcategoryName,
    this.selectedOptionName,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'name': name,
      'image': image,
      'price': price,
      'subcategoryName': subcategoryName,
      'selectedOptionName': selectedOptionName,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      categoryId: map['categoryId'] ?? '',
      subCategoryId: map['subCategoryId'] ?? '',
      name: map['name'] ?? map['itemName'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      subcategoryName: map['subcategoryName'] ?? map['sectionName'] ?? '',
      selectedOptionName: map['selectedOptionName'],
      quantity: map['quantity'] ?? 1,
    );
  }
}
