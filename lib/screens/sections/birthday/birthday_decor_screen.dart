import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BirthdayDecorScreen extends StatelessWidget {
  const BirthdayDecorScreen({super.key});

  static const String sectionId = 'b_decor';
  static const String sectionName = 'Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BIRTHDAY DECORATION ITEMS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'bd_001',
      name: 'Classic Balloon Arch',
      description: 'Colorful double-layered balloon arch with name foil balloons.',
      price: 5000,
      image: 'https://m.media-amazon.com/images/I/71GSWq8rYRL._AC_UF1000,1000_QL80_.jpg',
      features: ['Arch Design', 'Name Foils', 'Setup incl.'],
    ),
    StaticItem(
      id: 'bd_002',
      name: 'Jungle Safari Theme',
      description: 'Greenery backdrop with animal cutouts and organic balloon vines.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4BSsSFhydxF1WM4OqXwGibNcV4hmX_IuZMQ&s',
      features: ['Animal Props', 'Leafy Decor', 'Photo Booth'],
    ),
    StaticItem(
      id: 'bd_003',
      name: 'Princess Castle Theme',
      description: 'Pink and gold royal castle backdrop with star fairy lights.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG4QBGB9-owzSXpl-h6BfWg0910GbWAxv36A&s',
      features: ['Castle Cutout', 'Fairy Lights', 'Carpet incl.'],
    ),
    StaticItem(
      id: 'bd_004',
      name: 'Superhero Universe',
      description: 'Action-packed comic style backdrop with city silhouette.',
      price: 14000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-RYZw2gtDXA1NQ5-xWPk7E734m0DXq72qQg&s',
      features: ['Comic Props', 'Bold Colors', 'Action Poses'],
    ),
    StaticItem(
      id: 'bd_005',
      name: 'Minimalist Pastel Decor',
      description: 'Elegant macaron-colored balloons with a simple circular ring.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhI28Mz1OzHOncqwWYtSmSMcs9TpTQFNj-BA&s',
      features: ['Pastel Theme', 'Gold Ring', 'Modern Style'],
    ),
    StaticItem(
      id: 'bd_006',
      name: 'Outer Space Theme',
      description: 'Dark blue chrome balloons with astronaut and rocket foils.',
      price: 11000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvY_3gP_C0l9tUEtt6uMpCiRLJ3Zyy1IkX8A&s',
      features: ['Chrome Effect', 'Rocket Props', 'LED Stars'],
    ),
    StaticItem(
      id: 'bd_007',
      name: 'Under the Sea Theme',
      description: 'Aquatic blue drapes with mermaid and fish balloon art.',
      price: 13000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI3PRJYC3BCBwMxwd7XTqzt52HKHyMQP9W9Q&s',
      features: ['Mermaid Tails', 'Ocean Props', 'Bubble Balloons'],
    ),
    StaticItem(
      id: 'bd_008',
      name: 'Boho Picnic Style',
      description: 'Teepee tents, floor cushions, and pampas grass decoration.',
      price: 18000,
      image: 'https://m.media-amazon.com/images/I/71glHrpY+BL.jpg',
      features: ['Teepee Tents', 'Floor Seating', 'Macramé'],
    ),
    StaticItem(
      id: 'bd_009',
      name: 'Glow in the Dark',
      description: 'Neon balloons and fluorescent streamers with UV lighting.',
      price: 10000,
      image: 'https://m.media-amazon.com/images/I/81JAn5LhQjL._AC_UF894,1000_QL80_.jpg',
      features: ['Neon Props', 'UV Lights', 'Party Vibe'],
    ),
    StaticItem(
      id: 'bd_010',
      name: 'Candy Land Fantasy',
      description: 'Giant lollipop cutouts and doughnut-shaped balloon pillars.',
      price: 16000,
      image: 'https://m.media-amazon.com/images/I/71uRoaCM5kL.jpg',
      features: ['Sweet Theme', 'Giant Props', 'Colorful'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Birthday Decoration',
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
              itemCount: decorItems.length,
              itemBuilder: (context, index) => _DecorCard(item: decorItems[index]),
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

class _DecorCard extends StatelessWidget {
  final StaticItem item;
  const _DecorCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.palette, color: Colors.indigo)),
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
                                  sectionId: BirthdayDecorScreen.sectionId,
                                  sectionName: BirthdayDecorScreen.sectionName,
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