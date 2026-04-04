


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EngagementMakeupScreen extends StatelessWidget {
  const EngagementMakeupScreen({super.key});

  static const String sectionId = 'e_makeup';
  static const String sectionName = 'Makeup & Styling';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ENGAGEMENT MAKEUP SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> makeupItems = [
    StaticItem(
      id: 'emakeup_001',
      name: 'Bridal HD Engagement Look',
      description:
      'Flawless High-Definition makeup perfect for ring ceremony photography.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLcGa6qMYoPDiXruBKc73I_FuLs7rvPhf9cg&s',
      features: ['HD Products', 'Hairstyling', 'Draping'],
    ),
    StaticItem(
      id: 'emakeup_002',
      name: 'Airbrush Engagement Makeup',
      description:
      'Long-lasting, waterproof airbrush finish for a natural, glowing look.',
      price: 25000,
      image:
      'https://swissbeauty.in/cdn/shop/products/4_03551690-fc99-4853-8ddb-416caa93cb43.png?v=1748633775&width=620',
      features: ['Waterproof', 'Matte Finish', 'Premium Lashes'],
    ),
    StaticItem(
      id: 'emakeup_003',
      name: 'Groom Styling & Grooming',
      description:
      'Complete hair styling, beard grooming, and subtle touch-ups for the groom.',
      price: 8000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI-KSVaONfIQM1kx70j_0W4e8nMHYm1MIHKQ&s',
      features: ['Hair Styling', 'Beard Grooming', 'Skin Prep'],
    ),
    StaticItem(
      id: 'emakeup_004',
      name: 'Premium Couple Package',
      description:
      'Complete makeup and styling solution for both the bride and groom.',
      price: 20000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQca1Csa0hkBDTpEVw42YYzsRaaShlluNywvA&s',
      features: ['Bride + Groom', 'Touch-ups', 'Package Discount'],
    ),
    StaticItem(
      id: 'emakeup_005',
      name: 'Celebrity Makeup Artist',
      description: 'Get styled by an industry-leading celebrity makeup artist.',
      price: 50000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpBhw4sAkkphtp8QFL95AisPkSxo4x-5jMhg&s',
      features: ['Celeb Artist', 'Designer Look', 'All Day Support'],
    ),
    StaticItem(
      id: 'emakeup_006',
      name: 'Family Makeup (Pack of 3)',
      description:
      'Standard makeup and hairstyling for three close family members.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9gLFSzh3waxAU_NHXvDXWtXtPedNm_C39wg&s',
      features: ['3 Persons', 'Basic Styling', 'On-Location'],
    ),
    StaticItem(
      id: 'emakeup_007',
      name: 'Minimalist Roka Look',
      description:
      'Fresh, dewy, and natural makeup for daytime engagement functions.',
      price: 10000,
      image:
      'https://i.pinimg.com/736x/ab/8d/10/ab8d1055d2fe503a9909ebdd1684116f.jpg',
      features: ['Dewy Finish', 'Lightweight', 'Pastel Tones'],
    ),
    StaticItem(
      id: 'emakeup_008',
      name: 'Saree & Lehenga Draping',
      description:
      'Professional draping service to ensure your attire looks perfect.',
      price: 2500,
      image: 'https://hometriangle.com/imagecache/media/418358/image.webp',
      features: ['Safety Pins incl.', 'Pleat Setting', 'All Styles'],
    ),
    StaticItem(
      id: 'emakeup_009',
      name: 'Premium Hair Extensions & Styling',
      description:
      'Adding volume and length with natural-looking hair extensions.',
      price: 6000,
      image:
      'https://m.media-amazon.com/images/I/912KLSjFyiL._AC_UF1000,1000_QL80_.jpg',
      features: ['Real Hair Feel', 'Volume Boost', 'Styling incl.'],
    ),
    StaticItem(
      id: 'emakeup_010',
      name: 'Pre-Engagement Skin Glow',
      description:
      'Relaxing facial and skin prep session 2 days before the event.',
      price: 8500,
      image:
      'https://theskinstory.in/cdn/shop/articles/relax-rejuvenate-with-a-step-by-step-facial-at-home-7812423.png?v=1770394702',
      features: ['Hydrating', 'Detox', 'Natural Glow'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Clean Background
      appBar: AppBar(
        title: const Text(
          'Makeup & Styling',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: makeupItems.length,
              itemBuilder: (context, index) =>
                  _MakeupCard(item: makeupItems[index]),
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
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 10,
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
          padding: const EdgeInsets.all(20),
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
                        'Section Total',
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

class _MakeupCard extends StatelessWidget {
  final StaticItem item;
  const _MakeupCard({required this.item});

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
              width: 130, // Fixed width for portrait look
              height: 180, // Taller height
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 130,
                height: 180,
                color: Colors.indigo.shade50,
                child: const Icon(Icons.face, color: Colors.indigo),
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
                                  EngagementMakeupScreen.sectionId,
                                  sectionName:
                                  EngagementMakeupScreen.sectionName,
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