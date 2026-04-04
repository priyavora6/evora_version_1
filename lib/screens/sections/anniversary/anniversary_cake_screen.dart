import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class AnniversaryCakeScreen extends StatelessWidget {
  const AnniversaryCakeScreen({super.key});

  static const String sectionId = 'anniversary_cake';
  static const String sectionName = 'Cake';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ANNIVERSARY CAKES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> cakeItems = [
    StaticItem(
      id: 'ack_001',
      name: 'Heart Shape Chocolate',
      description: 'Classic heart-shaped anniversary cake with dark truffle and roses.',
      price: 1500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkBb5DQ-t_5YrZ5EGXc1avqDDmTOXbYy_W7A&s',
      features: ['1 Kg', 'Chocolate', 'Custom Message'],
    ),
    StaticItem(
      id: 'ack_002',
      name: 'Couple Photo Cake',
      description: 'Capture your journey with a high-definition edible photo print.',
      price: 2200,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXhNr_rSXO0AeNzgwsYtmTAQOfBmjMayik7w&s',
      features: ['Edible Print', 'Vanilla Base', '2 Kg'],
    ),
    StaticItem(
      id: 'ack_003',
      name: 'Luxury 2-Tier Floral',
      description: 'Grand white fondant cake decorated with fresh sugar flowers.',
      price: 6500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRGYAoUbRjIRgc-zrn7byVnYNT7x_hTmQJbA&s',
      features: ['3 Kg', 'Designer Work', 'Premium Look'],
    ),
    StaticItem(
      id: 'ack_004',
      name: 'Red Velvet Romance',
      description: 'Classic red velvet layers with smooth cream cheese frosting.',
      price: 1800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRigYLJXThFcAzgDSRgFxdMvWaZ7XZw5ONWOQ&s',
      features: ['1.5 Kg', 'Cream Cheese', 'Anniversary Topper'],
    ),
    StaticItem(
      id: 'ack_005',
      name: 'Gold Leaf Minimalist',
      description: 'Modern elegant design with 24k edible gold leaf accents.',
      price: 4000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg9qB6Uf8acTj0ezbxruCNVboC9utNoIoZhA&s',
      features: ['2 Kg', 'Gold Detailing', 'Classy'],
    ),
    StaticItem(
      id: 'ack_006',
      name: 'Bento Mini Couple Cake',
      description: 'Cute pocket-sized cake for private, intimate celebrations.',
      price: 900,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBq8wpPN_h_Wb10UtzHqFGJsZjjnC5r95Dwg&s',
      features: ['300g', 'Intimate', 'Quick Delivery'],
    ),
    StaticItem(
      id: 'ack_007',
      name: 'Ferrero Rocher Tower',
      description: 'Nutty chocolate cake topped with a grand tower of Ferrero Rocher.',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF_oZ9vQR8RF2FUww7J0Kx7q6g3Ayo6S5arw&s',
      features: ['2 Kg', 'Hazelnut', 'Chocolate overload'],
    ),
    StaticItem(
      id: 'ack_008',
      name: 'Milestone Number Cake',
      description: 'Cake shaped like your anniversary year (e.g., 10, 25, 50).',
      price: 3200,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGwTCfc0okGnPo0f6l3QFQsa5R27mlr00cpQ&s',
      features: ['Custom Numbers', 'Fruit Topped', '2.5 Kg'],
    ),
    StaticItem(
      id: 'ack_009',
      name: 'Fresh Strawberry Dream',
      description: 'Light sponge filled with seasonal farm-fresh strawberries.',
      price: 1600,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRu0yTgapStfyPMYvFwdgNpib7mA9LjkoKn5w&s',
      features: ['Healthy-ish', 'Fresh Fruit', '1.5 Kg'],
    ),
    StaticItem(
      id: 'ack_010',
      name: 'Pinata Surprise Heart',
      description: 'Break the heart with a hammer to find your gift and cake inside.',
      price: 2500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO6i5U-br1YEzImc8gxOKHCouTHsb1r1u-Vw&s',
      features: ['Interactive', 'Hammer incl.', 'Fun Element'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Anniversary Cakes',
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
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]),
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
                                  sectionId: AnniversaryCakeScreen.sectionId,
                                  sectionName: AnniversaryCakeScreen.sectionName,
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