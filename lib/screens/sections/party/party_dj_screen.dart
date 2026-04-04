import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PartyDJScreen extends StatelessWidget {
  const PartyDJScreen({super.key});

  static const String sectionId = 'p_dj';
  static const String sectionName = 'DJ & Music';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 HIGH-ENERGY DJ & MUSIC PACKAGES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> djItems = [
    StaticItem(
      id: 'pdj_001',
      name: 'House Party Essentials',
      description:
      'Compact 2-speaker sound system with a Bluetooth DJ controller for home parties.',
      price: 15000,
      image:
      'https://image.made-in-china.com/2f0j00AZVkqPUCkgoy/Party-Speaker-Wooden-Pair-2-0-Bluetooth-Passive-DJ-Speaker.webp',
      features: ['2 JBL Speakers', 'Digital Console', '4 Hours'],
    ),
    StaticItem(
      id: 'pdj_002',
      name: 'Bollywood Night Specialist',
      description:
      'Expert DJ specializing in Bollywood, Punjabi, and Retro hits to keep the floor moving.',
      price: 25000,
      image:
      'https://content.jdmagicbox.com/v2/comp/delhi/i8/011pxx11.xx11.231220162006.t4i8/catalogue/shyam-dj-sound-and-light-decoration-chattarpur-delhi-dj-system-on-rent-niwa0r5g6e.jpg',
      features: ['Pro DJ', '4 Top Speakers', 'Desi Hits'],
    ),
    StaticItem(
      id: 'pdj_003',
      name: 'Silent Disco Experience',
      description:
      'Trendy headphone party where guests switch between 3 different DJ channels.',
      price: 40000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTB5bTdZVYx5LfqvAGT546YlPJlGrJ1nKoVGQ&s', // Headphones
      features: ['50 Headsets', '3 Channels', 'No Noise'],
    ),
    StaticItem(
      id: 'pdj_004',
      name: 'EDM Festival Setup',
      description:
      'Club-level sound with heavy bass subs, lasers, and smoke machines.',
      price: 60000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmmEpKdZoGnYu7VnWHg-k2vJ8-wnCFYuP9PQ&s',
      features: ['Line Array', 'Laser Show', 'Smoke Machine'],
    ),
    StaticItem(
      id: 'pdj_005',
      name: 'Karaoke & DJ Combo',
      description:
      'Interactive karaoke setup with a host, followed by a DJ dance session.',
      price: 20000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0uxQyF0DvPq-bzXu0irINuX6lHRPc7aA7cA&s', // Mic/Singing
      features: ['Lyrics Screen', '2 Mics', 'DJ Host'],
    ),
    StaticItem(
      id: 'pdj_006',
      name: 'Live Dhol Fusion',
      description:
      'High-energy live dhol players jamming alongside the DJ tracks.',
      price: 45000,
      image:
      'https://content.jdmagicbox.com/comp/guntur/p8/9999px863.x863.221223143046.e9p8/catalogue/kawa-punjabi-dhol-group-event-tadepalle-guntur-dhol-players-1ymowrnr1l.jpg', // Drum/Beat
      features: ['2 Dhol Players', 'Fusion Mix', 'Crowd Favorite'],
    ),
    StaticItem(
      id: 'pdj_007',
      name: 'Pool Party Sound Rig',
      description:
      'Water-resistant outdoor speakers with upbeat tropical and pop music.',
      price: 22000,
      image:
      'Water-resistant outdoor speakers with upbeat tropical and pop music.', // Pool vibe
      features: ['Outdoor Sound', 'Water Safe', 'Daytime Vibes'],
    ),
    StaticItem(
      id: 'pdj_008',
      name: 'Vinyl Retro DJ',
      description:
      'Old-school DJ spinning actual vinyl records for a classic 80s/90s vibe.',
      price: 30000,
      image:
      'hhttps://www.shutterstock.com/image-photo/classic-turntable-spinning-blue-vinyl-260nw-2571562513.jpg', // Vinyl
      features: ['Real Vinyls', 'Retro Console', 'Classic Hits'],
    ),
    StaticItem(
      id: 'pdj_009',
      name: 'Celebrity Guest DJ',
      description:
      'Book a famous club DJ for a 90-minute exclusive performance.',
      price: 100000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe_iTi7aeY2Qu7QTXZB6h7ocYwjCTNoQr26w&s', // Famous DJ
      features: ['Celebrity Act', 'Meet & Greet', 'Press Kit'],
    ),
    StaticItem(
      id: 'pdj_010',
      name: 'Intelligent Lighting Add-on',
      description:
      'Enhance any DJ package with moving heads, sharpies, and pixel tubes.',
      price: 18000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYdUuTyCwG-i2lO0DYAK91HKhlwUQ5sHEahg&s', // Lights
      features: ['4 Sharpies', 'Pixel Tubes', 'DMX Control'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text(
          'DJ & Music',
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
              itemCount: djItems.length,
              itemBuilder: (context, index) => _DJCard(item: djItems[index]),
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

class _DJCard extends StatelessWidget {
  final StaticItem item;
  const _DJCard({required this.item});

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
                child: const Icon(Icons.music_note, color: Colors.indigo),
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
                                  sectionId: PartyDJScreen.sectionId,
                                  sectionName: PartyDJScreen.sectionName,
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
