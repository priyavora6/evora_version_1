import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/service_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  int _guestCount = 1;
  String? _selectedParentCategoryId; 
  String? _selectedEventTypeName;

  List<CartItem> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;
  int get guestCount => _guestCount;
  
  String? get selectedEventTypeId => _selectedParentCategoryId;
  String? get selectedEventTypeName => _selectedEventTypeName;
  String? get selectedParentCategoryId => _selectedParentCategoryId;

  bool isServiceInCart(String serviceId) {
    return _items.any((item) => item.id.startsWith(serviceId));
  }

  bool canAddService(String parentCategoryId) {
    if (_items.isEmpty) return true;
    return _selectedParentCategoryId == parentCategoryId;
  }

  bool addItem(ServiceModel service, {required String parentCategoryId, OptionModel? option, int qty = 1, String? eventTypeName}) {
    
    if (!canAddService(parentCategoryId)) {
      return false;
    }

    if (_items.isEmpty) {
      _selectedParentCategoryId = parentCategoryId;
      _selectedEventTypeName = eventTypeName ?? parentCategoryId.toUpperCase();
    }

    double finalPrice = service.basePrice + (option?.extraPrice ?? 0);

    _items.add(CartItem(
      id: service.id + (option?.id ?? ''),
      categoryId: parentCategoryId,
      subCategoryId: service.subCategoryId,
      name: service.name,
      image: service.image,
      price: finalPrice,
      subcategoryName: eventTypeName ?? service.subCategoryId,
      selectedOptionName: option?.name,
      quantity: qty,
    ));
    
    notifyListeners();
    return true;
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id.startsWith(id));

    if (_items.isEmpty) {
      _selectedParentCategoryId = null;
      _selectedEventTypeName = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _selectedParentCategoryId = null;
    _selectedEventTypeName = null;
    notifyListeners();
  }

  void setGuestCount(int count) {
    _guestCount = count;
    notifyListeners();
  }

  // Updated logic: Food items (those ending with _food) are multiplied by guest count.
  // Other services (Photography, Decor, etc.) are a flat price.
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      if (item.subCategoryId.endsWith('_food') || item.subCategoryId == 'food_menu') {
        total += (item.price * _guestCount);
      } else {
        total += item.price;
      }
    }
    return total;
  }

  Map<String, double> getPriceBreakdown() => {"Subtotal": totalPrice};
}
