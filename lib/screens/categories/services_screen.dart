import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/category_model.dart';
import '../../models/subcategory_model.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';

class ServicesScreen extends StatefulWidget {
  final SubCategoryModel subcategory;
  final CategoryModel category;

  const ServicesScreen({
    super.key,
    required this.subcategory,
    required this.category,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _searchQuery = '';
  final List<String> _foodCategories = [
    'All', 'Starters', 'Punjabi', 'Chinese', 'South Indian', 'Continental',
    'Tandoor & Breads', 'Biryani & Rice', 'Dal & Curry', 'Soups', 'Salads',
    'Desserts', 'Ice Cream', 'Beverages', 'Chaat', 'Live Counters',
  ];

  bool get isFoodSubcategory => widget.subcategory.id.endsWith('_food') || widget.subcategory.id == 'food_menu';

  @override
  void initState() {
    super.initState();
    if (isFoodSubcategory) {
      _tabController = TabController(length: _foodCategories.length, vsync: this);
      _tabController!.addListener(() {
        setState(() {});
      });
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchServices(widget.subcategory.id);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<ServiceModel> _getFilteredServices(List<ServiceModel> allServices) {
    List<ServiceModel> filtered = allServices;

    if (isFoodSubcategory && _tabController != null) {
      String selectedCat = _foodCategories[_tabController!.index];
      if (selectedCat != 'All') {
        filtered = filtered.where((s) => s.tags.contains(selectedCat)).toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) =>
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  void _showConflictDialog(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Switch Event Type?"),
        content: Text("Your cart is currently locked to '${cart.selectedEventTypeName}'. Adding services from '${widget.category.name}' will clear your current cart. Continue?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cart cleared! You can now add items from this category.")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear & Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.subcategory.name, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: cart.items.isNotEmpty,
                  label: Text(cart.items.length.toString()),
                  child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                ),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer2<CategoryProvider, CartProvider>(
        builder: (context, provider, cartProvider, child) {
          final services = _getFilteredServices(provider.services);
          final bool isLocked = !cartProvider.isEmpty && !cartProvider.canAddService(widget.category.id);

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Orange Notification Banner for locked state
              if (isLocked)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.orange.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.orange.shade800, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Locked to ${cartProvider.selectedEventTypeName}. Clear cart to add these.",
                          style: TextStyle(color: Colors.orange.shade900, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () => cartProvider.clearCart(),
                        child: Text("CLEAR", style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

              if (isFoodSubcategory) _buildSearchBar(),
              if (isFoodSubcategory)
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: const Color(0xFF1A237E),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF1A237E),
                    tabs: _foodCategories.map((cat) => Tab(text: cat)).toList(),
                  ),
                ),
              Expanded(
                child: services.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: services.length,
                        itemBuilder: (context, index) => _ServiceHorizontalCard(
                          service: services[index],
                          isFood: isFoodSubcategory,
                          parentCategoryId: widget.category.id, 
                          parentCategoryName: widget.category.name,
                          onConflict: () => _showConflictDialog(context),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: isFoodSubcategory ? _buildFoodBottomBar() : null,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search dishes...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.eco, color: Colors.green, size: 20),
                  SizedBox(width: 6),
                  Text('100% Veg', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              Consumer<CartProvider>(
                builder: (context, cart, child) => Text('${cart.guestCount} Guests', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No items in this category' : 'No items matching "$_searchQuery"',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final foodItems = cart.items.where((i) => i.subCategoryId == widget.subcategory.id).toList();
        if (foodItems.isEmpty) return const SizedBox.shrink();
        
        double total = 0;
        for (var item in foodItems) {
          total += (item.price * cart.guestCount);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${foodItems.length} items added', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${total.toStringAsFixed(0)} total', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('VIEW CART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceHorizontalCard extends StatelessWidget {
  final ServiceModel service;
  final bool isFood;
  final String parentCategoryId;
  final String parentCategoryName;
  final VoidCallback onConflict;

  const _ServiceHorizontalCard({
    required this.service, 
    required this.isFood, 
    required this.parentCategoryId,
    required this.parentCategoryName,
    required this.onConflict
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: SizedBox(
              width: 130,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: service.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey.shade100),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: Center(child: Text(service.emoji.isNotEmpty ? service.emoji : '✨', style: const TextStyle(fontSize: 35))),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${service.basePrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFood ? Colors.green : const Color(0xFF1A237E),
                        ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final bool isInCart = cart.isServiceInCart(service.id);
                          final bool isAllowed = cart.canAddService(parentCategoryId);

                          return ElevatedButton(
                            onPressed: () {
                              if (isInCart) {
                                cart.removeItem(service.id);
                              } else if (!isAllowed) {
                                onConflict();
                              } else {
                                cart.addItem(
                                  service, 
                                  parentCategoryId: parentCategoryId,
                                  eventTypeName: parentCategoryName,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInCart ? Colors.grey.shade200 : (isAllowed ? (isFood ? Colors.green : const Color(0xFF1A237E)) : Colors.grey),
                              foregroundColor: isInCart ? Colors.black87 : Colors.white,
                              elevation: 0,
                              minimumSize: const Size(80, 36),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: Text(
                              isInCart ? 'ADDED' : (isAllowed ? 'ADD' : 'LOCKED 🔒'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
