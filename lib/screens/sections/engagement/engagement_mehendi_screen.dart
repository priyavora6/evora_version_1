
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EngagementMehendiScreen extends StatelessWidget {
  const EngagementMehendiScreen({super.key});

  static const String sectionId = 'e_mehendi';
  static const String sectionName = 'Mehendi';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ENGAGEMENT MEHENDI SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> mehendiItems = [
    StaticItem(
      id: 'emeh_001',
      name: 'Bridal HD Mehendi',
      description: 'Intricate traditional designs up to elbows for the bride-to-be.',
      price: 8000,
      image: 'https://i.pinimg.com/736x/6f/b8/4f/6fb84f8341393ebecfe06319b5678c13.jpg',
      features: ['Both Hands', 'Dark Stain', 'Organic Henna'],
    ),
    StaticItem(
      id: 'emeh_002',
      name: 'Portrait Ring Style',
      description: 'Customized mehendi featuring a ring exchange portrait.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsAft3VYCHPDnzjiFjSuk4meao6NNKpikUyQ&s',
      features: ['Portrait Art', 'Designer', '4 Hours'],
    ),
    StaticItem(
      id: 'emeh_003',
      name: 'Modern Arabic Designs',
      description: 'Bold and stylish flowy patterns with thick beautiful outlines.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCA6QKnSw9FNqfrKF0lnP4R3eLxQPbjazf7Q&s',
      features: ['Bold Patterns', 'Fast application', 'Trendy'],
    ),
    StaticItem(
      id: 'emeh_004',
      name: 'Family Sider Package',
      description: 'Elegant mehendi designs for 5 close family members or friends.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLw_N9lmOGaS2b3FtOKsp25ZG9RdP08mqoaQ&s',
      features: ['Up to wrists', 'Group package', 'Pro artists'],
    ),
    StaticItem(
      id: 'emeh_005',
      name: 'Moroccan Geometric',
      description: 'Clean lines and geometric patterns for a chic modern bride.',
      price: 7500,
      image: 'https://www.fabfunda.com/blog/wp-content/uploads/2023/10/Moroccan-geometric-mehendi-designs-For-wedding-630x840.jpg',
      features: ['Geometric', 'No florals', 'Crisp Finish'],
    ),
    StaticItem(
      id: 'emeh_006',
      name: 'Classic Mandala Design',
      description: 'Traditional heavy circular mandalas on palms and back of hands.',
      price: 4500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlXq8Ax_EWu-z38GxnW2Mn-343wG9XqiERYw&s',
      features: ['Classic Circles', 'Traditional', 'Quick Apply'],
    ),
    StaticItem(
      id: 'emeh_007',
      name: 'Lotus Motif Traditional',
      description: 'Beautiful lotus and peacock patterns symbolizing purity.',
      price: 6500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSF2Q8OPlJnwG3QPAYZfvUiS6kvGzakQU1SGA&s',
      features: ['Lotus Patterns', 'Heavy Shading', 'Traditional'],
    ),
    StaticItem(
      id: 'emeh_008',
      name: 'Groom’s Minimal Mehendi',
      description: 'Small mandalas or initials for the groom on palms.',
      price: 2000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3D1Iez38mZ6oRKfZsIh_tGAslcobsqk3iZg&s',
      features: ['Initials only', 'Small Mandala', 'Symbolic'],
    ),
    StaticItem(
      id: 'emeh_009',
      name: 'Indo-Arabic Fusion',
      description: 'Mix of traditional Indian patterns with Arabic negative spacing.',
      price: 7000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKasMyUe7O7zQMzF0A_FDaKYNcaTkXJXwyxw&s',
      features: ['Fusion style', 'Floral & Bold', 'Both hands'],
    ),
    StaticItem(
      id: 'emeh_010',
      name: 'Full Artist Team (8 hrs)',
      description: 'Team of 2 junior artists to cover all guests during the function.',
      price: 18000,
      image: 'https://ecsiondevstorage.blob.core.windows.net/wedding-storage/17547E52-D597-4597-B54E-7348159D05D6.png',
      features: ['Guest Coverage', '2 Artists', 'Unlimited designs'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      appBar: AppBar(
        title: const Text('Engagement Mehendi',
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
              itemCount: mehendiItems.length,
              itemBuilder: (context, index) => _MehendiCard(item: mehendiItems[index]),
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

class _MehendiCard extends StatelessWidget {
  final StaticItem item;
  const _MehendiCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.brush, color: Colors.indigo)),
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
                                  sectionId: EngagementMehendiScreen.sectionId,
                                  sectionName: EngagementMehendiScreen.sectionName,
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
