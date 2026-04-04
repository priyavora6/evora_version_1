import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CorporatePhotographyScreen extends StatelessWidget {
  const CorporatePhotographyScreen({super.key});

  static const String sectionId = 'c_photo';
  static const String sectionName = 'Corporate Photography';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CORPORATE MEDIA PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> photoItems = [
    StaticItem(
      id: 'cph_001',
      name: 'Event Coverage (Half Day)',
      description: 'Professional photography coverage for seminars, workshops, or brief meetings.',
      price: 15000,
      image: 'https://marcinkrokowski.com/wp-content/uploads/2025/03/marcin-krokowski-fotograf-eventowy-backstage-00002-900x600.jpg.webp',
      features: ['4 Hours', '150+ Edited Photos', 'Quick Delivery'],
    ),
    StaticItem(
      id: 'cph_002',
      name: 'Event Coverage (Full Day)',
      description: 'Comprehensive photography capturing every moment of your major corporate event.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRitzBVvMmlr0ev36b6qQhzn0KQr-PZINC4TA&s',
      features: ['8 Hours', '300+ Edited Photos', 'Cloud Gallery'],
    ),
    StaticItem(
      id: 'cph_003',
      name: 'Executive Headshots',
      description: 'Premium studio-style headshots for leadership teams and employee ID profiles.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDV4Xq6wpyyWrN4bILZ2eMp5p_XKwBK3YViA&s',
      features: ['Mobile Studio', 'Retouching', 'Up to 20 Pax'],
    ),
    StaticItem(
      id: 'cph_004',
      name: 'Cinematic Event Film',
      description: 'High-quality video coverage producing a professional corporate highlight reel.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnP9orHC1JeuCr2CxXg2p20vQunHtnmmK8bA&s',
      features: ['4K Video', '3-5 Min Highlight', 'Licensed Music'],
    ),
    StaticItem(
      id: 'cph_005',
      name: 'Live Stream Setup',
      description: 'Professional multi-camera live streaming for virtual or hybrid townhalls.',
      price: 40000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7fsD-S_61ZuI-wnx3SXyM59FJJhCDwV3UqA&s',
      features: ['2 HD Cameras', 'Live Switcher', 'Tech Operator'],
    ),
    StaticItem(
      id: 'cph_006',
      name: 'Team & Branding Shoot',
      description: 'Creative lifestyle photography showcasing office culture and team collaboration.',
      price: 20000,
      image: 'https://media.istockphoto.com/id/1333943998/photo/group-of-smiling-businesspeople-in-a-casual-meeting-at-their-company.jpg?s=612x612&w=0&k=20&c=JTD9DxAQGOhH_2CTpfba3E8XAxYBcxvQ3-UAJf_jMNA=',
      features: ['Office Shoot', 'Marketing Use', 'High Resolution'],
    ),
    StaticItem(
      id: 'cph_007',
      name: 'CEO / Founder Profile Film',
      description: 'A polished, documentary-style interview video for leadership profiling.',
      price: 45000,
      image: 'https://i.ytimg.com/vi/S6CeaAM76w4/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLD_CFGeGtDME3JbH04WsbeLS40E7A',
      features: ['Multi-cam Interview', 'B-Roll Shots', 'Pro Audio'],
    ),
    StaticItem(
      id: 'cph_008',
      name: 'Product Photography',
      description: 'Clean, crisp studio photography for new corporate merchandise or products.',
      price: 18000,
      image: 'https://www.adobe.com/in/creativecloud/photography/discover/media_1713acadcfcee279eb4d5a34f99c1763f2d9130c9.png?width=750&format=png&optimize=medium', // Product/Desk focus
      features: ['White Background', 'Color Correction', 'E-com Ready'],
    ),
    StaticItem(
      id: 'cph_009',
      name: 'Drone Aerial Coverage',
      description: 'Stunning bird\'s-eye view shots of your outdoor corporate retreat or venue.',
      price: 22000,
      image: 'https://media.istockphoto.com/id/1598894658/photo/aerial-view-of-man-mowing-the-lawn-in-his-back-garden.jpg?s=612x612&w=0&k=20&c=JGpXWoJnELjdnz18wq1N3bNGaDQb5QW5gqtIvU-gG98=',
      features: ['4K Drone', 'Licensed Pilot', 'Cinematic Angles'],
    ),
    StaticItem(
      id: 'cph_010',
      name: 'The Mega Media Package',
      description: 'Ultimate media coverage: Photo, Video, Drone, and same-day express edits.',
      price: 85000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWiQQM7-uFLn-iGCOlnrAKYUhYnT6D-R5cGA&s',
      features: ['Full Team', 'Express Edits', 'All-Inclusive'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Photography & Media',
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
              itemCount: photoItems.length,
              itemBuilder: (context, index) => _PhotoCard(item: photoItems[index]),
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
                                  sectionId: CorporatePhotographyScreen.sectionId,
                                  sectionName: CorporatePhotographyScreen.sectionName,
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