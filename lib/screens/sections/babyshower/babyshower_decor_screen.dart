
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BabyShowerDecorScreen extends StatelessWidget {
  const BabyShowerDecorScreen({super.key});

  static const String sectionId = 'bs_decor';
  static const String sectionName = 'Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BABY SHOWER DECORATIONS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'bsd_001',
      name: 'Pastel Gender Neutral Theme',
      description: 'Elegant setup with mint, yellow, and peach balloons and florals.',
      price: 8500,
      image: 'https://m.media-amazon.com/images/I/71vK2KC2TLL._AC_UF894,1000_QL80_.jpg',
      features: ['Pastel Balloons', 'Oh Baby Neon', 'Cake Table'],
    ),
    StaticItem(
      id: 'bsd_002',
      name: 'It\'s a Boy! Blue Theme',
      description: 'Classic blue and white decor with silver accents and baby props.',
      price: 8000,
      image: 'https://m.media-amazon.com/images/I/61rx7NG8IaL._AC_UF1000,1000_QL80_.jpg',
      features: ['Blue Garland', 'Welcome Board', 'Boy Props'],
    ),
    StaticItem(
      id: 'bsd_003',
      name: 'It\'s a Girl! Pink Theme',
      description: 'Beautiful pink and rose gold setup with floral arrangements.',
      price: 8000,
      image: 'https://m.media-amazon.com/images/I/71RqxsISBnL.jpg',
      features: ['Pink Balloons', 'Floral Decor', 'Girl Props'],
    ),
    StaticItem(
      id: 'bsd_004',
      name: 'Jungle Safari Adventure',
      description: 'Fun and wild theme featuring animal cutouts, vines, and green balloons.',
      price: 12000,
      image: 'https://m.media-amazon.com/images/I/81oR27-AYzL.jpg',
      features: ['Animal Cutouts', 'Greenery', 'Photo Booth'],
    ),
    StaticItem(
      id: 'bsd_005',
      name: 'Teddy Bear Picnic',
      description: 'Adorable setup with giant teddy bears, floor seating, and pampas grass.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6Iiw7bq0f1dDeTs3WB7ruRqlN2DPQVqDKoA&s',
      features: ['Giant Teddies', 'Boho Seating', 'Warm Lights'],
    ),
    StaticItem(
      id: 'bsd_006',
      name: 'Royal Prince/Princess',
      description: 'Luxurious gold and white setup with crown motifs and velvet drapes.',
      price: 25000,
      image: 'https://m.media-amazon.com/images/I/81ucns4b1HL._AC_UF1000,1000_QL80_.jpg',
      features: ['Golden Arch', 'Velvet Drapes', 'Throne Chair'],
    ),
    StaticItem(
      id: 'bsd_007',
      name: 'Twinkle Little Star',
      description: 'Dreamy night sky theme with moon props, fairy lights, and silver stars.',
      price: 10000,
      image: 'https://m.media-amazon.com/images/I/71ehX8rOK3L._AC_UF1000,1000_QL80_.jpg',
      features: ['Star Foils', 'Moon Cutout', 'Fairy Lights'],
    ),
    StaticItem(
      id: 'bsd_008',
      name: 'Boho Chic Maternity',
      description: 'Trendy bohemian style with macramé, dried florals, and wicker chairs.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRmtFvUawfqNXnlGIeuB6a9QmHGZbLZSUgUQ&s',
      features: ['Macramé', 'Pampas Grass', 'Wicker Furniture'],
    ),
    StaticItem(
      id: 'bsd_009',
      name: 'Classic Floral Elegance',
      description: 'Sophisticated fresh flower wall with subtle balloon accents.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSdUW3CBJYWsmJDcq4Isn4uLvhJRPIsQvv7A&s',
      features: ['Flower Wall', 'Real Blooms', 'Classy Vibe'],
    ),
    StaticItem(
      id: 'bsd_010',
      name: 'At-Home Mini Setup',
      description: 'Compact yet beautiful ring decoration perfect for living room corners.',
      price: 6000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA1chZwmhBCQyNR9zSnH9O0AJL7Fvui1AraQ&s',
      features: ['Ring Frame', 'Balloon Garland', 'No-Mess Setup'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Baby Shower Decor',
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.child_friendly, color: Colors.indigo)),
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
                                  sectionId: BabyShowerDecorScreen.sectionId,
                                  sectionName: BabyShowerDecorScreen.sectionName,
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