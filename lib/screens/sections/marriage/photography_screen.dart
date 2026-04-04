import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PhotographyScreen extends StatelessWidget {
  const PhotographyScreen({super.key});

  static const String sectionId = 'photography';
  static const String sectionName = 'Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PROFESSIONAL PHOTOGRAPHY SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photographyItems = [
    StaticItem(
      id: 'ph_001',
      name: 'Traditional Photography',
      description: 'Standard high-resolution coverage of all rituals and guests.',
      price: 45000,
      image: 'https://www.wedium.com/wp-content/uploads/2019/10/4-8.jpg',
      features: ['2 Photographers', 'Unlimited Edits', 'High-Res Digital'],
    ),
    StaticItem(
      id: 'ph_002',
      name: 'Candid Photography',
      description: 'Capturing natural emotions and unposed moments of the couple.',
      price: 65000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFi1Mqe1Q5c2LwqCmfg-IN1jkKUU5G6j8sOQ&s',
      features: ['Pro Artist', 'Emotional Shots', 'Creative Edits'],
    ),
    StaticItem(
      id: 'ph_003',
      name: 'Cinematic Wedding Film',
      description: 'Full HD cinematic film with highlights and 2-min teaser.',
      price: 95000,
      image: 'https://cdn0.weddingwire.in/vendor/2447/3_2/960/jpg/25498262-753788941498776-9061627986412701981-n_15_52447.jpeg',
      features: ['4K Quality', 'Teaser included', '2 Videographers'],
    ),
    StaticItem(
      id: 'ph_004',
      name: 'Pre-Wedding Shoot',
      description: 'Thematic outdoor session at a premium location of your choice.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS00jEpmqm_0SSvSNrO3m8lEAVHBFme34H6vw&s',
      features: ['2 Locations', 'Makeup Artist', 'Drone Support'],
    ),
    StaticItem(
      id: 'ph_005',
      name: 'Royal Drone Coverage',
      description: 'Aerial 4K coverage for grand entry and venue visuals.',
      price: 25000,
      image: 'https://thumbs.dreamstime.com/b/hovering-drone-taking-pictures-wedding-couple-nature-summer-80974910.jpg',
      features: ['Licensed Pilot', '4K Aerial View', 'All Events'],
    ),
    StaticItem(
      id: 'ph_006',
      name: 'Premium Leather Album',
      description: 'Handcrafted 40-page luxury photobook with premium finish.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnk1VhPGu84IafyaxAlyeEHUzrVtUu4GSq8w&s',
      features: ['Waterproof', 'Lustre Finish', 'Custom Box'],
    ),
    StaticItem(
      id: 'ph_007',
      name: 'Traditional Videography',
      description: 'Standard long-format video coverage of the entire function.',
      price: 35000,
      image: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?q=80&w=500&auto=format&fit=crop',
      features: ['Full ceremony', 'DVD/USB output', 'LED Mix'],
    ),
    StaticItem(
      id: 'ph_008',
      name: 'Instant Photo Station',
      description: 'Live photo printing station for guests to take memories home.',
      price: 18000,
      image: 'https://images.unsplash.com/photo-1520854221256-17451cc331bf?q=80&w=500&auto=format&fit=crop',
      features: ['Unlimited Prints', 'Fun Props', 'Booth Setup'],
    ),

    StaticItem(
      id: 'ph_010',
      name: 'Crane/Jib Live Feed',
      description: 'Live mixing and crane shots for a celebrity-style grand event.',
      price: 40000,
      image: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?q=80&w=500&auto=format&fit=crop',
      features: ['Live LED Mix', '24ft Crane', 'Cinematic Move'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Photography & Film',
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
                                  sectionId: PhotographyScreen.sectionId,
                                  sectionName: PhotographyScreen.sectionName,
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