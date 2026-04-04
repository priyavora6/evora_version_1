import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PartyPhotographyScreen extends StatelessWidget {
  const PartyPhotographyScreen({super.key});

  static const String sectionId = 'p_photo';
  static const String sectionName = 'Party Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 SPECIALIZED SOCIAL EVENT PHOTOGRAPHY PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photoItems = [
    StaticItem(
      id: 'pph_001',
      name: 'Bachelor / Bachelorette Coverage',
      description: 'Fun, candid, and high-energy photography for your groom/bride squad night out.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNpYnDyMTJAopEhM-OdhDCkmVlEaqhoVXXQw&s',
      features: ['4 Hours', 'Nightlife Style', 'Squad Poses'],
    ),
    StaticItem(
      id: 'pph_002',
      name: 'Cocktail Night Candid',
      description: 'Capturing the elegance and laughter of your cocktail evening with natural lighting.',
      price: 18000,
      image: 'https://ik.imagekit.io/cvygf2xse/theglenlivet/wp-content/uploads/2025/01/FY23_TGL_FoundersReserve_Pistachio_BottleShot_16x9_-scaled-aspect-ratio-4-4-1-scaled.jpg?tr=q-80,w-2560,h-1440,fo-cover',
      features: ['Low Light Expert', 'No Flash', 'Mood Shots'],
    ),
    StaticItem(
      id: 'pph_003',
      name: 'Reunion Group Portraits',
      description: 'Large group photos and candid moments for school/college batch reunions.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSFnej2SvGx5uehwTOYEUlF7hp3kFMvBKVCA&s',
      features: ['Wide Angle Lens', 'Batch Photos', 'Unlimited Clicks'],
    ),
    StaticItem(
      id: 'pph_004',
      name: 'Housewarming / Pooja Shoot',
      description: 'Traditional coverage of Griha Pravesh rituals followed by the dinner party.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4uRL5l_Adn-cmNFIvHT79As9gfE6yhZS1Dg&s',
      features: ['Ritual Coverage', 'Home Tour', 'Family Portraits'],
    ),
    StaticItem(
      id: 'pph_005',
      name: 'Festival Party Highlights',
      description: 'Vibrant photography for Diwali, Holi, or Christmas parties capturing colors and lights.',
      price: 14000,
      image: 'https://thumbs.dreamstime.com/b/colorful-celebration-spring-holi-festival-india-vibrant-image-captures-joyous-spirit-holi-festival-india-355861263.jpg',
      features: ['Festival Theme', 'Action Shots', 'Color Correction'],
    ),
    StaticItem(
      id: 'pph_006',
      name: 'Retirement Celebration Film',
      description: 'Emotional coverage of speeches, cake cutting, and farewell moments.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI2LaaKy59Nriv2kk4qTr-6FMb-Qltn1JjDg&s',
      features: ['Video + Photo', 'Speech Audio', 'Memory Reel'],
    ),
    StaticItem(
      id: 'pph_007',
      name: 'Kitty Party / High Tea Shoot',
      description: 'Aesthetic food and decor photography with group portraits for afternoon parties.',
      price: 8000,
      image: 'https://thumbs.dreamstime.com/b/happy-people-cheers-celebration-food-dinner-table-party-event-together-above-top-view-group-friends-alcohol-442025301.jpg',
      features: ['Food Styling', 'Decor Shots', 'Group Selfies'],
    ),
    StaticItem(
      id: 'pph_008',
      name: '360° Slow Motion Booth',
      description: 'Trendy rotating camera platform for fun, shareable videos at parties.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5XKlHJmjTL2xmLf8LZLMvoOLFaV9rG2O8tA&s',
      features: ['Instant Share', 'Slow-Mo', 'Fun Props'],
    ),
    StaticItem(
      id: 'pph_009',
      name: 'Live Instant Printing',
      description: 'Guests get hard copies of their photos instantly as party favors.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7g5jFsbcW6tt-xWdRYoha-dkKZaklJmvxMw&s',
      features: ['Unlimited Prints', 'Custom Frame', 'On-site Tech'],
    ),
    StaticItem(
      id: 'pph_010',
      name: 'Instagram Reels Package',
      description: 'Short, trendy vertical videos edited same-day for social media stories.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBYNga5o9hngl_ETRKY8JmDWmV1pbVYxS7Uw&s',
      features: ['3 Viral Reels', 'Trending Audio', '24Hr Delivery'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Party Photography',
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
              itemCount: photoItems.length,
              itemBuilder: (context, index) => _PhotoCard(item: photoItems[index]),
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
                                  sectionId: PartyPhotographyScreen.sectionId,
                                  sectionName: PartyPhotographyScreen.sectionName,
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