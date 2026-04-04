import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PartyDecorScreen extends StatelessWidget {
  const PartyDecorScreen({super.key});

  static const String sectionId = 'p_decor';
  static const String sectionName = 'Party Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 SPECIALIZED SOCIAL EVENT DECOR THEMES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'pdec_001',
      name: 'Bachelor & Bachelorette Glam',
      description: 'Trendy "Bride to Be" or "Groom Squad" decor with foil balloons, sashes, and fun props.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRechBjgBYXiXGRlCKvaf-OEP5IIkdjjwBkxQ&s',
      features: ['Foil Balloons', 'Photo Props', 'Party Sashes'],
    ),
    StaticItem(
      id: 'pdec_002',
      name: 'Festival Lights & Rangoli',
      description: 'Traditional decor for Diwali/New Year with marigold strings, diyas, and LED rangoli.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsmF65x3DeBOwNp3Vi-c7w128qXBlU3UowkA&s',
      features: ['LED Rangoli', 'Lanterns', 'Ethnic Drapes'],
    ),
    StaticItem(
      id: 'pdec_003',
      name: 'Griha Pravesh Floral Decor',
      description: 'Elegant fresh flower decoration for Housewarming puja and evening dinner parties.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlqBG5yF4wO4aT1u4BHvNF0gCGZXeIEczOKQ&s',
      features: ['Entrance Toran', 'Fresh Flowers', 'Puja Setup'],
    ),
    StaticItem(
      id: 'pdec_004',
      name: 'Batch Reunion Nostalgia',
      description: 'School/College reunion setup with memory walls, photo strings, and vintage props.',
      price: 14000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqH3KnfMe2ReH2gSu7XfpTbglmae6p1duzWg&s',
      features: ['Memory Wall', 'Batch Year Sign', 'Photo Booth'],
    ),
    StaticItem(
      id: 'pdec_005',
      name: 'Golden Retirement Gala',
      description: 'Sophisticated Gold & White theme to celebrate a career milestone with elegance.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZ-o42VqfBxU5mSE53vCmg7GqMfM8WEKGgpA&s',
      features: ['Gold Balloons', 'Champagne Wall', 'Elegant Drapes'],
    ),
    StaticItem(
      id: 'pdec_006',
      name: 'High Tea & Kitty Decor',
      description: 'Aesthetic floral centerpieces and pastel drapes for casual afternoon gatherings.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0vj8c9v2XCyHhX4SJiWDkOisHsoyJAU5AAQ&s',
      features: ['Floral Table', 'Pastel Theme', 'Cozy Seating'],
    ),
    StaticItem(
      id: 'pdec_007',
      name: 'Cocktail Lounge Ambience',
      description: 'Dim ambient lighting, candles, and bar decor for a Friday night get-together.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4L4zErXDRL-KOVtiuKY2zK3DYgApO6Cl5Ag&s',
      features: ['Mood Lighting', 'Bar Styling', 'Lounge Sofa'],
    ),
    StaticItem(
      id: 'pdec_008',
      name: 'Tropical Poolside Vibe',
      description: 'Hawaiian luau theme with flamingos, palm leaves, and tiki torches for pool parties.',
      price: 16000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkSSrjpSQeCxWOG-njMFhci6FZoTNMuXr8hQ&s',
      features: ['Inflatables', 'Tiki Torch', 'Tropical Bar'],
    ),
    StaticItem(
      id: 'pdec_009',
      name: 'Neon Disco Fever',
      description: 'UV-reactive neon balloons, glow sticks, and blacklight setup for dance parties.',
      price: 12000,
      image: 'https://m.media-amazon.com/images/I/61YifM6KoHL._AC_UF350,350_QL80_.jpg',
      features: ['UV Lights', 'Glow Sticks', 'Neon Props'],
    ),
    StaticItem(
      id: 'pdec_010',
      name: 'Elegant Dinner Setting',
      description: 'Candlelight dinner decor with table runners and fine cutlery for intimate parties.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlCS2CtrPMKTyNWbFJPx7sW-XX-8-rSSf1Iw&s',
      features: ['Table Runner', 'Candles', 'Fine Dining'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Party Decoration',
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.celebration, color: Colors.indigo)),
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
                                  sectionId: PartyDecorScreen.sectionId,
                                  sectionName: PartyDecorScreen.sectionName,
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