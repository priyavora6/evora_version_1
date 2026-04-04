

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BabyShowerGiftsScreen extends StatelessWidget {
  const BabyShowerGiftsScreen({super.key});

  static const String sectionId = 'bs_gifts';
  static const String sectionName = 'Gifts & Hampers';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BABY SHOWER GIFTS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> giftItems = [
    StaticItem(
      id: 'bsgf_001',
      name: 'Essential Baby Hamper',
      description: 'A beautiful basket filled with baby clothes, soft toys, and organic lotions.',
      price: 3000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD-hpinZ4_p_bmAfv1pvqCr7ehy5rtI9IjKw&s', // Basket
      features: ['Organic Cotton', 'Bath Essentials', 'Gift Wrapped'],
    ),
    StaticItem(
      id: 'bsgf_002',
      name: 'Luxury Mom-to-Be Spa Kit',
      description: 'Premium self-care hamper for the expecting mother to relax and unwind.',
      price: 4500,
      image: 'https://i.etsystatic.com/27134679/r/il/835725/6180137096/il_fullxfull.6180137096_punl.jpg', // Spa
      features: ['Bath Bombs', 'Stretch Mark Oil', 'Scented Candles'],
    ),
    StaticItem(
      id: 'bsgf_003',
      name: 'Newborn Clothing Set',
      description: 'A 10-piece adorable, unisex, pure cotton clothing set for the newborn.',
      price: 5000,
      image: 'https://m.media-amazon.com/images/I/71VAfQdpUVL._AC_UF1000,1000_QL80_.jpg', // Baby clothes
    features: ['10 Pieces', 'Pure Cotton', 'Unisex Colors'],
    ),
    StaticItem(
      id: 'bsgf_004',
      name: 'Giant Teddy Surprise',
      description: 'A massive 4-foot soft teddy bear holding a congratulations balloon.',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-WUoXR1S6oSDm8xwMHdLqmTCUPB33Ggaljg&s', // Teddy
      features: ['4ft Tall', 'Washable', 'Super Soft'],
    ),
    StaticItem(
      id: 'bsgf_005',
      name: 'Custom Wooden Memory Box',
      description: 'Personalized engraved wooden box to keep the baby’s first memories safe.',
      price: 6500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIN1WjrWFYrhhpgNpEWsTlTJU3c1QrYKYxuw&s', // Wooden box
      features: ['Name Engraved', 'Keepsake Box', 'Premium Wood'],
    ),
    StaticItem(
      id: 'bsgf_006',
      name: 'Silver Blessing Coin & Bowl',
      description: 'Traditional pure silver feeding bowl and spoon set for the baby.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpI1JwcIsz2JaXqD1Gw8UusW0wev51J8NtDg&s', // Silver/Jewelry
      features: ['Pure Silver', 'Hallmarked', 'Velvet Case'],
    ),
    StaticItem(
      id: 'bsgf_007',
      name: 'Return Gifts (Pack of 20)',
      description: 'Cute, themed return gift bags for guests filled with chocolates and a small plant.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTded6wToCUKES-MHJKSKWnSGmH6neUxJYJ_A&s', // Return gifts
      features: ['20 Bags', 'Chocolates incl.', 'Custom Tags'],
    ),
    StaticItem(
      id: 'bsgf_008',
      name: 'Baby Play Gym & Mat',
      description: 'High-quality, colorful musical play mat to keep the baby engaged.',
      price: 4000,
      image: 'https://m.media-amazon.com/images/I/612WamXC+qL._AC_UF1000,1000_QL80_.jpg', // Toys
      features: ['Musical Toys', 'Soft Mat', 'Washable'],
    ),
    StaticItem(
      id: 'bsgf_009',
      name: 'Gourmet Pregnancy Cravings Box',
      description: 'A huge jar filled with premium chocolates, nuts, and exotic snacks for the mom.',
      price: 2800,
      image: 'https://m.media-amazon.com/images/I/81GtZWLoTOL._AC_UF350,350_QL80_.jpg', // Snacks
      features: ['Healthy Snacks', 'Imported Chocolates', 'Large Jar'],
    ),
    StaticItem(
      id: 'bsgf_010',
      name: 'First Year Photo Frame Set',
      description: 'A beautiful 12-month photo frame board to document the baby’s first year.',
      price: 1800,
      image: 'https://m.media-amazon.com/images/I/71aD3znzdGL._AC_UF894,1000_QL80_.jpg', // Frame
      features: ['12 Slots', 'Wall Mount', 'Elegant Design'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Gifts & Hampers',
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.card_giftcard, color: Colors.indigo)),
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
                                  sectionId: BabyShowerGiftsScreen.sectionId,
                                  sectionName: BabyShowerGiftsScreen.sectionName,
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