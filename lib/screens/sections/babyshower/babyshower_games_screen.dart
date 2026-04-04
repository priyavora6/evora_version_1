
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class BabyShowerGamesScreen extends StatelessWidget {
  const BabyShowerGamesScreen({super.key});

  static const String sectionId = 'bs_games';
  static const String sectionName = 'Games & Activities';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM BABY SHOWER GAMES & ACTIVITIES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> gameItems = [
    StaticItem(
      id: 'bsg_001',
      name: 'Professional Game Host',
      description: 'Energetic anchor to conduct 10+ interactive baby shower games for all guests.',
      price: 8000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrebVn9BqbV0kTeQkH6YKCK7lH1YnOpOZW7Q&s',
      features: ['2 Hours', 'Mic Included', 'High Energy'],
    ),
    StaticItem(
      id: 'bsg_002',
      name: 'Baby Bingo Set',
      description: 'Custom designed Bingo cards matching your theme. A fun sit-down game.',
      price: 2500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShX3_ItjfnCpztqlljbVgXGk1g3YcvexoP6w&s', // Cards/Games placeholder
      features: ['50 Cards', 'Custom Theme', 'Pens Included'],
    ),
    StaticItem(
      id: 'bsg_003',
      name: 'Blindfold Diaper Challenge',
      description: 'Hilarious activity for the dad-to-be and guests using plush dolls and blindfolds.',
      price: 3000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCtoNY1pBOzph0yCIEzbxEJuUAEWhZDkaP2w&s',
      features: ['Plush Dolls', 'Diapers incl.', 'Blindfolds'],
    ),
    StaticItem(
      id: 'bsg_004',
      name: 'Mom & Dad Trivia Quiz',
      description: 'Customized quiz about the couple’s childhood to see who knows them best.',
      price: 2000,
      image: 'https://m.media-amazon.com/images/I/7150HGy8TEL.jpg',
      features: ['Printed Sheets', 'Custom Q&A', 'Pencils incl.'],
    ),
    StaticItem(
      id: 'bsg_005',
      name: 'Baby Food Tasting Contest',
      description: 'Guests taste blindfolded and guess the baby food flavors. Super fun!',
      price: 3500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS56W66QxT7wb5w-_jlWbOPp6qWJgWUhMZWNg&s',
      features: ['10 Flavors', 'Safe Setup', 'Spoons incl.'],
    ),
    StaticItem(
      id: 'bsg_006',
      name: 'Onesie Painting Station',
      description: 'Creative corner where guests paint custom onesies for the upcoming baby.',
      price: 6500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBaiP21TIZWaXZy-YZ7zSjsFLqmPk8yFn50w&s', // Art/Painting
      features: ['15 White Onesies', 'Fabric Paint', 'Stencils'],
    ),
    StaticItem(
      id: 'bsg_007',
      name: 'Advice & Wishes Tree',
      description: 'A beautiful wooden tree where guests hang their advice cards for the parents.',
      price: 4500,
      image: 'https://m.media-amazon.com/images/I/71dkoDd7+9L._AC_UF894,1000_QL80_.jpg',
      features: ['Wooden Tree', '50 Cards', 'Keepsake'],
    ),
    StaticItem(
      id: 'bsg_008',
      name: 'Don\'t Say "Baby" Game',
      description: 'Clothespin necklace game. Whoever says "Baby" loses their pin!',
      price: 1500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfCwhUaYbuxPqmgTEjGvLfWndb_TJKfeS8zA&s',
      features: ['Custom Pins', 'Instruction Board', 'Ice Breaker'],
    ),
    StaticItem(
      id: 'bsg_009',
      name: 'Prize Hamper Bundle',
      description: 'A set of 5 beautifully wrapped premium gifts to give to the game winners.',
      price: 5000,
      image: 'https://5.imimg.com/data5/SELLER/Default/2022/6/FE/CS/KD/25530434/baby-shower-hamper.jpg',
      features: ['5 Hampers', 'Bath & Body', 'Chocolates'],
    ),
    StaticItem(
      id: 'bsg_010',
      name: 'The Ultimate Games Package',
      description: 'Includes a Host, Sound System, 5 Games, Props, and 5 Winner Prizes.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHqDhtY_cSdpi6D5zYiWLSAo804Cogt77CxA&s',
      features: ['All-in-One', 'Host + Sound', 'Prizes incl.'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Games & Activities',
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
              itemCount: gameItems.length,
              itemBuilder: (context, index) => _GameCard(item: gameItems[index]),
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

class _GameCard extends StatelessWidget {
  final StaticItem item;
  const _GameCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.extension, color: Colors.indigo)),
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
                                  sectionId: BabyShowerGamesScreen.sectionId,
                                  sectionName: BabyShowerGamesScreen.sectionName,
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