import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/service_model.dart';
import '../../models/subcategory_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';

class PackagesScreen extends StatefulWidget {
  final SubCategoryModel subCategory;

  const PackagesScreen({
    super.key,
    required this.subCategory,
  });

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchServices(widget.subCategory.id);
    });
  }

  void _showCategoryConflictDialog() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Switch Category?"),
        content: Text(
          "Your cart currently has items from the '${cart.selectedEventTypeName}' category. "
          "To select from '${widget.subCategory.name}', we need to clear your current selection. Continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cart cleared! You can now select from this category.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear & Continue", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategory.name),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _buildCartButton(context),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.services.isEmpty) {
            return const Center(child: Text("No packages available for this category."));
          }

          return Column(
            children: [
              _buildHeaderInfo(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.services.length,
                  itemBuilder: (context, index) {
                    final service = provider.services[index];
                    return _buildPackageCard(context, service);
                  },
                ),
              ),
              _buildBottomContinueBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return IconButton(
          icon: Badge(
            isLabelVisible: cart.items.isNotEmpty,
            label: Text(cart.items.length.toString()),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        );
      },
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1), Colors.white]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 36, color: AppColors.primary),
          const SizedBox(height: 12),
          const Text('Choose a Package', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Select one that suits your style and budget', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, ServiceModel service) {
    final cartProvider = Provider.of<CartProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    
    final bool isSelected = cartProvider.isServiceInCart(service.id);
    final String parentCatId = widget.subCategory.categoryId;
    final bool isAllowed = cartProvider.canAddService(parentCatId);

    // Find parent category name (e.g., Wedding, Birthday)
    String parentCategoryName = "Selected Category";
    try {
      parentCategoryName = categoryProvider.categories
          .firstWhere((c) => c.id == parentCatId)
          .name;
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade200, 
          width: isSelected ? 2 : 1
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                service.image, 
                width: 60, 
                height: 60, 
                fit: BoxFit.cover, 
                errorBuilder: (_, __, ___) => const Icon(Icons.image)
              ),
            ),
            title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Starting at ₹${service.basePrice.toStringAsFixed(0)}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.serviceDetail, arguments: {'service': service});
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSelected ? null : () {
                if (!isAllowed) {
                  _showCategoryConflictDialog();
                } else {
                  bool success = cartProvider.addItem(
                    service, 
                    parentCategoryId: parentCatId,
                    eventTypeName: parentCategoryName,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${service.name} added to cart!"), backgroundColor: Colors.green),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green : (isAllowed ? AppColors.primary : Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isSelected ? "Selected ✅" : (isAllowed ? "Select Package" : "LOCKED 🔒"),
                style: const TextStyle(color: Colors.white)
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomContinueBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.isEmpty) return const SizedBox.shrink();

        final bool isAllowed = cart.canAddService(widget.subCategory.categoryId);

        // ✅ Locked Category View (Orange Bar)
        if (!isAllowed) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE67E22), // Distinctive Orange Color
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Locked Category: You have selected the ${cart.selectedEventTypeName} category.",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                    child: const Text(
                      "View Cart",
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Standard "Proceed to Cart" Bar
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white, 
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Total Estimate", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('₹${cart.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, 
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Proceed to Cart →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}