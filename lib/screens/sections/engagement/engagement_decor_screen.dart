

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EngagementDecorScreen extends StatelessWidget {
  const EngagementDecorScreen({super.key});

  static const String sectionId = 'e_decor';
  static const String sectionName = 'Engagement Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ENGAGEMENT DECOR PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'ed_001',
      name: 'Floral Ring Backdrop',
      description:
      'Signature circular floral backdrop perfect for the ring exchange ceremony.',
      price: 18000,
      image: 'https://m.media-amazon.com/images/I/71uEJ9i-wmL.jpg',
      features: ['Fresh Flowers', 'Ring Structure', 'LED Focus Lights'],
    ),
    StaticItem(
      id: 'ed_002',
      name: 'Golden Glamour Stage',
      description:
      'Luxurious gold and white theme with chandeliers and premium draping.',
      price: 35000,
      image:
      'https://antonovich-design.com/uploads/gallery/2023/2/2023HBMDYRxMPXjn.jpeg',
      features: ['Golden Props', 'Crystal Chandeliers', 'Sofa Set'],
    ),
    StaticItem(
      id: 'ed_003',
      name: 'Boho Chic Setup',
      description:
      'Trendy bohemian style decor with pampas grass and macrame accents.',
      price: 22000,
      image:
      'https://thumbs.dreamstime.com/b/boho-living-room-interior-macrame-decor-pampas-grass-modern-fireplace-minimalist-home-decor-scandinavian-style-cozy-vibes-382451379.jpg',
      features: ['Pampas Grass', 'Macrame Hangings', 'Rustic Furniture'],
    ),
    StaticItem(
      id: 'ed_004',
      name: 'Enchanted Garden',
      description:
      'Open-air lush green setup with hanging florals and fairy lights.',
      price: 28000,
      image:
      'https://www.brides.com/thmb/vFPyGiB8RYJspLvVaIVJdGiQzyY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/greenery-installation-recirc-jaimee-morse-7-29-fbab325d35dc443c868c068e39d0aafb.jpg',
      features: ['Artificial Turf', 'Hanging Wisteria', 'Wooden Bench'],
    ),
    StaticItem(
      id: 'ed_005',
      name: 'Grand Entrance Arch',
      description:
      'Beautiful floral archway with a red carpet to welcome your guests.',
      price: 8000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1WlobU5VBUS-_B8T1F9oeEg3ea5Kd5VQnuw&s',
      features: ['Floral Arch', 'Welcome Board', 'Red Carpet'],
    ),
    StaticItem(
      id: 'ed_006',
      name: 'Couple Photo Booth',
      description:
      'Fun photo zone with customized hashtags, neon signs, and props.',
      price: 5000,
      image:
      'https://m.media-amazon.com/images/I/71f0bs2HSML.jpg',
      features: ['Custom Hashtag', 'Neon Sign', 'Fun Props'],
    ),
    StaticItem(
      id: 'ed_007',
      name: 'Elegant Table Settings',
      description:
      'Premium centerpieces and table runners for the guest dining area.',
      price: 6000,
      image:
      'https://www.urquidlinen.com/cdn/shop/articles/pexels-thallen-merlin-1580622.jpg?v=1647061417&width=1280',
      features: ['Centerpieces', 'Table Runners', '10 Tables included'],
    ),
    StaticItem(
      id: 'ed_008',
      name: 'Candlelight Pathway',
      description:
      'Romantic walkway lit by hundreds of glass candles and rose petals.',
      price: 12000,
      image:
      'https://thumbs.dreamstime.com/b/romantic-candlelit-pathway-rose-petals-beautifully-illuminated-lined-glowing-candles-scattered-red-creating-ambiance-355282240.jpg',
      features: ['Glass Candles', 'Rose Petals', 'Floor Decor'],
    ),
    StaticItem(
      id: 'ed_009',
      name: 'Pastel Dream Stage',
      description:
      'Soft pastel-colored drapes with matching floral arrangements.',
      price: 26000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQpG6dJaz9MBPKTqK1S3dM_9U1yk2fs99bsA&s',
      features: ['Pastel Drapes', 'Matching Sofa', 'Soft Lighting'],
    ),
    StaticItem(
      id: 'ed_010',
      name: 'LED Name Initials',
      description:
      'Giant marquee light-up letters of the couple’s initials for the stage.',
      price: 7000,
      image:
      'https://www.circlemakerstudio.com/cdn/shop/products/IMG_8622_2048x2048.jpg?v=1664579889',
      features: ['4ft Tall', 'Warm LED', 'Standalone'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text(
          'Engagement Decor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
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
              itemBuilder: (context, index) =>
                  _DecorCard(item: decorItems[index]),
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
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
              if (count > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Selection',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        '${AppStrings.rupee}${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'DONE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
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
              errorBuilder: (c, e, s) => Container(
                width: 125,
                height: 180,
                color: Colors.indigo.shade50,
                child: const Icon(Icons.palette, color: Colors.indigo),
              ),
            ),
          ),

          // 📝 CONTENT SECTION
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Feature Tags
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: item.features
                        .take(2)
                        .map(
                          (f) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppStrings.rupee}${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      // ✅ TOGGLE LOGIC: ADD <-> SELECTED
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final isInCart = cartProvider.isInCart(item.id);
                          return isInCart
                              ? GestureDetector(
                            onTap: () => cartProvider.removeItem(item.id),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                const Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              cartProvider.addItem(
                                CartItem(
                                  id: item.id,
                                  sectionId:
                                  EngagementDecorScreen.sectionId,
                                  sectionName:
                                  EngagementDecorScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1,
                                  image: item.image,
                                  type: 'item',
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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