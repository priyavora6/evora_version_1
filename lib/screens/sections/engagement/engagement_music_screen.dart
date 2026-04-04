

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EngagementMusicScreen extends StatelessWidget {
  const EngagementMusicScreen({super.key});

  static const String sectionId = 'e_music';
  static const String sectionName = 'Music & DJ';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM MUSIC & DJ SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> musicItems = [
    StaticItem(
      id: 'emuz_001',
      name: 'Basic Ceremony Audio',
      description: 'Clear and crisp audio setup perfect for background music and ring exchange announcements.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkfU91vmeONGSfFy3xmSYlj5JRsA9wVgZBvg&s',
      features: ['2 JBL Speakers', 'Wireless Mics', 'Audio Tech'],
    ),
    StaticItem(
      id: 'emuz_002',
      name: 'Professional Party DJ',
      description: 'Experienced DJ to keep the dance floor packed with the latest Bollywood and Punjabi tracks.',
      price: 25000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Xfn3dKQFcAYdDXkpWqBNXEUalzGNlQh9Tw&s',
      features: ['Pro DJ Console', '4 Top Speakers', 'LED Booth'],
    ),
    StaticItem(
      id: 'emuz_003',
      name: 'Live Sufi Band',
      description: 'Soulful live musical performance for an elegant, sit-down engagement evening.',
      price: 45000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBMbVEVew9OBbj4WIvnAQgYDOI6uiZj9YVmQ&s',
      features: ['5 Band Members', '2 Hours', 'Acoustic Setup'],
    ),
    StaticItem(
      id: 'emuz_004',
      name: 'Acoustic Guitarist & Singer',
      description: 'A solo artist playing romantic Bollywood covers during guest arrival and dinner.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDFcHZdsFWyD-TkA2cDfrahqko2aGA92ukvQ&s',
      features: ['Solo Artist', 'Romantic Hits', 'Dinner Ambience'],
    ),
    StaticItem(
      id: 'emuz_005',
      name: 'Club Lighting Package',
      description: 'Transform your venue into a nightclub with intelligent moving heads and lasers.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1_emVwSy0YnqKmmVOAEtlbLKb_vt3k9ecuQ&s',
      features: ['4 Moving Heads', 'Lasers', 'Smoke Machine'],
    ),
    StaticItem(
      id: 'emuz_006',
      name: 'LED Dance Floor',
      description: 'Interactive pixel-mapped LED dance floor that changes colors with the music.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR36hYx7Sbis7EP_AzME9d_pNQZ4lUQVz8K5Q&s',
      features: ['16x16 ft Size', 'Sound Reactive', 'Slip Resistant'],
    ),
    StaticItem(
      id: 'emuz_007',
      name: 'Percussionist / Dhol Mix',
      description: 'Live percussion player jamming alongside the DJ to pump up the crowd energy.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrGA4gexfHEH6sNwsvpfW88xLTzLBAWOc_jQ&s',
      features: ['Electronic Drums', 'Live Dhol', 'High Energy'],
    ),
    StaticItem(
      id: 'emuz_008',
      name: 'Violinist for Ring Entry',
      description: 'A professional violinist walking the couple to the stage with a romantic tune.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdKZ4tjqpzn4DXpbJn9LXDDtDi9mgu3xsDGQ&s',
      features: ['Grand Entry', 'Classical', 'Custom Song'],
    ),
    StaticItem(
      id: 'emuz_009',
      name: 'Celebrity Anchor',
      description: 'Renowned host to entertain guests, manage the itinerary, and conduct fun games.',
      price: 30000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFtD-z1Q9ULDAcyMe0CUwZlHl7v5xG6ciUng&s',
      features: ['Pro Host', 'Game Conductor', 'Crowd Interaction'],
    ),
    StaticItem(
      id: 'emuz_010',
      name: 'Mega Concert Setup',
      description: 'Massive line array sound system and truss lighting for an outdoor mega event.',
      price: 80000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwpQ6a0lQVTzl5uhEXPWZu5bl796Lidvhr2g&s',
      features: ['Line Array Audio', 'Box Truss', '500+ Guests'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Music & DJ',
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
              itemCount: musicItems.length,
              itemBuilder: (context, index) => _MusicCard(item: musicItems[index]),
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

class _MusicCard extends StatelessWidget {
  final StaticItem item;
  const _MusicCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.music_note, color: Colors.indigo)),
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
                                  sectionId: EngagementMusicScreen.sectionId,
                                  sectionName: EngagementMusicScreen.sectionName,
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



