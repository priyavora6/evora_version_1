import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class GraduationGiftsScreen extends StatelessWidget {
  const GraduationGiftsScreen({super.key});

  static const String sectionId = 'g_gifts';
  static const String sectionName = 'Gifts';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM GRADUATION GIFTS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> giftItems = [
    StaticItem(
      id: 'gg_001',
      name: 'Custom Engraved Frame',
      description: 'Elegant wood and glass frame to showcase their hard-earned degree.',
      price: 1500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2cDZ7yo0M_KBozQ-yIT7LF4YNP_COxzpC4w&s',
      features: ['Real Wood', 'Laser Engraved', 'Gift Wrapped'],
    ),
    StaticItem(
      id: 'gg_002',
      name: 'Executive Watch & Pen',
      description: 'A classic premium watch paired with a personalized metal rollerball pen.',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6Cg_BCB2OVEKkd6OzxQ2wg5HWRl4f8evbZg&s',
      features: ['Branded Watch', 'Metal Pen', 'Luxury Box'],
    ),
    StaticItem(
      id: 'gg_003',
      name: 'Future Leader Tech Kit',
      description: 'A useful bundle including noise-canceling earbuds and a 10,000mAh power bank.',
      price: 5000,
      image: 'https://m.media-amazon.com/images/I/51Jpv8QA4QL._AC_UF1000,1000_QL80_.jpg',
      features: ['Wireless Earbuds', 'Fast Charger', 'Tech Pouch'],
    ),
    StaticItem(
      id: 'gg_004',
      name: 'Celebration Hamper',
      description: 'Gourmet chocolates, a premium leather diary, and an insulated smart flask.',
      price: 4500,
      image: 'https://m.media-amazon.com/images/I/615GUPGXmlL._AC_UF894,1000_QL80_.jpg',
      features: ['Smart Flask', 'Leather Diary', 'Chocolates'],
    ),
    StaticItem(
      id: 'gg_005',
      name: 'Graduation Star Trophy',
      description: 'A heavy crystal star trophy customized with the graduate\'s name and year.',
      price: 2000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1xiQoHSuphJQzUjUPq-vag6yZNzWlBs1YnQ&s',
      features: ['Crystal Build', 'Gold Lettering', 'Satin Box'],
    ),
    StaticItem(
      id: 'gg_006',
      name: 'Achievement Plaque',
      description: 'A beautiful wooden wall plaque honoring their specific degree and university.',
      price: 1800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsXZMzV2mdujgp9qlWoWunXZHuMSF-v2MNGg&s', // Plaque/Award feel
      features: ['Mahogany Wood', 'Brass Plate', 'Wall Mount'],
    ),
    StaticItem(
      id: 'gg_007',
      name: 'Personalized Leather Journal',
      description: 'Handcrafted leather journal for the graduate to plan their next big steps.',
      price: 1200,
      image: 'https://m.media-amazon.com/images/I/71rMlDdlStL._AC_UF1000,1000_QL80_.jpg',
      features: ['Genuine Leather', 'Name Embossed', 'Thick Paper'],
    ),
    StaticItem(
      id: 'gg_008',
      name: 'Silver Milestone Bracelet',
      description: 'A delicate 925 silver bracelet engraved with the graduation year.',
      price: 3200,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi3brwZRUKqktgmiz8ktroKmx36qaiO5YGdw&s',
      features: ['925 Silver', 'Custom Year', 'Velvet Pouch'],
    ),
    StaticItem(
      id: 'gg_009',
      name: 'Memory Keepsake Box',
      description: 'A beautifully crafted wooden box to store the tassel, photos, and letters.',
      price: 2500,
      image: 'https://m.media-amazon.com/images/I/71SIGbqPVHL._AC_UF1000,1000_QL80_.jpg',
      features: ['Walnut Finish', 'Photo Slot', 'Lockable'],
    ),
    StaticItem(
      id: 'gg_010',
      name: 'Professional Portfolio Bag',
      description: 'A sleek, premium faux-leather laptop bag for their new career.',
      price: 4000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpRTSwFOj8xgGriT2R55EPXQkCsOvbeLOH4A&s',
      features: ['Water Resistant', 'Laptop Sleeve', 'Office Ready'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Graduation Gifts',
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
              itemCount: giftItems.length,
              itemBuilder: (context, index) => _GiftCard(item: giftItems[index]),
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

class _GiftCard extends StatelessWidget {
  final StaticItem item;
  const _GiftCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.school, color: Colors.indigo)),
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
                                  sectionId: GraduationGiftsScreen.sectionId,
                                  sectionName: GraduationGiftsScreen.sectionName,
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