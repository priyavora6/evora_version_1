import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class AnniversaryGiftsScreen extends StatelessWidget {
  const AnniversaryGiftsScreen({super.key});

  static const String sectionId = 'a_gifts';
  static const String sectionName = 'Gifts';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ANNIVERSARY GIFTS & EXPERIENCES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> giftItems = [
    StaticItem(
      id: 'ag_001',
      name: '100 Red Roses Bouquet',
      description: 'A massive, luxurious bouquet of fresh red roses to surprise your partner.',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVQfZbYSN3LUr9Ee-adcOC1dRLk7V3Pvj8kQ&s',
      features: ['100 Roses', 'Premium Wrap', 'Message Card'],
    ),
    StaticItem(
      id: 'ag_002',
      name: 'Luxury Spa Hamper',
      description: 'Premium collection of essential oils, bath bombs, and luxury perfumes.',
      price: 5500,
      image: 'https://m.media-amazon.com/images/I/71Q3Z-e0tJL._AC_UF1000,1000_QL80_.jpg',
      features: ['Essential Oils', 'Bath Salts', 'Wooden Box'],
    ),
    StaticItem(
      id: 'ag_003',
      name: 'Gourmet Chocolate Box',
      description: 'Handcrafted artisan chocolates from Belgium in an elegant velvet box.',
      price: 2800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbm9FX85rYT3DZ288Jmw27_W7Ed1NYDcxMpg&s',
      features: ['Imported Cocoa', '24 Pcs', 'Velvet Finish'],
    ),
    StaticItem(
      id: 'ag_004',
      name: 'Couple Watches Set',
      description: 'Elegant matching His & Hers watches delivered during the event.',
      price: 15000,
      image: 'https://m.media-amazon.com/images/I/61w+vYzvbJL._AC_UY1000_.jpg',
      features: ['Matching Set', 'Premium Brand', 'Gift Boxed'],
    ),
    StaticItem(
      id: 'ag_005',
      name: 'Custom Engraved Wine Glasses',
      description: 'A pair of crystal glasses engraved with your wedding date and names.',
      price: 3000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoRB--gOczaP7rjFdFmE90VxQpJzEskc2diw&s',
      features: ['Crystal Glass', 'Laser Engraved', 'Satin Box'],
    ),
    StaticItem(
      id: 'ag_006',
      name: 'Helicopter Ride Experience',
      description: 'A surprise 15-minute romantic helicopter joyride over the city.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSE3GJkUXFFydrzaUGlu70DgTjRp0FstwcRA&s',
      features: ['15 Min Ride', 'Champagne Toast', 'City View'],
    ),
    StaticItem(
      id: 'ag_007',
      name: 'Memory Scrapbook',
      description: 'Beautifully handcrafted vintage scrapbook filled with your couple photos.',
      price: 4500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGUfbK8zFrG4IdPD1AUCtUN6OYLREXbn3UtA&s',
      features: ['Handcrafted', '50 Photos', 'Leather Bound'],
    ),
    StaticItem(
      id: 'ag_008',
      name: 'Silver Coin Return Gifts (50 pcs)',
      description: 'Pure silver 10g coins customized for guests as a premium return gift.',
      price: 60000,
      image: 'https://m.media-amazon.com/images/I/513de2c+cEL._AC_UY1100_.jpg',
      features: ['10g Pure Silver', '50 Pieces', 'Velvet Pouches'],
    ),
    StaticItem(
      id: 'ag_009',
      name: 'Private Yacht Dinner',
      description: 'A luxury 2-hour private yacht experience with a dedicated chef.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsHgg2CvEhn_-tiLX2O2QesqeKpe1wb8AvcQ&s',
      features: ['2 Hours', 'Private Chef', 'Sunset View'],
    ),
    StaticItem(
      id: 'ag_010',
      name: 'Assorted Macaron Tower',
      description: 'A beautiful and delicious 4-tier tower of authentic French macarons.',
      price: 4000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdlaKsjaBY9vq-1qn4lRllxvNzlqDZ-TmcjA&s',
      features: ['4 Tiers', 'Mixed Flavors', 'French Recipe'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Anniversary Gifts',
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
                                  sectionId: AnniversaryGiftsScreen.sectionId,
                                  sectionName: AnniversaryGiftsScreen.sectionName,
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