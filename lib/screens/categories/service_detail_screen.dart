import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

// ✅ Import our custom ServiceModel (which includes OptionModel)
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service; // ✅ Changed EventService to ServiceModel

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  OptionModel? _selectedOption; // ✅ Changed ServiceOption to OptionModel
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-select the first option if available
    if (widget.service.options.isNotEmpty) {
      _selectedOption = widget.service.options.first;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  double get _finalPrice {
    final base = widget.service.basePrice + (_selectedOption?.extraPrice ?? 0);
    return base * _quantity;
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // ✅ 1. Check for Category Conflict
    if (!cartProvider.isEmpty && cartProvider.selectedParentCategoryId != widget.service.categoryId) {
      _showCategoryConflictDialog(cartProvider);
      return;
    }

    // 2. Add item if no conflict
    _processAddToCart(cartProvider);
  }

  // Helper to actually perform the add
  void _processAddToCart(CartProvider cartProvider) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    
    // Find parent category name (e.g., Wedding, Birthday)
    String parentCategoryName = "Selected Category";
    try {
      parentCategoryName = categoryProvider.categories
          .firstWhere((c) => c.id == widget.service.categoryId)
          .name;
    } catch (_) {}

    // ✅ Updated to use eventTypeName instead of subName
    cartProvider.addItem(
      widget.service, 
      parentCategoryId: widget.service.categoryId,
      option: _selectedOption, 
      qty: _quantity, 
      eventTypeName: parentCategoryName,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Cart!'), backgroundColor: Colors.green),
    );

    Navigator.pushNamed(context, AppRoutes.cart);
  }

  // ✅ 3. The "Clear Cart?" Alert Dialog
  void _showCategoryConflictDialog(CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart?"),
        content: Text(
          "Your cart already contains items for the '${cartProvider.selectedEventTypeName}' category. "
          "Would you like to clear your cart to start a new booking?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              cartProvider.clearCart(); // Clear old category items
              Navigator.pop(context);
              _processAddToCart(cartProvider); // Add the new item
            },
            child: const Text("Clear & Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow(),
                      const SizedBox(height: 20),
                      _buildDescription(),
                      const SizedBox(height: 24),
                      if (widget.service.options.isNotEmpty) ...[
                        _buildOptionsSection(),
                        const SizedBox(height: 24),
                      ],
                      _buildQuantityRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.service.name, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ Handle Image properly (Asset or Network)
            widget.service.image.isNotEmpty
                ? (widget.service.image.startsWith('http')
                ? Image.network(widget.service.image, fit: BoxFit.cover)
                : Image.asset(widget.service.image, fit: BoxFit.cover))
                : Container(color: AppColors.primary, child: const Icon(Icons.image, color: Colors.white, size: 50)),

            // Dark gradient overlay to make text readable
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Starting from', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text('₹${widget.service.basePrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(widget.service.priceUnit, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ]),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: const [
            Icon(Icons.verified_outlined, color: Colors.green, size: 16),
            SizedBox(width: 6),
            Text('Verified', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About this Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(widget.service.description, style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Package', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...widget.service.options.map((option) {
          final isSelected = _selectedOption?.id == option.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedOption = option),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.primary : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isSelected ? AppColors.primary : Colors.black)),
                        const SizedBox(height: 4),
                        Text(option.description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  if (option.extraPrice > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('+ ₹${option.extraPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Included', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.remove, color: AppColors.primary), onPressed: () => setState(() { if (_quantity > 1) _quantity--; })),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              IconButton(icon: Icon(Icons.add, color: AppColors.primary), onPressed: () => setState(() => _quantity++)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBottomCTA() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total Amount', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text('₹${_finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _addToCart,
              child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}