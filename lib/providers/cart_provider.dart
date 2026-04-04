// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _selectedEventTypeId;
  String? _selectedEventTypeName;
  int _guestCount = 100;

  List<CartItem> get items => _items;
  String? get selectedEventTypeId => _selectedEventTypeId;
  String? get selectedEventTypeName => _selectedEventTypeName;
  int get guestCount => _guestCount;

  // Calculate total price
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      if (item.type == 'food') {
        total += item.price * _guestCount;
      } else {
        total += item.totalPrice;
      }
    }
    return total;
  }

  // Get items count
  int get itemCount => _items.length;

  // Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  // Set event type
  void setEventType(String eventTypeId, String eventTypeName) {
    _selectedEventTypeId = eventTypeId;
    _selectedEventTypeName = eventTypeName;
    notifyListeners();
  }

  // Set guest count
  void setGuestCount(int count) {
    _guestCount = count;
    notifyListeners();
  }

  // Add item to cart
  void addItem(CartItem item) {
    // Check if item already exists
    int existingIndex = _items.indexWhere((i) => i.id == item.id);

    if (existingIndex != -1) {
      // Update quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String itemId, int quantity) {
    int index = _items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  // Check if item is in cart
  bool isInCart(String itemId) {
    return _items.any((item) => item.id == itemId);
  }

  // Get item from cart
  CartItem? getItem(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  // Get items by section
  List<CartItem> getItemsBySection(String sectionId) {
    return _items.where((item) => item.sectionId == sectionId).toList();
  }

  // Get section total
  double getSectionTotal(String sectionId) {
    List<CartItem> sectionItems = getItemsBySection(sectionId);
    double total = 0.0;

    for (var item in sectionItems) {
      if (item.type == 'food') {
        total += item.price * _guestCount;
      } else {
        total += item.totalPrice;
      }
    }

    return total;
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _selectedEventTypeId = null;
    _selectedEventTypeName = null;
    _guestCount = 100;
    notifyListeners();
  }

  // Get price breakdown by section
  Map<String, double> getPriceBreakdown() {
    Map<String, double> breakdown = {};

    for (var item in _items) {
      String sectionName = item.sectionName;
      double itemTotal = item.type == 'food'
          ? item.price * _guestCount
          : item.totalPrice;

      if (breakdown.containsKey(sectionName)) {
        breakdown[sectionName] = breakdown[sectionName]! + itemTotal;
      } else {
        breakdown[sectionName] = itemTotal;
      }
    }

    return breakdown;
  }
}