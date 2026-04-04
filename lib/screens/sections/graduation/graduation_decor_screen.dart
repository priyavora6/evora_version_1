import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class GraduationDecorScreen extends StatelessWidget {
  const GraduationDecorScreen({super.key});

  static const String sectionId = 'g_decor';
  static const String sectionName = 'Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM GRADUATION DECOR THEMES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'gdec_001',
      name: 'Classic Black & Gold',
      description: 'Elegant black and gold balloon arches with a customized graduation banner.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTc7uw-MQYsVFkH9zgv6Wc445SVTkI3c9qUeA&s',
      features: ['Gold Balloons', 'Foil Stars', 'Custom Banner'],
    ),
    StaticItem(
      id: 'gdec_002',
      name: 'LED "Class of" Marquee',
      description: 'Giant 4ft tall light-up numbers for the graduating year (e.g., 2024).',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuErq6_TtW3PH1YzOiBcTa_hJUHCEz-077QA&s',
      features: ['4ft LED Numbers', 'Warm White', 'Photo Backdrop'],
    ),
    StaticItem(
      id: 'gdec_003',
      name: 'The Memory Lane Wall',
      description: 'A beautiful fairy-lit string wall displaying photos from freshman to senior year.',
      price: 8000,
      image: 'https://m.media-amazon.com/images/I/71PHk2L17yS.jpg',
      features: ['Fairy Lights', '50 Photo Clips', 'Wooden Frame'],
    ),
    StaticItem(
      id: 'gdec_004',
      name: 'Future is Bright Neon',
      description: 'Trendy neon sign backdrop with a modern silver sequin wall.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3GeBvKcrq5_HHeNYVPPtR0mb1Cq-ztNVCGw&sp',
      features: ['Neon Signage', 'Sequin Wall', 'Modern Vibe'],
    ),
    StaticItem(
      id: 'gdec_005',
      name: 'Outdoor Garden Party',
      description: 'Boho-chic outdoor setup with teepee tents, cushions, and pampas grass.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG8UqUE5Hr1TfvxZoisxHrIAyTZznZn-ijQQ&s',
      features: ['Teepee Tents', 'Floor Cushions', 'Rustic Decor'],
    ),
    StaticItem(
      id: 'gdec_006',
      name: 'University Colors Theme',
      description: 'Complete balloon and drapery setup matching your specific university colors.',
      price: 14000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDu5XUQnJYDGuJ6BqJedm61wGag-5gRPIX0A&s',
      features: ['College Colors', 'Mascot Props', 'Table Decor'],
    ),
    StaticItem(
      id: 'gdec_007',
      name: 'Champagne & Cheers Wall',
      description: 'A stylish wooden wall holding champagne glasses for a celebratory toast.',
      price: 16000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2lr26ulH623p9qtZiTMKpzGL8CGRk41IabQ&s',
      features: ['Glass Holder Wall', 'Sparkling Cider', 'Classy'],
    ),
    StaticItem(
      id: 'gdec_008',
      name: 'Stage & Podium Setup',
      description: 'Professional stage setup for graduation speeches and certificate distribution.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLFIAc3r0YnVRTlV2TKj_hy9z2ULF_KmaWUw&s',
      features: ['Wooden Stage', 'Acrylic Podium', 'Spotlights'],
    ),
    StaticItem(
      id: 'gdec_009',
      name: 'Polaroid Photo Booth',
      description: 'Graduation themed photo booth with oversized polaroid frames and props.',
      price: 9000,
      image: 'https://m.media-amazon.com/images/I/818YegDKolL._AC_UF350,350_QL80_.jpg',
      features: ['Giant Frame', 'Degree Props', 'Ring Light'],
    ),
    StaticItem(
      id: 'gdec_010',
      name: 'Luxury Banquet Setup',
      description: 'Complete luxury venue makeover including chair bows, centerpieces, and drapes.',
      price: 45000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAjMjgf7gq59jDO17dD6u0V3Q7cnthzOvVqQ&s',
      features: ['Full Venue', 'Floral Centerpieces', 'Elegant'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Graduation Decor',
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
                                  sectionId: GraduationDecorScreen.sectionId,
                                  sectionName: GraduationDecorScreen.sectionName,
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