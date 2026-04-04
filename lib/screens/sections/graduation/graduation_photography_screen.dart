import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class GraduationPhotographyScreen extends StatelessWidget {
  const GraduationPhotographyScreen({super.key});

  static const String sectionId = 'g_photo';
  static const String sectionName = 'Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM GRADUATION PHOTOGRAPHY SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photographyItems = [
    StaticItem(
      id: 'gpho_001',
      name: 'Solo Graduate Portraits',
      description:
      'Professional outdoor portraits featuring you in your gown and cap.',
      price: 5000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1LBajbCRucGQG2KTW-SJzJnn0mTkICWfLmg&s',
      features: ['2 Hours', '50+ Edits', 'Campus Location'],
    ),
    StaticItem(
      id: 'gpho_002',
      name: 'Friends Group Photoshoot',
      description:
      'A fun and candid session capturing the bond between your best friends.',
      price: 8000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSspazFnzN55ofrzW-3U0cYwgJjnQtz8zIN2g&s',
      features: ['Up to 5 Pax', 'Candid Poses', 'Fun Props'],
    ),
    StaticItem(
      id: 'gpho_003',
      name: 'Full Event Coverage',
      description:
      'Complete photography coverage of your graduation party with family and guests.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXIPCzNtrpzacWNkIATvJFoZL79tu_pkFywA&s',
      features: ['4 Hours', '200+ Photos', 'Online Gallery'],
    ),
    StaticItem(
      id: 'gpho_004',
      name: 'Cinematic Grad Film',
      description:
      'A beautifully shot and edited cinematic video celebrating your achievement.',
      price: 22000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYlZB14MCre9aYTkX77VrO7jJmyG6XaIcHBg&s',
      features: ['4K Video', 'Highlight Reel', 'Voiceovers incl.'],
    ),
    StaticItem(
      id: 'gpho_005',
      name: 'Aerial Drone Shots',
      description:
      'Stunning bird\'s-eye view captures of the cap-toss and campus grounds.',
      price: 12000,
      image:
      'https://thumbs.dreamstime.com/b/bird-s-eye-view-school-grounds-239634586.jpg',
      features: ['Licensed Pilot', 'Cinematic Angles', 'Outdoor Only'],
    ),
    StaticItem(
      id: 'gpho_006',
      name: 'Instagram Reels Creator',
      description:
      'A dedicated creator to shoot trendy transition videos and reels in your gown.',
      price: 6000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXSWQLM9QfvEksJnmakU20TaVn7tvIkYddxg&s',
      features: ['3 Edited Reels', 'Trending Audio', '24Hr Delivery'],
    ),
    StaticItem(
      id: 'gpho_007',
      name: 'Premium Leather Album',
      description:
      'A handcrafted, personalized photo book to preserve your graduation memories.',
      price: 10000,
      image:
      'https://www.picsy.in/images/contentimages/images/Blog_60_Banner_1.jpg',
      features: ['40 Pages', 'Matte Finish', 'Custom Cover'],
    ),
    StaticItem(
      id: 'gpho_008',
      name: 'Studio Lighting Setup',
      description:
      'Professional indoor studio lighting brought to your venue for flawless portraits.',
      price: 7000,
      image:
      'https://thumbs.dreamstime.com/b/empty-photo-studio-lighting-equipment-modern-photography-studio-interior-professional-lighting-setup-ready-418625860.jpg',
      features: ['Softboxes', 'Backdrops', 'Magazine Style'],
    ),
    StaticItem(
      id: 'gpho_009',
      name: 'Instant Polaroid Station',
      description:
      'A dedicated photographer printing instant polaroids for guests at your grad party.',
      price: 9000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvH7-p0m7vDIJUYamI1yCd7OrHszgt-Vyolw&s',
      features: ['Unlimited Prints', 'Fun Props', 'Retro Vibe'],
    ),
    StaticItem(
      id: 'gpho_010',
      name: 'The Ultimate Grad Package',
      description:
      'Photo, Video, Reels, and a Drone for complete coverage of your success party.',
      price: 45000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSEvDtUKu9qSJwUaQIeH-g-XetNyIZufqulQ&s',
      features: ['Full Team', 'All-Inclusive', 'Priority Delivery'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text(
          'Photography',
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
              itemCount: photographyItems.length,
              itemBuilder: (context, index) =>
                  _PhotoCard(item: photographyItems[index]),
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
                child: const Icon(Icons.camera_alt, color: Colors.indigo),
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
                                  sectionId: GraduationPhotographyScreen
                                      .sectionId,
                                  sectionName: GraduationPhotographyScreen
                                      .sectionName,
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
