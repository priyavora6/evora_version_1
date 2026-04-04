import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CorporateAVScreen extends StatelessWidget {
  const CorporateAVScreen({super.key});

  static const String sectionId = 'c_av';
  static const String sectionName = 'AV Equipment';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CORPORATE AV PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> avItems = [
    StaticItem(
      id: 'cav_001',
      name: 'Basic Boardroom AV',
      description: 'Standard projector and audio setup for small meetings.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShcXCeKxojsI4YOLDoNIsLvb0_gIIcDAFM9w&s',
      features: ['HD Projector', '2 Speakers', 'Clicker incl.'],
    ),
    StaticItem(
      id: 'cav_002',
      name: 'Conference Audio Setup',
      description: 'Complete multi-mic audio system for large conferences.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa_jVL4GzppXbp-LrBY8WfaxJ2nrLsMBULdw&s',
      features: ['4 Wireless Mics', 'Podium Mic', 'Sound Tech'],
    ),
    StaticItem(
      id: 'cav_003',
      name: 'Live Streaming Rig',
      description: 'Professional multi-camera setup for hybrid events.',
      price: 30000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-pt3iCINgUkSQEsc8xgxzDCi8_J60vJxAiA&s',
      features: ['2 HD Cameras', 'Live Switcher', 'Web Setup'],
    ),
    StaticItem(
      id: 'cav_004',
      name: 'Indoor LED Wall',
      description: 'High-resolution P3 LED screen for crisp presentations.',
      price: 50000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuavQWQ2-UhEXOZwPKx7mKqKGdpSCgEeAYVw&s',
      features: ['12x8 ft Size', 'Laptop Switch', 'Tech Support'],
    ),
    StaticItem(
      id: 'cav_005',
      name: 'Townhall Sound System',
      description: 'High-quality Line Array sound system for 500+ attendees.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMK7KDlP91m-HnUyZgnqYqZz00B0sAVenXtQ&s',
      features: ['Line Array', 'Digital Mixer', 'Sound Engineer'],
    ),
    StaticItem(
      id: 'cav_006',
      name: 'Corporate Video Coverage',
      description: 'Cinematic recording of the event with highlights reel.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5G8ItCFdhQB8B52uqEP9ztm0FZ2YbPnjVQQ&s',
      features: ['4K Camera', 'Highlight Edit', 'Raw Footage'],
    ),
    StaticItem(
      id: 'cav_007',
      name: 'Webinar & Zoom Setup',
      description: 'Specialized setup for smooth Zoom/Teams townhall broadcasting.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQ5CDELbm6UbmFMM1nswvujkSG-VXWFuaN1A&s',
      features: ['Capture Card', 'HD Webcams', 'Audio Route'],
    ),
    StaticItem(
      id: 'cav_008',
      name: 'Interactive Touch Panel',
      description: 'Large 75-inch smart touch display for interactive workshops.',
      price: 20000,
      image: 'https://image.made-in-china.com/2f0j00HclhLDognAYJ/75-Inch-All-in-One-Interactive-Touch-Screen-Flat-Panel-School-Teaching-Interactive-Smart-Screen.jpg',
      features: ['75" Touch Screen', 'Stylus Pen', 'Screen Cast'],
    ),
    StaticItem(
      id: 'cav_009',
      name: 'Stage Lighting Package',
      description: 'Professional stage wash and profile lighting for keynotes.',
      price: 28000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDoA9VDZXmeRuZSKzHkz2Vv0wC0f_cI3bHwQ&s',
      features: ['Stage Wash', 'Moving Heads', 'Light Jockey'],
    ),
    StaticItem(
      id: 'cav_010',
      name: 'The CEO Package',
      description: 'The ultimate combo: LED Wall, Live Stream, Pro Audio, and Lighting.',
      price: 90000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDAE-mV4-nsBi3cD4e3w9wVD7l5c9akKjUvw&s',
      features: ['LED Screen', 'Multi-Cam', 'Full AV Team'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('AV & Equipment',
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
              itemCount: avItems.length,
              itemBuilder: (context, index) => _AVCard(item: avItems[index]),
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

class _AVCard extends StatelessWidget {
  final StaticItem item;
  const _AVCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.mic, color: Colors.indigo)),
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
                                  sectionId: CorporateAVScreen.sectionId,
                                  sectionName: CorporateAVScreen.sectionName,
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