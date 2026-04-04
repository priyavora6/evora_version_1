import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BabyShowerCakeScreen extends StatelessWidget {
  const BabyShowerCakeScreen({super.key});

  static const String sectionId = 'bs_cake';
  static const String sectionName = 'Cake';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BABY SHOWER CAKES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> cakeItems = [
    StaticItem(
      id: 'bsc_001',
      name: 'Pastel Baby Footprints',
      description: 'Cute buttercream cake decorated with little baby footprints.',
      price: 1500,
      image: 'https://i.pinimg.com/736x/e0/6e/46/e06e46718d67d148bfb94c4209bccb02.jpg',
      features: ['1 Kg', 'Custom Flavor', 'Eggless available'],
    ),
    StaticItem(
      id: 'bsc_002',
      name: 'Gender Reveal Pinata',
      description: 'Break the chocolate shell to reveal pink or blue candies inside.',
      price: 2500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHvQzfSH_6sdJanNyBBi0asqP9mftoTiiLag&s',
      features: ['Hammer Included', 'Color Reveal', '1.5 Kg'],
    ),
    StaticItem(
      id: 'bsc_003',
      name: 'Oh Baby! Two-Tier',
      description: 'Elegant two-tier cake with an acrylic "Oh Baby" golden topper.',
      price: 4500,
      image: 'https://m.media-amazon.com/images/I/618mI359d4L.jpg',
      features: ['3 Kg', 'Designer Look', 'Floral Accents'],
    ),
    StaticItem(
      id: 'bsc_004',
      name: 'Teddy Bear Fondant Cake',
      description: 'Adorable cake featuring a handcrafted edible fondant teddy bear.',
      price: 3200,
      image: 'https://alittlecake.com/wp-content/uploads/2024/03/Teddy-Bear-First-Birthday-Cake-With-Fondant-Ruffle-1.png',
      features: ['2 Kg', 'Fondant Art', 'Pastel Colors'],
    ),
    StaticItem(
      id: 'bsc_005',
      name: 'Royal Prince/Princess',
      description: 'Luxury design featuring a golden edible crown and quilted pattern.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk_G3V-_GfMvjH0iCHk1IwccmFSsZFa9qvOg&s',
      features: ['Crown Topper', 'Gold Detailing', '2.5 Kg'],
    ),
    StaticItem(
      id: 'bsc_006',
      name: 'Safari Jungle Theme',
      description: 'Fun cake topped with cute, edible sugar animals (Lion, Elephant).',
      price: 3800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsX6227w0JNZJwCAqAskRsD_2rI98_5OagFg&s',
      features: ['Animal Props', '2 Kg', 'Kids Favorite'],
    ),
    StaticItem(
      id: 'bsc_007',
      name: 'Stork & Baby Delivery',
      description: 'Classic theme cake with a stork carrying a baby bundle topper.',
      price: 2800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXTAfmB2L915Z0Dwcvw8Ty9tzGJGV_Pfvesg&s',
      features: ['Story Theme', 'Vanilla Base', '1.5 Kg'],
    ),
    StaticItem(
      id: 'bsc_008',
      name: 'Macaron & Floral Delight',
      description: 'Sophisticated cake decorated with fresh flowers and French macarons.',
      price: 4200,
      image: 'https://bakeoffcakes.in/wp-content/uploads/2024/07/Baby-Shower-Cake-with-Macroon.jpg',
      features: ['Real Flowers', 'Premium Macarons', '2 Kg'],
    ),
    StaticItem(
      id: 'bsc_009',
      name: 'Mini Bento Maternity Cake',
      description: 'Cute, trendy, small-sized cake perfect for an intimate family reveal.',
      price: 1200,
      image: 'https://yummycake.in/wp-content/uploads/2020/09/order-online-baby-shower-cake.png',
      features: ['500g', 'Trendy Design', 'Custom Text'],
    ),
    StaticItem(
      id: 'bsc_010',
      name: 'Twinkle Twinkle Little Star',
      description: 'Night sky themed cake with moon and stars for your little one.',
      price: 3500,
      image: 'https://i.pinimg.com/564x/ee/7b/15/ee7b153a4eb8bface8a5bac0d9c3f239.jpg',
      features: ['Star Props', 'Blue/Pink Galaxy', '2 Kg'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Baby Shower Cakes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E), // Midnight Indigo
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: cakeItems.length,
              itemBuilder: (context, index) => _CakeCard(item: cakeItems[index]),
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

class _CakeCard extends StatelessWidget {
  final StaticItem item;
  const _CakeCard({required this.item});

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
              width: 125,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.cake, color: Colors.indigo)),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(item.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),

                  // Feature Tags
                  Wrap(
                    spacing: 4, runSpacing: 4,
                    children: item.features.take(2).map((f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
                      child: Text(f, style: const TextStyle(fontSize: 8, color: Colors.indigo, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppStrings.rupee}${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green)),

                      // ✅ TOGGLE LOGIC: ADD <-> SELECTED
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final isInCart = cartProvider.isInCart(item.id);
                          return isInCart
                              ? GestureDetector(
                            onTap: () => cartProvider.removeItem(item.id),
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 30),
                                const Text("Selected", style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              cartProvider.addItem(CartItem(
                                  id: item.id,
                                  sectionId: BabyShowerCakeScreen.sectionId,
                                  sectionName: BabyShowerCakeScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1,
                                  image: item.image,
                                  type: 'item'
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('ADD', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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