import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PartyBarScreen extends StatelessWidget {
  const PartyBarScreen({super.key});

  static const String sectionId = 'p_bar';
  static const String sectionName = 'Bar & Drinks';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BAR & BEVERAGE SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> barItems = [
    StaticItem(
      id: 'pbar_001',
      name: 'Tropical Mocktail Bar',
      description:
      'Refreshing non-alcoholic mocktails mixed fresh for all age groups.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyPw8cU6n1tp2NyZ_FNYj98DouEO7A8PhkBg&s', // Colorful drinks
      features: ['5 Mocktails', 'Fresh Fruits', 'Pro Mixologist'],
    ),
    StaticItem(
      id: 'pbar_002',
      name: 'Premium Cocktail Bar',
      description:
      'Classic and signature cocktail menu curated by top bartenders.',
      price: 25000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLd9SDhuZS-GqyumiwE648FJER21m6ebEJGw&s', // Cocktail pouring
      features: ['8 Cocktails', 'Premium Mixers', 'Glassware incl.'],
    ),
    StaticItem(
      id: 'pbar_003',
      name: 'Flair Bartending Show',
      description:
      'Entertainment meets drinks with an amazing juggling and fire act.',
      price: 35000,
      image:
      'https://static.toiimg.com/thumb/msid-62337513,width-1280,height-720,resizemode-72/62337513.jpg', // Bartender action
      features: ['Fire Acts', 'Juggling Show', '2 Hour Set'],
    ),
    StaticItem(
      id: 'pbar_004',
      name: 'The Shot Station',
      description:
      'Dedicated shots counter with dry ice, LED trays, and flaming shots.',
      price: 18000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEVHIrzMTJ72XyiIDCOScWMf_gts7TyZk56A&s', // Shots
      features: ['Flaming Shots', 'LED Trays', 'Party Props'],
    ),
    StaticItem(
      id: 'pbar_005',
      name: 'Rustic Beer Boat',
      description:
      'A wooden canoe filled with crushed ice and assorted chilled beers.',
      price: 12000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQxtFGHI9D2ooPnT-LV3oIyketSzGxtgW50Q&s', // Beer/Ice
      features: ['Aesthetic Setup', 'Self-Serve', 'Ice Included'],
    ),
    StaticItem(
      id: 'pbar_006',
      name: 'Champagne Tower',
      description:
      'A luxurious 5-tier glass tower for a celebratory champagne toast.',
      price: 22000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkJZ-mFB92l6kcQYDEygVLq7F1Td0xK_FD2Q&s', // Champagne
      features: ['5-Tier Glasses', 'Sparkling Cider', 'Toast Setup'],
    ),
    StaticItem(
      id: 'pbar_007',
      name: 'Fresh Coconut Station',
      description:
      'Freshly cut tender coconuts branded with your party hashtag.',
      price: 10000,
      image:
      'https://static.wixstatic.com/media/a5b8c6_131712b180c749018de7714a47b531ba~mv2.jpg/v1/fit/w_500,h_500,q_90/file.jpg', // Coconut
      features: ['Laser Branded', 'Eco Straws', 'Refreshing'],
    ),
    StaticItem(
      id: 'pbar_008',
      name: 'Ice Gola / Slushy Cart',
      description:
      'A fun traditional Indian crushed ice cart with multiple flavors.',
      price: 8000,
      image:
      'https://www.shutterstock.com/image-vector/ice-gola-cart-bicycle-colourful-600w-2599487881.jpg', // Ice dessert
      features: ['6 Flavors', 'Live Counter', 'Kids Favorite'],
    ),
    StaticItem(
      id: 'pbar_009',
      name: 'Neon Theme Bar Counter',
      description:
      'Customized glowing LED bar setup tailored to your party theme.',
      price: 30000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqNdNXFgsiHS_fvWdHr5S5afD_LC2GN2ILHA&s', // Neon bar
      features: ['LED Counter', 'Custom Sign', 'Backbar Decor'],
    ),
    StaticItem(
      id: 'pbar_010',
      name: 'VIP Luxury Lounge Bar',
      description:
      'Exclusive enclosed bar experience for VIP guests with a dedicated server.',
      price: 60000,
      image:
      'https://static.wixstatic.com/media/3962bf_ea70a878e6774005b4881fa4a94d6787~mv2.png/v1/fill/w_568,h_568,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/3962bf_ea70a878e6774005b4881fa4a94d6787~mv2.png', // High end lounge
      features: ['Premium Crystal', 'Private Setup', 'Imported Style'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text(
          'Bar & Drinks',
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
              itemCount: barItems.length,
              itemBuilder: (context, index) => _BarCard(item: barItems[index]),
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

class _BarCard extends StatelessWidget {
  final StaticItem item;
  const _BarCard({required this.item});

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
                child: const Icon(Icons.local_bar, color: Colors.indigo),
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
                                  sectionId: PartyBarScreen.sectionId,
                                  sectionName: PartyBarScreen.sectionName,
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
