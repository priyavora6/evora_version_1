import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class PartyGamesScreen extends StatelessWidget {
  const PartyGamesScreen({super.key});

  static const String sectionId = 'p_games';
  static const String sectionName = 'Party Games';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 FUN PARTY GAMES & ACTIVITIES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> gameItems = [
    StaticItem(
      id: 'pgm_001',
      name: 'Interactive Karaoke Setup',
      description:
      'Sing your heart out with a complete karaoke system, lyrics screen, and 2 mics.',
      price: 10000,
      image:
      'https://lh6.googleusercontent.com/proxy/nDBjq1iqerJ0McpO_JCw2hWs3LUzBNi5wcqBLI96Ax_ncnUYQf_3MUDAbCl8EppY17HPJFkaL6Q6J_HvP3VmLpezHjM7RN72L-_JFH0jYuqo3qOKlQLMrzvYIKVtipAz_1c',
      features: ['Lyrics Screen', 'Song Library', '2 Mics'],
    ),
    StaticItem(
      id: 'pgm_002',
      name: 'Casino Royale Night',
      description:
      'Bring Vegas to your party with Blackjack, Roulette, and Poker tables (Fun money only).',
      price: 25000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShXDOoZrkWJZsp7t2xMXWSekBYIeAxiAougA&s',
      features: ['3 Tables', 'Professional Dealers', 'Fun Chips'],
    ),
    StaticItem(
      id: 'pgm_003',
      name: 'Retro Arcade Zone',
      description:
      'Nostalgic arcade machines featuring Pac-Man, Street Fighter, and racing games.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI9FJBZLgqRxL1T-FVB1QGTtStulEEHRm5Gg&s',
      features: ['2 Classic Machines', 'Free Play Mode', 'Attendant'],
    ),
    StaticItem(
      id: 'pgm_004',
      name: 'Pub Quiz Trivia Night',
      description:
      'Hosted trivia contest with buzzers, visuals, and fun categories for teams.',
      price: 8000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQW5scW0P03l8AWnPwNuv4sh1ZolXUDL4UIdA&s',
      features: ['Quiz Master', 'Buzzer System', 'Visual Rounds'],
    ),
    StaticItem(
      id: 'pgm_005',
      name: 'Beer Pong Championship',
      description:
      'Official beer pong tables with red cups and ping pong balls for a competitive vibe.',
      price: 5000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCOo1oZV5f4TdYOHq1AgoaEaDEeJToFxIJ3w&s', // Party vibe
      features: ['2 Tables', 'Cups & Balls', 'Referee incl.'],
    ),
    StaticItem(
      id: 'pgm_006',
      name: 'Mystery Scavenger Hunt',
      description:
      'An exciting treasure hunt across the venue with clues, puzzles, and hidden prizes.',
      price: 12000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToi7BeZjFCx8GT-CpMLLhwbs8TesmAIy56xw&s', // Clues/Mystery
      features: ['Custom Clues', 'Hidden Props', 'Winner Prize'],
    ),
    StaticItem(
      id: 'pgm_007',
      name: 'Spin The Wheel of Dares',
      description:
      'A giant colorful wheel with fun dares, shots, and truth questions for guests.',
      price: 6000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRru3u488e361neyvWKZE8ahri5Q4DfXd5kjQ&s', // Wheel
      features: ['Custom Dares', 'Giant Wheel', 'Host Managed'],
    ),
    StaticItem(
      id: 'pgm_008',
      name: 'Inflatable Sumo Wrestling',
      description:
      'Hilarious fun where guests wear giant padded sumo suits and wrestle in a ring.',
      price: 18000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkunj5pwxy79x1RiC8GW5XSAp6dbpl_13Rvg&s', // Fun/Active
      features: ['2 Sumo Suits', 'Padded Mat', 'Safety Gear'],
    ),
    StaticItem(
      id: 'pgm_009',
      name: 'Close-up Magic & Mentalism',
      description:
      'A roving magician performing mind-reading and card tricks among the crowd.',
      price: 15000,
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUDNvjc55Iis-lvXmj7wQK5T2HgldJ6OIY2g&s',
      features: ['Street Magic', 'Card Tricks', 'Interactive'],
    ),
    StaticItem(
      id: 'pgm_010',
      name: 'Just Dance Battle Zone',
      description:
      'Large screen setup with motion sensors for a virtual dance-off competition.',
      price: 10000,
      image:
      'Large screen setup with motion sensors for a virtual dance-off competition.', // Dance
      features: ['Large Screen', 'Motion Gaming', 'Sound System'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text(
          'Party Games',
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
              itemCount: gameItems.length,
              itemBuilder: (context, index) =>
                  _GameCard(item: gameItems[index]),
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
                child: const Icon(Icons.extension, color: Colors.indigo),
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
                                  sectionId: PartyGamesScreen.sectionId,
                                  sectionName:
                                  PartyGamesScreen.sectionName,
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
