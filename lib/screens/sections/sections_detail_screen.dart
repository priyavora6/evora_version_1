import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../providers/section_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item_model.dart';
import '../../widgets/loading_indicator.dart';

class SectionDetailScreen extends StatefulWidget {
  final String sectionId;
  final String sectionName;

  const SectionDetailScreen({
    super.key,
    required this.sectionId,
    required this.sectionName,
  });

  @override
  State<SectionDetailScreen> createState() => _SectionDetailScreenState();
}

class _SectionDetailScreenState extends State<SectionDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SectionProvider>(context, listen: false).fetchSectionItems(widget.sectionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.sectionName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [_buildCartBadge()],
      ),
      body: Consumer<SectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: LoadingIndicator());
          if (provider.error != null) return _buildErrorState();
          if (provider.sectionItems.isEmpty) return _buildEmptyState();

          return Column(
            children: [
              _buildInfoBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.sectionItems.length,
                  itemBuilder: (context, index) => _ItemCard(
                    item: provider.sectionItems[index],
                    sectionId: widget.sectionId,
                    sectionName: widget.sectionName,
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          );
        },
      ),
    );
  }

  // ─── APP BAR CART BADGE ──────────────────────────────────────────
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
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 26),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
              if (count > 0)
                Positioned(
                  right: 6, top: 6,
                  child: CircleAvatar(radius: 9, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                )
            ],
          ),
        );
      },
    );
  }

  // ─── SUB HEADER ──────────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: const Text(
        "Mix and match services to build your perfect package.",
        style: TextStyle(color: Colors.white70, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ─── BOTTOM TOTAL BAR ────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final sectionItems = cart.getItemsBySection(widget.sectionId);
        if (sectionItems.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${sectionItems.length} selected in ${widget.sectionName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${AppStrings.rupee}${cart.getSectionTotal(widget.sectionId).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildErrorState() => const Center(child: Text("Error loading items"));
  Widget _buildEmptyState() => const Center(child: Text("No items found in this section"));
}

// ─── PROFESSIONAL ITEM CARD ────────────────────────────────────────
class _ItemCard extends StatelessWidget {
  final dynamic item;
  final String sectionId, sectionName;

  const _ItemCard({required this.item, required this.sectionId, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // 🖼️ IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.image,
              width: 90, height: 90, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.indigo.shade50, child: const Icon(Icons.image, color: Colors.indigo)),
            ),
          ),
          const SizedBox(width: 16),
          // 📝 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E3E5C))),
                const SizedBox(height: 4),
                Text('${AppStrings.rupee}${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.green)),
              ],
            ),
          ),
          // ✅ ADD BUTTON / TICK LOGIC
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isInCart(item.id);

              return isInCart
                  ? InkWell(
                onTap: () => cartProvider.removeItem(item.id),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                    const SizedBox(height: 4),
                    Text("Remove", style: TextStyle(color: Colors.red.shade300, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
                  : ElevatedButton(
                onPressed: () {
                  final cartItem = CartItem(
                    id: item.id,
                    sectionId: sectionId,
                    sectionName: sectionName,
                    itemName: item.name,
                    price: item.price,
                    quantity: 1,
                    image: item.image,
                    type: 'item',
                  );
                  cartProvider.addItem(cartItem);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A237E),
                  side: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          ),
        ],
      ),
    );
  }
}