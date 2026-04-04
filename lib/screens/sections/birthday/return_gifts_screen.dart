import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class ReturnGiftsScreen extends StatelessWidget {
  const ReturnGiftsScreen({super.key});

  static const String sectionId = 'return_gifts';
  static const String sectionName = 'Return Gifts';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM RETURN GIFT OPTIONS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> returnGiftItems = [
    StaticItem(
      id: 'gift_001',
      name: 'Artistic Stationery Set',
      description: 'Themed bag with colorful notebooks, markers, and premium stickers.',
      price: 250,
      image: 'https://m.media-amazon.com/images/I/81ilCSJrMNL._AC_UF1000,1000_QL80_.jpg',
      features: ['Creative Kit', 'Themed Bag', 'Kids Favorite'],
    ),
    StaticItem(
      id: 'gift_002',
      name: 'Premium Chocolate Box',
      description: 'Assorted handcrafted chocolates in a luxury velvet-finish box.',
      price: 350,
      image: 'https://m.media-amazon.com/images/I/71oDmoEWyOL._AC_UF350,350_QL50_.jpg',
      features: ['Imported Cocoa', 'Luxury Box', 'Sweet Treat'],
    ),
    StaticItem(
      id: 'gift_003',
      name: 'Eco-Friendly Plant Kit',
      description: 'Small easy-to-grow succulent in a customized ceramic pot.',
      price: 200,
      image: 'https://nurserylive.com/cdn/shop/products/nurserylive-bulk-gifts-golden-money-plant-in-eco-friendly-pot-gift-pack-16968906244236_512x512.jpg?v=1634220554',
      features: ['Sustainable', 'Live Plant', 'Ceramic Pot'],
    ),
    StaticItem(
      id: 'gift_004',
      name: 'Interactive Puzzle Box',
      description: 'Educational 3D wooden puzzle set to engage young minds.',
      price: 450,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLlQtkdJX8ExhHByPdvHYVuNJMTIQpwcNLAg&s',
      features: ['Educational', 'Wooden Build', 'Skill Booster'],
    ),
    StaticItem(
      id: 'gift_005',
      name: 'Custom Photo Frame',
      description: 'Personalized wooden frame with a "Thank You" note from the host.',
      price: 300,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNQaG3B0qxv2TV6eCoUP_6zijTSM3vsdgw2g&s',
      features: ['Personalized', 'Real Wood', 'Keepsake'],
    ),
    StaticItem(
      id: 'gift_006',
      name: 'Gourmet Snack Hamper',
      description: 'Jar of premium cookies, flavored popcorn, and fruit juice.',
      price: 280,
      image: 'https://m.media-amazon.com/images/I/71uu36X8iZL._AC_UF350,350_QL80_.jpg',
      features: ['Fresh Baked', 'Jar Packing', 'Mixed Treats'],
    ),
    StaticItem(
      id: 'gift_007',
      name: 'Soft Toy Surprise',
      description: 'Cute high-quality plush mascot based on the party theme.',
      price: 400,
      image: 'https://image.made-in-china.com/2f0j00CNkWaTshHyYQ/Pink-Panda-Inflatable-Costume-for-Adults-Cute-Panda-Mascot-Costume-for-Birthday-Parties-Carnivals-Festivals-Interactive-Stage-Performances-and-Props.webp',
      features: ['Super Soft', 'Washable', 'Safe for Kids'],
    ),
    StaticItem(
      id: 'gift_008',
      name: 'Magical Slime Kit',
      description: 'DIY slime making kit with glitter, colors, and mixing tools.',
      price: 220,
      image: 'https://m.media-amazon.com/images/I/81Zr8qk7xtL.jpg',
      features: ['Activity Based', 'Non-toxic', 'Fun Colors'],
    ),
    StaticItem(
      id: 'gift_009',
      name: 'Board Game Classic',
      description: 'Travel-sized traditional board games for family entertainment.',
      price: 320,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShyKlwmOobuwvyQRD-tfn2cyOB92k1mMJM8g&s',
      features: ['Family Fun', 'Compact', 'Durable'],
    ),
    StaticItem(
      id: 'gift_010',
      name: 'Scented Candle Set',
      description: 'Pair of aromatic hand-poured candles in decorative tins.',
      price: 500,
      image: 'https://m.media-amazon.com/images/I/61MA5IhsFGL._AC_UF1000,1000_QL80_.jpg',
      features: ['Organic Soy', 'Home Decor', 'Long Lasting'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Return Gifts',
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
          _buildInfoBanner(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: returnGiftItems.length,
              itemBuilder: (context, index) => _ReturnGiftCard(item: returnGiftItems[index]),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: const Text(
        "Note: Prices are per guest. Selection applies to entire guest count.",
        style: TextStyle(color: Colors.white70, fontSize: 11),
        textAlign: TextAlign.center,
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
                      const Text('Running Subtotal', style: TextStyle(color: Colors.grey, fontSize: 12)),
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

class _ReturnGiftCard extends StatelessWidget {
  final StaticItem item;
  const _ReturnGiftCard({required this.item});

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
          // 🖼️ PORTRAIT IMAGE (Same as other screens)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 125,
              height: 170,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 125, height: 170, color: Colors.indigo.shade50, child: const Icon(Icons.card_giftcard, color: Colors.indigo)),
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
                              // SPECIAL LOGIC: Clear any existing return gift before adding new one
                              final existing = cartProvider.getItemsBySection(ReturnGiftsScreen.sectionId);
                              for (var i in existing) { cartProvider.removeItem(i.id); }

                              cartProvider.addItem(CartItem(
                                  id: item.id,
                                  sectionId: ReturnGiftsScreen.sectionId,
                                  sectionName: ReturnGiftsScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1,
                                  image: item.image,
                                  type: 'return_gift'
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('SELECT', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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