import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class AnniversaryPhotographyScreen extends StatelessWidget {
  const AnniversaryPhotographyScreen({super.key});

  static const String sectionId = 'a_photo';
  static const String sectionName = 'Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM PHOTOGRAPHY SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photographyItems = [
    StaticItem(
      id: 'aph_001',
      name: 'Couple Portrait Session',
      description: 'A romantic, directed photoshoot highlighting your bond and love.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwmKQIhZYcP6eVQjcWEXzlAw1wHIxKyoAfCw&s',
      features: ['2 Hours', '50+ Edits', 'Location of Choice'],
    ),
    StaticItem(
      id: 'aph_002',
      name: 'Candid Event Coverage',
      description: 'Capturing natural, unposed moments of you and your guests during the party.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5mvpdHbd18EOidHUWv7MTQOk5XovPWTD5Dw&s',
      features: ['4 Hours', '150+ Edits', 'Online Gallery'],
    ),
    StaticItem(
      id: 'aph_003',
      name: 'Cinematic Anniversary Film',
      description: 'A beautiful 3-5 minute highlight video of your celebration with music.',
      price: 25000,
      image: 'https://i.ytimg.com/vi/FrZ3rdca9Tg/hqdefault.jpg',
      features: ['4K Video', 'Drone Shots', 'Color Graded'],
    ),
    StaticItem(
      id: 'aph_004',
      name: 'Pre-Anniversary Getaway Shoot',
      description: 'An outdoor romantic photoshoot done a few days before the main event.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-U4nXVlychyYDMAmEL6i_Ne1TiKZdI1E4Gw&s',
      features: ['3 Hours', 'Outfit Changes', '80+ Edits'],
    ),
    StaticItem(
      id: 'aph_005',
      name: 'Luxury Photobook Package',
      description: 'Complete event coverage plus a premium leather-bound printed album.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX2LOiyQ-OLx3G3JPPkO1YITMOXXRRcu51Pw&s',
      features: ['40-Page Album', '200+ Photos', 'Matte Finish'],
    ),
    StaticItem(
      id: 'aph_006',
      name: 'Aerial Drone Coverage',
      description: 'Stunning bird\'s-eye view shots of your grand outdoor anniversary venue.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKFOloU6b2PMJ2MnyPgfzFlmzatzkfrsXkgw&s',
      features: ['Licensed Pilot', 'Cinematic Angles', 'HD Output'],
    ),
    StaticItem(
      id: 'aph_007',
      name: 'Instagram Reels Creator',
      description: 'A dedicated shooter making trendy vertical videos for your social media.',
      price: 7000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbRlytGA-gtv88whdksHrpuajp6xTp-J8ptw&s',
      features: ['3 Viral Reels', 'Trending Audio', '24Hr Delivery'],
    ),
    StaticItem(
      id: 'aph_008',
      name: 'The Ultimate Full Day',
      description: 'Complete photo and video coverage of your entire anniversary day from start to finish.',
      price: 40000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAQOvzFgdqZL_sja8p5RJs72OFf8QbDSZCLw&s',
      features: ['8 Hours', 'Photo + Video', 'Drone + Album'],
    ),
    StaticItem(
      id: 'aph_009',
      name: 'Vintage Polaroid Station',
      description: 'A fun setup where guests get instant printed polaroids to keep as memories.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKEjxIAyKwgPdsn1Cq6qqbnJMpO-2_HhYCJw&s',
      features: ['Unlimited Prints', 'Fun Props', 'Attendant incl.'],
    ),
    StaticItem(
      id: 'aph_010',
      name: 'Vow Renewal / Surprise Shoot',
      description: 'Hidden camera setup to capture a surprise gift or vow renewal moment perfectly.',
      price: 14000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmlZMA7Fr0idQB-2BQqneDxrdmQdzufieq1g&s',
      features: ['Secret Setup', 'Raw Emotion', 'Tear-jerker Video'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Photography & Video',
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
                                  sectionId: AnniversaryPhotographyScreen.sectionId,
                                  sectionName: AnniversaryPhotographyScreen.sectionName,
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