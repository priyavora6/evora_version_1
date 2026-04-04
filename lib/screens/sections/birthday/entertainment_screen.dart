import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class EntertainmentScreen extends StatelessWidget {
  const EntertainmentScreen({super.key});

  static const String sectionId = 'birthday_entertainment';
  static const String sectionName = 'Entertainment';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM ENTERTAINMENT SERVICES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> entertainmentItems = [
    StaticItem(
      id: 'ent_001',
      name: 'Professional Magician',
      description: 'Interactive 45-minute stage show with mind-blowing tricks for kids and adults.',
      price: 12000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSosQ5FBTdJTtWacRDQKVjm9VAz3-VbBuQfMQ&s',
      features: ['45 min Show', 'Interactive', 'Props incl.'],
    ),
    StaticItem(
      id: 'ent_002',
      name: 'Funny Clown / Joker',
      description: 'Entertaining clown with balloon twisting, magic tricks, and fun games.',
      price: 6000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDvOEKV_Sl_Uj8kYXhxKYvxgFWDuTerIRuUA&s',
      features: ['2 Hours', 'Balloon Art', 'Games Hosting'],
    ),
    StaticItem(
      id: 'ent_003',
      name: 'Professional Game Host',
      description: 'Energetic anchor to host party games, music dance, and cake cutting.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEJGNQ3-dr94gfAl0MaaNn9oxBA3ylFrZuEw&s',
      features: ['Energy Booster', 'Game Props', '3 Hours'],
    ),
    StaticItem(
      id: 'ent_004',
      name: 'Creative Tattoo Artist',
      description: 'Safe, temporary skin-friendly tattoos with 100+ design choices.',
      price: 4000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJwIp8UA7ZDasPuGFAuE1AWXD27sm2N8s0HQ&s',
      features: ['Organic Colors', '50+ Kids Designs', '2 Hours'],
    ),
    StaticItem(
      id: 'ent_005',
      name: 'DJ for Kids Party',
      description: 'High-energy DJ with lights, smoke machine, and the latest dance hits.',
      price: 10000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXh8scSF9BXJcsqm6pNMSeR5HjZVUg0tt0mA&s',
      features: ['Sound System', 'Disco Lights', 'Kids Playlist'],
    ),
    StaticItem(
      id: 'ent_006',
      name: 'Giant Bouncy Castle',
      description: 'Inflatable large jumping castle with safety nets and supervisor.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm51oNkoXMEmoWluhMyJUkG1LzBNK8zLk7ww&s',
      features: ['Safety Net', '4 Hours', 'Blower incl.'],
    ),
    StaticItem(
      id: 'ent_007',
      name: 'Puppet Story Show',
      description: 'Traditional puppet show telling educational and funny stories.',
      price: 7000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUPiBnfeLqQTGJKTke659bsO1reJs_FV5AFQ&s',
      features: ['30 min show', 'Fairy Tales', 'Portable Stage'],
    ),
    StaticItem(
      id: 'ent_008',
      name: 'Cartoon Mascot (Mickey)',
      description: 'Professional mascot character for photo sessions and dancing.',
      price: 5000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrpCMZWjB-ubeRQZEc-AmVnsiG894hSQh44w&s',
      features: ['Photo Op', 'Entry Dance', 'Cake Cutting'],
    ),
    StaticItem(
      id: 'ent_009',
      name: 'Face Painting Artist',
      description: 'Artistic face and hand painting using premium non-toxic colors.',
      price: 4500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOrTA4NjQjYRyXS9AeTDp3ubzpeHu4HLoWeQ&s',
      features: ['Cosmetic Grade', 'Speed Art', '2 Hours'],
    ),
    StaticItem(
      id: 'ent_010',
      name: 'Bubbles & Fog Show',
      description: 'Magic bubble show with giant bubbles and smoke rings.',
      price: 9000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7-LjYRtudE_VTb240jxu-CWZBZoeCnO8rJA&s',
      features: ['Giant Bubbles', 'Kids Activity', 'Visual Treat'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Entertainment',
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
              itemCount: entertainmentItems.length,
              itemBuilder: (context, index) => _EntertainmentCard(item: entertainmentItems[index]),
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

class _EntertainmentCard extends StatelessWidget {
  final StaticItem item;
  const _EntertainmentCard({required this.item});

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
          // 🖼️ PORTRAIT IMAGE (Same as Makeup/Vidhi)
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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.celebration, color: Colors.indigo)),
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
                                  sectionId: EntertainmentScreen.sectionId,
                                  sectionName: EntertainmentScreen.sectionName,
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