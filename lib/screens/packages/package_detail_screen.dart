import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/cart_provider.dart';
import '../../models/service_model.dart';
import '../../widgets/loading_indicator.dart';

class PackageDetailScreen extends StatefulWidget {
  final String packageId;

  const PackageDetailScreen({
    super.key,
    required this.packageId,
  });

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  dynamic _package; 
  bool _isLoading = true;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  Future<void> _loadPackage() async {
    // Note: In a real app, you'd fetch this from a Service or Firestore
    // For this example, we assume _package is loaded or passed.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showConflictDialog(CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Category Conflict"),
        content: Text(
          "Your cart already has items for a ${cart.selectedEventTypeName?.toUpperCase() ?? 'different event'}. "
          "You can only book one type of event at a time. Clear cart to switch?",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              _addPackageToCart(cart);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear & Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addPackageToCart(CartProvider cart) {
    final parentId = _package.categoryId ?? 'custom';
    final serviceWrap = ServiceModel(
      id: _package.id,
      categoryId: parentId,
      subCategoryId: _package.subCategoryId ?? 'pkg',
      name: _package.name,
      description: _package.description,
      basePrice: _package.price,
      priceUnit: 'package',
      image: _package.images.first,
      emoji: '📦',
      tags: [],
      options: [],
    );

    // ✅ Updated to use eventTypeName instead of subName
    bool success = cart.addItem(
      serviceWrap, 
      parentCategoryId: parentId,
      option: null, 
      qty: 1, 
      eventTypeName: "Package",
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Package added!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: LoadingIndicator()));
    if (_package == null) return const Scaffold(body: Center(child: Text('Package not found')));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildFeatures(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: IconButton(
        icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black)),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          controller: _pageController,
          itemCount: _package.images.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (context, index) => CachedNetworkImage(
            imageUrl: _package.images[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(_package.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        Text('₹${_package.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(_package.description, style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6));
  }

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What\'s Included', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._package.features.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Text(f, style: const TextStyle(fontSize: 15)),
          ]),
        )).toList(),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            final bool isSelected = cart.items.any((item) => item.id == _package.id);
            final String parentId = _package.categoryId ?? 'custom';
            final bool isAllowed = cart.canAddService(parentId);

            return isSelected
                ? Row(
              children: [
                const Expanded(child: Text("Package Selected ✅", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  onPressed: () => cart.removeItem(_package.id),
                  child: const Text("Remove", style: TextStyle(color: Colors.white)),
                )
              ],
            )
                : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isAllowed ? AppColors.primary : Colors.grey),
                onPressed: () {
                  if (!isAllowed) {
                    _showConflictDialog(cart);
                  } else {
                    _addPackageToCart(cart);
                  }
                },
                child: Text(isAllowed ? 'Add This Package' : 'Locked (Wrong Category)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
      ),
    );
  }
}