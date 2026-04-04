import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class AnniversaryDecorScreen extends StatelessWidget {
  const AnniversaryDecorScreen({super.key});

  static const String sectionId = 'anniversary_decor';
  static const String sectionName = 'Decoration';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ANNIVERSARY DECORATION THEMES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'adec_001',
      name: 'Romantic Room Surprise',
      description: 'Complete bedroom makeover with rose petals, heart balloons, and candles.',
      price: 8000,
      image: 'https://thumbs.dreamstime.com/b/romantic-room-decoration-heart-pillows-rose-petals-lit-candles-decorative-lights-valentine-s-day-heart-shaped-fairy-354678121.jpg',
      features: ['500 Petals', 'Heart Balloons', 'Scented Candles'],
    ),
    StaticItem(
      id: 'adec_002',
      name: 'Private Terrace Cabana',
      description: 'Elegant wooden cabana setup with fairy lights and private dining decor.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiAsJukA0918kTw9BnMucCm3hoeVwBCCohrA&s',
      features: ['White Drapes', 'Fairy Lights', 'Floor Cushions'],
    ),
    StaticItem(
      id: 'adec_003',
      name: 'Luxury Hotel Suite Decor',
      description: 'Premium decoration for a hotel suite including a rose heart on bed.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkUFU99R-mSe2FM9aByPa2-6wO1hX87-kKow&s',
      features: ['Professional Setup', 'Balloon Bouquet', 'Rose Heart'],
    ),
    StaticItem(
      id: 'adec_004',
      name: 'Outdoor Cinema Setup',
      description: 'Romantic open-air movie screening setup with cozy seating and decor.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQprQ4Lypi38BoSzQ9VEPAxVA0B_EmgXy-v_Q&s',
      features: ['Projector & Screen', 'Speaker System', 'Cozy Seating'],
    ),
    StaticItem(
      id: 'adec_005',
      name: 'Golden Jubilee Theme',
      description: 'Classic gold and white theme perfect for 25th or 50th anniversaries.',
      price: 25000,
      image: 'https://m.media-amazon.com/images/I/81IuO6oa1TL.jpg',
      features: ['Custom Numbers', 'Golden Arch', 'Champagne Wall'],
    ),
    StaticItem(
      id: 'adec_006',
      name: 'Bohemian Love Nest',
      description: 'Trendy boho-style setup with pampas grass and macramé hangings.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-y9LdhgjJm3ZAWYYS_BLRp-9V3N1JuoblTQ&s',
      features: ['Pampas Grass', 'Macramé Backdrop', 'Dreamcatchers'],
    ),
    StaticItem(
      id: 'adec_007',
      name: 'LED Memory Photo Wall',
      description: 'A beautiful string light display featuring your best moments over the years.',
      price: 6000,
      image: 'https://i.etsystatic.com/23513616/r/il/12921f/4010574433/il_1080xN.4010574433_e8xy.jpg',
      features: ['50 Photos', 'Clips & Lights', 'Gift Box incl.'],
    ),
    StaticItem(
      id: 'adec_008',
      name: 'Candlelight Dinner Setup',
      description: 'Elegant table styling with fine cutlery, flowers, and floating candles.',
      price: 5000,
      image: 'https://generalwax.com/cdn/shop/articles/Wedding-table-decorations-1.jpg?v=1719834589&width=1100',
      features: ['Table Runner', 'Flower Vases', 'Floating Diyas'],
    ),
    StaticItem(
      id: 'adec_009',
      name: 'Garden Floral Arch',
      description: 'Magnificent entrance archway decorated with real fresh roses and lilies.',
      price: 30000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbYA6MMjX1rzqSaZ5c90uEIwzAuGZEfOtKVw&s',
      features: ['Real Flowers', 'Fragrance Tech', 'Red Carpet'],
    ),
    StaticItem(
      id: 'adec_010',
      name: 'Floating Balloon Pool Decor',
      description: 'Romantic pool-side setup with floating flowers and balloons.',
      price: 11000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRj40dBC2OKZY3E9chj-nYWWQ05fS2Br9Q7VA&s',
      features: ['Waterproof LEDs', 'Flower Ropes', 'Side Decor'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Anniversary Decor',
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
                      const Text('Total Ready', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50),
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
                                  sectionId: AnniversaryDecorScreen.sectionId,
                                  sectionName: AnniversaryDecorScreen.sectionName,
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