
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class GraduationGownScreen extends StatelessWidget {
  const GraduationGownScreen({super.key});

  static const String sectionId = 'g_gown';
  static const String sectionName = 'Gown & Cap';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM GRADUATION APPAREL SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> gownItems = [
    StaticItem(
      id: 'ggwn_001',
      name: 'Basic Rental Gown Set',
      description: 'Standard black graduation gown with a matching cap and year tassel.',
      price: 500,
      image: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=500&auto=format&fit=crop',
      features: ['1 Day Rental', 'Cap & Tassel', 'Standard Fit'],
    ),
    StaticItem(
      id: 'ggwn_002',
      name: 'Premium Silk Gown Set',
      description: 'High-quality, breathable silk-blend gown that looks flawless in photos.',
      price: 1200,
      image: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=500&auto=format&fit=crop',
      features: ['Silk Blend', '2 Day Rental', 'Wrinkle Free'],
    ),
    StaticItem(
      id: 'ggwn_003',
      name: 'Purchase Your Gown',
      description: 'Keep your graduation gown forever as a lifelong memory of your achievement.',
      price: 2500,
      image: 'https://images.unsplash.com/photo-1525926477800-7a3b10316ac6?q=80&w=500&auto=format&fit=crop',
      features: ['Own Forever', 'Premium Fabric', 'Brand New'],
    ),
    StaticItem(
      id: 'ggwn_004',
      name: 'Master’s / PhD Velvet Gown',
      description: 'Luxury velvet-trimmed gown with distinctive bell sleeves for higher degrees.',
      price: 2000,
      image: 'https://images.unsplash.com/photo-1565022536102-f7645c84354a?q=80&w=500&auto=format&fit=crop',
      features: ['Velvet Trim', 'Hood Included', '2 Day Rental'],
    ),
    StaticItem(
      id: 'ggwn_005',
      name: 'Group Rental (Pack of 5)',
      description: 'Special discounted package for you and your best friends to match perfectly.',
      price: 2000,
      image: 'https://images.unsplash.com/photo-1589330694653-efa6de1289de?q=80&w=500&auto=format&fit=crop',
      features: ['5 Gown Sets', 'Group Discount', 'Color Match'],
    ),
    StaticItem(
      id: 'ggwn_006',
      name: 'Kids Kindergarten Gown',
      description: 'Adorable mini graduation gowns for kindergarten or primary school grads.',
      price: 400,
      image: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=500&auto=format&fit=crop',
      features: ['Lightweight', 'Safe Fabric', 'Mini Cap'],
    ),
    StaticItem(
      id: 'ggwn_007',
      name: 'Custom Gold Embroidery',
      description: 'Personalize your rented or purchased gown with your name embroidered in gold.',
      price: 600,
      image: 'https://images.unsplash.com/photo-1513258496099-48168024aec0?q=80&w=500&auto=format&fit=crop',
      features: ['Custom Name', 'Gold Thread', 'Add-on Service'],
    ),
    StaticItem(
      id: 'ggwn_008',
      name: 'Customized Honor Stole',
      description: 'A beautiful satin sash worn over the shoulders, customized with your major.',
      price: 800,
      image: 'https://images.unsplash.com/photo-1523580846011-d3a5ce25c59a?q=80&w=500&auto=format&fit=crop',
      features: ['Satin Fabric', 'Custom Text', 'Keep Forever'],
    ),
    StaticItem(
      id: 'ggwn_009',
      name: 'Alumni Memory Cap & Charm',
      description: 'A brand new cap featuring a customized year charm to keep as a souvenir.',
      price: 500,
      image: 'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?q=80&w=500&auto=format&fit=crop',
      features: ['Year Charm', 'Hard Board', 'Memory Item'],
    ),
    StaticItem(
      id: 'ggwn_010',
      name: 'The Ultimate Grad Wardrobe',
      description: 'Premium Gown, Cap, Honor Stole, Custom Embroidery, and 3-day extended rental.',
      price: 3500,
      image: 'https://images.unsplash.com/photo-1627556704290-2b1f5853ff78?q=80&w=500&auto=format&fit=crop',
      features: ['All Inclusive', '3 Day Rental', 'VIP Support'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Gowns & Apparel',
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
              itemCount: gownItems.length,
              itemBuilder: (context, index) => _GownCard(item: gownItems[index]),
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

class _GownCard extends StatelessWidget {
  final StaticItem item;
  const _GownCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.school, color: Colors.indigo)),
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
                                  sectionId: GraduationGownScreen.sectionId,
                                  sectionName: GraduationGownScreen.sectionName,
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