import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BirthdayPhotographyScreen extends StatelessWidget {
  const BirthdayPhotographyScreen({super.key});

  static const String sectionId = 'b_photo';
  static const String sectionName = 'Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BIRTHDAY PHOTOGRAPHY SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photographyItems = [
    StaticItem(
      id: 'bpho_001',
      name: 'Basic Event Coverage',
      description: 'Capture beautiful birthday memories, cake cutting, and group photos.',
      price: 6000,
      image: 'https://thumbs.dreamstime.com/b/middle-aged-black-women-cutting-cake-three-generation-family-birthday-celebration-close-up-middle-aged-african-american-144594318.jpg',
      features: ['2 Hours', '100+ Photos', 'Online Gallery'],
    ),
    StaticItem(
      id: 'bpho_002',
      name: 'Candid Party Photography',
      description: 'Focuses on natural, fun, and unposed moments of the birthday star and guests.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQktWyJBwXNAGssBXhRU0lsIinFxjBchQNjeQ&s',
      features: ['4 Hours', '250+ Photos', 'Premium Edits'],
    ),
    StaticItem(
      id: 'bpho_003',
      name: 'Photo + Cinematic Video',
      description: 'Complete coverage including a beautifully edited highlight video.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7WeU9lFpj9-8CQDh0UNWIhSX2KVoyX71RbA&s',
      features: ['Full Event', 'Highlight Reel', 'Edited Album'],
    ),
    StaticItem(
      id: 'bpho_004',
      name: 'Cake Smash Baby Shoot',
      description: 'A messy, fun, and adorable pre-birthday photoshoot for toddlers.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEIRDnCu95FukhZVLyclxnJkQVloSnKidOGA&s',
      features: ['Studio Setup', 'Props Incl.', 'Outfit Change'],
    ),
    StaticItem(
      id: 'bpho_005',
      name: 'Outdoor Drone Coverage',
      description: 'Aerial video and photography for grand outdoor garden parties.',
      price: 15000,
      image: 'https://www.shutterstock.com/shutterstock/videos/3879401659/thumb/1.jpg?ip=x480',
      features: ['4K Drone', 'Licensed Pilot', 'Cinematic Shots'],
    ),
    StaticItem(
      id: 'bpho_006',
      name: '360° Video Booth',
      description: 'Trendy rotating camera booth providing slow-motion videos for guests.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUQMKu8QRzvsLra_WbTMeYSj0JbAHFG77oVg&s',
      features: ['360 Platform', 'Slow Motion', 'Instant Share'],
    ),
    StaticItem(
      id: 'bpho_007',
      name: 'Polaroid Instant Station',
      description: 'A dedicated photographer printing instant retro photos for guests to keep.',
      price: 8000,
      image: 'https://m.media-amazon.com/images/I/71RAIq7ih-L.jpg',
      features: ['Unlimited Prints', 'Fun Props', 'Retro Vibe'],
    ),
    StaticItem(
      id: 'bpho_008',
      name: 'Instagram Reels Creator',
      description: 'A dedicated content creator shooting and editing viral-style vertical videos.',
      price: 7000,
      image: 'https://lwks.com/hubfs/Video%20Portrait%20Blog-min%20(1).webp',
      features: ['3 Reels', 'Trending Audio', '24Hr Delivery'],
    ),
    StaticItem(
      id: 'bpho_009',
      name: 'Themed Portrait Session',
      description: 'A stylish portrait session matching your specific birthday theme.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKFY8kcy84lL6kKiSXO0AFkr9Ht8WhwtX9vg&s',
      features: ['Theme Setup', 'Studio Lights', 'Retouched Pics'],
    ),
    StaticItem(
      id: 'bpho_010',
      name: 'Luxury Printed Album',
      description: 'Add a premium 40-page hardcover photobook to keep your memories safe.',
      price: 12000,
      image: 'https://m.media-amazon.com/images/I/61rgzXnTI5L._AC_UF1000,1000_QL80_.jpg',
      features: ['40 Pages', 'Matte Finish', 'Custom Cover'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Birthday Photography',
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
                                  sectionId: BirthdayPhotographyScreen.sectionId,
                                  sectionName: BirthdayPhotographyScreen.sectionName,
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