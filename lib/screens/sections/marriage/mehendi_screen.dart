import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class MarriageMehendiScreen extends StatelessWidget {
  const MarriageMehendiScreen({super.key});

  static const String sectionId = 'm_mehendi';
  static const String sectionName = 'Mehendi';

  static const List<StaticItem> mehendiItems = [
    StaticItem(
      id: 'meh_001',
      name: 'Full Bridal Mehendi',
      description: 'Intricate traditional designs up to elbows and feet for the bride.',
      price: 15000,
      image: 'https://i.pinimg.com/736x/d3/93/4d/d3934dc7eb09533e24ae828f9fa4785f.jpg', // Fixed missing URL
      features: ['Full Hand', 'Legs included', 'Organic Henna'],
    ),
    StaticItem(
      id: 'meh_002',
      name: 'Portrait Bridal Style',
      description: 'Customized mehendi featuring portraits of bride and groom.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBec9K-DKhsLHtkh0FjAqGAC5ztLvZNMHPIg&s',
      features: ['Portrait Art', 'Designer touch', '4-6 hours'],
    ),
    StaticItem(
      id: 'meh_003',
      name: 'Arabian Style Designs',
      description: 'Bold and stylish flowy patterns with thick outlines.',
      price: 8000,
      image: 'https://zerogravity.photography/wp-content/uploads/2025/08/mehendi_webp-1.webp',
      features: ['Bold Patterns', 'Fast application', 'Modern look'],
    ),
    StaticItem(
      id: 'meh_005',
      name: 'Moroccan Style Art',
      description: 'Geometric patterns and unique clean lines for a modern bride.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg6eJTQujdgdiyUlXsu09-iyJvz-oBraLTDw&s',
      features: ['Geometric', 'No florals', 'Crisp Finish'],
    ),
    StaticItem(
      id: 'meh_007',
      name: 'Lotus Motif Traditional',
      description: 'Beautiful lotus and peacock patterns symbolizing purity.',
      price: 9500,
      image: 'https://i.pinimg.com/736x/f9/04/e2/f904e27b498ae5fe13a83a2c9b526496.jpg',
      features: ['Lotus Patterns', 'Heavy Shading', 'Traditional'],
    ),
    StaticItem(
      id: 'meh_009',
      name: 'Indo-Arabic Fusion',
      description: 'Mix of traditional Indian patterns with Arabic negative spacing.',
      price: 9000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmJPO2As9b9k5BSYOkRVrZlrAhUT8ctYdeQw&s',
      features: ['Fusion style', 'Floral & Bold', 'Both hands'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Wedding Mehendi',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [_buildCartBadge(context)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mehendiItems.length,
              itemBuilder: (context, index) => _MehendiCard(item: mehendiItems[index]),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildCartBadge(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        int count = cart.items.length;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
              if (count > 0)
                Positioned(
                  right: 6, top: 8,
                  child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold))),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final total = cart.getSectionTotal(sectionId);
        if (total <= 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total Selection', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${AppStrings.rupee}${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: const Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MehendiCard extends StatelessWidget {
  final StaticItem item;
  const _MehendiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ PORTRAIT IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 130,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 130, height: 180, color: Colors.indigo.shade50),
            ),
          ),

          // 📝 CONTENT SECTION
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(item.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),

                  // Feature Tags
                  Wrap(
                    spacing: 4, runSpacing: 4,
                    children: item.features.take(2).map((f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
                      child: Text(f, style: const TextStyle(fontSize: 9, color: Colors.indigo, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppStrings.rupee}${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green)),

                      // ✅ UPDATED TOGGLE LOGIC: ADD <-> SELECTED
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final isInCart = cartProvider.isInCart(item.id);

                          return isInCart
                              ? GestureDetector(
                            // 🟢 Click the Tick to REMOVE (Toggle back to Add)
                            onTap: () => cartProvider.removeItem(item.id),
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                                const Text("Selected", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                              : GestureDetector(
                            // 🔵 Click ADD to join the cart
                            onTap: () {
                              cartProvider.addItem(CartItem(
                                  id: item.id,
                                  sectionId: MarriageMehendiScreen.sectionId,
                                  sectionName: MarriageMehendiScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1,
                                  image: item.image,
                                  type: 'item'
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('ADD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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