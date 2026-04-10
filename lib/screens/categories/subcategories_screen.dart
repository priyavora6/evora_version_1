import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/category_model.dart';
import '../../models/subcategory_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';
import 'services_screen.dart';

class SubcategoriesScreen extends StatefulWidget {
  final CategoryModel category;

  const SubcategoriesScreen({super.key, required this.category});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false)
          .fetchSubcategories(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.category.name} Services', 
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
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.subcategories.isEmpty) {
            return const Center(child: Text('No sections found for this event'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.subcategories.length,
            itemBuilder: (context, index) => _SubcategoryHorizontalCard(
              subcategory: provider.subcategories[index],
              category: widget.category,
            ),
          );
        },
      ),
    );
  }
}

class _SubcategoryHorizontalCard extends StatelessWidget {
  final SubCategoryModel subcategory;
  final CategoryModel category;

  const _SubcategoryHorizontalCard({required this.subcategory, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServicesScreen(
            subcategory: subcategory,
            category: category,
          ),
        ),
      ),
      child: Container(
        height: 120,
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
            // Left Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: SizedBox(
                width: 120,
                height: double.infinity,
                child: subcategory.image.isNotEmpty 
                  ? CachedNetworkImage(
                      imageUrl: subcategory.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade100),
                      errorWidget: (context, url, error) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
              ),
            ),
            
            // Right Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subcategory.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subcategory.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF1A237E)),
                        const SizedBox(width: 6),
                        Text(
                          "Explore Options",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A237E).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Text(subcategory.emoji, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
