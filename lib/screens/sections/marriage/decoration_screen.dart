import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class MarriageDecorScreen extends StatelessWidget {
  const MarriageDecorScreen({super.key});

  static const String sectionId = 'marriage_decor';
  static const String sectionName = 'Decoration';

  static const List<StaticItem> decorItems = [
    StaticItem(
      id: 'mar_decor_001',
      name: 'Royal Floral Mandap',
      description: 'Traditional 4-pillar mandap with fresh exotic flowers and ritual seating.',
      price: 85000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTB-IVpzVc_AoZ8v2S9UMiwvE2Ljikf4udVGA&s',
      features: ['Fresh Flowers', 'Traditional Seating', 'Havan Setup'],
    ),
    StaticItem(
      id: 'mar_decor_002',
      name: 'Grand Reception Stage',
      description: 'Luxury stage backdrop with themed LED lighting and plush couple seating.',
      price: 125000,
      image: 'https://media.weddingz.in/images/09909f5de0dc38961cee6f533cb96fbf/Wedding-Reception-Stage-Decoration-Ideas29.jpg',
      features: ['Crystal Decor', 'LED Wall', 'Plush Sofa'],
    ),
    StaticItem(
      id: 'mar_decor_003',
      name: 'Vibrant Haldi Setup',
      description: 'Lively yellow-themed decor with marigold hangings and ethnic props.',
      price: 45000,
      image: 'https://www.marriagecolours.com/wp-content/uploads/2025/07/Hency-Kingsley-Haldi-royal-palms-3.jpg',
      features: ['Marigold Theme', 'Photo Booth', 'Swing Setup'],
    ),
    StaticItem(
      id: 'mar_decor_004',
      name: 'Royal Entrance Gate',
      description: 'Magnificent entry with floral archways and candle-lit pathways.',
      price: 35000,
      image: 'https://rankatentsuppliers.in/public/images/showcase/1707080756royal-wedding-gate.jpg',
      features: ['Floral Arch', 'Pathway Lights', 'Red Carpet'],
    ),
    StaticItem(
      id: 'mar_decor_005',
      name: 'Elegant Pathway',
      description: 'Beautifully decorated aisle leading to the mandap with flower vases.',
      price: 25000,
      image: 'https://static.vecteezy.com/system/resources/previews/060/999/564/large_2x/enchanted-garden-wedding-venue-with-sequential-light-tunnel-archways-elegant-floral-entrance-decoration-and-illuminated-pathway-with-scattered-rose-petals-photo.jpeg',
      features: ['Flower Vases', 'Petal Sprinkles', 'Side Lighting'],
    ),
    StaticItem(
      id: 'mar_decor_006',
      name: 'Mehendi Lounge',
      description: 'Relaxed and colorful seating with bolsters and bohemian umbrellas.',
      price: 40000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7p-_wzvFVcUWYCgzvBiqWKy3XRF4JiwmFeQ&s',
      features: ['Boho Theme', 'Floor Seating', 'Props'],
    ),
    StaticItem(
      id: 'mar_decor_007',
      name: 'Dinner Area Styling',
      description: 'Theme-based dining setup with elegant table runners and centerpieces.',
      price: 60000,
      image: 'https://i.pinimg.com/736x/db/a9/6d/dba96d4b9ea3d9326500d698cd4090d8.jpg',
      features: ['Table Styling', 'Chair Decor', 'Buffet Lighting'],
    ),
    StaticItem(
      id: 'mar_decor_008',
      name: 'Ceiling Chandelier',
      description: 'Grand ceiling drapes with crystal chandeliers and fairy light canopies.',
      price: 70000,
      image: 'https://www.brides.com/thmb/kYYBr9hqe6iMCPgyHb9r-xNfyM8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/elise-luke_43-3fad2173fa01443fbf8f6911ba36a2ca.jpg',
      features: ['Silk Drapes', 'Crystal Lamps', 'Mood Lighting'],
    ),
    StaticItem(
      id: 'mar_decor_009',
      name: 'Sangeet Light Show',
      description: 'Professional stage lighting setup with sharpy, pars, and smoke effects.',
      price: 55000,
      image: 'https://www.marriagecolours.com/wp-content/uploads/2025/06/Anjana-Dhruv-Sangeet-Temple-Bay-9.jpg',
      features: ['Sharpy Lights', 'Smoke Machine', 'DJ Backdrop'],
    ),
    StaticItem(
      id: 'mar_decor_010',
      name: 'Vidaai Car Decor',
      description: 'Elegant fresh flower decoration for the departure car.',
      price: 10000,
      image: 'https://cdn0.weddingwire.in/article/0539/original/1280/jpg/129350-car-flowers-decoration-3.jpeg',
      features: ['Rose Net', 'Ribbon Work', 'Wedding Tag'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background like screenshot
      appBar: AppBar(
        title: const Text('Decoration',
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
              padding: const EdgeInsets.all(16),
              itemCount: decorItems.length,
              itemBuilder: (context, index) => _MatchScreenshotCard(item: decorItems[index]),
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
                  right: 6, top: 6,
                  child: CircleAvatar(radius: 9, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
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
          padding: const EdgeInsets.all(20),
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
                      const Text('Section Total', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${AppStrings.rupee}${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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

// ═══════════════════════════════════════════════════════════════════════════
// EXACT SCREENSHOT MATCH CARD
// ═══════════════════════════════════════════════════════════════════════════
class _MatchScreenshotCard extends StatelessWidget {
  final StaticItem item;
  const _MatchScreenshotCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(item.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 155, // Exact height to match proportions
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24), // Highly rounded corners like screenshot
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              // 🖼️ LEFT IMAGE (Square-ish, matching screenshot)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                child: Image.network(
                  item.image,
                  width: 140, // Wider image block like the screenshot
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 140,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),

              // 📝 RIGHT CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A237E), // Dark Indigo Title
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Description
                      Text(
                          item.description,
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                      ),

                      const SizedBox(height: 8),

                      // Tags (Pill shaped, light blue bg)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: item.features.take(2).map((feature) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4FF), // Very light blue
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const Spacer(),

                      // 💰 PRICE AND BUTTON ROW (Perfectly Aligned)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price
                          Text(
                            '${AppStrings.rupee}${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF22C55E), // Vivid Green
                            ),
                          ),

                          // ADD Button
                          SizedBox(
                            height: 32,
                            width: 75,
                            child: isInCart
                                ? ElevatedButton(
                              onPressed: () {
                                cartProvider.removeItem(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} removed'), backgroundColor: Colors.red, duration: const Duration(milliseconds: 500)));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Change to green when selected
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 18),
                            )
                                : ElevatedButton(
                              onPressed: () {
                                cartProvider.addItem(CartItem(
                                  id: item.id,
                                  sectionId: MarriageDecorScreen.sectionId,
                                  sectionName: MarriageDecorScreen.sectionName,
                                  itemName: item.name,
                                  price: item.price,
                                  quantity: 1,
                                  image: item.image,
                                  type: 'package',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added'), backgroundColor: Colors.green, duration: const Duration(milliseconds: 500)));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A237E), // Dark Indigo Button
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0
                              ),
                              child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                            ),
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
      },
    );
  }
}