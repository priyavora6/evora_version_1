import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class SangeetScreen extends StatelessWidget {
  const SangeetScreen({super.key});

  static const String sectionId = 'm_sangeet';
  static const String sectionName = 'Sangeet';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PROFESSIONAL SANGEET SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> sangeetItems = [
    StaticItem(
      id: 'sg_001',
      name: 'Professional Wedding DJ',
      description: 'Top-tier DJ with high-end sound system and Bollywood playlist.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjEnO7g5Ar7hQry6vO82H_BuRnZM4mrPByvQ&s',
      features: ['JBL Sound', 'LED Console', 'Fog Machine'],
    ),
    StaticItem(
      id: 'sg_002',
      name: 'LED Dance Floor',
      description: 'Glass-top interactive LED floor (20x20 ft) for heavy dancing.',
      price: 35000,
      image: 'https://cpimg.tistatic.com/10902103/b/4/dance-floor-lights.jpeg',
      features: ['Pressure Sensitive', 'RGB Colors', 'Non-slip'],
    ),
    StaticItem(
      id: 'sg_003',
      name: 'Celebrity Anchor / MC',
      description: 'Professional host to manage performances and engage the audience.',
      price: 15000,
      image: 'https://weddingsutra.com/images/emcee-pic13.jpg',
      features: ['Scripting', 'Game Hosting', 'Energy Booster'],
    ),
    StaticItem(
      id: 'sg_004',
      name: 'Family Choreographer',
      description: 'Expert choreographer for 10 sessions to train family and friends.',
      price: 20000,
      image: 'https://i.ytimg.com/vi/bdoqUbWbrpA/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDoi5wrAGpZ51qhdhDDBY_ZkK3p5g',
      features: ['Song Mixing', 'Basic Props', '10 Sessions'],
    ),
    StaticItem(
      id: 'sg_005',
      name: 'LED Wall (12x8 ft)',
      description: 'High-definition backdrop to display pre-wedding films and visuals.',
      price: 30000,
      image: 'https://jingyled.com/wp-content/uploads/2025/07/LED-Wall-Wedding-Backdrop-Manufacturer-in-China-2.jpg',
      features: ['P3 Resolution', 'Visual Operator', 'Live Feed'],
    ),
    StaticItem(
      id: 'sg_006',
      name: 'Cold Pyro & Fog Show',
      description: 'Special entry effects with cold fire and heavy smoke machines.',
      price: 12000,
      image: 'https://static.wixstatic.com/media/b1f310_498859c2e0904a238c896d55ed467632~mv2.jpeg/v1/fit/w_500,h_500,q_90/file.jpg',
      features: ['8 Pyro Shots', 'Terminator Fog', 'Safe Indoor'],
    ),
    StaticItem(
      id: 'sg_007',
      name: 'Percussionist / Dhol',
      description: 'Live percussion team to play along with the DJ for high energy.',
      price: 8000,
      image: 'https://www.shivmohanband.com/blog/wp-content/uploads/2022/06/Delhi-Wedding-Bands_-How-to-Find-the-Best-One.jpg',
      features: ['2 Players', 'Electronic Pads', 'Entry Dhol'],
    ),
    StaticItem(
      id: 'sg_008',
      name: 'Live Sufi Band',
      description: 'Soulful live musical performance for an elegant Sangeet evening.',
      price: 50000,
      image: 'https://theliveshow.in/_next/image/?url=https%3A%2F%2Fd1cnyts71k4y55.cloudfront.net%2Fassets%2Fbanner-wedding.webp&w=3840&q=75',
      features: ['5 Members', 'Full Setup', 'Sufi & Bollywood'],
    ),
    StaticItem(
      id: 'sg_009',
      name: 'Intelligent Lighting',
      description: 'Concert style lighting with sharpy, pars and smoke effects.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR85MW0C309B-WMV2pOatE32550d6KJH8c8kQ&s',
      features: ['Lighting Tech', 'Sharpy Move', 'DMX Control'],
    ),
    StaticItem(
      id: 'sg_010',
      name: 'Digital Guestbook',
      description: 'A touch screen kiosk where guests can record video wishes.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE_sUOwhCl7KUNoaroXenEf0yuid6v_2-wdg&s',
      features: ['Video Record', 'Instant Link', 'Kiosk Setup'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Sangeet & Party',
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
              itemCount: sangeetItems.length,
              itemBuilder: (context, index) => _SangeetCard(item: sangeetItems[index]),
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

class _SangeetCard extends StatelessWidget {
  final StaticItem item;
  const _SangeetCard({required this.item});

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
          // 🖼️ IMAGE (Portrait style)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 120,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 120, height: 160, color: Colors.indigo.shade50),
            ),
          ),

          // 📝 CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
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
                                  sectionId: SangeetScreen.sectionId,
                                  sectionName: SangeetScreen.sectionName,
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