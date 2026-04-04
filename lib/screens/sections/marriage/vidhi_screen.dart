import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_strings.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class VidhiScreen extends StatefulWidget {
  const VidhiScreen({super.key});

  @override
  State<VidhiScreen> createState() => _VidhiScreenState();
}

class _VidhiScreenState extends State<VidhiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const String sectionId = 'm_vidhi';
  static const String sectionName = 'Vidhi';

  static const List<_VidhiItem> _allVidhiItems = [
    _VidhiItem(
      id: 'v_001',
      name: 'Ganesh Sthapana',
      description: 'The inaugural ritual to remove obstacles. Includes idol, pandit, and complete puja setup.',
      price: 5500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQi7ZZTWw6DJKmyemnqvvuZLhzrTwWxP_sumg&s',
      features: ['Idol Included', 'Pandit Fees', 'Prasad'],
      isPopular: true,
    ),
    _VidhiItem(
      id: 'v_002',
      name: 'Mandap Mahurat',
      description: 'Spiritual foundation ceremony for the wedding mandap with traditional prayers.',
      price: 7000,
      image: 'https://cdn11.bigcommerce.com/s-9bdyx9g8xs/images/stencil/1280x1280/products/335/959/gujarati-marriage-wedding-ritual-kit-wedding-mandap-muhurat-haldi__34529.1655914976.jpg?c=2',
      features: ['Toran Decor', 'Ritual Items', '1 Hour'],
    ),
    _VidhiItem(
      id: 'v_003',
      name: 'Grah Shanti Ritual',
      description: 'Peace invocation for the nine planets. Detailed Vedic chanting for a happy married life.',
      price: 11000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV2WXC8PVzmnJgS3X5yr4u-y6rYTOZSc75yA&s',
      features: ['9 Planet Puja', 'Havan Kund', 'Senior Pandit'],
      isPopular: true,
    ),
    _VidhiItem(
      id: 'v_004',
      name: 'Pithi / Haldi Ceremony',
      description: 'Traditional turmeric paste application. Includes background decor and fresh haldi mix.',
      price: 15000,
      image: 'https://media.istockphoto.com/id/2127645644/photo/family-and-friends-dance-with-bride-and-groom-during-their-haldi-ceremony.jpg?s=612x612&w=0&k=20&c=7ZCQpSXs-CB2LDU_0mkoafoDWUvrJS7DKcXYIPEgiUE=',
      features: ['Yellow Theme', 'Organic Haldi', 'Music'],
    ),
    _VidhiItem(
      id: 'v_005',
      name: 'Lagana Patrika',
      description: 'The formal invitation to the groom’s family. Traditional scroll reading and gifting ritual.',
      price: 4500,
      image: 'https://m.media-amazon.com/images/I/71p+yRvomDL.jpg_BO30,255,255,255_UF750,750_SR1910,1000,0,C_QL100_.jpg',
      features: ['Handwritten Scroll', 'Sweets', 'Thali'],
    ),
    _VidhiItem(
      id: 'v_006',
      name: 'Kanya Daan Ceremony',
      description: 'The emotional giving away of the bride. Includes ritual vessel (Kalash) and spiritual setup.',
      price: 8500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxKgBO0Cl_HfX1X4j8Uj2yundPqqFtLbw01A&s',
      features: ['Copper Kalash', 'Milk & Honey', 'Traditional'],
    ),
    _VidhiItem(
      id: 'v_007',
      name: 'Hast Melap',
      description: 'The knot-tying ceremony symbolizing eternal union. High-quality silk dupatta used.',
      price: 3500,
      image: 'https://thumbs.dreamstime.com/b/hastmelap-indian-wedding-stock-image-276197161.jpg',
      features: ['Silk Scarf', 'Floral Knot', 'Chanting'],
      isPopular: true,
    ),
    _VidhiItem(
      id: 'v_008',
      name: 'Saptapadi (7 Vows)',
      description: 'The seven steps around the holy fire. Includes fire kund maintenance and floral pathway.',
      price: 12500,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzhou2hrIOEscCQb8tn4ksFx7wgqx3Y6HTNQ&s',
      features: ['Fire Attendant', 'Rose Petal Path', 'Vows'],
    ),
    _VidhiItem(
      id: 'v_009',
      name: 'Vidaai Farewell',
      description: 'The emotional farewell. Includes traditional doli or decorated car setup for the bride.',
      price: 18000,
      image: 'https://cdn0.weddingwire.in/article/1896/original/1280/jpg/76981-vidaai-ceremony-mva-cover.jpeg',
      features: ['Doli / Car Decor', 'Ritual Set', 'Audio'],
    ),
    _VidhiItem(
      id: 'v_010',
      name: 'Satyanarayan Puja',
      description: 'Post-wedding blessing for the new home. Complete puja for family prosperity.',
      price: 9000,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWAczp04JxBrDv5GtiMiUv7B4wRT8RI52W4Q&s',
      features: ['Prasad for 50', 'Full Puja Kit', 'Morning'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Rituals & Vidhi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [_buildCartBadge()],
      ),
      body: Column(
        children: [
          _buildSubHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemsList(_allVidhiItems),
                _buildItemsList(_allVidhiItems.where((i) => i.isPopular).toList()),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCartBadge() {
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

  Widget _buildSubHeader() {
    return Container(
      color: const Color(0xFF1A237E),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.amber,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        tabs: const [Tab(text: 'All Rituals'), Tab(text: 'Popular')],
      ),
    );
  }

  Widget _buildItemsList(List<_VidhiItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) => _VidhiItemCard(item: items[index]),
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final total = cart.getSectionTotal(sectionId);
        if (total <= 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]),
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

class _VidhiItemCard extends StatelessWidget {
  final _VidhiItem item;
  const _VidhiItemCard({required this.item});

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
          // 🖼️ PORTRAIT IMAGE (Same as Makeup)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 130, // Fixed Width
              height: 190, // Taller Height for Rituals
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 130, height: 190, color: Colors.indigo.shade50),
            ),
          ),

          // 📝 CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
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
                                  sectionId: 'm_vidhi',
                                  sectionName: 'Vidhi',
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

class _VidhiItem {
  final String id, name, description, image, category;
  final double price;
  final List<String> features;
  final bool isPopular;
  const _VidhiItem({required this.id, required this.name, required this.description, required this.price, required this.image, this.category = 'Vidhi', required this.features, this.isPopular = false});
}