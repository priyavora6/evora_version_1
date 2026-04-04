import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CorporateDecorScreen extends StatelessWidget {
  const CorporateDecorScreen({super.key});

  static const String sectionId = 'c_decor';
  static const String sectionName = 'Corporate Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CORPORATE DECOR PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'cdec_001',
      name: 'Professional Stage Setup',
      description: 'Elegant stage with customized flex backdrop and soft lighting.',
      price: 20000,
      image: 'https://cdn.prod.website-files.com/656931bf63931ea93ef3d6da/67a211040763d72591276cde_corporate%20Stage%20Design%20(1).jpg',
      features: ['Flex Backdrop', 'Podium', 'Soft Lighting'],
    ),
    StaticItem(
      id: 'cdec_002',
      name: 'Grand Entrance Decor',
      description: 'Welcome your guests with a branded archway and red carpet.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCccLAZvUtVNqaNRTy85pGSXz1EK0naXzYvg&s',
      features: ['Branded Arch', 'Red Carpet', 'Welcome Board'],
    ),
    StaticItem(
      id: 'cdec_003',
      name: 'Conference Table Setup',
      description: 'Professional table styling with neat covers and centerpieces.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt9WUIe-PYft0J0lUXERxKn1KMAdfl7oiSrg&s',
      features: ['Table Covers', 'Centerpieces', 'Nameplates'],
    ),
    StaticItem(
      id: 'cdec_004',
      name: 'Complete Branding Kit',
      description: 'Venue-wide corporate branding including standees and banners.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAk0NlxCymIseO07wvRZVDo3TFFiA6R77x0w&s',
      features: ['6 Standees', 'Logo Display', 'Venue Banners'],
    ),
    StaticItem(
      id: 'cdec_005',
      name: 'LED Screen Backdrop',
      description: 'Dynamic digital backdrop for high-end corporate presentations.',
      price: 30000,
      image: 'https://www.shutterstock.com/image-illustration/blue-futuristic-technology-tunnel-background-600nw-2732217927.jpg',
      features: ['10x8 LED Wall', 'Tech Operator', 'Stage Skirting'],
    ),
    StaticItem(
      id: 'cdec_006',
      name: 'Branded Photo Booth',
      description: 'Custom photo zone with corporate props for social engagement.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv2dgUMWTpXAzsOVGavVx8hufuwlSL4UNu3Q&s',
      features: ['Custom Backdrop', 'Fun Props', 'Ring Light'],
    ),
    StaticItem(
      id: 'cdec_007',
      name: 'Premium Floral Decor',
      description: 'Sophisticated flower arrangements for stage and VIP tables.',
      price: 18000,
      image: 'https://www.brides.com/thmb/m5bxybFOwGO7okn4qHZ9l-g5HX8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/wedding-floral-centerpiece-ideas-recirc-move-mountains-co-35b74293827c41cb94367a7a515eb633.jpg',
      features: ['Fresh Lilies', 'Podium Bouquet', 'Vase Setup'],
    ),
    StaticItem(
      id: 'cdec_008',
      name: 'Gala Dinner Lighting',
      description: 'Ambient venue lighting to transition from day meeting to night party.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTugrpKxGCkBnzEwkjeCTJS7sFasNhh0Le4Uw&s',
      features: ['Ambient Wash', 'Spotlights', 'Color Mix'],
    ),
    StaticItem(
      id: 'cdec_009',
      name: 'Award Ceremony Stage',
      description: 'Grand setup specialized for corporate R&R and award nights.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDUYRiLDiCMfyjWl7TVdu2loIhgHP8yuQA0A&s',
      features: ['Grand Steps', 'Trophy Display', 'Sparklers'],
    ),
    StaticItem(
      id: 'cdec_010',
      name: 'The CEO Package',
      description: 'Ultimate luxury decor with LED wall, florals, and full branding.',
      price: 75000,
      image: 'https://m.media-amazon.com/images/I/81ehMPzcDsL._AC_UF894,1000_QL80_.jpg',
      features: ['Full Venue', 'LED + Stage', 'VIP Lounge'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Corporate Decor',
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
              itemCount: decorItems.length,
              itemBuilder: (context, index) => _DecorCard(item: decorItems[index]),
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.business_center, color: Colors.indigo)),
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
                                  sectionId: CorporateDecorScreen.sectionId,
                                  sectionName: CorporateDecorScreen.sectionName,
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