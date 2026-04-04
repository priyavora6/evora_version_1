import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class AnniversaryMusicScreen extends StatelessWidget {
  const AnniversaryMusicScreen({super.key});

  static const String sectionId = 'a_music';
  static const String sectionName = 'Music';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM MUSIC & ENTERTAINMENT SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> musicItems = [
    StaticItem(
      id: 'amuz_001',
      name: 'Acoustic Guitarist',
      description: 'Romantic acoustic guitar performance for a private dinner setup.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf8Ewo8DGgjJ2y_DLBMkWgCc9lTCF4t_tfYQ&s',
      features: ['1 Hour', 'Custom Playlist', 'Background Music'],
    ),
    StaticItem(
      id: 'amuz_002',
      name: 'Solo Violinist',
      description: 'Beautiful, emotional violin melodies during the ring or cake ceremony.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkwZjOjaP2uBVIYVrYHOpHJ0I_0S3kYWvW6w&s',
      features: ['1.5 Hours', 'Classical Hits', 'Grand Entry'],
    ),
    StaticItem(
      id: 'amuz_003',
      name: 'Live Jazz/Sufi Band',
      description: 'A complete 5-piece band playing romantic classics for your guests.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuGxsEKNPZt8FFGKmdKsCV1QXZgbvAFz4GTw&s',
      features: ['2 Hours', 'Full Setup', 'Sufi & Retro'],
    ),
    StaticItem(
      id: 'amuz_004',
      name: 'Private Party DJ',
      description: 'Professional DJ with a customized dance floor for a grand anniversary party.',
      price: 18000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkvlaQnGva9m5XqFkZVabwh0HlR724jCCp4w&s',
      features: ['4 Hours', 'LED Setup', 'Party Mix'],
    ),
    StaticItem(
      id: 'amuz_005',
      name: 'Live Romantic Singer',
      description: 'A dedicated vocalist singing your favorite love songs to your partner.',
      price: 20000,
      image: 'https://miro.medium.com/v2/resize:fit:1400/0*hotL0AElvkgbgAZf',
      features: ['2 Hours', 'Couple Dedication', 'Sound Sys. incl.'],
    ),
    StaticItem(
      id: 'amuz_006',
      name: 'Smooth Saxophone',
      description: 'Classy and smooth saxophone tunes perfect for an evening gala.',
      price: 16000,
      image: 'https://i.ytimg.com/vi/Jwxu7Ie5UF8/maxresdefault.jpg',
      features: ['Instrumental', 'Classy Vibe', '1.5 Hours'],
    ),
    StaticItem(
      id: 'amuz_007',
      name: 'Karaoke Night Setup',
      description: 'Complete karaoke system with a massive screen and 2 mics for family fun.',
      price: 12000,
      image: 'https://m.media-amazon.com/images/I/7193NDP-zCL._AC_UF1000,1000_QL80_.jpg',
      features: ['Interactive', 'All Languages', 'Tech Support'],
    ),
    StaticItem(
      id: 'amuz_008',
      name: 'String Quartet',
      description: 'A 4-piece string ensemble for an ultra-luxury, high-end anniversary dinner.',
      price: 45000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtFy0PsDzZrE2qfKJCOC40T8V6wyBYgQVc3A&s',
      features: ['Cello & Violin', 'Bridgerton Vibe', '2 Hours'],
    ),
    StaticItem(
      id: 'amuz_009',
      name: 'Piano Player',
      description: 'Elegant piano melodies providing the perfect backdrop for conversation.',
      price: 22000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsp0p74Z82vtHzUqao1j-vlgGNc6yC1dOKTw&s', // Reusing elegant instrument image
      features: ['Grand Piano', 'Lounge Music', 'Classy'],
    ),
    StaticItem(
      id: 'amuz_010',
      name: 'Celebrity Guest Artist',
      description: 'Make it a night to remember with a famous playback singer performing live.',
      price: 150000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ04Jf_DiRmuEeMNfvBbYQpO9EpfXk8qKphA&s',
      features: ['Live Concert', 'Meet & Greet', '1 Hour Set'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Music & Entertainment',
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
                                  sectionId: AnniversaryMusicScreen.sectionId,
                                  sectionName: AnniversaryMusicScreen.sectionName,
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