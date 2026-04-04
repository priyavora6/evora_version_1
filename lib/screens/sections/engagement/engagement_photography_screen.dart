

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EngagementPhotographyScreen extends StatelessWidget {
  const EngagementPhotographyScreen({super.key});

  static const String sectionId = 'e_photo';
  static const String sectionName = 'Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM PHOTOGRAPHY SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photographyItems = [
    StaticItem(
      id: 'epho_001',
      name: 'Candid Engagement Shoot',
      description: 'Focuses on capturing raw, unposed emotions and beautiful ring exchange moments.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjj_yZYt6UqngdS4Cv7QsoXvJ-j6t_uerSFg&s',
      features: ['1 Pro Photographer', 'Color Graded', 'Digital Delivery'],
    ),
    StaticItem(
      id: 'epho_002',
      name: 'Traditional Photography',
      description: 'Classic stage photography covering all guests, family portraits, and rituals.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-AHFwP8lt07EoHGCWPSsIUm7eWRshfjrPow&s',
      features: ['Unlimited Clicks', 'Family Portraits', 'Basic Editing'],
    ),
    StaticItem(
      id: 'epho_003',
      name: 'Cinematic Engagement Film',
      description: 'A 5-8 minute cinematic highlight film capturing the best moments with music.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcDi_FFHGw7Y43JXYa0wt11Gb-t-d-kc4Q3w&s',
      features: ['2 Cinematographers', '4K Video', '1 Min Teaser'],
    ),
    StaticItem(
      id: 'epho_004',
      name: 'Pre-Engagement Photoshoot',
      description: 'A romantic outdoor photoshoot in casual/formal wear before the big day.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkMOw7j6h5YzQGfuYI32_1dBTFOTD-hXF_lQ&s',
      features: ['1 Location', '2 Outfit Changes', '30 Edited Pics'],
    ),
    StaticItem(
      id: 'epho_005',
      name: 'Aerial Drone Coverage',
      description: 'Capture your grand entrance and venue setup from stunning aerial views.',
      price: 18000,
      image: 'https://www.shutterstock.com/shutterstock/videos/3978451299/thumb/1.jpg?ip=x480',
      features: ['4K Drone', 'Licensed Pilot', 'Outdoor Venues'],
    ),
    StaticItem(
      id: 'epho_006',
      name: 'Instant Polaroid Station',
      description: 'A fun corner where guests get instant printed polaroid photos as souvenirs.',
      price: 12000,
      image: 'https://m.media-amazon.com/images/I/71shbpzuuhL._AC_UF1000,1000_QL80_.jpg',
      features: ['Unlimited Prints', 'Custom Frame', 'Fun Props'],
    ),
    StaticItem(
      id: 'epho_007',
      name: 'Premium Photo Album',
      description: 'High-quality 40-page flush mount album with a custom leather cover.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQW0u29tIXkYbvhfc0bgJMHErpiOiEO2Dd3Cw&s',
      features: ['Matte Finish', 'Tear Resistant', 'Custom Design'],
    ),
    StaticItem(
      id: 'epho_008',
      name: 'Reels & Shorts Creator',
      description: 'A dedicated creator to shoot and edit viral-style vertical videos for social media.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRL9vEAIcHnC7EweO2sW9Zb83zMvbyw7QuA9A&s',
      features: ['3 Edited Reels', 'Trending Audio', '24Hr Delivery'],
    ),
    StaticItem(
      id: 'epho_009',
      name: 'Live Streaming Setup',
      description: 'Professional multi-camera live stream for relatives who cannot attend.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQs854fn0KCp7Doaa0B7L7nrX1c0epcexF4g&s',
      features: ['Private Link', '2 HD Cameras', 'Live Switcher'],
    ),
    StaticItem(
      id: 'epho_010',
      name: 'Luxury Mega Package',
      description: 'The ultimate combo: Candid, Traditional, Cinematic, Drone, and Album.',
      price: 95000,
      image: 'https://weddingpur.com/wp-content/uploads/2026/02/Lovely-Kiss-Moment-Between-Bride-and-Groom-Filled-with-Love-scaled-e1771221258589.jpg',
      features: ['Complete Team', 'Full Day', 'Everything Included'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Engagement Photography',
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
              itemCount: photographyItems.length,
              itemBuilder: (context, index) => _PhotoCard(item: photographyItems[index]),
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

class _PhotoCard extends StatelessWidget {
  final StaticItem item;
  const _PhotoCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.camera_alt, color: Colors.indigo)),
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
                                  sectionId: EngagementPhotographyScreen.sectionId,
                                  sectionName: EngagementPhotographyScreen.sectionName,
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