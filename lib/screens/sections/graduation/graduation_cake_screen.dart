import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class GraduationCakeScreen extends StatelessWidget {
  const GraduationCakeScreen({super.key});

  static const String sectionId = 'g_cake';
  static const String sectionName = 'Cake';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM GRADUATION CAKES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> cakeItems = [
    StaticItem(
      id: 'gc_001',
      name: 'Classic Graduation Cap Cake',
      description: 'Elegant chocolate cake shaped and styled as a traditional graduation cap.',
      price: 1800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJhb1BsyuExKGFiOTpJRDcaAo--kszQvNWqA&s',
      features: ['1 Kg', 'Fondant Cap', 'Custom Tassel Color'],
    ),
    StaticItem(
      id: 'gc_002',
      name: 'Degree Book Cake',
      description: 'A beautiful open-book design with edible text congratulating the graduate.',
      price: 2500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsNWU5tdc-XxaKki_COMNqp-QtFY6vgbdYgw&s',
      features: ['1.5 Kg', 'Edible Print', 'Vanilla Sponge'],
    ),
    StaticItem(
      id: 'gc_003',
      name: '2-Tier Celebration Cake',
      description: 'Grand two-tier cake featuring a diploma scroll and cap topper.',
      price: 4500,
      image: 'https://static.wixstatic.com/media/a2fe96_c2fd23a23d474f07b43cfc88e6e4e1cc~mv2.webp/v1/fill/w_980,h_980,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/a2fe96_c2fd23a23d474f07b43cfc88e6e4e1cc~mv2.webp',
      features: ['3 Kg', 'Designer Decor', 'Party Size'],
    ),
    StaticItem(
      id: 'gc_004',
      name: 'Medical / Law Theme Cake',
      description: 'Customized cake with stethoscopes or law gavels for specific degrees.',
      price: 3200,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6t_AwSRXSaVlO9ggGf3kVkDk1SgX8h3yoSg&s',
      features: ['2 Kg', 'Custom Props', 'Fondant Finish'],
    ),
    StaticItem(
      id: 'gc_005',
      name: 'Class of 2024 Cupcake Tower',
      description: 'A stunning tower of 24 themed cupcakes topped with mini grad caps.',
      price: 2800,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxUaoIkBONKMSJzUeF5HWol6cFieGWW8RVMQ&s', // Cupcakes
      features: ['24 Pcs', 'Easy Serving', 'Tower Included'],
    ),
    StaticItem(
      id: 'gc_006',
      name: 'Future is Bright Pinata',
      description: 'A hammer-smash chocolate shell revealing candies and a hidden cake.',
      price: 2200,
      image: 'https://m.media-amazon.com/images/I/51wldG5bIhL.jpg',
      features: ['Interactive', 'Hammer Incl.', 'Chocolate Shell'],
    ),
    StaticItem(
      id: 'gc_007',
      name: 'University Logo Cake',
      description: 'Premium cake featuring an exact edible replica of the University logo.',
      price: 2600,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTycgc3A5vKiD37IYLLD5E85Mr5q2uyyRuHCw&s',
      features: ['1.5 Kg', 'HD Edible Print', 'Red Velvet'],
    ),
    StaticItem(
      id: 'gc_008',
      name: 'Golden Star Achievement Cake',
      description: 'Elegant white and gold cake with starry decorations to celebrate success.',
      price: 3000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSBMzuZ6tIlByOqZw1Jp9sjbPIYAkgxGKo7g&s',
      features: ['2 Kg', 'Gold Leaf', 'Classy Design'],
    ),
    StaticItem(
      id: 'gc_009',
      name: 'Bento Grad Cake',
      description: 'Trendy, minimalist mini cake for an intimate family celebration.',
      price: 900,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd4ozLSbPUCOyUlNWl-WBrxEOI4R8Q0uam1Q&s',
      features: ['300g', 'Minimalist', 'Korean Style'],
    ),
    StaticItem(
      id: 'gc_010',
      name: 'Macaron & Floral Delight',
      description: 'Sophisticated graduation cake decorated with fresh flowers and French macarons.',
      price: 4000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwJJRKO2uljp8sRW72g-XkZ8nd1kzY3WXgfQ&s',
      features: ['2 Kg', 'Real Flowers', 'Premium Taste'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Graduation Cakes',
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
              itemCount: cakeItems.length,
              itemBuilder: (context, index) => _CakeCard(item: cakeItems[index]),
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

class _CakeCard extends StatelessWidget {
  final StaticItem item;
  const _CakeCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.cake, color: Colors.indigo)),
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
                                  sectionId: GraduationCakeScreen.sectionId,
                                  sectionName: GraduationCakeScreen.sectionName,
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