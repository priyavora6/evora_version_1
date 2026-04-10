import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import 'subcategories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Event Type', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<CategoryProvider, CartProvider>(
        builder: (context, categoryProvider, cartProvider, child) {
          if (categoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categoryProvider.categories.isEmpty) {
            return const Center(child: Text("No categories found."));
          }

          final hasItemsInCart = cartProvider.items.isNotEmpty;
          final lockedCategoryId = cartProvider.selectedParentCategoryId;
          final lockedCategoryName = cartProvider.selectedEventTypeName;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orange Notification Banner
              if (hasItemsInCart)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.orange.shade200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade800, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You're currently planning a $lockedCategoryName. Clear your cart if you'd like to plan a different event type.",
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showClearCartDialog(context, cartProvider);
                        },
                        child: Text(
                          "Clear Cart",
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  "What are we planning?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Select a category to see specialized services",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.72, 
                  ),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    final isLocked = hasItemsInCart && lockedCategoryId != category.id;
                    
                    return _CategoryCard(
                      category: category, 
                      isLocked: isLocked,
                      lockedCategoryName: lockedCategoryName,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart?"),
        content: const Text("Changing the event type will remove all currently selected services from your cart."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text("CLEAR CART", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isLocked;
  final String? lockedCategoryName;

  const _CategoryCard({
    required this.category, 
    this.isLocked = false,
    this.lockedCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          _showLockedDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubcategoriesScreen(category: category),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: isLocked ? Border.all(color: Colors.grey.withOpacity(0.2), width: 1) : null,
        ),
        child: Opacity(
          opacity: isLocked ? 0.6 : 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image Section
              Expanded(
                flex: 12,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey.shade50,
                        child: category.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                errorWidget: (context, url, error) => Center(
                                  child: Text(category.emoji, style: const TextStyle(fontSize: 40)),
                                ),
                              )
                            : Center(
                                child: Text(category.emoji, style: const TextStyle(fontSize: 40)),
                              ),
                      ),
                    ),
                    if (isLocked)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.lock_outline, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Text Content Section
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange.shade800),
            const SizedBox(width: 10),
            const Text("Category Locked"),
          ],
        ),
        content: Text(
          "You currently have services for '$lockedCategoryName' in your cart. "
          "You can only select services from one main category at a time.\n\n"
          "Please complete your current booking or clear your cart to select this category.",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OKAY"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.cart);
            },
            child: const Text("VIEW CART"),
          ),
        ],
      ),
    );
  }
}
