

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class RingCeremonyScreen extends StatelessWidget {
  const RingCeremonyScreen({super.key});

  static const String sectionId = 'e_ring';
  static const String sectionName = 'Ring Ceremony';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM RING CEREMONY PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> ringItems = [
    StaticItem(
      id: 'er_001',
      name: 'Floral Ring Backdrop',
      description: 'Signature circular floral backdrop perfect for ring exchange ceremonies.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5XfQzy6ocJZgKfrcHLpuDQfWcYjN1icg9wQ&s',
      features: ['Fresh Flowers', 'Ring Structure', 'LED Focus Lights'],
    ),
    StaticItem(
      id: 'er_002',
      name: 'Golden Glamour Stage',
      description: 'Luxurious gold and white theme with chandeliers and premium draping.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIFWG3zVxYxxuCFqzy-u6tZdN0iHBHsGInpA&s',
      features: ['Golden Props', 'Crystal Chandeliers', 'Sofa Set'],
    ),
    StaticItem(
      id: 'er_003',
      name: 'Dry Ice Smoke Entry',
      description: 'Magical low-lying fog effect during the couple’s entrance and ring exchange.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSK1NV2O_IudvO-aPZ2KCKwC86l8AuUAn3CA&s',
      features: ['Heavy Smoke', 'Safe Indoors', 'Operator incl.'],
    ),
    StaticItem(
      id: 'er_004',
      name: 'Designer Ring Platter',
      description: 'Customized crystal or floral platter to present the engagement rings.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVmVhpTGimnnxS3wbkJezarfMuMQ2QLlrRpA&s',
      features: ['Crystal Base', 'Fresh Orchids', 'Name Tags'],
    ),
    StaticItem(
      id: 'er_005',
      name: 'Cold Pyro Fountains',
      description: 'Indoor-safe sparklers to go off exactly when the rings are exchanged.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWf9giPj6pyYACzzAZYODwLNS7Jj7r1PYBhg&s',
      features: ['4 Pyro Machines', 'Remote Trigger', 'Perfect Photos'],
    ),
    StaticItem(
      id: 'er_006',
      name: 'Acoustic Love Songs',
      description: 'Live guitarist singing romantic ballads during the ring ceremony.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBM-yv7zSNf1jXKi7moOjzaRWhNRhzbbl-Ig&s',
      features: ['Solo Guitarist', 'Custom Playlist', '2 Hours'],
    ),
    StaticItem(
      id: 'er_007',
      name: 'Enchanted Garden Theme',
      description: 'Open-air lush green setup with hanging florals and fairy lights.',
      price: 28000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6BvF67m8dv5-hUdXmE3aNuA4Ka87L0FKnuw&s',
      features: ['Artificial Turf', 'Hanging Wisteria', 'Wooden Bench'],
    ),
    StaticItem(
      id: 'er_008',
      name: 'Champagne Tower Setup',
      description: 'A beautiful glass tower for a celebratory toast after the ring exchange.',
      price: 14000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz09inTw4Se1ipDtCklIzaE-a0rmUzF3zVOw&s',
      features: ['5-Tier Glasses', 'Table Decor', 'Sparkling Cider'],
    ),
    StaticItem(
      id: 'er_009',
      name: 'LED Name Initials',
      description: 'Giant 4ft tall light-up letters of the couple’s initials near the stage.',
      price: 7000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9Cb3YctH8ooL4NEdIsaWt-LGEMwpbCkZhXg&s',
      features: ['4ft Tall', 'Warm LED', 'Photo Backdrop'],
    ),
    StaticItem(
      id: 'er_010',
      name: 'Confetti Blast',
      description: 'Giant confetti cannons showered over the couple post-ring exchange.',
      price: 4500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7CLOX1mP4H21H2wgE2v6DCA8tkKe_6_dIKg&s',
      features: ['Metallic Confetti', '2 Big Shoots', 'Cleanup incl.'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Ring Ceremony',
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
              itemCount: ringItems.length,
              itemBuilder: (context, index) => _RingCard(item: ringItems[index]),
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

class _RingCard extends StatelessWidget {
  final StaticItem item;
  const _RingCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.diamond, color: Colors.indigo)),
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
                                  sectionId: RingCeremonyScreen.sectionId,
                                  sectionName: RingCeremonyScreen.sectionName,
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