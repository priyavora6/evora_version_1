import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CorporateGiftsScreen extends StatelessWidget {
  const CorporateGiftsScreen({super.key});

  static const String sectionId = 'c_gifts';
  static const String sectionName = 'Corporate Gifts';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CORPORATE GIFTS
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> giftItems = [
    StaticItem(
      id: 'cg_001',
      name: 'Essential Employee Welcome Kit',
      description: 'Standard onboarding kit containing a branded notebook, metal pen, and keychain.',
      price: 800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSe4_513bSItgD3gfc6-PUwo_3NfrHTt3_tqA&s',
      features: ['Notebook', 'Metal Pen', 'Branded Box'],
    ),
    StaticItem(
      id: 'cg_002',
      name: 'Premium Leather Gift Set',
      description: 'High-quality leather diary, matching card holder, and an executive pen.',
      price: 1500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcxm83rdQzP63Rsg-ACNKz64EOFsP8dJtHDQ&s',
      features: ['Leather Diary', 'Card Holder', 'Premium Feel'],
    ),
    StaticItem(
      id: 'cg_003',
      name: 'Executive Tech Package',
      description: 'Modern gifting setup including a 10,000mAh Power Bank and a Smart Temp Bottle.',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd9_rMTp8CaiIDi3rHa0tNYAmVWYsvOdlx6w&s',
      features: ['Power Bank', 'Smart Flask', 'Custom Logo'],
    ),
    StaticItem(
      id: 'cg_004',
      name: 'The VIP Luxury Hamper',
      description: 'Top-tier luxury hamper for VIP clients featuring imported coffee, chocolates, and wine glasses.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKZRWKZDAS9yrb_axuWFxGhK5Mh9qQ_-wnFA&s',
      features: ['Imported Treats', 'Luxury Box', 'VIP Standard'],
    ),
    StaticItem(
      id: 'cg_005',
      name: 'Custom Crystal Trophies',
      description: 'Elegant crystal trophies for R&R events. Price is per unit, including custom engraving.',
      price: 2000,
      image: 'https://tapwell.in/wp-content/uploads/2022/07/Customized-Crystal-Trophy-For-Corporate-rewards-.png',
      features: ['Laser Engraved', 'Crystal Clear', 'Satin Lined Box'],
    ),
    StaticItem(
      id: 'cg_006',
      name: 'Festive Sweet Hamper',
      description: 'Traditional yet premium corporate boxes filled with assorted dry fruits and sweets.',
      price: 1200,
      image: 'https://royceindia.com/cdn/shop/files/Untitled_design_9_e5f5058e-8b86-4c22-b922-9984b69a7b51_768x.png?v=1701325811',
      features: ['Dry Fruits', 'Rich Sweets', 'Festive Ribbon'],
    ),
    StaticItem(
      id: 'cg_007',
      name: 'Eco-Friendly Plant Kit',
      description: 'A sustainable gift option featuring an indoor succulent with a branded ceramic pot.',
      price: 600,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcinATU1wolQGb-v4inF0skcKHbcMLxcnk4A&s',
      features: ['Indoor Plant', 'Branded Pot', 'Eco-Friendly'],
    ),
    StaticItem(
      id: 'cg_008',
      name: 'Bluetooth Speaker Set',
      description: 'High-quality portable Bluetooth speaker with company branding on the grill.',
      price: 2500,
      image: 'https://shop.zebronics.com/cdn/shop/files/Zeb-Party-Fyre-700-ipic1.jpg?v=1772286027&width=2000',
      features: ['High Bass', 'Custom Grill', '1 Yr Warranty'],
    ),
    StaticItem(
      id: 'cg_009',
      name: 'Apparel & Merch Combo',
      description: 'Includes a high-quality Polo T-shirt, a cap, and a tote bag—all bearing the corporate logo.',
      price: 1800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVom5ukFt2YMwWndRgjWGCKyK-X61WoCsWFQ&s',
      features: ['Polo T-shirt', 'Tote Bag', 'Embroidery'],
    ),
    StaticItem(
      id: 'cg_010',
      name: 'Gourmet Coffee & Mug Kit',
      description: 'A premium ceramic mug paired with artisanal roasted coffee beans and a French press.',
      price: 3200,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoTewgYY-EUzzkbVdk1NSHjzoReFfAOqWnvQ&s',
      features: ['Artisan Coffee', 'French Press', 'Ceramic Mug'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Corporate Gifts',
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
              itemCount: giftItems.length,
              itemBuilder: (context, index) => _GiftCard(item: giftItems[index]),
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
        "Note: Prices listed are per unit. Final total calculates automatically based on total guest/employee count.",
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
                                  sectionId: CorporateGiftsScreen.sectionId,
                                  sectionName: CorporateGiftsScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1, // Will multiply by guest count in cart
                                  image: item.image,
                                  type: 'return_gift' // Specific type for multiplier logic
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