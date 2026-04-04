import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CakeScreen extends StatelessWidget {
  const CakeScreen({super.key});

  static const String sectionId = 'birthday_cake';
  static const String sectionName = 'Cake';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CAKE SELECTIONS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> cakeItems = [
    StaticItem(
      id: 'ck_001',
      name: 'Chocolate Truffle',
      description: 'Layers of dark chocolate sponge with silky Belgian ganache.',
      price: 1800,
      image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=500&auto=format&fit=crop',
      features: ['Eggless', 'Fresh Cream', '1.5 kg'],
    ),
    StaticItem(
      id: 'ck_002',
      name: 'Custom Theme Cake',
      description: 'Handcrafted fondant cakes based on your choice of characters.',
      price: 3500,
      image: 'https://images.unsplash.com/photo-1535141192574-5d4897c12636?q=80&w=500&auto=format&fit=crop',
      features: ['Fondant Art', 'Thematic', '3 kg'],
    ),
    StaticItem(
      id: 'ck_003',
      name: 'Personalized Photo Cake',
      description: 'Delicious vanilla cream cake featuring your favorite memory.',
      price: 2200,
      image: 'https://i.pinimg.com/474x/c3/bd/3e/c3bd3e1632a68b25bcfba9c3145fadee.jpg',
      features: ['Edible Print', 'Any Image', '2 kg'],
    ),
    StaticItem(
      id: 'ck_004',
      name: 'Surprise Pinata Cake',
      description: 'Hard chocolate shell filled with treats and a hammer to break.',
      price: 2000,
      image: 'https://images.unsplash.com/photo-1621303837174-89787a7d4729?q=80&w=500&auto=format&fit=crop',
      features: ['Interactive', 'Filled with Candies', 'Hammer incl.'],
    ),
    StaticItem(
      id: 'ck_005',
      name: 'Classic Red Velvet',
      description: 'Vibrant red layers with smooth cream cheese frosting.',
      price: 2400,
      image: 'https://images.unsplash.com/photo-1586788680434-30d324b2d46f?q=80&w=500&auto=format&fit=crop',
      features: ['Cream Cheese', 'Premium', '1.5 kg'],
    ),
    StaticItem(
      id: 'ck_006',
      name: 'Two-Tier Designer Cake',
      description: 'Grand multi-level cake for milestone birthday celebrations.',
      price: 8000,
      image: 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?q=80&w=500&auto=format&fit=crop',
      features: ['2 Tier', 'Luxury Decor', '5 kg'],
    ),
    StaticItem(
      id: 'ck_007',
      name: 'Fresh Fruit Exotic',
      description: 'Light sponge loaded with seasonal fresh fruits and cream.',
      price: 1500,
      image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=500&auto=format&fit=crop',
      features: ['Healthy', 'Low Sugar', '1.5 kg'],
    ),
    StaticItem(
      id: 'ck_008',
      name: 'Rainbow Fun Cake',
      description: 'Colorful six-layer cake with fun sprinkles for kids.',
      price: 2800,
      image: 'https://www.kabhi-b.com/cdn/shop/files/RainbowThemeCreamCake.jpg?v=1741158626&width=1946',
      features: ['Kids Special', '6 Colors', '3 kg'],
    ),
    StaticItem(
      id: 'ck_009',
      name: 'Belgian Lotus Biscoff',
      description: 'Trendy biscoff spread cake with caramelized crunch.',
      price: 2600,
      image: 'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?q=80&w=500&auto=format&fit=crop',
      features: ['Biscoff Crunch', 'Matte Finish', '1.5 kg'],
    ),
    StaticItem(
      id: 'ck_010',
      name: 'KitKat & Gems Loaded',
      description: 'Surrounded by KitKat bars and topped with colorful gems.',
      price: 1900,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR26aZTtq_hNaSvDEmQs-tfobPQT6MA_NAd5A&s',
      features: ['Chocolate overload', 'Kids Favorite', '2 kg'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      appBar: AppBar(
        title: const Text('Birthday Cakes',
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
                      const Text('Cakes Selection', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
          // 🖼️ PORTRAIT IMAGE (Perfect for Tall Cakes)
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 175, color: Colors.indigo.shade50, child: const Icon(Icons.cake, color: Colors.indigo)),
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
                                  sectionId: CakeScreen.sectionId,
                                  sectionName: CakeScreen.sectionName,
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