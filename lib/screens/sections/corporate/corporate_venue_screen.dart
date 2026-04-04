import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/static_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CorporateVenueScreen extends StatelessWidget {
  const CorporateVenueScreen({super.key});

  static const String sectionId = 'c_venue';
  static const String sectionName = 'Venue';

  // ═══════════════════════════════════════════════════════════════════════
  // 10 PREMIUM CORPORATE VENUES
  // ═══════════════════════════════════════════════════════════════════════
  static const List<StaticItem> venueItems = [
    StaticItem(
      id: 'cven_001',
      name: 'Executive Boardroom',
      description: 'Premium boardroom setup for high-level meetings and investor pitches.',
      price: 15000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs_2YutGPHwxiazLVn9w5XJDz03Ut4raqLcA&s',
      features: ['20 Pax Capacity', 'Smart Screen', 'Luxury Seating'],
    ),
    StaticItem(
      id: 'cven_002',
      name: 'Mid-Sized Conference Hall',
      description: 'Fully equipped hall perfect for department townhalls and training sessions.',
      price: 35000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4sm6VlLATEj-hLWL8BWsdIYJvJryBxw7gPA&s',
      features: ['100 Pax', 'Projector Setup', 'Stage Podium'],
    ),
    StaticItem(
      id: 'cven_003',
      name: 'Grand Auditorium',
      description: 'Massive tiered seating auditorium for product launches and annual days.',
      price: 85000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlrU9YMbUU1cdMBoucTDRSMDVTW7_92nxPwA&s', // Auditorium vibe
      features: ['500+ Pax', 'Theater Style', 'Backstage Area'],
    ),
    StaticItem(
      id: 'cven_004',
      name: 'Rooftop Corporate Lounge',
      description: 'Modern open-air venue ideal for corporate networking and evening parties.',
      price: 45000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSt6N7xrdyAcGotYB-tLA3Gf3ID3QP-GtPsnA&s', // Outdoor/Lounge
      features: ['150 Pax', 'City Skyline View', 'Bar Setup'],
    ),
    StaticItem(
      id: 'cven_005',
      name: 'Creative Co-Working Space',
      description: 'Trendy, flexible breakout zones for brainstorming and team-building.',
      price: 20000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLBLATxar1SpOAcC7tuWhiQ0UX8vuk0j_hrA&s',
      features: ['50 Pax', 'Whiteboards', 'Casual Seating'],
    ),
    StaticItem(
      id: 'cven_006',
      name: '5-Star Banquet Hall',
      description: 'Luxurious hotel banquet space with premium carpet and chandeliers.',
      price: 120000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOTZxb556XUl1cOu-PN_T0j3MhVv5vQLIQvQ&s',
      features: ['300 Pax', 'Valet Parking', 'Luxury Dining'],
    ),
    StaticItem(
      id: 'cven_007',
      name: 'Outdoor Retreat Lawn',
      description: 'Spacious green lawns for sports days and massive company retreats.',
      price: 60000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfNtjSXKEWm6AyMWTcbBrCp71DA_BILrFE_Q&s',
      features: ['1000+ Pax', 'Open Space', 'Catering Tents'],
    ),
    StaticItem(
      id: 'cven_008',
      name: 'Industrial Warehouse Studio',
      description: 'Raw, aesthetic industrial space for fashion or modern product launches.',
      price: 40000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTk3bJOaItWOYJkPQUf4AZXdJIDH3M6Na-_7w&s',
      features: ['200 Pax', 'High Ceilings', 'Custom Lighting'],
    ),
    StaticItem(
      id: 'cven_009',
      name: 'Private Dining Room (PDR)',
      description: 'Exclusive enclosed restaurant space for intimate C-level executive dinners.',
      price: 18000,
      image: 'https://restaurantindia.s3.ap-south-1.amazonaws.com/s3fs-public/2022-02/Dine-at-Dome-1-%28European-Themed%29%2C-Level-19%2C-Shangri-La-Bengaluru.jpg',
      features: ['15 Pax', 'Dedicated Butler', 'Gourmet Menu'],
    ),
    StaticItem(
      id: 'cven_010',
      name: 'Tech Seminar Center',
      description: 'Dedicated tech hub with high-speed fiber internet and multiple breakout rooms.',
      price: 55000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk5aw5i9Lt2qmTA4ktXKrquw8eWkhKaFKkWg&s',
      features: ['250 Pax', 'Fiber Internet', '3 Breakout Rooms'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Gray background
      appBar: AppBar(
        title: const Text('Corporate Venues',
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
              itemCount: venueItems.length,
              itemBuilder: (context, index) => _VenueCard(item: venueItems[index]),
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

class _VenueCard extends StatelessWidget {
  final StaticItem item;
  const _VenueCard({required this.item});

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
              errorBuilder: (c, e, s) => Container(width: 125, height: 180, color: Colors.indigo.shade50, child: const Icon(Icons.business, color: Colors.indigo)),
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
                                  sectionId: CorporateVenueScreen.sectionId,
                                  sectionName: CorporateVenueScreen.sectionName,
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