import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class MarriageMakeupScreen extends StatelessWidget {
  const MarriageMakeupScreen({super.key});

  static const String sectionId = 'makeup';
  static const String sectionName = 'Makeup';

  static const List<StaticItem> makeupItems = [
    StaticItem(
      id: 'mu_001',
      name: 'Bridal HD Makeup',
      description: 'Traditional heavy bridal look using High Definition products for camera-ready finish.',
      price: 25000,
      image: 'https://i.pinimg.com/originals/4a/eb/3b/4aeb3b1690a6e0c375a4febf9de12f27.jpg',
      features: ['HD Products', 'Lashes included', '6-hour stay'],
    ),
    StaticItem(
      id: 'mu_002',
      name: 'Bridal Airbrush Makeup',
      description: 'Premium lightweight airbrush finish for a flawless, waterproof, and matte look.',
      price: 45000,
      image: 'https://media6.ppl-media.com/mediafiles/blogs/shutterstock_1925473556_2d9c057935.jpg',
      features: ['Waterproof', 'Celebrity Stylist', 'Flawless Base'],
    ),
    StaticItem(
      id: 'mu_003',
      name: 'Groom Royal Styling',
      description: 'Professional grooming, hair styling, and basic touch-up for the groom.',
      price: 12000,
      image: 'https://img.perniaspopupshop.com/catalog/product/z/o/ZOOP102448_1.jpg?impolicy=detailimageprod',
      features: ['Beard Styling', 'Skin Prep', 'Hair Set'],
    ),
    StaticItem(
      id: 'mu_004',
      name: 'Sangeet Glam Look',
      description: 'Shimmery and vibrant makeup perfect for evening dance performances.',
      price: 18000,
      image: 'https://i.pinimg.com/736x/93/63/88/93638818b4fa7b64dd8d1e465ae60081.jpg',
      features: ['Glitter Eyes', 'Heavy Contour', 'Fancy Bun'],
    ),
    StaticItem(
      id: 'mu_006',
      name: 'Reception High-Glam',
      description: 'Modern sophisticated look with bold lips and sleek hairstyle.',
      price: 22000,
      image: 'https://img.weddingbazaar.com/photos/pictures/000/722/501/new_medium/through_the_barrel.jpg?1550659283',
      features: ['Bold Style', 'Sleek Hair', 'False Lashes'],
    ),
    StaticItem(
      id: 'mu_008',
      name: 'Saree & Dupatta Draping',
      description: 'Professional draping service to ensure your attire looks perfect all day.',
      price: 3000,
      image: 'https://i.pinimg.com/736x/1a/e3/b1/1ae3b1101145eae92de065074bdd6d25.jpg',
      features: ['Safety Pins incl.', 'Pleat Setting', 'All Styles'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // ─── CLEAN INDIGO APPBAR ───
      appBar: AppBar(
        title: const Text('Makeup & Styling',
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
          // 🛑 Header Banner Removed for simplicity
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: makeupItems.length,
              itemBuilder: (context, index) => _MakeupCard(item: makeupItems[index]),
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

class _MakeupCard extends StatelessWidget {
  final StaticItem item;
  const _MakeupCard({required this.item});

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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 125,
              height: 175,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 125, height: 175, color: Colors.indigo.shade50),
            ),
          ),

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
                                  sectionId: MarriageMakeupScreen.sectionId,
                                  sectionName: MarriageMakeupScreen.sectionName,
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